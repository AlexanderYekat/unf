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
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗапасыПереданныеВРемонте.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыПереданныеВРемонтеИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыПереданныеВРемонтеИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияЗапасыПереданныеВРемонтеИзменение Тогда
		
		// Если временная таблица "ДвиженияЗапасыПереданныеВРемонтеИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияЗапасыПереданныеВРемонтеПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗапасыПереданныеВРемонте.НомерСтроки КАК НомерСтроки,
		|	ЗапасыПереданныеВРемонте.Номенклатура КАК Номенклатура,
		|	ЗапасыПереданныеВРемонте.Характеристика КАК Характеристика,
		|	ЗапасыПереданныеВРемонте.Серия КАК Серия,
		|	ЗапасыПереданныеВРемонте.СервисныйЦентр КАК СервисныйЦентр,
		|	ВЫБОР
		|		КОГДА ЗапасыПереданныеВРемонте.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыПереданныеВРемонте.Количество
		|		ИНАЧЕ -ЗапасыПереданныеВРемонте.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыПереданныеВРемонтеПередЗаписью
		|ИЗ
		|	РегистрНакопления.ЗапасыПереданныеВРемонте КАК ЗапасыПереданныеВРемонте
		|ГДЕ
		|	ЗапасыПереданныеВРемонте.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияЗапасыПереданныеВРемонтеИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияЗапасыПереданныеВРемонтеПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗапасыПереданныеВРемонтеИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияЗапасыПереданныеВРемонтеИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияЗапасыПереданныеВРемонтеИзменение.Характеристика КАК Характеристика,
		|	ДвиженияЗапасыПереданныеВРемонтеИзменение.Серия КАК Серия,
		|	ДвиженияЗапасыПереданныеВРемонтеИзменение.СервисныйЦентр КАК СервисныйЦентр,
		|	ДвиженияЗапасыПереданныеВРемонтеИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыПереданныеВРемонтеПередЗаписью
		|ИЗ
		|	ДвиженияЗапасыПереданныеВРемонтеИзменение КАК ДвиженияЗапасыПереданныеВРемонтеИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗапасыПереданныеВРемонте.НомерСтроки,
		|	ЗапасыПереданныеВРемонте.Номенклатура,
		|	ЗапасыПереданныеВРемонте.Характеристика,
		|	ЗапасыПереданныеВРемонте.Серия,
		|	ЗапасыПереданныеВРемонте.СервисныйЦентр,
		|	ВЫБОР
		|		КОГДА ЗапасыПереданныеВРемонте.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыПереданныеВРемонте.Количество
		|		ИНАЧЕ -ЗапасыПереданныеВРемонте.Количество
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ЗапасыПереданныеВРемонте КАК ЗапасыПереданныеВРемонте
		|ГДЕ
		|	ЗапасыПереданныеВРемонте.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияЗапасыПереданныеВРемонтеИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыПереданныеВРемонтеИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыПереданныеВРемонтеИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияЗапасыПереданныеВРемонтеИзменение");
	
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
	// и помещается во временную таблицу "ДвиженияЗапасыПереданныеВРемонтеИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияЗапасыПереданныеВРемонтеИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияЗапасыПереданныеВРемонтеИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияЗапасыПереданныеВРемонтеИзменение.Характеристика КАК Характеристика,
	|	ДвиженияЗапасыПереданныеВРемонтеИзменение.Серия КАК Серия,
	|	ДвиженияЗапасыПереданныеВРемонтеИзменение.СервисныйЦентр КАК СервисныйЦентр,
	|	СУММА(ДвиженияЗапасыПереданныеВРемонтеИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияЗапасыПереданныеВРемонтеИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияЗапасыПереданныеВРемонтеИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыПереданныеВРемонтеИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияЗапасыПереданныеВРемонтеПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияЗапасыПереданныеВРемонтеПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияЗапасыПереданныеВРемонтеПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияЗапасыПереданныеВРемонтеПередЗаписью.Серия КАК Серия,
	|		ДвиженияЗапасыПереданныеВРемонтеПередЗаписью.СервисныйЦентр КАК СервисныйЦентр,
	|		ДвиженияЗапасыПереданныеВРемонтеПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияЗапасыПереданныеВРемонтеПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи
	|	ИЗ
	|		ДвиженияЗапасыПереданныеВРемонтеПередЗаписью КАК ДвиженияЗапасыПереданныеВРемонтеПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияЗапасыПереданныеВРемонтеПриЗаписи.НомерСтроки,
	|		ДвиженияЗапасыПереданныеВРемонтеПриЗаписи.Номенклатура,
	|		ДвиженияЗапасыПереданныеВРемонтеПриЗаписи.Характеристика,
	|		ДвиженияЗапасыПереданныеВРемонтеПриЗаписи.Серия,
	|		ДвиженияЗапасыПереданныеВРемонтеПриЗаписи.СервисныйЦентр,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияЗапасыПереданныеВРемонтеПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияЗапасыПереданныеВРемонтеПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияЗапасыПереданныеВРемонтеПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияЗапасыПереданныеВРемонтеПриЗаписи.Количество
	|	ИЗ
	|		РегистрНакопления.ЗапасыПереданныеВРемонте КАК ДвиженияЗапасыПереданныеВРемонтеПриЗаписи
	|	ГДЕ
	|		ДвиженияЗапасыПереданныеВРемонтеПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияЗапасыПереданныеВРемонтеИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияЗапасыПереданныеВРемонтеИзменение.Номенклатура,
	|	ДвиженияЗапасыПереданныеВРемонтеИзменение.Характеристика,
	|	ДвиженияЗапасыПереданныеВРемонтеИзменение.Серия,
	|	ДвиженияЗапасыПереданныеВРемонтеИзменение.СервисныйЦентр
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияЗапасыПереданныеВРемонтеИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	СервисныйЦентр");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияЗапасыПереданныеВРемонтеИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыПереданныеВРемонтеИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияЗапасыПереданныеВРемонтеПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыПереданныеВРемонтеПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли