﻿#Область ПрограммныйИнтерфейс

Функция ЭтоРасширеннаяВерсияГосИС(Подсистема = Неопределено) Экспорт
	
	Если Подсистема = Неопределено Тогда
		Подсистема = "БазоваяФункциональность";
	КонецЕсли;
	
	Возврат ОбщегоНазначенияИСКлиентСерверПовтИсп.ЭтоРасширеннаяВерсияГосИС();
	
КонецФункции

#Область ИнтегрируемыеПодсистемы

Функция ПолноеИмяПодсистемы(ИмяПодсистемы) Экспорт
	
	Возврат СтрШаблон("ГосИС.%1", ИмяПодсистемы);
	
КонецФункции

Функция ПредставлениеПодсистемы(Представление = "") Экспорт
	
	Если Не ЗначениеЗаполнено(Представление) Тогда
		Возврат НСтр("ru = '<Интеграция>'");
	Иначе
		Возврат Представление;
	КонецЕсли;
	
КонецФункции

Функция МодульКлиент(ИмяПодсистемы) Экспорт
	
	Возврат СтрШаблон("Интеграция%1Клиент", ИмяПодсистемы);
	
КонецФункции

Функция МодульСервер(ИмяПодсистемы) Экспорт
	
	Возврат СтрШаблон("Интеграция%1", ИмяПодсистемы);
	
КонецФункции

Функция МодульКлиентСервер(ИмяПодсистемы) Экспорт
	
	Возврат СтрШаблон("Интеграция%1КлиентСервер", ИмяПодсистемы);
	
КонецФункции

#КонецОбласти

#Область Ошибки

// Добавляет в свойство структуры сообщения текст ошибки
//
// Параметры:
//  Сообщение    - Структура - сообщение, в которое добавляется текст ошибки.
//  ТекстОшибки  - Строка - добавляемый текст ошибки.
//
Процедура ДобавитьТекстОшибки(Сообщение, ТекстОшибки) Экспорт
	
	Если Сообщение.Ошибки.Получить(ТекстОшибки) <> Неопределено Тогда
		Возврат;
	Иначе
		Сообщение.Ошибки.Вставить(ТекстОшибки, Истина);
	КонецЕсли;
	
	Если ПустаяСтрока(Сообщение.ТекстОшибки) Тогда
		Сообщение.ТекстОшибки = ТекстОшибки;
	Иначе
		Сообщение.ТекстОшибки = Сообщение.ТекстОшибки + Символы.ПС + ТекстОшибки;
	КонецЕсли;
	
	Если Сообщение.Свойство("ТребуетсяПодписание") Тогда
		Сообщение.ТребуетсяПодписание = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает текст для представления внутренней ошибки библиотек ГосИС.
//
// Параметры:
//  ПредставлениеПодсистемы  - Строка - представление интегрированной подсистемы
//  УточнениеОшибки - Строка - описание возникшей ошибки
//
// Возвращаемое значение:
//	Строка - дополненное описание ошибки
//
Функция ТекстОшибки(Знач ПредставлениеПодсистемы = "", Знач УточнениеОшибки) Экспорт
	
	ПредставлениеПодсистемы = ПредставлениеПодсистемы(ПредставлениеПодсистемы);
	
	ТекстОшибки = 
		СтрШаблон(НСтр("ru='Внутренняя ошибки библиотеки %1.'"),ПредставлениеПодсистемы)
		+ Символы.ПС
		+ УточнениеОшибки;
	
	Возврат ТекстОшибки;
	
КонецФункции

Функция НовыйПараметрыОшибки() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ВыбрасыватьИсключение",             Ложь);
	ВозвращаемоеЗначение.Вставить("ЗаписыватьВЖурналРегистрации",      Ложь);
	ВозвращаемоеЗначение.Вставить("ПрерватьОбработкуОчередиСообщений", Ложь);
	ВозвращаемоеЗначение.Вставить("СообщатьОбОшибке",                  Ложь);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#Область ТекстыСтандартныхСообщений

Функция ТекстКомандаНеМожетБытьВыполнена() Экспорт
	Возврат НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'");
КонецФункции

#КонецОбласти

#Область Перекодировка

// Возвращает индекси вида продукции по переданному параметру и наоборот, а именно:
//  - Алкогольная - 0.
//  - Табак - 1.
//  - Обувь - 2.
// 
// Параметры:
// 	ВидПродукцииИлиИндекс - Число, ПеречислениеСсылка.ВидыПродукцииИС - Параметр расчета индекса или значения по индексу.
// Возвращаемое значение:
// 	Число, ПеречислениеСсылка.ВидыПродукцииИС - Индекс или значение по индексу.
//
Функция ИндексВидаПродукцииИС(ВидПродукцииИлиИндекс) Экспорт
	
	Если ВидПродукцииИлиИндекс = 0 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная");
	ИначеЕсли ВидПродукцииИлиИндекс = 1 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак");
	ИначеЕсли ВидПродукцииИлиИндекс = 2 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Обувь");
	ИначеЕсли ВидПродукцииИлиИндекс = 3 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ЛегкаяПромышленность");
	ИначеЕсли ВидПродукцииИлиИндекс = 4 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС");
	ИначеЕсли ВидПродукцииИлиИндекс = 5 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Шины");
	ИначеЕсли ВидПродукцииИлиИндекс = 6 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Фотоаппараты");
	ИначеЕсли ВидПродукцииИлиИндекс = 7 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Духи");
	ИначеЕсли ВидПродукцииИлиИндекс = 8 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Велосипеды");
	ИначеЕсли ВидПродукцииИлиИндекс = 9 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.КреслаКоляски");
	ИначеЕсли ВидПродукцииИлиИндекс = 10 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак");
	ИначеЕсли ВидПродукцииИлиИндекс = 11 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.УпакованнаяВода");
	ИначеЕсли ВидПродукцииИлиИндекс = 12 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияБезВЕТИС");
	ИначеЕсли ВидПродукцииИлиИндекс = 13 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Антисептики");
	ИначеЕсли ВидПродукцииИлиИндекс = 14 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.БАДы");
	ИначеЕсли ВидПродукцииИлиИндекс = 15 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.НикотиносодержащаяПродукция");
	ИначеЕсли ВидПродукцииИлиИндекс = 16 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Пиво");
	ИначеЕсли ВидПродукцииИлиИндекс = 17 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПродукцияИзНатуральногоМеха");
	ИначеЕсли ВидПродукцииИлиИндекс = 18 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.СоковаяПродукция");
	ИначеЕсли ВидПродукцииИлиИндекс = 19 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.БезалкогольноеПиво");
	ИначеЕсли ВидПродукцииИлиИндекс = 20 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МорепродуктыПодконтрольныеВЕТИС");
	ИначеЕсли ВидПродукцииИлиИндекс = 99 Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПустаяСсылка");
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная") Тогда
		Возврат 0;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак") Тогда
		Возврат 1;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Обувь") Тогда
		Возврат 2;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ЛегкаяПромышленность") Тогда
		Возврат 3;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС") Тогда
		Возврат 4;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Шины") Тогда
		Возврат 5;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Фотоаппараты") Тогда
		Возврат 6;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Духи") Тогда
		Возврат 7;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Велосипеды") Тогда
		Возврат 8;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.КреслаКоляски") Тогда
		Возврат 9;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак") Тогда
		Возврат 10;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.УпакованнаяВода") Тогда
		Возврат 11;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияБезВЕТИС") Тогда
		Возврат 12;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Антисептики") Тогда
		Возврат 13;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.БАДы") Тогда
		Возврат 14;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.НикотиносодержащаяПродукция") Тогда
		Возврат 15;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Пиво") Тогда
		Возврат 16;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПродукцияИзНатуральногоМеха") Тогда
		Возврат 17;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.СоковаяПродукция") Тогда
		Возврат 18;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.БезалкогольноеПиво") Тогда
		Возврат 19;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МорепродуктыПодконтрольныеВЕТИС") Тогда
		Возврат 20;
	ИначеЕсли ВидПродукцииИлиИндекс = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПустаяСсылка") Тогда
		Возврат 99;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ПроверкаВидовПродукции

// Возвращает признак принадлежности переданного в параметре вида продукции к виду продукции ИС МП.
//
// Параметры:
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции для анализа
//  ВключатьТабачнуюПродукцию - Булево - Признак включения табачной продукции
//  ВключатьМолочнуюПродукцию - Булево - Признак вкючения молочной продукции
// Возвращаемое значение:
//  Булево - Принадлежность к виду продукции ИСМП.
//
Функция ЭтоПродукцияИСМП(ВидПродукции, ВключатьТабачнуюПродукцию = Ложь, ВключатьМолочнуюПродукцию = Истина) Экспорт
	
	ВидыПродукцииИСМП = ВидыПродукцииИСМП(ВключатьТабачнуюПродукцию, ВключатьМолочнуюПродукцию);
	
	Возврат ВидыПродукцииИСМП.Найти(ВидПродукции) <> Неопределено;

КонецФункции

// Возвращает признак принадлежности переданного в параметре вида продукции к виду продукции МОТП.
//
// Параметры:
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции для анализа
// Возвращаемое значение:
//  Булево - Принадлежность к виду продукции МОТП.
//
Функция ЭтоПродукцияМОТП(ВидПродукции) Экспорт
	Возврат ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.НикотиносодержащаяПродукция");
КонецФункции

// Возвращает перечень маркируемой продукции, оборот которой фиксируется в ИС МП.
//
// Параметры:
//  ВключатьТабачнуюПродукцию - Булево - Признак включения табачной продукции
//  ВключатьМолочнуюПродукцию - Булево - Признак включения молочной продукции
//  ВключатьПиво              - Булево - Признак включения пивной продукции
//
// Возвращаемое значение:
//   Массив Из ПеречислениеСсылка.ВидыПродукцииИС - список видов маркируемой продукции ИСМП.
//
Функция ВидыПродукцииИСМП(ВключатьТабачнуюПродукцию = Ложь, ВключатьМолочнуюПродукцию = Истина, ВключатьПиво = Истина) Экспорт
	
	ВидыПродукцииИСМП = Новый Массив();
	ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Обувь"));
	ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ЛегкаяПромышленность"));
	ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Фотоаппараты"));
	ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Велосипеды"));
	ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.КреслаКоляски"));
	ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Шины"));
	ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Духи"));
	ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.УпакованнаяВода"));
	ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Антисептики"));
	ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.БАДы"));
	ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПродукцияИзНатуральногоМеха"));
	ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.СоковаяПродукция"));
	ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.БезалкогольноеПиво"));
	ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МорепродуктыПодконтрольныеВЕТИС"));

	Если ВключатьТабачнуюПродукцию Тогда
		ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак"));
		ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак"));
		ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.НикотиносодержащаяПродукция"));
	КонецЕсли;
	
	Если ВключатьМолочнуюПродукцию Тогда
		ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС"));
		ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияБезВЕТИС"));
	КонецЕсли;
	
	Если ВключатьПиво Тогда
		ВидыПродукцииИСМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Пиво"));
	КонецЕсли;
	
	Возврат ВидыПродукцииИСМП;
	
КонецФункции

// Признак использования наборов для вида продукции.
// 
// Параметры:
// 	ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции
// Возвращаемое значение:
// 	Булево - Признак использования наборов для вида продукции.
Функция ВидПродукцииИспользуетНаборы(ВидПродукции) Экспорт
	
	Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Антисептики")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.БАДы")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Духи")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияБезВЕТИС")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ЛегкаяПромышленность")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Фотоаппараты")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.НикотиносодержащаяПродукция")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.КреслаКоляски")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.СоковаяПродукция") Тогда
		Возврат Истина;
	КонецЕсли;

	Возврат Ложь;

КонецФункции

Функция ВидыПродукцииОбъемноСортовогоУчета() Экспорт
	
	ВидыПродукции = Новый Массив();
	
	ВидыПродукции.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.УпакованнаяВода"));
	ВидыПродукции.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияБезВЕТИС"));
	ВидыПродукции.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС"));
	ВидыПродукции.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Антисептики"));
	ВидыПродукции.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.БАДы"));
	ВидыПродукции.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.СоковаяПродукция"));
	
	Возврат ВидыПродукции;
	
КонецФункции

// Признак использования групповых упаковок для вида продукции.
// 
// Параметры:
// 	ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции
// Возвращаемое значение:
// 	Булево - Признак использования групповых упаковок для вида продукции.
Функция ВидПродукцииИспользуетГрупповыеУпаковки(ВидПродукции) Экспорт
	
	Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Антисептики")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.БАДы")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияБезВЕТИС")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Пиво")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.УпакованнаяВода")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.НикотиносодержащаяПродукция")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.КреслаКоляски")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.СоковаяПродукция")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МорепродуктыПодконтрольныеВЕТИС") Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ВидыПродукцииЕГАИС() Экспорт
	
	ВидыПродукцииЕГАИС = Новый Массив;
	ВидыПродукцииЕГАИС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная"));
	ВидыПродукцииЕГАИС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Пиво"));
	
	Возврат ВидыПродукцииЕГАИС;
	
КонецФункции

// Возвращает признак принадлежности переданного в параметре вида продукции к молочной продукции ИСМП.
//
// Параметры:
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции для анализа
// Возвращаемое значение:
//  Булево - Принадлежность к виду молочной продукции ИСМП.
//
Функция ЭтоМолочнаяПродукцияИСМП(ВидПродукции) Экспорт
	Возврат ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияБезВЕТИС")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС");
КонецФункции

// Возвращает признак принадлежности переданного в параметре вида продукции к видам продукции, подконтрольным учету в ВетИС.
//
// Параметры:
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции для анализа
// Возвращаемое значение:
//  Булево - Истина, если по виду продукции ведется учет в ВетИС.
//
Функция ЭтоПродукцияПодконтрольнаяВЕТИС(ВидПродукции) Экспорт
	Возврат ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МорепродуктыПодконтрольныеВЕТИС");
КонецФункции

//Определяет является ли тип упаковки логистической или групповой товарной упаковкой.
//
//Параметры:
//  ВидУпаковки                 - ПеречислениеСсылка.ТипыУпаковок - тип упаковки
//  НеЗаполненКакУпаковка       - Булево - Истина если пустой вид рассматривать как "возможно упаковка"
//  ВключатьОбъемноСортовойУчет - Булево - Обработка объемно-сортовых кодов
//Возвращаемое значение:
//   Булево - Истина, если вид упаковки относится к логистической или групповой.
Функция ЭтоУпаковкаПоВиду(ВидУпаковки, НеЗаполненКакУпаковка = Ложь, ВключатьОбъемноСортовойУчет = Истина) Экспорт
	
	Возврат ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Логистическая")
		Или ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Групповая")
		Или ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Набор")
		Или (ВключатьОбъемноСортовойУчет 
			И ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.ОбъемноСортовойУчет"))
		Или (НеЗаполненКакУпаковка И ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.ПустаяСсылка"));
	
КонецФункции

#КонецОбласти

// Конвертирует двоичные данные в Base64
// 
// Параметры:
// 	ДвоичныеДанные - ДвоичныеДанные - Двоичные данные
// Возвращаемое значение:
// 	Строка - Строка в Base64
Функция ДвоичныеДанныеBase64(ДвоичныеДанные) Экспорт
	
	Base64 = Base64Строка(ДвоичныеДанные);
	Base64 = СтрЗаменить(Base64, Символы.ПС, "");
	Base64 = СтрЗаменить(Base64, Символы.ВК, "");
	
	Возврат Base64;
	
КонецФункции

// Формирует представление параметра в формате CamelCase в строковое представление с пробелами.
// 
// Параметры:
//  ИмяПараметра - Произвольный - Имя параметра.
// 
// Возвращаемое значение:
//  Строка - Представление параметра с пробелами.
Функция ПредставлениеВстроенногоИмени(ИмяПараметра) Экспорт
	
	ДлинаСтроки = СтрДлина(ИмяПараметра);
	
	Если ДлинаСтроки = 0 Тогда
		Возврат ИмяПараметра;
	КонецЕсли;
	
	ИтоговыеДанные      = Новый Массив();
	ПредыдущийЗаглавный = Ложь;
	
	Для НомерСимвола = 1 По ДлинаСтроки Цикл
		
		ТекущийСимвол      = Сред(ИмяПараметра, НомерСимвола, 1);
		ТекущийЗаглавный   = (ТекущийСимвол = ВРег(ТекущийСимвол));
		СледующийЗаглавный = Ложь;
		Если НомерСимвола < ДлинаСтроки Тогда
			СледующийСимвол    = Сред(ИмяПараметра, НомерСимвола + 1, 1);
			СледующийЗаглавный = (СледующийСимвол = ВРег(СледующийСимвол));
		КонецЕсли;
		
		Если НомерСимвола = 1 Тогда
			ИтоговыеДанные.Добавить(Врег(ТекущийСимвол));
		Иначе
			Если ПредыдущийЗаглавный Тогда
				ИтоговыеДанные.Добавить(ТекущийСимвол);
			Иначе
				Если ТекущийЗаглавный Тогда
					ИтоговыеДанные.Добавить(" ");
					Если СледующийЗаглавный Тогда
						ИтоговыеДанные.Добавить(ТекущийСимвол);
					Иначе
						ИтоговыеДанные.Добавить(НРег(ТекущийСимвол));
					КонецЕсли;
				Иначе
					ИтоговыеДанные.Добавить(ТекущийСимвол);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ПредыдущийЗаглавный = (ТекущийСимвол = ВРег(ТекущийСимвол));
		
	КонецЦикла;
	
	Возврат СтрСоединить(ИтоговыеДанные);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область РаботаСДатами

Функция ДатаИзСтрокиUNIX(Знач Значение, Делитель = 1000, ПриводитьКМестномуВремени = Истина) Экспорт
	
	Значение = '19700101' + Цел(Значение / Делитель);
	
	Если ПриводитьКМестномуВремени Тогда
		Возврат МестноеВремя(Значение);
	Иначе
		Возврат Значение;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти