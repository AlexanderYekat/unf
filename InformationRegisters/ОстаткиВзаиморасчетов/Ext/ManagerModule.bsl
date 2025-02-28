﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура обновляет данные регистра для переданных контрагентов по текущим остаткам взаиморасчетов.
//
// Параметры:
//  Контрагенты	 - массив, ТаблицаЗначений	 - контрагенты, для которых необходимо обновить данные регистра.
//		Если параметр не указан, обновляются остатки по всем контрагентам.
//
Процедура ОбновитьОстаткиВзаиморасчетов(знач Контрагенты = Неопределено) Экспорт
	
	Если ТипЗнч(Контрагенты) = Тип("Массив") Тогда
		ТаблицаКонтрагентов = Новый ТаблицаЗначений;
		ТаблицаКонтрагентов.Колонки.Добавить("Контрагент", Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
		Для Каждого Контрагент Из Контрагенты Цикл
			НоваяСтрока = ТаблицаКонтрагентов.Добавить();
			НоваяСтрока.Контрагент = Контрагент;
		КонецЦикла;
		Контрагенты = ТаблицаКонтрагентов;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Если Контрагенты = Неопределено Тогда
		
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВложенныйЗапрос.Контрагент,
			|	СУММА(ВложенныйЗапрос.СуммаОстаток) КАК СуммаОстаток
			|ПОМЕСТИТЬ втВзаиморасчеты
			|ИЗ
			|	(ВЫБРАТЬ
			|		РасчетыСПокупателямиОстатки.Контрагент КАК Контрагент,
			|		РасчетыСПокупателямиОстатки.СуммаОстаток КАК СуммаОстаток
			|	ИЗ
			|		РегистрНакопления.РасчетыСПокупателями.Остатки КАК РасчетыСПокупателямиОстатки
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		РасчетыСПоставщикамиОстатки.Контрагент,
			|		-РасчетыСПоставщикамиОстатки.СуммаОстаток
			|	ИЗ
			|		РегистрНакопления.РасчетыСПоставщиками.Остатки КАК РасчетыСПоставщикамиОстатки
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		РасчетыСПрочимиКонтрагентамиОстатки.Контрагент,
			|		РасчетыСПрочимиКонтрагентамиОстатки.СуммаОстаток
			|	ИЗ
			|		РегистрНакопления.РасчетыСПрочимиКонтрагентами.Остатки КАК РасчетыСПрочимиКонтрагентамиОстатки) КАК ВложенныйЗапрос
			|
			|СГРУППИРОВАТЬ ПО
			|	ВложенныйЗапрос.Контрагент
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ЕСТЬNULL(ОстаткиВзаиморасчетов.Контрагент, втВзаиморасчеты.Контрагент) КАК Контрагент,
			|	ЕСТЬNULL(втВзаиморасчеты.СуммаОстаток, 0) КАК СуммаОстаток
			|ИЗ
			|	РегистрСведений.ОстаткиВзаиморасчетов КАК ОстаткиВзаиморасчетов
			|		ПОЛНОЕ СОЕДИНЕНИЕ втВзаиморасчеты КАК втВзаиморасчеты
			|		ПО ОстаткиВзаиморасчетов.Контрагент = втВзаиморасчеты.Контрагент";
		
	Иначе
		
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Контрагенты.Контрагент
			|ПОМЕСТИТЬ втКонтрагенты
			|ИЗ
			|	&Контрагенты КАК Контрагенты
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВложенныйЗапрос.Контрагент,
			|	СУММА(ВложенныйЗапрос.СуммаОстаток) КАК СуммаОстаток
			|ПОМЕСТИТЬ втВзаиморасчеты
			|ИЗ
			|	(ВЫБРАТЬ
			|		РасчетыСПокупателямиОстатки.Контрагент КАК Контрагент,
			|		РасчетыСПокупателямиОстатки.СуммаОстаток КАК СуммаОстаток
			|	ИЗ
			|		РегистрНакопления.РасчетыСПокупателями.Остатки(, Контрагент В (&Контрагенты)) КАК РасчетыСПокупателямиОстатки
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		РасчетыСПоставщикамиОстатки.Контрагент,
			|		-РасчетыСПоставщикамиОстатки.СуммаОстаток
			|	ИЗ
			|		РегистрНакопления.РасчетыСПоставщиками.Остатки(, Контрагент В (&Контрагенты)) КАК РасчетыСПоставщикамиОстатки
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		РасчетыСПрочимиКонтрагентамиОстатки.Контрагент,
			|		РасчетыСПрочимиКонтрагентамиОстатки.СуммаОстаток
			|	ИЗ
			|		РегистрНакопления.РасчетыСПрочимиКонтрагентами.Остатки(, Контрагент В (&Контрагенты)) КАК РасчетыСПрочимиКонтрагентамиОстатки) КАК ВложенныйЗапрос
			|
			|СГРУППИРОВАТЬ ПО
			|	ВложенныйЗапрос.Контрагент
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	втКонтрагенты.Контрагент КАК Контрагент,
			|	ЕСТЬNULL(втВзаиморасчеты.СуммаОстаток, 0) КАК СуммаОстаток
			|ИЗ
			|	втКонтрагенты КАК втКонтрагенты
			|		ЛЕВОЕ СОЕДИНЕНИЕ втВзаиморасчеты КАК втВзаиморасчеты
			|		ПО втКонтрагенты.Контрагент = втВзаиморасчеты.Контрагент";
		
		Запрос.УстановитьПараметр("Контрагенты", Контрагенты);
	
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ОстаткиВзаиморасчетов.СоздатьНаборЗаписей();
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей.Отбор.Контрагент.Установить(Выборка.Контрагент);
		
		Если Выборка.СуммаОстаток = 0 Тогда
			НаборЗаписей.Записать(Истина);
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0 Тогда
			ЗаписьНабора = НаборЗаписей[0];
		Иначе
			ЗаписьНабора = НаборЗаписей.Добавить();
		КонецЕсли;
		ЗаписьНабора.Контрагент = Выборка.Контрагент;
		ЗаписьНабора.Сумма = Выборка.СуммаОстаток;
		
		НаборЗаписей.Записать(Истина);
		НаборЗаписей.Очистить();
		
	КонецЦикла;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Контрагент)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли