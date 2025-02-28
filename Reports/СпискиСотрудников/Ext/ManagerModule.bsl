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
	Результат.Добавить(Новый Структура("Имя, Представление", "СписокСотрудников", 
		НСтр("ru = 'Список сотрудников'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ПлановыеНачисления", 
		НСтр("ru = 'Плановые начисления сотрудникам'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ПаспортныеДанные", 
		НСтр("ru = 'Паспортные данные сотрудников'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "КонтактнаяИнформация", 
		НСтр("ru = 'Контактная информация сотрудников'")));
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СпискиСотрудников, "СписокСотрудников");
	Вариант.Описание = НСтр("ru = 'Отчет отображает кадровую информацию сотрудников.'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Персонал.Подсистемы.Персонал, "Важный");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СпискиСотрудников, "ПлановыеНачисления");
	Вариант.Описание = НСтр("ru = 'Отчет отображает информацию о плановых начислениях сотрудников.'");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СпискиСотрудников, "ПаспортныеДанные");
	Вариант.Описание = НСтр("ru = 'Отчет отображает паспортные данные физических лиц.'");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СпискиСотрудников, "КонтактнаяИнформация");
	Вариант.Описание = НСтр("ru = 'Отчет отображает контактную информацию физических лиц.'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли