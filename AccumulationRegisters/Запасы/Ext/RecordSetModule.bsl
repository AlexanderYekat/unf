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
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.Запасы.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияЗапасыИзменение Тогда
		
		// Если временная таблица "ДвиженияЗапасыИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияЗапасыПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Запасы.НомерСтроки КАК НомерСтроки,
		|	Запасы.Организация КАК Организация,
		|	Запасы.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	Запасы.СчетУчета КАК СчетУчета,
		|	Запасы.Номенклатура КАК Номенклатура,
		|	Запасы.Характеристика КАК Характеристика,
		|	Запасы.Партия КАК Партия,
		|	Запасы.ЗаказПокупателя КАК ЗаказПокупателя,
		|	ВЫБОР
		|		КОГДА Запасы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА Запасы.Количество
		|		ИНАЧЕ -Запасы.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью,
		|	ВЫБОР
		|		КОГДА Запасы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА Запасы.Сумма
		|		ИНАЧЕ -Запасы.Сумма
		|	КОНЕЦ КАК СуммаПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыПередЗаписью
		|ИЗ
		|	РегистрНакопления.Запасы КАК Запасы
		|ГДЕ
		|	Запасы.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияЗапасыИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияЗапасыПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗапасыИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияЗапасыИзменение.Организация КАК Организация,
		|	ДвиженияЗапасыИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ДвиженияЗапасыИзменение.СчетУчета КАК СчетУчета,
		|	ДвиженияЗапасыИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияЗапасыИзменение.Характеристика КАК Характеристика,
		|	ДвиженияЗапасыИзменение.Партия КАК Партия,
		|	ДвиженияЗапасыИзменение.ЗаказПокупателя КАК ЗаказПокупателя,
		|	ДвиженияЗапасыИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
		|	ДвиженияЗапасыИзменение.СуммаПередЗаписью КАК СуммаПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыПередЗаписью
		|ИЗ
		|	ДвиженияЗапасыИзменение КАК ДвиженияЗапасыИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Запасы.НомерСтроки,
		|	Запасы.Организация,
		|	Запасы.СтруктурнаяЕдиница,
		|	Запасы.СчетУчета,
		|	Запасы.Номенклатура,
		|	Запасы.Характеристика,
		|	Запасы.Партия,
		|	Запасы.ЗаказПокупателя,
		|	ВЫБОР
		|		КОГДА Запасы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА Запасы.Количество
		|		ИНАЧЕ -Запасы.Количество
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА Запасы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА Запасы.Сумма
		|		ИНАЧЕ -Запасы.Сумма
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.Запасы КАК Запасы
		|ГДЕ
		|	Запасы.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияЗапасыИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияЗапасыИзменение");
	
	КонецЕсли;
	
	// Хозяйственная операция
	ХозяйственныеОперацииСервер.ЗаполнитьХозяйственнуюОперациюВНабореЗаписей(ЭтотОбъект);
	// Конец Хозяйственная операция
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ПриЗаписи набора записей.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		
		Если ДополнительныеСвойства.Свойство("ТаблицаНоменклатурыДляОбновленияОстатков") Тогда
			ДополнительныеПараметры = Новый Структура("ТаблицаНоменклатуры", ДополнительныеСвойства.ТаблицаНоменклатурыДляОбновленияОстатков);
			РегистрыСведений.ОстаткиТоваров.ОбновитьЗаписиОстатковВТехническомРегистре(ДополнительныеПараметры);
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу "ДвиженияЗапасыИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияЗапасыИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияЗапасыИзменение.Организация КАК Организация,
	|	ДвиженияЗапасыИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ДвиженияЗапасыИзменение.СчетУчета КАК СчетУчета,
	|	ДвиженияЗапасыИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияЗапасыИзменение.Характеристика КАК Характеристика,
	|	ДвиженияЗапасыИзменение.Партия КАК Партия,
	|	ДвиженияЗапасыИзменение.ЗаказПокупателя КАК ЗаказПокупателя,
	|	СУММА(ДвиженияЗапасыИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияЗапасыИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияЗапасыИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи,
	|	СУММА(ДвиженияЗапасыИзменение.СуммаПередЗаписью) КАК СуммаПередЗаписью,
	|	СУММА(ДвиженияЗапасыИзменение.СуммаИзменение) КАК СуммаИзменение,
	|	СУММА(ДвиженияЗапасыИзменение.СуммаПриЗаписи) КАК СуммаПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияЗапасыПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияЗапасыПередЗаписью.Организация КАК Организация,
	|		ДвиженияЗапасыПередЗаписью.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		ДвиженияЗапасыПередЗаписью.СчетУчета КАК СчетУчета,
	|		ДвиженияЗапасыПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияЗапасыПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияЗапасыПередЗаписью.Партия КАК Партия,
	|		ДвиженияЗапасыПередЗаписью.ЗаказПокупателя КАК ЗаказПокупателя,
	|		ДвиженияЗапасыПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияЗапасыПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи,
	|		ДвиженияЗапасыПередЗаписью.СуммаПередЗаписью КАК СуммаПередЗаписью,
	|		ДвиженияЗапасыПередЗаписью.СуммаПередЗаписью КАК СуммаИзменение,
	|		0 КАК СуммаПриЗаписи
	|	ИЗ
	|		ДвиженияЗапасыПередЗаписью КАК ДвиженияЗапасыПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияЗапасыПриЗаписи.НомерСтроки,
	|		ДвиженияЗапасыПриЗаписи.Организация,
	|		ДвиженияЗапасыПриЗаписи.СтруктурнаяЕдиница,
	|		ДвиженияЗапасыПриЗаписи.СчетУчета,
	|		ДвиженияЗапасыПриЗаписи.Номенклатура,
	|		ДвиженияЗапасыПриЗаписи.Характеристика,
	|		ДвиженияЗапасыПриЗаписи.Партия,
	|		ДвиженияЗапасыПриЗаписи.ЗаказПокупателя,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияЗапасыПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияЗапасыПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияЗапасыПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияЗапасыПриЗаписи.Количество,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияЗапасыПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияЗапасыПриЗаписи.Сумма
	|			ИНАЧЕ ДвиженияЗапасыПриЗаписи.Сумма
	|		КОНЕЦ,
	|		ДвиженияЗапасыПриЗаписи.Сумма
	|	ИЗ
	|		РегистрНакопления.Запасы КАК ДвиженияЗапасыПриЗаписи
	|	ГДЕ
	|		ДвиженияЗапасыПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияЗапасыИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияЗапасыИзменение.Организация,
	|	ДвиженияЗапасыИзменение.СтруктурнаяЕдиница,
	|	ДвиженияЗапасыИзменение.СчетУчета,
	|	ДвиженияЗапасыИзменение.Номенклатура,
	|	ДвиженияЗапасыИзменение.Характеристика,
	|	ДвиженияЗапасыИзменение.Партия,
	|	ДвиженияЗапасыИзменение.ЗаказПокупателя
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ДвиженияЗапасыИзменение.КоличествоИзменение) <> 0
	|		ИЛИ СУММА(ДвиженияЗапасыИзменение.СуммаИзменение) <> 0)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	СтруктурнаяЕдиница,
	|	СчетУчета,
	|	Номенклатура,
	|	Характеристика,
	|	Партия,
	|	ЗаказПокупателя");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияЗапасыИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияЗапасыПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	// Расчет быстрых остатков для списка номенклатуры
	РегистрыСведений.ОстаткиТоваров.РассчитатьОстатокТовараДляБыстрогоОтображения(ДополнительныеСвойства, ВыборкаИзРезультатаЗапроса.Количество, "ДвиженияЗапасыИзменение");
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли