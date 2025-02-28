﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура создает пустую временную таблицу изменения движений.
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	ЗапасыПереданные.НомерСтроки КАК НомерСтроки,
	|	ЗапасыПереданные.Организация КАК Организация,
	|	ЗапасыПереданные.Номенклатура КАК Номенклатура,
	|	ЗапасыПереданные.Характеристика КАК Характеристика,
	|	ЗапасыПереданные.Партия КАК Партия,
	|	ЗапасыПереданные.Контрагент КАК Контрагент,
	|	ЗапасыПереданные.Договор КАК Договор,
	|	ЗапасыПереданные.Заказ КАК Заказ,
	|	ЗапасыПереданные.ТипПриемаПередачи КАК ТипПриемаПередачи,
	|	ЗапасыПереданные.Количество КАК КоличествоПередЗаписью,
	|	ЗапасыПереданные.Количество КАК КоличествоИзменение,
	|	ЗапасыПереданные.Количество КАК КоличествоПриЗаписи,
	|	ЗапасыПереданные.СуммаРасчетов КАК СуммаРасчетовПередЗаписью,
	|	ЗапасыПереданные.СуммаРасчетов КАК СуммаРасчетовИзменение,
	|	ЗапасыПереданные.СуммаРасчетов КАК СуммаРасчетовПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыПереданныеИзменение
	|ИЗ
	|	РегистрНакопления.ЗапасыПереданные КАК ЗапасыПереданные");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыПереданныеИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Контрагент)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли