﻿
#Область ПрограммныйИнтерфейс

// Функция - Классификатор организационно правовых форм
//
// Возвращаемое значение:
//  ТаблицаЗначений - Колонки:
//  	Код - Строка - код ОКОПФ
//  	ПолнаяФорма - Строка - полная форма наименования ОПФ
//  	КраткаяФорма - Строка - аббревиатура наименования ОПФ (может быть незаполнена)
//
Функция КлассификаторОрганизационноПравовыхФорм() Экспорт
	
	Макет = ПолучитьОбщийМакет("КлассификаторОрганизационноПравовыхФорм");
	Таблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет.ПолучитьТекст()).Данные;
	
	Возврат Таблица;
	
КонецФункции

// Функция - Классификатор форм собственности
//
// Возвращаемое значение:
//  ТаблицаЗначений - Колонки:
//  	Код - Строка - код ОКФС
//  	Наименование - Строка - наименование формы собственности
//
Функция КлассификаторФормСобственности() Экспорт
	
	Макет = ПолучитьОбщийМакет("КлассификаторФормСобственности");
	Таблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет.ПолучитьТекст()).Данные;
	
	Возврат Таблица;
	
КонецФункции

#КонецОбласти