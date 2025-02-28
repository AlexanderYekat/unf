﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(Сотрудники.Сотрудник, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ОтзывЗаявленийОПредоставленииСведенийОТрудовойДеятельности;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведенияДокумента(СсылкаНаДокумент) Экспорт
	
	ДанныеДляПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаДокумент);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОтзывЗаявления.Ссылка.Дата КАК ДатаОтзыва,
		|	ОтзывЗаявления.Ссылка.Организация КАК Организация,
		|	ОтзывЗаявления.Сотрудник КАК ФизическоеЛицо,
		|	ОтзывЗаявления.Заявление КАК Заявление,
		|	ОтзывЗаявления.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Документ.ОтзывЗаявленийОПредоставленииСведенийОТрудовойДеятельности.Сотрудники КАК ОтзывЗаявления
		|ГДЕ
		|	ОтзывЗаявления.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	
	ДанныеДляПроведения.Вставить("ЗаявленияОВеденииТрудовыхКнижекОтозванные", Запрос.Выполнить().Выгрузить());
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли