﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Контрагент)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область РасчетыПоПрочимОперациям

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаРасчетыСПрочимиКонтрагентами(ДокументСсылкаПрочиеРасходы, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("УчетРасчетовПоПрочимОперациям", НСтр("ru='Учет расчетов по прочим операциям'"));
	Запрос.УстановитьПараметр("КомментарийПриход", НСтр("ru='Увеличение долга контрагента'"));
	Запрос.УстановитьПараметр("КомментарийРасход", НСтр("ru='Уменьшение долга контрагента'"));
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаПрочиеРасходы);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ПериодКонтроля", СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени.Дата);
	Запрос.УстановитьПараметр("КурсоваяРазница", НСтр("ru='Курсовая разница'"));
	
	Запрос.УстановитьПараметр("ВалютаУчета", Константы.ВалютаУчета.Получить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПрочиеРасходыРасходы.НомерСтроки КАК НомерСтроки,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ПрочиеРасходыРасходы.Контрагент КАК Контрагент,
	|	ПрочиеРасходыРасходы.Договор КАК Договор,
	|	ПрочиеРасходыРасходы.Договор.ВалютаРасчетов КАК Валюта,
	|	ВЫБОР
	|		КОГДА ПрочиеРасходыРасходы.Контрагент.ВестиРасчетыПоЗаказам
	|			ТОГДА ПрочиеРасходыРасходы.ЗаказПокупателя
	|		ИНАЧЕ ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|	КОНЕЦ КАК Заказ,
	|	ПрочиеРасходыРасходы.Ссылка.Дата КАК Период,
	|	СУММА(ПрочиеРасходыРасходы.Сумма) КАК Сумма,
	|	&УчетРасчетовПоПрочимОперациям КАК СодержаниеПроводки,
	|	&КомментарийПриход КАК Комментарий,
	|	ПрочиеРасходыРасходы.СчетЗатрат КАК СчетУчета,
	|	ВЫРАЗИТЬ(ПрочиеРасходыРасходы.Сумма * КурсыВалютРасчетов.Кратность * КурсыВалютУчета.Курс / (КурсыВалютРасчетов.Курс * КурсыВалютУчета.Кратность) КАК ЧИСЛО(15, 2)) КАК СуммаВал
	|ИЗ
	|	Документ.ПрочиеРасходы.Расходы КАК ПрочиеРасходыРасходы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, ) КАК КурсыВалютРасчетов
	|		ПО ПрочиеРасходыРасходы.Договор.ВалютаРасчетов = КурсыВалютРасчетов.Валюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, Валюта = &ВалютаУчета) КАК КурсыВалютУчета
	|		ПО (КурсыВалютУчета.Валюта = &ВалютаУчета)
	|ГДЕ
	|	ПрочиеРасходыРасходы.Ссылка = &Ссылка
	|	И ПрочиеРасходыРасходы.Ссылка.УчетПрочихРасчетов
	|	И ПрочиеРасходыРасходы.Контрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	И (ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Дебиторы)
	|			ИЛИ ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Кредиторы))
	|
	|СГРУППИРОВАТЬ ПО
	|	ПрочиеРасходыРасходы.НомерСтроки,
	|	ПрочиеРасходыРасходы.Контрагент,
	|	ПрочиеРасходыРасходы.Договор,
	|	ПрочиеРасходыРасходы.Договор.ВалютаРасчетов,
	|	ПрочиеРасходыРасходы.Ссылка.Дата,
	|	ВЫБОР
	|		КОГДА ПрочиеРасходыРасходы.Контрагент.ВестиРасчетыПоЗаказам
	|			ТОГДА ПрочиеРасходыРасходы.ЗаказПокупателя
	|		ИНАЧЕ ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|	КОНЕЦ,
	|	ПрочиеРасходыРасходы.СчетЗатрат,
	|	ВЫРАЗИТЬ(ПрочиеРасходыРасходы.Сумма * КурсыВалютРасчетов.Кратность * КурсыВалютУчета.Курс / (КурсыВалютРасчетов.Курс * КурсыВалютУчета.Кратность) КАК ЧИСЛО(15, 2))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПрочиеРасходыРасходы.НомерСтроки,
	|	&Организация,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|	ПрочиеРасходы.Контрагент,
	|	ПрочиеРасходы.Договор,
	|	ПрочиеРасходы.Договор.ВалютаРасчетов,
	|	НЕОПРЕДЕЛЕНО,
	|	ПрочиеРасходы.Дата,
	|	СУММА(ПрочиеРасходыРасходы.Сумма),
	|	&УчетРасчетовПоПрочимОперациям,
	|	&КомментарийРасход,
	|	ПрочиеРасходы.Корреспонденция,
	|	ВЫРАЗИТЬ(ПрочиеРасходыРасходы.Сумма * КурсыВалютРасчетов.Кратность * КурсыВалютУчета.Курс / (КурсыВалютРасчетов.Курс * КурсыВалютУчета.Кратность) КАК ЧИСЛО(15, 2))
	|ИЗ
	|	Документ.ПрочиеРасходы.Расходы КАК ПрочиеРасходыРасходы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, Валюта = &ВалютаУчета) КАК КурсыВалютУчета
	|		ПО (КурсыВалютУчета.Валюта = &ВалютаУчета)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПрочиеРасходы КАК ПрочиеРасходы
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, ) КАК КурсыВалютРасчетов
	|			ПО ПрочиеРасходы.Договор.ВалютаРасчетов = КурсыВалютРасчетов.Валюта
	|		ПО ПрочиеРасходыРасходы.Ссылка = ПрочиеРасходы.Ссылка
	|ГДЕ
	|	ПрочиеРасходыРасходы.Ссылка = &Ссылка
	|	И ПрочиеРасходы.Ссылка = &Ссылка
	|	И ПрочиеРасходыРасходы.Ссылка.УчетПрочихРасчетов
	|	И ПрочиеРасходы.Контрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	И (ПрочиеРасходы.Корреспонденция.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Дебиторы)
	|			ИЛИ ПрочиеРасходы.Корреспонденция.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Кредиторы))
	|
	|СГРУППИРОВАТЬ ПО
	|	ПрочиеРасходыРасходы.НомерСтроки,
	|	ПрочиеРасходы.Контрагент,
	|	ПрочиеРасходы.Договор,
	|	ПрочиеРасходы.Договор.ВалютаРасчетов,
	|	ПрочиеРасходы.Дата,
	|	ПрочиеРасходы.Корреспонденция,
	|	ВЫРАЗИТЬ(ПрочиеРасходыРасходы.Сумма * КурсыВалютРасчетов.Кратность * КурсыВалютУчета.Курс / (КурсыВалютРасчетов.Курс * КурсыВалютУчета.Кратность) КАК ЧИСЛО(15, 2))";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРасчетыСПрочимиКонтрагентами", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаРасчетыСПокупателями()

#КонецОбласти

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаПрочиеРасходы, СтруктураДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПрочиеРасходыРасходы.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ПрочиеРасходыРасходы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ПрочиеРасходыРасходы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ПрочиеРасходыРасходы.СчетЗатрат КАК СчетУчета,
	|	ПрочиеРасходыРасходы.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ПрочиеРасходыРасходы.Сумма КАК Сумма,
	|	ПрочиеРасходыРасходы.Сумма КАК СуммаБезНДС,
	|	ИСТИНА КАК ФиксированнаяСтоимость,
	|	&ПрочиеРасходы КАК СодержаниеПроводки
	|ИЗ
	|	Документ.ПрочиеРасходы.Расходы КАК ПрочиеРасходыРасходы
	|ГДЕ
	|	ПрочиеРасходыРасходы.Ссылка = &Ссылка
	|	И (ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.НезавершенноеПроизводство)
	|			ИЛИ ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.КосвенныеЗатраты))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПрочиеРасходыРасходы.НомерСтроки КАК НомерСтроки,
	|	ПрочиеРасходыРасходы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеРасходы)
	|				ИЛИ ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПроцентыПоКредитам)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.Прочее)
	|		ИНАЧЕ ПрочиеРасходыРасходы.НаправлениеДеятельности
	|	КОНЕЦ КАК НаправлениеДеятельности,
	|	ВЫБОР
	|		КОГДА ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеРасходы)
	|				ИЛИ ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПроцентыПоКредитам)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	|		ИНАЧЕ ПрочиеРасходыРасходы.Ссылка.СтруктурнаяЕдиница
	|	КОНЕЦ КАК СтруктурнаяЕдиница,
	|	ВЫБОР
	|		КОГДА ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеРасходы)
	|				ИЛИ ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПроцентыПоКредитам)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.Проекты.ПустаяСсылка)
	|		ИНАЧЕ ПрочиеРасходыРасходы.Ссылка.Проект
	|	КОНЕЦ КАК Проект,
	|	ПрочиеРасходыРасходы.СчетЗатрат КАК СчетУчета,
	|	ВЫБОР
	|		КОГДА ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеРасходы)
	|				ИЛИ ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПроцентыПоКредитам)
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ПрочиеРасходыРасходы.ЗаказПокупателя
	|	КОНЕЦ КАК ЗаказПокупателя,
	|	0 КАК СуммаДоходов,
	|	ПрочиеРасходыРасходы.Сумма КАК СуммаРасходов,
	|	ПрочиеРасходыРасходы.Сумма КАК Сумма,
	|	&ПрочиеРасходы КАК СодержаниеПроводки,
	|	ПрочиеРасходыРасходы.АналитикаПрочихДоходовИРасходов КАК Аналитика
	|ИЗ
	|	Документ.ПрочиеРасходы.Расходы КАК ПрочиеРасходыРасходы
	|ГДЕ
	|	ПрочиеРасходыРасходы.Ссылка = &Ссылка
	|	И (ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Расходы)
	|			ИЛИ ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеРасходы)
	|			ИЛИ ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПроцентыПоКредитам))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПрочиеРасходыРасходы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.Прочее) КАК НаправлениеДеятельности,
	|	СУММА(ПрочиеРасходыРасходы.Сумма) КАК СуммаДоходов,
	|	СУММА(ПрочиеРасходыРасходы.Сумма) КАК Сумма,
	|	ПрочиеРасходыРасходы.Ссылка.Корреспонденция КАК СчетУчета,
	|	&ПоступлениеДоходов КАК СодержаниеПроводки,
	|	ПрочиеРасходыРасходы.Ссылка.АналитикаПрочихДоходовИРасходов КАК Аналитика
	|ИЗ
	|	Документ.ПрочиеРасходы.Расходы КАК ПрочиеРасходыРасходы
	|ГДЕ
	|	ПрочиеРасходыРасходы.Ссылка = &Ссылка
	|	И ПрочиеРасходыРасходы.Ссылка.Корреспонденция.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеДоходы)
	|	И ПрочиеРасходыРасходы.Сумма > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ПрочиеРасходыРасходы.Ссылка,
	|	ПрочиеРасходыРасходы.Ссылка.Дата,
	|	ПрочиеРасходыРасходы.Ссылка.Корреспонденция,
	|	ПрочиеРасходыРасходы.Ссылка.АналитикаПрочихДоходовИРасходов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПрочиеРасходыРасходы.НомерСтроки КАК НомерСтроки,
	|	ПрочиеРасходыРасходы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический) КАК СценарийПланирования,
	|	ПрочиеРасходыРасходы.СчетЗатрат КАК СчетДт,
	|	ВЫБОР
	|		КОГДА ПрочиеРасходыРасходы.СчетЗатрат.Валютный
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ВалютаДт,
	|	ВЫБОР
	|		КОГДА ПрочиеРасходыРасходы.СчетЗатрат.Валютный
	|			ТОГДА 0
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаВалДт,
	|	ПрочиеРасходыРасходы.Ссылка.Корреспонденция КАК СчетКт,
	|	ВЫБОР
	|		КОГДА ПрочиеРасходыРасходы.Ссылка.Корреспонденция.Валютный
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ВалютаКт,
	|	ВЫБОР
	|		КОГДА ПрочиеРасходыРасходы.Ссылка.Корреспонденция.Валютный
	|			ТОГДА 0
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаВалКт,
	|	ПрочиеРасходыРасходы.Сумма КАК Сумма,
	|	&ПрочееОприходование КАК Содержание
	|ИЗ
	|	Документ.ПрочиеРасходы.Расходы КАК ПрочиеРасходыРасходы
	|ГДЕ
	|	ПрочиеРасходыРасходы.Ссылка = &Ссылка
	|	И ПрочиеРасходыРасходы.Сумма > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	1 КАК НомерСтроки,
	|	ПрочиеРасходыРасходы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.Прочее) КАК НаправлениеДеятельности,
	|	ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка) КАК СтруктурнаяЕдиница,
	|	ПрочиеРасходыРасходы.Ссылка.Корреспонденция КАК СчетУчета,
	|	НЕОПРЕДЕЛЕНО КАК ЗаказПокупателя,
	|	0 КАК СуммаДоходов,
	|	СУММА(ПрочиеРасходыРасходы.Сумма) КАК СуммаРасходов,
	|	СУММА(ПрочиеРасходыРасходы.Сумма) КАК Сумма,
	|	&ПрочиеРасходы КАК СодержаниеПроводки,
	|	ПрочиеРасходыРасходы.Ссылка.АналитикаПрочихДоходовИРасходов КАК Аналитика
	|ИЗ
	|	Документ.ПрочиеРасходы.Расходы КАК ПрочиеРасходыРасходы
	|ГДЕ
	|	ПрочиеРасходыРасходы.Ссылка = &Ссылка
	|	И (ПрочиеРасходыРасходы.Ссылка.Корреспонденция.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Кредиторы)
	|			ИЛИ ПрочиеРасходыРасходы.Ссылка.Корреспонденция.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Дебиторы))
	|	И ПрочиеРасходыРасходы.Ссылка.УчетПрочихРасчетов
	|	И ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета <> ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Расходы)
	|	И ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета <> ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеРасходы)
	|	И ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета <> ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПроцентыПоКредитам)
	|	И ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета <> ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.НераспределеннаяПрибыль)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПрочиеРасходыРасходы.Ссылка.Дата,
	|	ПрочиеРасходыРасходы.Ссылка.Корреспонденция,
	|	ПрочиеРасходыРасходы.Ссылка.АналитикаПрочихДоходовИРасходов
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПрочиеРасходыРасходы.НомерСтроки,
	|	ПрочиеРасходыРасходы.Ссылка.Дата,
	|	&Организация,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.Прочее),
	|	ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка),
	|	ПрочиеРасходыРасходы.Ссылка.Корреспонденция,
	|	НЕОПРЕДЕЛЕНО,
	|	ПрочиеРасходыРасходы.Сумма,
	|	0,
	|	ПрочиеРасходыРасходы.Сумма,
	|	&ПоступлениеДоходов,
	|	ПрочиеРасходыРасходы.АналитикаПрочихДоходовИРасходов
	|ИЗ
	|	Документ.ПрочиеРасходы.Расходы КАК ПрочиеРасходыРасходы
	|ГДЕ
	|	ПрочиеРасходыРасходы.Ссылка = &Ссылка
	|	И ПрочиеРасходыРасходы.Ссылка.Корреспонденция.ТипСчета <> ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Капитал)
	|	И ПрочиеРасходыРасходы.Ссылка.Корреспонденция.ТипСчета <> ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеОборотныеАктивы)
	|			И (ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Кредиторы)
	|				ИЛИ ПрочиеРасходыРасходы.СчетЗатрат.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Дебиторы))
	|	И ПрочиеРасходыРасходы.Ссылка.УчетПрочихРасчетов
	|	И (ПрочиеРасходыРасходы.Ссылка.Корреспонденция.ТипСчета <> ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.ПрочиеДоходы)
	|			ИЛИ ПрочиеРасходыРасходы.Сумма < 0)");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаПрочиеРасходы);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.УстановитьПараметр("ПрочиеРасходы", НСтр("ru = 'Отражение затрат'"));
	Запрос.УстановитьПараметр("ПоступлениеДоходов", НСтр("ru = 'Прочие доходы'"));
	Запрос.УстановитьПараметр("ПрочееОприходование", НСтр("ru = 'Прочих затраты (расходы)'"));
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасы", МассивРезультатов[0].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДоходыИРасходы", МассивРезультатов[1].Выгрузить());
	
	Если СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыИРасходы.Количество() = 0 Тогда
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДоходыИРасходы", МассивРезультатов[2].Выгрузить());
	Иначе
		
		Выборка = МассивРезультатов[2].Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыИРасходы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			
		КонецЦикла;
		
	КонецЕсли;
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаУправленческий", МассивРезультатов[3].Выгрузить());
	
	// Прочие расчеты
	Если СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыИРасходы.Количество() = 0 Тогда
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДоходыИРасходы", МассивРезультатов[4].Выгрузить());
	Иначе
		
		Выборка = МассивРезультатов[4].Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДоходыИРасходы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			
		КонецЦикла;
		
	КонецЕсли;
	
	СформироватьТаблицаРасчетыСПрочимиКонтрагентами(ДокументСсылкаПрочиеРасходы, СтруктураДополнительныеСвойства);
	// Конец Прочие расчеты
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
