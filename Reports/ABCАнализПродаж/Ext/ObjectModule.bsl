﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Задать настройки формы отчета.
//
// Параметры:
//  Форма		 - ФормаКлиентскогоПриложения	 - Форма отчета
//  КлючВарианта - Строка						 - Ключ загружаемого варианта
//  Настройки	 - Структура					 - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт

	Настройки.РазрешеноИзменятьСтруктуру = Ложь;
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// Процедура - Обработчик заполнения настроек отчета и варианта
//
// Параметры:
//  НастройкиОтчета		 - Структура - Настройки отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиОтчета 
//  НастройкиВариантов	 - Структура - Настройки варианта отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиВарианта
//
Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ОтчетыУНФ.ФормаОтчетаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеВариантаНаСервере
//
// Параметры:
//  Форма			 - ФормаКлиентскогоПриложения	 - Форма отчета
//  НовыеНастройкиКД - НастройкиКомпоновкиДанных	 - Загружаемые настройки КД
//
Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПреобразоватьСтарыеНастройки(Форма, НовыеНастройкиКД);	
	РаботаССегментами.ОпределитьВидимостьОтбораПоСегментуВОтчете(Форма);
	ОтчетыУНФ.ОбновитьВидимостьОтбораОрганизация(Форма.Отчет.КомпоновщикНастроек);	
	ОтчетыУНФ.ФормаОтчетаПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеПользовательскихНастроекНаСервере
//
// Параметры:
//  Форма							 - ФормаКлиентскогоПриложения				 - Форма отчета
//  НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных - Загружаемые пользовательские
//                                                                                 настройки КД
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПеренестиПараметрыЗаголовкаВНастройки(КомпоновщикНастроек.Настройки, НовыеПользовательскиеНастройкиКД);	
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОтчетыУНФ.ОбъединитьСПользовательскимиНастройками(КомпоновщикНастроек);
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УправлениеНебольшойФирмойОтчеты.ИсправитьНастройкиГруппировок(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
	НастройкиОтчета = КомпоновщикНастроек.Настройки;
	ПараметрыОтчета = ПодготовитьПараметрыОтчета(НастройкиОтчета);
	
	СуммаПроцентов = ПараметрыОтчета.ПроцентAКласса + ПараметрыОтчета.ПроцентBКласса + ПараметрыОтчета.ПроцентCКласса;
	Если СуммаПроцентов <> 100 Тогда
		ВызватьИсключение НСтр("ru = 'Сумма процентов критериев распределения по АВС-классам должна быть равна 100%'");
	КонецЕсли; 
	
	ОтчетыУНФ.СтандартизироватьСхему(СхемаКомпоновкиДанных);
	ОтчетыУНФ.ДобавитьВычисляемыеПоля(СхемаКомпоновкиДанных);
	
	УправлениеНебольшойФирмойОтчеты.УстановитьМакетОформленияОтчета(НастройкиОтчета);
	
	РезультатРаспределения = ПолучитьРезультатРаспределения(ПараметрыОтчета);
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТаблицаКлассовОбъектов", РезультатРаспределения);
	
	Для каждого ЭлементСтруктуры Из НастройкиОтчета.Структура Цикл
		Если ТипЗнч(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных") Тогда
			ЭлементСтруктуры.Выбор.Элементы.Очистить();
			ПолеПоиска = Новый ПолеКомпоновкиДанных(ПараметрыОтчета.ПараметрАнализа);
			НайденноеПоле = ЭлементСтруктуры.Выбор.ДоступныеПоляВыбора.Элементы.Найти(ПолеПоиска);
			Если НайденноеПоле <> Неопределено Тогда
				ВыбранноеПоле = ЭлементСтруктуры.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
				ВыбранноеПоле.Поле = ПолеПоиска;
				ВыбранноеПоле.Использование = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ЭлементыУсловногоОформления = ПараметрыОтчета.НастройкиОтчета.УсловноеОформление.Элементы;
	
	СписокУдаляемыхЭлементов = Новый СписокЗначений;
	Для каждого ЭлементУсловногоОформления Из ЭлементыУсловногоОформления Цикл
		Если ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "ОформлениеПараметраАнализа" Тогда
			СписокУдаляемыхЭлементов.Добавить(ЭлементУсловногоОформления);
		КонецЕсли;
	КонецЦикла;
	Для каждого Элемент Из СписокУдаляемыхЭлементов Цикл
		ЭлементыУсловногоОформления.Удалить(Элемент.Значение);
	КонецЦикла;
	
	ЭлементУсловногоОформления = ЭлементыУсловногоОформления.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", Новый Цвет(230, 230, 230));
	ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "ОформлениеПараметраАнализа";
	ЭлементУсловногоОформления.Представление = "Оформление параметра анализа";
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ПараметрыОтчета.ПараметрАнализа);
	ОформляемоеПоле.Использование = Истина;
	
	Если ПараметрыОтчета.ОбъектАнализа = "Номенклатура" 
		И ПараметрыОтчета.ЕстьХарактеристики Тогда
		
		НовоеПоле = СхемаКомпоновкиДанных.НаборыДанных.КлассификацияОбъектов.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		НовоеПоле.Поле = "Характеристика";
		НовоеПоле.ПутьКДанным = "Характеристика";
		НовоеПоле.Роль.Измерение = Истина;
		НовоеПоле.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры");
		
		НоваяСвязь = СхемаКомпоновкиДанных.СвязиНаборовДанных.Добавить();
		НоваяСвязь.ВыражениеИсточник = "Характеристика";
		НоваяСвязь.ВыражениеПриемник = "Характеристика";
		НоваяСвязь.НаборДанныхИсточник = "КлассификацияОбъектов";
		НоваяСвязь.НаборДанныхПриемник = "ДанныеПоПродажам";
		
	КонецЕсли;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	// Создадим и инициализируем процессор компоновки
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);

	// Создадим и инициализируем процессор вывода результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	// Обозначим начало вывода
	ПроцессорВывода.НачатьВывод();
	ТаблицаЗафиксирована = Ложь;

	ДокументРезультат.ФиксацияСверху = 0;
	
	// Основной цикл вывода отчета
	ОбластиКУдалению = Новый Массив;
	КоличествоДиаграмм = 0;
	Пока Истина Цикл
		// Получим следующий элемент результата компоновки
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();

		Если ЭлементРезультата = Неопределено Тогда
			// Следующий элемент не получен - заканчиваем цикл вывода
			Прервать;
		Иначе
			// Зафиксируем шапку
			Если  Не ТаблицаЗафиксирована 
				  И ЭлементРезультата.ЗначенияПараметров.Количество() > 0 
				  И ТипЗнч(КомпоновщикНастроек.Настройки.Структура[0]) <> Тип("ДиаграммаКомпоновкиДанных") Тогда

				ТаблицаЗафиксирована = Истина;
				ДокументРезультат.ФиксацияСверху = ДокументРезультат.ВысотаТаблицы;

			КонецЕсли;
			// Элемент получен - выведем его при помощи процессора вывода
			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
			
		КонецЕсли;
	КонецЦикла;

	ПроцессорВывода.ЗакончитьВывод();
	
	Для каждого Область Из ОбластиКУдалению Цикл
		ДокументРезультат.УдалитьОбласть(Область, ТипСмещенияТабличногоДокумента.ПоВертикали);
	КонецЦикла;
	
	ОтчетыУНФ.ОбработатьДиаграммыТабличногоДокумента(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["ABCАнализПродажПоНоменклатуре"].Теги = НСтр("ru = 'Номенклатура,Продажи'"); // АПК:216
	НастройкиВариантов["ABCАнализПродажПоКатегориямНоменклатуры"].Теги = НСтр("ru = 'Категории,Продажи'"); // АПК:216
	НастройкиВариантов["ABCАнализПродажПоПокупателям"].Теги = НСтр("ru = 'Покупатели,Контрагенты,Продажи,CRM'"); // АПК:216
	НастройкиВариантов["ABCАнализПродажПоМенеджерам"].Теги = НСтр("ru = 'Менеджеры,Сотрудники,Продажи'"); // АПК:216
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ABCАнализПродажПоНоменклатуре"].СвязанныеПоля, 
		"Номенклатура", "Справочник.Номенклатура"); // АПК:216
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ABCАнализПродажПоКатегориямНоменклатуры"].СвязанныеПоля, 
		"Номенклатура.КатегорияНоменклатуры", "Справочник.КатегорииНоменклатуры"); // АПК:216
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ABCАнализПродажПоПокупателям"].СвязанныеПоля, 
		"Контрагент", "Справочник.Контрагенты"); // АПК:216
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ABCАнализПродажПоМенеджерам"].СвязанныеПоля, 
		"Ответственный", "Справочник.Сотрудники"); // АПК:216
	
КонецПроцедуры

Функция ПодготовитьПараметрыОтчета(НастройкиОтчета)
	
	НачалоПериода = Дата(1,1,1);
	КонецПериода  = Дата(1,1,1);
	ВыводитьЗаголовок = Ложь;
	Заголовок = НСтр("ru = 'ABC-анализ продаж'");
	
	ОбъектАнализа = "Номенклатура";
	ПараметрАнализа = "Количество";
	ПроцентAКласса = 80;
	ПроцентBКласса = 15;
	ПроцентCКласса = 5;
	
	ПараметрыВключаемыеВТекстОтбора = Новый Массив;
	
	ПараметрПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ПараметрПериод <> Неопределено
		И ПараметрПериод.Использование
		И ЗначениеЗаполнено(ПараметрПериод.Значение) Тогда
		
		НачалоПериода = ПараметрПериод.Значение.ДатаНачала;
		КонецПериода  = ПараметрПериод.Значение.ДатаОкончания;
	КонецЕсли;
	
	ПараметрВыводитьЗаголовок = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьЗаголовок"));
	Если ПараметрВыводитьЗаголовок <> Неопределено
		И ПараметрВыводитьЗаголовок.Использование Тогда
		
		ВыводитьЗаголовок = ПараметрВыводитьЗаголовок.Значение;
	КонецЕсли;
	
	ПараметрВывода = НастройкиОтчета.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок"));
	Если ПараметрВывода <> Неопределено
		И ПараметрВывода.Использование Тогда
		Заголовок = ПараметрВывода.Значение;
	КонецЕсли;
	
	ПараметрОбъектАнализа = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОбъектАнализа"));
	Если ПараметрОбъектАнализа <> Неопределено
		И ПараметрОбъектАнализа.Использование Тогда
		
		ОбъектАнализа = ПараметрОбъектАнализа.Значение;
		ПараметрОбъектАнализа.ПредставлениеПользовательскойНастройки = "Объект анализа";
		ПараметрыВключаемыеВТекстОтбора.Добавить(ПараметрОбъектАнализа);
	КонецЕсли;
	
	ПараметрДляАнализа = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПараметрАнализа"));
	Если ПараметрДляАнализа <> Неопределено
		И ПараметрДляАнализа.Использование Тогда
		
		ПараметрАнализа = ПараметрДляАнализа.Значение;
		ПараметрДляАнализа.ПредставлениеПользовательскойНастройки = "Параметр анализа";
		ПараметрыВключаемыеВТекстОтбора.Добавить(ПараметрДляАнализа);
	КонецЕсли;
	
	ПараметрПроцентAКласса = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПроцентAКласса"));
	Если ПараметрПроцентAКласса <> Неопределено
		И ПараметрПроцентAКласса.Использование Тогда
		
		ПроцентAКласса = ПараметрПроцентAКласса.Значение;
	КонецЕсли;
	
	ПараметрПроцентBКласса = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПроцентBКласса"));
	Если ПараметрПроцентBКласса <> Неопределено
		И ПараметрПроцентBКласса.Использование Тогда
		
		ПроцентBКласса = ПараметрПроцентBКласса.Значение;
	КонецЕсли;
	
	ПараметрПроцентCКласса = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПроцентCКласса"));
	Если ПараметрПроцентCКласса <> Неопределено
		И ПараметрПроцентCКласса.Использование Тогда
		
		ПроцентCКласса = ПараметрПроцентCКласса.Значение;
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("НачалоПериода"                  , НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                   , КонецПериода);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"              , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("Заголовок"                      , Заголовок);
	ПараметрыОтчета.Вставить("ОбъектАнализа"                  , ОбъектАнализа);
	ПараметрыОтчета.Вставить("ПараметрАнализа"                , ПараметрАнализа);
	ПараметрыОтчета.Вставить("ПроцентAКласса"                 , ПроцентAКласса);
	ПараметрыОтчета.Вставить("ПроцентBКласса"                 , ПроцентBКласса);
	ПараметрыОтчета.Вставить("ПроцентCКласса"                 , ПроцентCКласса);
	ПараметрыОтчета.Вставить("ПараметрыВключаемыеВТекстОтбора", ПараметрыВключаемыеВТекстОтбора);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"            , "ABCАнализПродаж");
	ПараметрыОтчета.Вставить("НастройкиОтчета"                , НастройкиОтчета);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

Функция ПолучитьРезультатРаспределения(ПараметрыОтчета)

	Запрос = Новый Запрос;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, ПараметрыОтчета.НастройкиОтчета);
	Запрос.Текст = МакетКомпоновкиДанных.НаборыДанных.ДанныеПоПродажам.Запрос;
	
	Для каждого Параметр Из МакетКомпоновкиДанных.ЗначенияПараметров Цикл
		Запрос.Параметры.Вставить(Параметр.Имя, Параметр.Значение);
	КонецЦикла;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ЕстьХарактеристики = СтрНайти(Запрос.Текст, "Характеристика") <> 0 И ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики");
	ПараметрыОтчета.Вставить("ЕстьХарактеристики", ЕстьХарактеристики);
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("Число"));

	КвалификаторЧисла = Новый КвалификаторыЧисла(15, 2);
	ОписаниеТипаЧисло = Новый ОписаниеТипов(Массив, КвалификаторЧисла);
	
	ТаблицаКлассовОбъектов = Новый ТаблицаЗначений;
	ТаблицаКлассовОбъектов.Колонки.Добавить("Объект");
	ТаблицаКлассовОбъектов.Колонки.Добавить("Характеристика");
	ТаблицаКлассовОбъектов.Колонки.Добавить("Класс", Новый ОписаниеТипов("Строка"));
	ТаблицаКлассовОбъектов.Колонки.Добавить("Сумма", ОписаниеТипаЧисло);
	ТаблицаКлассовОбъектов.Колонки.Добавить("Себестоимость", ОписаниеТипаЧисло);
	ТаблицаКлассовОбъектов.Колонки.Добавить("ВаловаяПрибыль", ОписаниеТипаЧисло);
	ТаблицаКлассовОбъектов.Колонки.Добавить("Количество", ОписаниеТипаЧисло);
	ТаблицаКлассовОбъектов.Колонки.Добавить("Доля", ОписаниеТипаЧисло);
	
	ЗаполнитьТаблицуКлассовОбъектов(Выборка, ТаблицаКлассовОбъектов, ПараметрыОтчета);
	
	Возврат ТаблицаКлассовОбъектов;
	
КонецФункции

// Процедура заполняет данными таблицу значений, распределяет объекты отчета по АВС-классам
// 
// Параметры
//  Выборка                - ВыборкаИзРезультатаЗапроса, по группировке объекта отчета
//  ТаблицаКлассовОбъектов - таблица значений, таблица с распределенными объектами отчета по классам
//
// Возвращаемые значения
//  НЕТ
//
Процедура ЗаполнитьТаблицуКлассовОбъектов(ВыборкаОбъектов, ТаблицаКлассовОбъектов, ПараметрыОтчета)

	Пока ВыборкаОбъектов.Следующий() Цикл
		
		НоваяСтрока = ТаблицаКлассовОбъектов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаОбъектов);
		НоваяСтрока.Объект = ВыборкаОбъектов.ОбъектАнализа;
		
	КонецЦикла;
	
	ПараметрАнализа = ПараметрыОтчета.ПараметрАнализа;
	ТаблицаКлассовОбъектов.Свернуть("Объект, Характеристика, Класс", "Сумма, Себестоимость, ВаловаяПрибыль, Количество, Доля");
	ТаблицаКлассовОбъектов.Сортировать(ПараметрАнализа + " ВОЗР");

	ВсегоСумма = ТаблицаКлассовОбъектов.Итог(ПараметрАнализа);

	СуммаВысокая = Окр((ВсегоСумма * ПараметрыОтчета.ПроцентAКласса / 100), 2);
	СуммаСредняя = Окр((ВсегоСумма * ПараметрыОтчета.ПроцентBКласса / 100), 2);
	СуммаНизкая = ВсегоСумма - СуммаВысокая - СуммаСредняя;

	СуммаНакопления = 0;
	Для каждого Строки Из ТаблицаКлассовОбъектов Цикл
		
		СуммаНакопления = СуммаНакопления + Строки[ПараметрАнализа];
		
		Если СуммаНакопления <= СуммаНизкая Тогда
			ABCКлассификация = "C-класс";
		ИначеЕсли СуммаНакопления <= (СуммаНизкая + СуммаСредняя) Тогда
			ABCКлассификация = "B-класс";
		Иначе
			ABCКлассификация = "A-класс";
		КонецЕсли;
		
		Строки.Класс = ABCКлассификация;
		Строки.Доля  = ?(ВсегоСумма=0,0,Строки[ПараметрАнализа]/ВсегоСумма*100);
		
	КонецЦикла;
	
	ТаблицаКлассовОбъектов.Сортировать(ПараметрАнализа + " УБЫВ, Класс");

КонецПроцедуры

#КонецОбласти

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли