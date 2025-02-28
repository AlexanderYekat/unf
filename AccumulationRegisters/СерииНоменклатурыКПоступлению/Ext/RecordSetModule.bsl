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
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.СерииНоменклатурыКПоступлению.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияСерииНоменклатурыКПоступлениюИзменение")
			ИЛИ СтруктураВременныеТаблицы.Свойство("ДвиженияСерииНоменклатурыКПоступлениюИзменение")
			И НЕ СтруктураВременныеТаблицы.ДвиженияСерииНоменклатурыКПоступлениюИзменение Тогда

		// Если временная таблица "ДвиженияСерииНоменклатурыКПоступлениюИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		Запрос = Новый Запрос("ВЫБРАТЬ 
			|	СерииНоменклатурыКПоступлению.НомерСтроки КАК НомерСтроки,
			|	СерииНоменклатурыКПоступлению.Номенклатура КАК Номенклатура,
			|	СерииНоменклатурыКПоступлению.Характеристика КАК Характеристика,
			|	СерииНоменклатурыКПоступлению.Партия КАК Партия,
			|	СерииНоменклатурыКПоступлению.Серия КАК Серия,
			|	СерииНоменклатурыКПоступлению.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
			|	СерииНоменклатурыКПоступлению.Организация КАК Организация,
			|	СерииНоменклатурыКПоступлению.ДокументОснование КАК ДокументОснование,
			|	ВЫБОР
			|		КОГДА СерииНоменклатурыКПоступлению.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
			|			ТОГДА СерииНоменклатурыКПоступлению.Количество
			|		ИНАЧЕ -СерииНоменклатурыКПоступлению.Количество
			|	КОНЕЦ КАК КоличествоПередЗаписью
			|ПОМЕСТИТЬ ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью
			|ИЗ
			|	РегистрНакопления.СерииНоменклатурыКПоступлению КАК СерииНоменклатурыКПоступлению
			|ГДЕ
			|	СерииНоменклатурыКПоступлению.Регистратор = &Регистратор
			|	И &Замещение");

		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);

		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();

	Иначе

	// Если временная таблица "ДвиженияСерииНоменклатурыКПоступлениюИзменение" существует и содержит записи
	// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
	// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью",
	// чтобы при записи получить изменение нового набора относительно первоначального.
		Запрос = Новый Запрос("ВЫБРАТЬ 
			|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.НомерСтроки КАК НомерСтроки,
			|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Номенклатура КАК Номенклатура,
			|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Характеристика КАК Характеристика,
			|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Партия КАК Партия,
			|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Серия КАК Серия,
			|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
			|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Организация КАК Организация,
			|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.ДокументОснование КАК ДокументОснование,
			|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью
			|ПОМЕСТИТЬ ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью
			|ИЗ
			|	ДвиженияСерииНоменклатурыКПоступлениюИзменение КАК ДвиженияСерииНоменклатурыКПоступлениюИзменение
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	СерииНоменклатурыКПоступлению.НомерСтроки,
			|	СерииНоменклатурыКПоступлению.Номенклатура,
			|	СерииНоменклатурыКПоступлению.Характеристика,
			|	СерииНоменклатурыКПоступлению.Партия,
			|	СерииНоменклатурыКПоступлению.Серия,
			|	СерииНоменклатурыКПоступлению.СтруктурнаяЕдиница,
			|	СерииНоменклатурыКПоступлению.Организация,
			|	СерииНоменклатурыКПоступлению.ДокументОснование,
			|	ВЫБОР
			|		КОГДА СерииНоменклатурыКПоступлению.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
			|			ТОГДА СерииНоменклатурыКПоступлению.Количество
			|		ИНАЧЕ -СерииНоменклатурыКПоступлению.Количество
			|	КОНЕЦ
			|ИЗ
			|	РегистрНакопления.СерииНоменклатурыКПоступлению КАК СерииНоменклатурыКПоступлению
			|ГДЕ
			|	СерииНоменклатурыКПоступлению.Регистратор = &Регистратор
			|	И &Замещение");

		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);

		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();

	КонецЕсли;

	// Временная таблица "ДвиженияСерииНоменклатурыКПоступлениюИзменение" уничтожается
	// Удаляется информация о ее существовании.
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияСерииНоменклатурыКПоступлениюИзменение") Тогда

		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияСерииНоменклатурыКПоступлениюИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияСерииНоменклатурыКПоступлениюИзменение");

	КонецЕсли;
	
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
	// и помещается во временную таблицу "ДвиженияСерииНоменклатурыКПоступлениюИзменение".
	
	Запрос = Новый Запрос( 
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияСерииНоменклатурыКПоступлениюИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Характеристика КАК Характеристика,
	|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Партия КАК Партия,
	|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Серия КАК Серия,
	|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Организация КАК Организация,
	|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.ДокументОснование КАК ДокументОснование,
	|	СУММА(ДвиженияСерииНоменклатурыКПоступлениюИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияСерииНоменклатурыКПоступлениюИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияСерииНоменклатурыКПоступлениюИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияСерииНоменклатурыКПоступлениюИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью.Партия КАК Партия,
	|		ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью.Серия КАК Серия,
	|		ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью.Организация КАК Организация,
	|		ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью.ДокументОснование КАК ДокументОснование,
	|		ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи
	|	ИЗ
	|		ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью КАК ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ДвиженияСерииНоменклатурыКПоступлениюПриЗаписи.НомерСтроки,
	|		ДвиженияСерииНоменклатурыКПоступлениюПриЗаписи.Номенклатура,
	|		ДвиженияСерииНоменклатурыКПоступлениюПриЗаписи.Характеристика,
	|		ДвиженияСерииНоменклатурыКПоступлениюПриЗаписи.Партия,
	|		ДвиженияСерииНоменклатурыКПоступлениюПриЗаписи.Серия,
	|		ДвиженияСерииНоменклатурыКПоступлениюПриЗаписи.СтруктурнаяЕдиница,
	|		ДвиженияСерииНоменклатурыКПоступлениюПриЗаписи.Организация,
	|		ДвиженияСерииНоменклатурыКПоступлениюПриЗаписи.ДокументОснование,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияСерииНоменклатурыКПоступлениюПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияСерииНоменклатурыКПоступлениюПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияСерииНоменклатурыКПоступлениюПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияСерииНоменклатурыКПоступлениюПриЗаписи.Количество
	|	ИЗ
	|		РегистрНакопления.СерииНоменклатурыКПоступлению КАК ДвиженияСерииНоменклатурыКПоступлениюПриЗаписи
	|	ГДЕ
	|		ДвиженияСерииНоменклатурыКПоступлениюПриЗаписи.Регистратор = &Регистратор) КАК
	|		ДвиженияСерииНоменклатурыКПоступлениюИзменение
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Номенклатура,
	|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Характеристика,
	|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Партия,
	|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Серия,
	|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.СтруктурнаяЕдиница,
	|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.Организация,
	|	ДвиженияСерииНоменклатурыКПоступлениюИзменение.ДокументОснование
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияСерииНоменклатурыКПоступлениюИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Партия,
	|	Серия,
	|	СтруктурнаяЕдиница,
	|	Организация");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияСерииНоменклатурыКПоступлениюИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияСерииНоменклатурыКПоступлениюИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияСерииНоменклатурыКПоступлениюПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли