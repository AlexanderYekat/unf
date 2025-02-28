﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура создает пустую временную таблицу изменения движений.
//
// Параметры:
//  ДополнительныеСвойства	 - 	Структура 
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда	
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	ЗаказыНаПеремещение.НомерСтроки КАК НомерСтроки,
	|	ЗаказыНаПеремещение.Организация КАК Организация,
	|	ЗаказыНаПеремещение.ЗаказНаПеремещение КАК ЗаказНаПеремещение,
	|	ЗаказыНаПеремещение.ТипДвижения КАК ТипДвижения,
	|	ЗаказыНаПеремещение.Склад КАК Склад,
	|	ЗаказыНаПеремещение.Номенклатура КАК Номенклатура,
	|	ЗаказыНаПеремещение.Характеристика КАК Характеристика,
	|	ЗаказыНаПеремещение.Количество КАК КоличествоПередЗаписью,
	|	ЗаказыНаПеремещение.Количество КАК КоличествоИзменение,
	|	ЗаказыНаПеремещение.Количество КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗаказыНаПеремещениеИзменение
	|ИЗ
	|	РегистрНакопления.ЗаказыНаПеремещение КАК ЗаказыНаПеремещение");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗаказыНаПеремещениеИзменение", Ложь);
	
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
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли