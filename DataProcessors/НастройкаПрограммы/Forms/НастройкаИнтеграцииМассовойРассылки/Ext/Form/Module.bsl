﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущийСервис = МассовыеРассылкиИнтеграция.ПодключенныйСервис();
	СсылкиНаСтатьи = Перечисления.СервисыМассовыхРассылок.СсылкиНаСтатьи();
	УправлениеФормой();
	ПрочитатьНастройкиИнтеграции();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СервисSendPulseЛогоНажатие(Элемент)
	ОткрытьСтраницуСервиса(ПредопределенноеЗначение("Перечисление.СервисыМассовыхРассылок.SendPulse"));
КонецПроцедуры

&НаКлиенте
Процедура СервисSendPulseСсылкаНажатие(Элемент)
	ОткрытьСтраницуСервиса(ПредопределенноеЗначение("Перечисление.СервисыМассовыхРассылок.SendPulse"));
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСервисSendPulseПриИзменении(Элемент)
	Если ИспользоватьСервисSendPulse Тогда
		ВыбранныйСервис = ПредопределенноеЗначение("Перечисление.СервисыМассовыхРассылок.SendPulse");
	Иначе
		ВыбранныйСервис = Неопределено;
	КонецЕсли;
	ПриВыбореСервиса(ВыбранныйСервис);
КонецПроцедуры

&НаКлиенте
Процедура СервисUniSenderЛогоНажатие(Элемент)
	ОткрытьСтраницуСервиса(ПредопределенноеЗначение("Перечисление.СервисыМассовыхРассылок.UniSender"));
КонецПроцедуры

&НаКлиенте
Процедура СервисUniSenderСсылкаНажатие(Элемент)
	ОткрытьСтраницуСервиса(ПредопределенноеЗначение("Перечисление.СервисыМассовыхРассылок.UniSender"));
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСервисUniSenderПриИзменении(Элемент)
	Если ИспользоватьСервисUniSender Тогда
		ВыбранныйСервис = ПредопределенноеЗначение("Перечисление.СервисыМассовыхРассылок.UniSender");
	Иначе
		ВыбранныйСервис = Неопределено;
	КонецЕсли;
	ПриВыбореСервиса(ВыбранныйСервис);
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияПоРаботеСРассылкамиНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://its.1c.ru/db/metod81#content:7391:hdoc");
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияНастройкиНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ИнструкцияПодключенияСсылка(ТекущийСервис));
	
КонецПроцедуры

&НаКлиенте
Процедура КлючAPIПриИзменении(Элемент)
	СохранитьНастройкиИнтеграции();
КонецПроцедуры

&НаКлиенте
Процедура СекретныйКлючПриИзменении(Элемент)
	СохранитьНастройкиИнтеграции();
КонецПроцедуры

&НаКлиенте
Процедура ЛогинПриИзменении(Элемент)
	СохранитьНастройкиИнтеграции();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()
	
	Элементы.Инструкции.Видимость = ЗначениеЗаполнено(ТекущийСервис);
	Элементы.НастройкаИнтеграции.Видимость = ЗначениеЗаполнено(ТекущийСервис);
	
	Если Не ЗначениеЗаполнено(ТекущийСервис) Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиИнтерфейса = МассовыеРассылкиИнтеграция.НастройкиИнтерфейса(ТекущийСервис);
	
	Элементы.Логин.Видимость         = НастройкиИнтерфейса.ИспользоватьЛогин;
	Элементы.СекретныйКлюч.Видимость = НастройкиИнтерфейса.ИспользоватьСекретныйКлюч;
	Элементы.КлючAPI.Видимость       = НастройкиИнтерфейса.ИспользоватьКлючAPI;
	
	Если ТекущийСервис = Перечисления.СервисыМассовыхРассылок.SendPulse Тогда
		Элементы.КлючAPI.Заголовок = НСтр("ru='ID'");
		Элементы.СекретныйКлюч.Заголовок = НСтр("ru='Secret'");
	ИначеЕсли ТекущийСервис = Перечисления.СервисыМассовыхРассылок.UniSender Тогда
		Элементы.КлючAPI.Заголовок = НСтр("ru='Ключ доступа к API'");
	Иначе
		Элементы.КлючAPI.Заголовок = НСтр("ru='Ключ API'");
		Элементы.СекретныйКлюч.Заголовок = НСтр("ru='Секретный ключ'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриВыбореСервиса(ВыбранныйСервис)
	
	Если Не ЗначениеЗаполнено(ВыбранныйСервис) Тогда
		ОтключитьИнтеграцию();
	КонецЕсли;
	
	ТекущийСервис = ВыбранныйСервис;
	Константы.ИспользоватьМассовыеРассылкиИнтеграция.Установить(Истина);
	Константы.СервисМассовыхРассылок.Установить(ТекущийСервис);
	
	УправлениеФормой();
	
	КлючAPI = Неопределено;
	Логин = Неопределено;
	СекретныйКлюч = Неопределено;
	
	ПрочитатьНастройкиИнтеграции();
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьИнтеграцию()
	
	Константы.ИспользоватьМассовыеРассылкиИнтеграция.Установить(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиИнтеграции()
	
	НастройкаИнтеграции = МассовыеРассылкиИнтеграция.НастройкаИнтеграции(ТекущийСервис);
	КлючAPI       = НастройкаИнтеграции.КлючAPI;
	Логин         = НастройкаИнтеграции.Логин;
	СекретныйКлюч = НастройкаИнтеграции.СекретныйКлюч;
	
	Если НастройкаИнтеграции.Сервис = Перечисления.СервисыМассовыхРассылок.SendPulse Тогда
		ИспользоватьСервисSendPulse = Истина;
		ИспользоватьСервисUniSender = Ложь;
	ИначеЕсли НастройкаИнтеграции.Сервис = Перечисления.СервисыМассовыхРассылок.UniSender Тогда
		ИспользоватьСервисSendPulse = Ложь;
		ИспользоватьСервисUniSender = Истина;
	Иначе
		ИспользоватьСервисSendPulse = Ложь;
		ИспользоватьСервисUniSender = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиИнтеграции()
	
	НастройкаИнтеграции = МассовыеРассылкиИнтеграция.НовыйНастройкаИнтеграции();
	НастройкаИнтеграции.Сервис        = ТекущийСервис;
	НастройкаИнтеграции.КлючAPI       = КлючAPI;
	НастройкаИнтеграции.Логин         = Логин;
	НастройкаИнтеграции.СекретныйКлюч = СекретныйКлюч;
	
	МассовыеРассылкиИнтеграция.СохранитьНастройкиИнтеграции(НастройкаИнтеграции);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСтраницуСервиса(Сервис)
	
	Ссылка = СсылкиНаСтатьи.НайтиПоЗначению(Сервис).Представление;
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Ссылка);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИнструкцияПодключенияСсылка(Сервис)
	
	СсылкиНаСтатьи = Новый Соответствие;
	СсылкиНаСтатьи.Вставить(ПредопределенноеЗначение("Перечисление.СервисыМассовыхРассылок.SendPulse"), "https://its.1c.ru/db/metod81#content:7392:hdoc");
	СсылкиНаСтатьи.Вставить(ПредопределенноеЗначение("Перечисление.СервисыМассовыхРассылок.UniSender"), "https://its.1c.ru/db/metod81#content:7393:hdoc");
	Возврат СсылкиНаСтатьи.Получить(Сервис);
	
КонецФункции

#КонецОбласти
