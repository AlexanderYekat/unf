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
	Результат.Добавить(Новый Структура("Имя, Представление", "Ведомость", 
		НСтр("ru = 'Расчеты по прочим операциям (упр. вал.)'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "Остатки", 
		НСтр("ru = 'Остатки расчетов по прочим операциям (упр. вал.)'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ВедомостьВВалюте", 
		НСтр("ru = 'Расчеты по прочим операциям'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ОстаткиВВалюте", 
		НСтр("ru = 'Остатки расчетов по прочим операциям'")));
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.РасчетыПоПрочимОперациям, "Ведомость");
	Вариант.Описание = НСтр("ru = 'В отчете отображаются сведения о прочих расчетах компании, включая заказы и договоры, в рамках которых заключались сделки между компанией и контрагентами.'");
	Вариант.ФункциональныеОпции.Добавить("УчетВалютныхОпераций");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Деньги.Подсистемы.Деньги, "СмТакже");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.РасчетыПоПрочимОперациям, "Остатки");
	Вариант.Описание = НСтр("ru = 'В отчете отображаются сведения о прочих расчетах компании, включая заказы и договоры, в рамках которых заключались сделки между компанией и контрагентами.'");
	Вариант.ФункциональныеОпции.Добавить("УчетВалютныхОпераций");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Деньги.Подсистемы.Деньги, "СмТакже");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.РасчетыПоПрочимОперациям, "ВедомостьВВалюте");
	Вариант.Описание = НСтр("ru = 'В отчете отображаются сведения о прочих расчетах компании в валюте расчетов, включая заказы и договоры, в рамках которых заключались сделки между компанией и контрагентами.'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Деньги.Подсистемы.Деньги, "СмТакже");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.РасчетыПоПрочимОперациям, "ОстаткиВВалюте");
	Вариант.Описание = НСтр("ru = 'В отчете отображаются сведения о прочих расчетах компании в валюте расчетов, включая заказы и договоры, в рамках которых заключались сделки между компанией и контрагентами.'");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Деньги.Подсистемы.Деньги, "СмТакже");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли