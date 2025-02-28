﻿////////////////////////////////////////////////////////////////////////////////
// Модуль формы Справочник.Номенклатура.Форма.ФормаЗначенийРеквизитов
//  
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ЗначенияНоменклатурыКонтрагента") Тогда
		
		ЗаполнитьПоЗначениямНоменклатурыКонтрагента(Параметры.ЗначенияНоменклатурыКонтрагента);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(КатегорияНоменклатуры) Тогда
		КатегорияНоменклатуры = Справочники.КатегорииНоменклатуры.БезКатегории;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда
		ЕдиницаИзмерения = Справочники.КлассификаторЕдиницИзмерения.шт;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ВидСтавкиНДС) Тогда
		ВидСтавкиНДС = Перечисления.ВидыСтавокНДС.БезНДС;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Родитель", Родитель);
	Результат.Вставить("КатегорияНоменклатуры", КатегорияНоменклатуры);
	Результат.Вставить("ЕдиницаИзмерения", ЕдиницаИзмерения);
	Результат.Вставить("ВидСтавкиНДС", ВидСтавкиНДС);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПоЗначениямНоменклатурыКонтрагента(Значения)
	
	Если Значения.Свойство("ЕдиницаИзмеренияКод") И Не ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда
		
		ЕдиницаИзмерения = Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду(Значения.ЕдиницаИзмеренияКод);
		
	КонецЕсли;
	
	Если Значения.Свойство("ЕдиницаИзмерения") И Не ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда
		
		ЕдиницаИзмерения = Справочники.КлассификаторЕдиницИзмерения.НайтиПоНаименованию(Значения.ЕдиницаИзмерения, Истина);
		
	КонецЕсли;
	
	Если Значения.Свойство("СтавкаНДС") И Не ЗначениеЗаполнено(ВидСтавкиНДС) Тогда
		
		СтавкиНДСПоКлючу = Новый Соответствие;
		ОбменСКонтрагентамиПереопределяемый.ЗаполнитьСоответствиеСтавокНДС(СтавкиНДСПоКлючу);
		ВидСтавкиНДС = Перечисления.ВидыСтавокНДС.ВидСтавки(СтавкиНДСПоКлючу[Значения.СтавкаНДС]);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

