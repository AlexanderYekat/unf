﻿
#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекИнтеграции(НастройкиИнтеграции) Экспорт
	
	НастройкиИнтеграции.ПоддерживаетсяНастройкаМаршрутизации = Истина;
	НастройкиИнтеграции.Методы.ПриПолученииАдресаОбратногоВызова = Истина;
	НастройкиИнтеграции.Методы.ПриОбработкеПолученияИнформацииОВызывающемАбоненте = Истина;
	
	НастройкиИнтеграции.Проверки.Вставить("ПроверкаОбязательныхПолей", Истина);
	НастройкиИнтеграции.Проверки.Вставить("ПроверкаСлужебногоПользователя", Истина);
	НастройкиИнтеграции.Проверки.Вставить("ПроверкаПубликуемогоСервиса", Истина);
	НастройкиИнтеграции.Проверки.Вставить("ПроверкаПодключенияАТС", Истина);
	НастройкиИнтеграции.Проверки.Вставить("ПроверкаСистемыВзаимодействия", Истина);
	
КонецПроцедуры

Функция КорневойАдрес() Экспорт
	
	Возврат "https://api.cloudpbx.rt.ru/";
	
КонецФункции

Функция ШаблонURLHTTPСервиса() Экспорт
	
	Возврат "rt";
	
КонецФункции

Функция ЗапросИсходящегоВызова(НомерКонтакта, НастройкиТелефонии) Экспорт
	
	ПараметрыЗвонка = Новый Структура;
	ПараметрыЗвонка.Вставить("request_number", НомерКонтакта);
	ПараметрыЗвонка.Вставить("from_pin", НастройкиТелефонии.НастройкиТекущегоПользователя.ВнутреннийНомер);
	ПараметрыЗвонкаJson = ОтправкаЗапросов.СоздатьJSONИзСтруктуры(ПараметрыЗвонка);
	
	Подпись = НастройкиТелефонии.УникальныйКодИдентификации + ПараметрыЗвонкаJson + НастройкиТелефонии.УникальныйКлючДляПодписи;
	Подпись = НовыйХешСумма(Подпись);
	
	ПараметрыОтправки = ОтправкаЗапросов.НовыйПараметрыОтправки();
	ПараметрыОтправки.Сервер = КорневойАдрес();
	ПараметрыОтправки.АдресРесурса = "call_back";
	ПараметрыОтправки.Заголовки.Вставить("X-Client-ID",   НастройкиТелефонии.УникальныйКодИдентификации);
	ПараметрыОтправки.Заголовки.Вставить("X-Client-Sign", Подпись);
	ПараметрыОтправки.Json = ПараметрыЗвонкаJson;
	Возврат ПараметрыОтправки;
	
КонецФункции

Процедура ОбработатьОтветЗапросаИсходящегоВызова(HttpОтвет, НастройкиТелефонии, Результат) Экспорт
	
КонецПроцедуры

// Выполняет запрос на получение информации о звонке. Используется в качестве метода проверки подключения с АТС.
//
// Возвращаемое значение:
//  Структура - данные с результатами обработки ответа сервиса, включая код состояни, код ошибки, текст ошибки.
//
Функция ПолучитьИнформациюОЗвонке() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("КодСостояния", "");
	Результат.Вставить("ЗаголовокОшибки", "");
	Результат.Вставить("ТекстОшибки", "");
	
	URL = ТелефонияСервер.КорневойАдресАТС();
	Если URL = Неопределено Тогда
		Результат.ЗаголовокОшибки = "НеЗаполненАдресАТС";
		Возврат Результат;
	КонецЕсли;
	
	НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	АТС = Константы.ИспользуемаяАТС.Получить();
	Если Не НастройкиИнтеграцииЗаполнены(АТС, НастройкиТелефонии) Тогда
		Результат.ЗаголовокОшибки = "НеЗаполненыНастройкиИнтеграции";
		Возврат Результат;
	КонецЕсли;
	
	ПараметрыОтправки = ЗапросНаИнформациюОЗвонке(НастройкиТелефонии);
	
	ОбщегоНазначенияКлиентСервер.Проверить(ТипЗнч(ПараметрыОтправки) = Тип("Структура"), 
		НСтр("ru='Ожидается значение типа структура.'"), "ПозвонитьПоНомеруОблачнаяТелефония");
	
	Если ПараметрыОтправки.Количество() = 3 Тогда
		HTTPОтвет = ПараметрыОтправки.HTTPСоединение.ВызватьHTTPМетод(ПараметрыОтправки.HTTPМетод, ПараметрыОтправки.HTTPЗапрос);
		ИдентификаторЗапроса = ТелефонияСервер.ЛогироватьИсходящийЗапрос(ПараметрыОтправки.HTTPСоединение, ПараметрыОтправки.HTTPМетод, ПараметрыОтправки.HTTPЗапрос);
		ТелефонияСервер.ЛогироватьПолученныйОтвет(HTTPОтвет, ИдентификаторЗапроса);
	Иначе
		HTTPОтвет = ОтправкаЗапросов.ОтправитьЗапросРекурсивно(ПараметрыОтправки);
		ИдентификаторЗапроса = ТелефонияСервер.ЛогироватьПараметрыОтправки(ПараметрыОтправки);
		ТелефонияСервер.ЛогироватьПолученныйОтвет(HTTPОтвет, ИдентификаторЗапроса);
	КонецЕсли;
	
	ИмяСобытияДляЖурналаРегистрации = НСтр("ru='ИнициализацияИсходящегоВызова'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	ОбработатьОтветИнформацияОЗвонке(HTTPОтвет, Результат);
	
	Если ЗначениеЗаполнено(Результат.ЗаголовокОшибки) Тогда
		ТекстОшибки = СтрШаблон("%1%2%3", Результат.ЗаголовокОшибки, Символы.ПС, Результат.ТекстОшибки);
		ТелефонияСервер.ЗаписатьЗапросВЖурналРегистрации(ИмяСобытияДляЖурналаРегистрации, ТекстОшибки);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПриОбработкеПолученияИнформацииОВызывающемАбоненте(ДанныеАбонента, Ответ) Экспорт
	
#Если НЕ ВнешнееСоединение Тогда
	ПараметрыОтвета = Новый Структура;
	ПараметрыОтвета.Вставить("result", 0);
	ПараметрыОтвета.Вставить("resultMessage", НСтр("ru='Операция выполнена успешно'", ОбщегоНазначения.КодОсновногоЯзыка()));
	ПараметрыОтвета.Вставить("displayName", "");
	ПараметрыОтвета.Вставить("PIN", "");
	
	Если ДанныеАбонента = Неопределено Тогда
		ПараметрыОтвета.result = 1;
		ПараметрыОтвета.resultMessage = НСтр("ru='Не найдены данные абонента'", ОбщегоНазначения.КодОсновногоЯзыка());
	Иначе
		ПараметрыОтвета.displayName = ДанныеАбонента.Представление;
		Если ДанныеАбонента.МаршрутизироватьВызовНаОтветственного Тогда
			ПараметрыОтвета.PIN = Строка(ДанныеАбонента.ВнутреннийНомерОтветственного);
		КонецЕсли;
	КонецЕсли;
	
	ТелоОтвета = ТелефонияСервер.СоздатьJSONИзСтруктуры(ПараметрыОтвета, ПереносСтрокJSON.Нет);
	
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type",   "application/json; charset=utf-8");
	Ответ.УстановитьТелоИзСтроки(ТелоОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	
	ПодписатьЗапрос(Ответ);
#КонецЕсли
	
КонецПроцедуры

Процедура ПриПолученииАдресаОбратногоВызова(ШаблонСтрокиПодключения, ПараметрыПодключения, АдресОбратногоВызова) Экспорт
	
	АдресОбратногоВызова = URLБезПротокола(АдресОбратногоВызова);
	
КонецПроцедуры

Функция КорректнаяПодписьЗапроса(ПодписьЗапроса, ПараметрыЗапроса = Неопределено) Экспорт
	
	НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	ПараметрыПодписи = НастройкиТелефонии.УникальныйКодИдентификации + ПараметрыЗапроса + НастройкиТелефонии.УникальныйКлючДляПодписи;
	Возврат ПодписьЗапроса = НовыйХешСумма(ПараметрыПодписи);
	
КонецФункции

Функция НастройкиИнтеграцииЗаполнены(АТС, НастройкиТелефонии) Экспорт
	
	Возврат ЗначениеЗаполнено(НастройкиТелефонии.УникальныйКодИдентификации)
		И ЗначениеЗаполнено(НастройкиТелефонии.УникальныйКлючДляПодписи);
	
КонецФункции

Функция СсылкаНаЗаписьРазговора(ДанныеЗвонка, Ошибка) Экспорт
	
	СсылкаНаЗаписьРазговора = ТелефонияСервер.КорневойАдресАТС() + "get_record";
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(СсылкаНаЗаписьРазговора);
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("session_id", ДанныеЗвонка.ИдентификаторЗвонкаВАТС);
	ПараметрыЗапроса.Вставить("ip_adress", "");
	
	ТелоЗапроса = ТелефонияСервер.СоздатьJSONИзСтруктуры(ПараметрыЗапроса, ПереносСтрокJSON.Нет);
	
	HTTPЗапрос = Новый HTTPЗапрос();
	HTTPЗапрос.АдресРесурса = СтруктураURI.ПутьНаСервере;
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	
	ПодписатьЗапрос(HTTPЗапрос);
	
	Прокси = ПолучениеФайловИзИнтернета.ПолучитьПрокси(СтруктураURI.Схема);
	HTTPСоединение = Новый HTTPСоединение(
		СтруктураURI.Хост,
		СтруктураURI.Порт,,,
		Прокси,
		20,
		ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение());
	
	HTTPОтвет = HTTPСоединение.ВызватьHTTPМетод("POST", HTTPЗапрос);
	ИдентификаторЗапроса = ТелефонияСервер.ЛогироватьИсходящийЗапрос(HTTPСоединение, "POST", HTTPЗапрос);
	ТелефонияСервер.ЛогироватьПолученныйОтвет(HTTPОтвет, ИдентификаторЗапроса);
	Если HTTPОтвет.КодСостояния <> 200 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТелоОтвета = РаскодироватьСтроку(HTTPОтвет.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	ПараметрыОтвета = ТелефонияСервер.ПрочитатьJSONВСтруктуру(ТелоОтвета);
	
	Если Не ЗначениеЗаполнено(ПараметрыОтвета.URL) Тогда
		ТекстОшибки = НСтр("ru='Не удалось получить ссылку записи разговора на сервере АТС.'");
		Если ПараметрыОтвета.Свойство("resultMessage") И ЗначениеЗаполнено(ПараметрыОтвета.resultMessage) Тогда
			ТекстОшибки = ТекстОшибки + Символы.ПС;
			ТекстОшибки = ТекстОшибки + ПараметрыОтвета.resultMessage;
		КонецЕсли;
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Результат = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(ПараметрыОтвета.URL,, Истина);
	
	Расширение = ".mp3";
	ИмяФайла = СтрШаблон(
		НСтр("ru='Звонок %1 от %2'"),
		?(ЗначениеЗаполнено(ДанныеЗвонка.Контакт.Ссылка), ДанныеЗвонка.Контакт.Ссылка, ДанныеЗвонка.НомерКонтакта),
		ДанныеЗвонка.ДатаНачалаЗвонка);
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла, "_");
	ПодстрокиИмениФайла = Новый Массив;
	ПодстрокиИмениФайла.Добавить(ИмяФайла);
	ПодстрокиИмениФайла.Добавить(Расширение);
	ИмяФайла = СтрСоединить(ПодстрокиИмениФайла);
	
	ДанныеФайла = Новый Структура;
	ДанныеФайла.Вставить("ИмяФайла", ИмяФайла);
	ДанныеФайла.Вставить("СсылкаНаДвоичныеДанныеФайла", Результат.Путь);
	ДанныеФайла.Вставить("Расширение", Расширение);
	
	Возврат ДанныеФайла;
	
КонецФункции

// Выполняет проверку подключения к ВАТС.
//
Процедура ПроверкаПодключения() Экспорт
	
	Возврат;
	
КонецПроцедуры

#Область ПроцедурыИФункцииДиагностикиПодключения

Функция ПроверкаПолейАвторизацииОАТС(ТипГруппыПроверок) Экспорт
	
	НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	
	РезультатыТекущейПроверки = Новый Массив;
	
	ТелефонияДиагностика.ПроверитьОбязательноеПоле(
		РезультатыТекущейПроверки,
		ТипГруппыПроверок,
		НСтр("ru='Уникальный ключ для подписи'"),
		НастройкиТелефонии.УникальныйКлючДляПодписи);
		
	ТелефонияДиагностика.ПроверитьОбязательноеПоле(
		РезультатыТекущейПроверки,
		ТипГруппыПроверок,
		НСтр("ru='Уникальный код идентификации'"),
		НастройкиТелефонии.УникальныйКодИдентификации);
	
	Возврат РезультатыТекущейПроверки;
	
КонецФункции

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

Процедура ПриСозданииИсходящегоВызова(НомерАбонента, ДанныеПользователяАТС, НастройкиТелефонии, ПараметрыОтправки, Ошибка) Экспорт
	
	ИсходящиеПараметры = Новый Структура;
	ИсходящиеПараметры.Вставить("request_number", НомерАбонента);
	ИсходящиеПараметры.Вставить("from_pin", ДанныеПользователяАТС.ВнутреннийНомер);
	
	ТелоЗапроса = ТелефонияСервер.СоздатьJSONИзСтруктуры(ИсходящиеПараметры, ПереносСтрокJSON.Нет);
	
	Подпись = НастройкиТелефонии.УникальныйКодИдентификации + ТелоЗапроса + НастройкиТелефонии.УникальныйКлючДляПодписи;
	Подпись = НовыйХешСумма(Подпись);
	
	ПараметрыОтправки.URL = ПараметрыОтправки.URL + "call_back";
	ПараметрыОтправки.Заголовки.Вставить("X-Client-ID",   НастройкиТелефонии.УникальныйКодИдентификации);
	ПараметрыОтправки.Заголовки.Вставить("X-Client-Sign", Подпись);
	ПараметрыОтправки.Json = ТелоЗапроса;
	
КонецПроцедуры

Процедура ПриОбработкеОтветаНаСозданиеИсходящегоВызова(HTTPОтвет, ЗаголовокОшибки, ТекстОшибки) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗапросНаИнформациюОЗвонке(НастройкиТелефонии)
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("session_id", "6UYIUYIUY66hhcw9");
	ПараметрыЗапросаJson = ОтправкаЗапросов.СоздатьJSONИзСтруктуры(ПараметрыЗапроса);
	
	Подпись = НастройкиТелефонии.УникальныйКодИдентификации + ПараметрыЗапросаJson + НастройкиТелефонии.УникальныйКлючДляПодписи;
	Подпись = НовыйХешСумма(Подпись);
	
	ПараметрыОтправки = ОтправкаЗапросов.НовыйПараметрыОтправки();
	ПараметрыОтправки.Сервер = КорневойАдрес();
	ПараметрыОтправки.АдресРесурса = "call_info";
	ПараметрыОтправки.Заголовки.Вставить("X-Client-ID",   НастройкиТелефонии.УникальныйКодИдентификации);
	ПараметрыОтправки.Заголовки.Вставить("X-Client-Sign", Подпись);
	ПараметрыОтправки.Json = ПараметрыЗапросаJson;
	Возврат ПараметрыОтправки;
	
КонецФункции

Процедура ОбработатьОтветИнформацияОЗвонке(HttpОтвет, Результат)
	
	ТелоОтвета = РаскодироватьСтроку(HTTPОтвет.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	Результат.КодСостояния = HTTPОтвет.КодСостояния;
	
	Если HTTPОтвет.КодСостояния <> 200 Тогда
		Результат.ЗаголовокОшибки = НСтр("ru='Ошибка при инициализации вызова.'");
		Результат.ТекстОшибки = ТелоОтвета;
	КонецЕсли;
	
КонецПроцедуры

Функция НовыйХешСумма(ПараметрыПодписи)
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA256);
	ХешированиеДанных.Добавить(ПараметрыПодписи);
	
	Возврат НРег(СтрЗаменить(Строка(ХешированиеДанных.ХешСумма), " ", ""));
	
КонецФункции

Процедура ПодписатьЗапрос(Запрос, НастройкиТелефонии = Неопределено)
	
	Если НастройкиТелефонии = Неопределено Тогда
		НастройкиТелефонии = ТелефонияСервер.ПолучитьНастройкиТелефонии();
	КонецЕсли;
	
	ТелоЗапроса = Запрос.ПолучитьТелоКакСтроку();
	
	Если ТелоЗапроса = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Не установлено тело запроса.'");
	КонецЕсли;
	
	Подпись = НастройкиТелефонии.УникальныйКодИдентификации + ТелоЗапроса + НастройкиТелефонии.УникальныйКлючДляПодписи;
	Подпись = НовыйХешСумма(Подпись);
	
	Запрос.Заголовки.Вставить("X-Client-ID",   НастройкиТелефонии.УникальныйКодИдентификации);
	Запрос.Заголовки.Вставить("X-Client-Sign", Подпись);
	
КонецПроцедуры

Функция URLБезПротокола(URL)
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	Протокол = СтруктураURI.Схема + "://";
	Возврат Прав(URL, СтрДлина(URL) - СтрДлина(Протокол));
	
КонецФункции

#КонецОбласти
