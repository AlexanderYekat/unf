﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Установка исключительной блокировки текущего набора записей регистратора.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗапасыНаСкладах.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыНаСкладахИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыНаСкладахИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияЗапасыНаСкладахИзменение Тогда
		
		// Если временная таблица "ДвиженияЗапасыНаСкладахИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияЗапасыНаСкладахПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗапасыНаСкладах.НомерСтроки КАК НомерСтроки,
		|	ЗапасыНаСкладах.Организация КАК Организация,
		|	ЗапасыНаСкладах.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ЗапасыНаСкладах.Номенклатура КАК Номенклатура,
		|	ЗапасыНаСкладах.Характеристика КАК Характеристика,
		|	ЗапасыНаСкладах.Партия КАК Партия,
		|	ЗапасыНаСкладах.Ячейка КАК Ячейка,
		|	ВЫБОР
		|		КОГДА ЗапасыНаСкладах.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыНаСкладах.Количество
		|		ИНАЧЕ -ЗапасыНаСкладах.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыНаСкладахПередЗаписью
		|ИЗ
		|	РегистрНакопления.ЗапасыНаСкладах КАК ЗапасыНаСкладах
		|ГДЕ
		|	ЗапасыНаСкладах.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияЗапасыНаСкладахИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияЗапасыНаСкладахПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗапасыНаСкладахИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияЗапасыНаСкладахИзменение.Организация КАК Организация,
		|	ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ДвиженияЗапасыНаСкладахИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияЗапасыНаСкладахИзменение.Характеристика КАК Характеристика,
		|	ДвиженияЗапасыНаСкладахИзменение.Партия КАК Партия,
		|	ДвиженияЗапасыНаСкладахИзменение.Ячейка КАК Ячейка,
		|	ДвиженияЗапасыНаСкладахИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыНаСкладахПередЗаписью
		|ИЗ
		|	ДвиженияЗапасыНаСкладахИзменение КАК ДвиженияЗапасыНаСкладахИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗапасыНаСкладах.НомерСтроки,
		|	ЗапасыНаСкладах.Организация,
		|	ЗапасыНаСкладах.СтруктурнаяЕдиница,
		|	ЗапасыНаСкладах.Номенклатура,
		|	ЗапасыНаСкладах.Характеристика,
		|	ЗапасыНаСкладах.Партия,
		|	ЗапасыНаСкладах.Ячейка,
		|	ВЫБОР
		|		КОГДА ЗапасыНаСкладах.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыНаСкладах.Количество
		|		ИНАЧЕ -ЗапасыНаСкладах.Количество
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ЗапасыНаСкладах КАК ЗапасыНаСкладах
		|ГДЕ
		|	ЗапасыНаСкладах.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияЗапасыНаСкладахИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыНаСкладахИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыНаСкладахИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияЗапасыНаСкладахИзменение");
	
	КонецЕсли;
	
	// Хозяйственная операция
	ХозяйственныеОперацииСервер.ЗаполнитьХозяйственнуюОперациюВНабореЗаписей(ЭтотОбъект);
	// Конец Хозяйственная операция
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ПриЗаписи набора записей.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу "ДвиженияЗапасыНаСкладахИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияЗапасыНаСкладахИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияЗапасыНаСкладахИзменение.Организация КАК Организация,
	|	ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ДвиженияЗапасыНаСкладахИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияЗапасыНаСкладахИзменение.Характеристика КАК Характеристика,
	|	ДвиженияЗапасыНаСкладахИзменение.Партия КАК Партия,
	|	ДвиженияЗапасыНаСкладахИзменение.Ячейка КАК Ячейка,
	|	СУММА(ДвиженияЗапасыНаСкладахИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияЗапасыНаСкладахИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияЗапасыНаСкладахИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыНаСкладахИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияЗапасыНаСкладахПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияЗапасыНаСкладахПередЗаписью.Организация КАК Организация,
	|		ДвиженияЗапасыНаСкладахПередЗаписью.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		ДвиженияЗапасыНаСкладахПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияЗапасыНаСкладахПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияЗапасыНаСкладахПередЗаписью.Партия КАК Партия,
	|		ДвиженияЗапасыНаСкладахПередЗаписью.Ячейка КАК Ячейка,
	|		ДвиженияЗапасыНаСкладахПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияЗапасыНаСкладахПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи
	|	ИЗ
	|		ДвиженияЗапасыНаСкладахПередЗаписью КАК ДвиженияЗапасыНаСкладахПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияЗапасыНаСкладахПриЗаписи.НомерСтроки,
	|		ДвиженияЗапасыНаСкладахПриЗаписи.Организация,
	|		ДвиженияЗапасыНаСкладахПриЗаписи.СтруктурнаяЕдиница,
	|		ДвиженияЗапасыНаСкладахПриЗаписи.Номенклатура,
	|		ДвиженияЗапасыНаСкладахПриЗаписи.Характеристика,
	|		ДвиженияЗапасыНаСкладахПриЗаписи.Партия,
	|		ДвиженияЗапасыНаСкладахПриЗаписи.Ячейка,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияЗапасыНаСкладахПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияЗапасыНаСкладахПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияЗапасыНаСкладахПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияЗапасыНаСкладахПриЗаписи.Количество
	|	ИЗ
	|		РегистрНакопления.ЗапасыНаСкладах КАК ДвиженияЗапасыНаСкладахПриЗаписи
	|	ГДЕ
	|		ДвиженияЗапасыНаСкладахПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияЗапасыНаСкладахИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияЗапасыНаСкладахИзменение.Организация,
	|	ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница,
	|	ДвиженияЗапасыНаСкладахИзменение.Номенклатура,
	|	ДвиженияЗапасыНаСкладахИзменение.Характеристика,
	|	ДвиженияЗапасыНаСкладахИзменение.Партия,
	|	ДвиженияЗапасыНаСкладахИзменение.Ячейка
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияЗапасыНаСкладахИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	СтруктурнаяЕдиница,
	|	Номенклатура,
	|	Характеристика,
	|	Партия,
	|	Ячейка");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияЗапасыНаСкладахИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыНаСкладахИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияЗапасыНаСкладахПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыНаСкладахПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	// Расчет быстрых остатков для списка номенклатуры
	Если ТипЗнч(Отбор.Регистратор.Значение) = Тип("ДокументСсылка.ПриходныйОрдер")
		Или ТипЗнч(Отбор.Регистратор.Значение) = Тип("ДокументСсылка.РасходныйОрдер") Тогда
		РегистрыСведений.ОстаткиТоваров.РассчитатьОстатокТовараДляБыстрогоОтображения(ДополнительныеСвойства, ВыборкаИзРезультатаЗапроса.Количество);
	КонецЕсли;
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли