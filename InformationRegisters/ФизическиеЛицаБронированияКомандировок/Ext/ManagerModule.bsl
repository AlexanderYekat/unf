﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗарегистрироватьИзмененияСотрудниковВСпискеОтправляемых(СистемаБронирования, ФизическоеЛицо, ПричинаОтправки, Отправляется) Экспорт

	Если СистемаБронирования = Неопределено 
		Или ФизическоеЛицо = Неопределено 
		Или Отправляется = Неопределено 
		Или ПричинаОтправки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Не Отправляется 
		И ПричинаОтправки = Перечисления.ПричиныОтправкиСотрудниковБронированияКомандировок.ПоУсловию Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ФизическоеЛицо) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Список = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
	ИначеЕсли ТипЗнч(ФизическоеЛицо) = Тип("Массив") Тогда
		Список = ФизическоеЛицо;
	КонецЕсли;

	Запись = РегистрыСведений.ФизическиеЛицаБронированияКомандировок.СоздатьМенеджерЗаписи();
	Для Каждого Элемент Из Список Цикл
		Запись.СистемаБронирования = СистемаБронирования;
		Запись.ФизическоеЛицо = Элемент;
		Запись.Прочитать();
		Если Не Запись.Выбран() Тогда
			Запись.СистемаБронирования = СистемаБронирования;
			Запись.ФизическоеЛицо = Элемент;
		КонецЕсли;
		Запись.ПричинаОтправки = ПричинаОтправки;
		Запись.Отправляется = Отправляется;
		УстановитьПривилегированныйРежим(Истина);
		Запись.Записать();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЦикла;

КонецПроцедуры

Процедура ЗарегистрироватьНастройкуОтправкиСотрудника(Настройка) Экспорт

	Если Не Настройка.Отправляется 
		И Настройка.ПричинаОтправки = Перечисления.ПричиныОтправкиСотрудниковБронированияКомандировок.ПоУсловию Тогда
		Возврат;
	КонецЕсли;

	НаборЗаписей = РегистрыСведений.ФизическиеЛицаБронированияКомандировок.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.СистемаБронирования.Установить(Настройка.СистемаБронирования);
	НаборЗаписей.Отбор.ФизическоеЛицо.Установить(Настройка.ФизическоеЛицо);

	НоваяЗапись = НаборЗаписей.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяЗапись, Настройка);
	НаборЗаписей.ДополнительныеСвойства.Вставить("ОтправленоУдачно", Настройка.ОтправленоУдачно);

	УстановитьПривилегированныйРежим(Истина);
	НаборЗаписей.Записать();
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

Процедура ПолучитьНастройкуОтправкиСотрудника(Настройка) Экспорт

	Запись = РегистрыСведений.ФизическиеЛицаБронированияКомандировок.СоздатьМенеджерЗаписи();
	Запись.СистемаБронирования = Настройка.СистемаБронирования;
	Запись.ФизическоеЛицо = Настройка.ФизическоеЛицо;
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		ЗаполнитьЗначенияСвойств(Настройка, Запись)
	КонецЕсли;

КонецПроцедуры

Процедура УдалитьСотрудниковИзСпискаОтправляемых(СистемаБронирования, ФизическоеЛицо) Экспорт

	Если СистемаБронирования = Неопределено Или ФизическоеЛицо = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ФизическоеЛицо) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Список = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
	ИначеЕсли ТипЗнч(ФизическоеЛицо) = Тип("Массив") Тогда
		Список = ФизическоеЛицо;
	КонецЕсли;

	Для Каждого Элемент Из Список Цикл
		Запись = РегистрыСведений.ФизическиеЛицаБронированияКомандировок.СоздатьМенеджерЗаписи();
		Запись.СистемаБронирования = СистемаБронирования;
		Запись.ФизическоеЛицо = Элемент;
		Запись.Прочитать();
		Если Запись.Выбран() Тогда
			УстановитьПривилегированныйРежим(Истина);
			Запись.Удалить();
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецЕсли