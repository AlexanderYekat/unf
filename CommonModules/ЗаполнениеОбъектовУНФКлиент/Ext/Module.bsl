﻿
#Область ПрограммныйИнтерфейс

Процедура ПоказатьВыборШаблонаДляСозданияДокументаИзСписка(Знач ПолноеИмяОбъектаМетаданных, Знач ЭлементыОтбораДинамическогоСписка, Знач ДокументСсылка, Знач ИсключитьТипы = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПолноеИмяОбъектаМетаданных", ПолноеИмяОбъектаМетаданных);
	ПараметрыФормы.Вставить("ВидыОпераций", СписокВидовОперацийДляОтбора(ЭлементыОтбораДинамическогоСписка));
	ПараметрыФормы.Вставить("ДокументСсылка", ДокументСсылка);
	ПараметрыФормы.Вставить("ИсключитьТипы", ИсключитьТипы);
	
	ОткрытьФорму("Справочник.ШаблоныДокументовУНФ.ФормаВыбора", ПараметрыФормы);
	
КонецПроцедуры

Процедура СохранитьДокументКакШаблон(Объект, ОтображаемыеРеквизиты, ОписаниеОповещения) Экспорт
	
	Если ТипЗнч(ОписаниеОповещения) = Тип("ОписаниеОповещения") Тогда
		
		ОткрытьФорму("Справочник.ШаблоныДокументовУНФ.ФормаОбъекта",
		Новый Структура("Объект, ОтображаемыеРеквизиты", Объект, ОтображаемыеРеквизиты),,,,,
		ОписаниеОповещения);
		
	Иначе
		
		ОткрытьФорму("Справочник.ШаблоныДокументовУНФ.ФормаОбъекта",
		Новый Структура("Объект, ОтображаемыеРеквизиты", Объект, ОтображаемыеРеквизиты));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСкладВСтрокеТЧЗапасы(Знач СтрокаТЧЗапасы, Знач ДокументОбъект, Знач ДанныеНоменклатуры) Экспорт
	
	Если ТипЗнч(ДанныеНоменклатуры)=Тип("Структура") Тогда
		Если ДанныеНоменклатуры.Свойство("Склад") И ЗначениеЗаполнено(ДанныеНоменклатуры.Склад) Тогда
			СтрокаТЧЗапасы.СтруктурнаяЕдиница = ДанныеНоменклатуры.Склад;
		КонецЕсли;
		Если ДанныеНоменклатуры.Свойство("Ячейка") И ЗначениеЗаполнено(ДанныеНоменклатуры.Ячейка) И СтрокаТЧЗапасы.Свойство("Ячейка") Тогда
			СтрокаТЧЗапасы.Ячейка = ДанныеНоменклатуры.Ячейка;
		КонецЕсли;
	КонецЕсли;
	
	ЕстьРеквизитПоложениеСклада = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДокументОбъект, "ПоложениеСклада");
	ПоложениеСклада = ?(ЕстьРеквизитПоложениеСклада, ДокументОбъект.ПоложениеСклада, ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти"));
	
	Если Не ЗначениеЗаполнено(СтрокаТЧЗапасы.СтруктурнаяЕдиница) 
		И ПоложениеСклада<>ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти") Тогда
		СтрокаТЧЗапасы.СтруктурнаяЕдиница = ДокументОбъект.СтруктурнаяЕдиница;
		Если СтрокаТЧЗапасы.Свойство("Ячейка") Тогда
			СтрокаТЧЗапасы.Ячейка = ДокументОбъект.Ячейка;
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

// Заполняет реквизит строки табличной части по шапке. 
// 
// Параметры:
//  СтрокаТЧ - ДанныеФормыСтруктура - Строка табличной части для заполнения.
//  ДокументОбъект - ДанныеФормы - Обрабатываемый документ.
//  ИмяПоля - Строка - Имя заполняемого поля.
//  ИмяПоляПоложения - Строка - Имя поля текущего положения реквизита.
// 
Процедура ЗаполнитьСтрокуПоШапке(Знач СтрокаТЧ, Знач ДокументОбъект, ИмяПоля, ИмяПоляПоложения) Экспорт
	
	ЗаполнениеОбъектовУНФКлиентСервер.ЗаполнитьСтрокуПоШапке(СтрокаТЧ, ДокументОбъект, ИмяПоля, ИмяПоляПоложения);
	
КонецПроцедуры

// Выполняет стандартные действия после смены положения реквизита на форме. 
// 
// Параметры:
//  ДокументОбъект - ДанныеФормы - Обрабатываемый документ.
//  ИмяТЧ - Строка - Имя обрабатываемой табличной части.
//  ИмяПоля - Строка - Имя реквизита, изменившего положение.
//  ИмяПоляПоложения - Строка - Имя поля текущего положения реквизита.
// 
Процедура ОбработатьИзменениеПоложения(Знач ДокументОбъект, ИмяТЧ, ИмяПоля, ИмяПоляПоложения) Экспорт
	
	Если ДокументОбъект[ИмяПоляПоложения]<>ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти") Тогда
		ДокументОбъект[ИмяПоля] = ЗначениеДляШапки(ДокументОбъект[ИмяТЧ], ИмяПоля);
	КонецЕсли;
	
	Для каждого СтрокаТабличнойЧасти Из ДокументОбъект[ИмяТЧ] Цикл
		СтрокаТабличнойЧасти[ИмяПоля] = ДокументОбъект[ИмяПоля];
	КонецЦикла; 
	
КонецПроцедуры

// Возвращает наиболее часто встречающиеся в табличной части значение поля. 
// 
// Параметры:
//  ТабличнаяЧасть - ТабличнаяЧасть - Обрабатываемая табличная часть.
//  ИмяПоля - Строка - Имя анализируемого поля.
// 
// Возвращаемое значение:
//  ЛюбоеЗначение - Наиболее часто встречающиеся в табличной части значение поля.
//
Функция ЗначениеДляШапки(ТабличнаяЧасть, ИмяПоля) Экспорт
	
	Если ТабличнаяЧасть.Количество()=0 Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	СоответствиеЗначений = Новый Соответствие;
	Для каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		Значение = СтрокаТабличнойЧасти[ИмяПоля];
		Если НЕ ЗначениеЗаполнено(Значение) Тогда
			Продолжить;
		КонецЕсли;
		Количество = СоответствиеЗначений.Получить(Значение);
		Если Количество=Неопределено Тогда
			Количество = 0;
		КонецЕсли; 
		СоответствиеЗначений.Вставить(Значение, Количество + 1);
	КонецЦикла; 
	
	МаксимальноеЗначение = Неопределено;
	Для каждого КлючИЗначение Из СоответствиеЗначений Цикл
		Если МаксимальноеЗначение=Неопределено Тогда
			МаксимальноеЗначение = КлючИЗначение;
			Продолжить;
		КонецЕсли;
		Если КлючИЗначение.Значение>МаксимальноеЗначение.Значение Тогда
			МаксимальноеЗначение = КлючИЗначение;
		КонецЕсли; 
	КонецЦикла;
	Если МаксимальноеЗначение=Неопределено Тогда
		Возврат Неопределено;
	Иначе
		Возврат МаксимальноеЗначение.Ключ;
	КонецЕсли; 
	
КонецФункции

// Заполняет пустые реквизиты положений перед открытием формы "Шапка / табличная часть". 
// 
// Параметры:
//  Объект - ДанныеФормы - Обрабатываемый документ.
//  ИменаПолей - Строка - Имена полей, которые следует проверить и заполнить, разделенные занятой.
// 
Процедура ЗаполнитьПустыеПоложения(Объект, ИменаПолей) Экспорт
	
	Поля = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаПолей, , , Истина);
	Для каждого Поле Из Поля Цикл
		Если НЕ ЗначениеЗаполнено(Объект[Поле]) Тогда
			Объект[Поле] = ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВШапке");
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СписокВидовОперацийДляОтбора(ЭлементыОтбораДинамическогоСписка)
	
	Результат = Новый СписокЗначений;
	
	Для Каждого ТекЭлементОтбора Из ЭлементыОтбораДинамическогоСписка Цикл
		
		Если Не ТекЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(ТекЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекЭлементОтбора.ЛевоеЗначение <> Новый ПолеКомпоновкиДанных("ВидОперации") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
			Результат.Добавить(ТекЭлементОтбора.ПравоеЗначение);
			Возврат Результат;
		КонецЕсли;
		
		Если ТекЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
			Результат.ЗагрузитьЗначения(ТекЭлементОтбора.ПравоеЗначение.ВыгрузитьЗначения());
			Возврат Результат;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти