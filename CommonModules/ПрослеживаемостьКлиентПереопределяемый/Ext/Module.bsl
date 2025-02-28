﻿#Область ПрограммныйИнтерфейс

// Процедура вызывается при выборе номенклатуры в документе 
// Уведомление об остатках прослеживаемых товаров
// 
// Параметры:
// 
// ДанныеСтрокиТаблицы - Структура - данные которые заполняются с текущей строки таблицы товаров 
//          * Номенклатура - СправочникСсылка.Номенклатура - Номеклатура
//          * ЕдиницаИзмерения - ОпределяемыйТип.ЕдиницаИзмерения -  Единица измерения
//          * Количество - Число - Количество
//          * КодОКПД2 - СправочникСсылка.КлассификаторОКПД2 - ОКПД2
//          * ЕдиницаИзмеренияПрослеживаемости - ОпределяемыйТип.ЕдиницаИзмерения - Единица измерения прослеживаемости
//          * КоличествоПрослеживаемости - Число -Количество по прослеживаемости
//          * Сумма - Число - Сумма
// 
Процедура ДанныеСтрокиТаблицыТоварыУведомленияОбОстатках(ДанныеСтрокиТаблицы) Экспорт
	
	Возврат ;
	
КонецПроцедуры

// Процедура вызывается при выборе номенклатуры в документе 
// Уведомление об остатках прослеживаемых товаров
// 
// Параметры:
// 
// ДанныеОбъекта - Структура - данные, которые заполняются с шапки объекта 
//         * КодТНВЭД - СправочникСсылка.КлассификаторТНВЭД - Код ТНВЭД
// 
Процедура ДанныеОбъектаУведомленияОбОСтатках(ДанныеОбъекта) Экспорт
	
	Возврат ;
	
КонецПроцедуры

// Процедура вызывается при выборе сопроводительного документа в табличной части Товары
// Уведомление о перемещении прослеживаемых товаров
// 
// Параметры:
// 
// Форма - ФормаКлиентскогоПриложения - Форма объекта
// ДанныеОбъекта - ТекущиеДанные - Текущие данные таблицы Контрагенты 
// 
Процедура ОткрытьФормуПодбораСопроводительногоДокумента(Форма, ТекущиеДанные) Экспорт
	
	ПрослеживаемостьФормыКлиентУНФ.ОткрытьФормуПодбораСопроводительногоДокумента(Форма, ТекущиеДанные);
	
КонецПроцедуры

// Процедура выполняет печать документов: УведомлениеОбОстаткахПрослеживаемыхТоваров,
// УведомлениеОВвозеПрослеживаемыхТоваров, УведомлениеОПеремещенииПрослеживаемыхТоваров 
// из формы 1С-отчетность вкладка отчеты
// 
// Параметры:
//   Ссылка - ДокументСсылка - Ссылка на документ уведомления 
//   СтандартнаяОбработка - Булево - признак стандартной обработки
// 
Процедура ПечатьРегламентированногоОтчета(Ссылка, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.УведомлениеОПеремещенииПрослеживаемыхТоваров") Тогда
		
		СтандартнаяОбработка = Ложь;
		Если Не ЗначениеЗаполнено(Ссылка) Тогда 
			Возврат;
		КонецЕсли;
		
		СписокПечатаемыхЛистов = ПрослеживаемостьВызовСервераПереопределяемый.ПолучитьСписокПечатаемыхЛистовНаСервере(Ссылка);
		ДополнительныеПараметры = Новый Структура("ЗаголовокФормы,Заголовок,УникальныйИдентификатор", 
			НСтр("ru='Уведомление о перемещении прослеживаемых товаров в ЕАЭС'"));
			
		РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(
			ДополнительныеПараметры, "ПоказатьБланк", , СписокПечатаемыхЛистов, ДополнительныеПараметры);
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.УведомлениеОбОстаткахПрослеживаемыхТоваров") Тогда
		
		СтандартнаяОбработка = Ложь;
		Если Не ЗначениеЗаполнено(Ссылка) Тогда 
			Возврат;
		КонецЕсли;
		
		ТекущаяПечатнаяФорма = ПрослеживаемостьВызовСервераПереопределяемый.ПолучитьСписокПечатаемыхЛистовУведомлениеОбОстатках(Ссылка);
		
		ОткрытьФормуПредварительногоПросмотра(ТекущаяПечатнаяФорма, НСтр("ru='Уведомление об остатках прослеживаемых товаров'"));
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.УведомлениеОВвозеПрослеживаемыхТоваров") Тогда
		
		СтандартнаяОбработка = Ложь;
		Если Не ЗначениеЗаполнено(Ссылка) Тогда 
			Возврат;
		КонецЕсли;
		
		ТекущаяПечатнаяФорма = ПрослеживаемостьВызовСервераПереопределяемый.ПолучитьСписокПечатаемыхЛистовУведомлениеОВвозе(Ссылка);
		
		ОткрытьФормуПредварительногоПросмотра(ТекущаяПечатнаяФорма, НСтр("ru='Уведомление о ввозе прослеживаемых товаров'"));
	
	КонецЕсли;
	
КонецПроцедуры

// Процедура открывает форму выбора первичного документа
// 
// Параметры:
// 
// Форма - ФормаКлиентскогоПриложения - Форма объекта
//
Процедура ПервичныйДокументНачалоВыбораУведомлениеОбОстатках(ВидОперации, Форма) Экспорт
	
	Если ВидОперации = 
			ПредопределенноеЗначение("Перечисление.ВидыОперацийУведомленияОбОстаткахПрослеживаемыхОбъектов.Товары")
		 ИЛИ НЕ ЗначениеЗаполнено(ВидОперации) Тогда
		
		Если ЗначениеЗаполнено(Форма.ПервичныйДокумент) Тогда
			
			ПараметрыИсходногоДокумента = Новый Структура("Ключ", Форма.ПервичныйДокумент);
			
			Если ТипЗнч(Форма.ПервичныйДокумент) = Тип("ДокументСсылка.ИнвентаризацияЗапасов") Тогда
				
				ТипПервичногоДокумента = "ИнвентаризацияЗапасов";
				
			Иначе 
				// КорректировкаРеализации
				ТипПервичногоДокумента = "КорректировкаРеализации";
				
			КонецЕсли;
			
			ОткрытьФормуПервичногоДокумента(ТипПервичногоДокумента, Форма, ПараметрыИсходногоДокумента)
			
		Иначе
			
			СписокВыбора = Новый СписокЗначений;
			СписокВыбора.Добавить("ИнвентаризацияЗапасов",  НСтр("ru='Инвентаризация запасов'"));
		
			Оповещение = Новый ОписаниеОповещения("ВыбратьТипПервичногоДокументаЗавершение", 
				ЭтотОбъект, Новый Структура("Форма", Форма));
			
			Форма.ПоказатьВыборИзМеню(Оповещение, СписокВыбора, Форма.Элементы.ПервичныйДокумент);
			
		КонецЕсли;
		
	Иначе
		
		ОткрытьФормуПервичногоДокумента("ИнвентаризацияОС", Форма)
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьЗаголовокПечатнойФормы(ОбъектыПечати) Экспорт
	
	ПараметрыПечати = УправлениеНебольшойФирмойКлиент.ПолучитьЗаголовокПечатнойФормы(ОбъектыПечати);
	
	Возврат ПараметрыПечати;
	
КонецФункции

Процедура ОткрытьФормуПредварительногоПросмотра(ТекущаяПечатнаяФорма, ТекстЗаголовкаФормы)
	
	СписокПечатныхФорм = Новый СписокЗначений;
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(ПоместитьВоВременноеХранилище(ТекущаяПечатнаяФорма));
	МассивПараметров.Добавить(Новый УникальныйИдентификатор());
	МассивПараметров.Добавить("");
	
	СписокПечатныхФорм.Добавить(МассивПараметров, ТекстЗаголовкаФормы);
	
	ДополнительныеПараметры = Новый Структура("ЗаголовокФормы,Заголовок,УникальныйИдентификатор", 
	ТекстЗаголовкаФормы);
	
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(
	ДополнительныеПараметры, "ПоказатьБланк", , СписокПечатныхФорм, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ВыбратьТипПервичногоДокументаЗавершение(ВыбранныйЭлемент, ДопПараметры) Экспорт

	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТипПервичногоДокумента = ВыбранныйЭлемент.Значение;
	
	ОткрытьФормуПервичногоДокумента(ТипПервичногоДокумента, ДопПараметры.Форма);
	
КонецПроцедуры

Процедура ОткрытьФормуПервичногоДокумента(ВыбранныйДокумент, Форма, ПараметрыДокумента = Неопределено)

	ОткрытьФорму(
		"Документ." + ВыбранныйДокумент + ".Форма.ФормаВыбора",
		ПараметрыДокумента, 
		Форма
	);
	
КонецПроцедуры

#КонецОбласти
