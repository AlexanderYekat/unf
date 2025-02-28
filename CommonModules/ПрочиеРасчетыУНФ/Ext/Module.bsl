﻿
#Область ПрограммныйИнтерфейс

// Выполняет движения регистра накопления РасчетыСПрочимиКонтрагентами.
//
// Параметры:
//   ДополнительныеСвойства - Структура - Структура содержащая временные таблицы для помещения в движения документа
//   Движения - КоллекцияДвижений - Коллекция движений для помещения данных
//   Отказ - Булево - Признак отмены проведения документа
//
Процедура ОтразитьРасчетыСПрочимиКонтрагентами(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаРасчетыСПрочимиКонтрагентами = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРасчетыСПрочимиКонтрагентами;
	
	Если Отказ
	 ИЛИ ТаблицаРасчетыСПрочимиКонтрагентами.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияРасчетыСПрочимиКонтрагентами = Движения.РасчетыСПрочимиКонтрагентами;
	ДвиженияРасчетыСПрочимиКонтрагентами.Записывать = Истина;
	ДвиженияРасчетыСПрочимиКонтрагентами.Загрузить(ТаблицаРасчетыСПрочимиКонтрагентами);
	
КонецПроцедуры

// Выполняет движения регистра накопления РасчетыПоКредитамИЗаймам.
//
// Параметры:
//   ДополнительныеСвойства - Структура - Структура содержащая временные таблицы для помещения в движения документа
//   Движения - КоллекцияДвижений - Коллекция движений для помещения данных
//   Отказ - Булево - Признак отмены проведения документа
//
Процедура ОтразитьРасчетыПоКредитамИЗаймам(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаРасчетыПоКредитамИЗаймам = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРасчетыПоКредитамИЗаймам;
	
	Если Отказ
	 ИЛИ ТаблицаРасчетыПоКредитамИЗаймам.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияРасчетыПоКредитамИЗаймам = Движения.РасчетыПоКредитамИЗаймам;
	ДвиженияРасчетыПоКредитамИЗаймам.Записывать = Истина;
	ДвиженияРасчетыПоКредитамИЗаймам.Загрузить(ТаблицаРасчетыПоКредитамИЗаймам);
	
КонецПроцедуры

// Выполняет движения регистра сведений ГрафикПогашенияКредитовИЗаймов.
//
// Параметры:
//   ДополнительныеСвойства - Структура - Структура содержащая временные таблицы для помещения в движения документа
//   Движения - КоллекцияДвижений - Коллекция движений для помещения данных
//   Отказ - Булево - Признак отмены проведения документа
//
Процедура ОтразитьГрафикПогашенияКредитовИЗаймов(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаГрафикПогашенияКредитовИЗаймов = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаГрафикПогашенияКредитовИЗаймов;
	
	Если Отказ
	 ИЛИ ТаблицаГрафикПогашенияКредитовИЗаймов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияГрафикПогашенияКредитовИЗаймов = Движения.ГрафикПогашенияКредитовИЗаймов;
	ДвиженияГрафикПогашенияКредитовИЗаймов.Записывать = Истина;
	ДвиженияГрафикПогашенияКредитовИЗаймов.Загрузить(ТаблицаГрафикПогашенияКредитовИЗаймов);
	
КонецПроцедуры

#КонецОбласти
