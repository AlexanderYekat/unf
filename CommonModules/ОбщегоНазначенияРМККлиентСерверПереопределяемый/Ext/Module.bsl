﻿
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Поясняющие_надписи_ПрограммныйИнтерфейс

// Позволяет переопределить текст подсказки настройки запрета продаж
//
// Параметры:
//  ТекстПодсказки - Строка - в этот параметр нужно записать результат.
//
Процедура ЗаполнитьТекстПодсказкиНастройкиЗапретовПродаж(ТекстПодсказки) Экспорт
	ОбщегоНазначенияРМКУНФКлиентСервер.ЗаполнитьТекстПодсказкиНастройкиЗапретовПродаж(ТекстПодсказки);
КонецПроцедуры

// Формирует коллекцию для дополнения сообщения об отсутствующих в программе данных гиперссылками
//
// Параметры:
//  ДанныеДополненияПредупреждения - Структура:
//		* ИмяСущности - Строка - имя отсутствующей сущности
//		* ДанныеДополнения - ФорматированнаяСтрока - данные с гиперссылкой на форму списка сущности.
//
Процедура ЗаполнитьДанныеДополненияПредупреждения(ДанныеДополненияПредупреждения) Экспорт
	ОбщегоНазначенияРМКУНФКлиентСервер.ЗаполнитьДанныеДополненияПредупреждения(ДанныеДополненияПредупреждения);
КонецПроцедуры

#КонецОбласти

// Заполняет день недели по дате 
//
// Параметры:
//  Результат - Неопределено, ОпределяемыйТип.ДниНеделиРМК.
//  Дата - Дата - дата, по которой определяется значение дня.
//
Процедура ЗаполнитьДеньНеделиПеречислением(Результат, Дата) Экспорт
	ОбщегоНазначенияРМКУНФКлиентСервер.ЗаполнитьДеньНеделиПеречислением(Результат, Дата);
КонецПроцедуры

// Определяет имя основной таблицы для списка видов оплат в помощнике настройки кассового места
//
// Параметры:
//  ИмяТаблицы - Строка - имя основной таблицы видов оплат до переопределения.
//
Процедура ЗаполнитьИмяОсновнойТаблицыВидовОплат(ИмяТаблицы) Экспорт
	ОбщегоНазначенияРМКУНФКлиентСервер.ЗаполнитьИмяОсновнойТаблицыВидовОплат(ИмяТаблицы);
КонецПроцедуры

// Рассчитывает сумму НДС исходя из суммы и флагов налогообложения.
//
// Параметры:
//  Объект - ДанныеФормыКоллекция - данные объекта формы рабочего места кассира.
//  ТекущаяСтрока - Структура - строка табличной части товаров для обработки.
//
Процедура РассчитатьСуммуНДС(Объект, ТекущаяСтрока) Экспорт
	ОбщегоНазначенияРМКУНФКлиентСервер.РассчитатьСуммуНДС(Объект, ТекущаяСтрока);
КонецПроцедуры

// Определяет вид отображения параметров в настройках рабочего места кассира.
// Значение по умолчанию - "Флажок".
//
// Параметры:
//  ВидОтображения - ВидФлажка - вид отображения настроек.
//
Процедура ПереопределитьВидОтображенияНастроек(ВидОтображения) Экспорт
	ОбщегоНазначенияРМКУНФКлиентСервер.ПереопределитьВидОтображенияНастроек(ВидОтображения);
КонецПроцедуры

// Определяет положения заголовка параметров в настройках рабочего места кассира.
// Значение по умолчанию - "Лево".
//
// Параметры:
//  ПоложениеЗаголовка - ПоложениеЗаголовкаЭлементаФормы - положение заголовка.
//
Процедура ПереопределитьПоложениеЗаголовкаНастроек(ПоложениеЗаголовка) Экспорт
	ОбщегоНазначенияРМКУНФКлиентСервер.ПереопределитьПоложениеЗаголовкаНастроек(ПоложениеЗаголовка);
КонецПроцедуры

// Заполняет текст ошибки, если не удалось определить доступные кассы при запуске РМК.
//
// Параметры:
//  ТекстСообщения - Строка - текст сообщения об ошибке определения кассы.
//
Процедура ЗаполнитьТекстОшибкиПриОпределенииКассы(ТекстСообщения) Экспорт
	ОбщегоНазначенияРМКУНФКлиентСервер.ЗаполнитьТекстОшибкиПриОпределенииКассы(ТекстСообщения);
КонецПроцедуры

// Заполняет текст ошибки, если не удалось определить настройки рабочего места кассира при запуске РМК.
//
// Параметры:
//  ТекстСообщения - Строка - текст сообщения при ошибке определения настройки РМК..
//
Процедура ЗаполнитьТекстОшибкиПриОпределенииНастройкиРМК(ТекстСообщения) Экспорт
	ОбщегоНазначенияРМКУНФКлиентСервер.ЗаполнитьТекстОшибкиПриОпределенииНастройкиРМК(ТекстСообщения);
КонецПроцедуры

// Переопределяет заголовок для колонки "Особенность учета" в регистре "Условия запретов продаж".
//
// Параметры:
//  Заголовок - Строка - заголовок колонки.
//
Процедура ЗаполнитьЗаголовокОсобенностьУчета(Заголовок) Экспорт
	ОбщегоНазначенияРМКУНФКлиентСервер.ЗаполнитьЗаголовокОсобенностьУчета(Заголовок);
КонецПроцедуры

// Переопределяет заголовок для колонки "Вид номенклатуры" в регистре "Условия запретов продаж".
//
// Параметры:
//  Заголовок - Строка - заголовок колонки.
//
Процедура ЗаполнитьЗаголовокВидНоменклатуры(Заголовок) Экспорт
	ОбщегоНазначенияРМКУНФКлиентСервер.ЗаполнитьЗаголовокВидНоменклатуры(Заголовок);
КонецПроцедуры

// Определяет является ли переданное значение особенности учета пивной продукцией.
//
// Параметры:
//  ОсобенностьУчета - ОпределяемыйТип.ОсобенностиУчетаНоменклатурыРМК - особенность учета.
//  Результат - Булево - Истина, если особенность учета является пивной продукцией.
//
Процедура ОпределитьОсобенностьУчетаПивнаяПродукция(ОсобенностьУчета, Результат) Экспорт
	ОбщегоНазначенияРМКУНФКлиентСервер.ОпределитьОсобенностьУчетаПивнаяПродукция(ОсобенностьУчета, Результат);
КонецПроцедуры

#КонецОбласти
