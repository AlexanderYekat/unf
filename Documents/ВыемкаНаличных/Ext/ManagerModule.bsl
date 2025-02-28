﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
	|	И ЗначениеРазрешено(КассаККМ)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

Функция ПолучитьТекстЗапросаИнициализироватьДанные()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Валюта КАК Валюта,
	|	КурсыВалютСрезПоследних.Курс КАК Курс,
	|	КурсыВалютСрезПоследних.Кратность КАК Кратность
	|ПОМЕСТИТЬ ВременнаяТаблицаКурсыВалютСрезПоследних
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, Валюта В (&ВалютаУчета, &ВалютаДС)) КАК КурсыВалютСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	1 КАК НомерСтроки,
	|	ВыемкаНаличных.Дата КАК Дата,
	|	&Организация КАК Организация,
	|	ВыемкаНаличных.КассаККМ КАК КассаККМ,
	|	ВыемкаНаличных.ДоговорПлатежногоАгента КАК ДоговорПлатежногоАгента,
	|	ВыемкаНаличных.ВалютаДенежныхСредств КАК ВалютаДенежныхСредств,
	|	ВЫРАЗИТЬ(ВыемкаНаличных.СуммаДокумента * КурсыВалютКассы.Курс * КурсыВалютУчетаСрезПоследних.Кратность / (КурсыВалютУчетаСрезПоследних.Курс * КурсыВалютКассы.Кратность) КАК ЧИСЛО(15, 2)) КАК Сумма,
	|	ВыемкаНаличных.СуммаДокумента КАК СуммаВал,
	|	ВыемкаНаличных.КассаККМ.СчетУчета КАК КассаККМСчетУчета,
	|	ВыемкаНаличных.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВременнаяТаблицаШапка
	|ИЗ
	|	Документ.ВыемкаНаличных КАК ВыемкаНаличных
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаКурсыВалютСрезПоследних КАК КурсыВалютУчетаСрезПоследних
	|		ПО (КурсыВалютУчетаСрезПоследних.Валюта = &ВалютаУчета)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаКурсыВалютСрезПоследних КАК КурсыВалютКассы
	|		ПО (КурсыВалютКассы.Валюта = &ВалютаДС)
	|ГДЕ
	|	ВыемкаНаличных.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаВыемкаНаличных, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = ПолучитьТекстЗапросаИнициализироватьДанные();
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаВыемкаНаличных);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ПериодКонтроля", СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени.Дата);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.УстановитьПараметр("ВалютаУчета", Константы.ВалютаУчета.Получить());
	Запрос.УстановитьПараметр("ВалютаДС", ДокументСсылкаВыемкаНаличных.КассаККМ.ВалютаДенежныхСредств);
	
	Запрос.ВыполнитьПакет();
	
	// Формирование таблиц движений по разделам учета.
	СформироватьТаблицаДенежныеСредстваВКассахККМ(ДокументСсылкаВыемкаНаличных, СтруктураДополнительныеСвойства);
	СформироватьТаблицаДенежныеСредстваКПоступлению(ДокументСсылкаВыемкаНаличных, СтруктураДополнительныеСвойства);
	СформироватьТаблицаУправленческий(ДокументСсылкаВыемкаНаличных, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаДенежныеСредстваВКассахККМ(ДокументСсылкаВыемкаНаличных, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	
	"ВЫБРАТЬ
	|	1 КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаДокумента.Дата КАК Дата,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.КассаККМ КАК КассаККМ,
	|	ТаблицаДокумента.ВалютаДенежныхСредств КАК Валюта,
	|	ТаблицаДокумента.ДоговорПлатежногоАгента КАК ДоговорКонтрагента,
	|	СУММА(ТаблицаДокумента.Сумма) КАК Сумма,
	|	СУММА(ТаблицаДокумента.СуммаВал) КАК СуммаВал,
	|	СУММА(ТаблицаДокумента.Сумма) КАК СуммаДляОстатка,
	|	СУММА(ТаблицаДокумента.СуммаВал) КАК СуммаВалДляОстатка,
	|	ТаблицаДокумента.КассаККМСчетУчета КАК СчетУчета,
	|	&РасходДенежныхСредств КАК СодержаниеПроводки
	|ПОМЕСТИТЬ ВременнаяТаблицаДенежныеСредстваВКассахККМ
	|ИЗ
	|	ВременнаяТаблицаШапка КАК ТаблицаДокумента
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Дата,
	|	ТаблицаДокумента.Организация,
	|	ТаблицаДокумента.КассаККМ,
	|	ТаблицаДокумента.ВалютаДенежныхСредств,
	|	ТаблицаДокумента.КассаККМСчетУчета,
	|	ТаблицаДокумента.ДоговорПлатежногоАгента
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	КассаККМ,
	|	Валюта,
	|	СчетУчета";
	
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаВыемкаНаличных);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ПериодКонтроля", СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени.Дата);
	Запрос.УстановитьПараметр("РасходДенежныхСредств", СодержанияПроводок.РасходДенегИзКассыККМ());
	Запрос.УстановитьПараметр("КурсоваяРазница", СодержанияПроводок.КурсоваяРазница());
	
	Запрос.Выполнить();
	
	// Установка исключительной блокировки контролируемых остатков денежных средств.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВременнаяТаблицаДенежныеСредстваВКассахККМ.Организация КАК Организация,
	|	ВременнаяТаблицаДенежныеСредстваВКассахККМ.КассаККМ КАК КассаККМ
	|ИЗ
	|	ВременнаяТаблицаДенежныеСредстваВКассахККМ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ДенежныеСредстваВКассахККМ");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
	
	Для каждого КолонкаРезультатЗапроса Из РезультатЗапроса.Колонки Цикл
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных(КолонкаРезультатЗапроса.Имя, КолонкаРезультатЗапроса.Имя);
	КонецЦикла;
	Блокировка.Заблокировать();
	
	НомерЗапроса = 0;
	Запрос.Текст = КурсовыеРазницыУНФ.ПолучитьТекстЗапросаКурсовыеРазницыДенежныеСредстваВКассахККМ(Запрос.МенеджерВременныхТаблиц, НомерЗапроса);
	Запрос.УстановитьПараметр("ДвижениеЧекаВОткрытойСмене", Ложь);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДенежныеСредстваВКассахККМ", МассивРезультатов[НомерЗапроса].Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаДенежныеСредстваВКассахККМ()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаДенежныеСредстваКПоступлению(ДокументСсылкаВыемкаНаличных, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	
	"ВЫБРАТЬ
	|	1 КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаДокумента.Дата КАК Дата,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.КассыККМ.ПустаяСсылка) КАК Касса,
	|	&Ссылка КАК ДокументПередачи,
	|	ТаблицаДокумента.КассаККМ КАК КассаОтправитель,
	|	СУММА(ТаблицаДокумента.Сумма) КАК Сумма,
	|	СУММА(ТаблицаДокумента.СуммаВал) КАК СуммаВал,
	|	СУММА(ТаблицаДокумента.Сумма) КАК СуммаДляОстатка,
	|	СУММА(ТаблицаДокумента.СуммаВал) КАК СуммаВалДляОстатка,
	|	ТаблицаДокумента.ВалютаДенежныхСредств КАК Валюта,
	|	ТаблицаДокумента.ДоговорПлатежногоАгента КАК ДоговорКонтрагента,
	|	&Выемка КАК СодержаниеПроводки
	|ПОМЕСТИТЬ ВременнаяТаблицаДенежныеСредстваКПоступлению
	|ИЗ
	|	ВременнаяТаблицаШапка КАК ТаблицаДокумента
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Дата,
	|	ТаблицаДокумента.Организация,
	|	ТаблицаДокумента.КассаККМ,
	|	ТаблицаДокумента.ВалютаДенежныхСредств,
	|	ТаблицаДокумента.ДоговорПлатежногоАгента
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	КассаОтправитель,
	|	Валюта";
	
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаВыемкаНаличных);
	Запрос.УстановитьПараметр("СчетУчета", ПланыСчетов.Управленческий.ПереводыВПути);
	Запрос.УстановитьПараметр("Выемка", НСтр("ru = 'Выемка наличных'"));
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ПериодКонтроля", СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени.Дата);
	Запрос.УстановитьПараметр("КурсоваяРазница", НСтр("ru='Курсовая разница'"));
	
	Запрос.Выполнить();
	
	// Установка исключительной блокировки контролируемых остатков денежных средств к поступлению.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВременнаяТаблицаДенежныеСредстваКПоступлению.Организация КАК Организация,
	|	ВременнаяТаблицаДенежныеСредстваКПоступлению.Касса КАК Касса,
	|	ВременнаяТаблицаДенежныеСредстваКПоступлению.ДокументПередачи КАК ДокументПередачи
	|ИЗ
	|	ВременнаяТаблицаДенежныеСредстваКПоступлению";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ДенежныеСредстваКПоступлению");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
	
	Для каждого КолонкаРезультатЗапроса Из РезультатЗапроса.Колонки Цикл
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных(КолонкаРезультатЗапроса.Имя, КолонкаРезультатЗапроса.Имя);
	КонецЦикла;
	Блокировка.Заблокировать();
	
	НомерЗапроса = 0;
	Запрос.Текст = КурсовыеРазницыУНФ.ПолучитьТекстЗапросаКурсовыеРазницыДенежныеСредстваКПоступлению(Запрос.МенеджерВременныхТаблиц, НомерЗапроса);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДенежныеСредстваКПоступлению", МассивРезультатов[НомерЗапроса].Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаДенежныеСредстваКПоступлению()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаУправленческий(ДокументСсылкаВыемкаНаличных, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаВыемкаНаличных);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("КурсоваяРазница", НСтр("ru='Курсовая разница'"));
	Запрос.УстановитьПараметр("СодержаниеВыемкаНаличных", НСтр("ru = 'Выемка наличных'"));
	Запрос.УстановитьПараметр("ВалютаУчета", СтруктураДополнительныеСвойства.ВалютаУчета);
		
	Запрос.Текст =
	"ВЫБРАТЬ
	|	1 КАК Порядок,
	|	1 КАК НомерСтроки,
	|	ТаблицаДокумента.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический) КАК СценарийПланирования,
	|	ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПереводыВПути) КАК СчетДт,
	|	ТаблицаДокумента.КассаККМСчетУчета КАК СчетКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.КассаККМСчетУчета.Валютный
	|			ТОГДА ТаблицаДокумента.ВалютаДенежныхСредств
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ВалютаКт,
	|	0 КАК СуммаВалДт,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.КассаККМСчетУчета.Валютный
	|			ТОГДА ТаблицаДокумента.СуммаВал
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаВалКт,
	|	ТаблицаДокумента.Сумма КАК Сумма,
	|	ВЫРАЗИТЬ(&СодержаниеВыемкаНаличных КАК СТРОКА(100)) КАК Содержание
	|ИЗ
	|	ВременнаяТаблицаШапка КАК ТаблицаДокумента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2,
	|	ТаблицаДокумента.НомерСтроки,
	|	ТаблицаДокумента.Дата,
	|	ТаблицаДокумента.Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический),
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|			ТОГДА ТаблицаДокумента.СчетУчета
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПрочиеРасходы)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПрочиеДоходы)
	|		ИНАЧЕ ТаблицаДокумента.СчетУчета
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|				И ТаблицаДокумента.СчетУчета.Валютный
	|			ТОГДА ТаблицаДокумента.Валюта
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы < 0
	|				И ТаблицаДокумента.СчетУчета.Валютный
	|			ТОГДА ТаблицаДокумента.Валюта
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	0,
	|	0,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|			ТОГДА ТаблицаДокумента.СуммаКурсовойРазницы
	|		ИНАЧЕ -ТаблицаДокумента.СуммаКурсовойРазницы
	|	КОНЕЦ,
	|	&КурсоваяРазница
	|ИЗ
	|	ВременнаяТаблицаКурсовыхРазницДенежныеСредстваВКассахККМ КАК ТаблицаДокумента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	3,
	|	ТаблицаДокумента.НомерСтроки,
	|	ТаблицаДокумента.Дата,
	|	ТаблицаДокумента.Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический),
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|			ТОГДА ТаблицаДокумента.СчетУчета
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПрочиеРасходы)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПрочиеДоходы)
	|		ИНАЧЕ ТаблицаДокумента.СчетУчета
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|				И ТаблицаДокумента.СчетУчета.Валютный
	|			ТОГДА ТаблицаДокумента.Валюта
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы < 0
	|				И ТаблицаДокумента.СчетУчета.Валютный
	|			ТОГДА ТаблицаДокумента.Валюта
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	0,
	|	0,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.СуммаКурсовойРазницы > 0
	|			ТОГДА ТаблицаДокумента.СуммаКурсовойРазницы
	|		ИНАЧЕ -ТаблицаДокумента.СуммаКурсовойРазницы
	|	КОНЕЦ,
	|	&КурсоваяРазница
	|ИЗ
	|	ВременнаяТаблицаКурсовыхРазницДенежныеСредстваКПоступлению КАК ТаблицаДокумента";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаУправленческий", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаУправленческий()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылкаВыемкаНаличных, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если НЕ Константы.КонтролироватьОстаткиПриПроведении.Получить() Тогда
		Возврат;
	КонецЕсли;
	
	// МобильноеПриложение
	Если МобильноеПриложениеВызовСервера.НужноОграничитьФункциональность() Тогда
		Возврат;
	КонецЕсли;
	// Конец МобильноеПриложение
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Если временные таблицы содержат записи, необходимо выполнить контроль
	// отрицательных остатков.
	Если СтруктураВременныеТаблицы.ДвиженияДенежныеСредстваКПоступлениюИзменение
	 ИЛИ СтруктураВременныеТаблицы.ДвиженияДенежныеСредстваВКассахККМИзменение Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.Организация КАК ОрганизацияПредставление,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.Касса КАК КассаПредставление,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.ДокументПередачи КАК ДокументПередачиПредставление,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.ДокументПередачи.ВалютаДенежныхСредств КАК ВалютаПредставление,
		|	ЕСТЬNULL(ДенежныеСредстваКПоступлениюОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
		|	ЕСТЬNULL(ДенежныеСредстваКПоступлениюОстатки.СуммаВалОстаток, 0) КАК СуммаВалОстаток,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаВалИзменение + ЕСТЬNULL(ДенежныеСредстваКПоступлениюОстатки.СуммаВалОстаток, 0) КАК ОстатокДенежныхСредств,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаПередЗаписью КАК СуммаПередЗаписью,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаПриЗаписи КАК СуммаПриЗаписи,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаИзменение КАК СуммаИзменение,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаВалПередЗаписью КАК СуммаВалПередЗаписью,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаВалПриЗаписи КАК СуммаВалПриЗаписи,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаВалИзменение КАК СуммаВалИзменение
		|ИЗ
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение КАК ДвиженияДенежныеСредстваКПоступлениюИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДенежныеСредстваКПоступлению.Остатки(&МоментКонтроля, ) КАК ДенежныеСредстваКПоступлениюОстатки
		|		ПО ДвиженияДенежныеСредстваКПоступлениюИзменение.Организация = ДенежныеСредстваКПоступлениюОстатки.Организация
		|			И ДвиженияДенежныеСредстваКПоступлениюИзменение.Касса = ДенежныеСредстваКПоступлениюОстатки.Касса
		|			И ДвиженияДенежныеСредстваКПоступлениюИзменение.ДоговорКонтрагента = ДенежныеСредстваКПоступлениюОстатки.ДоговорКонтрагента
		|ГДЕ
		|	ЕСТЬNULL(ДенежныеСредстваКПоступлениюОстатки.СуммаВалОстаток, 0) < 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияДенежныеСредстваВКассахККМИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияДенежныеСредстваВКассахККМИзменение.Организация КАК ОрганизацияПредставление,
		|	ДвиженияДенежныеСредстваВКассахККМИзменение.КассаККМ КАК КассаККМПредставление,
		|	ДвиженияДенежныеСредстваВКассахККМИзменение.КассаККМ.ВалютаДенежныхСредств КАК ВалютаПредставление,
		|	ЕСТЬNULL(ДенежныеСредстваВКассахККМОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
		|	ЕСТЬNULL(ДенежныеСредстваВКассахККМОстатки.СуммаВалОстаток, 0) КАК СуммаВалОстаток,
		|	ДвиженияДенежныеСредстваВКассахККМИзменение.СуммаВалИзменение + ЕСТЬNULL(ДенежныеСредстваВКассахККМОстатки.СуммаВалОстаток, 0) КАК ОстатокДенежныхСредств,
		|	ДвиженияДенежныеСредстваВКассахККМИзменение.СуммаПередЗаписью КАК СуммаПередЗаписью,
		|	ДвиженияДенежныеСредстваВКассахККМИзменение.СуммаПриЗаписи КАК СуммаПриЗаписи,
		|	ДвиженияДенежныеСредстваВКассахККМИзменение.СуммаИзменение КАК СуммаИзменение,
		|	ДвиженияДенежныеСредстваВКассахККМИзменение.СуммаВалПередЗаписью КАК СуммаВалПередЗаписью,
		|	ДвиженияДенежныеСредстваВКассахККМИзменение.СуммаВалПриЗаписи КАК СуммаВалПриЗаписи,
		|	ДвиженияДенежныеСредстваВКассахККМИзменение.СуммаВалИзменение КАК СуммаВалИзменение
		|ИЗ
		|	ДвиженияДенежныеСредстваВКассахККМИзменение КАК ДвиженияДенежныеСредстваВКассахККМИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДенежныеСредстваВКассахККМ.Остатки(&МоментКонтроля, ) КАК ДенежныеСредстваВКассахККМОстатки
		|		ПО ДвиженияДенежныеСредстваВКассахККМИзменение.Организация = ДенежныеСредстваВКассахККМОстатки.Организация
		|			И ДвиженияДенежныеСредстваВКассахККМИзменение.КассаККМ = ДенежныеСредстваВКассахККМОстатки.КассаККМ
		|			И ДвиженияДенежныеСредстваВКассахККМИзменение.ДоговорКонтрагента = ДенежныеСредстваВКассахККМОстатки.ДоговорКонтрагента
		|ГДЕ
		|	ЕСТЬNULL(ДенежныеСредстваВКассахККМОстатки.СуммаВалОстаток, 0) < 0
		|	И ДенежныеСредстваВКассахККМОстатки.КассаККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ФискальныйРегистратор)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		Если НЕ МассивРезультатов[0].Пустой()
			ИЛИ НЕ МассивРезультатов[1].Пустой() Тогда
			ДокументОбъектВыемкаНаличных = ДокументСсылкаВыемкаНаличных.ПолучитьОбъект()
		КонецЕсли;
		
		// Отрицательный остаток по денежным средствам к поступлению.
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			КонтрольОстатковУНФ.ДенежныеСредстваКПоступлению(ДокументОбъектВыемкаНаличных, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток по кассе ККМ.
		Если НЕ МассивРезультатов[1].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
			КонтрольОстатковУНФ.ДенежныеСредстваВКассахККМ(ДокументОбъектВыемкаНаличных, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКонтроль()

#КонецЕсли
