﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет движение по текущему регистру вызывая обработчики проведения документов.
//
// Параметры:
//  Регистратор - Документ регистратор
//
Процедура ВыполнитьДвиженияСерииНоменклатуры(Регистратор) Экспорт
	
	ОтразитьСерииПриходнаяРасходнаяНакладные(Регистратор);
	ОтразитьСерииЧекиККМ(Регистратор);
	ОтразитьСерииВводНачальныхОстатков(Регистратор);
	ОтразитьСерииЗаказНаряд(Регистратор);
	ОтразитьСерииПередачаТоваровМеждуОрганизациями(Регистратор);
	ОтразитьСерииОтчетОРозничныхПродажах(Регистратор);
	ОтразитьСерииДокументыБезДопУсловий(Регистратор);
	
КонецПроцедуры

// Возвращает признак наличия битых ссылок 
//
// Параметры:
//  Регистратор - Ссылка на документ
//  ИмяТабличнойЧасти - Имя таблицы поиска
//
// Возвращаемое значение:
//  Булево - Наличие битых ссылок
//
Функция ЕстьБитыеСсылкиНаНоменклатуруВТаблице(Регистратор, ИмяТабличнойЧасти = "Запасы") Экспорт
	
	МетаданныеОбъекта = Регистратор.Метаданные();
	Если МетаданныеОбъекта.ТабличныеЧасти.Найти(ИмяТабличнойЧасти) = Неопределено Тогда
		Возврат Истина
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ТабличнаяЧасть", Регистратор[ИмяТабличнойЧасти]);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТабличнаяЧасть.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура
	|ПОМЕСТИТЬ ВременнаяТаблица
	|ИЗ
	|	&ТабличнаяЧасть КАК ТабличнаяЧасть
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблица.Номенклатура КАК Номенклатура
	|ИЗ
	|	ВременнаяТаблица КАК ВременнаяТаблица
	|ГДЕ
	|	ВременнаяТаблица.Номенклатура.СчетУчетаЗапасов ЕСТЬ NULL";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает соответствие типов документов для отражения на которые не нужно накладывать дополнительные условия
//
// Параметры:
//
// Возвращаемое значение:
//  Соответствие - Строкового наименование типу документа.
//
Функция СоответствиеТиповДокументовОтраженийБезУсловий()
	
	СоответствиеТипов = Новый Соответствие;
	СоответствиеТипов.Вставить(Тип("ДокументСсылка.ОприходованиеЗапасов"), "ОприходованиеЗапасов");
	СоответствиеТипов.Вставить(Тип("ДокументСсылка.ОтчетКомиссионера"), "ОтчетКомиссионера");
	СоответствиеТипов.Вставить(Тип("ДокументСсылка.ОтчетКомитенту"), "ОтчетКомитенту");
	СоответствиеТипов.Вставить(Тип("ДокументСсылка.ОтчетОПереработке"), "ОтчетОПереработке");
	СоответствиеТипов.Вставить(Тип("ДокументСсылка.ОтчетПереработчика"), "ОтчетПереработчика");
	СоответствиеТипов.Вставить(Тип("ДокументСсылка.ПеремещениеЗапасов"), "ПеремещениеЗапасов");
	СоответствиеТипов.Вставить(Тип("ДокументСсылка.ПеремещениеПоЯчейкам"), "ПеремещениеПоЯчейкам");
	СоответствиеТипов.Вставить(Тип("ДокументСсылка.ПересортицаЗапасов"), "ПересортицаЗапасов");
	СоответствиеТипов.Вставить(Тип("ДокументСсылка.ПриходныйОрдер"), "ПриходныйОрдер");
	СоответствиеТипов.Вставить(Тип("ДокументСсылка.РаспределениеЗатрат"), "РаспределениеЗатрат");
	СоответствиеТипов.Вставить(Тип("ДокументСсылка.РасходныйОрдер"), "РасходныйОрдер");
	СоответствиеТипов.Вставить(Тип("ДокументСсылка.СборкаЗапасов"), "СборкаЗапасов");
	СоответствиеТипов.Вставить(Тип("ДокументСсылка.СписаниеЗапасов"), "СписаниеЗапасов");
	
	Возврат СоответствиеТипов;
	
КонецФункции

Процедура ОтразитьСерииПриходнаяРасходнаяНакладные(Регистратор)
	Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.РасходнаяНакладная")
		ИЛИ ТипЗнч(Регистратор) = Тип("ДокументСсылка.ПриходнаяНакладная") Тогда
		
		ЗаблокироватьДанныеДляРедактирования(Регистратор);
		
		Отказ = Ложь;
		
		РегистраторОбъект = Регистратор.ПолучитьОбъект();
		ДополнительныеСвойства = РегистраторОбъект.ДополнительныеСвойства;
		Движения = РегистраторОбъект.Движения;
		
		// Инициализация дополнительных свойств для проведения документа.
		ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Регистратор, ДополнительныеСвойства);
		
		// Инициализация данных документа.
		Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.РасходнаяНакладная") Тогда
			// Взаиморасчеты
			СоответствиеТабличныхЧастейИРеквизитаЗаказ = Новый Соответствие;
			СоответствиеТабличныхЧастейИРеквизитаЗаказ.Вставить("Запасы", "Заказ");
			ДополнительныеСвойства.Вставить("ИмяРеквизитаЗаказ", "Заказ");
			РасчетыПроведениеДокументов.ИнициализироватьДополнительныеСвойстваДляПроведения(Регистратор, ДополнительныеСвойства, Отказ, Ложь, СоответствиеТабличныхЧастейИРеквизитаЗаказ);
			// Конец Взаиморасчеты
			Документы.РасходнаяНакладная.ИнициализироватьДанныеДокумента(Регистратор, ДополнительныеСвойства);
		КонецЕсли;
		
		Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.ПриходнаяНакладная") Тогда
			// Взаиморасчеты
			СоответствиеТабличныхЧастейИРеквизитаЗаказ = Новый Соответствие;
			СоответствиеТабличныхЧастейИРеквизитаЗаказ.Вставить("Запасы", "Заказ");
			СоответствиеТабличныхЧастейИРеквизитаЗаказ.Вставить("Расходы", "ЗаказПоставщику");
			ДополнительныеСвойства.Вставить("ИмяРеквизитаЗаказ", "Заказ");
			РасчетыПроведениеДокументов.ИнициализироватьДополнительныеСвойстваДляПроведения(Регистратор, ДополнительныеСвойства, Отказ, Истина, СоответствиеТабличныхЧастейИРеквизитаЗаказ);
			// Конец Взаиморасчеты
			Документы.ПриходнаяНакладная.ИнициализироватьДанныеДокумента(Регистратор, ДополнительныеСвойства);
		КонецЕсли;
		
		ДвижениеДляОтражения = Движения.Найти("ДвиженияСерииНоменклатуры");
		Если Не ДвижениеДляОтражения = Неопределено Тогда
			Движения.Найти("ДвиженияСерииНоменклатуры").Записывать = Истина;
		Иначе
			Возврат
		КонецЕсли;
		
		ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
		ПроведениеДокументовУНФ.ОтразитьДвижения("ДвиженияСерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
		
		// Запись наборов записей.
		ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(РегистраторОбъект);
		ПроведениеДокументовУНФ.ЗакрытьМенеджерВременныхТаблиц(РегистраторОбъект);
		
		РазблокироватьДанныеДляРедактирования(Регистратор);
		
	КонецЕсли;
КонецПроцедуры

Процедура ОтразитьСерииЧекиККМ(Регистратор)
	Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.ЧекККМ")
		ИЛИ ТипЗнч(Регистратор) = Тип("ДокументСсылка.ЧекККМВозврат") Тогда
		
		ЗаблокироватьДанныеДляРедактирования(Регистратор);
		
		Отказ = Ложь;
		
		РегистраторОбъект = Регистратор.ПолучитьОбъект();
		ДополнительныеСвойства = РегистраторОбъект.ДополнительныеСвойства;
		Движения = РегистраторОбъект.Движения;
		
		// Инициализация дополнительных свойств для проведения документа.
		ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Регистратор, ДополнительныеСвойства);
		
		// Инициализация данных документа.
		Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.ЧекККМ") Тогда
			ДополнительныеСвойства.ДляПроведения.Вставить("ЧекПробит", Регистратор.Статус = Перечисления.СтатусыЧековККМ.Пробит);
			ДополнительныеСвойства.ДляПроведения.Вставить("ТоварЗарезервирован", Регистратор.Статус = Перечисления.СтатусыЧековККМ.ТоварЗарезервирован);
			ДополнительныеСвойства.ДляПроведения.Вставить("Архивный", Регистратор.Архивный);
			ДополнительныеСвойства.ДляПроведения.Вставить("ОперацияСДенежнымиСредствами", Регистратор.ОперацияСДенежнымиСредствами);
			ДополнительныеСвойства.ДляПроведения.Вставить("ДвиженияПоЗапасамУдалять", Регистратор.ДвиженияПоЗапасамУдалять);
			
			РасчетыПроведениеДокументов.ИнициализироватьДополнительныеСвойстваДляПроведения(РегистраторОбъект, ДополнительныеСвойства, Отказ, Ложь);
			Документы.ЧекККМ.ИнициализироватьДанныеДокумента(Регистратор, ДополнительныеСвойства);
		КонецЕсли;
		
		Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.ЧекККМВозврат") Тогда
			// Взаиморасчеты
			ДополнительныеСвойства.ДляПроведения.Вставить("ЧекПробит", ЗначениеЗаполнено(Регистратор.НомерЧекаККМ));
			ДополнительныеСвойства.ДляПроведения.Вставить("Архивный", Регистратор.Архивный);
			ДополнительныеСвойства.ДляПроведения.Вставить("ДвиженияПоЗапасамУдалять", Регистратор.ДвиженияПоЗапасамУдалять);
			ДополнительныеСвойства.ДляПроведения.Вставить("ОперацияСДенежнымиСредствами", Регистратор.ОперацияСДенежнымиСредствами);
			РасчетыПроведениеДокументов.ИнициализироватьДополнительныеСвойстваДляПроведения(РегистраторОбъект, ДополнительныеСвойства, Отказ, Ложь);
			// Конец Взаиморасчеты
			Документы.ЧекККМВозврат.ИнициализироватьДанныеДокумента(Регистратор, ДополнительныеСвойства);
		КонецЕсли;
		
		ДвижениеДляОтражения = Движения.Найти("ДвиженияСерииНоменклатуры");
		Если Не ДвижениеДляОтражения = Неопределено Тогда
			Движения.Найти("ДвиженияСерииНоменклатуры").Записывать = Истина;
		Иначе
			Возврат
		КонецЕсли;
		
		ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
		ПроведениеДокументовУНФ.ОтразитьДвижения("ДвиженияСерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
		
		// Запись наборов записей.
		ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(РегистраторОбъект);
		ПроведениеДокументовУНФ.ЗакрытьМенеджерВременныхТаблиц(РегистраторОбъект);
		
		РазблокироватьДанныеДляРедактирования(Регистратор);
		
	КонецЕсли;
КонецПроцедуры

Процедура ОтразитьСерииВводНачальныхОстатков(Регистратор)
	Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.ВводНачальныхОстатков") Тогда
		
		ЗаблокироватьДанныеДляРедактирования(Регистратор);
		
		Отказ = Ложь;
		
		РегистраторОбъект = Регистратор.ПолучитьОбъект();
		ДополнительныеСвойства = РегистраторОбъект.ДополнительныеСвойства;
		Движения = РегистраторОбъект.Движения;
		
		// Инициализация дополнительных свойств для проведения документа.
		ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Регистратор, ДополнительныеСвойства);
		
		// Инициализация данных документа.
		Документы.ВводНачальныхОстатков.ИнициализироватьДанныеДокумента(Регистратор, ДополнительныеСвойства);
		
		ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
		Если ДополнительныеСвойства.ТаблицыДляДвижений.Свойство("ТаблицаЗапасы") 
			И ДополнительныеСвойства.ТаблицыДляДвижений.Свойство("ТаблицаДвиженияСерииНоменклатуры") Тогда
			
			ДвижениеДляОтражения = Движения.Найти("ДвиженияСерииНоменклатуры");
			Если Не ДвижениеДляОтражения = Неопределено Тогда
				Движения.Найти("ДвиженияСерииНоменклатуры").Записывать = Истина;
			Иначе
				Возврат
			КонецЕсли;
			
			// Серии
			ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
			ПроведениеДокументовУНФ.ОтразитьДвижения("ДвиженияСерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
			// Серии
		КонецЕсли;
		
		// Запись наборов записей.
		ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(РегистраторОбъект);
		ПроведениеДокументовУНФ.ЗакрытьМенеджерВременныхТаблиц(РегистраторОбъект);
		
		РазблокироватьДанныеДляРедактирования(Регистратор);
		
	КонецЕсли;
КонецПроцедуры

Процедура ОтразитьСерииЗаказНаряд(Регистратор)
	Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.ЗаказПокупателя") 
		И Регистратор.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд Тогда
		
		ЗаблокироватьДанныеДляРедактирования(Регистратор);
		
		Отказ = Ложь;
		
		РегистраторОбъект = Регистратор.ПолучитьОбъект();
		ДополнительныеСвойства = РегистраторОбъект.ДополнительныеСвойства;
		Движения = РегистраторОбъект.Движения;
		
		// Инициализация дополнительных свойств для проведения документа.
		ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Регистратор, ДополнительныеСвойства);
		
		// Взаиморасчеты
		СоответствиеТабличныхЧастейИРеквизитаЗаказ = Новый Соответствие;
		
		СоответствиеТабличныхЧастейИРеквизитаЗаказ.Вставить("Запасы", "Заказ");
		СоответствиеТабличныхЧастейИРеквизитаЗаказ.Вставить("Работы", "Заказ");
		
		СоответствиеВременныхТаблицИРеквизитаЗаказ = Новый Соответствие;
		СоответствиеВременныхТаблицИРеквизитаЗаказ.Вставить("Товары", "Заказ");
		СоответствиеВременныхТаблицИРеквизитаЗаказ.Вставить("Работы", "Заказ");
		ДополнительныеСвойства.Вставить("ИмяРеквизитаЗаказ", "Ссылка");
		
		РасчетыПроведениеДокументов.ИнициализироватьДополнительныеСвойстваДляПроведения(РегистраторОбъект, ДополнительныеСвойства,
		Отказ, Ложь, СоответствиеТабличныхЧастейИРеквизитаЗаказ, СоответствиеВременныхТаблицИРеквизитаЗаказ);
		// Конец Взаиморасчеты
		
		// Инициализация данных документа.
		Документы.ЗаказПокупателя.ИнициализироватьДанныеДокумента(Регистратор, ДополнительныеСвойства, РегистраторОбъект);
		
		ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
		Если ДополнительныеСвойства.ТаблицыДляДвижений.Свойство("ТаблицаДвиженияСерииНоменклатуры") Тогда
			
			ДвижениеДляОтражения = Движения.Найти("ДвиженияСерииНоменклатуры");
			Если Не ДвижениеДляОтражения = Неопределено Тогда
				Движения.Найти("ДвиженияСерииНоменклатуры").Записывать = Истина;
			Иначе
				Возврат
			КонецЕсли;
			
			// Серии
			ПроведениеДокументовУНФ.ОтразитьДвижения("ДвиженияСерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
			// Серии
		КонецЕсли;
		
		// Запись наборов записей.
		ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(РегистраторОбъект);
		ПроведениеДокументовУНФ.ЗакрытьМенеджерВременныхТаблиц(РегистраторОбъект);
		
		РазблокироватьДанныеДляРедактирования(Регистратор);
		
	КонецЕсли;
КонецПроцедуры

Процедура ОтразитьСерииПередачаТоваровМеждуОрганизациями(Регистратор)
	Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями") Тогда
		
		ЗаблокироватьДанныеДляРедактирования(Регистратор);
		
		Отказ = Ложь;
		
		РегистраторОбъект = Регистратор.ПолучитьОбъект();
		ДополнительныеСвойства = РегистраторОбъект.ДополнительныеСвойства;
		Движения = РегистраторОбъект.Движения;
		
		// Инициализация дополнительных свойств для проведения документа.
		ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Регистратор, ДополнительныеСвойства);
		
		// Взаиморасчеты
		СоответствиеТабличныхЧастейИРеквизитаЗаказ = Новый Соответствие;
		СоответствиеТабличныхЧастейИРеквизитаЗаказ.Вставить("Запасы", "Заказ");
		РасчетыПроведениеДокументов.ИнициализироватьДополнительныеСвойстваДляПроведения(РегистраторОбъект, ДополнительныеСвойства,
		Отказ, Истина, СоответствиеТабличныхЧастейИРеквизитаЗаказ);
		// Конец Взаиморасчеты
		
		// Инициализация данных документа.
		Документы.ПередачаТоваровМеждуОрганизациями.ИнициализироватьДанныеДокумента(Регистратор, ДополнительныеСвойства);
		
		ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
		Если ДополнительныеСвойства.ТаблицыДляДвижений.Свойство("ТаблицаДвиженияСерииНоменклатуры") Тогда
			
			ДвижениеДляОтражения = Движения.Найти("ДвиженияСерииНоменклатуры");
			Если Не ДвижениеДляОтражения = Неопределено Тогда
				Движения.Найти("ДвиженияСерииНоменклатуры").Записывать = Истина;
			Иначе
				Возврат
			КонецЕсли;
			
			// Серии
			ПроведениеДокументовУНФ.ОтразитьДвижения("ДвиженияСерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
			// Серии
		КонецЕсли;
		
		// Запись наборов записей.
		ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(РегистраторОбъект);
		ПроведениеДокументовУНФ.ЗакрытьМенеджерВременныхТаблиц(РегистраторОбъект);
		
		РазблокироватьДанныеДляРедактирования(Регистратор);
		
	КонецЕсли;
КонецПроцедуры

Процедура ОтразитьСерииОтчетОРозничныхПродажах(Регистратор)
	Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.ОтчетОРозничныхПродажах") Тогда
		
		ЗаблокироватьДанныеДляРедактирования(Регистратор);
		
		Отказ = Ложь;
		
		РегистраторОбъект = Регистратор.ПолучитьОбъект();
		ДополнительныеСвойства = РегистраторОбъект.ДополнительныеСвойства;
		Движения = РегистраторОбъект.Движения;
		
		// Инициализация дополнительных свойств для проведения документа
		ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Регистратор, ДополнительныеСвойства);
		
		ДополнительныеСвойства.ДляПроведения.Вставить("ПолноеПроведение", Ложь);
		
		// При закрытии смены обработка заполнения не вызывается, а значит нужно подготовить данные по серийным номерам.
		Если Не ДополнительныеСвойства.Свойство("ДанныеСерийНоменклатурыДляПроведения") Тогда
			ДанныеСерийНоменклатурыДляПроведения = СерииНоменклатурыУНФ.СвернутьСерииНоменклатурыДляПроверки(Регистратор.Запасы,Регистратор.СерииНоменклатуры);
			ДополнительныеСвойства.Вставить("ДанныеСерийНоменклатурыДляПроведения", ДанныеСерийНоменклатурыДляПроведения);
		КонецЕсли;
		
		// Инициализация данных документа
		Документы.ОтчетОРозничныхПродажах.ИнициализироватьДанныеДокумента(Регистратор, ДополнительныеСвойства);
		
		ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
		Если ДополнительныеСвойства.ТаблицыДляДвижений.Свойство("ТаблицаДвиженияСерииНоменклатуры") Тогда
			
			ДвижениеДляОтражения = Движения.Найти("ДвиженияСерииНоменклатуры");
			Если Не ДвижениеДляОтражения = Неопределено Тогда
				Движения.Найти("ДвиженияСерииНоменклатуры").Записывать = Истина;
			Иначе
				Возврат
			КонецЕсли;
			
			// Серии
			ПроведениеДокументовУНФ.ОтразитьДвижения("ДвиженияСерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
			// Серии
		КонецЕсли;
		
		// Запись наборов записей
		ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(РегистраторОбъект);
		ПроведениеДокументовУНФ.ЗакрытьМенеджерВременныхТаблиц(РегистраторОбъект);
		
		РазблокироватьДанныеДляРедактирования(Регистратор);
		
	КонецЕсли;
КонецПроцедуры

Процедура ОтразитьСерииДокументыБезДопУсловий(Регистратор)
	СоответствиеТиповБезУсловий = СоответствиеТиповДокументовОтраженийБезУсловий();
	СоответствиеТипа = СоответствиеТиповБезУсловий.Получить(ТипЗнч(Регистратор));
	
	Если Не СоответствиеТипа = Неопределено Тогда
		
		ЗаблокироватьДанныеДляРедактирования(Регистратор);
		
		Отказ = Ложь;
		
		РегистраторОбъект = Регистратор.ПолучитьОбъект();
		ДополнительныеСвойства = РегистраторОбъект.ДополнительныеСвойства;
		Движения = РегистраторОбъект.Движения;
		
		// Инициализация дополнительных свойств для проведения документа
		ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Регистратор, ДополнительныеСвойства);
		
		Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.ОтчетКомиссионера") Тогда
			ДополнительныеСвойства.Вставить("ИспользоватьНовуюСхемуДвижений", Регистратор.ИспользоватьНовуюСхемуДвижений);
			ДополнительныеСвойства.Вставить("ВидОперации", Регистратор.ВидОперации);
		КонецЕсли;
		
		// Инициализация данных документа
		Документы[СоответствиеТипа].ИнициализироватьДанныеДокумента(Регистратор, ДополнительныеСвойства);
		
		ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
		Если ДополнительныеСвойства.ТаблицыДляДвижений.Свойство("ТаблицаДвиженияСерииНоменклатуры") Тогда
			
			ДвижениеДляОтражения = Движения.Найти("ДвиженияСерииНоменклатуры");
			Если Не ДвижениеДляОтражения = Неопределено Тогда
				Движения.Найти("ДвиженияСерииНоменклатуры").Записывать = Истина;
			Иначе
				Возврат
			КонецЕсли;
			
			// Серии
			ПроведениеДокументовУНФ.ОтразитьДвижения("ДвиженияСерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
			// Серии
		КонецЕсли;
		
		// Запись наборов записей
		ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(РегистраторОбъект);
		ПроведениеДокументовУНФ.ЗакрытьМенеджерВременныхТаблиц(РегистраторОбъект);
		
		РазблокироватьДанныеДляРедактирования(Регистратор);
		
	КонецЕсли;
КонецПроцедуры


#КонецОбласти

#КонецЕсли