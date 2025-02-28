﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Константы.УчетПоКомпании.Получить() Тогда
		
		Организация = Справочники.Организации.ОрганизацияКомпания();
		Элементы.Организация.Видимость = Ложь;
		
	ИначеЕсли Параметры.Отбор.Свойство("Организация") Тогда
		
		Организация = Параметры.Отбор.Организация;
		Элементы.Организация.Доступность = Ложь;
		
	Иначе
		
		ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
		
		Если ЗначениеЗаполнено(ЗначениеНастройки) Тогда
			
			Организация = ЗначениеНастройки;
			
		Иначе
			
			Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
			
		КонецЕсли;
		
	КонецЕсли;
	
	УчетПоНесколькимПодразделениям = Константы.ФункциональнаяОпцияУчетПоНесколькимПодразделениям.Получить();
	ОсновноеПодразделение = Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение;
	Если НЕ УчетПоНесколькимПодразделениям Тогда
		
		Элементы.Подразделения.Видимость = Ложь;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "СтруктурнаяЕдиница",
			ОсновноеПодразделение);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделенияПриАктивизацииСтроки(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
// В процедуре устанавливаются отборы на табличную часть штатного расписания
//
Процедура УстановитьОтбор()
	
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация);

	Если НЕ УчетПоНесколькимПодразделениям Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "СтруктурнаяЕдиница",
			ОсновноеПодразделение);
		
	ИначеЕсли Элементы.Подразделения.ТекущиеДанные <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "СтруктурнаяЕдиница",
			Элементы.Подразделения.ТекущиеДанные.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
