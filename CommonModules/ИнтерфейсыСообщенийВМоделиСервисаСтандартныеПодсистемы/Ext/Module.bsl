﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интерфейсы сообщений в модели сервиса", логика, которая должна
// наследоваться из БСП конфигурациями, разворачиваемыми в модели сервиса.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет переданный массив общими модулями, которые являются обработчиками интерфейсов
//  принимаемых сообщений
//
// Параметры:
//  МассивОбработчиков - массив
//
Процедура ЗаполнитьОбработчикиПринимаемыхСообщений(МассивОбработчиков) Экспорт
	
	// Сообщения удаленного администрирования
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияИнтерфейс);
	// Конец Сообщения удаленного администрирования
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных") Тогда
		
		// Сообщения управления резервным копированием
		МассивОбработчиков.Добавить(ОбщегоНазначения.ОбщийМодуль("СообщенияУправлениеРезервнымКопированиемИнтерфейс"));
		// Конец Сообщения управления резервным копированием
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса") Тогда
		
		// Сообщения контроля администрирования обмена данными
		МассивОбработчиков.Добавить(ОбщегоНазначения.ОбщийМодуль("СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс"));
		// Конец Сообщения контроля администрирования обмена данными
		
		// Сообщения управления администрированием обмена данными
		МассивОбработчиков.Добавить(ОбщегоНазначения.ОбщийМодуль("СообщенияАдминистрированиеОбменаДаннымиУправлениеИнтерфейс"));
		// Конец Сообщения управления администрированием обмена данными
		
		// Сообщения контроля обмена данными
		МассивОбработчиков.Добавить(ОбщегоНазначения.ОбщийМодуль("СообщенияОбменаДаннымиКонтрольИнтерфейс"));
		// Конец Сообщения контроля обмена данными
		
		// Сообщения управления обменом данными
		МассивОбработчиков.Добавить(ОбщегоНазначения.ОбщийМодуль("СообщенияОбменаДаннымиУправлениеИнтерфейс"));
		// Конец Сообщения управления обменом данными
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ИнформационныйЦентр") Тогда
		
		// Сообщения информационного центра
		МассивОбработчиков.Добавить(ОбщегоНазначения.ОбщийМодуль("СообщенияИнформационногоЦентраИнтерфейс"));
		// Конец Сообщения информационного центра
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет переданный массив общими модулями, которые являются обработчиками интерфейсов
//  отправляемых сообщений
//
// Параметры:
//  МассивОбработчиков - массив
//
Процедура ЗаполнитьОбработчикиОтправляемыхСообщений(МассивОбработчиков) Экспорт
	
	// Сообщения контроля удаленного администрирования
	МассивОбработчиков.Добавить(СообщенияКонтрольУдаленногоАдминистрированияИнтерфейс);
	// Конец Сообщения контроля удаленного администрирования
	
	// Сообщения управления приложениями
	МассивОбработчиков.Добавить(СообщенияУправленияПриложениямиИнтерфейс);
	// Конец Сообщения управления приложениями
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.РезервноеКопированиеОбластейДанных") Тогда
		
		// Сообщения контроля резервного копирования
		МассивОбработчиков.Добавить(ОбщегоНазначения.ОбщийМодуль("СообщенияКонтрольРезервногоКопированияИнтерфейс"));
		// Конец Сообщения контроля резервного копирования
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса") Тогда
		
		// Сообщения контроля администрирования обмена данными
		МассивОбработчиков.Добавить(ОбщегоНазначения.ОбщийМодуль("СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс"));
		// Конец Сообщения контроля администрирования обмена данными
		
		// Сообщения управления администрированием обмена данными
		МассивОбработчиков.Добавить(ОбщегоНазначения.ОбщийМодуль("СообщенияАдминистрированиеОбменаДаннымиУправлениеИнтерфейс"));
		// Конец Сообщения управления администрированием обмена данными
		
		// Сообщения контроля обмена данными
		МассивОбработчиков.Добавить(ОбщегоНазначения.ОбщийМодуль("СообщенияОбменаДаннымиКонтрольИнтерфейс"));
		// Конец Сообщения контроля обмена данными
		
		// Сообщения управления обменом данными
		МассивОбработчиков.Добавить(ОбщегоНазначения.ОбщийМодуль("СообщенияОбменаДаннымиУправлениеИнтерфейс"));
		// Конец Сообщения управления обменом данными
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
