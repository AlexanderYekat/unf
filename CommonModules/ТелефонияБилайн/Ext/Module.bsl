﻿////////////////////////////////////////////////////////////////////////////////
// Серверные процедуры для выполнения операций по обработке данных о звонках подключенной виртуальной АТС Билайн через HTTP сервис:
// - создание и обновление подписки на события ВАТС Билайн;
// - обработка данных о входящих звонках;
// - запуск исходящих звонков на базе API ВАТС Билайн;
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Настройка доступности методов в соответствии с выбранным оператором АТС.
//
// Параметры:
//  НастройкиИнтеграции - Структура - исходное значение структуры НастройкиИнтеграции.
//
Процедура ПриОпределенииНастроекИнтеграции(НастройкиИнтеграции) Экспорт
	
	НастройкиИнтеграции.ПоддерживаетсяНастройкаМаршрутизации = Ложь;
	НастройкиИнтеграции.Методы.ПриПолученииАдресаОбратногоВызова = Ложь;
	НастройкиИнтеграции.Методы.ПриОбработкеПолученияИнформацииОВызывающемАбоненте = Ложь;
	
	НастройкиИнтеграции.Проверки.Вставить("ПроверкаОбязательныхПолей", Истина);
	НастройкиИнтеграции.Проверки.Вставить("ПроверкаПолучениеПодпискиНаСобытияАТС", Истина);
	НастройкиИнтеграции.Проверки.Вставить("ПроверкаСлужебногоПользователя", Истина);
	НастройкиИнтеграции.Проверки.Вставить("ПроверкаПубликуемогоСервиса", Истина);
	НастройкиИнтеграции.Проверки.Вставить("ПроверкаПодключенияАТС", Истина);
	НастройкиИнтеграции.Проверки.Вставить("ПроверкаСистемыВзаимодействия", Истина);
	НастройкиИнтеграции.Проверки.Вставить("ПроверкаАбонентовАТС", Истина);
	
КонецПроцедуры

// Возвращает корневой адрес API АТС Билайн для получения данных по звонкам.
//
// Возвращаемое значение:
//  Строка - содержит корневой адрес API АТС Билайн.
//
Функция КорневойАдрес() Экспорт
	
	Возврат "https://cloudpbx.beeline.ru/";
	
КонецФункции

// Возвращает шаблон принимающего HTTP сервиса публикуемого на стороне 1С:УНФ для получения данных о звонках АТС Билайн.
//
// Возвращаемое значение:
//  Строка - содержит шаблон принимающего HTTP сервиса 1С:УНФ.
//
Функция ШаблонURLHTTPСервиса() Экспорт
	
	Возврат "beeline";
	
КонецФункции

// Возвращает статус настроек телефонии (ключа авторизации к API).
//
// Параметры:
//  НастройкиТелефонии - Структура - описание настроек (адрес, ключ авторизации) используемых для авторизации при использовании API АТС Билайн.
//
// Возвращаемое значение:
//  Булево - статус заполнения значения ключа авторизации.
//
Функция НастройкиИнтеграцииЗаполнены(АТС, НастройкиТелефонии) Экспорт
	
	Возврат ЗначениеЗаполнено(НастройкиТелефонии.КлючДляАвторизацииВАТСБилайн);
	
КонецФункции

// Выполняет загрузку списка абонентов ВАТС Билайн.
//
Процедура ПроверкаПодключения() Экспорт
	
	Если СтатусПроверкиНастроекПодключенияАТС() Тогда
		ОбновлениеПодпискиНаСобытияВАТС();
	КонецЕсли;
	
КонецПроцедуры

// Выполняет проверку данных о текущей подписке на события из ВАТС Билайн.
// В случае если время работы подписки на события истекло, выполняется запрос на получение новой подписки.
//
Процедура ПроверкаПодпискиНаСобытияАТС() Экспорт
	
	Если СтатусПроверкиНастроекПодключенияАТС() Тогда
		ОбновлениеПодпискиНаСобытияВАТС();
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает данные событий из ВАТС Билайн по входящим и исходящим звонкам.
// Каждый отдельный звонок представляет собой серию событий передаваемых из ВАТС Билайн путем вызова опубликованного сервиса 1С:УНФ для каждого события.
//
// Параметры:
//  СтрокаXML - тело запроса с XML описанием события по звонку.
//
Процедура ОбработкаЗапроса(СтрокаXML) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
		СтрокаXML = СтрЗаменить(СтрокаXML,"http://www.w3.org/2001/XMLSchema-instance","http://v8.1c.ru/messages");
		ОтветXML = СтрокаXMLВXDTO(СтрокаXML);
		
		Если ОтветXML.Свойства().Получить("eventData") <> Неопределено Тогда
			ТипСобытия = ОтветXML.eventData.type;
		КонецЕсли;
		
		// В случае отмены подписки на события о звонках, осуществляется вызов сервиса API Билайн для создания новой подписки на события.
		// Причинами отмены подписки могут быть: ошибка, истечение времени существования подписки, таймаут при ожидании ответа от принимающего события сервиса 1С:УНФ.
		Если ТипСобытия = "xsi:SubscriptionTerminatedEvent" Тогда // Подписка отменена
			
			ЗапросНовойПодпискиНаСобытия();
			
		ИначеЕсли ОтветXML.eventData.Свойства().Получить("call") <> Неопределено Тогда
			
			Если ТипСобытия = "xsi:CallReceivedEvent" ИЛИ ТипСобытия = "xsi:CallAnsweredEvent"
				ИЛИ ТипСобытия = "xsi:CallOriginatedEvent" ИЛИ ТипСобытия = "xsi:CallReleasedEvent" Тогда
				
				ДанныеЗвонкаXML = ОтветXML.eventData.call;
				ИдентификаторЗвонкаВАТС = ДанныеЗвонкаXML.extTrackingId;
				ИдентификаторПользователяВАТС = ОтветXML.targetId;
				
				ПользовательТелефонии = РегистрыСведений.НастройкиПользователейТелефонии.ПолучитьДанныеПользователя(ИдентификаторПользователяВАТС);
				ВнутреннийНомерСотрудника = ?(ПользовательТелефонии <> Неопределено, ПользовательТелефонии.ВнутреннийНомер, Неопределено);
				СотрудникОпределен = ?(ВнутреннийНомерСотрудника <> Неопределено, Истина, Ложь);
				
				// Переменная "ТекущийЗвонок" используется на случай если во время обмена данными между 1С:УНФ и АТС Билайн была отменена подписка на события телефонии.
				// В случае отмены подписки и последующего создания новой подписки на события, некоторые события по текущему звонку могут быть пропущены (т.к. поступали в момент создания новой подписки).
				// В связи с этим, при обработке каждого из событий ведется проверка на наличие данных в регистре ДанныеЗвонков о текущем звонке
				// с последующей дополнительной обработкой в случае необходимости.
				ТекущийЗвонок = РегистрыСведений.ДанныеЗвонков.ПолучитьДанныеЗвонкаПоИдентификатору(ИдентификаторЗвонкаВАТС);
				
				Направление = Неопределено;
				Если ДанныеЗвонкаXML.personality = "Terminator" Тогда
					Направление = Перечисления.ВходящееИсходящееСобытие.Входящее;
				ИначеЕсли ДанныеЗвонкаXML.personality = "Originator" Тогда
					Направление = Перечисления.ВходящееИсходящееСобытие.Исходящее;
				КонецЕсли;
				
				Если Направление = Перечисления.ВходящееИсходящееСобытие.Входящее И СотрудникОпределен Тогда
					
					Если ТипСобытия = "xsi:CallReceivedEvent" Тогда
						
						ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
						ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ИдентификаторЗвонкаВАТС;
						ДанныеЗвонка.ДатаНачалаЗвонка = ПолучитьДатаВремя(ДанныеЗвонкаXML.startTime);
						ЗаполнитьНомерКонтакта(ДанныеЗвонкаXML, ДанныеЗвонка);
						
						ТелефонияСервер.ОбработатьВходящийЗвонок(ДанныеЗвонка, Истина);
						
					ИначеЕсли ТипСобытия = "xsi:CallAnsweredEvent" Тогда
						
						ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
						ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ИдентификаторЗвонкаВАТС;
						ДанныеЗвонка.Пользователь.ВнутреннийНомер = ВнутреннийНомерСотрудника;
						ДанныеЗвонка.ДатаНачалаРазговора = ПолучитьДатаВремя(ДанныеЗвонкаXML.answerTime);
						
						Если ТекущийЗвонок = Неопределено Тогда
							ДанныеЗвонка.ДатаНачалаЗвонка = ПолучитьДатаВремя(ДанныеЗвонкаXML.startTime);
							ЗаполнитьНомерКонтакта(ДанныеЗвонкаXML, ДанныеЗвонка);
							
							ТелефонияСервер.ОбработатьВходящийЗвонок(ДанныеЗвонка, Истина);
						Иначе
							ТелефонияСервер.ОбработатьИзменениеЗвонка(ДанныеЗвонка);
						КонецЕсли;
						
					КонецЕсли;
					
				ИначеЕсли Направление = Перечисления.ВходящееИсходящееСобытие.Исходящее И СотрудникОпределен Тогда
					
					Если ТипСобытия = "xsi:CallOriginatedEvent" Тогда
						
						ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
						ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ИдентификаторЗвонкаВАТС;
						ДанныеЗвонка.Пользователь.ВнутреннийНомер = ВнутреннийНомерСотрудника;
						ДанныеЗвонка.ДатаНачалаЗвонка = ПолучитьДатаВремя(ДанныеЗвонкаXML.startTime);
						ЗаполнитьНомерКонтакта(ДанныеЗвонкаXML, ДанныеЗвонка);
						
						Если ТекущийЗвонок = Неопределено Тогда
							ТелефонияСервер.ОбработатьИсходящийЗвонок(ДанныеЗвонка);
						Иначе
							ТелефонияСервер.ОбработатьИзменениеЗвонка(ДанныеЗвонка);
						КонецЕсли;
						
					ИначеЕсли ТипСобытия = "xsi:CallAnsweredEvent" Тогда
						
						ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
						ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ИдентификаторЗвонкаВАТС;
						ДанныеЗвонка.Пользователь.ВнутреннийНомер = ВнутреннийНомерСотрудника;
						ДанныеЗвонка.ДатаНачалаРазговора = ПолучитьДатаВремя(ДанныеЗвонкаXML.answerTime);
						
						Если ТекущийЗвонок = Неопределено Тогда
							ДанныеЗвонка.ДатаНачалаЗвонка = ПолучитьДатаВремя(ДанныеЗвонкаXML.startTime);
							ТелефонияСервер.ОбработатьИсходящийЗвонок(ДанныеЗвонка);
						Иначе
							ТелефонияСервер.ОбработатьИзменениеЗвонка(ДанныеЗвонка);
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЕсли;
				
				Если (ТипСобытия = "xsi:CallReleasedEvent" И СотрудникОпределен)
					ИЛИ (ТипСобытия = "xsi:CallReleasedEvent" И Не СотрудникОпределен И ДанныеЗвонкаXML.Свойства().Получить("redirect") = Неопределено) Тогда
					
					ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
					ДанныеЗвонка.Направление = Направление;
					ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ИдентификаторЗвонкаВАТС;
					Если СотрудникОпределен Тогда
						ДанныеЗвонка.Пользователь.ВнутреннийНомер = ВнутреннийНомерСотрудника;
					КонецЕсли;
					
					Если ТекущийЗвонок = Неопределено Тогда
						ДанныеЗвонка.ДатаНачалаЗвонка = ПолучитьДатаВремя(ДанныеЗвонкаXML.startTime);
						ДанныеЗвонка.ДлительностьРазговора = ПолучитьДлительностьРазговора(ДанныеЗвонкаXML.startTime, ДанныеЗвонкаXML.releaseTime);
					Иначе
						ДанныеЗвонка.ДлительностьРазговора = ТекущийЗвонок.ДлительностьРазговора + ПолучитьДлительностьРазговора(ДанныеЗвонкаXML.startTime, ДанныеЗвонкаXML.releaseTime);
					КонецЕсли;
					
					Если ОтветXML.eventData.call.Свойства().Получить("answerTime") <> Неопределено Тогда
						ДанныеЗвонка.ДатаНачалаРазговора = ПолучитьДатаВремя(ДанныеЗвонкаXML.answerTime);
						ДанныеЗвонка.Неотвеченный = Ложь;
					Иначе
						ДанныеЗвонка.Неотвеченный = Истина;
					КонецЕсли;
					
					ДанныеЗвонка.ЗаписьРазговора.ТребуетсяЗапросить = ОтветXML.eventData.call.Свойства().Получить("recorded") <> Неопределено;
					
					Если ДанныеЗвонка.Направление = Перечисления.ВходящееИсходящееСобытие.Входящее Тогда
						
						ЗаполнитьНомерКонтакта(ДанныеЗвонкаXML, ДанныеЗвонка);
						
						Если ТекущийЗвонок = Неопределено Тогда
							ТелефонияСервер.ОбработатьВходящийЗвонок(ДанныеЗвонка, Истина);
						КонецЕсли;
						ТелефонияСервер.ОбработатьЗавершениеЗвонка(ДанныеЗвонка);
						
					Иначе
						
						Если ТекущийЗвонок = Неопределено Тогда
							
							Если ДанныеЗвонкаXML.Свойства().Получить("releaseCause") = Неопределено
								ИЛИ ДанныеЗвонкаXML.releaseCause.Свойства().Получить("internalReleaseCause") = Неопределено
								ИЛИ НЕ ДанныеЗвонкаXML.releaseCause.internalReleaseCause = "Busy" Тогда
								
								ТелефонияСервер.ОбработатьИсходящийЗвонок(ДанныеЗвонка);
							КонецЕсли;
							
						КонецЕсли;
						
						ТелефонияСервер.ОбработатьЗавершениеЗвонка(ДанныеЗвонка);
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Формирует запрос для API ВАТС Билайн для выполнения исходящего звонка с общего номера на номер контрагента.
//
// Параметры:
//  НомерКонтакта - Строка - номер телефона контрагента.
//  НастройкиТелефонии - Структура - описание настроек (адрес, ключ авторизации) используемых для авторизации при использовании API АТС Билайн.
//
// Возвращаемое значение:
//  Структура - данные запроса (адрес сервера, ресурса с указанием номера телефона контрагента) для выполнения исходящего звонка через API ВАТС Билайн.
//
Функция ЗапросИсходящегоВызова(НомерКонтакта, НастройкиТелефонии) Экспорт
	
	ПараметрыОтправки = ОтправкаЗапросов.НовыйПараметрыОтправки();
	ПараметрыОтправки.Сервер = КорневойАдрес();
	ПараметрыОтправки.АдресРесурса = СтрШаблон("integration/core/api/v2/abonents/%1/call?pattern=%1&phoneNumber=%2",
		НастройкиТелефонии.НастройкиТекущегоПользователя.ВнутреннийНомер, НомерКонтакта);
	ПараметрыОтправки.Заголовки.Вставить("X-MPBX-API-AUTH-TOKEN", НастройкиТелефонии.КлючДляАвторизацииВАТСБилайн);
	Возврат ПараметрыОтправки;
	
КонецФункции

// Возвращает структуру параметров отправки используемых для вызова сервиса.
//
// Параметры:
//  НастройкиТелефонии - Структура - значения настроек облачной телефонии.
//
// Возвращаемое значение:
//  Структура - параметры отправки используемых для вызова сервиса.
//
Функция ЗапросСпискаПользователей(НастройкиТелефонии) Экспорт
	
	ПараметрыОтправки = ОтправкаЗапросов.НовыйПараметрыОтправки("GET");
	ПараметрыОтправки.Сервер = КорневойАдрес();
	ПараметрыОтправки.АдресРесурса = "integration/core/api/abonents";
	ПараметрыОтправки.Заголовки.Вставить("X-MPBX-API-AUTH-TOKEN", НастройкиТелефонии.КлючДляАвторизацииВАТСБилайн);
	Возврат ПараметрыОтправки;
	
КонецФункции

// Выполняет проверку результата вызова сервиса получения списка абонентов АТС.
//
// Параметры:
//  HttpОтвет - Структура - данные ответа выполненного сервиса получения списка абонентов АТС.
//  НастройкиТелефонии - Структура - значения настроек облачной телефонии.
//  Результат - Структура - данные с результатами обработки ответа сервиса, включая список абонентов АТС
//
Процедура ОбработатьОтветЗапросаСпискаПользователей(HttpОтвет, НастройкиТелефонии, Результат) Экспорт
	
	ТелоОтвета = РаскодироватьСтроку(HTTPОтвет.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	Результат.КодСостояния = HTTPОтвет.КодСостояния;
	
	Если HTTPОтвет.КодСостояния <> 200 Тогда
		Результат.ЗаголовокОшибки = НСтр("ru='Ошибка при инициализации вызова.'");
		Результат.ТекстОшибки = ТелоОтвета;
	Иначе
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ТелоОтвета);
		ПараметрыОтвета = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
		
		СписокПользователей = Новый Массив;
		Если ТипЗнч(ПараметрыОтвета) = Тип("Массив") Тогда
			Для каждого Пользователь Из ПараметрыОтвета Цикл
				Если Пользователь.Свойство("userId")
					И Пользователь.Свойство("extension") Тогда
					
					ПользовательАТС = Новый Структура("ИмяПользователя, ВнутреннийНомер");
					ПользовательАТС.ИмяПользователя = Пользователь.userId;
					ПользовательАТС.ВнутреннийНомер = Пользователь.extension;
					СписокПользователей.Добавить(ПользовательАТС);
				КонецЕсли;
			
			КонецЦикла;
		КонецЕсли;
		
		Результат.СписокПользователей = СписокПользователей;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет структуру Результат информацией об ошибке (если обнаружена).
//
// Параметры:
//  HttpОтвет - Структура - данные о результатах http вызова api для исходящего вызова.
//  НастройкиТелефонии - Структура - данные по настройкам телефонии (ключ авторизации, данные о текущем пользователе).
//  Результат - Структура - данные по результатам обработки звонка.
//
Процедура ОбработатьОтветЗапросаИсходящегоВызова(HttpОтвет, НастройкиТелефонии, Результат) Экспорт
	
	Если HTTPОтвет.КодСостояния = 200 Тогда
		Возврат;
	КонецЕсли;
	
	Результат.ЗаголовокОшибки = РасшифровкаОшибки(HTTPОтвет.КодСостояния);
	Результат.ТекстОшибки = РаскодироватьСтроку(HTTPОтвет.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	
КонецПроцедуры

// Выполняет HTTP запрос через API АТС Билайн для получения данных по абонентам настроенным на стороне АТС.
//
// Параметры:
//  HTTPОтвет - Структура - параметры HTTP Ответа запроса.
//
// Возвращаемое значение:
//  Массив - список абонентов настроенных на стороне ВАТС Билайн.
//
Функция ЗагрузитьДанныеПоАбонентам(HTTPОтвет = Неопределено) Экспорт
	
	ИмяСобытия = НСтр("ru = 'Телефония.ЗагрузкаСпискаАбонентовВАТСБилайн'", ОбщегоНазначения.КодОсновногоЯзыка());
	УстановитьПривилегированныйРежим(Истина);
	
	НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	
	ПараметрыЗапроса = ОтправкаЗапросов.НовыйПараметрыОтправки("GET");
	ПараметрыЗапроса.Сервер = КорневойАдрес();
	ПараметрыЗапроса.АдресРесурса = "integration/core/api/abonents";
	ПараметрыЗапроса.Заголовки.Вставить("X-MPBX-API-AUTH-TOKEN", НастройкиТелефонии.КлючДляАвторизацииВАТСБилайн);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	HTTPОтвет = ОтправкаЗапросов.ОтправитьЗапрос(ПараметрыЗапроса);
	ПараметрыОтвета = ТелефонияСервер.ПрочитатьJSONВСтруктуру(HTTPОтвет.ПолучитьТелоКакСтроку());
	
	Если HTTPОтвет.КодСостояния = 200 Тогда
		Если ТипЗнч(ПараметрыОтвета) = Тип("Массив") И ПараметрыОтвета.Количество() > 0 Тогда
			
			СписокАбонентов = Новый СписокЗначений;
			
			Для каждого Абонент Из ПараметрыОтвета Цикл
				СписокАбонентов.Добавить(Абонент.userId, Абонент.extension);
			КонецЦикла;
			
			Возврат СписокАбонентов;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		ОписаниеОшибки = ПолучитьОписаниеОшибокHTTPВызова(НСтр("ru = 'Ошибка получения списка абонентов АТС.'"), HTTPОтвет);
		ЗарегистрироватьОшибку(ИмяСобытия, ОписаниеОшибки.КраткийТекстОшибки, ОписаниеОшибки.ПодробныйТекстОшибки);
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Обработчик регламентного задания ОбновлениеПодпискиНаСобытияВАТС
//
Процедура ЗаданиеОбновлениеПодпискиНаСобытияВАТС() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОбновлениеПодпискиНаСобытияВАТС);
	Если ТелефонияСервер.ИспользуетсяТелефония() Тогда
		ИспользуемаяАТС = Константы.ИспользуемаяАТС.Получить();
		Если ИспользуемаяАТС <> Неопределено
			И ИспользуемаяАТС = Перечисления.ДоступныеАТС.Билайн
			И СтатусПроверкиНастроекПодключенияАТС() Тогда
			ОбновлениеПодпискиНаСобытияВАТС();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает ссылку на запись разговора пользователя телефонии.
//
// Параметры:
//  ДанныеЗвонка - Структура - данные звонка (идентификатор звонка, ссылка на событие, направление, номер от кого, номер кому).
//
// Возвращаемое значение:
//  Строка - ссылка на запись разговора для скачивания.
//
Функция СсылкаНаЗаписьРазговора(ДанныеЗвонка, Ошибка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДанныеЗвонка.ЗаписьРазговора.Ссылка) Тогда
	
		ДанныеЗвонка.ЗаписьРазговора.Ссылка = НайтиЗаписьРазговораПоИдентификаторуЗвонка(ДанныеЗвонка);
		Если Не ЗначениеЗаполнено(ДанныеЗвонка.ЗаписьРазговора.Ссылка) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	ТелефонияСервер.ОбновитьДанныеЗвонкаВРегистре(ДанныеЗвонка);
	Возврат ДанныеЗвонка.ЗаписьРазговора.Ссылка;
	
КонецФункции

#Область ПроцедурыИФункцииДиагностикиПодключения

Процедура ПроверкаПолучениеПодпискиНаСобытияАТС(АдресПринимающегоСервиса, РезультатыВсехПроверок) Экспорт
	
	ТипГруппыПроверок = Перечисления.ТипыПроверокТелефонии.ПроверкаПолучениеПодпискиНаСобытияАТС;
	РезультатыТекущейГруппыПроверок = Новый Массив;
	
	// Выполнение группы проверок
	НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	СтатусПроверки = ТелефонияДиагностика.ПроверитьОбязательноеПоле(
		РезультатыТекущейГруппыПроверок,
		ТипГруппыПроверок,
		НСтр("ru='Токен для аутентификации'"),
		НастройкиТелефонии.КлючДляАвторизацииВАТСБилайн);
		
	//Если СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусПроверки.Успешно") Тогда
	ТелефонияДиагностика.ПроверкаАдресаПубликуемогоСервиса(АдресПринимающегоСервиса, РезультатыТекущейГруппыПроверок, ТипГруппыПроверок);
	//КонецЕсли;
	
	ОбщийСтатусГруппыПроверок = ТелефонияДиагностика.ПолучитьОбщийСтатусДляГруппыПроверок(РезультатыТекущейГруппыПроверок);
	
	Если ОбщийСтатусГруппыПроверок = ПредопределенноеЗначение("Перечисление.СтатусПроверкиТелефонии.Успешно") Тогда
		ПроверкаПолученияПодпискиНаСобытияОАТС(РезультатыТекущейГруппыПроверок, ТипГруппыПроверок, АдресПринимающегоСервиса);
	КонецЕсли;

	ОбщийСтатусГруппыПроверок = ТелефонияДиагностика.ПолучитьОбщийСтатусДляГруппыПроверок(РезультатыТекущейГруппыПроверок);
	
	// Добавление заголовка текущей группы проверок в общий список проверок.
	ТелефонияДиагностика.ДобавитьРезультатПроверкиВСписок(РезультатыВсехПроверок,
		ТипГруппыПроверок,
		ТипГруппыПроверок,
		"Группа",
		ОбщийСтатусГруппыПроверок,
		Строка(ТипГруппыПроверок));
		
	ТелефонияДиагностика.ДополнитьРезультатыПроверок(РезультатыВсехПроверок, РезультатыТекущейГруппыПроверок);
	
КонецПроцедуры

Функция ПроверкаПолейАвторизацииОАТС(ТипГруппыПроверок) Экспорт
	
	НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	
	РезультатыТекущейПроверки = Новый Массив;
	ТелефонияДиагностика.ПроверитьОбязательноеПоле(
		РезультатыТекущейПроверки,
		ТипГруппыПроверок,
		НСтр("ru='Токен для аутентификации'"),
		НастройкиТелефонии.КлючДляАвторизацииВАТСБилайн);
	
	Возврат РезультатыТекущейПроверки;
	
КонецФункции

Процедура ПроверкаПолученияПодпискиНаСобытияОАТС(РезультатыПроверок, ТипГруппыПроверок, АдресПринимающегоСервиса = Неопределено)
	
	ТипПроверки = Перечисления.ТипыПроверокТелефонии.ПроверкаПолучениеПодпискиНаСобытияАТС;
	СтатусПроверки = Перечисления.СтатусПроверкиТелефонии.Успешно;
	ЗаголовокСообщения = НСтр("ru='Подписка на события АТС получена'");
	ТекстСообщения = Неопределено;
	
	HTTPОтвет = Неопределено;
	ИдентификаторПодписки = ЗапросНовойПодпискиНаСобытия(HTTPОтвет, АдресПринимающегоСервиса);
	
	Если HTTPОтвет.КодСостояния <> 200 ИЛИ ИдентификаторПодписки = Неопределено Тогда
		ТекстОшибки = "";
		Если ИдентификаторПодписки = Неопределено Тогда
			ТекстОшибки = НСтр("ru='Тело ответа сервиса не заполнено'");
		Иначе
			ТекстОшибки = HTTPОтвет.ПолучитьТелоКакСтроку();
		КонецЕсли;
		СтатусПроверки = Перечисления.СтатусПроверкиТелефонии.Ошибка;
		ЗаголовокСообщения = НСтр("ru='Подписка на события АТС не доступна'");
		ТекстСообщения = СтрШаблон(НСтр("ru='Обнаружена ошибка вызова сервиса создания подписки на события:%1%2'"), Символы.ПС,
			ТекстОшибки);
		СпособыУстранения = СтрШаблон(НСтр("ru='1. Проверьте корректность заполнения поля ''Токен для аутентификации''
			|2. Выполните операцию ''Создать новую подписку АТС'' вручную.'"));
	КонецЕсли;
	
	ТелефонияДиагностика.ДобавитьРезультатПроверкиВСписок(
		РезультатыПроверок,
		ТипГруппыПроверок,
		ТипПроверки,
		"Элемент",
		СтатусПроверки,
		ЗаголовокСообщения,
		ТекстСообщения,
		СпособыУстранения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обновляет подписку на события о звонках АТС Билайн в случае если подписка была отменена (по причине ошибки или истек срок действия).
//
Процедура ОбновлениеПодпискиНаСобытияВАТС()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		ИмяСобытия = НСтр("ru = 'Телефония.ОбновлениеПодпискиНаСобытия'", ОбщегоНазначения.КодОсновногоЯзыка());
		АдресПринимающегоСервиса = ТелефонияСервер.АдресОбратногоВызоваОблачнаяТелефония(Перечисления.ДоступныеАТС.Билайн);
		СтатусПодпискиНаСобытияВАТС = Ложь;
		МенеджерЗаписи = РегистрыСведений.НастройкиПодпискиНаСобытияТелефонии.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ОператорАТС = Перечисления.ДоступныеАТС.Билайн;
		МенеджерЗаписи.Прочитать();
		Если МенеджерЗаписи.Выбран() Тогда
			Если МенеджерЗаписи.АдресПринимающегоСервиса = АдресПринимающегоСервиса Тогда
				СтатусПодпискиНаСобытияВАТС = СтатусПодпискиНаСобытияВАТС(МенеджерЗаписи.ИдентификаторПодписки);
			КонецЕсли;
		КонецЕсли;
		
		Если Не СтатусПодпискиНаСобытияВАТС Тогда
			ЗапросНовойПодпискиНаСобытия();
		КонецЕсли;
		
	Исключение
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Регистрирует ошибку в журнале регистрации.
//
// Параметры:
//  КраткийТекстОшибки - Строка - Краткий текст ошибки.
//  ПодробныйТекстОшибки - Строка - Подробный текст ошибки.
//  ПоказыватьСообщения - Булево - определяет показ сообщений пользователю.
//
Процедура ЗарегистрироватьОшибку(ИмяСобытия, КраткийТекстОшибки, ПодробныйТекстОшибки, ПоказыватьСообщения = Ложь) Экспорт
	
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ПодробныйТекстОшибки);
	Если Не ПоказыватьСообщения Тогда
		Возврат;
	КонецЕсли;
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'При обработке события возникла ошибка. Обратитесь к администратору.
					|Текст ошибки:
					|%1'"),
		КраткийТекстОшибки);
	ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

Функция СтатусПодпискиНаСобытияВАТС(ИдентификаторПодпискиВАТС)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяСобытия = НСтр("ru = 'Телефония.ОбновлениеСтатусаПодключения'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	
	ПараметрыURL = Новый Структура;
	ПараметрыURL.Вставить("subscriptionId", ИдентификаторПодпискиВАТС);
	
	ПараметрыЗапроса = ОтправкаЗапросов.НовыйПараметрыОтправки("GET");
	ПараметрыЗапроса.Сервер = КорневойАдрес();
	ПараметрыЗапроса.АдресРесурса = "integration/core/api/subscription";
	ПараметрыЗапроса.ПараметрыURL = ПараметрыURL;
	ПараметрыЗапроса.Заголовки.Вставить("X-MPBX-API-AUTH-TOKEN", НастройкиТелефонии.КлючДляАвторизацииВАТСБилайн);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	HTTPОтвет = ОтправкаЗапросов.ОтправитьЗапрос(ПараметрыЗапроса);
	ПараметрыОтвета = ТелефонияСервер.ПрочитатьJSONВСтруктуру(HTTPОтвет.ПолучитьТелоКакСтроку());
	
	Если HTTPОтвет.КодСостояния = 200 Тогда
		
		Если ПараметрыОтвета.Свойство("subscriptionId")
			И ЗначениеЗаполнено(ПараметрыОтвета.subscriptionId)
			И Число(ПараметрыОтвета.expires) > 7200 Тогда
			
			МенеджерЗаписи = РегистрыСведений.НастройкиПодпискиНаСобытияТелефонии.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ОператорАТС = Перечисления.ДоступныеАТС.Билайн;
			МенеджерЗаписи.Прочитать();
			МенеджерЗаписи.ИдентификаторПодписки = ПараметрыОтвета.subscriptionId;
			МенеджерЗаписи.ТипПодписки = ПараметрыОтвета.subscriptionType;
			МенеджерЗаписи.ВремяДоЗавершения = ПараметрыОтвета.expires;
			МенеджерЗаписи.ДатаОбновления = ТекущаяДатаСеанса();
			МенеджерЗаписи.АдресПринимающегоСервиса = ПараметрыОтвета.url;
			МенеджерЗаписи.Записать();
			
			Возврат Истина;
			
		КонецЕсли;
		
	Иначе
		ОписаниеОшибки = ПолучитьОписаниеОшибокHTTPВызова(НСтр("ru = 'Ошибка получения статуса подписки на события АТС.'"), HTTPОтвет);
		ЗарегистрироватьОшибку(ИмяСобытия, ОписаниеОшибки.КраткийТекстОшибки, ОписаниеОшибки.ПодробныйТекстОшибки);
	КонецЕсли;
		
	Возврат Ложь;
	
КонецФункции

Функция ЗапросНовойПодпискиНаСобытия(HTTPОтвет = Неопределено, АдресПринимающегоСервиса = Неопределено)

	УстановитьПривилегированныйРежим(Истина);
	
	ИмяСобытия = НСтр("ru = 'Телефония.ЗапросНовойПодпискиНаСобытия'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	ОшибкаНастройки = Ложь;
	
	Если АдресПринимающегоСервиса = Неопределено Тогда
		АдресПринимающегоСервиса = ТелефонияСервер.АдресОбратногоВызоваОблачнаяТелефония(Перечисления.ДоступныеАТС.Билайн);
	КонецЕсли;
	НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	
	ДлительностьПодписки = 86400;
	ТипПодписки = "BASIC_CALL";
	
	ПараметрыЗвонка = Новый Структура;
	ПараметрыЗвонка.Вставить("expires", ДлительностьПодписки);
	ПараметрыЗвонка.Вставить("subscriptionType", ТипПодписки);
	ПараметрыЗвонка.Вставить("url", АдресПринимающегоСервиса);
	ТелоЗапросаJson = ОтправкаЗапросов.СоздатьJSONИзСтруктуры(ПараметрыЗвонка);
	
	ПараметрыЗапроса = ОтправкаЗапросов.НовыйПараметрыОтправки("PUT");
	ПараметрыЗапроса.Сервер = КорневойАдрес();
	ПараметрыЗапроса.АдресРесурса = "integration/core/api/subscription";
	ПараметрыЗапроса.Заголовки.Вставить("X-MPBX-API-AUTH-TOKEN", НастройкиТелефонии.КлючДляАвторизацииВАТСБилайн);
	ПараметрыЗапроса.Json = ТелоЗапросаJson;
	
	HTTPОтвет = ОтправкаЗапросов.ОтправитьЗапрос(ПараметрыЗапроса);
	ПараметрыОтвета = ТелефонияСервер.ПрочитатьJSONВСтруктуру(HTTPОтвет.ПолучитьТелоКакСтроку());
	
	Если HTTPОтвет.КодСостояния = 200 Тогда
		Если ПараметрыОтвета.Свойство("subscriptionId") И ЗначениеЗаполнено(ПараметрыОтвета.subscriptionId) Тогда
		
			ДатаСоздания = ТекущаяДатаСеанса();
			ИдентификаторПодписки = ПараметрыОтвета.subscriptionId;
			МенеджерЗаписи = РегистрыСведений.НастройкиПодпискиНаСобытияТелефонии.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ОператорАТС = Перечисления.ДоступныеАТС.Билайн;
			МенеджерЗаписи.ИдентификаторПодписки = ИдентификаторПодписки;
			МенеджерЗаписи.ТипПодписки = ТипПодписки;
			МенеджерЗаписи.Длительность = ДлительностьПодписки;
			МенеджерЗаписи.ВремяДоЗавершения = ДлительностьПодписки;
			МенеджерЗаписи.ДатаСоздания = ДатаСоздания;
			МенеджерЗаписи.ДатаОбновления = ДатаСоздания;
			МенеджерЗаписи.АдресПринимающегоСервиса = АдресПринимающегоСервиса;
			МенеджерЗаписи.Записать();
			
			УстановитьПривилегированныйРежим(Ложь);
			
			Возврат ИдентификаторПодписки;
		КонецЕсли;
	Иначе
		ОписаниеОшибки = ПолучитьОписаниеОшибокHTTPВызова(НСтр("ru = 'Ошибка выполнения запрос на получение подписки на события АТС.'"), HTTPОтвет);
		ЗарегистрироватьОшибку(ИмяСобытия, ОписаниеОшибки.КраткийТекстОшибки, ОписаниеОшибки.ПодробныйТекстОшибки);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Неопределено;
	
КонецФункции

Функция СтатусПроверкиНастроекПодключенияАТС(РегистрацияПредупреждений = Истина)
	
	ИмяСобытия = НСтр("ru = 'Телефония.ПроверкаНастроекПодключения'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	СписокОшибок = Новый ТаблицаЗначений;
	СписокОшибок.Колонки.Добавить("ТипОшибки",				Новый ОписаниеТипов("Строка"));
	СписокОшибок.Колонки.Добавить("ОписаниеОшибки",			Новый ОписаниеТипов("Строка"));

	НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	Если НЕ ЗначениеЗаполнено(НастройкиТелефонии.КлючДляАвторизацииВАТСБилайн) Тогда
		
		Ошибка = СписокОшибок.Добавить();
		Ошибка.ТипОшибки = НСтр("ru = 'Настройка'");
		Ошибка.ОписаниеОшибки = НСтр("ru = 'Отсутствует подключение к АТС Билайн.
			| Необходимо заполнить поле ''Токен для аутентификации''.'");
		
	КонецЕсли;
	
	АдресПринимающегоСервиса = ТелефонияСервер.АдресОбратногоВызоваОблачнаяТелефония(Перечисления.ДоступныеАТС.Билайн);
	Если НЕ ЗначениеЗаполнено(АдресПринимающегоСервиса)
		ИЛИ СтрНайти(АдресПринимающегоСервиса, "[") > 0
		ИЛИ СтрНайти(АдресПринимающегоСервиса, "]") > 0
		ИЛИ СтрНайти(АдресПринимающегоСервиса, "АдресСервераОсновнойПубликации") > 0
		ИЛИ СтрНайти(АдресПринимающегоСервиса, "АдресРесурсаОсновнойПубликации") > 0 Тогда
		
		Ошибка = СписокОшибок.Добавить();
		Ошибка.ТипОшибки = НСтр("ru = 'Настройка'");;
		Ошибка.ОписаниеОшибки = НСтр("ru = 'Отсутствует подключение к АТС Билайн.
			| Необходимо указать корректный адрес публикуемого сервиса 1С:УНФ.'");
		
	КонецЕсли;
	
	Если РегистрацияПредупреждений Тогда
		Для каждого Ошибка Из СписокОшибок Цикл
			ТекстПредупреждения = Ошибка.ОписаниеОшибки;
			ЗарегистрироватьПредупреждение(ИмяСобытия, ТекстПредупреждения);
		КонецЦикла;
	КонецЕсли;
	
	Если СписокОшибок.Количество() > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция НайтиЗаписьРазговораПоИдентификаторуЗвонка(ДанныеЗвонка)
	
	Если НЕ ЗначениеЗаполнено(ДанныеЗвонка.ИдентификаторЗвонкаВАТС) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДатаЗвонка = УниверсальноеВремя(ДанныеЗвонка.ДатаНачалаЗвонка);
	
	НачалоПериода = Формат(ДатаЗвонка - 600, "ДФ=""гггг-ММ-ддTЧЧ:мм:ссZ""");
	ЗавершениеПериода = Формат(ДатаЗвонка + 600, "ДФ=""гггг-ММ-ддTЧЧ:мм:ссZ""");
	
	ИмяСобытия = НСтр("ru = 'Телефония.GetRecordFromList'", ОбщегоНазначения.КодОсновногоЯзыка());
	УстановитьПривилегированныйРежим(Истина);
	
	НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	
	ПараметрыЗапроса = ОтправкаЗапросов.НовыйПараметрыОтправки("GET");
	ПараметрыЗапроса.Сервер = КорневойАдрес();
	ПараметрыЗапроса.АдресРесурса = СтрШаблон("apis/portal/records/?dateFrom=%1&dateTo=%2", НачалоПериода, ЗавершениеПериода);
	ПараметрыЗапроса.Заголовки.Вставить("X-MPBX-API-AUTH-TOKEN", НастройкиТелефонии.КлючДляАвторизацииВАТСБилайн);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	HTTPОтвет = ОтправкаЗапросов.ОтправитьЗапрос(ПараметрыЗапроса);
	ПараметрыОтвета = ТелефонияСервер.ПрочитатьJSONВСтруктуру(HTTPОтвет.ПолучитьТелоКакСтроку());
	
	Если HTTPОтвет.КодСостояния = 200 Тогда
		
		НомерЗаписиЗвонка = Неопределено;
		Если ТипЗнч(ПараметрыОтвета) = Тип("Массив") Тогда
			Для каждого Запись Из ПараметрыОтвета Цикл
				Если Запись.Свойство("externalId") И Запись.Свойство("id") И Запись.externalId = ДанныеЗвонка.ИдентификаторЗвонкаВАТС Тогда
					Возврат ПолучитьЗаписьРазговораПоНомеруЗаписи(Запись.id);
				КонецЕсли;
			КонецЦикла;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		ОписаниеОшибки = ПолучитьОписаниеОшибокHTTPВызова(НСтр("ru = 'Ошибка получения записи разговора.'"), HTTPОтвет);
		ЗарегистрироватьОшибку(ИмяСобытия, ОписаниеОшибки.КраткийТекстОшибки, ОписаниеОшибки.ПодробныйТекстОшибки);
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьЗаписьРазговораПоНомеруЗаписи(НомерЗаписиЗвонка)
	
	Если НЕ ЗначениеЗаполнено(НомерЗаписиЗвонка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяСобытия = НСтр("ru = 'Телефония.GetRecordByNumber'", ОбщегоНазначения.КодОсновногоЯзыка());
	УстановитьПривилегированныйРежим(Истина);
	
	НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	
	ПараметрыЗапроса = ОтправкаЗапросов.НовыйПараметрыОтправки("GET");
	ПараметрыЗапроса.Сервер = КорневойАдрес();
	ПараметрыЗапроса.АдресРесурса = СтрШаблон("apis/portal/records/%1/reference", НомерЗаписиЗвонка);
	ПараметрыЗапроса.Заголовки.Вставить("X-MPBX-API-AUTH-TOKEN", НастройкиТелефонии.КлючДляАвторизацииВАТСБилайн);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	HTTPОтвет = ОтправкаЗапросов.ОтправитьЗапрос(ПараметрыЗапроса);
	ПараметрыОтвета = ТелефонияСервер.ПрочитатьJSONВСтруктуру(HTTPОтвет.ПолучитьТелоКакСтроку());
	
	Если HTTPОтвет.КодСостояния = 200 Тогда
		Если ПараметрыОтвета.Свойство("url") И ЗначениеЗаполнено(ПараметрыОтвета.url) Тогда
			Возврат ПараметрыОтвета.url;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		Если HTTPОтвет.КодСостояния <> 400
			ИЛИ (HTTPОтвет.КодСостояния = 400
			И ЗначениеЗаполнено(ПараметрыОтвета.errorCode)
			И ПараметрыОтвета.errorCode <> "RecordNotFound")  Тогда
			ОписаниеОшибки = ПолучитьОписаниеОшибокHTTPВызова(НСтр("ru = 'Ошибка получения записи разговора.'"), HTTPОтвет);
			ЗарегистрироватьОшибку(ИмяСобытия, ОписаниеОшибки.КраткийТекстОшибки, ОписаниеОшибки.ПодробныйТекстОшибки);
		КонецЕсли;
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция СтрокаXMLВXDTO(СтрокаXML)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	Возврат ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
КонецФункции

Функция ПолучитьДлительностьРазговора(ВремяНачалаUnixTime, ВремяЗавершенияUnixTime)

	ВремяНачала = дата(1970,1,1,1,0,0) + Лев(ВремяНачалаUnixTime, 10);
	ВремяЗавершения = дата(1970,1,1,1,0,0) + Лев(ВремяЗавершенияUnixTime, 10);
	Длительность = ВремяЗавершения - ВремяНачала;
	
	Возврат Длительность;

КонецФункции

Функция ПолучитьДатаВремя(ВремяUnix)
	
	Возврат МестноеВремя(Дата(1970,01,01) + Лев(ВремяUnix, 10), ЧасовойПоясСеанса());
	
КонецФункции

Процедура ЗарегистрироватьПредупреждение(ИмяСобытия, ТекстПредупреждения, ПоказыватьСообщения = Ложь)
	
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Предупреждение,,, ТекстПредупреждения);

	Если Не ПоказыватьСообщения Тогда
		Возврат;
	КонецЕсли;
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'При обработке события возникла ошибка. Обратитесь к администратору.
					|Текст ошибки:
					|%1'"),
		ТекстПредупреждения);
	ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

Функция ПолучитьОписаниеОшибокHTTPВызова(КраткийТекстОшибки, Ответ)
	
	Если Ответ.КодСостояния = 401 ИЛИ Ответ.КодСостояния = 403 Тогда
		КраткийТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 Ошибка авторизации.'"), КраткийТекстОшибки);
	КонецЕсли;
	
	ПодробныйТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Сервер вернул состояние: %1
					|Тело ответа: %2'"), Ответ.КодСостояния, Ответ.ПолучитьТелоКакСтроку());
	
	ТекстОшибок = Новый Структура;
	ТекстОшибок.Вставить("КраткийТекстОшибки", КраткийТекстОшибки);
	ТекстОшибок.Вставить("ПодробныйТекстОшибки", ПодробныйТекстОшибки);
	
	Возврат ТекстОшибок;
	
КонецФункции

Функция РасшифровкаОшибки(Код)
	
	Если Код = 400 Тогда
		Возврат НСтр("ru='Ошибка выполнения запроса'");
	ИначеЕсли Код = 401 Тогда
		Возврат НСтр("ru='Ошибка авторизации'");
	Иначе
		Возврат НСтр("ru='Неизвестная ошибка'");
	КонецЕсли;
	
КонецФункции

Процедура ЗаполнитьНомерКонтакта(ДанныеЗвонкаXML, ДанныеЗвонка)
	
	// Проверка на внутренний звонок
	Если ДанныеЗвонкаXML.remoteParty.Свойства().Получить("userId") <> Неопределено Тогда
		ДанныеЗвонка.НомерКонтакта = СтрЗаменить(ДанныеЗвонкаXML.remoteParty.address, "tel:", "");
	Иначе
		ДанныеЗвонка.НомерКонтакта = СтрЗаменить(ДанныеЗвонкаXML.remoteParty.address.Последовательность().ПолучитьТекст(0), "tel:+", "");
	КонецЕсли;

КонецПроцедуры
#КонецОбласти
