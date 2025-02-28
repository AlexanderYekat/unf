﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Источник привлечения связанный с контактной информацией
//
// Параметры:
//  - ЗначениеКИ - Строка - значение контактной информации
//  - ЭтоОтслеживаниеНомеров - Булево
//
// Возвращаемое значение:
//  - СправочникСсылка.ИсточникиПривлеченияПокупателей
//
Функция ПолучитьИсточникПривлеченияПоКИ(ЗначениеКИ, ЭтоОтслеживаниеНомеров = Ложь) Экспорт
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОтслеживаниеИсточниковПривлечения.ИсточникПривлечения КАК ИсточникПривлечения
	|ИЗ
	|	РегистрСведений.ОтслеживаниеИсточниковПривлечения КАК ОтслеживаниеИсточниковПривлечения
	|ГДЕ
	|	ОтслеживаниеИсточниковПривлечения.ЗначениеКИ ПОДОБНО &ЗначениеКИ
	|	И НЕ ОтслеживаниеИсточниковПривлечения.ИсточникПривлечения.Недействителен";
	
	Если ЭтоОтслеживаниеНомеров Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ОтслеживаниеИсточниковПривлечения.ЗначениеКИ", "ОтслеживаниеИсточниковПривлечения.ЗначениеКИДляПоиска");
		ЗначениеКИ = КонтактнаяИнформацияУНФ.ПреобразоватьНомерДляКонтактнойИнформации(ЗначениеКИ);
	КонецЕсли;

	Запрос.УстановитьПараметр("ЗначениеКИ", ЗначениеКИ);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.ИсточникПривлечения;
	КонецЦикла;
	
	Возврат Справочники.ИсточникиПривлеченияПокупателей.ПустаяСсылка();
	
КонецФункции

#КонецОбласти

#КонецЕсли
