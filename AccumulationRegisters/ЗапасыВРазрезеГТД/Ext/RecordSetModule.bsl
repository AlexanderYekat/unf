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
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗапасыВРазрезеГТД.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыВРазрезеГТДИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыВРазрезеГТДИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияЗапасыВРазрезеГТДИзменение Тогда
		
		// Если временная таблица "ДвиженияЗапасыВРазрезеГТДИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияЗапасыВРазрезеГТДПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗапасыВРазрезеГТД.НомерСтроки КАК НомерСтроки,
		|	ЗапасыВРазрезеГТД.Организация КАК Организация,
		|	ЗапасыВРазрезеГТД.СтранаПроисхождения КАК СтранаПроисхождения,
		|	ЗапасыВРазрезеГТД.Номенклатура КАК Номенклатура,
		|	ЗапасыВРазрезеГТД.Характеристика КАК Характеристика,
		|	ЗапасыВРазрезеГТД.Партия КАК Партия,
		|	ЗапасыВРазрезеГТД.НомерГТД КАК НомерГТД,
		|	ВЫБОР
		|		КОГДА ЗапасыВРазрезеГТД.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыВРазрезеГТД.Количество
		|		ИНАЧЕ -ЗапасыВРазрезеГТД.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыВРазрезеГТДПередЗаписью
		|ИЗ
		|	РегистрНакопления.ЗапасыВРазрезеГТД КАК ЗапасыВРазрезеГТД
		|ГДЕ
		|	ЗапасыВРазрезеГТД.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияЗапасыВРазрезеГТДИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияЗапасыВРазрезеГТДПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗапасыВРазрезеГТДИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияЗапасыВРазрезеГТДИзменение.Организация КАК Организация,
		|	ДвиженияЗапасыВРазрезеГТДИзменение.СтранаПроисхождения КАК СтранаПроисхождения,
		|	ДвиженияЗапасыВРазрезеГТДИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияЗапасыВРазрезеГТДИзменение.Характеристика КАК Характеристика,
		|	ДвиженияЗапасыВРазрезеГТДИзменение.Партия КАК Партия,
		|	ДвиженияЗапасыВРазрезеГТДИзменение.НомерГТД КАК НомерГТД,
		|	ДвиженияЗапасыВРазрезеГТДИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыВРазрезеГТДПередЗаписью
		|ИЗ
		|	ДвиженияЗапасыВРазрезеГТДИзменение КАК ДвиженияЗапасыВРазрезеГТДИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗапасыВРазрезеГТД.НомерСтроки,
		|	ЗапасыВРазрезеГТД.Организация,
		|	ЗапасыВРазрезеГТД.СтранаПроисхождения,
		|	ЗапасыВРазрезеГТД.Номенклатура,
		|	ЗапасыВРазрезеГТД.Характеристика,
		|	ЗапасыВРазрезеГТД.Партия,
		|	ЗапасыВРазрезеГТД.НомерГТД,
		|	ВЫБОР
		|		КОГДА ЗапасыВРазрезеГТД.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыВРазрезеГТД.Количество
		|		ИНАЧЕ -ЗапасыВРазрезеГТД.Количество
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ЗапасыВРазрезеГТД КАК ЗапасыВРазрезеГТД
		|ГДЕ
		|	ЗапасыВРазрезеГТД.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияЗапасыВРазрезеГТДИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыВРазрезеГТДИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыВРазрезеГТДИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияЗапасыВРазрезеГТДИзменение");
	
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
	// и помещается во временную таблицу "ДвиженияЗапасыВРазрезеГТДИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияЗапасыВРазрезеГТДИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияЗапасыВРазрезеГТДИзменение.Организация КАК Организация,
	|	ДвиженияЗапасыВРазрезеГТДИзменение.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ДвиженияЗапасыВРазрезеГТДИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияЗапасыВРазрезеГТДИзменение.Характеристика КАК Характеристика,
	|	ДвиженияЗапасыВРазрезеГТДИзменение.Партия КАК Партия,
	|	ДвиженияЗапасыВРазрезеГТДИзменение.НомерГТД КАК НомерГТД,
	|	СУММА(ДвиженияЗапасыВРазрезеГТДИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияЗапасыВРазрезеГТДИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияЗапасыВРазрезеГТДИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыВРазрезеГТДИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияЗапасыВРазрезеГТДПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияЗапасыВРазрезеГТДПередЗаписью.Организация КАК Организация,
	|		ДвиженияЗапасыВРазрезеГТДПередЗаписью.СтранаПроисхождения КАК СтранаПроисхождения,
	|		ДвиженияЗапасыВРазрезеГТДПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияЗапасыВРазрезеГТДПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияЗапасыВРазрезеГТДПередЗаписью.Партия КАК Партия,
	|		ДвиженияЗапасыВРазрезеГТДПередЗаписью.НомерГТД КАК НомерГТД,
	|		ДвиженияЗапасыВРазрезеГТДПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияЗапасыВРазрезеГТДПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи
	|	ИЗ
	|		ДвиженияЗапасыВРазрезеГТДПередЗаписью КАК ДвиженияЗапасыВРазрезеГТДПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияЗапасыВРазрезеГТДПриЗаписи.НомерСтроки,
	|		ДвиженияЗапасыВРазрезеГТДПриЗаписи.Организация,
	|		ДвиженияЗапасыВРазрезеГТДПриЗаписи.СтранаПроисхождения,
	|		ДвиженияЗапасыВРазрезеГТДПриЗаписи.Номенклатура,
	|		ДвиженияЗапасыВРазрезеГТДПриЗаписи.Характеристика,
	|		ДвиженияЗапасыВРазрезеГТДПриЗаписи.Партия,
	|		ДвиженияЗапасыВРазрезеГТДПриЗаписи.НомерГТД,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияЗапасыВРазрезеГТДПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияЗапасыВРазрезеГТДПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияЗапасыВРазрезеГТДПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияЗапасыВРазрезеГТДПриЗаписи.Количество
	|	ИЗ
	|		РегистрНакопления.ЗапасыВРазрезеГТД КАК ДвиженияЗапасыВРазрезеГТДПриЗаписи
	|	ГДЕ
	|		ДвиженияЗапасыВРазрезеГТДПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияЗапасыВРазрезеГТДИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияЗапасыВРазрезеГТДИзменение.Организация,
	|	ДвиженияЗапасыВРазрезеГТДИзменение.СтранаПроисхождения,
	|	ДвиженияЗапасыВРазрезеГТДИзменение.Номенклатура,
	|	ДвиженияЗапасыВРазрезеГТДИзменение.Характеристика,
	|	ДвиженияЗапасыВРазрезеГТДИзменение.Партия,
	|	ДвиженияЗапасыВРазрезеГТДИзменение.НомерГТД
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияЗапасыВРазрезеГТДИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	СтранаПроисхождения,
	|	Номенклатура,
	|	Характеристика,
	|	Партия,
	|	НомерГТД");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияЗапасыВРазрезеГТДИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыВРазрезеГТДИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияЗапасыВРазрезеГТДПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыВРазрезеГТДПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли