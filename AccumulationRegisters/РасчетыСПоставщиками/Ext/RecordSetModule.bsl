﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("КонтрагентыСИзмененнымиВзаиморасчетами", КонтрагентыСИзмененнымиВзаиморасчетами());
	
	Если Не ДополнительныеСвойства.Свойство("ДляПроведения")
		Или Не ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Установка исключительной блокировки текущего набора записей регистратора.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.РасчетыСПоставщиками.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияРасчетыСПоставщикамиИзменение")
		ИЛИ СтруктураВременныеТаблицы.Свойство("ДвиженияРасчетыСПоставщикамиИзменение")
	   И НЕ СтруктураВременныеТаблицы.ДвиженияРасчетыСПоставщикамиИзменение Тогда
		
		// Если временная таблица "ДвиженияРасчетыСПоставщикамиИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияРасчетыСПоставщикамиПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РегистрНакопленияРасчетыСПоставщиками.НомерСтроки КАК НомерСтроки,
		|	РегистрНакопленияРасчетыСПоставщиками.Организация КАК Организация,
		|	РегистрНакопленияРасчетыСПоставщиками.Контрагент КАК Контрагент,
		|	РегистрНакопленияРасчетыСПоставщиками.Договор КАК Договор,
		|	РегистрНакопленияРасчетыСПоставщиками.Документ КАК Документ,
		|	РегистрНакопленияРасчетыСПоставщиками.Заказ КАК Заказ,
		|	РегистрНакопленияРасчетыСПоставщиками.ТипРасчетов КАК ТипРасчетов,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияРасчетыСПоставщиками.Сумма
		|		ИНАЧЕ -РегистрНакопленияРасчетыСПоставщиками.Сумма
		|	КОНЕЦ КАК СуммаПередЗаписью,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияРасчетыСПоставщиками.СуммаВал
		|		ИНАЧЕ -РегистрНакопленияРасчетыСПоставщиками.СуммаВал
		|	КОНЕЦ КАК СуммаВалПередЗаписью
		|ПОМЕСТИТЬ ДвиженияРасчетыСПоставщикамиПередЗаписью
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщиками КАК РегистрНакопленияРасчетыСПоставщиками
		|ГДЕ
		|	РегистрНакопленияРасчетыСПоставщиками.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияРасчетыСПоставщикамиИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияРасчетыСПоставщикамиПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияРасчетыСПоставщикамиИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияРасчетыСПоставщикамиИзменение.Организация КАК Организация,
		|	ДвиженияРасчетыСПоставщикамиИзменение.Контрагент КАК Контрагент,
		|	ДвиженияРасчетыСПоставщикамиИзменение.Договор КАК Договор,
		|	ДвиженияРасчетыСПоставщикамиИзменение.Документ КАК Документ,
		|	ДвиженияРасчетыСПоставщикамиИзменение.Заказ КАК Заказ,
		|	ДвиженияРасчетыСПоставщикамиИзменение.ТипРасчетов КАК ТипРасчетов,
		|	ДвиженияРасчетыСПоставщикамиИзменение.СуммаПередЗаписью КАК СуммаПередЗаписью,
		|	ДвиженияРасчетыСПоставщикамиИзменение.СуммаВалПередЗаписью КАК СуммаВалПередЗаписью
		|ПОМЕСТИТЬ ДвиженияРасчетыСПоставщикамиПередЗаписью
		|ИЗ
		|	ДвиженияРасчетыСПоставщикамиИзменение КАК ДвиженияРасчетыСПоставщикамиИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РегистрНакопленияРасчетыСПоставщиками.НомерСтроки,
		|	РегистрНакопленияРасчетыСПоставщиками.Организация,
		|	РегистрНакопленияРасчетыСПоставщиками.Контрагент,
		|	РегистрНакопленияРасчетыСПоставщиками.Договор,
		|	РегистрНакопленияРасчетыСПоставщиками.Документ,
		|	РегистрНакопленияРасчетыСПоставщиками.Заказ,
		|	РегистрНакопленияРасчетыСПоставщиками.ТипРасчетов,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияРасчетыСПоставщиками.Сумма
		|		ИНАЧЕ -РегистрНакопленияРасчетыСПоставщиками.Сумма
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияРасчетыСПоставщиками.СуммаВал
		|		ИНАЧЕ -РегистрНакопленияРасчетыСПоставщиками.СуммаВал
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщиками КАК РегистрНакопленияРасчетыСПоставщиками
		|ГДЕ
		|	РегистрНакопленияРасчетыСПоставщиками.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияРасчетыСПоставщикамиИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияРасчетыСПоставщикамиИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияРасчетыСПоставщикамиИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияРасчетыСПоставщикамиИзменение");
	
	КонецЕсли;
	
	// Хозяйственная операция
	ХозяйственныеОперацииСервер.ЗаполнитьХозяйственнуюОперациюВНабореЗаписей(ЭтотОбъект);
	// Конец Хозяйственная операция
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("КонтрагентыСИзмененнымиВзаиморасчетами") Тогда
		РегистрыСведений.ОстаткиВзаиморасчетов.ОбновитьОстаткиВзаиморасчетов(ДополнительныеСвойства.КонтрагентыСИзмененнымиВзаиморасчетами);
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("ДляПроведения")
		Или Не ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу "ДвиженияРасчетыСПоставщикамиИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияРасчетыСПоставщикамиИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияРасчетыСПоставщикамиИзменение.Организация КАК Организация,
	|	ДвиженияРасчетыСПоставщикамиИзменение.Контрагент КАК Контрагент,
	|	ДвиженияРасчетыСПоставщикамиИзменение.Договор КАК Договор,
	|	ДвиженияРасчетыСПоставщикамиИзменение.Документ КАК Документ,
	|	ДвиженияРасчетыСПоставщикамиИзменение.Заказ КАК Заказ,
	|	ДвиженияРасчетыСПоставщикамиИзменение.ТипРасчетов КАК ТипРасчетов,
	|	СУММА(ДвиженияРасчетыСПоставщикамиИзменение.СуммаПередЗаписью) КАК СуммаПередЗаписью,
	|	СУММА(ДвиженияРасчетыСПоставщикамиИзменение.СуммаИзменение) КАК СуммаИзменение,
	|	СУММА(ДвиженияРасчетыСПоставщикамиИзменение.СуммаПриЗаписи) КАК СуммаПриЗаписи,
	|	СУММА(ДвиженияРасчетыСПоставщикамиИзменение.СуммаВалПередЗаписью) КАК СуммаВалПередЗаписью,
	|	СУММА(ДвиженияРасчетыСПоставщикамиИзменение.СуммаВалИзменение) КАК СуммаВалИзменение,
	|	СУММА(ДвиженияРасчетыСПоставщикамиИзменение.СуммаВалПриЗаписи) КАК СуммаВалПриЗаписи
	|ПОМЕСТИТЬ ДвиженияРасчетыСПоставщикамиИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияРасчетыСПоставщикамиПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияРасчетыСПоставщикамиПередЗаписью.Организация КАК Организация,
	|		ДвиженияРасчетыСПоставщикамиПередЗаписью.Контрагент КАК Контрагент,
	|		ДвиженияРасчетыСПоставщикамиПередЗаписью.Договор КАК Договор,
	|		ДвиженияРасчетыСПоставщикамиПередЗаписью.Документ КАК Документ,
	|		ДвиженияРасчетыСПоставщикамиПередЗаписью.Заказ КАК Заказ,
	|		ДвиженияРасчетыСПоставщикамиПередЗаписью.ТипРасчетов КАК ТипРасчетов,
	|		ДвиженияРасчетыСПоставщикамиПередЗаписью.СуммаПередЗаписью КАК СуммаПередЗаписью,
	|		ДвиженияРасчетыСПоставщикамиПередЗаписью.СуммаПередЗаписью КАК СуммаИзменение,
	|		0 КАК СуммаПриЗаписи,
	|		ДвиженияРасчетыСПоставщикамиПередЗаписью.СуммаВалПередЗаписью КАК СуммаВалПередЗаписью,
	|		ДвиженияРасчетыСПоставщикамиПередЗаписью.СуммаВалПередЗаписью КАК СуммаВалИзменение,
	|		0 КАК СуммаВалПриЗаписи
	|	ИЗ
	|		ДвиженияРасчетыСПоставщикамиПередЗаписью КАК ДвиженияРасчетыСПоставщикамиПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияРасчетыСПоставщикамиПриЗаписи.НомерСтроки,
	|		ДвиженияРасчетыСПоставщикамиПриЗаписи.Организация,
	|		ДвиженияРасчетыСПоставщикамиПриЗаписи.Контрагент,
	|		ДвиженияРасчетыСПоставщикамиПриЗаписи.Договор,
	|		ДвиженияРасчетыСПоставщикамиПриЗаписи.Документ,
	|		ДвиженияРасчетыСПоставщикамиПриЗаписи.Заказ,
	|		ДвиженияРасчетыСПоставщикамиПриЗаписи.ТипРасчетов,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияРасчетыСПоставщикамиПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияРасчетыСПоставщикамиПриЗаписи.Сумма
	|			ИНАЧЕ ДвиженияРасчетыСПоставщикамиПриЗаписи.Сумма
	|		КОНЕЦ,
	|		ДвиженияРасчетыСПоставщикамиПриЗаписи.Сумма,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияРасчетыСПоставщикамиПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияРасчетыСПоставщикамиПриЗаписи.СуммаВал
	|			ИНАЧЕ ДвиженияРасчетыСПоставщикамиПриЗаписи.СуммаВал
	|		КОНЕЦ,
	|		ДвиженияРасчетыСПоставщикамиПриЗаписи.СуммаВал
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками КАК ДвиженияРасчетыСПоставщикамиПриЗаписи
	|	ГДЕ
	|		ДвиженияРасчетыСПоставщикамиПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияРасчетыСПоставщикамиИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияРасчетыСПоставщикамиИзменение.Организация,
	|	ДвиженияРасчетыСПоставщикамиИзменение.Контрагент,
	|	ДвиженияРасчетыСПоставщикамиИзменение.Договор,
	|	ДвиженияРасчетыСПоставщикамиИзменение.Документ,
	|	ДвиженияРасчетыСПоставщикамиИзменение.Заказ,
	|	ДвиженияРасчетыСПоставщикамиИзменение.ТипРасчетов
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ДвиженияРасчетыСПоставщикамиИзменение.СуммаИзменение) <> 0
	|		ИЛИ СУММА(ДвиженияРасчетыСПоставщикамиИзменение.СуммаВалИзменение) <> 0)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Контрагент,
	|	Договор,
	|	Документ,
	|	Заказ,
	|	ТипРасчетов");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияРасчетыСПоставщикамиИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияРасчетыСПоставщикамиИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияРасчетыСПоставщикамиПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияРасчетыСПоставщикамиПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	РасчетыПроведениеДокументов.ОбновитьСуммыВНациональнойВалюте(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КонтрагентыСИзмененнымиВзаиморасчетами()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РасчетыСПоставщиками.Контрагент КАК Контрагент
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщиками КАК РасчетыСПоставщиками
		|ГДЕ
		|	РасчетыСПоставщиками.Регистратор = &Регистратор";
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	КонтрагентыПрошлогоНабора = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Контрагент");
	КонтрагентыТекущегоНабора = ВыгрузитьКолонку("Контрагент");
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(КонтрагентыПрошлогоНабора, КонтрагентыТекущегоНабора, Истина);
	
	Возврат КонтрагентыПрошлогоНабора;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли