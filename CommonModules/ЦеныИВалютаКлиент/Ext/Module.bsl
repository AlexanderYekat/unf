﻿
#Область ПрограммныйИнтерфейс

// Задает пользователю вопрос об установке курса расчетов с соответствии с курсом валюты.
// 
// Параметры:
//  ВалютаКурсКратность - см. РаботаСКурсамиВалют.ПолучитьКурсВалюты
//  Объект - ДанныеФормыСтруктура - объект, для которого требуется пересчет курса
//  Форма - ФормаКлиентскогоПриложения - форма, для которой требуется пересчет курса
Процедура ПересчитатьКурсКратностьВалютыРасчетов(ВалютаКурсКратность, Объект, Форма) Экспорт
	
	ДанныеВалют = ДанныеВалют(Форма);
	
	Если Не ЗначениеЗаполнено(ДанныеВалют.ВалютаРасчетов) Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Курс = ВалютаКурсКратность.Курс И Объект.Кратность = ВалютаКурсКратность.Кратность Тогда
		Возврат;
	КонецЕсли;

	ПараметрыВопроса = НовыеПараметрыВопроса(ВалютаКурсКратность, Объект, Форма, ДанныеВалют);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьОтветОПересчетеКурсаВалюты",
		ЭтотОбъект, ПараметрыВопроса);
	
	ШаблонПредставленияВалюты = "%1 %2 = %3 %4";
	КурсВалютыСтрокой = СтрШаблон(ШаблонПредставленияВалюты, Объект.Кратность, СокрЛП(ДанныеВалют.ВалютаРасчетов),
		Объект.Курс, СокрЛП(ДанныеВалют.НациональнаяВалюта));
	КурсНовыйВалютыСтрокой = СтрШаблон(ШаблонПредставленияВалюты, ПараметрыВопроса.КратностьНовый,
		СокрЛП(ДанныеВалют.ВалютаРасчетов), ПараметрыВопроса.КурсНовый, СокрЛП(ДанныеВалют.НациональнаяВалюта));
	
	ТекстВопроса = СтрШаблон(НСтр(
		"ru = 'На дату документа у валюты расчетов (%1) был задан курс.
		|Установить курс расчетов (%2) в соответствии с курсом валюты?'"), КурсВалютыСтрокой, КурсНовыйВалютыСтрокой);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

// Новые параметры вопроса.
// 
// Параметры:
//  ВалютаКурсКратность - см. РаботаСКурсамиВалют.ПолучитьКурсВалюты
//  Объект - ДанныеФормыСтруктура - объект, для которого требуется пересчет курса
//  Форма - ФормаКлиентскогоПриложения - форма, для которой требуется пересчет курса
//  ДанныеВалют - см. ДанныеВалют
// 
// Возвращаемое значение:
//  Структура - Новые параметры вопроса:
//   * КурсНовый - Число - новое значение курса
//   * КратностьНовый - Число - новое значение кратности
//   * Объект - ДанныеФормыСтруктура - объект, для которого требуется пересчет курса
//   * Форма - ФормаКлиентскогоПриложения - форма, для которой требуется пересчет курса
//   * ДанныеВалют - см. ДанныеВалют
Функция НовыеПараметрыВопроса(ВалютаКурсКратность, Объект, Форма, ДанныеВалют) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("КурсНовый", 1);
	Результат.Вставить("КратностьНовый", 1);
	Результат.Вставить("Объект", Объект);
	Результат.Вставить("Форма", Форма);
	Результат.Вставить("ДанныеВалют", ДанныеВалют);
	
	Если ЗначениеЗаполнено(ВалютаКурсКратность.Курс) Тогда
		Результат.КурсНовый = ВалютаКурсКратность.Курс;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВалютаКурсКратность.Кратность) Тогда
		Результат.КратностьНовый = ВалютаКурсКратность.Кратность;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обработать ответ о пересчете курса валюты.
// 
// Параметры:
//  Результат - КодВозвратаДиалога
//  Параметры - см. НовыеПараметрыВопроса
Процедура ОбработатьОтветОПересчетеКурсаВалюты(Результат, Параметры) Экспорт

	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Объект.Курс = Параметры.КурсНовый;
	Параметры.Объект.Кратность = Параметры.КратностьНовый;
	
	ПересчитатьПредоплату(Параметры, "Предоплата");
	ПересчитатьПредоплату(Параметры, "ПредоплатаПолучатель");
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Параметры.Форма, "ЦеныИВалюта") Тогда
		Параметры.Форма.ЦеныИВалюта = ЦеныИВалютаКлиентСервер.ТекстНадписиЦеныИВалюта(Параметры.Объект,
			Параметры.ДанныеВалют.ВалютаРасчетов, Параметры.ДанныеВалют.КурсНациональнаяВалюта,
			Параметры.ДанныеВалют.УчетВалютныхОпераций);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеВалют(Форма)
	
	Результат = Новый Структура;
	Результат.Вставить("ВалютаДокумента", ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	Результат.Вставить("ВалютаРасчетов", ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	Результат.Вставить("НациональнаяВалюта", ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	Результат.Вставить("КурсНациональнаяВалюта", 1);
	Результат.Вставить("КратностьНациональнаяВалюта", 1);
	Результат.Вставить("УчетВалютныхОпераций", Ложь);
	
	ЗаполнитьЗначенияСвойств(Результат, Форма);
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "КэшЗначений") Тогда
		ЗаполнитьЗначенияСвойств(Результат, Форма.КэшЗначений);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПересчитатьПредоплату(Параметры, ИмяТабличнойЧастиПредоплата)
	
	Если Не Параметры.Объект.Свойство(ИмяТабличнойЧастиПредоплата) Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Объект.ВалютаДокумента = Параметры.ДанныеВалют.НациональнаяВалюта Тогда
		КурсКон = Параметры.ДанныеВалют.КурсНациональнаяВалюта;
		КратностьКон = Параметры.ДанныеВалют.КратностьНациональнаяВалюта;
	Иначе
		КурсКон = Параметры.Объект.Курс;
		КратностьКон = Параметры.Объект.Кратность;
	КонецЕсли;
	
	Для Каждого СтрокаТабличнойЧасти Из Параметры.Объект[ИмяТабличнойЧастиПредоплата] Цикл
		СтрокаТабличнойЧасти.СуммаПлатежа = ВалютыУНФКлиентСервер.Пересчитать(СтрокаТабличнойЧасти.СуммаРасчетов,
			СтрокаТабличнойЧасти.Курс, КурсКон, СтрокаТабличнойЧасти.Кратность, КратностьКон);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
