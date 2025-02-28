﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// СтандартныеПодсистемы.ВерсионированиеОбъектов
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ПереченьРеквизитовПодписейВОбъекте(ИмяОбъекта) Экспорт
	
	ДокументыСПравиламиЗаполнения = ПодписьДокументовУНФ.ДокументыСПравиламиЗаполнения();
	Если ДокументыСПравиламиЗаполнения.Найти(ИмяОбъекта) <> Неопределено Тогда
		
		Возврат Документы[ИмяОбъекта].ОписатьПравилаЗаполненияПодписей();
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Процедура ОтозватьПодписиПриУвольнении(ДополнительныеСвойства, Отказ) Экспорт
	
	ТаблицаОтзываемыхПодписей = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаОтзываемыхПодписей;
	Для каждого СтрокаТаблицы Из ТаблицаОтзываемыхПодписей Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ПодписьУвольняемого) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ПодписьОбъект = СтрокаТаблицы.ПодписьУвольняемого.ПолучитьОбъект();
		Попытка
			
			ПодписьОбъект.Заблокировать();
			ПодписьОбъект.ПравоОтозвано = Истина;
			ПодписьОбъект.Записать();
			
		Исключение
			
			Отказ = Истина;
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПодписьИспользуетсяВДокументах(ПодписьСсылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПодписьСсылка) Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(ПодписьСсылка);
	
	МассивОбластьПоиска = Новый Массив;
	Для каждого ОбъектМетаданных Из Метаданные.Документы Цикл
		
		МассивОбластьПоиска.Добавить(ОбъектМетаданных);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаСсылок = НайтиПоСсылкам(МассивСсылок, Новый Массив, МассивОбластьПоиска, Новый Массив);
	УжеИспользуется = (ТаблицаСсылок.Количество() > 0);
	ТаблицаСсылок = Неопределено;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат УжеИспользуется;
	
КонецФункции

#Область Печать

// Процедура формирования макета печати
//
Функция СформироватьПомощникСозданияФаксимилеПодписи(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент	= Новый ТабличныйДокумент;
	Макет				= УправлениеПечатью.МакетПечатнойФормы("Справочник.Подписи.ПомощникСозданияФаксимилеПодписи");
	
	Для каждого ЭлементМассива Из МассивОбъектов Цикл 
	
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("ПоляКЗаполнению"));
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Линия"));
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Схема"));
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 1, ОбъектыПечати, ЭлементМассива);
	
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;

КонецФункции // СформироватьПомощникСозданияФаксимилеПодписи()

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ОбъектыПечати         - СписокЗначений   - значение - ссылка на объект
//                                            - представление - имя области в которой был выведен объект
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "НапечататьПомощникСозданияФаксимилеПодписи") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"НапечататьПомощникСозданияФаксимилеПодписи",
			НСтр("ru='Как быстро и просто создать факсимиле подписи?'"),
			СформироватьПомощникСозданияФаксимилеПодписи(МассивОбъектов, ОбъектыПечати));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли