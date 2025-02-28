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

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//   Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Ограничивает видимость реквизитов объекта в отчете по версии.
//
// Параметры:
//   Реквизиты - Массив - список имен реквизитов объекта.
Процедура ПриПолученииСлужебныхРеквизитов(Реквизиты) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если ПроведениеДокументовУНФ.КонтрольОстатковВыключен() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Если СтруктураВременныеТаблицы.ДвиженияЗапасыПереданныеИзменение Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗапасыПереданныеИзменение.НомерСтроки КАК НомерСтроки,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыПереданныеИзменение.Организация) КАК ОрганизацияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыПереданныеИзменение.Номенклатура) КАК НоменклатураПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыПереданныеИзменение.Характеристика) КАК ХарактеристикаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыПереданныеИзменение.Партия) КАК ПартияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыПереданныеИзменение.Контрагент) КАК КонтрагентПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыПереданныеИзменение.Договор) КАК ДоговорПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыПереданныеИзменение.Заказ) КАК ЗаказПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыПереданныеИзменение.ТипПриемаПередачи) КАК ТипПриемаПередачиПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЗапасыПереданныеОстатки.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
		|	ЕСТЬNULL(ДвиженияЗапасыПереданныеИзменение.КоличествоИзменение, 0) + ЕСТЬNULL(ЗапасыПереданныеОстатки.КоличествоОстаток, 0) КАК ОстатокЗапасыПереданные,
		|	ЕСТЬNULL(ЗапасыПереданныеОстатки.КоличествоОстаток, 0) КАК КоличествоОстатокЗапасыПереданные,
		|	ЕСТЬNULL(ДвиженияЗапасыПереданныеИзменение.СуммаРасчетовИзменение, 0) + ЕСТЬNULL(ЗапасыПереданныеОстатки.СуммаРасчетовОстаток, 0) КАК СуммаРасчетовЗапасыПереданные,
		|	ЕСТЬNULL(ЗапасыПереданныеОстатки.СуммаРасчетовОстаток, 0) КАК СуммаРасчетовОстатокЗапасыПереданные,
		|	ДвиженияЗапасыПереданныеИзменение.КоличествоИзменение КАК КоличествоИзменение,
		|	ДвиженияЗапасыПереданныеИзменение.СуммаРасчетовИзменение КАК СуммаРасчетовИзменение
		|ИЗ
		|	ДвиженияЗапасыПереданныеИзменение КАК ДвиженияЗапасыПереданныеИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыПереданные.Остатки(
		|				&МоментКонтроля,
		|				(Организация, Номенклатура, Характеристика, Партия, Контрагент, Договор, Заказ, ТипПриемаПередачи) В
		|					(ВЫБРАТЬ
		|						ДвиженияЗапасыПереданныеИзменение.Организация КАК Организация,
		|						ДвиженияЗапасыПереданныеИзменение.Номенклатура КАК Номенклатура,
		|						ДвиженияЗапасыПереданныеИзменение.Характеристика КАК Характеристика,
		|						ДвиженияЗапасыПереданныеИзменение.Партия КАК Партия,
		|						ДвиженияЗапасыПереданныеИзменение.Контрагент КАК Контрагент,
		|						ДвиженияЗапасыПереданныеИзменение.Договор КАК Договор,
		|						ДвиженияЗапасыПереданныеИзменение.Заказ КАК Заказ,
		|						ДвиженияЗапасыПереданныеИзменение.ТипПриемаПередачи КАК ТипПриемаПередачи
		|					ИЗ
		|						ДвиженияЗапасыПереданныеИзменение КАК ДвиженияЗапасыПереданныеИзменение)) КАК ЗапасыПереданныеОстатки
		|		ПО ДвиженияЗапасыПереданныеИзменение.Организация = ЗапасыПереданныеОстатки.Организация
		|			И ДвиженияЗапасыПереданныеИзменение.Номенклатура = ЗапасыПереданныеОстатки.Номенклатура
		|			И ДвиженияЗапасыПереданныеИзменение.Характеристика = ЗапасыПереданныеОстатки.Характеристика
		|			И ДвиженияЗапасыПереданныеИзменение.Партия = ЗапасыПереданныеОстатки.Партия
		|			И ДвиженияЗапасыПереданныеИзменение.Контрагент = ЗапасыПереданныеОстатки.Контрагент
		|			И ДвиженияЗапасыПереданныеИзменение.Договор = ЗапасыПереданныеОстатки.Договор
		|			И ДвиженияЗапасыПереданныеИзменение.Заказ = ЗапасыПереданныеОстатки.Заказ
		|			И ДвиженияЗапасыПереданныеИзменение.ТипПриемаПередачи = ЗапасыПереданныеОстатки.ТипПриемаПередачи
		|ГДЕ
		|	(ЕСТЬNULL(ЗапасыПереданныеОстатки.КоличествоОстаток, 0) < 0
		|			ИЛИ ЕСТЬNULL(ЗапасыПереданныеОстатки.СуммаРасчетовОстаток, 0) < 0)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Количество()
			Тогда
			ДокументОбъектОтчетКомиссионера = ДокументСсылка.ПолучитьОбъект();
				// Отрицательный остаток запасов переданных.
			КонтрольОстатковУНФ.ЗапасыПереданные(ДокументОбъектОтчетКомиссионера, Выборка, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКонтроль()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства, Контроль = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПереоценкаТоваровНаКомиссииЗапасы.НомерСтроки КАК НомерСтроки,
	|	ПереоценкаТоваровНаКомиссииЗапасы.Ссылка КАК Документ,
	|	ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.Контрагент КАК Контрагент,
	|	ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.Договор.ВалютаРасчетов КАК ВалютаРасчетов,
	|	ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.Договор КАК Договор,
	|	ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.Контрагент КАК СтруктурнаяЕдиница,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыПриемаПередачиТоваров.ПередачаКомиссионеру) КАК ТипПриемаПередачи,
	|	ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.Подразделение КАК ПодразделениеПродажи,
	|	ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.Ответственный КАК Ответственный,
	|	ПереоценкаТоваровНаКомиссииЗапасы.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &ИспользоватьХарактеристики
	|			ТОГДА ПереоценкаТоваровНаКомиссииЗапасы.Характеристика
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Характеристика,
	|	ВЫБОР
	|		КОГДА &ИспользоватьПартии
	|			ТОГДА ПереоценкаТоваровНаКомиссииЗапасы.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Партия,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ПереоценкаТоваровНаКомиссииЗапасы.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
	|			ТОГДА ПереоценкаТоваровНаКомиссииЗапасы.Количество
	|		ИНАЧЕ ПереоценкаТоваровНаКомиссииЗапасы.Количество * ПереоценкаТоваровНаКомиссииЗапасы.ЕдиницаИзмерения.Коэффициент
	|	КОНЕЦ КАК Количество,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.ВалютаДокумента = КонстантаНациональнаяВалюта.Значение
	|				ТОГДА ПереоценкаТоваровНаКомиссииЗапасы.Сумма * КурсыРегВалюты.Курс * КурсыУпрВалюты.Кратность / (КурсыУпрВалюты.Курс * КурсыРегВалюты.Кратность)
	|			ИНАЧЕ ПереоценкаТоваровНаКомиссииЗапасы.Сумма * ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.Курс * КурсыУпрВалюты.Кратность / (КурсыУпрВалюты.Курс * ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.Кратность)
	|		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК Сумма,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.ВалютаДокумента = КонстантаНациональнаяВалюта.Значение
	|				ТОГДА ПереоценкаТоваровНаКомиссииЗапасы.Сумма * КурсыРегВалюты.Курс * ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.Кратность / (ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.Курс * КурсыРегВалюты.Кратность)
	|			ИНАЧЕ ПереоценкаТоваровНаКомиссииЗапасы.Сумма
	|		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК СуммаВал,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.ВалютаДокумента = КонстантаНациональнаяВалюта.Значение
	|				ТОГДА ПереоценкаТоваровНаКомиссииЗапасы.Сумма
	|			ИНАЧЕ ПереоценкаТоваровНаКомиссииЗапасы.Сумма * ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.Курс / ПереоценкаТоваровНаКомиссииЗапасы.Ссылка.Кратность
	|		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК СуммаРег,
	|	ПереоценкаТоваровНаКомиссииЗапасы.Заказ КАК ЗаказПокупателя,
	|	ПереоценкаТоваровНаКомиссииЗапасы.СуммаСтарая КАК СуммаРасчетовРасход,
	|	ПереоценкаТоваровНаКомиссииЗапасы.Сумма КАК СуммаРасчетовПриход
	|ПОМЕСТИТЬ ВременнаяТаблицаЗапасы
	|ИЗ
	|	Константа.НациональнаяВалюта КАК КонстантаНациональнаяВалюта,
	|	Документ.ПереоценкаТоваровНаКомиссии.Запасы КАК ПереоценкаТоваровНаКомиссииЗапасы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(
	|				&МоментВремени,
	|				Валюта В
	|					(ВЫБРАТЬ
	|						КонстантаНациональнаяВалюта.Значение
	|					ИЗ
	|						Константа.НациональнаяВалюта КАК КонстантаНациональнаяВалюта)) КАК КурсыРегВалюты
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(
	|				&МоментВремени,
	|				Валюта В
	|					(ВЫБРАТЬ
	|						КонстантаВалютаУчета.Значение
	|					ИЗ
	|						Константа.ВалютаУчета КАК КонстантаВалютаУчета)) КАК КурсыУпрВалюты
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ПереоценкаТоваровНаКомиссииЗапасы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ИспользоватьХарактеристики", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьХарактеристики);
	Запрос.УстановитьПараметр("ИспользоватьПартии", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьПартии);
	
	Запрос.ВыполнитьПакет();
	
	// Формирование проводок документа.
	ПроведениеДокументовУНФ.СформироватьТаблицуПроводок(ДокументСсылка, СтруктураДополнительныеСвойства);
	
	СформироватьТаблицаЗапасыПереданные(ДокументСсылка, СтруктураДополнительныеСвойства);

	
КонецПроцедуры // ИнициализироватьДанныеДокумента() 

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Документы.ПереоценкаТоваровНаКомиссии.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульСозданиеНаОсновании = ОбщегоНазначения.ОбщийМодуль("СозданиеНаОсновании");
		КомандаСозданияНаОсновании = МодульСозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы.ПереоценкаТоваровНаКомиссии);
		Возврат КомандаСозданияНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныйИнтерфейс

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаЗапасыПереданные(ДокументСсылкаОтчетКомиссионера, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МИНИМУМ(ТаблицаЗапасыПереданные.НомерСтроки) КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаЗапасыПереданные.Период КАК Период,
	|	ТаблицаЗапасыПереданные.Организация КАК Организация,
	|	ТаблицаЗапасыПереданные.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасыПереданные.Характеристика КАК Характеристика,
	|	ТаблицаЗапасыПереданные.Контрагент КАК Контрагент,
	|	ТаблицаЗапасыПереданные.Договор КАК Договор,
	|	ВЫБОР
	|		КОГДА ТаблицаЗапасыПереданные.ЗаказПокупателя <> ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|			ТОГДА ТаблицаЗапасыПереданные.ЗаказПокупателя
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Заказ,
	|	ТаблицаЗапасыПереданные.Партия КАК Партия,
	|	ТаблицаЗапасыПереданные.ТипПриемаПередачи КАК ТипПриемаПередачи,
	|	СУММА(-ТаблицаЗапасыПереданные.Количество) КАК Количество,
	|	СУММА(-ТаблицаЗапасыПереданные.СуммаРасчетовРасход) КАК СуммаРасчетов
	|ИЗ
	|	ВременнаяТаблицаЗапасы КАК ТаблицаЗапасыПереданные
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаЗапасыПереданные.Период,
	|	ТаблицаЗапасыПереданные.Организация,
	|	ТаблицаЗапасыПереданные.Номенклатура,
	|	ТаблицаЗапасыПереданные.Характеристика,
	|	ТаблицаЗапасыПереданные.Партия,
	|	ТаблицаЗапасыПереданные.Контрагент,
	|	ТаблицаЗапасыПереданные.Договор,
	|	ВЫБОР
	|		КОГДА ТаблицаЗапасыПереданные.ЗаказПокупателя <> ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|			ТОГДА ТаблицаЗапасыПереданные.ЗаказПокупателя
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	ТаблицаЗапасыПереданные.ТипПриемаПередачи
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МИНИМУМ(ТаблицаЗапасыПереданные.НомерСтроки),
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	ТаблицаЗапасыПереданные.Период,
	|	ТаблицаЗапасыПереданные.Организация,
	|	ТаблицаЗапасыПереданные.Номенклатура,
	|	ТаблицаЗапасыПереданные.Характеристика,
	|	ТаблицаЗапасыПереданные.Контрагент,
	|	ТаблицаЗапасыПереданные.Договор,
	|	ВЫБОР
	|		КОГДА ТаблицаЗапасыПереданные.ЗаказПокупателя <> ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|			ТОГДА ТаблицаЗапасыПереданные.ЗаказПокупателя
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	ТаблицаЗапасыПереданные.Партия,
	|	ТаблицаЗапасыПереданные.ТипПриемаПередачи,
	|	СУММА(ТаблицаЗапасыПереданные.Количество),
	|	СУММА(ТаблицаЗапасыПереданные.СуммаРасчетовПриход)
	|ИЗ
	|	ВременнаяТаблицаЗапасы КАК ТаблицаЗапасыПереданные
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаЗапасыПереданные.Период,
	|	ТаблицаЗапасыПереданные.Организация,
	|	ТаблицаЗапасыПереданные.Номенклатура,
	|	ТаблицаЗапасыПереданные.Характеристика,
	|	ТаблицаЗапасыПереданные.Партия,
	|	ТаблицаЗапасыПереданные.Контрагент,
	|	ТаблицаЗапасыПереданные.Договор,
	|	ВЫБОР
	|		КОГДА ТаблицаЗапасыПереданные.ЗаказПокупателя <> ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|			ТОГДА ТаблицаЗапасыПереданные.ЗаказПокупателя
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	ТаблицаЗапасыПереданные.ТипПриемаПередачи";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасыПереданные", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаЗапасыПереданные()

#Область ЗагрузкаДанныхИзВнешнегоИсточника

// Поля загрузки данных из внешнего источника.
// 
// Параметры:
//  ТаблицаПолейЗагрузки - см. ЗагрузкаДанныхИзВнешнегоИсточника.СоздатьТаблицуПолейОписанияЗагрузки
//  НастройкиЗагрузкиДанных - см. ЗагрузкаДанныхИзВнешнегоИсточника.ПриСозданииНаСервере
//
Процедура ПоляЗагрузкиДанныхИзВнешнегоИсточника(ТаблицаПолейЗагрузки, НастройкиЗагрузкиДанных) Экспорт
	
	ОписанияТиповПолей = ЗагрузкаДанныхИзВнешнегоИсточника.НовыйОписанияТиповПолейЗагрузки();

	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.Номенклатура");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПоляНоменклатуры(ТаблицаПолейЗагрузки, ОписаниеТиповКолонка,
		ОписанияТиповПолей, НастройкиЗагрузкиДанных);

	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Содержание", НСтр(
		"ru = 'Содержание'"), ОписанияТиповПолей.ОписаниеТиповСтрока1000, ОписанияТиповПолей.ОписаниеТиповСтрока1000, ,
		, , , НастройкиЗагрузкиДанных.СодержаниеВидимо);

	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПоляГруппыНоменклатуры(ТаблицаПолейЗагрузки, ОписанияТиповПолей,
		ОписаниеТиповКолонка);

	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПоляХарактеристики(ТаблицаПолейЗагрузки, ОписанияТиповПолей);

	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ЭтоУслуга", НСтр(
		"ru = 'Это услуга'", ОбщегоНазначения.КодОсновногоЯзыка()), ОписанияТиповПолей.ОписаниеТиповБулево,
		ОписанияТиповПолей.ОписаниеТиповБулево);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Картинка", НСтр(
		"ru = 'Картинка'", ОбщегоНазначения.КодОсновногоЯзыка()), ОписанияТиповПолей.ОписаниеТиповСтрока1000,
		ОписанияТиповПолей.ОписаниеТиповСтрока1000, , , , , Ложь);

	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартии") Тогда

		ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.ПартииНоменклатуры");
		ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Партия", НСтр(
			"ru = 'Партия (наименование)'"), ОписанияТиповПолей.ОписаниеТиповСтрока150, ОписаниеТиповКолонка);

	КонецЕсли;

	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Количество", НСтр(
		"ru = 'Количество'"), ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписанияТиповПолей.ОписаниеТиповЧисло15_3, , ,
		Истина);

	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.КлассификаторЕдиницИзмерения, СправочникСсылка.ЕдиницыИзмерения");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "ЕдиницаИзмерения", НСтр(
		"ru = 'Ед. изм.'"), ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписаниеТиповКолонка, , , , ,
		ПолучитьФункциональнуюОпцию("УчетВРазличныхЕдиницахИзмерения"));

	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Цена", НСтр("ru = 'Цена'"),
		ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписанияТиповПолей.ОписаниеТиповЧисло15_2, , , Ложь);

	ОписаниеТиповКолонка = Новый ОписаниеТипов("СправочникСсылка.СтавкиНДС");
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "СтавкаНДС", НСтр(
		"ru = 'СтавкаНДС'"), ОписанияТиповПолей.ОписаниеТиповСтрока25, ОписаниеТиповКолонка, , , Ложь);

	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказПокупателя"));

	ОписаниеТиповКолонка = Новый ОписаниеТипов(МассивТипов);
	ЗагрузкаДанныхИзВнешнегоИсточника.ДобавитьПолеОписанияЗагрузки(ТаблицаПолейЗагрузки, "Заказ", НСтр("ru = 'Заказ'"),
		ОписанияТиповПолей.ОписаниеТиповСтрока50, ОписаниеТиповКолонка);

КонецПроцедуры

Процедура ПриОпределенииОбразцовЗагрузкиДанных(НастройкиЗагрузкиДанных, УникальныйИдентификатор) Экспорт
	
	Образец_xlsx = ПолучитьМакет("ОбразецЗагрузкиДанных_xlsx");
	ОбразецЗагрузкиДанных_xlsx = ПоместитьВоВременноеХранилище(Образец_xlsx, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_xlsx", ОбразецЗагрузкиДанных_xlsx);
	
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_mxl", "ОбразецЗагрузкиДанных_mxl");
	
	Образец_csv = ПолучитьМакет("ОбразецЗагрузкиДанных_csv");
	ОбразецЗагрузкиДанных_csv = ПоместитьВоВременноеХранилище(Образец_csv, УникальныйИдентификатор);
	НастройкиЗагрузкиДанных.Вставить("ОбразецЗагрузкиДанных_csv", ОбразецЗагрузкиДанных_csv);
	
КонецПроцедуры

Процедура СопоставитьЗагружаемыеДанныеИзВнешнегоИсточника(ПараметрыСопоставления, АдресРезультата) Экспорт
	
	ТаблицаСопоставленияДанных	= ПараметрыСопоставления.ТаблицаСопоставленияДанных;
	РазмерТаблицыДанных			= ТаблицаСопоставленияДанных.Количество();
	НастройкиЗагрузкиДанных		= ПараметрыСопоставления.НастройкиЗагрузкиДанных;
	НастройкиПоиска				= НастройкиЗагрузкиДанных.НастройкиПоиска;
	
	ТаблицаДублирующихСтрок = ЗагрузкаДанныхИзВнешнегоИсточника.ПустаяТаблицаДублирующихСтрокНоменклатуры();
	НастройкиПоиска.Вставить("ТаблицаДублирующихСтрок", ТаблицаДублирующихСтрок);

	ПолноеИмяОбъектаЗаполнения = НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения;
	
	// ТаблицаСопоставленияДанных - Тип ДанныеФормыКоллекция
	Для каждого СтрокаТаблицыФормы Из ТаблицаСопоставленияДанных Цикл
		
		// Номенклатура по ШтрихКоду, Артикулу, Наименованию, НаименованиеПолное
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьНоменклатуру(СтрокаТаблицыФормы, НастройкиПоиска);
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "КатегорияНоменклатуры_ВходящиеДанные")
			И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "КатегорияНоменклатуры") Тогда
		
			ЗначениеПоУмолчанию = Справочники.КатегорииНоменклатуры.БезКатегории;					
			ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьКатегориюНоменклатуры(СтрокаТаблицыФормы.КатегорияНоменклатуры, СтрокаТаблицыФормы.КатегорияНоменклатуры_ВходящиеДанные, ЗначениеПоУмолчанию);
			
		КонецЕсли;
		
		Если ПолноеИмяОбъектаЗаполнения = "Документ.ПереоценкаТоваровНаКомиссии.ТабличнаяЧасть.Запасы" Тогда
			
			Если СтрокаТаблицыФормы.Номенклатура.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Запас Тогда
				
				СтрокаТаблицыФормы.Номенклатура = Неопределено;
				
			КонецЕсли;
			
			СтрокаТаблицыФормы.СчетУчетаЗапасов = Справочники.Номенклатура.СчетУчетаЗапасов();
			СтрокаТаблицыФормы.СчетУчетаЗатрат = ?(ПолучитьФункциональнуюОпцию("ИспользоватьПодсистемуПроизводство"), 
				ПланыСчетов.Управленческий.НезавершенноеПроизводство, ПланыСчетов.Управленческий.КоммерческиеРасходы);
			СтрокаТаблицыФормы.СчетУчетаДоходов = ?(СтрокаТаблицыФормы.Номенклатура.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.ПодарочныйСертификат"), 
				ПланыСчетов.Управленческий.ПрочиеДоходы, ПланыСчетов.Управленческий.ПустаяСсылка());
				
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "НаправлениеДеятельности") Тогда
					
				ЗначениеПоУмолчанию = Справочники.НаправленияДеятельности.Прочее;
				ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьНаправлениеДеятельности(СтрокаТаблицыФормы.НаправлениеДеятельности, СтрокаТаблицыФормы.НаправлениеДеятельности_ВходящиеДанные, ЗначениеПоУмолчанию);
				
			КонецЕсли;
			
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "МетодОценки") Тогда
					
				ЗначениеПоУмолчанию = Перечисления.МетодОценкиЗапасов.ПоСредней;
				ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьМетодОценки(СтрокаТаблицыФормы.МетодОценки, СтрокаТаблицыФормы.МетодОценки_ВходящиеДанные, ЗначениеПоУмолчанию);
				
			КонецЕсли;
			
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "СпособПополнения") Тогда
					
				ЗначениеПоУмолчанию = Перечисления.СпособыПополненияЗапасов.Закупка;
				ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьСпособПополнения(СтрокаТаблицыФормы.СпособПополнения, СтрокаТаблицыФормы.СпособПополнения_ВходящиеДанные, ЗначениеПоУмолчанию);
				
			КонецЕсли;
			
			Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") Тогда
				
				Если ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура) Тогда
					
					// Характеристика по Владельцу и Наименованию
					ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьХарактеристику(СтрокаТаблицыФормы);
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "Родитель")
				И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "РодительНаименование")
				И ЗначениеЗаполнено(СтрокаТаблицыФормы.РодительНаименование) Тогда
				
				ЗначениеПоУмолчанию = Справочники.Номенклатура.ПустаяСсылка();
				ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьРодителяНоменклатуры(СтрокаТаблицыФормы.Родитель, "", СтрокаТаблицыФормы.РодительНаименование, ЗначениеПоУмолчанию);
				
			КонецЕсли;
			
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицыФормы, "ЭтоУслуга_ВходящиеДанные") Тогда
				
				СтрокаТаблицыФормы.ЭтоУслуга = СтрокаТаблицыФормы.ЭтоУслуга_ВходящиеДанные;
				
			КонецЕсли;
			
			Если ПолучитьФункциональнуюОпцию("ИспользоватьПартии") Тогда
				
				Если ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура) Тогда
					
					// Партия по Владельцу и Наименованию
					ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьПартию(СтрокаТаблицыФормы.Партия, СтрокаТаблицыФормы.Номенклатура, СтрокаТаблицыФормы.Штрихкод, СтрокаТаблицыФормы.Партия_ВходящиеДанные);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		// Количество
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.Количество, СтрокаТаблицыФормы.Количество_ВходящиеДанные, 1);
		
		// ЕдиницыИзмерения по Наименованию (так же рассмотреть возможность прикрутить пользовательские ЕИ)
		ЗначениеПоУмолчанию = ?(ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура), СтрокаТаблицыФормы.Номенклатура.ЕдиницаИзмерения, Справочники.КлассификаторЕдиницИзмерения.шт);
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьЕдиницыИзмерения(СтрокаТаблицыФормы.Номенклатура, СтрокаТаблицыФормы.ЕдиницаИзмерения, СтрокаТаблицыФормы.ЕдиницаИзмерения_ВходящиеДанные, ЗначениеПоУмолчанию);
		
		// Цена
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ПреобразоватьСтрокуВЧисло(СтрокаТаблицыФормы.Цена, СтрокаТаблицыФормы.Цена_ВходящиеДанные, 1);
		
		// Заказ по номеру, дате, признаку
		ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.СопоставитьЗаказ(СтрокаТаблицыФормы.Заказ, СтрокаТаблицыФормы.Заказ_ВходящиеДанные);
		
		ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы, ПолноеИмяОбъектаЗаполнения);
		
		ЗагрузкаДанныхИзВнешнегоИсточника.ПрогрессСопоставленияДанных(ТаблицаСопоставленияДанных.Индекс(СтрокаТаблицыФормы), РазмерТаблицыДанных);
		
	КонецЦикла;

	ТаблицаСопоставленияДанных.ЗагрузитьКолонку(ТаблицаДублирующихСтрок.ВыгрузитьКолонку("КлючСвязи"), "_КлючСвязи");
	ПоместитьВоВременноеХранилище(ТаблицаСопоставленияДанных, АдресРезультата);
	
КонецПроцедуры

Процедура ПроверитьКорректностьДанныхВСтрокеТаблицы(СтрокаТаблицыФормы, ПолноеИмяОбъектаЗаполнения = "") Экспорт
	
	ИмяСлужебногоПоля = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяСлужебногоПоляЗагрузкаВПриложениеВозможна();
	
	НоменклатураЗаполнена = ЗначениеЗаполнено(СтрокаТаблицыФормы.Номенклатура);
	ЗагрузкаНоменклатурыВозможна = Ложь;
	Если НЕ НоменклатураЗаполнена Тогда
		ЗагрузкаНоменклатурыВозможна = (ЗначениеЗаполнено(СтрокаТаблицыФормы.НоменклатураНаименование) ИЛИ ЗначениеЗаполнено(СтрокаТаблицыФормы.НоменклатураНаименованиеПолное));
	КонецЕсли;

	Если ПолноеИмяОбъектаЗаполнения = "Документ.ПереоценкаТоваровНаКомиссии.ТабличнаяЧасть.Запасы" Тогда
		
		Если НоменклатураЗаполнена Тогда				
			
			СтрокаТаблицыФормы[ИмяСлужебногоПоля] = СтрокаТаблицыФормы.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас
			И НЕ СтрокаТаблицыФормы.Номенклатура.ЭтоНабор // Исключая наборы
			И СтрокаТаблицыФормы.Количество <> 0;
			СтрокаТаблицыФормы._СтрокаСопоставлена = НоменклатураЗаполнена;
			
		Иначе
			
			СтрокаТаблицыФормы[ИмяСлужебногоПоля] = ЗагрузкаНоменклатурыВозможна И НЕ СтрокаТаблицыФормы.ЭтоУслуга;
			
		КонецЕсли;		
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерфейсПечати

// Функция формирует печатную форму документа.
//
// Параметры:
//	ТабличныйДокумент - ТабличныйДокумент в который будет выводится печатная
//				   форма.
Функция ПечатнаяФормаПереоценка(МассивОбъектов, ОбъектыПечати)
	Перем ПервыйДокумент, НомерСтрокиНачало;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ПереоценкаТоваровНаКомиссии";
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПереоценкаТоваровНаКомиссии_Накладная";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПереоценкаТоваровНаКомиссии.ПФ_MXL_Переоценка");
	
	ПараметрыНоменклатуры = Новый Структура;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПереоценкаТоваровНаКомиссии.Ссылка КАК Ссылка,
	|	ПереоценкаТоваровНаКомиссии.Организация КАК Организация,
	|	ПереоценкаТоваровНаКомиссии.Контрагент КАК Контрагент,
	|	ПереоценкаТоваровНаКомиссии.Дата КАК ДатаДокумента,
	|	ПереоценкаТоваровНаКомиссии.КонтактноеЛицоПодписант КАК КонтактноеЛицоПодписант,
	|	ПереоценкаТоваровНаКомиссии.Номер КАК Номер,
	|	ПереоценкаТоваровНаКомиссии.Организация.Префикс КАК Префикс,
	|	ПереоценкаТоваровНаКомиссии.ВалютаДокумента КАК ВалютаДокумента,
	|	ПереоценкаТоваровНаКомиссии.Запасы.(
	|		НомерСтроки КАК НомерСтроки,
	|		ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(ПереоценкаТоваровНаКомиссии.Запасы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|				ТОГДА ПереоценкаТоваровНаКомиссии.Запасы.Номенклатура.Наименование
	|			ИНАЧЕ ВЫРАЗИТЬ(ПереоценкаТоваровНаКомиссии.Запасы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))
	|		КОНЕЦ КАК Запас,
	|		Количество КАК Количество,
	|		ЕдиницаИзмерения КАК ЕдиницаХранения,
	|		Характеристика КАК Характеристика,
	|		Партия КАК Партия,
	|		Цена КАК Цена,
	|		Сумма КАК Сумма,
	|		Номенклатура.Код КАК Код,
	|		Номенклатура.Артикул КАК Артикул,
	|		Номенклатура.Штрихкод КАК Штрихкод,
	|		СуммаСтарая КАК СуммаСтарая,
	|		Отклонение КАК Отклонение,
	|		ВЫРАЗИТЬ(ПереоценкаТоваровНаКомиссии.Запасы.СуммаСтарая / ПереоценкаТоваровНаКомиссии.Запасы.Количество КАК ЧИСЛО(15, 2)) КАК ЦенаСтарая
	|	) КАК Запасы,
	|	ПереоценкаТоваровНаКомиссии.Ответственный КАК Ответственный,
	|	СотрудникиСрезПоследних.Должность КАК Должность
	|ИЗ
	|	Документ.ПереоценкаТоваровНаКомиссии КАК ПереоценкаТоваровНаКомиссии
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники.СрезПоследних КАК СотрудникиСрезПоследних
	|		ПО ПереоценкаТоваровНаКомиссии.Ответственный = СотрудникиСрезПоследних.Сотрудник
	|ГДЕ
	|	ПереоценкаТоваровНаКомиссии.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
		
	ДанныеДокументов = Запрос.Выполнить().Выгрузить();
	
	Для каждого Шапка Из ДанныеДокументов Цикл
	
		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало);
		
		СведенияОбОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента, ,);
		СведенияОбКонтрагенте = ПечатьДокументовУНФ.СведенияОЮрФизЛице(Шапка.Контрагент, Шапка.ДатаДокумента, ,);
		
		НомерДокумента = ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(Шапка.ДатаДокумента,
			Шапка.Номер, Шапка.Префикс);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Переоценка товаров на комиссии № %1 от %2'"),
			НомерДокумента, Формат(Шапка.ДатаДокумента, "ДЛФ=DD"));
			
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ПредставлениеПоставщика = ПечатьДокументовУНФ.ОписаниеОрганизации(
			СведенияОбОрганизации, "ПолноеНаименование,ИНН,КПП,РегистрационныйНомер,ЮридическийАдрес,Телефоны,");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		ОбластьМакета.Параметры.ПредставлениеПолучателя = ПечатьДокументовУНФ.ОписаниеОрганизации(
			СведенияОбКонтрагенте, "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		
		СтруктураИтогов = Новый Структура("Сумма, СуммаСтарая, Отклонение, Количество, НомерСтроки", 0, 0, 0, 0, 0);
		ДанныеПечати = Новый Структура;
		
		Для каждого СтрокаЗапасы Из Шапка.Запасы Цикл
			
			Если СтрокаЗапасы.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаЗапасы, ДанныеПечати, ПараметрыНоменклатуры, СтруктураИтогов, Шапка);
			
			ОбластьМакета.Параметры.Заполнить(СтрокаЗапасы);
			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		ОбластьМакета.Параметры.Всего = ПечатьДокументовУНФ.ФорматСумм(СтруктураИтогов.Сумма);
		ОбластьМакета.Параметры.ВсегоСтарая = ПечатьДокументовУНФ.ФорматСумм(СтруктураИтогов.СуммаСтарая);
		ОбластьМакета.Параметры.ВсегоОтклонение = ПечатьДокументовУНФ.ФорматСумм(СтруктураИтогов.Отклонение);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		СуммаКПрописи = СтруктураИтогов.Сумма;
		ОбластьМакета.Параметры.ИтоговаяСтрока = "Всего наименований "
								+ Строка(СтруктураИтогов.НомерСтроки)
								+ ", на сумму "
								+ ПечатьДокументовУНФ.ФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента);
		
		ОбластьМакета.Параметры.СуммаПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаКПрописи, Шапка.ВалютаДокумента);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьМакета);
			
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаТабличнойЧасти, ДанныеПечати, ПараметрыНоменклатуры, СтруктураИтогов, Шапка)
	
	ДанныеПечати.Очистить();
	
	СтруктураИтогов.НомерСтроки = СтруктураИтогов.НомерСтроки+1;
	НомерСтроки = СтруктураИтогов.НомерСтроки;
	
	ДанныеПечати.Вставить("НомерСтроки", НомерСтроки);
	
	ПараметрыНоменклатуры.Очистить();
	ПараметрыНоменклатуры.Вставить("ПредставлениеНоменклатуры", СтрокаТабличнойЧасти.Запас);
	ПараметрыНоменклатуры.Вставить("ПредставлениеХарактеристики", СтрокаТабличнойЧасти.Характеристика);
	ДанныеПечати.Вставить("Запас", ПечатьДокументовУНФ.ПредставлениеНоменклатуры(ПараметрыНоменклатуры));
	
	ДанныеПечати.Вставить("ПредставлениеКодаНоменклатуры", ПечатьДокументовУНФ.ПредставлениеКодаНоменклатуры(СтрокаТабличнойЧасти));
	
	СтруктураИтогов.Сумма = СтруктураИтогов.Сумма + СтрокаТабличнойЧасти.Сумма;
	СтруктураИтогов.СуммаСтарая = СтруктураИтогов.СуммаСтарая + СтрокаТабличнойЧасти.СуммаСтарая;
	СтруктураИтогов.Отклонение = СтруктураИтогов.Отклонение + СтрокаТабличнойЧасти.Отклонение;
	
КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПереоценкаТоваровОтданныхНаКомиссию") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПереоценкаТоваровОтданныхНаКомиссию", НСтр("ru = 'Переоценка товаров отданных на комиссию'"), ПечатнаяФормаПереоценка(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	// параметры отправки печатных форм по электронной почте
	ЭлектроннаяПочтаУНФ.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, 
		КоллекцияПечатныхФорм);
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// МобильноеПриложение
	Если МобильноеПриложениеВызовСервера.НужноОграничитьФункциональность() Тогда
		Возврат;
	КонецЕсли;
	// Конец МобильноеПриложение

	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПереоценкаТоваровОтданныхНаКомиссию";
	КомандаПечати.Представление = НСтр("ru = 'Переоценка товаров отданных на комиссию'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли