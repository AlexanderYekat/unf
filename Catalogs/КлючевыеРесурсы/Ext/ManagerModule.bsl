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

// Процедура заполняет данные выбора.
//
Процедура ЗаполнитьДанныеВыбора(ДанныеВыбора, Параметры)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыРесурсовПредприятия.РесурсПредприятия КАК РесурсПредприятия,
	|	ВидыРесурсовПредприятия.РесурсПредприятия.Наименование КАК РесурсПредприятияНаименование,
	|	ВидыРесурсовПредприятия.РесурсПредприятия.Код КАК РесурсПредприятияКод
	|ИЗ
	|	РегистрСведений.ВидыРесурсовПредприятия КАК ВидыРесурсовПредприятия
	|ГДЕ
	|	ВидыРесурсовПредприятия.ВидРесурсаПредприятия = &ВидРесурсаПредприятия
	|
	|СГРУППИРОВАТЬ ПО
	|	ВидыРесурсовПредприятия.РесурсПредприятия,
	|	ВидыРесурсовПредприятия.РесурсПредприятия.Наименование,
	|	ВидыРесурсовПредприятия.РесурсПредприятия.Код
	|
	|ИМЕЮЩИЕ
	|	ПОДСТРОКА(ВидыРесурсовПредприятия.РесурсПредприятия.Наименование, 1, &ДлинаПодстроки) ПОДОБНО &СтрокаПоиска
	|
	|УПОРЯДОЧИТЬ ПО
	|	РесурсПредприятияНаименование";
	
	Запрос.УстановитьПараметр("ВидРесурсаПредприятия", Параметры.ОтборВидРесурса);
	Запрос.УстановитьПараметр("СтрокаПоиска", Параметры.СтрокаПоиска);
	Запрос.УстановитьПараметр("ДлинаПодстроки", СтрДлина(Параметры.СтрокаПоиска));
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		ДанныеВыбора = Новый СписокЗначений;
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ПредставлениеВыбора = СокрЛП(Выборка.РесурсПредприятия) + " (" + СокрЛП(Выборка.РесурсПредприятияКод) + ")";
			ДанныеВыбора.Добавить(Выборка.РесурсПредприятия, ПредставлениеВыбора);
		КонецЦикла;
	КонецЕсли;
		
КонецПроцедуры // ЗаполнитьДанныеВыбора()	

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОтборВидРесурса") Тогда
		
		ОтборВидРесурса = Параметры.ОтборВидРесурса;
		Если ЗначениеЗаполнено(ОтборВидРесурса) Тогда
			
			СтандартнаяОбработка = Ложь;
			ЗаполнитьДанныеВыбора(ДанныеВыбора, Параметры);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Параметры.Отбор.Свойство("Недействителен") Тогда
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
	
КонецПроцедуры

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли