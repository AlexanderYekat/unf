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
	|	ЗапасыПереданныеВРемонте.НомерСтроки КАК НомерСтроки,
	|	ЗапасыПереданныеВРемонте.Номенклатура КАК Номенклатура,
	|	ЗапасыПереданныеВРемонте.Характеристика КАК Характеристика,
	|	ЗапасыПереданныеВРемонте.Серия КАК Серия,
	|	ЗапасыПереданныеВРемонте.СервисныйЦентр КАК СервисныйЦентр,
	|	ЗапасыПереданныеВРемонте.Количество КАК КоличествоПередЗаписью,
	|	ЗапасыПереданныеВРемонте.Количество КАК КоличествоИзменение,
	|	ЗапасыПереданныеВРемонте.Количество КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыПереданныеВРемонтеИзменение
	|ИЗ
	|	РегистрНакопления.ЗапасыПереданныеВРемонте КАК ЗапасыПереданныеВРемонте");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыПереданныеВРемонте", Ложь);
	
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