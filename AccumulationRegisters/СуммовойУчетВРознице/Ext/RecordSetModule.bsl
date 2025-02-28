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
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.СуммовойУчетВРознице.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияСуммовойУчетВРозницеИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияСуммовойУчетВРозницеИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияСуммовойУчетВРозницеИзменение Тогда
		
		// Если временная таблица "ДвиженияСуммовойУчетВРозницеИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияСуммовойУчетВРозницеПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РегистрНакопленияСуммовойУчетВРознице.НомерСтроки КАК НомерСтроки,
		|	РегистрНакопленияСуммовойУчетВРознице.Организация КАК Организация,
		|	РегистрНакопленияСуммовойУчетВРознице.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	РегистрНакопленияСуммовойУчетВРознице.Валюта КАК Валюта,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияСуммовойУчетВРознице.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияСуммовойУчетВРознице.Сумма
		|		ИНАЧЕ -РегистрНакопленияСуммовойУчетВРознице.Сумма
		|	КОНЕЦ КАК СуммаПередЗаписью,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияСуммовойУчетВРознице.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияСуммовойУчетВРознице.СуммаВал
		|		ИНАЧЕ -РегистрНакопленияСуммовойУчетВРознице.СуммаВал
		|	КОНЕЦ КАК СуммаВалПередЗаписью,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияСуммовойУчетВРознице.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияСуммовойУчетВРознице.Себестоимость
		|		ИНАЧЕ -РегистрНакопленияСуммовойУчетВРознице.Себестоимость
		|	КОНЕЦ КАК СебестоимостьПередЗаписью
		|ПОМЕСТИТЬ ДвиженияСуммовойУчетВРозницеПередЗаписью
		|ИЗ
		|	РегистрНакопления.СуммовойУчетВРознице КАК РегистрНакопленияСуммовойУчетВРознице
		|ГДЕ
		|	РегистрНакопленияСуммовойУчетВРознице.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияСуммовойУчетВРозницеИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияСуммовойУчетВРозницеПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияСуммовойУчетВРозницеИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияСуммовойУчетВРозницеИзменение.Организация КАК Организация,
		|	ДвиженияСуммовойУчетВРозницеИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ДвиженияСуммовойУчетВРозницеИзменение.Валюта КАК Валюта,
		|	ДвиженияСуммовойУчетВРозницеИзменение.СуммаПередЗаписью КАК СуммаПередЗаписью,
		|	ДвиженияСуммовойУчетВРозницеИзменение.СуммаВалПередЗаписью КАК СуммаВалПередЗаписью,
		|	ДвиженияСуммовойУчетВРозницеИзменение.СебестоимостьПередЗаписью КАК СебестоимостьПередЗаписью
		|ПОМЕСТИТЬ ДвиженияСуммовойУчетВРозницеПередЗаписью
		|ИЗ
		|	ДвиженияСуммовойУчетВРозницеИзменение КАК ДвиженияСуммовойУчетВРозницеИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РегистрНакопленияСуммовойУчетВРознице.НомерСтроки,
		|	РегистрНакопленияСуммовойУчетВРознице.Организация,
		|	РегистрНакопленияСуммовойУчетВРознице.СтруктурнаяЕдиница,
		|	РегистрНакопленияСуммовойУчетВРознице.Валюта,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияСуммовойУчетВРознице.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияСуммовойУчетВРознице.Сумма
		|		ИНАЧЕ -РегистрНакопленияСуммовойУчетВРознице.Сумма
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияСуммовойУчетВРознице.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияСуммовойУчетВРознице.СуммаВал
		|		ИНАЧЕ -РегистрНакопленияСуммовойУчетВРознице.СуммаВал
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияСуммовойУчетВРознице.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияСуммовойУчетВРознице.Себестоимость
		|		ИНАЧЕ -РегистрНакопленияСуммовойУчетВРознице.Себестоимость
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.СуммовойУчетВРознице КАК РегистрНакопленияСуммовойУчетВРознице
		|ГДЕ
		|	РегистрНакопленияСуммовойУчетВРознице.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияСуммовойУчетВРозницеИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияСуммовойУчетВРозницеИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияСуммовойУчетВРозницеИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияСуммовойУчетВРозницеИзменение");
	
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
	// и помещается во временную таблицу "ДвиженияСуммовойУчетВРозницеИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияСуммовойУчетВРозницеИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияСуммовойУчетВРозницеИзменение.Организация КАК Организация,
	|	ДвиженияСуммовойУчетВРозницеИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ДвиженияСуммовойУчетВРозницеИзменение.Валюта КАК Валюта,
	|	СУММА(ДвиженияСуммовойУчетВРозницеИзменение.СуммаПередЗаписью) КАК СуммаПередЗаписью,
	|	СУММА(ДвиженияСуммовойУчетВРозницеИзменение.СуммаИзменение) КАК СуммаИзменение,
	|	СУММА(ДвиженияСуммовойУчетВРозницеИзменение.СуммаПриЗаписи) КАК СуммаПриЗаписи,
	|	СУММА(ДвиженияСуммовойУчетВРозницеИзменение.СуммаВалПередЗаписью) КАК СуммаВалПередЗаписью,
	|	СУММА(ДвиженияСуммовойУчетВРозницеИзменение.СуммаВалИзменение) КАК СуммаВалИзменение,
	|	СУММА(ДвиженияСуммовойУчетВРозницеИзменение.СуммаВалПриЗаписи) КАК СуммаВалПриЗаписи,
	|	СУММА(ДвиженияСуммовойУчетВРозницеИзменение.СебестоимостьПередЗаписью) КАК СебестоимостьПередЗаписью,
	|	СУММА(ДвиженияСуммовойУчетВРозницеИзменение.СебестоимостьИзменение) КАК СебестоимостьИзменение,
	|	СУММА(ДвиженияСуммовойУчетВРозницеИзменение.СебестоимостьПриЗаписи) КАК СебестоимостьПриЗаписи

	|ПОМЕСТИТЬ ДвиженияСуммовойУчетВРозницеИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияСуммовойУчетВРозницеПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияСуммовойУчетВРозницеПередЗаписью.Организация КАК Организация,
	|		ДвиженияСуммовойУчетВРозницеПередЗаписью.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		ДвиженияСуммовойУчетВРозницеПередЗаписью.Валюта КАК Валюта,
	|		ДвиженияСуммовойУчетВРозницеПередЗаписью.СуммаПередЗаписью КАК СуммаПередЗаписью,
	|		ДвиженияСуммовойУчетВРозницеПередЗаписью.СуммаПередЗаписью КАК СуммаИзменение,
	|		0 КАК СуммаПриЗаписи,
	|		ДвиженияСуммовойУчетВРозницеПередЗаписью.СуммаВалПередЗаписью КАК СуммаВалПередЗаписью,
	|		ДвиженияСуммовойУчетВРозницеПередЗаписью.СуммаВалПередЗаписью КАК СуммаВалИзменение,
	|		0 КАК СуммаВалПриЗаписи,
	|		ДвиженияСуммовойУчетВРозницеПередЗаписью.СебестоимостьПередЗаписью КАК СебестоимостьПередЗаписью,
	|		ДвиженияСуммовойУчетВРозницеПередЗаписью.СебестоимостьПередЗаписью КАК СебестоимостьИзменение,
	|		0 КАК СебестоимостьПриЗаписи

	|	ИЗ
	|		ДвиженияСуммовойУчетВРозницеПередЗаписью КАК ДвиженияСуммовойУчетВРозницеПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияСуммовойУчетВРозницеПриЗаписи.НомерСтроки,
	|		ДвиженияСуммовойУчетВРозницеПриЗаписи.Организация,
	|		ДвиженияСуммовойУчетВРозницеПриЗаписи.СтруктурнаяЕдиница,
	|		ДвиженияСуммовойУчетВРозницеПриЗаписи.Валюта,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияСуммовойУчетВРозницеПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияСуммовойУчетВРозницеПриЗаписи.Сумма
	|			ИНАЧЕ ДвиженияСуммовойУчетВРозницеПриЗаписи.Сумма
	|		КОНЕЦ,
	|		ДвиженияСуммовойУчетВРозницеПриЗаписи.Сумма,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияСуммовойУчетВРозницеПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияСуммовойУчетВРозницеПриЗаписи.СуммаВал
	|			ИНАЧЕ ДвиженияСуммовойУчетВРозницеПриЗаписи.СуммаВал
	|		КОНЕЦ,
	|		ДвиженияСуммовойУчетВРозницеПриЗаписи.СуммаВал,
		|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияСуммовойУчетВРозницеПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияСуммовойУчетВРозницеПриЗаписи.Себестоимость
	|			ИНАЧЕ ДвиженияСуммовойУчетВРозницеПриЗаписи.Себестоимость
	|		КОНЕЦ,
	|		ДвиженияСуммовойУчетВРозницеПриЗаписи.Себестоимость

	|	ИЗ
	|		РегистрНакопления.СуммовойУчетВРознице КАК ДвиженияСуммовойУчетВРозницеПриЗаписи
	|	ГДЕ
	|		ДвиженияСуммовойУчетВРозницеПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияСуммовойУчетВРозницеИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияСуммовойУчетВРозницеИзменение.Организация,
	|	ДвиженияСуммовойУчетВРозницеИзменение.СтруктурнаяЕдиница,
	|	ДвиженияСуммовойУчетВРозницеИзменение.Валюта
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ДвиженияСуммовойУчетВРозницеИзменение.СуммаИзменение) <> 0
	|		ИЛИ СУММА(ДвиженияСуммовойУчетВРозницеИзменение.СуммаВалИзменение) <> 0
	|		ИЛИ СУММА(ДвиженияСуммовойУчетВРозницеИзменение.СебестоимостьИзменение) <> 0)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	СтруктурнаяЕдиница,
	|	Валюта");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияСуммовойУчетВРозницеИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияСуммовойУчетВРозницеИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияСуммовойУчетВРозницеПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияСуммовойУчетВРозницеПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли