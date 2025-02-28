﻿
#Область СлужебныйПрограммныйИнтерфейс

Функция ЭтоРасширеннаяВерсияГосИС() Экспорт
	
	Возврат ОбщегоНазначенияИСМПКлиентСерверПовтИсп.ЭтоРасширеннаяВерсияГосИС();
	
КонецФункции

Функция ДатаНачалаКонтроляКодовМаркировкиМОТП() Экспорт
	
	Возврат '20200701';
	
КонецФункции

// Инициализировать структуру параметров запроса в ИС МОТП (ИС МП) для получения ключа сессии.
// 
// Параметры:
// 	Организация - ОпределяемыйТип.Организация, Неопределено - Организация.
// Возвращаемое значение:
// 	Структура - Параметры запроса ключа сессии См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии.
//
Функция ПараметрыЗапросаКлючаСессии(Организация = Неопределено) Экспорт
	
	ПараметрыОтправкиHTTPЗапросов = ПараметрыОтправкиHTTPЗапросов("", Истина);
	
	ПараметрыЗапроса = ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии();
	ПараметрыЗапроса.Организация = Организация;
	
	ПараметрыЗапроса.ПредставлениеСервиса             = ПараметрыОтправкиHTTPЗапросов.ПредставлениеСервиса;
	ПараметрыЗапроса.Сервер                           = ПараметрыОтправкиHTTPЗапросов.Сервер;
	ПараметрыЗапроса.Порт                             = ПараметрыОтправкиHTTPЗапросов.Порт;
	ПараметрыЗапроса.Таймаут                          = ПараметрыОтправкиHTTPЗапросов.Таймаут;
	ПараметрыЗапроса.ИспользоватьЗащищенноеСоединение = ПараметрыОтправкиHTTPЗапросов.ИспользоватьЗащищенноеСоединение;
	
	ПараметрыЗапроса.ИмяПараметраСеанса                = "ДанныеКлючаСессииИСМП";
	ПараметрыЗапроса.АдресЗапросаПараметровАвторизации = "api/v3/true-api/auth/key";
	ПараметрыЗапроса.АдресЗапросаКлючаСессии           = "api/v3/true-api/auth/simpleSignIn";
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

// Возвращает параметры для отправки HTTP запросов МОТП.
// 
// Параметры:
// 	Поддомен - Строка - Имя поддомена
// 	ИспользоватьTrueAPI - Булево - Использовать true-api
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * ИспользоватьЗащищенноеСоединение - Булево - Признак использования SSL.
// * Таймаут - Число - Таймаут соединения.
// * Порт - Число - Порт соединения.
// * Сервер - Строка - Адрес сервера.
// * ПредставлениеСервиса - Строка - Представления сервиса.
//
Функция ПараметрыОтправкиHTTPЗапросов(Поддомен = "api", ИспользоватьTrueAPI = Ложь) Экспорт
	
	Если ЗначениеЗаполнено(Поддомен) Тогда
		АдресСервера = СтрШаблон("%1.%2", Поддомен, АдресСервера(ИспользоватьTrueAPI));
	Иначе
		АдресСервера = АдресСервера(ИспользоватьTrueAPI);
	КонецЕсли;
	
	ПараметрыОтправкиHTTPЗапросов = Новый Структура;
	ПараметрыОтправкиHTTPЗапросов.Вставить("Сервер",                           АдресСервера);
	ПараметрыОтправкиHTTPЗапросов.Вставить("Порт",                             443);
	ПараметрыОтправкиHTTPЗапросов.Вставить("Таймаут",                          60);
	ПараметрыОтправкиHTTPЗапросов.Вставить("ИспользоватьЗащищенноеСоединение", Истина);
	ПараметрыОтправкиHTTPЗапросов.Вставить("ПредставлениеСервиса",             НСтр("ru = 'ГИС МТ'"));
	
	Возврат ПараметрыОтправкиHTTPЗапросов;
	
КонецФункции

// Возвращает адрес сервера ИС МОТП.
// 
// Параметры:
// 	ИспользоватьTrueAPI - Булево - Использовать true-api
// Возвращаемое значение:
// 	Строка - адрес сервера ИС МОТП.
//
Функция АдресСервера(ИспользоватьTrueAPI = Ложь) Экспорт
	
	РежимРаботыСТестовымКонтуромИСМП = ОбщегоНазначенияИСМПКлиентСерверПовтИсп.РежимРаботыСТестовымКонтуромИСМП();
	
	Если РежимРаботыСТестовымКонтуромИСМП Тогда
		Возврат "markirovka.sandbox.crptech.ru";
	Иначе
		Возврат "markirovka.crpt.ru";
	КонецЕсли;
	
КонецФункции

Функция ИменаПараметровРаботыКлиента() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить(
		"ВерсияБПОПоддерживаетПроверкуКМЕдинымМетодом",
		"ИнтеграцияИСМП_ВерсияБПОПоддерживаетПроверкуКМСредствамиККТЕдинымМетодом");
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Возвращает значение параметра ЗапрашиватьДанныеСервисаИСМП. Если оно установлено как ПоУмолчанию, то значение берется из
//  ФО ЗапрашиватьДанныеСервисаИСМП
// 
// Параметры:
//  ПараметрыСканирования - см. ШтрихкодированиеОбщегоНазначенияИС.ПараметрыСканирования
//  ОтключитьПоВидуПродукцииВидуОперации - Булево - признак необходимости исключения запросов по настройкам исключений контролей
// 
// Возвращаемое значение:
//  Булево - значение ЗапрашиватьДанныеСервисаИСМП
Функция ЗначениеПараметраСканированияЗапрашиватьДанныеСервисаИСМП(ПараметрыСканирования, ОтключитьПоВидуПродукцииВидуОперации = Ложь) Экспорт
	
	Значение = Ложь;
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ПараметрыСканирования, "ЗапрашиватьДанныеСервисаИСМП") Тогда
		Возврат Значение;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыСканирования.ЗапрашиватьДанныеСервисаИСМП) = Тип("Строка") Тогда
		
		Если ВРег(ПараметрыСканирования.ЗапрашиватьДанныеСервисаИСМП) = "ПОУМОЛЧАНИЮ" Тогда
			Значение = ОбщегоНазначенияИСМПКлиентСерверПовтИсп.ЗапрашиватьДанныеСервиса() И Не ОтключитьПоВидуПродукцииВидуОперации;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПараметрыСканирования.ЗапрашиватьДанныеСервисаИСМП) = Тип("Булево") Тогда
		
		Значение = ПараметрыСканирования.ЗапрашиватьДанныеСервисаИСМП;
		
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

// Устанавливает значение параметра ЗапрашиватьДанныеСервисаИСМП. 
// 
// Параметры:
//  ПараметрыСканирования - см. ШтрихкодированиеОбщегоНазначенияИС.ПараметрыСканирования
//  Значение - Булево, Строка - если устанавливается строка "ПоУмолчанию", то значение берется в соответствие с ФО ЗапрашиватьДанныеСервисаИСМП
//    если требуется поведение, отличное от ФО, то оно устанавливается напрямую значением типа Булево
Процедура УстановитьПараметрСканированияЗапрашиватьДанныеСервисаИСМП(ПараметрыСканирования, Значение = "ПоУмолчанию") Экспорт
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ПараметрыСканирования, "ЗапрашиватьДанныеСервисаИСМП") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСканирования.ЗапрашиватьДанныеСервисаИСМП = Значение;
	
КонецПроцедуры

// Возвращает значение параметра ЗапрашиватьДанныеНеизвестныхУпаковокИСМП. Если оно установлено как ПоУмолчанию, то значение берется из
//  ФО ЗапрашиватьДанныеСервисаИСМП
// 
// Параметры:
//  ПараметрыСканирования - см. ШтрихкодированиеОбщегоНазначенияИС.ПараметрыСканирования
//  ОтключитьПоВидуПродукцииВидуОперации - Булево - признак необходимости исключения запросов по настройкам исключений контролей
// 
// Возвращаемое значение:
//  Булево - значение ЗапрашиватьДанныеНеизвестныхУпаковокИСМП
Функция ЗначениеПараметраСканированияЗапрашиватьДанныеНеизвестныхУпаковокИСМП(ПараметрыСканирования, ОтключитьПоВидуПродукцииВидуОперации = Ложь) Экспорт
	
	Значение = Ложь;
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ПараметрыСканирования, "ЗапрашиватьДанныеНеизвестныхУпаковокИСМП") Тогда
		Возврат Значение;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыСканирования.ЗапрашиватьДанныеНеизвестныхУпаковокИСМП) = Тип("Строка") Тогда
		
		Если ВРег(ПараметрыСканирования.ЗапрашиватьДанныеНеизвестныхУпаковокИСМП) = "ПОУМОЛЧАНИЮ" Тогда
			Значение = ОбщегоНазначенияИСМПКлиентСерверПовтИсп.ЗапрашиватьДанныеСервиса() И Не ОтключитьПоВидуПродукцииВидуОперации;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПараметрыСканирования.ЗапрашиватьДанныеНеизвестныхУпаковокИСМП) = Тип("Булево") Тогда
		
		Значение = ПараметрыСканирования.ЗапрашиватьДанныеНеизвестныхУпаковокИСМП;
		
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

// Устанавливает значение параметра ЗапрашиватьДанныеНеизвестныхУпаковокИСМП. 
// 
// Параметры:
//  ПараметрыСканирования - см. ШтрихкодированиеОбщегоНазначенияИС.ПараметрыСканирования
//  Значение - Булево, Строка - если устанавливается строка "ПоУмолчанию", то значение берется в соответствие с ФО ЗапрашиватьДанныеСервисаИСМП
//    если требуется поведение, отличное от ФО, то оно устанавливается напрямую значением типа Булево
Процедура УстановитьПараметрСканированияЗапрашиватьДанныеНеизвестныхУпаковокИСМП(ПараметрыСканирования, Значение = "ПоУмолчанию") Экспорт
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ПараметрыСканирования, "ЗапрашиватьДанныеНеизвестныхУпаковокИСМП") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСканирования.ЗапрашиватьДанныеНеизвестныхУпаковокИСМП = Значение;
	
КонецПроцедуры

#КонецОбласти