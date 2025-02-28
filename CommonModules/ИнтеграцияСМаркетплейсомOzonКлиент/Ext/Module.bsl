﻿#Область ПрограммныйИнтерфейс
// Показывает вопрос перед очисткой настроек авторизации.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//
Процедура ОчисткаНастроекАвторизацииВопрос(Форма) Экспорт

	Оповещение = Новый ОписаниеОповещения("ОчиститьНастройкиЗавершение", Форма);
	ТекстВопроса = НСтр("ru = 'Настройки авторизации будут удалены, что приведет к невозможности управления продажами товаров текущей учетной записи.
			|Очистить настройки?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);

КонецПроцедуры

// Показывает состояние выполнения действия.
//
// Параметры:
//  Результат - Структура   - любая структура, ожидаются ключи "КодОшибки", "ОписаниеОшибки".
//  ДополнительныеПараметры  - Структура - см. ИнтеграцияСМаркетплейсомOzonКлиент.НовоеОписаниеПараметровДействия.
//  ВывестиСообщениеОбОшибке - Булево - Признак вывода сообщения.
//
Процедура ВывестиСостояние(Результат, ДополнительныеПараметры, ВывестиСообщениеОбОшибке = Ложь) Экспорт

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Не ПустаяСтрока(Результат.КодОшибки) Тогда
		Если ВывестиСообщениеОбОшибке И Результат.Свойство("ОписаниеОшибки") Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ОписаниеОшибки);
		КонецЕсли;

		Если ДополнительныеПараметры <> Неопределено Тогда
			Состояние(ДополнительныеПараметры.ОписаниеДействия,, ДополнительныеПараметры.РезультатСОшибками);
		КонецЕсли;
	ИначеЕсли ДополнительныеПараметры <> Неопределено Тогда
		Состояние(ДополнительныеПараметры.ОписаниеДействия,, ДополнительныеПараметры.УспешныйРезультат);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КэшПодсистемы()

	ИмяПодсистемы = "Продажи.РаботаСOzon";
	Если ПараметрыПриложения[ИмяПодсистемы] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПодсистемы, Новый Структура);
	КонецЕсли;

	Возврат ПараметрыПриложения[ИмяПодсистемы];

КонецФункции

Функция КэшКатегорий() Экспорт

	КэшПодсистемы = КэшПодсистемы();

	КэшКатегорий     = Неопределено;
	НаименованиеКэша = "КэшКатегорийOzon";

	КэшПодсистемы.Свойство(НаименованиеКэша, КэшКатегорий);

	Если КэшКатегорий = Неопределено Тогда
		КэшПодсистемы.Вставить(НаименованиеКэша, Новый Структура);
	КонецЕсли;

	Возврат КэшПодсистемы[НаименованиеКэша];

КонецФункции

// Возвращает данные из кэша категорий по запрашиваемому идентификатору.
//
// Параметры:
//  ИдентификаторДанных - Строка - идентификатор данных, начинается с "Категория_", "ХарактеристикаКатегории_",
//                                 например: "Категория_100549328", "ХарактеристикаКатегории_8229".
//
// Возвращаемое значение:  
//  - Неопределено - при отсутствии данных в кэше для переданного идентификатора.
//  - ТаблицаЗначений - данные, помещаемые в кэш для переданного идентификатора,
//
Функция ПолучитьДанныеИзКэшаКатегорий(ИдентификаторДанных) Экспорт

	КэшКатегорий = КэшКатегорий(); 

	ДанныеИзКэша = Неопределено;
	КэшКатегорий.Свойство(ИдентификаторДанных, ДанныеИзКэша); 

	Возврат ДанныеИзКэша;

КонецФункции

// Помещает данные в кэш категорий по переданному идентификатору.
//
// Параметры:
//  ДанныеКэша - ТаблицаЗначений - данные, помещаемые в кэш для переданного идентификатора,
//  ИдентификаторДанных - Строка - идентификатор данных, начинается с "Категория_", "ХарактеристикаКатегории_",
//                                 например: "Категория_100549328", "ХарактеристикаКатегории_8229".
//
Процедура СохранитьДанныеВКэшКатегорий(ДанныеКэша, ИдентификаторДанных) Экспорт

	КэшКатегорий = КэшКатегорий();
	КэшКатегорий.Вставить(ИдентификаторДанных, ДанныеКэша);

КонецПроцедуры

Функция КэшПодсистемыДанныеПолучить( ИдентификаторДанных ) Экспорт

	КэшПодсистемы = КэшПодсистемы(); 

	ДанныеИзКэша = Неопределено;
	КэшПодсистемы.Свойство( ИдентификаторДанных, ДанныеИзКэша );

	Возврат ДанныеИзКэша;

КонецФункции

Процедура КэшПодсистемыДанныеСохранить( ДанныеКэша, ИдентификаторДанных ) Экспорт

	КэшПодсистемы = КэшПодсистемы(); 
	КэшПодсистемы.Вставить( ИдентификаторДанных, ДанныеКэша );

КонецПроцедуры



#КонецОбласти

