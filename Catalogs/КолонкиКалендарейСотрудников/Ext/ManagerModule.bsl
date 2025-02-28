﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция КолонкиКалендаряВладельца(Владелец) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст  = 
	"ВЫБРАТЬ
	|	КолонкиКалендарейСотрудников.Ссылка КАК Ссылка,
	|	КолонкиКалендарейСотрудников.Наименование КАК Наименование,
	|	КолонкиКалендарейСотрудников.Порядок КАК Порядок
	|ИЗ
	|	Справочник.КолонкиКалендарейСотрудников КАК КолонкиКалендарейСотрудников
	|ГДЕ
	|	КолонкиКалендарейСотрудников.Владелец = &Владелец
	|	И НЕ КолонкиКалендарейСотрудников.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	КолонкиКалендарейСотрудников.Порядок";
	
	Запрос.УстановитьПараметр("Владелец", Владелец);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция РеквизитДопУпорядочиванияДляЗаписи(Владелец) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст  = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КолонкиКалендарейСотрудников.Порядок КАК Порядок
	|ИЗ
	|	Справочник.КолонкиКалендарейСотрудников КАК КолонкиКалендарейСотрудников
	|ГДЕ
	|	КолонкиКалендарейСотрудников.Владелец = &Владелец
	|
	|УПОРЯДОЧИТЬ ПО
	|	КолонкиКалендарейСотрудников.Порядок УБЫВ";
	
	Запрос.УстановитьПараметр("Владелец", Владелец);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Результат.Пустой() Тогда
		Возврат Справочники.КалендариСотрудников.ПустаяСсылка();
	КонецЕсли;
	
	Выборка.Следующий();
	
	Возврат Выборка.Порядок + 1;
	
КонецФункции

Функция КолонкаНеобработанное(Владелец) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст  = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КолонкиКалендарейСотрудников.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КолонкиКалендарейСотрудников КАК КолонкиКалендарейСотрудников
	|ГДЕ
	|	КолонкиКалендарейСотрудников.Владелец = &Владелец
	|
	|УПОРЯДОЧИТЬ ПО
	|	КолонкиКалендарейСотрудников.Порядок";
	
	Запрос.УстановитьПараметр("Владелец", Владелец);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Результат.Пустой() Тогда
		Возврат Справочники.КалендариСотрудников.ПустаяСсылка();
	КонецЕсли;
	
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции

Процедура ПриИзмененииКолонкиЗаписи(Запись,Колонка) Экспорт
	
	Если ТипЗнч(Запись) = Тип("СправочникСсылка.ЗаписиКалендаряСотрудника") Тогда
		ИмяМетаданных = Запись.Источник.Метаданные().Имя;
	Иначе
		ИмяМетаданных = Запись.Метаданные().Имя;
	КонецЕсли;
	
	ПравилаОбъекта = Колонка.ПравилаКолонки.НайтиСтроки(Новый Структура("ОбъектПравила", ИмяМетаданных));
	Если ПравилаОбъекта.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Запись) = Тип("СправочникСсылка.ЗаписиКалендаряСотрудника") Тогда
		ОбъектЗаписи = Запись.Источник.ПолучитьОбъект();
		ОбъектЗаписи.Заблокировать();
		ОбъектЗаписи.Состояние = ПравилаОбъекта[0].Состояние;
		ОбъектЗаписи.Записать();
		ОбъектЗаписи.Разблокировать();
	Иначе
		ОбъектЗаписи = Запись.ПолучитьОбъект();
		ОбъектЗаписи.Заблокировать();
		ОбъектЗаписи.Выполнена = Истина;
		ОбъектЗаписи.Записать();
		ОбъектЗаписи.Разблокировать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьСоздатьПервуюКолонкуКалендаря(Календарь) Экспорт
	
	ПерваяКолонкаКалендаря = Справочники.КолонкиКалендарейСотрудников.КолонкаНеобработанное(Календарь.Ссылка);
	Если ЗначениеЗаполнено(ПерваяКолонкаКалендаря) Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.КолонкиКалендарейСотрудников.ДобавитьПервуюКолонку(Календарь.Ссылка);
	
КонецПроцедуры

#Область ОбновлениеИнформационнойБазыУНФ

Процедура ДобавитьПервуюКолонку(Календарь) Экспорт
	НоваяКолонка = Справочники.КолонкиКалендарейСотрудников.СоздатьЭлемент();
	НоваяКолонка.Владелец = Календарь;
	НоваяКолонка.Наименование = НСтр("ru = 'Необработанное'");
	НоваяКолонка.Порядок = 0;
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(НоваяКолонка); 
КонецПроцедуры
	
#КонецОбласти

#КонецОбласти

#КонецЕсли