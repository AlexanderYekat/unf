﻿#Область ПрограммныйИнтерфейс

// Определяет необходимость показа рабочего места кассира
// РМК показывается в случае наличия профиля РабочееМестоКассира у пользователя
Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	
#Если ВнешнееСоединение Тогда
	Параметры.Вставить(
		"ЕстьПрофильРМК", Ложь);
#Иначе
		Параметры.Вставить(
			"ЕстьПрофильРМК", УправлениеДоступомУНФ.ЕстьПрофильРабочееМестоКассира());
#КонецЕсли
	
КонецПроцедуры

#Область ПредпросмотрЧека

Процедура ЗаполнитьТекстовоеПредставлениеЧека(СтрокаСостава, ЧекККМ, ИдентификаторУстройства = Неопределено) Экспорт
	
	ОбщиеПараметры = ПодготовитьДанныеДляПробитияЧека(ЧекККМ, ИдентификаторУстройства);
	
	СобратьПараметрыВТекст(ОбщиеПараметры, СтрокаСостава);
	
КонецПроцедуры

Процедура ЗаполнитьОплатуПриПробитииЧекаККМНаККТ(ДокументОбъект, ОбщиеПараметры) Экспорт
	
	// Подготовка таблицы оплат
	Предоплата = ДокументОбъект.Предоплата.Выгрузить();
	Предоплата.Колонки.Добавить("ВидОплаты", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(50)));
	
	Для Каждого СтрокаПредоплаты Из Предоплата Цикл
		Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ЧекККМ")
			И ТипЗнч(СтрокаПредоплаты.Документ) = Тип("ДокументСсылка.ПоступлениеНаСчет")
			И СтрокаПредоплаты.Документ.НомерЧекаККМ = 0 Тогда
				СтрокаПредоплаты.ВидОплаты = "Банковский платеж";
		Иначе
			СтрокаПредоплаты.ВидОплаты = "Зачет аванса";
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Оплата.ВидОплаты КАК ВидОплаты,
	|	Оплата.Сумма КАК Сумма
	|ПОМЕСТИТЬ Оплата
	|ИЗ
	|	&Оплата КАК Оплата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Предоплата.ВидОплаты КАК ВидОплаты,
	|	Предоплата.СуммаРасчетов КАК Сумма
	|ПОМЕСТИТЬ Предоплата
	|ИЗ
	|	&Предоплата КАК Предоплата
	|ГДЕ
	|	НЕ &ОплатаДолга
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Оплата.ВидОплаты КАК ВидОплаты,
	|	Оплата.Сумма КАК Сумма
	|ПОМЕСТИТЬ Оплаты
	|ИЗ
	|	Оплата КАК Оплата
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Предоплата.ВидОплаты,
	|	Предоплата.Сумма
	|ИЗ
	|	Предоплата КАК Предоплата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Оплаты.ВидОплаты КАК ВидОплаты,
	|	СУММА(Оплаты.Сумма) КАК Сумма
	|ИЗ
	|	Оплаты КАК Оплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	Оплаты.ВидОплаты
	|
	|ИМЕЮЩИЕ
	|	СУММА(Оплаты.Сумма) > 0";
	
	Запрос.УстановитьПараметр("Оплата", ДокументОбъект.БезналичнаяОплата.Выгрузить());
	Запрос.УстановитьПараметр("Предоплата", Предоплата);
	Запрос.УстановитьПараметр("ОплатаДолга", Предоплата.Количество() И ДокументОбъект.ОперацияСДенежнымиСредствами);
	
	Результат = Запрос.Выполнить();
	ТаблицаПоВидамОплат = Результат.Выгрузить();
	
	СуммаЭлектронно = 0;
	
	// Платежная карта
	СтрокаТаблицы = ТаблицаПоВидамОплат.Найти(Перечисления.ВидыБезналичныхОплат.БанковскаяКарта, "ВидОплаты");
	Если Не СтрокаТаблицы = Неопределено Тогда
		СуммаЭлектронно = СтрокаТаблицы.Сумма;
	КонецЕсли;
	
	// ЭС НСПК
	СтрокаТаблицы = ТаблицаПоВидамОплат.Найти(Перечисления.ВидыБезналичныхОплат.СертификатНСПК, "ВидОплаты");
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОплатуСертификатамиНСПК") И Не СтрокаТаблицы = Неопределено Тогда
		Если СуммаЭлектронно > 0 Тогда
			ДетализацияОплаты = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыДетализацииСтрокиОплаты();
			ДетализацияОплаты.НаименованиеТипаОплаты = НСтр("ru = 'КАРТА МИР'");
			ДетализацияОплаты.Сумма = СуммаЭлектронно;
			ОбщиеПараметры.ДетализацияОплаты.Добавить(ДетализацияОплаты);
		КонецЕсли;
		
		ДетализацияОплаты = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыДетализацииСтрокиОплаты();
		ДетализацияОплаты.НаименованиеТипаОплаты = НСтр("ru = 'СЕРТИФИКАТОМ'");
		ДетализацияОплаты.Сумма = СтрокаТаблицы.Сумма;
		ОбщиеПараметры.ДетализацияОплаты.Добавить(ДетализацияОплаты);
		
		СтрокаТаблицыЧека   = ДокументОбъект.БезналичнаяОплата.НайтиСтроки(Новый Структура("ВидОплаты", Перечисления.ВидыБезналичныхОплат.СертификатНСПК));
		СтрокаТаблицыЧека   = ?(СтрокаТаблицыЧека.Количество(), СтрокаТаблицыЧека[0], Неопределено);
		
		Если НЕ СтрокаТаблицыЧека = Неопределено 
			И (ТипЗнч(ДокументОбъект.Ссылка) = Тип("ДокументСсылка.ЧекККМ")
				ИЛИ ТипЗнч(ДокументОбъект.Ссылка) = Тип("ДокументСсылка.ЧекККМВозврат")) Тогда
			
			ОбщиеПараметры.ИдентификаторОплатыПлатежнойСистемы 	= СтрокаТаблицыЧека.СсылочныйНомер;
			ОбщиеПараметры.ТипПлатежнойСистемы 					= Перечисления.ТипыПлатежнойСистемыККТ.СертификатНСПК;
			
			ОбщиеПараметры.QRКод.ЗначениеКода 					= СтрокаТаблицыЧека.СсылочныйНомер;
			
		КонецЕсли;
		
		СуммаЭлектронно = СуммаЭлектронно + СтрокаТаблицы.Сумма;
	КонецЕсли;
	
	// Платежная система
	СтрокаТаблицы = ТаблицаПоВидамОплат.Найти(Перечисления.ВидыБезналичныхОплат.СБП, "ВидОплаты");
	Если Не СтрокаТаблицы = Неопределено Тогда
		
		СуммаЭлектронно 	= СуммаЭлектронно + СтрокаТаблицы.Сумма;      
		СтрокаТаблицыЧека   = ДокументОбъект.БезналичнаяОплата.НайтиСтроки(Новый Структура("ВидОплаты", Перечисления.ВидыБезналичныхОплат.СБП));
		СтрокаТаблицыЧека   = ?(СтрокаТаблицыЧека.Количество(), СтрокаТаблицыЧека[0], Неопределено);
		
		Если НЕ СтрокаТаблицыЧека = Неопределено 
			И ТипЗнч(ДокументОбъект.Ссылка) = Тип("ДокументСсылка.ЧекККМ") Тогда
			
			ОбщиеПараметры.ИдентификаторОплатыПлатежнойСистемы 	= СтрокаТаблицыЧека.СсылочныйНомер;
			ОбщиеПараметры.ТипПлатежнойСистемы 					= Перечисления.ТипыПлатежнойСистемыККТ.СистемаБыстрыхПлатежей;
			
			ОбщиеПараметры.QRКод.ЗначениеКода 					= СтрокаТаблицыЧека.СсылочныйНомер;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Кредит
	СтрокаТаблицы = ТаблицаПоВидамОплат.Найти(Перечисления.ВидыБезналичныхОплат.Кредит, "ВидОплаты");
	Если Не СтрокаТаблицы = Неопределено Тогда
		СуммаЭлектронно = СуммаЭлектронно + СтрокаТаблицы.Сумма;
	КонецЕсли;
	
	// Банковский платеж
	СтрокаТаблицы = ТаблицаПоВидамОплат.Найти("Банковский платеж", "ВидОплаты");
	Если Не СтрокаТаблицы = Неопределено Тогда
		СуммаЭлектронно = СуммаЭлектронно + СтрокаТаблицы.Сумма;
	КонецЕсли;
	
	Если СуммаЭлектронно <> 0 Тогда
		СтрокаОплаты = Новый Структура;
		СтрокаОплаты.Вставить("ТипОплаты", Перечисления.ТипыОплатыККТ.Электронно);
		СтрокаОплаты.Вставить("Наименование", НСтр("ru = 'Электронно'"));
		СтрокаОплаты.Вставить("Сумма", СуммаЭлектронно);
		ОбщиеПараметры.ТаблицаОплат.Добавить(СтрокаОплаты);
	КонецЕсли;
	
	ЗачетАванса = 0;
	
	// Подарочный сертификат
	СтрокаТаблицы = ТаблицаПоВидамОплат.Найти(Перечисления.ВидыБезналичныхОплат.ПодарочныйСертификат, "ВидОплаты");
	Если Не СтрокаТаблицы = Неопределено Тогда
		ЗачетАванса = СтрокаТаблицы.Сумма;
	КонецЕсли;
	
	// Зачет аванса
	СтрокаТаблицы = ТаблицаПоВидамОплат.Найти("Зачет аванса", "ВидОплаты");
	Если Не СтрокаТаблицы = Неопределено Тогда
		ЗачетАванса = ЗачетАванса + СтрокаТаблицы.Сумма;
	КонецЕсли;
	
	Если ЗачетАванса > 0 Тогда
		СтрокаОплаты = Новый Структура;
		СтрокаОплаты.Вставить("ТипОплаты", Перечисления.ТипыОплатыККТ.Предоплата);
		СтрокаОплаты.Вставить("Наименование", НСтр("ru = 'Зачет аванс'"));
		СтрокаОплаты.Вставить("Сумма", ЗачетАванса);
		ОбщиеПараметры.ТаблицаОплат.Добавить(СтрокаОплаты);
	КонецЕсли;
	
	// Наличные
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДокументОбъект, "ПолученоНаличными")
		И ДокументОбъект.ПолученоНаличными > 0 Тогда
		СтрокаОплаты = Новый Структура;
		СтрокаОплаты.Вставить("ТипОплаты", Перечисления.ТипыОплатыККТ.Наличные);
		СтрокаОплаты.Вставить("Наименование", НСтр("ru = 'Наличные'"));
		СтрокаОплаты.Вставить("Сумма", ДокументОбъект.ПолученоНаличными);
		ОбщиеПараметры.ТаблицаОплат.Добавить(СтрокаОплаты);
	ИначеЕсли ДокументОбъект.СуммаДокумента
			- ДокументОбъект.БезналичнаяОплата.Итог("Сумма")
			- ДокументОбъект.Предоплата.Итог("СуммаРасчетов") > 0 Тогда 
		СтрокаОплаты = Новый Структура;
		СтрокаОплаты.Вставить("ТипОплаты", Перечисления.ТипыОплатыККТ.Наличные);
		СтрокаОплаты.Вставить("Наименование", НСтр("ru = 'Наличные'"));
		СтрокаОплаты.Вставить("Сумма", ДокументОбъект.СуммаДокумента
									 - ДокументОбъект.БезналичнаяОплата.Итог("Сумма")
									 - ДокументОбъект.Предоплата.Итог("СуммаРасчетов"));
		ОбщиеПараметры.ТаблицаОплат.Добавить(СтрокаОплаты);
	КонецЕсли;
	
	Если ОбщиеПараметры.ТаблицаОплат.Количество() = 0 Тогда
		
		СтрокаОплаты = Новый Структура;
		СтрокаОплаты.Вставить("Сумма", 0);
		
		// Полная оплата бонусами, либо скидка 100%
		Если ДокументОбъект.СуммаДокумента = 0 Тогда
			СтрокаОплаты.Вставить("ТипОплаты", Перечисления.ТипыОплатыККТ.ВстречноеПредоставление);
			СтрокаОплаты.Вставить("Наименование", НСтр("ru = 'Встречное предоставление'"));
		Иначе
			СтрокаОплаты.Вставить("ТипОплаты", Перечисления.ТипыОплатыККТ.Наличные);
			СтрокаОплаты.Вставить("Наименование", НСтр("ru = 'Наличные'"));
		КонецЕсли;
		
		ОбщиеПараметры.ТаблицаОплат.Добавить(СтрокаОплаты);
		
	КонецЕсли;
	
	//	Встречное предоставление
	СтрокаОплатыВстречнымПредоставлением = ТаблицаПоВидамОплат.Найти(
		Перечисления.ВидыБезналичныхОплат.ВстречноеПредоставление, "ВидОплаты");
		
	СуммаВстречногоПредоставления = 0;
	Если НЕ СтрокаОплатыВстречнымПредоставлением = Неопределено Тогда
		СуммаВстречногоПредоставления = СтрокаОплатыВстречнымПредоставлением.Сумма;
	КонецЕсли;
	
	Если НЕ СтрокаОплатыВстречнымПредоставлением = Неопределено Тогда
		
		СтрокаОплаты = Новый Структура;
		СтрокаОплаты.Вставить("ТипОплаты", ОбщегоНазначения.ПредопределенныйЭлемент("Перечисление.ТипыОплатыККТ.ВстречноеПредоставление"));
		СтрокаОплаты.Вставить("Наименование", НСтр("ru = 'Встречное предоставление'"));
		СтрокаОплаты.Вставить("Сумма", СуммаВстречногоПредоставления);
		ОбщиеПараметры.ТаблицаОплат.Добавить(СтрокаОплаты);
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьОплатуПриПробитииЧекаККМНаККТ()

Функция ПолучитьПараметрыРегистрацииККТ(ККТ) Экспорт
	
	Параметры = Новый Структура;
	
	ИскомаяСтрока = ККТ.ПараметрыРегистрации.Найти("ОрганизацияНазвание", "НаименованиеПараметра");
	Если ИскомаяСтрока <> Неопределено Тогда
		Параметры.Вставить("ОрганизацияНазвание", ИскомаяСтрока.ЗначениеПараметра);
	КонецЕсли;
	
	ИскомаяСтрока = ККТ.ПараметрыРегистрации.Найти("АдресПроведенияРасчетов", "НаименованиеПараметра");
	Если ИскомаяСтрока <> Неопределено Тогда
		Параметры.Вставить("АдресРасчетов", ИскомаяСтрока.ЗначениеПараметра);
	КонецЕсли;
	
	ИскомаяСтрока = ККТ.ПараметрыРегистрации.Найти("ОрганизацияИНН", "НаименованиеПараметра");
	Если ИскомаяСтрока <> Неопределено Тогда
		Параметры.Вставить("ОрганизацияИНН", ИскомаяСтрока.ЗначениеПараметра);
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

// Формирует структуру параметров чека
// Параметры:
//  ЧекККМ - ДокументСсылка.ЧекККМ, ДокументСсылка.ЧекККМВозврат
//  ИдентфикаторУстройства - СправочникСсылка.ПодулючаемоеОборудование
// 
// Возвращаемое значние:
//  Структура - параметры чека, необходимые для фискализации
// 
Функция ПодготовитьДанныеДляПробитияЧека(ЧекККМ, ИдентификаторУстройства = Неопределено) Экспорт
	
	ЕстьАлкогольнаяПродукцияЕГАИС = Неопределено;
	ТранспортныйМодуль = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаТоваровЧека = ПодготовкаДанныхДляПробитияЧекаККМ(ЧекККМ, ЕстьАлкогольнаяПродукцияЕГАИС);
	
	ОбщиеПараметры = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека();
	
	РеквизитыОрганизация = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЧекККМ.Организация, "НаименованиеПолное,ИНН,КПП");
	
	СтруктураРеквизитов = Новый Структура("ЭлектронныйЧекSMSПередаютсяПрограммой1С,ЭлектронныйЧекEmailПередаютсяПрограммой1С,СерийныйНомер,Код,ПодключаемоеОборудование,СтруктурнаяЕдиница");
	СтруктураРеквизитов.Вставить("СпособФорматноЛогическогоКонтроля", "ПодключаемоеОборудование.СпособФорматноЛогическогоКонтроля");
	СтруктураРеквизитов.Вставить("ДопустимоеРасхождениеФорматноЛогическогоКонтроля", "ПодключаемоеОборудование.ДопустимоеРасхождениеФорматноЛогическогоКонтроля");
	СтруктураРеквизитов.Вставить("ТипОборудования", "ПодключаемоеОборудование.ТипОборудования");
	СтруктураРеквизитов.Вставить("ИсточникФИОКассираВЧеке");
	РеквизитыКассыККМ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЧекККМ.КассаККМ, СтруктураРеквизитов);
	
	ПользовательКассирДляПечати = Справочники.КассыККМ.ПолучитьПользователяКассираДляПечатиЧека(ЧекККМ, РеквизитыКассыККМ.ИсточникФИОКассираВЧеке);
	РеквизитыКассира = РозничныеПродажиСервер.ПолучитьРеквизитыКассира(ПользовательКассирДляПечати);
	
	ОбщиеПараметры.ТипРасчета = ?(ТипЗнч(ЧекККМ) = Тип("ДокументСсылка.ЧекККМВозврат"),
		Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратДенежныхСредств,
		Перечисления.ТипыРасчетаДенежнымиСредствами.ПриходДенежныхСредств);
	
	ОбщиеПараметры.Электронно = Ложь;
	
	Если ЗначениеЗаполнено(ЧекККМ.Телефон) Тогда
		Если РеквизитыКассыККМ.ЭлектронныйЧекSMSПередаютсяПрограммой1С Тогда
			ОбщиеПараметры.Отправляет1СSMS = Истина;
		КонецЕсли;
		ОбщиеПараметры.ПокупательНомер = "+7" + РозничныеПродажиСервер.УбратьРазделителиВНомереТелефона(ЧекККМ.Телефон);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЧекККМ.АдресЭП) Тогда
		Если РеквизитыКассыККМ.ЭлектронныйЧекEmailПередаютсяПрограммой1С Тогда
			ОбщиеПараметры.Отправляет1СEmail = Истина;
		КонецЕсли;
		ОбщиеПараметры.ПокупательEmail = ЧекККМ.АдресЭП;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЧекККМ.Контрагент) Тогда
		СведенияОКонтрагенте = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЧекККМ.Контрагент, "НаименованиеПолное,ИНН,ВидКонтрагента");
		Если СведенияОКонтрагенте.ВидКонтрагента = Перечисления.ВидыКонтрагентов.ЮридическоеЛицо 
			ИЛИ ЗначениеЗаполнено(СведенияОКонтрагенте.ИНН) Тогда
			ОбщиеПараметры.Получатель    = СведенияОКонтрагенте.НаименованиеПолное;
			ОбщиеПараметры.ПолучательИНН = СведенияОКонтрагенте.ИНН;
		КонецЕсли;
	КонецЕсли;
	
	ОбщиеПараметры.ДокументОснование = ЧекККМ;
	ОбщиеПараметры.ТорговыйОбъект = РеквизитыКассыККМ.СтруктурнаяЕдиница;
	
	// Параметры необходимые для чека ЕНВД на принтере чеков
	ОбщиеПараметры.Кассир          = РеквизитыКассира.ИмяКассираИДолжность;
	ОбщиеПараметры.Вставить("ИмяКассира", РеквизитыКассира.ИмяКассира);
	ОбщиеПараметры.КассирИНН       = РеквизитыКассира.КассирИНН;
	
	ОбщиеПараметры.ОрганизацияНазвание = РеквизитыОрганизация.НаименованиеПолное;
	ОбщиеПараметры.ОрганизацияИНН = РеквизитыОрганизация.ИНН;
	ОбщиеПараметры.ОрганизацияКПП = РеквизитыОрганизация.КПП;
	ОбщиеПараметры.НомерКассы     = "00001";
	ОбщиеПараметры.НомерЧека      = ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(ЧекККМ.Дата,
		ЧекККМ.Номер,
		ЧекККМ.Организация.Префикс);
	ОбщиеПараметры.НомерСмены     = "1";
	
	СведенияОбОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(ЧекККМ.Организация, ЧекККМ.Дата);
	АдресМагазина = ПечатьДокументовУНФ.КонтактнаяИнформация(ЧекККМ.СтруктурнаяЕдиница, ПредопределенноеЗначение(
		"Справочник.ВидыКонтактнойИнформации.ФактАдресСтруктурнойЕдиницы"));
	
	СерийныйНомер = "1";
	
	ОбщиеПараметры.АдресМагазина = АдресМагазина;
	ОбщиеПараметры.НаименованиеМагазина = Строка(ЧекККМ.СтруктурнаяЕдиница);
	ОбщиеПараметры.СерийныйНомер = СерийныйНомер;
	ДатаЧека = ЧекККМ.Дата;
	ОбщиеПараметры.СистемаНалогообложения = РозничныеПродажиСервер.ПолучитьТипСистемыНалогообложенияККТ(
		ЧекККМ.Организация,
		ЧекККМ.СтруктурнаяЕдиница,
		ДатаЧека,
		ЧекККМ.СпециальныйНалоговыйРежим);
	
	// Подготовка таблицы товаров
	ДополнитьТоварамиПараметрыПриПробитииЧека(ЧекККМ, ОбщиеПараметры, ТаблицаТоваровЧека, Документы.ЧекККМ.ПризнакСпособаРасчета(ЧекККМ));
	
	Если РеквизитыКассыККМ.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
		ОбщиеПараметры.СпособФорматноЛогическогоКонтроля = РеквизитыКассыККМ.СпособФорматноЛогическогоКонтроля;
		ОбщиеПараметры.ДопустимоеРасхождениеФорматноЛогическогоКонтроля = РеквизитыКассыККМ.ДопустимоеРасхождениеФорматноЛогическогоКонтроля;
		Если ФорматноЛогическийКонтрольКлиентСервер.НуженФорматноЛогическийКонтроль(ОбщиеПараметры) Тогда
			ФорматноЛогическийКонтрольКлиентСервер.ПровестиФорматноЛогическийКонтроль(ОбщиеПараметры);
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьОплатуПриПробитииЧекаККМНаККТ(ЧекККМ, ОбщиеПараметры);
	
	РазницаСумм = ЧекККМ.Запасы.Итог("Сумма") - ЧекККМ.СуммаДокумента;
	Если РазницаСумм > 0 Тогда
		СтрокаОплаты = Новый Структура();
		СтрокаОплаты.Вставить("ТипОплаты",Перечисления.ТипыОплатыККТ.Постоплата);
		СтрокаОплаты.Вставить("Наименование", НСтр("ru = 'Постоплата'"));
		СтрокаОплаты.Вставить("Сумма", РазницаСумм);
		ОбщиеПараметры.ТаблицаОплат.Добавить(СтрокаОплаты);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПодарочныеСертификаты") Тогда
		РаботаСПодарочнымиСертификатами.ДобавитьВнереализационнуюПрибыль(ЧекККМ, ОбщиеПараметры);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ИдентификаторУстройства = Неопределено Тогда
		ИдентификаторУстройства = ?(
				ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудование") // Проверка на включенную ФО "Использовать ПО"
			  И ЗначениеЗаполнено(ЧекККМ.КассаККМ)
			  И ЗначениеЗаполнено(ЧекККМ.КассаККМ.ПодключаемоеОборудование),
			  ЧекККМ.КассаККМ.ПодключаемоеОборудование.Ссылка,
			  Справочники.ПодключаемоеОборудование.ПустаяСсылка());
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		
		ПараметрыРегистрации = ПолучитьПараметрыРегистрацииККТ(ИдентификаторУстройства);
		
		Если ПараметрыРегистрации.Свойство("ОрганизацияНазвание") Тогда
			ОбщиеПараметры.Вставить("ОрганизацияНазвание", ПараметрыРегистрации.ОрганизацияНазвание);
		КонецЕсли;
		
		Если ПараметрыРегистрации.Свойство("АдресРасчетов") Тогда
			ОбщиеПараметры.Вставить("АдресРасчетов", ПараметрыРегистрации.АдресРасчетов);
		КонецЕсли;
		
		Если ПараметрыРегистрации.Свойство("ОрганизацияИНН") Тогда
			ОбщиеПараметры.Вставить("ОрганизацияИНН", ПараметрыРегистрации.ОрганизацияИНН);
		КонецЕсли;
		
		ОбщиеПараметры = ОборудованиеЧекопечатающиеУстройства.ШаблонЧека(ОбщиеПараметры, Неопределено, Неопределено, ИдентификаторУстройства);
		ОсновныеПараметры = ОбщиеПараметры;
		ОписаниеОшибки = "";
		Если НЕ ОборудованиеЧекопечатающиеУстройстваВызовСервера.ВыполненаПроверкаОбязательностиИПравильностиЗаполненияТэгов(ОсновныеПараметры, ИдентификаторУстройства, ОписаниеОшибки) Тогда
			ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки);
		КонецЕсли;
		Отказ = Ложь;
		ИсправленыОсновныеПараметры = Ложь;
		ОборудованиеЧекопечатающиеУстройстваВызовСервера.ПривестиДанныеКТребуемомуФормату(ОсновныеПараметры, Отказ, ОписаниеОшибки, ИсправленыОсновныеПараметры);
		Если Отказ Тогда
			ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки);
		ИначеЕсли ИсправленыОсновныеПараметры Тогда
			ОбщиеПараметры = ОсновныеПараметры;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ОбщиеПараметры;
	
КонецФункции

#КонецОбласти

#Область ЧекККМ

Функция ПодготовкаДанныхДляПробитияЧекаККМ(ДокументОбъект, ЕстьАлкогольнаяПродукцияЕГАИС) Экспорт
	
	ТаблицаТовары = ДокументОбъект.Запасы.Выгрузить();
	
	ЕстьАлкогольнаяПродукцияЕГАИС = ИнтеграцияЕГАИСУНФ.ЕстьАлкогольнаяПродукцияЕГАИС(ДокументОбъект.Запасы);
	
	Если ТаблицаТовары.Колонки.Найти("ПроцентАвтоматическойСкидки") = Неопределено Тогда
		ТаблицаТовары.Колонки.Добавить("ПроцентАвтоматическойСкидки", Новый ОписаниеТипов("Число"));
		ТаблицаТовары.Колонки.Добавить("СуммаАвтоматическойСкидки", Новый ОписаниеТипов("Число"));
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	ТаблицаДокумента.Характеристика КАК Характеристика,
	|	ТаблицаДокумента.Партия КАК Партия,
	|	ТаблицаДокумента.Количество КАК Количество,
	|	ТаблицаДокумента.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ТаблицаДокумента.Цена КАК Цена,
	|	ТаблицаДокумента.ПроцентСкидкиНаценки КАК ПроцентСкидкиНаценки,
	|	ТаблицаДокумента.Сумма КАК Сумма,
	|	ТаблицаДокумента.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаДокумента.СуммаНДС КАК СуммаНДС,
	|	ТаблицаДокумента.Всего КАК Всего,
	|	ТаблицаДокумента.ПроцентАвтоматическойСкидки КАК ПроцентАвтоматическойСкидки,
	|	ТаблицаДокумента.СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки,
	|	ТаблицаДокумента.КлючСвязи КАК КлючСвязи,
	|	ТаблицаДокумента.НеобходимостьВводаАкцизнойМарки КАК НеобходимостьВводаАкцизнойМарки,
	|	ТаблицаДокумента.Штрихкод КАК Штрихкод,
	|	ТаблицаДокумента.КодМаркировки КАК КодМаркировки,
	|	ТаблицаДокумента.ДоговорПлатежногоАгента КАК ДоговорПлатежногоАгента
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Партия КАК Партия,
	|	ТаблицаТовары.Количество КАК Количество,
	|	ТаблицаТовары.Цена КАК Цена,
	|	ТаблицаТовары.Сумма КАК Сумма,
	|	ТаблицаТовары.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТовары.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТовары.Всего КАК Всего,
	|	ТаблицаТовары.ПроцентАвтоматическойСкидки КАК ПроцентАвтоматическойСкидки,
	|	ТаблицаТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ТаблицаТовары.КлючСвязи КАК КлючСвязи,
	|	ТаблицаТовары.СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки,
	|	СправочникНоменклатура.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	СправочникНоменклатура.КодТРУ КАК КодТРУ,
	|	СправочникНоменклатура.ВидПродукцииИС КАК ВидПродукцииИС,
	|	НЕ СправочникНоменклатура.ВидПродукцииИС = ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПустаяСсылка) КАК ПродукцияИС,
	|	ТаблицаТовары.НеобходимостьВводаАкцизнойМарки КАК НеобходимостьВводаАкцизнойМарки,
	|	ТаблицаТовары.Штрихкод КАК Штрихкод,
	|	ТаблицаТовары.КодМаркировки КАК КодМаркировки,
	|	ТаблицаТовары.ДоговорПлатежногоАгента КАК ДоговорПлатежногоАгента
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ТаблицаТовары.Номенклатура = СправочникНоменклатура.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ШтрихкодыНоменклатуры.Штрихкод) КАК Штрихкод,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Партия КАК Партия,
	|	ТаблицаТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|ПОМЕСТИТЬ ТаблицаШтрихкоды
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО ТаблицаТовары.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
	|			И ТаблицаТовары.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	|			И ТаблицаТовары.Партия = ШтрихкодыНоменклатуры.Партия
	|			И (ТИПЗНАЧЕНИЯ(ТаблицаТовары.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
	|				ИЛИ ТаблицаТовары.ЕдиницаИзмерения = ШтрихкодыНоменклатуры.Номенклатура)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика,
	|	ТаблицаТовары.Партия,
	|	ТаблицаТовары.ЕдиницаИзмерения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Партия КАК Партия,
	|	ТаблицаТовары.Количество КАК Количество,
	|	ТаблицаТовары.Цена КАК Цена,
	|	ТаблицаТовары.Сумма КАК Сумма,
	|	ТаблицаТовары.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТовары.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТовары.Всего КАК Всего,
	|	ТаблицаТовары.ПроцентАвтоматическойСкидки КАК ПроцентАвтоматическойСкидки,
	|	ТаблицаТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ТаблицаТовары.КлючСвязи КАК КлючСвязи,
	|	ТаблицаТовары.СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Штрихкод = """"
	|			ТОГДА ЕСТЬNULL(ТаблицаШтрихкоды.Штрихкод, """")
	|		ИНАЧЕ ТаблицаТовары.Штрихкод
	|	КОНЕЦ КАК Штрихкод,
	|	ТаблицаТовары.КодМаркировки КАК КодМаркировки,
	|	ТаблицаТовары.ДоговорПлатежногоАгента КАК ДоговорПлатежногоАгента,
	|	ТаблицаТовары.КодТРУ КАК КодТРУ,
	|	ТаблицаТовары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаТовары.ВидПродукцииИС КАК ВидПродукцииИС,
	|	ТаблицаТовары.ПродукцияИС КАК ПродукцияИС
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаШтрихкоды КАК ТаблицаШтрихкоды
	|		ПО ТаблицаТовары.Номенклатура = ТаблицаШтрихкоды.Номенклатура
	|			И ТаблицаТовары.Характеристика = ТаблицаШтрихкоды.Характеристика
	|			И ТаблицаТовары.Партия = ТаблицаШтрихкоды.Партия";
	
	Запрос.УстановитьПараметр("ТаблицаТовары", ТаблицаТовары);
	
	Результат = Запрос.Выполнить();
	
	ТаблицаТоваровЧека = Результат.Выгрузить();
	
	Возврат ТаблицаТоваровЧека;
	
КонецФункции

Функция СерийныйНомерККМ(КассаККМ) Экспорт
	
	СерийныйНомер = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА КассыККМ.СерийныйНомер <> """"
	|			ТОГДА КассыККМ.СерийныйНомер
	|		ИНАЧЕ КассыККМ.ПодключаемоеОборудование.СерийныйНомер
	|	КОНЕЦ КАК СерийныйНомер
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	КассыККМ.Ссылка = &КассаККМ";
	Запрос.УстановитьПараметр("КассаККМ", КассаККМ);
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СерийныйНомер;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПредпросмотрЧека

Процедура СобратьПараметрыВТекст(Параметры, СтрокаСостава)
	
	Разделитель = "-------------------------------";
	КУдалению = "===============================";
	ТекстЧека = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.СформироватьТекстНефискальногоЧека(Параметры);
	ТекстЧека = СтрЗаменить(ТекстЧека, КУдалению, "");
	Позиция1 = СтрНайти(ТекстЧека, Разделитель);
	Позиция2 = СтрНайти(ТекстЧека, Разделитель,, Позиция1 + 1);
	Позиция3 = СтрНайти(ТекстЧека, Разделитель,, Позиция2 + 1);
	Шапка = Лев(ТекстЧека, Позиция1 - 1);
	Состав = Сред(ТекстЧека, Позиция1 + 32, Позиция2 - Позиция1 - 33);
	Итог = Сред(ТекстЧека, Позиция2 + 32, Позиция3 - Позиция2 - 32);
	Подвал = Сред(ТекстЧека, Позиция3 + 32);
	
	СтрокаСостава.Состав = Состав;
	СтрокаСостава.Реквизиты = Шапка + Итог + Подвал;
	
КонецПроцедуры

Процедура ДополнитьТоварамиПараметрыПриПробитииЧека(ДокументОбъект, ОбщиеПараметры, ТаблицаТоваровЧека, ПризнакСпособаРасчета)
	
	ЭтоАванс = ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.Аванс
			ИЛИ ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПредоплатаПолная
			ИЛИ ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПредоплатаЧастичная;
	
	Если ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.Аванс Тогда
		
		СтрокаПозицииЧека = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыФискальнойСтрокиЧека(); 
		Если ОбщиеПараметры.ТипРасчета = Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратДенежныхСредств Тогда
			СтрокаПозицииЧека.Наименование = НСтр("ru = 'Возврат от:'") + " " + ДокументОбъект.Контрагент;
		Иначе
			СтрокаПозицииЧека.Наименование = НСтр("ru = 'Оплата от:'") + " " + ДокументОбъект.Контрагент;
		КонецЕсли;
		СтрокаПозицииЧека.Количество     = 1;
		СтрокаПозицииЧека.Цена           = ДокументОбъект.СуммаДокумента;
		СтрокаПозицииЧека.ЦенаСоСкидками = ДокументОбъект.СуммаДокумента;
		СтрокаПозицииЧека.Сумма          = ДокументОбъект.СуммаДокумента;
		СтрокаПозицииЧека.НомерСекции    = 2;
		Если ОбщиеПараметры.СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.ОСН Тогда
			
			Если ДокументОбъект.Дата > '20190101' Тогда
				СтрокаПозицииЧека.СтавкаНДС = 120;
				СтрокаПозицииЧека.СуммаНДС = СтрокаПозицииЧека.Сумма / 120 * 20;
			Иначе
				СтрокаПозицииЧека.СтавкаНДС = 118;
				СтрокаПозицииЧека.СуммаНДС = СтрокаПозицииЧека.Сумма / 118 * 18;
			КонецЕсли;
			
		Иначе
			СтрокаПозицииЧека.СтавкаНДС      = Неопределено;
		КонецЕсли;
		СтрокаПозицииЧека.ПризнакСпособаРасчета = ПризнакСпособаРасчета;
		СтрокаПозицииЧека.ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.ПлатежВыплата;
		
		ОбщиеПараметры.ПозицииЧека.Добавить(СтрокаПозицииЧека);
		
	Иначе
		
		ДанныеДляИСМП = РозничныеПродажиСервер.ДанныеДляИСМП(ДокументОбъект, ОбщиеПараметры);
		
		ОперацияСДенежнымиСредствами = Ложь;
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДокументОбъект, "ОперацияСДенежнымиСредствами") Тогда
			ОперацияСДенежнымиСредствами = ДокументОбъект.ОперацияСДенежнымиСредствами;
		КонецЕсли;
		
		Для Каждого СтрокаТЧ Из ТаблицаТоваровЧека Цикл
			
			МассивСтрокДляДобавленияВЧек = Новый Массив;
			МассивСтрокДляДобавленияВЧек.Добавить(СтрокаТЧ);
			
			Если ДанныеДляИСМП.Количество() > 0 Тогда
				СтрокиИСМП = ДанныеДляИСМП.НайтиСтроки(Новый Структура("НомерСтроки", СтрокаТЧ.НомерСтроки));
				Если СтрокиИСМП.Количество() > 0 Тогда
					МассивСтрокДляДобавленияВЧек = СтрокиИСМП;
				КонецЕсли;
			КонецЕсли;
			
			Для Каждого СтрокаДляДобавленияВЧек Из МассивСтрокДляДобавленияВЧек Цикл
				
				СтрокаТаблицыТоваров = Новый СписокЗначений();
				РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
					СтрокаТЧ.Номенклатура, "НаименованиеПолное,ТипНоменклатуры,ЭтоНабор,ВидМаркировки,АлкогольнаяПродукция,ПодакцизныйТовар, 
						|ВидПродукцииИС, ПризнакПредметаРасчета, ПродаетсяВРозлив");
				Если ЗначениеЗаполнено(СтрокаТЧ.Характеристика) Тогда
					НаименованиеХарактеристикиДляПечати = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТЧ.Характеристика, "НаименованиеДляПечати");
					НаименованиеТовара = РеквизитыНоменклатуры.НаименованиеПолное + " (" + НаименованиеХарактеристикиДляПечати + ")";
				Иначе
					НаименованиеТовара = РеквизитыНоменклатуры.НаименованиеПолное;
				КонецЕсли;
				
				СтрокаПозицииЧека = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыФискальнойСтрокиЧека();
				СтрокаПозицииЧека.Вставить("РезультатРаспределенияШтрихкодов");
				СтрокаПозицииЧека.Наименование = НаименованиеТовара;
				СтрокаПозицииЧека.Количество   = СтрокаДляДобавленияВЧек.Количество;
				СтрокаПозицииЧека.Цена         = СтрокаТЧ.Цена + ?(ДокументОбъект.СуммаВключаетНДС, 0, СтрокаДляДобавленияВЧек.СуммаНДС / ?(СтрокаДляДобавленияВЧек.Количество = 0, 1, СтрокаДляДобавленияВЧек.Количество)); //  5 - Цена за позицию без скидки;
				СуммаСкидки = СтрокаПозицииЧека.Цена * СтрокаПозицииЧека.Количество - (СтрокаДляДобавленияВЧек.Сумма + ?(ДокументОбъект.СуммаВключаетНДС, 0, СтрокаДляДобавленияВЧек.СуммаНДС));
				СтрокаПозицииЧека.ЦенаСоСкидками = Окр(СтрокаПозицииЧека.Цена - СуммаСкидки / ?(СтрокаДляДобавленияВЧек.Количество = 0, 1, СтрокаДляДобавленияВЧек.Количество), 2);
				Если СтрокаТЧ.Всего = СтрокаДляДобавленияВЧек.Сумма Тогда
					СтрокаПозицииЧека.Сумма        = СтрокаТЧ.Всего;
				ИначеЕсли ДокументОбъект.СуммаВключаетНДС Тогда
					СтрокаПозицииЧека.Сумма = СтрокаДляДобавленияВЧек.Сумма;
				Иначе
					СтрокаПозицииЧека.Сумма = СтрокаДляДобавленияВЧек.Сумма + СтрокаДляДобавленияВЧек.СуммаНДС;
				КонецЕсли;
				СтрокаПозицииЧека.СуммаСкидок = СуммаСкидки;
				СтрокаПозицииЧека.НомерСекции  = 1;
				СтрокаПозицииЧека.СуммаНДС = СтрокаДляДобавленияВЧек.СуммаНДС;
				Если Не ОперацияСДенежнымиСредствами Тогда
					СтрокаПозицииЧека.Штрихкод = СтрокаДляДобавленияВЧек.Штрихкод;
				КонецЕсли;
				СтрокаПозицииЧека.ПризнакПредметаРасчета = РозничныеПродажиСервер.ПолучитьПризнакПредметаРасчета(РеквизитыНоменклатуры);
				Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаДляДобавленияВЧек, "ЕдиницаИзмерения") 
					И ЗначениеЗаполнено(СтрокаДляДобавленияВЧек.ЕдиницаИзмерения) Тогда 
					Если ТипЗнч(СтрокаДляДобавленияВЧек.ЕдиницаИзмерения) = Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
						ЕдиницаИзмеренияПозицииЧека = 
							ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаДляДобавленияВЧек.ЕдиницаИзмерения, "ЕдиницаИзмеренияПоКлассификатору");
					ИначеЕсли ТипЗнч(СтрокаДляДобавленияВЧек.ЕдиницаИзмерения) = Тип("СправочникСсылка.КлассификаторЕдиницИзмерения") Тогда
						ЕдиницаИзмеренияПозицииЧека = СтрокаДляДобавленияВЧек.ЕдиницаИзмерения;
					Иначе
						ЕдиницаИзмеренияПозицииЧека = Неопределено;
					КонецЕсли;
					Если ЗначениеЗаполнено(ЕдиницаИзмеренияПозицииЧека) Тогда
						КодЕдиницыИзмеренияПозицииЧека = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЕдиницаИзмеренияПозицииЧека, "Код");
						СтрокаПозицииЧека.КодЕдиницыИзмерения = КодЕдиницыИзмеренияПозицииЧека;
					КонецЕсли;
				КонецЕсли;
				Если ЗначениеЗаполнено(СтрокаТЧ.Партия)
					И СтрокаТЧ.Партия.Статус <> Перечисления.СтатусыПартий.СобственныеЗапасы Тогда
					СтруктураРеквизитов = Новый Структура();
					СтруктураРеквизитов.Вставить("НаименованиеПолное", "ВладелецПартии.НаименованиеПолное");
					СтруктураРеквизитов.Вставить("ИНН", "ВладелецПартии.ИНН");
					СтруктураРеквизитов.Вставить("ВладелецПартии", "ВладелецПартии");
					РеквизитыВладельца = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрокаТЧ.Партия, СтруктураРеквизитов);
					СтрокаПозицииЧека.ДанныеПоставщика.Наименование = РеквизитыВладельца.НаименованиеПолное;
					СтрокаПозицииЧека.ДанныеПоставщика.ИНН = РеквизитыВладельца.ИНН;
					Если СтрокаТЧ.Партия.Статус = Перечисления.СтатусыПартий.ТоварыНаКомиссии Тогда
						СтрокаПозицииЧека.ПризнакАгентаПоПредметуРасчета = Перечисления.ПризнакиАгента.Комиссионер;
					КонецЕсли;
					Телефон = Справочники.Контрагенты.ПолучитьТелефонКонтрагента(РеквизитыВладельца.ВладелецПартии);
					Телефон = РозничныеПродажиСервер.УбратьРазделителиВНомереТелефона(Телефон);
					СтрокаПозицииЧека.ДанныеПоставщика.Телефон = Телефон;
				КонецЕсли;
				
				СтрокаПозицииЧека.НомерСтрокиТовара = СтрокаТЧ.НомерСтроки;
				СтрокаПозицииЧека.КодВидаНоменклатурнойКлассификации = СтрокаТЧ.Номенклатура.КодМедицинскогоИзделия;
				
				Если СтрокаТЧ.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат Тогда
					СтрокаПозицииЧека.ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.Аванс;
					СтрокаПозицииЧека.СтавкаНДС = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДСДляККТ(СтрокаТЧ.СтавкаНДС, Истина);
				Иначе
					СтрокаПозицииЧека.ПризнакСпособаРасчета = ПризнакСпособаРасчета;
					СтрокаПозицииЧека.СтавкаНДС = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДСДляККТ(СтрокаТЧ.СтавкаНДС, ЭтоАванс);
				КонецЕсли;
				
				Если РеквизитыНоменклатуры.ПодакцизныйТовар
					И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДокументОбъект, "Контрагент")
					И ЗначениеЗаполнено(ДокументОбъект.Контрагент) Тогда
					ВидКонтрагента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОбъект.Контрагент, "ВидКонтрагента");
					
					Если ВидКонтрагента = Перечисления.ВидыКонтрагентов.ЮридическоеЛицо
						ИЛИ ВидКонтрагента = Перечисления.ВидыКонтрагентов.ИндивидуальныйПредприниматель Тогда
						СтрокаПозицииЧека.СуммаАкциза = 0;
					КонецЕсли;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(РеквизитыНоменклатуры.ВидПродукцииИС)
					И ДанныеДляИСМП.Количество() > 0 Тогда
					
					СтрокаПозицииЧека.Штрихкод = СтрокаДляДобавленияВЧек.Штрихкод;
					
					РозничныеПродажиСервер.ЗаполнитьСтрокуПоДаннымРазбораШтрихкода(СтрокаПозицииЧека, СтрокаДляДобавленияВЧек);
					
					Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаДляДобавленияВЧек, "РезультатРаспределенияШтрихкодов")
						И ЗначениеЗаполнено(СтрокаДляДобавленияВЧек.РезультатРаспределенияШтрихкодов) Тогда
						
						РезультатРаспределенияШтрихкодов = СтрокаДляДобавленияВЧек.РезультатРаспределенияШтрихкодов;
						
						СтрокаПозицииЧека.РезультатРаспределенияШтрихкодов = СтрокаДляДобавленияВЧек.РезультатРаспределенияШтрихкодов;
						
						ПолныйКодМаркировки = РезультатРаспределенияШтрихкодов.ПолныйКодМаркировки;
						Если ЗначениеЗаполнено(ПолныйКодМаркировки) Тогда
							СтрокаПозицииЧека.ШтрихкодBase64 = ПолныйКодМаркировки;
							СтрокаПозицииЧека.КонтрольнаяМарка = ПолныйКодМаркировки;
						КонецЕсли;
						
						Если РезультатРаспределенияШтрихкодов.ЧастичноеВыбытие Тогда
							Если РеквизитыНоменклатуры.ВидПродукцииИС = Перечисления.ВидыПродукцииИС.Пиво Тогда
								СтрокаПозицииЧека.Штрихкод = "";
								СтрокаПозицииЧека.ШтрихкодBase64 = "";
							Иначе
								СтрокаПозицииЧека.ДробноеКоличество.Числитель   = РезультатРаспределенияШтрихкодов.Количество;
								СтрокаПозицииЧека.ДробноеКоличество.Знаменатель = РезультатРаспределенияШтрихкодов.ЕмкостьПотребительскойУпаковки;
								
								Если РезультатРаспределенияШтрихкодов.Количество > 1 Тогда
									
									Упаковка = СтрокаДляДобавленияВЧек.ЕдиницаИзмерения;
									Если НЕ ЗначениеЗаполнено(Упаковка) Тогда
										Упаковка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаДляДобавленияВЧек.Номенклатура, "ЕдиницаИзмерения");
									КонецЕсли;
									
									УпаковкаНаименование = "ед";
									Если ЗначениеЗаполнено(Упаковка) Тогда
										УпаковкаНаименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Упаковка, "Наименование");
									КонецЕсли;
									УпаковкаНаименование = УпаковкаНаименование + ".";
									
									Валюта = ДокументОбъект.ВалютаДокумента;
									ЦенаЕдиницы = Окр(СтрокаДляДобавленияВЧек.Цена / РезультатРаспределенияШтрихкодов.Количество, 2);
									
									ОписаниеЧастичногоВыбытия = СтрШаблон(
										НСтр("ru = ' (%1 %2, цена: %3 %4/%5)'"),
										РезультатРаспределенияШтрихкодов.Количество,
										УпаковкаНаименование,
										ЦенаЕдиницы,
										Валюта,
										УпаковкаНаименование);
									
									СтрокаПозицииЧека.Наименование = СтрокаПозицииЧека.Наименование
										+ ОписаниеЧастичногоВыбытия;
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
						
						Если ЗначениеЗаполнено(РезультатРаспределенияШтрихкодов.РазрешительныйРежимИдентификаторЗапросаГИСМТ) Тогда
							СтрокаПозицииЧека.ЗапросПроверкиКода.ИдентификаторЗапроса
								= РезультатРаспределенияШтрихкодов.РазрешительныйРежимИдентификаторЗапросаГИСМТ;
							СтрокаПозицииЧека.ЗапросПроверкиКода.ВременнаяМетка
								= РезультатРаспределенияШтрихкодов.РазрешительныйРежимДатаЗапросаГИСМТ;
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЕсли;
				
				АгентскиеПлатежиУНФ.ЗаполнитьПараметрыПлатежногоДоговораВСтроке(ОбщиеПараметры, СтрокаПозицииЧека, СтрокаТЧ);
				
				ОбщиеПараметры.ПозицииЧека.Добавить(СтрокаПозицииЧека);
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти