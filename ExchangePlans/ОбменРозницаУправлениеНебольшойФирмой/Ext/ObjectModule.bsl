﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ИспользоватьОтборПоОрганизациям Тогда
		Организации.Очистить();
	КонецЕсли;
	Если НЕ ИспользоватьОтборПоСкладам Тогда
		Склады.Очистить();
	КонецЕсли;
	РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьОбъект(ДанныеЗаполнения);
	
КонецПроцедуры


#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОбъект(ДанныеЗаполнения)
	
	Если Не ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	
	РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	РежимВыгрузкиДокументовКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	РежимВыгрузкиСправочниковКорреспондента = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	
	// настройка отборов
	ДатаНачалаВыгрузкиДокументов = НачалоГода(ТекущаяДата());
	ИспользоватьОтборПоОрганизациям = Ложь;
	ИспользоватьОтборПоСкладам = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли