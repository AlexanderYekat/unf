﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Сформировать печатные формы объектов
//
// Параметры:
//  МассивОбъектов - Массив - Массив ссылок на объекты которые нужно распечатать
//  ПараметрыПечати - Структура - Структура дополнительных параметров печати
//  КоллекцияПечатныхФорм - ТаблицаЗначений - Сформированные табличные документы
//  ОбъектыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ОбъектыПечати
//  ПараметрыВывода - Структура - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТОРГ2") Тогда

		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ТОРГ2",
			НСтр("ru='Акт об расхождениях (ТОРГ-2)'"), ПечатьАктаОбРасхождениях(МассивОбъектов, ОбъектыПечати),, "Обработка.ПечатьТОРГ2.ПФ_MXL_ТОРГ2");

	КонецЕсли;
	
	// параметры отправки печатных форм по электронной почте
	ЭлектроннаяПочтаУНФ.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов,
		КоллекцияПечатныхФорм);
	
КонецПроцедуры

#Область ИнтерфейсПечати

// Возвращает представление печатной формы
//
// Параметры:
//  ДополнительныеПараметры - Структура дополнительных параметров для формирования печатной формы
//
// Возвращаемое значение:
//  Строка - Представление печатной формы
//
Функция ПредставлениеПФ(ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры = Неопределено Тогда
		Возврат НСтр("ru = 'Акт о расхождениях (ТОРГ-2)'");
	Иначе
		Возврат "";
	КонецЕсли;

КонецФункции

#КонецОбласти

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

// Получает заполненную структуру по дате и имени параметра
//
// Параметры:
//  ИмяПараметра - Строка - Строка префикса имен параметров структуры
//  Дата - Дата - Дата, которую необходимо разбить на параметры.
//
// Возвращаемое значение:
//  Структура даты - Структура - содержит данные указанной даты.
//
Функция ПараметрыПоДате(ИмяПараметра, Дата)
	
	СтруктураДаты = Новый Структура;
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Возврат СтруктураДаты;
	КонецЕсли;
	СтруктураДаты.Вставить(ИмяПараметра+"День", День(Дата));
	СтруктураДаты.Вставить(ИмяПараметра+"Месяц", Сред(Формат(Дата,"ДФ=dd.MMMM"), 4));
	СтруктураДаты.Вставить(ИмяПараметра+"Год", Формат(Год(Дата), "ЧГ=0"));
	
	Возврат СтруктураДаты;
	
КонецФункции

Процедура ЗаполнитьПараметрОбластиМакета(ОбластьМакета, ИмяПараметра, ЗначениеПараметра)

	ЗначенияЗаполнения = Новый Структура(ИмяПараметра, ЗначениеПараметра);
	ОбластьМакета.Параметры.Заполнить(ЗначенияЗаполнения);

КонецПроцедуры

Функция ПечатьАктаОбРасхождениях(МассивОбъектов, ОбъектыПечати)
	ТипыОбъектов = РазложитьСписокПоТипамОбъектов(МассивОбъектов);
	
	Для Каждого ОбъектыТипа Из ТипыОбъектов Цикл
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ОбъектыТипа.Значение[0]);
		
		СоответствиеОбъектовПечати = Неопределено;
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыТОРГ2(ОбъектыТипа.Значение, СоответствиеОбъектовПечати);
		
		ДанныеСчетовФактур         = ДанныеДляПечати.ДанныеСчетовФактур.Выбрать();
		ДанныеПечати               = ДанныеДляПечати.ДанныеПечати.Выбрать();
		ТаблицаТоваров             = ДанныеДляПечати.ДанныеТовары.Выгрузить();
		ТаблицаТоваровПоДокументам = ДанныеДляПечати.ДанныеТоваровПоДокументам.Выгрузить();
		ТаблицаКурсовВалют         = ДанныеДляПечати.ДанныеКурсовВалют.Выгрузить();
		
		ПересчитатьСуммыВВалютеРегламентированногоУчета(ТаблицаТоваров, ТаблицаКурсовВалют);
		
		УстановитьПривилегированныйРежим(Истина);
		
		ДополнительнаяКолонкаПечатныхФормДокументов = Константы.ПредставлениеКодовВПечатныхФормах.Получить();
		Если ДополнительнаяКолонкаПечатныхФормДокументов = Перечисления.КодыНоменклатурыВДокументах.Артикул Тогда
			КолонкаКодов = "Артикул";
		Иначе
			КолонкаКодов = "Код";
		КонецЕсли;
		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.АвтоМасштаб = Истина;
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;

		ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ТОРГ2";

		Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьТОРГ2.ПФ_MXL_ТОРГ2");
		
		ПервыйДокумент = Истина;
		
		Пока ДанныеПечати.Следующий() Цикл
		
			Если НЕ ПервыйДокумент Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ПервыйДокумент = Ложь;
			
			// Запомним номер строки, с которой начали выводить текущий документ.
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
			ТекстНДСВШапкеТаблицы = ?(ДанныеПечати.ЦенаВключаетНДС, "", " " + НСтр("ru='(Без НДС)'", Метаданные.Языки.Русский.КодЯзыка));
			
			Область = Макет.ПолучитьОбласть("ШапкаПервойСтраницы");
			Область.Параметры.Заполнить(ДанныеПечати);
			
			Если ДанныеПечати.Операция = Перечисления.ВидыОперацийАктОРасхождениях.РасхожденияПриПриемке Тогда
				ЗаполнитьПараметрОбластиМакета(Область, "ВидОперации", НСтр("ru = 'при приемке'"));
			Иначе
				ЗаполнитьПараметрОбластиМакета(Область, "ВидОперации", НСтр("ru = 'после приемки'"));
			КонецЕсли; 
			
			ДанныеЗаполнения = Новый Структура;
			ДанныеЗаполнения.Вставить("НомерДокумента", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.НомерДокумента, Ложь, Истина));
			
			ДанныеОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.ДатаДокумента);
			ДанныеЗаполнения.Вставить("ПредставлениеОрганизации", ПечатьДокументовУНФ.ОписаниеОрганизации(ДанныеОрганизации, "ПолноеНаименование,ЮридическийАдрес,Телефоны,"));
			
			ДанныеПоставщика = ПечатьДокументовУНФ.СведенияОЮрФизЛице(ДанныеПечати.Поставщик, ДанныеПечати.ДатаДокумента);
			ДанныеЗаполнения.Вставить("Поставщик", ПечатьДокументовУНФ.ОписаниеОрганизации(ДанныеПоставщика, "ПолноеНаименование,ЮридическийАдрес,Телефоны,"));
			
			Область.Параметры.Заполнить(ПараметрыПоДате("ДатаДоговораПоставки", ДанныеПечати.ДатаДоговораПоставки));
			
			ДанныеСчетовФактур.Сбросить();
			Если ДанныеСчетовФактур.НайтиСледующий(Новый Структура("ДокументОснование", ДанныеПечати.Ссылка)) Тогда
				Область.Параметры.Заполнить(ДанныеСчетовФактур);
				ЗаполнитьПараметрОбластиМакета(Область, "НомерСчетаФактуры", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеСчетовФактур.НомерСчетаФактуры));
				Область.Параметры.Заполнить(ПараметрыПоДате("ДатаСчетаФактуры", ДанныеСчетовФактур.ДатаСчетаФактуры));
			КонецЕсли;
			
			ДанныеЗаполнения.Вставить("РуководительФИО", ДанныеПечати.Руководитель);
			
			Область.Параметры.Заполнить(ДанныеЗаполнения);
			ТабличныйДокумент.Вывести(Область);
			
			// Вывод таблицы приемки товаров
			Область = Макет.ПолучитьОбласть("ТаблицаПриемкиТоваровШапка");
			ТабличныйДокумент.Вывести(Область);
			Область = Макет.ПолучитьОбласть("ТаблицаПриемкиТоваровСтрока");
			ТабличныйДокумент.Вывести(Область);
			Область = Макет.ПолучитьОбласть("ТаблицаПриемкиТоваровПодвал");
			ТабличныйДокумент.Вывести(Область);
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
			// Страница №2 ////////////////////////////////////////////////////////////////////////////////////////////////////
			
			// Вывод шапки
			Область = Макет.ПолучитьОбласть("ШапкаВторойСтраницы");
			ТабличныйДокумент.Вывести(Область);
				
			
			// Вывод таблицы товаров по документам
			Область = Макет.ПолучитьОбласть("ТаблицаТоваровПоДокументамШапка");
			ТабличныйДокумент.Вывести(Область);
			Строки = ТаблицаТоваровПоДокументам.НайтиСтроки(Новый Структура("Ссылка",ДанныеПечати.Ссылка));
			Для Каждого Строка Из Строки Цикл
				Область = Макет.ПолучитьОбласть("ТаблицаТоваровПоДокументамСтрока");
				Область.Параметры.Заполнить(Строка);
				Если ЗначениеЗаполнено(Строка.Номенклатура) Тогда
					ЗаполнитьПараметрОбластиМакета(Область, "Товар", Строка.НоменклатураНаименование);
				Иначе
					ЗаполнитьПараметрОбластиМакета(Область, "Товар", Строка.ТекстовоеОписание);
				КонецЕсли;
				ТабличныйДокумент.Вывести(Область);
			КонецЦикла;
			Область = Макет.ПолучитьОбласть("ТаблицаТоваровПоДокументамПодвал");
			ТабличныйДокумент.Вывести(Область);
			
			// Вывод таблицы итогов
			Область = Макет.ПолучитьОбласть("ТаблицаИтогов");
			Область.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(Область);
			
			// Вывод первой части таблицы товаров
			Область = Макет.ПолучитьОбласть("ТаблицаТоваров1Шапка");
			ЗаполнитьПараметрОбластиМакета(Область, "НДС", ТекстНДСВШапкеТаблицы);
			ТабличныйДокумент.Вывести(Область);
			Область = Макет.ПолучитьОбласть("ТаблицаТоваров1Строка");
			Товары = ТаблицаТоваров.НайтиСтроки(Новый Структура("Ссылка", ДанныеПечати.Ссылка));
			Для Каждого Товар Из Товары Цикл
				Область.Параметры.Заполнить(Товар);
				Если ЗначениеЗаполнено(Товар.НоменклатураНаименование) Тогда
					ЗаполнитьПараметрОбластиМакета(Область, "Товар", Товар.НоменклатураНаименование);
				Иначе
					ЗаполнитьПараметрОбластиМакета(Область, "Товар", Товар.ТекстовоеОписание);
				КонецЕсли;
				ЗаполнитьПараметрОбластиМакета(Область, "ЗначениеКода", Товар[КолонкаКодов]);
				ТабличныйДокумент.Вывести(Область);
			КонецЦикла;
			Область = Макет.ПолучитьОбласть("ТаблицаТоваров1Подвал");
			ТабличныйДокумент.Вывести(Область);
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
			// Страница №3 ////////////////////////////////////////////////////////////////////////////////////////////////////
			
			// Вывод шапки
			Область = Макет.ПолучитьОбласть("ШапкаТретьейСтраницы");
			ТабличныйДокумент.Вывести(Область);
			
			// Вывод Температуры При Разгрузке
			Область = Макет.ПолучитьОбласть("ТемператураПриРазгрузке");
			ТабличныйДокумент.Вывести(Область);
			
			// Вывод даты вскрытия тары
			Область = Макет.ПолучитьОбласть("ДатаВскрытияТары");
			ТабличныйДокумент.Вывести(Область);
			
			
			// Вывод второй части таблицы товаров
			Область = Макет.ПолучитьОбласть("ТаблицаТоваров2Шапка");
			ЗаполнитьПараметрОбластиМакета(Область, "НДС", ТекстНДСВШапкеТаблицы);

			ТабличныйДокумент.Вывести(Область);
			Область = Макет.ПолучитьОбласть("ТаблицаТоваров2Строка");
			Для Каждого Товар Из Товары Цикл
				Область.Параметры.Заполнить(Товар);
				Если ЗначениеЗаполнено(КолонкаКодов) Тогда
					ЗаполнитьПараметрОбластиМакета(Область, "ЗначениеКода", Товар[КолонкаКодов]);
				КонецЕсли;
				ТабличныйДокумент.Вывести(Область);
			КонецЦикла;
			Область = Макет.ПолучитьОбласть("ТаблицаТоваров2Подвал");
			ТабличныйДокумент.Вывести(Область);
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
			// Страница №4 ////////////////////////////////////////////////////////////////////////////////////////////////////
			
			// Вывод шапки
			Область = Макет.ПолучитьОбласть("ШапкаЧетвертойСтраницы");
			ТабличныйДокумент.Вывести(Область);
			
			// Вывод способа определения количества
			Область = Макет.ПолучитьОбласть("СпособОпределенияКоличества");
			Область.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(Область);
			
			// Вывод членов комиссии
			Область = Макет.ПолучитьОбласть("ЧленыКомиссии");
			ТабличныйДокумент.Вывести(Область);
			
			// Вывод кладовщика
			Область = Макет.ПолучитьОбласть("Кладовщик");
			
			ТабличныйДокумент.Вывести(Область);
			
			Если СоответствиеОбъектовПечати <> Неопределено Тогда
				СсылкаНаОбъект = СоответствиеОбъектовПечати[ДанныеПечати.Ссылка];
			Иначе
				СсылкаНаОбъект = ДанныеПечати.Ссылка;
			КонецЕсли; 
			
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, СсылкаНаОбъект);
		КонецЦикла;
	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции

// Производит пересчет ценовых показателей таблицы товаров в валюте регламентированного учета.
//
// Параметры:
//  ТаблицаТоваров - ТаблицаЗначений - Таблица по товарам, содержит в том числе:
//  	* Ссылка - ДокументСсылка.АктОРасхожденияхПослеОтгрузки, ДокументСсылка.АктОРасхожденияхПослеПриемки - 
//  ТаблицаВалют   - ТаблицаЗначений - Таблица значений курсов валют.
//  ИмяФормы       - Строка          - Имя печатной формы.
Процедура ПересчитатьСуммыВВалютеРегламентированногоУчета(ТаблицаТоваров, ТаблицаВалют)
	
	СоответствиеСсылок = Новый Соответствие;    // Ключ - <ДокументСсылка.АктОРасхождениях>
	                                            // Значение - <Структура>
	
	Для Каждого Строка Из ТаблицаТоваров Цикл
		
		ТекущаяСсылка = СоответствиеСсылок[Строка.Ссылка];
		
		Если ТекущаяСсылка = Неопределено Тогда
			
			ТекущаяСсылка = Новый Структура;
			
			ОписаниеКурсовВалют = ТаблицаВалют.Найти(Строка.Ссылка, "Ссылка");
			Если ОписаниеКурсовВалют = Неопределено ИЛИ ОписаниеКурсовВалют.ПересчетНеТребуется Тогда
				ТекущаяСсылка.Вставить("ТребуетсяПересчет", Ложь);
			Иначе
				ТекущаяСсылка.Вставить("ТребуетсяПересчет", Истина);
				
				ТекущаяСсылка.Вставить("КоэффициентПересчета",
					ОписаниеКурсовВалют.КурсВалютыДокумента * ОписаниеКурсовВалют.КратностьВалютыРегламентированногоУчета
					/ (ОписаниеКурсовВалют.КратностьВалютыДокумента * ОписаниеКурсовВалют.КурсВалютыРегламентированногоУчета));
				
				ТекущаяСсылка.Вставить("ЦенаВключаетНДСПоДокументам", Строка.ЦенаВключаетНДСПоДокументам);
				ТекущаяСсылка.Вставить("ЦенаВключаетНДСПоФакту", Строка.ЦенаВключаетНДСПоДокументам);
				
				ТекущаяСсылка.Вставить("ИтогПоДокументам", 0);
				ТекущаяСсылка.Вставить("МассивПоДокументам", Новый Массив);
				ТекущаяСсылка.Вставить("ИтогПоФакту", 0);
				ТекущаяСсылка.Вставить("МассивПоФакту", Новый Массив);
				
			КонецЕсли;
			
			СоответствиеСсылок.Вставить(Строка.Ссылка, ТекущаяСсылка);
			
		КонецЕсли;
		
		Если ТекущаяСсылка.ТребуетсяПересчет Тогда
			
			Если Строка.СуммаПоДокументам <> 0 Тогда
				СуммаПоДокументам = ?(ТекущаяСсылка.ЦенаВключаетНДСПоДокументам,
					Строка.СуммаПоДокументам,
					Строка.СуммаПоДокументам+Строка.СуммаНДСПоДокументам)
					* ТекущаяСсылка.КоэффициентПересчета;
				ТекущаяСсылка.ИтогПоДокументам = ТекущаяСсылка.ИтогПоДокументам + СуммаПоДокументам;
				ТекущаяСсылка.МассивПоДокументам.Добавить(СуммаПоДокументам);
			КонецЕсли;
			Если Строка.СуммаПоФакту <> 0 Тогда
				СуммаПоФакту = ?(ТекущаяСсылка.ЦенаВключаетНДСПоФакту,
					Строка.СуммаПоФакту,
					Строка.СуммаПоФакту+Строка.СуммаНДСПоФакту)
					* ТекущаяСсылка.КоэффициентПересчета;
				ТекущаяСсылка.ИтогПоФакту = ТекущаяСсылка.ИтогПоФакту + СуммаПоФакту;
				ТекущаяСсылка.МассивПоФакту.Добавить(СуммаПоФакту);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого ТекущаяСсылка Из СоответствиеСсылок Цикл
		
		Если НЕ ТекущаяСсылка.Значение.ТребуетсяПересчет Тогда
			Продолжить;
		КонецЕсли;
		
		ТекущаяСсылка.Значение.МассивПоДокументам = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(
			ТекущаяСсылка.Значение.ИтогПоДокументам, ТекущаяСсылка.Значение.МассивПоДокументам);
		ТекущаяСсылка.Значение.МассивПоФакту = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(
			ТекущаяСсылка.Значение.ИтогПоФакту, ТекущаяСсылка.Значение.МассивПоФакту);
		
	КонецЦикла;
	
	Для Каждого Строка Из ТаблицаТоваров Цикл
		
		ТекущаяСсылка = СоответствиеСсылок[Строка.Ссылка];
		Если ТекущаяСсылка = Неопределено ИЛИ НЕ ТекущаяСсылка.ТребуетсяПересчет Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекущаяСсылка.МассивПоДокументам <> Неопределено И Строка.СуммаПоДокументам<>0 Тогда
			СуммаСНДС                   = ТекущаяСсылка.МассивПоДокументам[0];
			Строка.СуммаНДСПоДокументам = РассчитатьСуммуНДС(СуммаСНДС,Строка.СтавкаНДС);
			Строка.СуммаПоДокументам    = ?(ТекущаяСсылка.ЦенаВключаетНДСПоДокументам, СуммаСНДС, СуммаСНДС - Строка.СуммаНДСПоДокументам);
			ТекущаяСсылка.МассивПоДокументам.Удалить(0);
			Если Строка.КоличествоПоДокументам > 0 Тогда
				Строка.Цена= Строка.СуммаПоДокументам / Строка.КоличествоПоДокументам;
			КонецЕсли;
		КонецЕсли;
		
		ЦенаПоФакту = 0;
		СуммаСНДСПоФакту = 0;
		Если ТекущаяСсылка.МассивПоФакту <> Неопределено И Строка.СуммаПоФакту <> 0 Тогда
			СуммаСНДСПоФакту       = ТекущаяСсылка.МассивПоФакту[0];
			Строка.СуммаНДСПоФакту = РассчитатьСуммуНДС(СуммаСНДСПоФакту,Строка.СтавкаНДС);
			Строка.СуммаПоФакту    = ?(ТекущаяСсылка.ЦенаВключаетНДСПоФакту, СуммаСНДСПоФакту, СуммаСНДСПоФакту - Строка.СуммаНДСПоФакту);
			ТекущаяСсылка.МассивПоФакту.Удалить(0);
			Если Строка.КоличествоПоФакту > 0 Тогда
				ЦенаПоФакту = Строка.СуммаПоФакту / Строка.КоличествоПоФакту;
				Строка.Цена = ЦенаПоФакту;
			КонецЕсли;
		КонецЕсли;
		
		Строка.СуммаИзлишек   = ?(Строка.СуммаПоФакту>Строка.СуммаПоДокументам, Строка.СуммаПоФакту-Строка.СуммаПоДокументам, 0);
		Строка.СуммаНедостача = ?(Строка.СуммаПоФакту<Строка.СуммаПоДокументам, Строка.СуммаПоДокументам-Строка.СуммаПоФакту, 0);
		Строка.ЦенаПоФакту = ЦенаПоФакту;
		
	КонецЦикла;
	
КонецПроцедуры

Функция РассчитатьСуммуНДС(Сумма, ТекущаяСтавкаНДС)
	ЗначениеСтавкиНДС = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(ТекущаяСтавкаНДС);
	
	Возврат Окр(РассчитатьСуммуНДССПараметрами(Сумма, Истина, ЗначениеСтавкиНДС), 2);
КонецФункции

// Рассчитывает сумму НДС исходя из суммы и флагов налогообложения.
//
// Параметры:
//  Сумма            - Число - сумма от которой надо рассчитывать налоги;
//  СуммаВключаетНДС - Булево - признак включения НДС в сумму ("внутри" или "сверху");
//  СтавкаНДС        - Число - процентная ставка НДС.
//
// Возвращаемое значение:
//  Число - полученная сумма НДС.
//
Функция РассчитатьСуммуНДССПараметрами(Сумма, СуммаВключаетНДС, СтавкаНДС) 

	Если СуммаВключаетНДС Тогда
		СуммаБезНДС = 100 * Сумма / (100 + СтавкаНДС);
		СуммаНДС = Сумма - СуммаБезНДС;
	Иначе
		СуммаБезНДС = Сумма;
	КонецЕсли;

	Если НЕ СуммаВключаетНДС Тогда
		СуммаНДС = СуммаБезНДС * СтавкаНДС / 100;
	КонецЕсли;
	
	Возврат СуммаНДС;

КонецФункции // РассчитатьСуммуНДС()

// Функция раскладывает список значений на соответствие по типам значений.
//
// Параметры:
//  МассивОбъектов - <СписокЗначений> - список объектов различного вида
//
// Возвращаемое значение:
//   Соответствие   - соответствие в котором Ключ = Метаданные типа, Значение = массив объектов этого типа
//
Функция РазложитьСписокПоТипамОбъектов(СписокОбъектов)
	
	СтруктураТипов = Новый Соответствие;
	
	Для Каждого Объект Из СписокОбъектов Цикл
		
		МетаданныеДокумента = Объект.Метаданные();
		
		Если СтруктураТипов.Получить(МетаданныеДокумента) = Неопределено Тогда
			МассивДокументов = Новый Массив;
			СтруктураТипов.Вставить(МетаданныеДокумента, МассивДокументов);
		КонецЕсли;
		
		СтруктураТипов[МетаданныеДокумента].Добавить(Объект);
		
	КонецЦикла;
	
	Возврат СтруктураТипов;
	
КонецФункции

#КонецОбласти

#КонецЕсли