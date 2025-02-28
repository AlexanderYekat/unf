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
	Результат.Добавить(Новый Структура("Имя, Представление", "Основной", 
		НСтр("ru = 'Товарный отчет ТОРГ-29'")));
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ТоварныйОтчетТОРГ29, "Основной");
	Вариант.Описание = НСтр("ru = 'Отчет предназначен для анализа розничных продаж. Отчет формируется по регламентированной форме Торг-29.'");
	Для Каждого РазмещениеВПодсистеме Из Вариант.Размещение Цикл
		Вариант.Размещение.Вставить(РазмещениеВПодсистеме.Ключ, "Важный");
	КонецЦикла; 
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

// Выполняет формирование табличного документа отчета ТОРГ-29.
//
// Параметры:
//  ПараметрыОтчета	 - Структура - ключи:
//   * ДатаНачала - Дата,
//   * ДатаОкончания - Дата,
//   * Организация - СправочникСсылка.Организации,
//   * СтруктурнаяЕдиница - СправочникСсылка.СтруктурныеЕдиницы,
//   * ВыводитьСуммуДокументаИДельту - Булево,
//   * НомерОтчета - Число.
//  АдресРезультата - адрес во временном хранилище, куда будет помещён ТабличныйДокумент - результат формирования
//                   товарного отчета ТОРГ-29.
//
Процедура СформироватьОтчет(ПараметрыОтчета, АдресРезультата) Экспорт
	
	ПроверитьПараметрыОтчета(ПараметрыОтчета);
	
	ИмяКлючевойОперации = "Отчет Товарный отчет ТОРГ-29 (формирование)";
	ВыполнятьЗамеры = ВыполнятьЗамеры();
	Если ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительности = ОбщегоНазначения.ОбщийМодуль("ОценкаПроизводительности");
		ВремяНачала = МодульОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	Результат = Новый ТабличныйДокумент;
	
	Макет = Отчеты.ТоварныйОтчетТОРГ29.ПолучитьМакет("Макет");
	
	ОбластьШапки = ВывестиШапку(Результат, Макет, ПараметрыОтчета);
	
	ПовторятьПриПечатиОбластьШапки = Результат.Область(1 + ОбластьШапки.ВысотаТаблицы, ,2 + ОбластьШапки.ВысотаТаблицы);
	
	ИсходныеДанные = ТаблицаИсходныеДанные(
		ПараметрыОтчета.ДатаНачала, ПараметрыОтчета.ДатаОкончания, ПараметрыОтчета.СтруктурнаяЕдиница,
		ПараметрыОтчета.НомерОтчета);
	
	НачОст = 0;
	КонОст = 0;
	
	ИнициализироватьНачОстИКонОст(НачОст, КонОст, ИсходныеДанные);
	
	ОбластьОстатокНачала = Макет.ПолучитьОбласть("ОстатокНачала");
	ОбластьОстатокНачала.Параметры.ДатаНачала = СтрШаблон(НСтр("ru = 'Остаток на %1'"), Формат(ПараметрыОтчета.ДатаНачала, "ДЛФ=Д"));
	ОбластьОстатокНачала.Параметры.НачСтоимостьВсего = ФорматированнаяСумма(НачОст);
	Результат.Вывести(ОбластьОстатокНачала);
	
	ТаблицаОстаткиИОбороты = ТаблицаОстаткиИОбороты(ПараметрыОтчета.ДатаНачала, ПараметрыОтчета.ДатаОкончания, ИсходныеДанные);
	
	Результат.Вывести(Макет.ПолучитьОбласть("Приход"));
	ВывестиСтрокиПриход(Результат, ТаблицаОстаткиИОбороты, Макет, ПараметрыОтчета);
	ВывестиИтогиПриход(Результат, ТаблицаОстаткиИОбороты, Макет, НачОст);
	
	Результат.ВывестиГоризонтальныйРазделительСтраниц();
	
	Результат.Вывести(Макет.ПолучитьОбласть("Расход"));
	ВывестиСтрокиРасход(Результат, ТаблицаОстаткиИОбороты, Макет, ПараметрыОтчета);
	ВывестиИтогиРасход(Результат, ТаблицаОстаткиИОбороты, Макет, ПараметрыОтчета, КонОст);
	
	Результат.Вывести(Макет.ПолучитьОбласть("Подвал"));
	
	Результат.ПовторятьПриПечатиСтроки = ПовторятьПриПечатиОбластьШапки;
	
	Если ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительности.ЗакончитьЗамерВремени(
		ИмяКлючевойОперации,
		ВремяНачала,
		1);
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Новый ХранилищеЗначения(Результат, Новый СжатиеДанных), АдресРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПараметрыОтчета(Знач ПараметрыОтчета)
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.ДатаНачала)
		И ЗначениеЗаполнено(ПараметрыОтчета.ДатаОкончания)
		И ПараметрыОтчета.ДатаНачала > ПараметрыОтчета.ДатаОкончания Тогда
		ВызватьИсключение НСтр("ru = 'Дата начала периода не должна превышать дату окончания.'");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыОтчета.СтруктурнаяЕдиница.РозничныйВидЦен) Тогда
		ВызватьИсключение НСтр("ru = 'У структурной единицы не указан розничный вид цен.'");
	КонецЕсли;

КонецПроцедуры

Функция ВывестиШапку(Знач Результат, Знач Макет, Знач ПараметрыОтчета)
	
	СведенияОПокупателе = ПечатьДокументовУНФ.СведенияОЮрФизЛице(ПараметрыОтчета.Организация, ПараметрыОтчета.ДатаОкончания);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ОрганизацияПредставление = ПечатьДокументовУНФ.ОписаниеОрганизации(СведенияОПокупателе);
	ОбластьМакета.Параметры.СтруктурнаяЕдиницаПредставление = ПараметрыОтчета.СтруктурнаяЕдиница.Наименование;
	ОбластьМакета.Параметры.ДатаСоставления = ТекущаяДата();
	ОбластьМакета.Параметры.ДатаНачала = ПараметрыОтчета.ДатаНачала;
	ОбластьМакета.Параметры.ДатаКонца = ПараметрыОтчета.ДатаОкончания;
	ОбластьМакета.Параметры.ОрганизацияПоОКПО = СведенияОПокупателе.КодПоОКПО;
	МОЛНаименование = ПараметрыОтчета.СтруктурнаяЕдиница.МОЛ.Наименование;
	ОбластьМакета.Параметры.МОЛ = ?(ЗначениеЗаполнено(МОЛНаименование), МОЛНаименование, "");
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Сотрудники.Код КАК МОЛТабельныйНомер
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|ГДЕ
	|	Сотрудники.Физлицо = &Физлицо");
	Запрос.УстановитьПараметр("Физлицо", ПараметрыОтчета.СтруктурнаяЕдиница.МОЛ);
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаРезультатаЗапроса.Следующий() Тогда
		ОбластьМакета.Параметры.МОЛТабельныйНомер = ?(ЗначениеЗаполнено(ВыборкаРезультатаЗапроса.МОЛТабельныйНомер), ВыборкаРезультатаЗапроса.МОЛТабельныйНомер, "");
	КонецЕсли;
	
	ОбластьМакета.Параметры.Номер = ПараметрыОтчета.НомерОтчета;
	
	Результат.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	Результат.Вывести(ОбластьМакета);
	
	Возврат ОбластьМакета;

КонецФункции

Процедура ИнициализироватьНачОстИКонОст(НачОст, КонОст, Знач ИсходныеДанные)
	
	Если Не ЗначениеЗаполнено(ИсходныеДанные) Тогда
		Возврат;
	КонецЕсли;
	
	Если ИсходныеДанные[0].СуммаНачальныйОстаток <> NULL Тогда
		НачОст = ИсходныеДанные[0].СуммаНачальныйОстаток;
	КонецЕсли;
	
	Если ИсходныеДанные[ИсходныеДанные.Количество()-1].СуммаКонечныйОстаток <> NULL Тогда
		КонОст = ИсходныеДанные[ИсходныеДанные.Количество()-1].СуммаКонечныйОстаток;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиСтрокиПриход(Знач Результат, Знач ТаблицаОстаткиИОбороты, Знач Макет, Знач ПараметрыОтчета)
	
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	
	Для Каждого СтрокаТЗ Из ТаблицаОстаткиИОбороты Цикл
		
		Если СтрокаТЗ.Приход = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьСтрока.Параметры.ПредставлениеДокумента = СтрокаТЗ.Документ;
		ОбластьСтрока.Параметры.ДатаДокумента = СтрокаТЗ.ДатаДок;
		ОбластьСтрока.Параметры.НомерДокумента = Формат(СтрокаТЗ.НомерДок,"ЧЦ=11; ЧВН=; ЧГ=0");
		ОбластьСтрока.Параметры.СуммаТовара = ФорматированнаяСумма(СтрокаТЗ.Приход);
		ОбластьСтрока.Параметры.СуммаТары = ФорматированнаяСумма(0);
		Если ПараметрыОтчета.ВыводитьСуммуДокументаИДельту Тогда
			ОбластьСтрока.Параметры.РегистраторСумма = ФорматированнаяСумма(СтрокаТЗ.РегистраторСумма);
			ОбластьСтрока.Параметры.ДельтаСуммы = ФорматированнаяСумма(СтрокаТЗ.Приход - СтрокаТЗ.РегистраторСумма);
		Иначе
			ОбластьСтрока.Параметры.РегистраторСумма = "";
			ОбластьСтрока.Параметры.ДельтаСуммы = "";
		КонецЕсли;
		Если ТипЗнч(СтрокаТЗ.Документ) = Тип("Строка") Тогда
			ОбластьСтрока.Параметры.Расшифровка = Новый Структура("Документ, Дата, Сумма", СтрокаТЗ.Документ, СтрокаТЗ.ДатаДок, СтрокаТЗ.Приход);
		Иначе
			ОбластьСтрока.Параметры.Расшифровка = СтрокаТЗ.Документ;
		КонецЕсли;
		Результат.Вывести(ОбластьСтрока);
		
	КонецЦикла;

КонецПроцедуры

Процедура ВывестиИтогиПриход(Знач Результат, Знач ТаблицаОстаткиИОбороты, Знач Макет, Знач НачОст)
	
	Приход = ТаблицаОстаткиИОбороты.Итог("Приход");
	
	ОбластьИтогоПриход = Макет.ПолучитьОбласть("ИтогоПриход");
	ОбластьИтогоПриход.Параметры.ПриходСтоимостьВсего = ФорматированнаяСумма(Приход);
	Результат.Вывести(ОбластьИтогоПриход);
	
	ОбластьВсегоПриход = Макет.ПолучитьОбласть("ВсегоПриход");
	ОбластьВсегоПриход.Параметры.ПриходСОстатком = ФорматированнаяСумма(Приход + НачОст);
	Результат.Вывести(ОбластьВсегоПриход);

КонецПроцедуры

Процедура ВывестиСтрокиРасход(Знач Результат, Знач ТаблицаОстаткиИОбороты, Знач Макет, Знач ПараметрыОтчета)
	
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	
	Для Каждого СтрокаТЗ Из ТаблицаОстаткиИОбороты Цикл
		
		Если СтрокаТЗ.Расход = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьСтрока.Параметры.ПредставлениеДокумента = СтрокаТЗ.Документ;
		ОбластьСтрока.Параметры.ДатаДокумента = СтрокаТЗ.ДатаДок;
		ОбластьСтрока.Параметры.НомерДокумента = Формат(СтрокаТЗ.НомерДок,"ЧЦ=11; ЧВН=; ЧГ=0");
		ОбластьСтрока.Параметры.СуммаТовара = ФорматированнаяСумма(СтрокаТЗ.Расход);
		ОбластьСтрока.Параметры.СуммаТары = ФорматированнаяСумма(0);
		Если ТипЗнч(СтрокаТЗ.Документ) = Тип("Строка") Тогда
			ОбластьСтрока.Параметры.Расшифровка = Новый Структура("Документ, Дата, Сумма", СтрокаТЗ.Документ, СтрокаТЗ.ДатаДок, СтрокаТЗ.Приход);
		Иначе
			ОбластьСтрока.Параметры.Расшифровка = СтрокаТЗ.Документ;
		КонецЕсли;
		Если ПараметрыОтчета.ВыводитьСуммуДокументаИДельту Тогда
			ОбластьСтрока.Параметры.РегистраторСумма = ФорматированнаяСумма(СтрокаТЗ.РегистраторСумма);
			ОбластьСтрока.Параметры.ДельтаСуммы = ФорматированнаяСумма(СтрокаТЗ.Расход - СтрокаТЗ.РегистраторСумма);
		Иначе
			ОбластьСтрока.Параметры.РегистраторСумма = "";
			ОбластьСтрока.Параметры.ДельтаСуммы = "";
		КонецЕсли;
		Результат.Вывести(ОбластьСтрока);
		
	КонецЦикла;

КонецПроцедуры

Процедура ВывестиИтогиРасход(Знач Результат, Знач ТаблицаОстаткиИОбороты, Знач Макет, Знач ПараметрыОтчета, Знач КонОст)
	
	Расход = ТаблицаОстаткиИОбороты.Итог("Расход");
	
	ОбластьИтогоРасход = Макет.ПолучитьОбласть("ИтогоРасход");
	ОбластьИтогоРасход.Параметры.РасходСтоимостьВсего = ФорматированнаяСумма(Расход);
	Результат.Вывести(ОбластьИтогоРасход);
	
	ОбластьОстатокКонец = Макет.ПолучитьОбласть("ОстатокКонец");
	ОбластьОстатокКонец.Параметры.ДатаКонца = СтрШаблон(НСтр("ru = 'Остаток на %1.'"), Формат(ПараметрыОтчета.ДатаОкончания, "ДЛФ=Д"));
	ОбластьОстатокКонец.Параметры.КонСтоимостьВсего = ФорматированнаяСумма(КонОст);
	Результат.Вывести(ОбластьОстатокКонец);

КонецПроцедуры

Функция ФорматированнаяСумма(Знач Сумма)
	
	Возврат Формат(Сумма, "ЧЦ=15; ЧДЦ=2");
	
КонецФункции

Функция ТаблицаИсходныеДанные(Знач ДатаНачала, Знач ДатаОкончания, Знач СтруктурнаяЕдиница, Знач НомерОтчета)
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ПериодСекунда", Новый ОписаниеТипов("Дата"));
	Результат.Колонки.Добавить("Регистратор", ТипКолонкиРегистратор());
	Результат.Колонки.Добавить("СуммаНачальныйОстаток", Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("СуммаПриход", Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("СуммаРасход", Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("СуммаКонечныйОстаток", Новый ОписаниеТипов("Число"));
	Результат.Индексы.Добавить("ПериодСекунда, Регистратор");
	
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(ЗапросИзСКД());
	СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Источники[0].Источник.Параметры[4].Выражение
		= Новый ВыражениеСхемыЗапроса("СтруктурнаяЕдиница = &СтруктурнаяЕдиница");
	
	Запрос = Новый Запрос(СхемаЗапроса.ПолучитьТекстЗапроса());
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(ДатаНачала));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(ДатаОкончания));
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	Запрос.УстановитьПараметр("ВидЦен", СтруктурнаяЕдиница.РозничныйВидЦен);
	Запрос.УстановитьПараметр("РегистраторУстановкаЦен", РегистраторУстановкаЦен());
	Запрос.УстановитьПараметр("Граница", Новый Граница(КонецДня(ДатаОкончания), ВидГраницы.Включая));
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	ПоступленияНоменклатуры = ПоступленияНоменклатуры(РезультатЗапроса);
	
	Процент = 0;
	Прогресс = 0;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Прогресс = Прогресс + 1;
		ТекПроцент = Окр(Прогресс / Выборка.Количество() * 100);
		
		Если Процент <> ТекПроцент Тогда
			Процент = ТекПроцент;
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Обработано %1%% исходных данных (проход 2/2)...'"), Процент);
			ДлительныеОперации.СообщитьПрогресс(Процент, ТекстСообщения);
		КонецЕсли;
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ПериодСекунда", Выборка.ПериодСекунда);
		ПараметрыОтбора.Вставить("Регистратор", Выборка.Регистратор);
		
		НайденныеСтроки = Результат.НайтиСтроки(ПараметрыОтбора);
		Если Не ЗначениеЗаполнено(НайденныеСтроки) Тогда
			ТекСтрока = Результат.Добавить();
			ТекСтрока.ПериодСекунда = Выборка.ПериодСекунда;
			ТекСтрока.Регистратор = Выборка.Регистратор;
		Иначе
			ТекСтрока = НайденныеСтроки[0];
		КонецЕсли;
		
		ТекСтрока.СуммаНачальныйОстаток = ТекСтрока.СуммаНачальныйОстаток + Выборка.СуммаНачальныйОстаток;
		ТекСтрока.СуммаПриход = ТекСтрока.СуммаПриход + Выборка.СуммаПриход;
		ТекСтрока.СуммаРасход = ТекСтрока.СуммаРасход + Выборка.СуммаРасход;
		ТекСтрока.СуммаКонечныйОстаток = ТекСтрока.СуммаКонечныйОстаток + Выборка.СуммаКонечныйОстаток;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ТипКолонкиРегистратор()
	
	Возврат Новый ОписаниеТипов(
	Метаданные.РегистрыНакопления.ЗапасыНаСкладах.СтандартныеРеквизиты.Регистратор.Тип,
	"Строка",,,
	Новый КвалификаторыСтроки(100));
	
КонецФункции

Функция ЗапросИзСКД()
	
	СКД = Отчеты.ТоварныйОтчетТОРГ29.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Возврат СКД.НаборыДанных.Запрос.Запрос;
	
КонецФункции

Функция ПоступленияНоменклатуры(РезультатЗапроса)
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ПериодДень", Новый ОписаниеТипов("Дата"));
	Результат.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Результат.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	Результат.Индексы.Добавить("ПериодДень, Номенклатура, Характеристика");
	
	Процент = 0;
	Прогресс = 0;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Прогресс = Прогресс + 1;
		ТекПроцент = Окр(Прогресс / Выборка.Количество() * 100);
		
		Если Процент <> ТекПроцент Тогда
			Процент = ТекПроцент;
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Обработано %1%% исходных данных (проход 1/2)...'"), Процент);
			ДлительныеОперации.СообщитьПрогресс(Процент, ТекстСообщения);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.СуммаНачальныйОстаток) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ОбщегоНазначения.ЗначениеСсылочногоТипа(Выборка.Регистратор) Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ПериодДень", Выборка.ПериодДень);
		ПараметрыОтбора.Вставить("Номенклатура", Выборка.Номенклатура);
		ПараметрыОтбора.Вставить("Характеристика", Выборка.Характеристика);
		
		НайденныеСтроки = Результат.НайтиСтроки(ПараметрыОтбора);
		Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекСтрока = Результат.Добавить();
		ТекСтрока.ПериодДень = Выборка.ПериодДень;
		ТекСтрока.Номенклатура = Выборка.Номенклатура;
		ТекСтрока.Характеристика = Выборка.Характеристика;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция РегистраторУстановкаЦен()
	
	Возврат НСтр("ru = 'Установка цен'");
	
КонецФункции

Функция ТаблицаОстаткиИОбороты(Знач ДатаНачала, Знач ДатаОкончания, Знач ИсходныеДанные)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Таблица.ПериодСекунда КАК ПериодСекунда,
	|	ЕСТЬNULL(Таблица.Регистратор, НЕОПРЕДЕЛЕНО) КАК Регистратор,
	|	Таблица.СуммаНачальныйОстаток КАК НачОст,
	|	Таблица.СуммаПриход КАК Приход,
	|	Таблица.СуммаРасход КАК Расход,
	|	Таблица.СуммаКонечныйОстаток КАК КонОст
	|ПОМЕСТИТЬ ТаблицаИсходныеДанные
	|ИЗ
	|	&ИсходныеДанные КАК Таблица
	|ГДЕ НЕ ЕСТЬNULL(Таблица.Регистратор, НЕОПРЕДЕЛЕНО) = Неопределено
	|	И Таблица.ПериодСекунда >= &НачалоПериода
	|	И Таблица.ПериодСекунда <= &ОкончаниеПериода
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Таблица.ПериодСекунда КАК ПериодСекунда,
	|	Таблица.Регистратор КАК Регистратор,
	|	Таблица.Регистратор.Дата КАК РегистраторДата,
	|	Таблица.Регистратор.Номер КАК РегистраторНомер,
	|	Таблица.Регистратор.СуммаДокумента КАК РегистраторСумма,
	|	Таблица.НачОст КАК НачОст,
	|	Таблица.Приход КАК Приход,
	|	Таблица.Расход КАК Расход,
	|	Таблица.КонОст КАК КонОст
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	ТаблицаИсходныеДанные КАК Таблица
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМ
	|				ИЛИ ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМВозврат
	|			ТОГДА ТаблицаДокументов.Регистратор.КассоваяСмена
	|		ИНАЧЕ ТаблицаДокументов.Регистратор
	|	КОНЕЦ КАК Документ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМ
	|				ИЛИ ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМВозврат
	|			ТОГДА ТаблицаДокументов.Регистратор.КассоваяСмена.Дата
	|		ИНАЧЕ 
	|			ВЫБОР 
	|				КОГДА ТаблицаДокументов.РегистраторДата <> ДАТАВРЕМЯ(1,1,1,0,0,0) 
	|					ТОГДА ТаблицаДокументов.РегистраторДата
	|				ИНАЧЕ ТаблицаДокументов.ПериодСекунда
	|			КОНЕЦ
	|	КОНЕЦ КАК ДатаДок,
	|	ВЫБОР
	|		КОГДА ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМ
	|				ИЛИ ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМВозврат
	|			ТОГДА ТаблицаДокументов.Регистратор.КассоваяСмена.Номер
	|		ИНАЧЕ ТаблицаДокументов.РегистраторНомер
	|	КОНЕЦ КАК НомерДок,
	|	ВЫБОР
	|		КОГДА ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМ
	|				ИЛИ ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМВозврат
	|			ТОГДА ТаблицаДокументов.Регистратор.КассоваяСмена.СуммаДокумента
	|		ИНАЧЕ ISNULL(ТаблицаДокументов.РегистраторСумма, 0)
	|	КОНЕЦ КАК РегистраторСумма,
	|	СУММА(ТаблицаДокументов.Приход) КАК Приход,
	|	СУММА(ТаблицаДокументов.Расход) КАК Расход
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМ
	|				ИЛИ ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМВозврат
	|			ТОГДА ТаблицаДокументов.Регистратор.КассоваяСмена
	|		ИНАЧЕ ТаблицаДокументов.Регистратор
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМ
	|				ИЛИ ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМВозврат
	|			ТОГДА ТаблицаДокументов.Регистратор.КассоваяСмена.Дата
	|		ИНАЧЕ 
	|			ВЫБОР 
	|				КОГДА ТаблицаДокументов.РегистраторДата <> ДАТАВРЕМЯ(1,1,1,0,0,0) 
	|					ТОГДА ТаблицаДокументов.РегистраторДата
	|				ИНАЧЕ ТаблицаДокументов.ПериодСекунда
	|			КОНЕЦ
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМ
	|				ИЛИ ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМВозврат
	|			ТОГДА ТаблицаДокументов.Регистратор.КассоваяСмена.Номер
	|		ИНАЧЕ ТаблицаДокументов.РегистраторНомер
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМ
	|				ИЛИ ТаблицаДокументов.Регистратор ССЫЛКА Документ.ЧекККМВозврат
	|			ТОГДА ТаблицаДокументов.Регистратор.КассоваяСмена.СуммаДокумента
	|		ИНАЧЕ ISNULL(ТаблицаДокументов.РегистраторСумма, 0)
	|	КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДок,
	|	Документ
	|");
	
	Запрос.УстановитьПараметр("ИсходныеДанные", 	ИсходныеДанные);
	
	Запрос.УстановитьПараметр("НачалоПериода", 		НачалоДня(ДатаНачала));
	Запрос.УстановитьПараметр("ОкончаниеПериода",	КонецДня(ДатаОкончания));
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

Функция ВыполнятьЗамеры()
	
	Если БезопасныйРежим() <> Ложь Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		МодульОценкаПроизводительностиВызовСервераПовтИсп = ОбщегоНазначения.ОбщийМодуль("ОценкаПроизводительностиВызовСервераПовтИсп");
		Если МодульОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции

#КонецОбласти

#КонецЕсли