﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаОперация, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Управленческий.НомерСтроки КАК НомерСтроки,
	|	Управленческий.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический) КАК СценарийПланирования,
	|	Управленческий.СчетДт КАК СчетДт,
	|	ВЫБОР
	|		КОГДА Управленческий.СчетДт.Валютный
	|			ТОГДА Управленческий.ВалютаДт
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ВалютаДт,
	|	ВЫБОР
	|		КОГДА Управленческий.СчетДт.Валютный
	|			ТОГДА Управленческий.СуммаВалДт
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаВалДт,
	|	Управленческий.СчетКт КАК СчетКт,
	|	ВЫБОР
	|		КОГДА Управленческий.СчетКт.Валютный
	|			ТОГДА Управленческий.ВалютаКт
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ВалютаКт,
	|	ВЫБОР
	|		КОГДА Управленческий.СчетКт.Валютный
	|			ТОГДА Управленческий.СуммаВалКт
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаВалКт,
	|	Управленческий.Сумма КАК Сумма,
	|	Управленческий.Содержание КАК Содержание
	|ИЗ
	|	Документ.Операция.Проводки КАК Управленческий
	|ГДЕ
	|	Управленческий.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаОперация);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаУправленческий", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли