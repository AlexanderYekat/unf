﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Новая таблица поиска кодов маркировки на оборудовании розлива.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Новая таблица поиска кодов маркировки на оборудовании розлива:
// * Номенклатура - ОпределяемыйТип.Номенклатура -
// * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры -
// * Серия - ОпределяемыйТип.СерияНоменклатуры -
// * Количество - Число -
// * УчитыватьСерии - Булево -
// * ИндексИсходнойСтроки - Число
Функция НоваяТаблицаПоискаКодовМаркировкиНаОборудованииРозлива() Экспорт
	
	ТаблицаТовары = Новый ТаблицаЗначений;
	ТаблицаТовары.Колонки.Добавить("Номенклатура",         Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	ТаблицаТовары.Колонки.Добавить("Характеристика",       Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	ТаблицаТовары.Колонки.Добавить("Серия",                Метаданные.ОпределяемыеТипы.СерияНоменклатуры.Тип);
	ТаблицаТовары.Колонки.Добавить("Количество",           ОбщегоНазначения.ОписаниеТипаЧисло(18, 2));
	ТаблицаТовары.Колонки.Добавить("УчитыватьСерии",       Новый ОписаниеТипов("Булево"));
	ТаблицаТовары.Колонки.Добавить("ИндексИсходнойСтроки", ОбщегоНазначения.ОписаниеТипаЧисло(10));
	
	Возврат ТаблицаТовары;
	
КонецФункции

// Коды маркировки подключенные к оборудованию розлива.
//
// Параметры:
//  ТаблицаТовары - см. НоваяТаблицаПоискаКодовМаркировкиНаОборудованииРозлива
//  ПараметрыСканирования - См. ШтрихкодированиеОбщегоНазначенияИСКлиент.ПараметрыСканирования
//  ТребуетсяПолныйКодМаркировки - Булево - Требуется полный код маркировки
//  ТолькоПолноеСоответствие - Булево - Искать без учета подменной номенклатуры
//
// Возвращаемое значение:
//  ТаблицаЗначений - Коды маркировки подключенные к оборудованию розлива:
// * Номенклатура - ОпределяемыйТип.Номенклатура -
// * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры -
// * Серия - ОпределяемыйТип.СерияНоменклатуры -
// * ИндексИсходнойСтроки - Число -
// * УчитыватьСерии - Булево -
// * ВариантЧастичногоВыбытия - ПеречислениеСсылка.ВариантыУчетаЧастичногоВыбытияИС -
// * КодМаркировки - ОпределяемыйТип.ШтрихкодУпаковкиИС -
// * Комментарий - ОпределяемыйТип.ОборудованиеРозливаИСМП-
// * КодМаркировкиСтрокой - Строка -
// * ПолныйКодМаркировки - Строка -
Функция КодыМаркировкиПодключенныеКОборудованиюРозлива(ТаблицаТовары, ПараметрыСканирования, ТребуетсяПолныйКодМаркировки = Ложь, ТолькоПолноеСоответствие = Ложь) Экспорт
	
	Если ОбщегоНазначенияИС.ЭтоРасширеннаяВерсияГосИС() Тогда
		Возврат КодыМаркировкиПодключенныеКОборудованиюРозливаРасширенная(ТаблицаТовары, ПараметрыСканирования, ТребуетсяПолныйКодМаркировки, ТолькоПолноеСоответствие);
	Иначе
		Возврат КодыМаркировкиПодключенныеКОборудованиюРозливаРМК(ТаблицаТовары, ПараметрыСканирования, ТолькоПолноеСоответствие);
	КонецЕсли;

КонецФункции

// Возвращает описание подключенных к оборудованию кег
//
// Параметры:
//   КодМаркировки - ОпределяемыйТип.ШтрихкодУпаковкиИС, Массив Из ОпределяемыйТип.ШтрихкодУпаковкиИС - Код маркировки кега
//
// Возвращаемое значение:
//   Соответствие из КлючИЗначение - найденные кеги с их описанием:
//    * Ключ - ОпределяемыйТип.ШтрихкодУпаковкиИС - Код маркировки кена
//    * Значение - см. ИнициализироватьДанныеПодключенияКОборудованию
Функция ПолучитьПодключениеКОборудованию(КодМаркировки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Соответствие;
	
	Если Не ЗначениеЗаполнено(КодМаркировки) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	
	Если ОбщегоНазначенияИС.ЭтоРасширеннаяВерсияГосИС() Тогда
		Запрос.Текст = ТекстЗапросаВскрытыеПотребительскиеУпаковки();
	Иначе
		Запрос.Текст = ТекстЗапросаВскрытыеПотребительскиеУпаковкиРМК();
	КонецЕсли;
	
	Запрос.УстановитьПараметр("КодМаркировки", КодМаркировки);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДанныеПодключения = ИнициализироватьДанныеПодключенияКОборудованию();
		ЗаполнитьЗначенияСвойств(ДанныеПодключения, Выборка);
		Результат.Вставить(Выборка.КодМаркировки, ДанныеПодключения);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Сохраняет данные подключения кега к оборудованию розлива.
// Параметр СохраненныеДанные используется для изменения ранее полученных данных при необоходимости.
//
// Параметры:
//   ДанныеПодключения - См. ИнициализироватьДанныеПодключенияКОборудованию
//   СохраненныеДанные - Неопределено
//                     - см. ИнициализироватьДанныеПодключенияКОборудованию
//
Процедура УстановитьПодключениеКОборудованию(ДанныеПодключения, СохраненныеДанные = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если СохраненныеДанные = Неопределено Тогда
		КодМаркировки = ДанныеПодключения.КодМаркировки;
	Иначе
		КодМаркировки = СохраненныеДанные.КодМаркировки;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.КодМаркировки.Установить(КодМаркировки, Истина);
	
	Если СохраненныеДанные = Неопределено Тогда
		НаборЗаписей.Прочитать();
	КонецЕсли;
	
	Если НаборЗаписей.Выбран() И СохраненныеДанные = Неопределено Тогда
		
		Если НаборЗаписей.Количество() Тогда
			ЗаписьНабора = НаборЗаписей[0];
		Иначе
			ЗаписьНабора = НаборЗаписей.Добавить();
			ЗаписьНабора.КодМаркировки = КодМаркировки;
		КонецЕсли;
		
		Для Каждого Реквизит Из Метаданные.РегистрыСведений.КегиНаОборудованииРозливаИСМП.Реквизиты Цикл
			ЗаписьНабора[Реквизит.Имя] = ДанныеПодключения[Реквизит.Имя];
		КонецЦикла;
		
	ИначеЕсли СохраненныеДанные <> Неопределено Тогда
		
		Если НаборЗаписей.Количество() Тогда
			ЗаписьНабора = НаборЗаписей[0];
		Иначе
			ЗаписьНабора = НаборЗаписей.Добавить();
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЗаписьНабора, СохраненныеДанные);
		
		Для Каждого Реквизит Из Метаданные.РегистрыСведений.КегиНаОборудованииРозливаИСМП.Реквизиты Цикл
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеПодключения, Реквизит.Имя)
				И ДанныеПодключения[Реквизит.Имя] <> Неопределено Тогда
				ЗаписьНабора[Реквизит.Имя] = ДанныеПодключения[Реквизит.Имя];
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(ЗаписьНабора, ДанныеПодключения);
		
	КонецЕсли;
	
	ЗаписьНабора.Комментарий = СокрЛП(ЗаписьНабора.Комментарий);
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Новая таблица отключения кег от оборудования розлива.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Новая таблица отключения кег от оборудования розлива:
// * КодМаркировки - ОпределяемыйТип.ШтрихкодУпаковкиИС - Кег
Функция НоваяТаблицаОтключенияКегОтОборудованияРозлива() Экспорт
	
	ТаблицаКодыМаркировки = Новый ТаблицаЗначений();
	ТаблицаКодыМаркировки.Колонки.Добавить("КодМаркировки", Метаданные.ОпределяемыеТипы.ШтрихкодУпаковкиИС.Тип);
	
	Возврат ТаблицаКодыМаркировки;
	
КонецФункции

// Отключить кеги от оборудования розлива.
//
// Параметры:
//  ТаблицаКодыМаркировки - см. НоваяТаблицаОтключенияКегОтОборудованияРозлива
//
// Возвращаемое значение:
// Структура:
// * ТекстОшибки - Неопределено, Строка - Текст ошибки при наличии
Функция ОтключитьКегиОтОборудованияРозлива(ТаблицаКодыМаркировки) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ТекстОшибки");
	
	Блокировка = Новый БлокировкаДанных();
	
	ЭлементБлокировки = Блокировка.Добавить(Метаданные.РегистрыСведений.КегиНаОборудованииРозливаИСМП.ПолноеИмя());
	ЭлементБлокировки.ИсточникДанных = ТаблицаКодыМаркировки;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("КодМаркировки", "КодМаркировки");
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка.Заблокировать();
		
		ДанныеПодключений = ПолучитьПодключениеКОборудованию(ТаблицаКодыМаркировки.ВыгрузитьКолонку("КодМаркировки"));
		
		Для Каждого СтрокаТаблицы Из ТаблицаКодыМаркировки Цикл
			
			ДанныеПодключения = ДанныеПодключений[СтрокаТаблицы.КодМаркировки];
			Если ДанныеПодключения = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если (Не ОбщегоНазначенияИСМП.ЭтоРасширеннаяВерсияГосИС()
				Или ДанныеПодключения.СтатусИСМП = Перечисления["СтатусыОбработкиПодключениеКОборудованиюРозливаИСМП"].ПодключеноКОборудованию
				Или ДанныеПодключения.ДальнейшееДействие = Перечисления["ДальнейшиеДействияПоВзаимодействиюИСМП"].НеТребуется) Тогда
				УдалитьПодключениеКОборудованию(СтрокаТаблицы.КодМаркировки);
			ИначеЕсли ДанныеПодключения.Статус <> Перечисления.СтатусыПодключенияКОборудованиюРозливаИСМП.Отключено Тогда
				НовыеДанныеПодключения = ИнициализироватьДанныеПодключенияКОборудованию();
				НовыеДанныеПодключения.Статус = Перечисления.СтатусыПодключенияКОборудованиюРозливаИСМП.Отключено;
				УстановитьПодключениеКОборудованию(НовыеДанныеПодключения, ДанныеПодключения);
			КонецЕсли;
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'Ошибка отключения кега от оборудования розлива:
				       |%1'"),
			ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ТекстОшибкиПодробно = СтрШаблон(
			НСтр("ru = 'Ошибка отключения кега от оборудования розлива:
				       |%1'"),
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		ВозвращаемоеЗначение.ТекстОшибки = ТекстОшибки;
		
		ОбщегоНазначенияИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
			ТекстОшибки,
			НСтр("ru = 'ИС МП'", ОбщегоНазначения.КодОсновногоЯзыка()),
			Метаданные.РегистрыСведений.КегиНаОборудованииРозливаИСМП,
			ТекстОшибкиПодробно);
		
	КонецПопытки;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Списки) Экспорт

	Если ОбщегоНазначенияИСМП.ЭтоРасширеннаяВерсияГосИС() Тогда
		МодульУправлениеДоступомИСПереопределяемый = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомИСПереопределяемый");
		МодульУправлениеДоступомИСПереопределяемый.ПриЗаполненииОграниченияДоступа(
			Метаданные.РегистрыСведений.КегиНаОборудованииРозливаИСМП, Списки);
	КонецЕсли;

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

Процедура ПриОпределенииКомандПодключенныхКОбъекту(Команды) Экспорт
	Возврат;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)

	Если ОбщегоНазначенияИСМП.ЭтоРасширеннаяВерсияГосИС() Тогда
		Если ВидФормы = "ФормаСписка" Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма       = "ОбщаяФорма.СписокКегНаОборудованииРозливаИСМП";
		ИначеЕсли ВидФормы = "ФормаЗаписи" Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма       = "ОбщаяФорма.ПодключенияКегаКОборудованиюРозливаИСМП";
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализировать данные подключения к оборудованию.
//
// Возвращаемое значение:
//  Структура - Инициализировать данные подключения к оборудованию:
// * КодМаркировки - СправочникСсылка.ШтрихкодыУпаковокТоваров -
// * Организация - ОпределяемыйТип.Организация -
// * Подразделение - ОпределяемыйТип.Подразделение -
// * Склад - ОпределяемыйТип.Склад -
// * Комментарий - ОпределяемыйТип.ОборудованиеРозливаИСМП -
// * Статус - ПеречислениеСсылка.СтатусыПодключенияКОборудованиюРозливаИСМП -
// * СтатусИСМП - ПеречислениеСсылка.СтатусыОбработкиПодключениеКОборудованиюРозливаИСМП -
// * ДальнейшееДействие - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП -
// * Документ - ДокументСсылка.ПодключениеКегаКОборудованиюРозливаИСМП -
// * КодФИАС - ОпределяемыйТип.УникальныйИдентификаторИС -
// * ОбъемСлива - Число -
// * СрокРеализации - Дата -
// * ДатаПодключения - Дата -
// * ПолныйКодМаркировки - Строка - Полный код маркировки (для РМК)
Функция ИнициализироватьДанныеПодключенияКОборудованию() Экспорт

	ДанныеПодключения = Новый Структура();
	ДанныеПодключения.Вставить("КодМаркировки");
	ДанныеПодключения.Вставить("Организация");
	ДанныеПодключения.Вставить("Подразделение");
	ДанныеПодключения.Вставить("Склад");
	ДанныеПодключения.Вставить("Комментарий");
	ДанныеПодключения.Вставить("Статус");
	ДанныеПодключения.Вставить("Документ");
	ДанныеПодключения.Вставить("СрокРеализации");
	ДанныеПодключения.Вставить("ДатаПодключения");
	ДанныеПодключения.Вставить("Ответственный");
	ДанныеПодключения.Вставить("АдресПодключения");
	ДанныеПодключения.Вставить("АдресПодключенияСтрокой");
	ДанныеПодключения.Вставить("ОбъемСлива");
	ДанныеПодключения.Вставить("КодФИАС");
	ДанныеПодключения.Вставить("СтатусИСМП");
	ДанныеПодключения.Вставить("ДальнейшееДействие");
	ДанныеПодключения.Вставить("ПолныйКодМаркировки");

	Возврат ДанныеПодключения;

КонецФункции

Процедура УдалитьПодключениеКОборудованию(КодМаркировки) Экспорт

	Если ТипЗнч(КодМаркировки) = Тип("Массив") Тогда
		НаборКодовМаркировки = КодМаркировки;
	Иначе
		НаборКодовМаркировки = Новый Массив();
		НаборКодовМаркировки.Добавить(КодМаркировки);
	КонецЕсли;

	Для Каждого ЗначениеКодаМаркировки Из НаборКодовМаркировки Цикл

		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.КодМаркировки.Установить(ЗначениеКодаМаркировки, Истина);
		НаборЗаписей.Записать();

	КонецЦикла;

КонецПроцедуры

Функция КодыМаркировкиПодключенныеКОборудованиюРозливаРасширенная(ТаблицаТовары, ПараметрыСканирования, ТребуетсяПолныйКодМаркировки = Ложь, ТолькоПолноеСоответствие = Ложь) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИсходнаяТаблицаТовары.Номенклатура         КАК Номенклатура,
		|	ИсходнаяТаблицаТовары.Характеристика       КАК Характеристика,
		|	ИсходнаяТаблицаТовары.Серия                КАК Серия,
		|	ИсходнаяТаблицаТовары.УчитыватьСерии       КАК УчитыватьСерии,
		|	ИсходнаяТаблицаТовары.ИндексИсходнойСтроки КАК ИндексИсходнойСтроки,
		|	ИсходнаяТаблицаТовары.Количество           КАК Количество
		|ПОМЕСТИТЬ ИсходнаяТаблицаТовары
		|ИЗ
		|	&Товары КАК ИсходнаяТаблицаТовары
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	Характеристика,
		|	Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НастройкиЧастичногоВыбытияПродукцииИСМП.Номенклатура   КАК Номенклатура,
		|	НастройкиЧастичногоВыбытияПродукцииИСМП.Характеристика КАК Характеристика,
		|	ИсходнаяТаблицаТовары.Серия                            КАК Серия,
		|	ИсходнаяТаблицаТовары.УчитыватьСерии                   КАК УчитыватьСерии,
		|	ИсходнаяТаблицаТовары.ИндексИсходнойСтроки             КАК ИндексИсходнойСтроки,
		|	ИсходнаяТаблицаТовары.Количество                       КАК Количество,
		|	ОписаниеНоменклатурыИС.ВариантЧастичногоВыбытия        КАК ВариантЧастичногоВыбытия
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	ИсходнаяТаблицаТовары КАК ИсходнаяТаблицаТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиЧастичногоВыбытияПродукцииИС КАК НастройкиЧастичногоВыбытияПродукцииИСМП
		|		ПО ИсходнаяТаблицаТовары.Номенклатура = НастройкиЧастичногоВыбытияПродукцииИСМП.НоменклатураЧастичногоВыбытия
		|		И ИсходнаяТаблицаТовары.Характеристика = НастройкиЧастичногоВыбытияПродукцииИСМП.ХарактеристикаЧастичногоВыбытия
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОписаниеНоменклатурыИС КАК ОписаниеНоменклатурыИС
		|		ПО НастройкиЧастичногоВыбытияПродукцииИСМП.Номенклатура = ОписаниеНоменклатурыИС.Номенклатура
		|ГДЕ
		|	ОписаниеНоменклатурыИС.ВариантЧастичногоВыбытия = ЗНАЧЕНИЕ(Перечисление.ВариантыУчетаЧастичногоВыбытияИС.НастроеннаяНоменклатура)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ИсходнаяТаблицаТовары.Номенклатура,
		|	ИсходнаяТаблицаТовары.Характеристика,
		|	ИсходнаяТаблицаТовары.Серия,
		|	ИсходнаяТаблицаТовары.УчитыватьСерии,
		|	ИсходнаяТаблицаТовары.ИндексИсходнойСтроки,
		|	ИсходнаяТаблицаТовары.Количество,
		|	ОписаниеНоменклатурыИС.ВариантЧастичногоВыбытия
		|ИЗ
		|	ИсходнаяТаблицаТовары КАК ИсходнаяТаблицаТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОписаниеНоменклатурыИС КАК ОписаниеНоменклатурыИС
		|		ПО ИсходнаяТаблицаТовары.Номенклатура = ОписаниеНоменклатурыИС.Номенклатура
		|ГДЕ
		|	ВЫБОР
		|		КОГДА &ТолькоПолноеСоответствие
		|			ТОГДА ОписаниеНоменклатурыИС.ВариантЧастичногоВыбытия = ЗНАЧЕНИЕ(Перечисление.ВариантыУчетаЧастичногоВыбытияИС.ТекущаяНоменклатура)
		|			ИНАЧЕ ИСТИНА
		|	КОНЕЦ
		|
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ
		|	Товары.Номенклатура                                        КАК Номенклатура,
		|	Товары.Характеристика                                      КАК Характеристика,
		|	ШтрихкодыУпаковокТоваров.Серия                             КАК Серия,
		|	Товары.ИндексИсходнойСтроки                                КАК ИндексИсходнойСтроки,
		|	Товары.УчитыватьСерии                                      КАК УчитыватьСерии,
		|	Товары.ВариантЧастичногоВыбытия                            КАК ВариантЧастичногоВыбытия,
		|	КегиНаОборудованииРозливаИСМП.КодМаркировки                КАК КодМаркировки,
		|	КегиНаОборудованииРозливаИСМП.Комментарий                  КАК Комментарий,
		|	ПРЕДСТАВЛЕНИЕ(КегиНаОборудованииРозливаИСМП.КодМаркировки) КАК КодМаркировкиСтрокой
		|ИЗ
		|	РегистрСведений.КегиНаОборудованииРозливаИСМП КАК КегиНаОборудованииРозливаИСМП
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ШтрихкодыУпаковокТоваров КАК ШтрихкодыУпаковокТоваров
		|		ПО КегиНаОборудованииРозливаИСМП.КодМаркировки = ШтрихкодыУпаковокТоваров.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Товары КАК Товары
		|		ПО ШтрихкодыУпаковокТоваров.Номенклатура = Товары.Номенклатура
		|		И ШтрихкодыУпаковокТоваров.Характеристика = Товары.Характеристика
		|		И ВЫБОР
		|			КОГДА Товары.УчитыватьСерии
		|				ТОГДА ШтрихкодыУпаковокТоваров.Серия = Товары.Серия
		|				ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|ГДЕ
		|	КегиНаОборудованииРозливаИСМП.Склад         = &Склад
		|	И КегиНаОборудованииРозливаИСМП.Организация = &Организация
		|	И КегиНаОборудованииРозливаИСМП.Статус      = ЗНАЧЕНИЕ(Перечисление.СтатусыПодключенияКОборудованиюРозливаИСМП.Подключено)";

	Запрос.УстановитьПараметр("Товары",                   ТаблицаТовары);
	Запрос.УстановитьПараметр("ТолькоПолноеСоответствие", ТолькоПолноеСоответствие);
	Запрос.УстановитьПараметр("Склад",                    ПараметрыСканирования.Склад);
	Запрос.УстановитьПараметр("Организация",              ПараметрыСканирования.Организация);

	УстановитьПривилегированныйРежим(Истина);

	ТаблицаКодовМаркировки = Запрос.Выполнить().Выгрузить();

	Если ТребуетсяПолныйКодМаркировки Тогда

		МодульШтрихкодированиеИСМП = ОбщегоНазначения.ОбщийМодуль("ШтрихкодированиеИСМП");

		ТаблицаКодовМаркировки.Колонки.Добавить("ПолныйКодМаркировки", Метаданные.РегистрыСведений.КегиНаОборудованииРозливаИСМП.Реквизиты.ПолныйКодМаркировки.Тип);

		СтрокиТаблицыПоКодамМаркировки = Новый Соответствие();
		ТаблицаПоиска = МодульШтрихкодированиеИСМП.НоваяТаблицаПоискаКодаМаркировкивПуле();
		Для Каждого СтрокаТаблицы Из ТаблицаКодовМаркировки Цикл
			СтрокиТаблицыПоКодамМаркировки.Вставить(СтрокаТаблицы.КодМаркировкиСтрокой, СтрокаТаблицы);
			МодульШтрихкодированиеИСМП.ДобавитьКодМаркировкиВТаблицуДляПоискаВПуле(
					СтрокаТаблицы.КодМаркировкиСтрокой,
					ТаблицаПоиска);
		КонецЦикла;

		КодыМаркировкиВПуле = МодульШтрихкодированиеИСМП.РезультатПоискаВПулеКодовМаркировки(ТаблицаПоиска, "ПолныйКодМаркировки");

		Для Каждого СтрокаТаблицы Из КодыМаркировкиВПуле Цикл

			ИсходнаяСтрока = СтрокиТаблицыПоКодамМаркировки[СтрокаТаблицы.КодМаркировки];
			ИсходнаяСтрока.ПолныйКодМаркировки = СтрокаТаблицы.ПолныйКодМаркировки;

		КонецЦикла;

	КонецЕсли;

	Возврат ТаблицаКодовМаркировки;

КонецФункции

Функция КодыМаркировкиПодключенныеКОборудованиюРозливаРМК(ТаблицаТовары, ПараметрыСканирования, ТолькоПолноеСоответствие = Ложь) Экспорт
	
	ВозвращаемоеЗначение = Новый ТаблицаЗначений();
	ВозвращаемоеЗначение.Колонки.Добавить("КодМаркировки",            Метаданные.ОпределяемыеТипы.ШтрихкодУпаковкиИС.Тип);
	ВозвращаемоеЗначение.Колонки.Добавить("Номенклатура",             Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	ВозвращаемоеЗначение.Колонки.Добавить("Характеристика",           Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	ВозвращаемоеЗначение.Колонки.Добавить("Серия",                    Метаданные.ОпределяемыеТипы.СерияНоменклатуры.Тип);
	ВозвращаемоеЗначение.Колонки.Добавить("ИндексИсходнойСтроки",     ОбщегоНазначения.ОписаниеТипаЧисло(3));
	ВозвращаемоеЗначение.Колонки.Добавить("УчитыватьСерии",           Новый ОписаниеТипов("Булево"));
	ВозвращаемоеЗначение.Колонки.Добавить("ВариантЧастичногоВыбытия", Новый ОписаниеТипов("ПеречислениеСсылка.ВариантыУчетаЧастичногоВыбытияИС"));
	ВозвращаемоеЗначение.Колонки.Добавить("Комментарий",              Метаданные.РегистрыСведений.КегиНаОборудованииРозливаИСМП.Реквизиты.Комментарий.Тип);
	ВозвращаемоеЗначение.Колонки.Добавить("КодМаркировкиСтрокой",     Метаданные.РегистрыСведений.КегиНаОборудованииРозливаИСМП.Реквизиты.ПолныйКодМаркировки.Тип);
	ВозвращаемоеЗначение.Колонки.Добавить("ПолныйКодМаркировки",      Метаданные.РегистрыСведений.КегиНаОборудованииРозливаИСМП.Реквизиты.ПолныйКодМаркировки.Тип);
	
	ОбщегоНазначенияИСМППереопределяемый.ПриОпределенииКодовМаркировкиКегНаОборудованииРозлива(
		ВозвращаемоеЗначение,
		ТаблицаТовары,
		ПараметрыСканирования,
		ТолькоПолноеСоответствие);
	
	Индекс = 0;
	Для Каждого СтрокаТаблицы Из ВозвращаемоеЗначение Цикл
		СтрокаТаблицы.ИндексИсходнойСтроки = Индекс;
		Индекс = Индекс +1 ;
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ТекстЗапросаВскрытыеПотребительскиеУпаковки()
	Возврат "
	|ВЫБРАТЬ
	|	КегиНаОборудованииРозливаИСМП.КодМаркировки,
	|	КегиНаОборудованииРозливаИСМП.Организация,
	|	КегиНаОборудованииРозливаИСМП.Подразделение,
	|	КегиНаОборудованииРозливаИСМП.Комментарий,
	|	КегиНаОборудованииРозливаИСМП.Статус,
	|	КегиНаОборудованииРозливаИСМП.Склад,
	|	КегиНаОборудованииРозливаИСМП.Документ,
	|	КегиНаОборудованииРозливаИСМП.СрокРеализации,
	|	КегиНаОборудованииРозливаИСМП.ДатаПодключения,
	|	КегиНаОборудованииРозливаИСМП.Ответственный,
	|	КегиНаОборудованииРозливаИСМП.КодФИАС,
	|	КегиНаОборудованииРозливаИСМП.АдресПодключения,
	|	КегиНаОборудованииРозливаИСМП.АдресПодключенияСтрокой,
	|	КегиНаОборудованииРозливаИСМП.ОбъемСлива,
	|	КегиНаОборудованииРозливаИСМП.ПолныйКодМаркировки,
	|	СтатусыДокументовИСМП.Статус              КАК СтатусИСМП,
	|	СтатусыДокументовИСМП.ДальнейшееДействие1 КАК ДальнейшееДействие
	|ИЗ
	|	РегистрСведений.КегиНаОборудованииРозливаИСМП КАК КегиНаОборудованииРозливаИСМП
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовИСМП КАК СтатусыДокументовИСМП
	|		ПО СтатусыДокументовИСМП.Документ = КегиНаОборудованииРозливаИСМП.Документ
	|ГДЕ
	|	КегиНаОборудованииРозливаИСМП.КодМаркировки В (&КодМаркировки)";
КонецФункции

Функция ТекстЗапросаВскрытыеПотребительскиеУпаковкиРМК()
	Возврат "
	|ВЫБРАТЬ
	|	КегиНаОборудованииРозливаИСМП.КодМаркировки,
	|	КегиНаОборудованииРозливаИСМП.Организация,
	|	КегиНаОборудованииРозливаИСМП.Подразделение,
	|	КегиНаОборудованииРозливаИСМП.Комментарий,
	|	КегиНаОборудованииРозливаИСМП.Статус,
	|	КегиНаОборудованииРозливаИСМП.Склад,
	|	КегиНаОборудованииРозливаИСМП.Документ,
	|	КегиНаОборудованииРозливаИСМП.СрокРеализации,
	|	КегиНаОборудованииРозливаИСМП.ДатаПодключения,
	|	КегиНаОборудованииРозливаИСМП.Ответственный,
	|	КегиНаОборудованииРозливаИСМП.КодФИАС,
	|	КегиНаОборудованииРозливаИСМП.АдресПодключения,
	|	КегиНаОборудованииРозливаИСМП.АдресПодключенияСтрокой,
	|	КегиНаОборудованииРозливаИСМП.ОбъемСлива,
	|	КегиНаОборудованииРозливаИСМП.ПолныйКодМаркировки
	|ИЗ
	|	РегистрСведений.КегиНаОборудованииРозливаИСМП КАК КегиНаОборудованииРозливаИСМП
	|ГДЕ
	|	КегиНаОборудованииРозливаИСМП.КодМаркировки В (&КодМаркировки)";
КонецФункции

#КонецОбласти

#КонецЕсли