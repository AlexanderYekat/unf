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
	
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	НастройкиВариантов["ОстаткиТоваровМеньшеНуля"].Теги = НСТР("ru = 'Главное,Товары,Запасы,Склады,Продажи,Закупки,Номенклатура'");
	
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
	
	ПараметрыОтчета = ОтчетыУНФ.ПараметрыФормированияОтчета(НастройкиОтчета);
	
	УправлениеНебольшойФирмойОтчеты.УстановитьМакетОформленияОтчета(НастройкиОтчета);
	СтруктураПолейСравнения = Новый Структура;
	
	// Установка имени горизонтальной группировки по периоду для макета
	ДоступныеРесурсы = Новый Массив;
	Для каждого Элемент Из НастройкиОтчета.Выбор.ДоступныеПоляВыбора.Элементы Цикл
		Если Элемент.Ресурс Тогда
			ДоступныеРесурсы.Добавить(Элемент.Поле);
		КонецЕсли;
	КонецЦикла;
	
	ВыбранныеРесурсы = Новый Массив;
	Для Каждого Элемент Из НастройкиОтчета.Выбор.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("АвтоВыбранноеПолеКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		Если Элемент.Использование И ДоступныеРесурсы.Найти(Элемент.Поле) <> Неопределено Тогда
			ВыбранныеРесурсы.Добавить(Элемент.Поле);
		КонецЕсли;
	КонецЦикла;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	// Создадим и инициализируем процессор компоновки
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	// Создадим и инициализируем процессор вывода результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	// Обозначим начало вывода
	ПроцессорВывода.НачатьВывод();
	ТаблицаЗафиксирована = Ложь;

	ДокументРезультат.ФиксацияСверху = 0;
	
	Пока Истина Цикл
		// Получим следующий элемент результата компоновки
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();

		Если ЭлементРезультата = Неопределено Тогда
			// Следующий элемент не получен - заканчиваем цикл вывода
			Прервать;
		Иначе

			// Элемент получен - выведем его при помощи процессора вывода
			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
			
		КонецЕсли;
	КонецЦикла;

	ПроцессорВывода.ЗакончитьВывод();
	
	ОтчетыУНФ.ОбработатьДиаграммыТабличногоДокумента(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ОстаткиТоваровМеньшеНуля"].СвязанныеПоля, "СтруктурнаяЕдиница", "Справочник.СтруктурныеЕдиницы", Перечисления.ТипыСтруктурныхЕдиниц.Склад);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли