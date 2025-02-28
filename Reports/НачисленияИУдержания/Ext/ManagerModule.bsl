﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Вызывается при работе в модели сервиса для получения сведений о предопределенных вариантах отчета.
//
// Возвращаемое значение:
//  Массив из Структура:
//    * Имя           - Строка - имя варианта отчета; например, "Основной";
//    * Представление - Строка - имя варианта отчета; например, НСтр("ru = 'Динамика изменений файлов'").
//
Функция ВариантыНастроек() Экспорт 
	
	Результат = Новый Массив;
	Результат.Добавить(Новый Структура("Имя, Представление", "Основной", 
		НСтр("ru = 'Начисления и удержания (упр. вал.)'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ВВалюте", 
		НСтр("ru = 'Начисления и удержания'")));
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.НачисленияИУдержания, "Основной");
	Вариант.Описание = НСтр("ru = 'В отчете отражаются данные по начислениям и удержаниям сотрудников с детализацией до вида начисления/удержания.'");
	Вариант.ФункциональныеОпции.Добавить("УчетВалютныхОпераций");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	Для Каждого РазмещениеВПодсистеме Из Вариант.Размещение Цикл
		Вариант.Размещение.Вставить(РазмещениеВПодсистеме.Ключ, "СмТакже");
	КонецЦикла; 
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.НачисленияИУдержания, "ВВалюте");
	Вариант.Описание = НСтр("ru = 'В отчете отражаются данные по начислениям и удержаниям сотрудников в валюте с детализацией до вида начисления/удержания.'");
	Для Каждого РазмещениеВПодсистеме Из Вариант.Размещение Цикл
		Вариант.Размещение.Вставить(РазмещениеВПодсистеме.Ключ, "Важный");
	КонецЦикла; 
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли