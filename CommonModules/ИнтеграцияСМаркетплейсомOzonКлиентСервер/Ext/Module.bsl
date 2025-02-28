﻿
#Область СлужебныеПроцедурыИФункции

// Формирует массив отбора по типам номенклатуры: Товар.
//
// Возвращаемое значение:
//  Массив - состоит из элементов типа ПеречислениеСсылка.ТипыНоменклатуры.
//
Функция ОтборПоНоменклатуре() Экспорт

	МассивТиповНоменклатуры = Новый Массив;
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Запас"));

	Возврат МассивТиповНоменклатуры;

КонецФункции

// Возвращает массив составляющих из строки пути к полю, представлено в виде строки с точками-разделителями.
//
// Параметры:
//  ПутьКПолю - Строка - строка пути к полю с точками-разделителями вида "Номенклатура.ВидНоменклатуры.Наименование".
//
// Возвращаемое значение:
//  Массив - Строка - составляющие из строки пути к полю.
//
Функция ЧастиПутиКПолю(Знач ПутьКПолю) Экспорт

	СоответствиеПутиДополнительногоСвойства = Новый Соответствие;

	НомерСвойства = 1;
	Пока Истина Цикл
		ПозицияНачала = СтрНайти(ПутьКПолю, ".[");
		Если ПозицияНачала = 0 Тогда
			Прервать;
		КонецЕсли;

		ПозицияКонца = СтрНайти(ПутьКПолю, "].");
		Если ПозицияКонца = 0 Тогда
			ПозицияКонца = 1;

			Пока ПозицияКонца <= СтрДлина(ПутьКПолю) Цикл
				ПозицияПоиска = СтрНайти(ПутьКПолю, "]",, ПозицияКонца);
				Если ПозицияПоиска = 0 Тогда
					Прервать;
				Иначе
					ПозицияКонца = ПозицияПоиска;
				КонецЕсли;
				
				ПозицияКонца = ПозицияКонца + 1;
			КонецЦикла;
		КонецЕсли;

		Если ПозицияКонца = 1 Тогда
			Прервать;
		КонецЕсли;

		Свойство = Сред(ПутьКПолю, ПозицияНачала + 1, ПозицияКонца - ПозицияНачала);
		ИмяСвойства = "Свойство" + НомерСвойства;

		СоответствиеПутиДополнительногоСвойства.Вставить(ИмяСвойства, Свойство);

		ПутьКПолю = СтрЗаменить(ПутьКПолю, Свойство, ИмяСвойства);

		НомерСвойства = НомерСвойства + 1;
	КонецЦикла;

	ЧастиПутиКПолю = СтрРазделить(ПутьКПолю, ".");

	Для Каждого СоответствиеПути Из СоответствиеПутиДополнительногоСвойства Цикл
		ИндексЭлемента = ЧастиПутиКПолю.Найти(СоответствиеПути.Ключ);
		Если ИндексЭлемента <> Неопределено Тогда 
			ЧастиПутиКПолю[ИндексЭлемента] = СоответствиеПути.Значение;
		КонецЕсли;
	КонецЦикла;

	Возврат ЧастиПутиКПолю;

КонецФункции

Функция ПроверитьДублированиеДополнительногоРеквизита(ПутьКПолю, ЗаголовокПоля, ВыбранныеПоляКомпоновщикаНастроек) Экспорт

	Результат = "";

	Если ПустаяСтрока(ПутьКПолю) Тогда
		Возврат Результат;
	КонецЕсли;

	ЕстьДубли = Ложь;

	ЧастиПути = ЧастиПутиКПолю(ПутьКПолю);
	ЧастиПутиЗаголовка = ЧастиПутиКПолю(ЗаголовокПоля);

	МассивЧастейПутиКПолю = Новый Массив;
	МассивЧастейПутиКЗаголовку = Новый Массив;
	Счетчик = 1;
	Для Каждого ЧастьПути Из ЧастиПути Цикл
		Если ЧастиПутиЗаголовка.Количество() >= Счетчик Тогда
			МассивЧастейПутиКЗаголовку.Добавить(ЧастиПутиЗаголовка[Счетчик - 1]);
		КонецЕсли;

		Если Счетчик > 1 Тогда
			ИмяРеквизита = СтрСоединить(МассивЧастейПутиКПолю, ".");
			Поле = Новый ПолеКомпоновкиДанных(ИмяРеквизита);
			КоллекцияПолей = ВыбранныеПоляКомпоновщикаНастроек.НайтиПоле(Поле);

			МассивЧастейПутиКПолю.Добавить(ЧастьПути);
			ИмяРеквизита = СтрСоединить(МассивЧастейПутиКПолю, ".");
			Поле = Новый ПолеКомпоновкиДанных(ИмяРеквизита);

			КоличествоПолей = КоличествоВхожденийПоляВКоллекцию(Поле, КоллекцияПолей);

			Если КоличествоПолей > 1 Тогда
				ЕстьДубли = Истина;
				Прервать;
			КонецЕсли;
		Иначе
			МассивЧастейПутиКПолю.Добавить(ЧастьПути);
		КонецЕсли;

		Счетчик = Счетчик + 1;
	КонецЦикла;

	Если ЕстьДубли Тогда
		ПредставлениеПоля = ?(ПустаяСтрока(ЗаголовокПоля), ИмяРеквизита, СтрСоединить(МассивЧастейПутиКЗаголовку, "."));
		ШаблонСообщенияОбОшибке =
				НСтр("ru = 'Для реквизита 1С <%1> обнаружено дублирование наименования среди дополнительных реквизитов / сведений.'");
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщенияОбОшибке, ПредставлениеПоля);
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция КоличествоВхожденийПоляВКоллекцию(Поле, КоллекцияПолей)

	КоличествоПолей = 0;

	Если КоллекцияПолей = Неопределено Или Поле = Неопределено Тогда
		Возврат КоличествоПолей;
	КонецЕсли;

	Для Каждого ВыбранноеПоле Из КоллекцияПолей.Элементы Цикл
		Если Поле = ВыбранноеПоле.Поле Тогда 
			КоличествоПолей = КоличествоПолей + 1;
		КонецЕсли;
	КонецЦикла;

	Возврат КоличествоПолей;

КонецФункции

Функция ОписаниеТипа(ТипЗначения1С, ТипЗначенияМаркетплейса = "") Экспорт

	Если ЗначениеЗаполнено(ТипЗначенияМаркетплейса) И ТипЗначенияМаркетплейса = "integer" Тогда
		КвалификаторЧисла = Новый КвалификаторыЧисла(15, 0);
		ОписаниеТипа = Новый ОписаниеТипов(ТипЗначения1С,,, КвалификаторЧисла);
	Иначе
		ОписаниеТипа = Новый ОписаниеТипов(ТипЗначения1С);
	КонецЕсли;

	Возврат ОписаниеТипа;

КонецФункции

Функция ПараметрыДействийДляКарточкиТовара() Экспорт

	ПараметрыДействий = Новый Структура;
	ПараметрыДействий.Вставить("Событие", "");
	ПараметрыДействий.Вставить("ПолучитьДанныеТовара", Ложь);
	ПараметрыДействий.Вставить("ОбновитьДанныеТовара", Ложь);
	ПараметрыДействий.Вставить("ОбновитьКатегориюМаркетплейса", Ложь);
	ПараметрыДействий.Вставить("ЗаполнитьДеревоРеквизитов", Ложь);
	ПараметрыДействий.Вставить("ЗаполнитьДеревоАтрибутов", Ложь);
	ПараметрыДействий.Вставить("ПолучитьОбъектыПубликации", Ложь);
	ПараметрыДействий.Вставить("ОбновитьОбъектыПубликации", Ложь);
	ПараметрыДействий.Вставить("ПолучитьОписаниеТовара", Ложь);
	ПараметрыДействий.Вставить("ПроверитьОшибки", Ложь);

	Возврат ПараметрыДействий;

КонецФункции

Функция НавигационнаяСсылкаНаТовар(SKU) Экспорт

	Возврат "https://www.ozon.ru/context/detail/id/" + SKU;

КонецФункции

// Функция - Префиксы сервиса
//  Возвращает список используемых подсистемой префиксов настроек.
// Возвращаемое значение:
//  Структура - Список используемых подсистемой префиксов настроек.
//
Функция ПрефиксыСервиса() Экспорт

	Префиксы = Новый Структура;
	Префиксы.Вставить("НастройкиСервиса", "OzonSetup_"); 
	Префиксы.Вставить("ВыгрузкаОстатков", "OzonBalanceUnload_"); 
	Префиксы.Вставить("ЗагрузкаОстатков", "OzonBalanceLoad_"); 
	Префиксы.Вставить("ВыгрузкаЦен", "OzonPriceUnload_"); 
	Префиксы.Вставить("ЗагрузкаЦен", "OzonPriceLoad_"); 
	Префиксы.Вставить("ОбновлениеТоварногоКаталога", "OzonProductCatalogUpdate_");

	Возврат Префиксы;

КонецФункции

Функция ВариантЗагрузкиОбновитьСопоставленныеКарточкиТоваров() Экспорт
	Возврат 0;
КонецФункции

Функция ВариантЗагрузкиЗагрузитьНесопоставленныеКарточкиТоваров() Экспорт
	Возврат 2;
КонецФункции

Функция ФормаРежимОтображенияОткрытие() Экспорт
	Возврат 0;
КонецФункции

Функция ФормаРежимОтображенияЗагрузитьВсеОписания() Экспорт
	Возврат 1;
КонецФункции

Функция ФормаРежимОтображенияЗагрузитьСДетальнымиНастройками() Экспорт
	Возврат 2;
КонецФункции

Функция ПараметрыИмпортаДляДетальнойЗагрузки() Экспорт

	Параметры = Новый Структура;
	Параметры.Вставить( "УчетнаяЗаписьМаркетплейса", Неопределено );
	Параметры.Вставить( "ВариантЗагрузкиДанных", ИнтеграцияСМаркетплейсомOzonКлиентСервер.ВариантЗагрузкиЗагрузитьНесопоставленныеКарточкиТоваров() );

	Параметры.Вставить( "СоздатьЭлементыНоменклатуры", Истина );
	Параметры.Вставить( "ПерезаполнитьЗначенияРеквизитовНоменклатуры", Ложь );
	Параметры.Вставить( "СоздатьИерархиюНоменклатуры", Истина );
	Параметры.Вставить( "СоздатьХарактеристикиНоменклатуры", Истина );
	
	Параметры.Вставить( "СоздатьКатегорииНоменклатуры", Истина );
	Параметры.Вставить( "СоздатьИерархиюКатегорийНоменклатуры", Истина );

	Параметры.Вставить( "ЗагрузитьИзображения", Истина );
	Параметры.Вставить( "ЗагрузитьЦеныПродажи", Истина );
	
	Параметры.Вставить( "ДанныеВыделенныхСтрок", Неопределено );
	
	Параметры.Вставить( "ЗагрузитьОписанияАрхивныхПозиций", Ложь );
	Параметры.Вставить( "РазмерПорцииЗагрузкиДанных", 100 );
	
	Возврат Параметры;
КонецФункции

// Возвращает список констант для сервиса.
//
// Возвращаемое значение:
//   Соответствие Из КлючИЗначение - имена и значения констант.
//
Функция КонстантыСервиса() Экспорт

	Результат = Новый Соответствие;
	
	Результат.Вставить( "ИдентификаторАтрибута_ТНВЭД", "22232" );
	Результат.Вставить( "ИдентификаторАтрибута_Наименование", "4180" );
	Результат.Вставить( "ИдентификаторАтрибута_Аннотация", "4191" );
	Результат.Вставить( "ИдентификаторАтрибута_Изображение", "4194" );
	Результат.Вставить( "ИдентификаторАтрибута_ТипТовара", "8229" );
	Результат.Вставить( "ИдентификаторАтрибута_ОбъединитьНаОднойКарточке", "8292" );
	Результат.Вставить( "ИдентификаторАтрибута_Артикул", "9024" );
	
	Возврат Результат;

КонецФункции

// Определяет постфикс устаревшей категории торговой площадки.
//
// Возвращаемое значение:
//   Строка - постфикс устаревшей категории.
//
Функция ПостфиксУстаревшейКатегории() Экспорт

	Возврат " " + НСтр("ru = '(Устарела)'");

КонецФункции

Функция КатегориияМаркетплейсаУстарела( ИдентификаторКатегорииМаркетплейса ) Экспорт
    Результат = (СтрНайти( ИдентификаторКатегорииМаркетплейса, "_") = 0);
	Возврат Результат;
КонецФункции

// Определяет постфикс неиспользуемой категории торговой площадки.
//
// Возвращаемое значение:
//   Строка - постфикс неиспользуемой категории.
//
Функция ПостфиксНеиспользуемойКатегории() Экспорт

	Возврат " " + НСтр("ru = '(Не сопоставлено)'");

КонецФункции

Функция НаименованияАтрибутаМаркетплейсаДляОбъединенияВОднуКарточкуПолучить() Экспорт
	Результат = Новый Массив;
	Результат.Добавить( "Объединить на одной карточке" );
	Результат.Добавить( "Combine into One PDP" );
	Результат.Добавить( "Название модели (для объединения в одну карточку)" );
	Результат.Добавить( "Значение объединения в одну карточку" );
	
	Возврат Результат;
КонецФункции

#КонецОбласти
