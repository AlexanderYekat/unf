﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	// Прослеживаемость
	СведенияПрослеживаемости.Очистить();
	// Конец Прослеживаемость
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ЗаказПокупателя")] = "ЗаполнитьПоЗаказуНаряду";
	СтратегияЗаполнения[Тип("ДокументСсылка.АктВыполненныхРабот")] = "ЗаполнитьПоРеализации";
	СтратегияЗаполнения[Тип("ДокументСсылка.РасходнаяНакладная")] = "ЗаполнитьПоРеализации";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
	// Прослеживаемость
	ПрослеживаемостьУНФ.ОбновитьПризнакПрослеживаемости(Запасы, Дата);
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДаннымиСобытияУНФ.ПропуститьДозаполнениеДокумента(ЭтотОбъект, РежимЗаписи) Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьСуммыДоКорректировки();
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДоговорПоУмолчанию(ЭтотОбъект);
	
	СуммаДокумента = Запасы.Итог("Всего");
	
	// Прослеживаемость
	ПрослеживаемыйТовар = Запасы.НайтиСтроки(Новый Структура("ПрослеживаемыйТовар", Истина));
	ЕстьПрослеживаемыйТовар = ПрослеживаемыйТовар.Количество() <> 0;
	Если ЕстьПрослеживаемыйТовар Тогда
		ПрослеживаемостьУНФ.ПодобратьРНПТКорректировка(ЭтотОбъект, Отказ);
	Иначе
		СведенияПрослеживаемости.Очистить();
	КонецЕсли;
	// Конец Прослеживаемость
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ТаблицаЗапасы = Запасы.Выгрузить(, "Заказ, Всего");
	ТаблицаЗапасы.Свернуть("Заказ", "Всего");
	
	ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизитДоговор(ПроверяемыеРеквизиты, ЭтотОбъект);
	
	НоменклатураВДокументахСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Отказ, Истина);
	
	ГрузовыеТаможенныеДекларацииСервер.ПриОбработкеПроверкиЗаполнения(Отказ, ЭтотОбъект);
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ПриКопировании объекта.
//
Процедура ПриКопировании(ОбъектКопирования)
	
	УправлениеНебольшойФирмойЭлектронныеДокументыСервер.ОчиститьДатуНомерВходящегоДокумента(ЭтотОбъект);
	ШтрихкодыУпаковок.Очистить();
	
	// Прослеживаемость
	СведенияПрослеживаемости.Очистить();
	ПрослеживаемостьУНФ.ОбновитьПризнакПрослеживаемости(Запасы, Дата);
	// Конец Прослеживаемость
	
КонецПроцедуры // ПриКопировании()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

// АПК:299-выкл вызывается из внешней процедуры
Процедура ЗаполнитьПоРеализации(ДанныеЗаполнения) Экспорт
	
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РасходнаяНакладная")
		И НЕ (ДанныеЗаполнения.ВидОперации = Перечисления.ВидыОперацийРасходнаяНакладная.ПродажаПокупателю
		Или ДанныеЗаполнения.ВидОперации = Перечисления.ВидыОперацийРасходнаяНакладная.ПередачаНаКомиссию) Тогда
		
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не требуется вводить акт о расхождениях на основании документа %1.'"),
			ДанныеЗаполнения);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ВидОперацииЗаполнения = Неопределено;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ДокументОснование") Тогда
		ВидОперацииЗаполнения = ?(ДанныеЗаполнения.Свойство("ВидОперации"), ДанныеЗаполнения.ВидОперации, Неопределено);
		ДокументОснование = ДанныеЗаполнения.ДокументОснование;
	Иначе
		ДокументОснование = ДанныеЗаполнения;
	КонецЕсли;
	
	ЗаполнитьСвойстваШапки(ВидОперацииЗаполнения);
	
	Запасы.Очистить();
	
	МетаданныеДокумента = ДанныеЗаполнения.Метаданные();
	ИмяВидаДокумента = МетаданныеДокумента.Имя;
	ИмяТабличнойЧасти = ?(ИмяВидаДокумента = "АктВыполненныхРабот", "РаботыИУслуги", "Запасы");
	
	Запрос = Новый Запрос;
	Текст = 
	"ВЫБРАТЬ
	|	РасходнаяНакладная.Ссылка КАК ДокументОснование,
	|	РасходнаяНакладная.Организация,
	|	РасходнаяНакладная.Контрагент,
	|	РасходнаяНакладная.Договор,
	|	РасходнаяНакладная.ВалютаДокумента,
	|	РасходнаяНакладная.НалогообложениеНДС,
	|	РасходнаяНакладная.СуммаВключаетНДС,
	|	РасходнаяНакладная.НДСВключатьВСтоимость,
	|	РасходнаяНакладная.Курс,
	|	РасходнаяНакладная.Кратность,
	|	РасходнаяНакладная.СуммаДокумента,
	|	РасходнаяНакладная.ДисконтнаяКарта,
	|	РасходнаяНакладная.ВидЦен,";
	Если ИмяВидаДокумента = "АктВыполненныхРабот" Тогда
		Текст = Текст + "
		|	РасходнаяНакладная.ЗаказПокупателя КАК Заказ,";
	Иначе
		Текст = Текст + "
		|	РасходнаяНакладная.СтруктурнаяЕдиница,
		|	РасходнаяНакладная.Ячейка,
		|	РасходнаяНакладная.ДокументПоступления КАК ДокументПоступления,
		|	РасходнаяНакладная.НомерВходящегоДокумента,
		|	РасходнаяНакладная.ДатаВходящегоДокумента,
		|	РасходнаяНакладная.Заказ,";
	КонецЕсли;
	Если ИмяВидаДокумента = "РасходнаяНакладная" Тогда
		Текст = Текст + "
		|	РасходнаяНакладная.ПодписьРуководителя КАК ПодписьРуководителя,
		|	РасходнаяНакладная.ПодписьГлавногоБухгалтера КАК ПодписьГлавногоБухгалтера,
		|	РасходнаяНакладная.ПодписьКладовщика КАК ПодписьКладовщика,
		|	РасходнаяНакладная.КонтактноеЛицоПодписант КАК КонтактноеЛицоПодписант,";
	КонецЕсли;
	Текст = Текст + "
	|	РасходнаяНакладная.Подразделение,
	|	РасходнаяНакладная.Ответственный
	|ИЗ
	|	Документ." + ИмяВидаДокумента + " КАК РасходнаяНакладная
	|ГДЕ
	|	РасходнаяНакладная.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасходнаяНакладнаяЗапасы.Номенклатура,
	|	РасходнаяНакладнаяЗапасы.Характеристика,";
	Если ИмяВидаДокумента = "АктВыполненныхРабот" Тогда
		Текст = Текст + "
		|	ЛОЖЬ КАК ТипНоменклатурыЗапас,
		|	РасходнаяНакладнаяЗапасы.Номенклатура.ПрослеживаемыйТовар КАК ПрослеживаемыйТовар,
		|	РасходнаяНакладнаяЗапасы.Номенклатура.ПрослеживаемыйКомплект КАК ПрослеживаемыйКомплект,
		|	РасходнаяНакладнаяЗапасы.Номенклатура.ТоварнаяНоменклатураВЭД КАК КодТНВЭД,
		|	РасходнаяНакладнаяЗапасы.ЗаказПокупателя КАК Заказ,";
	Иначе
		Текст = Текст + "
		|	РасходнаяНакладнаяЗапасы.ПрослеживаемыйТовар КАК ПрослеживаемыйТовар,
		|	РасходнаяНакладнаяЗапасы.ПрослеживаемыйКомплект КАК ПрослеживаемыйКомплект,
		|	РасходнаяНакладнаяЗапасы.КодТНВЭД КАК КодТНВЭД,
		|	РасходнаяНакладнаяЗапасы.ТипНоменклатурыЗапас КАК ТипНоменклатурыЗапас,
		|	РасходнаяНакладнаяЗапасы.Партия,
		|	РасходнаяНакладнаяЗапасы.ИдентификаторСтроки,
		|	РасходнаяНакладнаяЗапасы.ДокументПоступления КАК ДокументПоступления,
		|	РасходнаяНакладнаяЗапасы.Заказ,";
	КонецЕсли;
	Если ИмяВидаДокумента = "РасходнаяНакладная" Тогда
		Текст = Текст + "
		|	ВЫБОР
		|		КОГДА РасходнаяНакладнаяЗапасы.Ссылка.ПоложениеСклада = ЗНАЧЕНИЕ(Перечисление.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти)
		|			ТОГДА РасходнаяНакладнаяЗапасы.СтруктурнаяЕдиница
		|		ИНАЧЕ РасходнаяНакладнаяЗапасы.Ссылка.СтруктурнаяЕдиница
		|	КОНЕЦ КАК СтруктурнаяЕдиница,
		|	ВЫБОР
		|		КОГДА РасходнаяНакладнаяЗапасы.Ссылка.ПоложениеСклада = ЗНАЧЕНИЕ(Перечисление.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти)
		|			ТОГДА РасходнаяНакладнаяЗапасы.Ячейка
		|		ИНАЧЕ РасходнаяНакладнаяЗапасы.Ссылка.Ячейка
		|	КОНЕЦ КАК Ячейка,";
	ИначеЕсли ИмяВидаДокумента = "КорректировкаРеализации" Тогда
		Текст = Текст + "
		|	РасходнаяНакладнаяЗапасы.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	РасходнаяНакладнаяЗапасы.Ячейка КАК Ячейка,";
	КонецЕсли;
	Текст = Текст + "
	|	РасходнаяНакладнаяЗапасы.ЕдиницаИзмерения,
	|	РасходнаяНакладнаяЗапасы.Количество,
	|	РасходнаяНакладнаяЗапасы.Цена,
	|	РасходнаяНакладнаяЗапасы.Сумма,
	|	РасходнаяНакладнаяЗапасы.СтавкаНДС,
	|	РасходнаяНакладнаяЗапасы.СуммаНДС,
	|	РасходнаяНакладнаяЗапасы.Всего,
	|	РасходнаяНакладнаяЗапасы.Содержание,
	|	РасходнаяНакладнаяЗапасы.Количество КАК КоличествоДоИзменения,
	|	РасходнаяНакладнаяЗапасы.Цена КАК ЦенаДоИзменения,
	|	РасходнаяНакладнаяЗапасы.Сумма КАК СуммаДоИзменения,
	|	РасходнаяНакладнаяЗапасы.СтавкаНДС КАК СтавкаНДСДоИзменения,
	|	РасходнаяНакладнаяЗапасы.СуммаНДС КАК СуммаНДСДоИзменения,
	|	РасходнаяНакладнаяЗапасы.Всего КАК ВсегоДоИзменения,";
	Если ИмяВидаДокумента = "КорректировкаРеализации" Тогда
		Текст = Текст + "
		|	РасходнаяНакладнаяЗапасы.КоличествоДоКорректировки,
		|	РасходнаяНакладнаяЗапасы.ЦенаДоКорректировки,
		|	РасходнаяНакладнаяЗапасы.СуммаДоКорректировки,
		|	РасходнаяНакладнаяЗапасы.СуммаНДСДоКорректировки,
		|	РасходнаяНакладнаяЗапасы.ВсегоДоКорректировки,";
	КонецЕсли;
	Если ИмяВидаДокумента = "КорректировкаРеализации" Тогда
		Текст = Текст + "
		|	РасходнаяНакладнаяЗапасы.КлючСвязи КАК КлючСвязи,";
	Иначе
		Текст = Текст + "
		|	РасходнаяНакладнаяЗапасы.НомерСтроки КАК КлючСвязи,";
	КонецЕсли;
	Если ИмяТабличнойЧасти = "Запасы" Тогда
		Текст = Текст + "
		|	РасходнаяНакладнаяЗапасы.СтранаПроисхождения,
		|	РасходнаяНакладнаяЗапасы.НомерГТД,"
	КонецЕсли;
	Текст = Текст + "
	|	РасходнаяНакладнаяЗапасы.Содержание КАК СодержаниеДоИзменения,
	|	РасходнаяНакладнаяЗапасы.НоменклатураНабора КАК НоменклатураНабора,
	|	РасходнаяНакладнаяЗапасы.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	ИСТИНА КАК ЕстьВДокументеРеализации
	|ИЗ
	|	Документ." + ИмяВидаДокумента + "." + ИмяТабличнойЧасти +" КАК РасходнаяНакладнаяЗапасы
	|ГДЕ
	|	РасходнаяНакладнаяЗапасы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасходнаяНакладнаяПредоплата.Документ,
	|	РасходнаяНакладнаяПредоплата.Заказ,
	|	РасходнаяНакладнаяПредоплата.СуммаРасчетов,
	|	РасходнаяНакладнаяПредоплата.Курс,
	|	РасходнаяНакладнаяПредоплата.Кратность,
	|	РасходнаяНакладнаяПредоплата.СуммаПлатежа,
	|	РасходнаяНакладнаяПредоплата.СуммаРасчетов КАК СуммаРасчетовДоИзменения,
	|	РасходнаяНакладнаяПредоплата.СуммаПлатежа КАК СуммаПлатежаДоИзменения,";
	Если ИмяВидаДокумента = "КорректировкаРеализации" Тогда
			Текст = Текст + "
		|	РасходнаяНакладнаяПредоплата.СуммаРасчетовДоКорректировки,
		|	РасходнаяНакладнаяПредоплата.СуммаПлатежаДоКорректировки,";
	КонецЕсли;
	Текст = Текст + "
	|	ИСТИНА КАК ЕстьВДокументеРеализации
	|ИЗ
	|	Документ." + ИмяВидаДокумента + ".Предоплата КАК РасходнаяНакладнаяПредоплата
	|ГДЕ
	|	РасходнаяНакладнаяПредоплата.Ссылка = &Ссылка";
	
	Если ИмяВидаДокумента = "РасходнаяНакладная" ИЛИ ИмяВидаДокумента = "КорректировкаРеализации" Тогда
		
		РазделительЗапросов = 
		"
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|";
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	СведенияПрослеживаемости.РНПТ КАК РНПТ,
		|	СведенияПрослеживаемости.Количество КАК Количество,
		|	СведенияПрослеживаемости.КоличествоПрослеживаемости КАК КоличествоПрослеживаемости,
		|	СведенияПрослеживаемости.ИдентификаторСтроки КАК ИдентификаторСтроки,
		|	СведенияПрослеживаемости.Номенклатура КАК Номенклатура,
		|	СведенияПрослеживаемости.Сумма КАК Сумма,
		|	СведенияПрослеживаемости.СтранаПроисхождения КАК СтранаПроисхождения
		|ИЗ
		|	Документ.РасходнаяНакладная.СведенияПрослеживаемости КАК СведенияПрослеживаемости
		|ГДЕ
		|	СведенияПрослеживаемости.Ссылка = &Ссылка";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "РасходнаяНакладная", ИмяВидаДокумента);
		Текст = Текст + РазделительЗапросов + ТекстЗапроса;
		
	КонецЕсли;
	
	Запрос.Текст = Текст;
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаШапка = МассивРезультатов[0].Выбрать();
	ВыборкаШапка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	
	ВыборкаЗапасы = МассивРезультатов[1].Выбрать();
	Пока ВыборкаЗапасы.Следующий() Цикл
	
		НоваяСтрока = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаЗапасы);
	
	КонецЦикла;
	
	// Прослеживаемость
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РасходнаяНакладная")
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.КорректировкаПоступления") Тогда
		ВыборкаСведенияПрослеживаемости = МассивРезультатов[3].Выбрать();
		Пока ВыборкаСведенияПрослеживаемости.Следующий() Цикл
			
			НоваяСтрока = СведенияПрослеживаемости.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаСведенияПрослеживаемости);
			
		КонецЦикла;
	КонецЕсли; 
	// Конец Прослеживаемость
	
	// Доставка
	Если ИмяВидаДокумента = "РасходнаяНакладная" Тогда
		Запрос.Текст =
		"ВЫБРАТЬ
		|	РасходнаяНакладная.НоменклатураДоставки,
		|	РасходнаяНакладная.СтоимостьДоставки,
		|	РасходнаяНакладная.СтавкаНДСДоставки,
		|	РасходнаяНакладная.СуммаНДСДоставки,
		|	РасходнаяНакладная.СтоимостьДоставки КАК СтоимостьДоставкиДоИзменения,
		|	РасходнаяНакладная.СтавкаНДСДоставки КАК СтавкаНДСДоставкиДоИзменения,
		|	РасходнаяНакладная.СуммаНДСДоставки КАК СуммаНДСДоставкиДоИзменения,
		|	ВЫБОР
		|		КОГДА РасходнаяНакладная.НоменклатураДоставки <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЕстьВДокументеРеализации
		|ИЗ
		|	Документ.РасходнаяНакладная КАК РасходнаяНакладная
		|ГДЕ
		|	РасходнаяНакладная.Ссылка = &Ссылка";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		КонецЕсли;
	ИначеЕсли ИмяВидаДокумента = "КорректировкаРеализации" Тогда 
		Запрос.Текст =
		"ВЫБРАТЬ
		|	КорректировкаРеализации.НоменклатураДоставки,
		|	КорректировкаРеализации.СтоимостьДоставки,
		|	КорректировкаРеализации.СтавкаНДСДоставки,
		|	КорректировкаРеализации.СуммаНДСДоставки,
		|	КорректировкаРеализации.СтоимостьДоставкиДоИзменения,
		|	КорректировкаРеализации.СтавкаНДСДоставкиДоИзменения,
		|	КорректировкаРеализации.СуммаНДСДоставкиДоИзменения,
		|	КорректировкаРеализации.СтоимостьДоставки КАК СтоимостьДоставкиДоКорректировки,
		|	КорректировкаРеализации.СтавкаНДСДоставки КАК СтавкаНДСДоставкиДоКорректировки,
		|	КорректировкаРеализации.СуммаНДСДоставки КАК СуммаНДСДоставкиДоКорректировки,
		|	ВЫБОР
		|		КОГДА КорректировкаРеализации.НоменклатураДоставки <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЕстьВДокументеРеализации
		|ИЗ
		|	Документ.КорректировкаРеализации КАК КорректировкаРеализации
		|ГДЕ
		|	КорректировкаРеализации.Ссылка = &Ссылка";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		КонецЕсли;
	КонецЕсли; 
	// Конец Доставка
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДокументОснование, "Проект") Тогда
		Проект = ДокументОснование.Проект;
	КонецЕсли;
	
		Если ЗначениеЗаполнено(ДанныеЗаполнения) И НЕ ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И Не ДанныеЗаполнения.Метаданные().ТабличныеЧасти.Найти("СерииНоменклатуры") = Неопределено Тогда
		
		СерииНоменклатуры.Очистить();
		ПеренестиСерииНоменклатуры(ДанныеЗаполнения.СерииНоменклатуры, ДанныеЗаполнения.Запасы);
		
		Если Не ДанныеЗаполнения.Метаданные().ТабличныеЧасти.Найти("СерииНоменклатурыДоКорректировки") = Неопределено Тогда
			СерииНоменклатурыДоКорректировки.Очистить();
			ПеренестиСерииНоменклатуры(ДанныеЗаполнения.СерииНоменклатурыДоКорректировки, ДанныеЗаполнения.Запасы, Истина);
		Иначе
			СерииНоменклатурыДоКорректировки.Очистить();
			ПеренестиСерииНоменклатуры(ДанныеЗаполнения.СерииНоменклатуры, ДанныеЗаполнения.Запасы, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	// Наборы
	ДобавленныеНаборы.Загрузить(ДанныеЗаполнения.ДобавленныеНаборы.Выгрузить());
	
КонецПроцедуры
// АПК:299-вкл

Процедура ПеренестиСерииНоменклатуры(ТаблицаСерииНоменклатурыДокумента, ТаблицаЗапасыДокумента, СерииДоКорректировки = Ложь)
	
	Если Не ТаблицаСерииНоменклатурыДокумента.Количество() Тогда
		Возврат
	КонецЕсли;
	
	СтруктураПоиска = Новый Структура("Номенклатура, Характеристика, Партия");
	СтруктураПоискаКлючСвязи = Новый Структура("КлючСвязи");
	
	ТаблицаСтрокЗапасовССериями = Новый ТаблицаЗначений;
	ТаблицаСтрокЗапасовССериями.Колонки.Добавить("КлючСвязи");
	
	Для Каждого СтрокаСерийДокумента Из ТаблицаСерииНоменклатурыДокумента Цикл
		
		СтруктураПоискаКлючСвязи.КлючСвязи = СтрокаСерийДокумента.КлючСвязи;
		
		НайденныеСтрокиЗапасыДокументаОснования = ТаблицаЗапасыДокумента.НайтиСтроки(СтруктураПоискаКлючСвязи);
		
		Если Не НайденныеСтрокиЗапасыДокументаОснования.Количество() Тогда
			Продолжить;
		КонецЕсли;
		
		НайденнаяСтрока = НайденныеСтрокиЗапасыДокументаОснования[0];
		
		СтруктураПоиска.Номенклатура = НайденнаяСтрока.Номенклатура;
		СтруктураПоиска.Характеристика = НайденнаяСтрока.Характеристика;
		СтруктураПоиска.Партия = НайденнаяСтрока.Партия;
		
		НайденныеСтрокиЗапасы = Запасы.НайтиСтроки(СтруктураПоиска);
		
		Если Не НайденныеСтрокиЗапасы.Количество() Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаЗапасовССериями = ТаблицаСтрокЗапасовССериями.Добавить();
		СтрокаЗапасовССериями.КлючСвязи = НайденныеСтрокиЗапасы[0].КлючСвязи;
		
		Если СерииДоКорректировки Тогда
			НоваяСтрокаСерии = СерииНоменклатурыДоКорректировки.Добавить();
		Иначе
			НоваяСтрокаСерии = СерииНоменклатуры.Добавить();
		КонецЕсли;
	
		НоваяСтрокаСерии.КлючСвязи = НайденныеСтрокиЗапасы[0].КлючСвязи;
		НоваяСтрокаСерии.Количество = СтрокаСерийДокумента.Количество;
		НоваяСтрокаСерии.Серия = СтрокаСерийДокумента.Серия;
		
	КонецЦикла;
	
	ТаблицаСтрокЗапасовССериями.Свернуть("КлючСвязи");
	
	// Заполним строковое представление серий
	
	Для Каждого СтрокаТаблицыЗапасовССериями Из ТаблицаСтрокЗапасовССериями Цикл
		
		СтроковоеПредставлениеСерийНоменклатуры = "";
		СтруктураПоискаКлючСвязи.КлючСвязи = СтрокаТаблицыЗапасовССериями.КлючСвязи;
		
		Если СерииДоКорректировки Тогда
			НайденныеСтрокиСерии = СерииНоменклатурыДоКорректировки.НайтиСтроки(СтруктураПоискаКлючСвязи);
		Иначе
			НайденныеСтрокиСерии = СерииНоменклатуры.НайтиСтроки(СтруктураПоискаКлючСвязи);
		КонецЕсли;
		
		Если Не НайденныеСтрокиСерии.Количество() Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого СтрокаСерий Из НайденныеСтрокиСерии Цикл
			
			СтроковоеПредставлениеСерийНоменклатуры = СтроковоеПредставлениеСерийНоменклатуры + СтрокаСерий.Серия+"; ";
			
		КонецЦикла;
		
		СтроковоеПредставлениеСерийНоменклатуры = Лев(СтроковоеПредставлениеСерийНоменклатуры, Мин(СтрДлина(СтроковоеПредставлениеСерийНоменклатуры)-2,150));
		
		НайденныеСтрокиЗапасы = Запасы.НайтиСтроки(СтруктураПоискаКлючСвязи);
		
		Если Не НайденныеСтрокиЗапасы.Количество() Тогда
			Продолжить;
		КонецЕсли;
		
		Если СерииДоКорректировки Тогда
			НайденныеСтрокиЗапасы[0].СерииНоменклатурыДоКорректировки = СтроковоеПредставлениеСерийНоменклатуры;
		Иначе
			НайденныеСтрокиЗапасы[0].СерииНоменклатуры = СтроковоеПредставлениеСерийНоменклатуры;
		КонецЕсли;
		
	КонецЦикла;
	
	
КонецПроцедуры

// АПК:299-выкл вызывается из внешней процедуры
Процедура ЗаполнитьПоЗаказуНаряду(ДанныеЗаполнения) Экспорт
	
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеЗаполнения.ВидОперации <> Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд Тогда
		
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не требуется вводить корректировку поступления на основании документа %1.'"),
			ДанныеЗаполнения);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "СостояниеЗаказа, ВидЗаказа");
	Если НЕ СостоянияЗаказов.ЭтоСостояниеВыполненияЗаказНаряда(ЗначенияРеквизитов.СостояниеЗаказа, ЗначенияРеквизитов.ВидЗаказа) Тогда
		
		ТекстИсключения = НСтр("ru = 'Корректировка может быть создана только на основании выполненного заказа-наряда.'");
		ВызватьИсключение ТекстИсключения;
		
	КонецЕсли;
	
	ВидОперацииЗаполнения = Неопределено;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ДокументОснование") Тогда
		ВидОперацииЗаполнения = ?(ДанныеЗаполнения.Свойство("ВидОперации"), ДанныеЗаполнения.ВидОперации, Неопределено);
		ДокументОснование = ДанныеЗаполнения.ДокументОснование;
	Иначе
		ДокументОснование = ДанныеЗаполнения;
	КонецЕсли;
	
	ЗаполнитьСвойстваШапки(ВидОперацииЗаполнения);
	
	Запасы.Очистить();
	
	Запрос = Новый Запрос;
	Текст = 
	"ВЫБРАТЬ
	|	ЗаказПокупателя.Ссылка КАК ДокументОснование,
	|	ЗаказПокупателя.Организация КАК Организация,
	|	ЗаказПокупателя.Контрагент КАК Контрагент,
	|	ЗаказПокупателя.Договор КАК Договор,
	|	ЗаказПокупателя.ВалютаДокумента КАК ВалютаДокумента,
	|	ЗаказПокупателя.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЗаказПокупателя.СуммаВключаетНДС КАК СуммаВключаетНДС,
	|	ЗаказПокупателя.НДСВключатьВСтоимость КАК НДСВключатьВСтоимость,
	|	ЗаказПокупателя.Курс КАК Курс,
	|	ЗаказПокупателя.Кратность КАК Кратность,
	|	ЗаказПокупателя.СуммаДокумента КАК СуммаДокумента,
	|	ЗаказПокупателя.ВидЦен КАК ВидЦен,
	|	ЗаказПокупателя.СтруктурнаяЕдиницаПродажи КАК Подразделение,
	|	ЗаказПокупателя.Ответственный КАК Ответственный,
	|	ЗаказПокупателя.СтруктурнаяЕдиницаРезерв КАК СтруктурнаяЕдиница,
	|	ЗаказПокупателя.ДисконтнаяКарта КАК ДисконтнаяКарта,
	|	ЗаказПокупателя.ТипДенежныхСредств КАК ТипДенежныхСредств,
	|	ЗаказПокупателя.Касса КАК Касса,
	|	ЗаказПокупателя.ЗапланироватьОплату КАК ЗапланироватьОплату,
	|	ЗаказПокупателя.ДокументПоступления КАК ДокументПоступления
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	|ГДЕ
	|	ЗаказПокупателя.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказПокупателяРаботы.Номенклатура КАК Номенклатура,
	|	ЗаказПокупателяРаботы.Характеристика КАК Характеристика,
	|	ЗаказПокупателяРаботы.Количество * ЗаказПокупателяРаботы.Коэффициент * ЗаказПокупателяРаботы.Кратность КАК Количество,
	|	ЗаказПокупателяРаботы.Цена КАК Цена,
	|	ЗаказПокупателяРаботы.Сумма КАК Сумма,
	|	ЗаказПокупателяРаботы.СтавкаНДС КАК СтавкаНДС,
	|	ЗаказПокупателяРаботы.СуммаНДС КАК СуммаНДС,
	|	ЗаказПокупателяРаботы.Всего КАК Всего,
	|	ЗаказПокупателяРаботы.Содержание КАК Содержание,
	|	ЗаказПокупателяРаботы.Количество * ЗаказПокупателяРаботы.Коэффициент * ЗаказПокупателяРаботы.Кратность КАК КоличествоДоИзменения,
	|	ЗаказПокупателяРаботы.Цена КАК ЦенаДоИзменения,
	|	ЗаказПокупателяРаботы.Сумма КАК СуммаДоИзменения,
	|	ЗаказПокупателяРаботы.СтавкаНДС КАК СтавкаНДСДоИзменения,
	|	ЗаказПокупателяРаботы.СуммаНДС КАК СуммаНДСДоИзменения,
	|	ЗаказПокупателяРаботы.Всего КАК ВсегоДоИзменения,
	|	ЗаказПокупателяРаботы.НоменклатураНабора КАК НоменклатураНабора,
	|	ЗаказПокупателяРаботы.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	ЗаказПокупателяРаботы.Содержание КАК СодержаниеДоИзменения,
	|	ЗаказПокупателяРаботы.Ссылка.СтруктурнаяЕдиницаРезерв КАК СтруктурнаяЕдиница,
	|	ЗаказПокупателяРаботы.Ссылка.Ячейка КАК Ячейка,
	|	ЗаказПокупателяРаботы.Ссылка КАК Заказ,
	|	ИСТИНА КАК ЕстьВДокументеРеализации,
	|	ЗаказПокупателяРаботы.Спецификация КАК Спецификация,
	|	ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка) КАК Партия,
	|	ЗаказПокупателяРаботы.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЛОЖЬ КАК ТипНоменклатурыЗапас,
	|	0 КАК Резерв,
	|	ЗаказПокупателяРаботы.НомерСтроки КАК КлючСвязи,
	|	0 КАК ИдентификаторСтроки,
	|	НЕОПРЕДЕЛЕНО КАК СтранаПроисхождения,
	|	ЛОЖЬ КАК ПрослеживаемыйТовар,
	|	ЛОЖЬ КАК ПрослеживаемыйКомплект,
	|	"""" КАК КодТНВЭД,
	|	"""" КАК НомерГТД,
	|	НЕОПРЕДЕЛЕНО КАК ДокументПоступления
	|ИЗ
	|	Документ.ЗаказПокупателя.Работы КАК ЗаказПокупателяРаботы
	|ГДЕ
	|	ЗаказПокупателяРаботы.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗаказПокупателяЗапасы.Номенклатура,
	|	ЗаказПокупателяЗапасы.Характеристика,
	|	ЗаказПокупателяЗапасы.Количество,
	|	ЗаказПокупателяЗапасы.Цена,
	|	ЗаказПокупателяЗапасы.Сумма,
	|	ЗаказПокупателяЗапасы.СтавкаНДС,
	|	ЗаказПокупателяЗапасы.СуммаНДС,
	|	ЗаказПокупателяЗапасы.Всего,
	|	ЗаказПокупателяЗапасы.Содержание,
	|	ЗаказПокупателяЗапасы.Количество,
	|	ЗаказПокупателяЗапасы.Цена,
	|	ЗаказПокупателяЗапасы.Сумма,
	|	ЗаказПокупателяЗапасы.СтавкаНДС,
	|	ЗаказПокупателяЗапасы.СуммаНДС,
	|	ЗаказПокупателяЗапасы.Всего,
	|	ЗаказПокупателяЗапасы.НоменклатураНабора,
	|	ЗаказПокупателяЗапасы.ХарактеристикаНабора,
	|	ЗаказПокупателяЗапасы.Содержание,
	|	ЗаказПокупателяЗапасы.СтруктурнаяЕдиницаРезерв,
	|	ЗаказПокупателяЗапасы.Ссылка.Ячейка,
	|	ЗаказПокупателяЗапасы.Ссылка,
	|	ИСТИНА,
	|	ЗНАЧЕНИЕ(Справочник.Спецификации.ПустаяСсылка),
	|	ЗаказПокупателяЗапасы.Партия,
	|	ЗаказПокупателяЗапасы.ЕдиницаИзмерения,
	|	ЗаказПокупателяЗапасы.ТипНоменклатурыЗапас,
	|	ЗаказПокупателяЗапасы.Резерв,
	|	ЗаказПокупателяЗапасы.НомерСтроки,
	|	ЗаказПокупателяЗапасы.ИдентификаторСтроки,
	|	ЗаказПокупателяЗапасы.СтранаПроисхождения,
	|	ЗаказПокупателяЗапасы.ПрослеживаемыйТовар,
	|	ЗаказПокупателяЗапасы.ПрослеживаемыйКомплект,
	|	ЗаказПокупателяЗапасы.КодТНВЭД,
	|	ЗаказПокупателяЗапасы.НомерГТД,
	|	ЗаказПокупателяЗапасы.ДокументПоступления
	|ИЗ
	|	Документ.ЗаказПокупателя.Запасы КАК ЗаказПокупателяЗапасы
	|ГДЕ
	|	ЗаказПокупателяЗапасы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказПокупателяПредоплата.Документ КАК Документ,
	|	ЗаказПокупателяПредоплата.СуммаРасчетов КАК СуммаРасчетов,
	|	ЗаказПокупателяПредоплата.Курс КАК Курс,
	|	ЗаказПокупателяПредоплата.Кратность КАК Кратность,
	|	ЗаказПокупателяПредоплата.СуммаПлатежа КАК СуммаПлатежа,
	|	ЗаказПокупателяПредоплата.СуммаРасчетов КАК СуммаРасчетовДоИзменения,
	|	ЗаказПокупателяПредоплата.СуммаПлатежа КАК СуммаПлатежаДоИзменения,
	|	ИСТИНА КАК ЕстьВДокументеРеализации
	|ИЗ
	|	Документ.ЗаказПокупателя.Предоплата КАК ЗаказПокупателяПредоплата
	|ГДЕ
	|	ЗаказПокупателяПредоплата.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказПокупателяПлатежныйКалендарь.ДатаОплаты КАК ДатаОплаты,
	|	ЗаказПокупателяПлатежныйКалендарь.ПроцентОплаты КАК ПроцентОплаты,
	|	ЗаказПокупателяПлатежныйКалендарь.СуммаОплаты КАК СуммаОплаты,
	|	ЗаказПокупателяПлатежныйКалендарь.СуммаНДСОплаты КАК СуммаНДСОплаты,
	|	ЗаказПокупателяПлатежныйКалендарь.ДатаОплаты КАК ДатаОплатыДоИзменения,
	|	ЗаказПокупателяПлатежныйКалендарь.ПроцентОплаты КАК ПроцентОплатыДоИзменения,
	|	ЗаказПокупателяПлатежныйКалендарь.СуммаОплаты КАК СуммаОплатыДоИзменения,
	|	ЗаказПокупателяПлатежныйКалендарь.СуммаНДСОплаты КАК СуммаНДСДоИзменения,
	|	ИСТИНА КАК ЕстьВДокументеРеализации
	|ИЗ
	|	Документ.ЗаказПокупателя.ПлатежныйКалендарь КАК ЗаказПокупателяПлатежныйКалендарь
	|ГДЕ
	|	ЗаказПокупателяПлатежныйКалендарь.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СведенияПрослеживаемости.РНПТ КАК РНПТ,
	|	СведенияПрослеживаемости.Количество КАК Количество,
	|	СведенияПрослеживаемости.КоличествоПрослеживаемости КАК КоличествоПрослеживаемости,
	|	СведенияПрослеживаемости.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	СведенияПрослеживаемости.Номенклатура КАК Номенклатура,
	|	СведенияПрослеживаемости.Сумма КАК Сумма,
	|	СведенияПрослеживаемости.СтранаПроисхождения КАК СтранаПроисхождения
	|ИЗ
	|	Документ.ЗаказПокупателя.СведенияПрослеживаемости КАК СведенияПрослеживаемости
	|ГДЕ
	|	СведенияПрослеживаемости.Ссылка = &Ссылка";
	
	Запрос.Текст = Текст;
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаШапка = МассивРезультатов[0].Выбрать();
	ВыборкаШапка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	
	ВыборкаЗапасы = МассивРезультатов[1].Выбрать();
	Пока ВыборкаЗапасы.Следующий() Цикл
	
		НоваяСтрока = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаЗапасы);
	
	КонецЦикла;
	
	ВыборкаСведенияПрослеживаемости = МассивРезультатов[4].Выбрать();
	
	Пока ВыборкаСведенияПрослеживаемости.Следующий() Цикл
		
		НоваяСтрока = СведенияПрослеживаемости.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаСведенияПрослеживаемости);
		
	КонецЦикла;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДокументОснование, "Проект") Тогда
		Проект = ДокументОснование.Проект;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) И НЕ ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И Не ДанныеЗаполнения.Метаданные().ТабличныеЧасти.Найти("СерииНоменклатуры") = Неопределено Тогда
		
		СерииНоменклатуры.Очистить();
		ПеренестиСерииНоменклатуры(ДанныеЗаполнения.СерииНоменклатуры, ДанныеЗаполнения.Запасы);
		
		Если Не ДанныеЗаполнения.Метаданные().ТабличныеЧасти.Найти("СерииНоменклатурыДоКорректировки") = Неопределено Тогда
			СерииНоменклатурыДоКорректировки.Очистить();
			ПеренестиСерииНоменклатуры(ДанныеЗаполнения.СерииНоменклатурыДоКорректировки, ДанныеЗаполнения.Запасы);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
// АПК:299-вкл

Процедура ЗаполнитьСвойстваШапки(ВидОперацииЗаполнения = Неопределено) Экспорт

	Если НЕ ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	КорректировкаКорректировочногоСчетаФактуры = Ложь;
		
	ИсправляемыйДокументРеализации = Документы.КорректировкаРеализации.ПолучитьИсправляемыйДокументРеализации(ДокументОснование, Ложь);
	
	ПараметрыИсправления = Документы.КорректировкаРеализации.СформироватьПараметрыИсправленияКорректировочногоДокумента(
	, ДокументОснование, ИсправляемыйДокументРеализации);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыИсправления);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ОбработатьСуммыДоКорректировки()
	
	Запасы.ЗагрузитьКолонку(Запасы.ВыгрузитьКолонку("КоличествоДоИзменения"), 	"КоличествоДоКорректировки");
	Запасы.ЗагрузитьКолонку(Запасы.ВыгрузитьКолонку("ЦенаДоИзменения"), 		"ЦенаДоКорректировки");
	Запасы.ЗагрузитьКолонку(Запасы.ВыгрузитьКолонку("СуммаДоИзменения"), 		"СуммаДоКорректировки");
	Запасы.ЗагрузитьКолонку(Запасы.ВыгрузитьКолонку("СуммаНДСДоИзменения"), 	"СуммаНДСДоКорректировки");
	Запасы.ЗагрузитьКолонку(Запасы.ВыгрузитьКолонку("ВсегоДоИзменения"), 		"ВсегоДоКорректировки");

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли