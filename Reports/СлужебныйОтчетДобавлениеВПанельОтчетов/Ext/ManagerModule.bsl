﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
	Результат.Добавить(Новый Структура("Имя, Представление", "МониторПульсБизнеса", 
		НСтр("ru = 'Пульс бизнеса'")));
	
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СлужебныйОтчетДобавлениеВПанельОтчетов, "МониторРасчетовСПокупателями");
	Вариант.Описание = НСтр("ru = 'Монитор отображает состояние расчетов с покупателями.'");
	Вариант.Включен = Ложь;
	Вариант.Размещение.Очистить();
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СлужебныйОтчетДобавлениеВПанельОтчетов, "МониторРасчетовСПоставщиками");
	Вариант.Описание = НСтр("ru = 'Монитор отображает состояние расчетов с поставщиками.'");
	Вариант.Включен = Ложь;
	Вариант.Размещение.Очистить();
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СлужебныйОтчетДобавлениеВПанельОтчетов, "МониторДенежныеСредства");
	Вариант.Описание = НСтр("ru = 'Монитор отображает динамику движения денежных средств.'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Деньги.Подсистемы.Деньги);
	Вариант.Включен = Ложь;
	Вариант.Размещение.Очистить();
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СлужебныйОтчетДобавлениеВПанельОтчетов, "МониторОбщиеПоказатели");
	Вариант.Описание = НСтр("ru = 'Монитор отображает основные показатели состояния бизнеса.'");
	Вариант.Включен = Ложь;
	Вариант.Размещение.Очистить();
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СлужебныйОтчетДобавлениеВПанельОтчетов, "МониторРуководителя");
	Вариант.Описание = НСтр("ru = 'Монитор отображает основные показатели состояния бизнеса.'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Компания.Подсистемы.Компания, "СмТакже");
	Вариант.Включен = Ложь;
	Вариант.Размещение.Очистить();
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СлужебныйОтчетДобавлениеВПанельОтчетов, "МониторРуководителяНовый");
	Вариант.Описание = НСтр("ru = 'Монитор отображает основные показатели состояния бизнеса.'");
	Вариант.Включен = Ложь;
	Вариант.Размещение.Очистить();
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СлужебныйОтчетДобавлениеВПанельОтчетов, "МониторПульсБизнеса");
	Вариант.Описание = НСтр("ru = 'Монитор отображает заданные пользователем показатели и диаграммы, характеризующие состояния бизнеса.'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)

	Если Не Параметры.Свойство("КлючВарианта") Тогда
		ВызватьИсключение НСтр("ru = 'Служебный отчет не предназначен для непосредственного использования'");
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	Параметры.Вставить("ОткрытаНеНаНачальнойСтранице", Истина);

	ИменаФормПоКлючуВарианта = Новый Соответствие;
	ИменаФормПоКлючуВарианта["МониторПульсБизнеса"] = "Обработка.ПульсБизнеса.Форма";

	ВыбраннаяФорма = ИменаФормПоКлючуВарианта[Параметры.КлючВарианта];

КонецПроцедуры

#КонецОбласти

#КонецЕсли