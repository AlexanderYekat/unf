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
	|	И ЗначениеРазрешено(СтруктурнаяЕдиница)";

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

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//   Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Документы.РасходныйОрдер.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
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
		КомандаСозданияНаОсновании = МодульСозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы.РасходныйОрдер);
		Возврат КомандаСозданияНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
#КонецОбласти

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаРасходныйОрдер, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос( 
	"ВЫБРАТЬ
	|	РасходныйОрдерЗапасы.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	РасходныйОрдерЗапасы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	РасходныйОрдерЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ВЫБОР
	|		КОГДА &УчетПоЯчейкам
	|			ТОГДА РасходныйОрдерЗапасы.Ячейка
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Ячейка,
	|	РасходныйОрдерЗапасы.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &ИспользоватьХарактеристики
	|			ТОГДА РасходныйОрдерЗапасы.Характеристика
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Характеристика,
	|	ВЫБОР
	|		КОГДА &ИспользоватьПартии
	|			ТОГДА РасходныйОрдерЗапасы.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Партия,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(РасходныйОрдерЗапасы.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
	|			ТОГДА РасходныйОрдерЗапасы.Количество
	|		ИНАЧЕ РасходныйОрдерЗапасы.Количество * РасходныйОрдерЗапасы.ЕдиницаИзмерения.Коэффициент
	|	КОНЕЦ КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ РасходныйОрдерЗапасы.Ссылка.СтруктурнаяЕдиница.ВидУчетаОрдерныхСкладов = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаОрдерныхСкладов.ПоСкладуВЦелом)
	|			ТОГДА ВЫБОР
	|					КОГДА РасходныйОрдерЗапасы.Ссылка.СтруктурнаяЕдиница.ВидУчетаОрдерныхСкладов = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаОрдерныхСкладов.УчетОстатковПоСкладскимОрдерам)
	|						ТОГДА РасходныйОрдерЗапасы.Ссылка
	|					ИНАЧЕ РасходныйОрдерЗапасы.ДокументПоступления
	|				КОНЕЦ
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ДокументОснование
	|ИЗ
	|	Документ.РасходныйОрдер.Запасы КАК РасходныйОрдерЗапасы
	|ГДЕ
	|	РасходныйОрдерЗапасы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаЗапасы.Ссылка.Дата КАК ДатаСобытия,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииСерийНоменклатуры.Расход) КАК Операция,
	|	ТаблицаСерииНоменклатуры.Серия КАК Серия,
	|	&Организация КАК Организация,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаЗапасы.Ссылка.Ячейка КАК Ячейка,
	|	ВЫБОР
	|		КОГДА ТаблицаСерииНоменклатуры.Количество = 0
	|			ТОГДА 1
	|		ИНАЧЕ ТаблицаСерииНоменклатуры.Количество
	|	КОНЕЦ КАК Количество
	|ИЗ
	|	Документ.РасходныйОрдер.Запасы КАК ТаблицаЗапасы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РасходныйОрдер.СерииНоменклатуры КАК ТаблицаСерииНоменклатуры
	|		ПО ТаблицаЗапасы.Ссылка = ТаблицаСерииНоменклатуры.Ссылка
	|			И ТаблицаЗапасы.КлючСвязи = ТаблицаСерииНоменклатуры.КлючСвязи
	|ГДЕ
	|	ТаблицаСерииНоменклатуры.Ссылка = &Ссылка
	|	И ТаблицаЗапасы.Ссылка = &Ссылка
	|	И &ИспользоватьСерииНоменклатуры
	|	И НЕ ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница.ВидУчетаОрдерныхСкладов = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаОрдерныхСкладов.УчетОстатковПоСкладскимОрдерам)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаЗапасы.Ссылка.Дата КАК ДатаСобытия,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииСерийНоменклатуры.Расход) КАК Операция,
	|	ТаблицаСерииНоменклатуры.Серия КАК Серия,
	|	&Организация КАК Организация,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаЗапасы.Ссылка.Ячейка КАК Ячейка,
	|	ВЫБОР
	|		КОГДА ТаблицаСерииНоменклатуры.Количество = 0
	|			ТОГДА 1
	|		ИНАЧЕ ТаблицаСерииНоменклатуры.Количество
	|	КОНЕЦ КАК Количество,
	|	ВЫБОР
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL
	|			ТОГДА ВЫБОР
	|					КОГДА ТаблицаЗапасы.Номенклатура.ПолитикаУчетаСерий = ЗНАЧЕНИЕ(Справочник.ПолитикаУчетаСерий.ПустаяСсылка)
	|						ТОГДА &ОстаткиСерийНоменклатуры
	|					ИНАЧЕ ВЫБОР
	|							КОГДА ТаблицаЗапасы.Номенклатура.ПолитикаУчетаСерий.ТипПолитики = ЗНАЧЕНИЕ(Перечисление.ТипыПолитикУказанияСерий.УправлениеОстаткамиСерий)
	|								ТОГДА ИСТИНА
	|							ИНАЧЕ ЛОЖЬ
	|						КОНЕЦ
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий = ЗНАЧЕНИЕ(Справочник.ПолитикаУчетаСерий.ПустаяСсылка)
	|					ТОГДА &ОстаткиСерийНоменклатуры
	|				ИНАЧЕ ВЫБОР
	|						КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.ТипПолитики = ЗНАЧЕНИЕ(Перечисление.ТипыПолитикУказанияСерий.УправлениеОстаткамиСерий)
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ ЛОЖЬ
	|					КОНЕЦ
	|			КОНЕЦ
	|	КОНЕЦ КАК ОстаткиСерийНоменклатуры
	|ИЗ
	|	Документ.РасходныйОрдер.Запасы КАК ТаблицаЗапасы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РасходныйОрдер.СерииНоменклатуры КАК ТаблицаСерииНоменклатуры
	|		ПО ТаблицаЗапасы.Ссылка = ТаблицаСерииНоменклатуры.Ссылка
	|			И ТаблицаЗапасы.КлючСвязи = ТаблицаСерииНоменклатуры.КлючСвязи
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|		ПО ТаблицаЗапасы.Номенклатура = ПолитикиУчетаСерий.Владелец
	|			И (&Организация = ПолитикиУчетаСерий.Организация)
	|			И (&СтруктурнаяЕдиница = ПолитикиУчетаСерий.СтруктурнаяЕдиница)
	|ГДЕ
	|	ТаблицаСерииНоменклатуры.Ссылка = &Ссылка
	|	И ТаблицаЗапасы.Ссылка = &Ссылка
	|	И &ИспользоватьСерииНоменклатуры
	|	И НЕ ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница.ВидУчетаОрдерныхСкладов = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаОрдерныхСкладов.УчетОстатковПоСкладскимОрдерам)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаЗапасы.Ссылка.Дата КАК ДатаСобытия,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииСерийНоменклатуры.Расход) КАК Операция,
	|	ТаблицаСерииНоменклатуры.Серия КАК Серия,
	|	&Организация КАК Организация,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ТаблицаЗапасы.Ссылка.Ячейка КАК Ячейка,
	|	ВЫБОР
	|		КОГДА ТаблицаСерииНоменклатуры.Количество = 0
	|			ТОГДА 1
	|		ИНАЧЕ ТаблицаСерииНоменклатуры.Количество
	|	КОНЕЦ КАК Количество,
	|	ВЫБОР
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL
	|			ТОГДА ВЫБОР
	|					КОГДА ТаблицаЗапасы.Номенклатура.ПолитикаУчетаСерий = ЗНАЧЕНИЕ(Справочник.ПолитикаУчетаСерий.ПустаяСсылка)
	|						ТОГДА &ОстаткиСерийНоменклатуры
	|					ИНАЧЕ ВЫБОР
	|							КОГДА ТаблицаЗапасы.Номенклатура.ПолитикаУчетаСерий.ТипПолитики = ЗНАЧЕНИЕ(Перечисление.ТипыПолитикУказанияСерий.УправлениеОстаткамиСерий)
	|								ТОГДА ИСТИНА
	|							ИНАЧЕ ЛОЖЬ
	|						КОНЕЦ
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий = ЗНАЧЕНИЕ(Справочник.ПолитикаУчетаСерий.ПустаяСсылка)
	|					ТОГДА &ОстаткиСерийНоменклатуры
	|				ИНАЧЕ ВЫБОР
	|						КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.ТипПолитики = ЗНАЧЕНИЕ(Перечисление.ТипыПолитикУказанияСерий.УправлениеОстаткамиСерий)
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ ЛОЖЬ
	|					КОНЕЦ
	|			КОНЕЦ
	|	КОНЕЦ КАК ОстаткиСерийНоменклатуры,
	|	ВЫБОР
	|		КОГДА ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница.ВидУчетаОрдерныхСкладов = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаОрдерныхСкладов.УчетОстатковПоСкладскимОрдерам)
	|			ТОГДА ТаблицаЗапасы.Ссылка
	|		ИНАЧЕ ТаблицаЗапасы.ДокументПоступления
	|	КОНЕЦ КАК ДокументОснование
	|ИЗ
	|	Документ.РасходныйОрдер.Запасы КАК ТаблицаЗапасы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РасходныйОрдер.СерииНоменклатуры КАК ТаблицаСерииНоменклатуры
	|		ПО ТаблицаЗапасы.Ссылка = ТаблицаСерииНоменклатуры.Ссылка
	|			И ТаблицаЗапасы.КлючСвязи = ТаблицаСерииНоменклатуры.КлючСвязи
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|		ПО ТаблицаЗапасы.Номенклатура = ПолитикиУчетаСерий.Владелец
	|			И (&Организация = ПолитикиУчетаСерий.Организация)
	|			И (&СтруктурнаяЕдиница = ПолитикиУчетаСерий.СтруктурнаяЕдиница)
	|ГДЕ
	|	ТаблицаСерииНоменклатуры.Ссылка = &Ссылка
	|	И ТаблицаЗапасы.Ссылка = &Ссылка
	|	И &ИспользоватьСерииНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасходныйОрдерЗапасы.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	РасходныйОрдерЗапасы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	РасходныйОрдерЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ВЫБОР
	|		КОГДА &УчетПоЯчейкам
	|				И РасходныйОрдерЗапасы.Ссылка.СтруктурнаяЕдиница.УчетОстатковПоЯчейкам
	|			ТОГДА РасходныйОрдерЗапасы.Ячейка
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Ячейка,
	|	РасходныйОрдерЗапасы.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &ИспользоватьХарактеристики
	|			ТОГДА РасходныйОрдерЗапасы.Характеристика
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Характеристика,
	|	ВЫБОР
	|		КОГДА &ИспользоватьПартии
	|			ТОГДА РасходныйОрдерЗапасы.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Партия,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(РасходныйОрдерЗапасы.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
	|			ТОГДА РасходныйОрдерЗапасы.Количество
	|		ИНАЧЕ РасходныйОрдерЗапасы.Количество * РасходныйОрдерЗапасы.ЕдиницаИзмерения.Коэффициент
	|	КОНЕЦ КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ РасходныйОрдерЗапасы.Ссылка.СтруктурнаяЕдиница.ВидУчетаОрдерныхСкладов = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаОрдерныхСкладов.ПоСкладуВЦелом)
	|			ТОГДА ВЫБОР
	|					КОГДА РасходныйОрдерЗапасы.Ссылка.СтруктурнаяЕдиница.ВидУчетаОрдерныхСкладов = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаОрдерныхСкладов.УчетОстатковПоСкладскимОрдерам)
	|						ТОГДА РасходныйОрдерЗапасы.Ссылка
	|					ИНАЧЕ ВЫБОР
	|							КОГДА РасходныйОрдерЗапасы.Ссылка.ПоложениеДокументаПоступления = ЗНАЧЕНИЕ(Перечисление.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти)
	|								ТОГДА РасходныйОрдерЗапасы.ДокументПоступления
	|							ИНАЧЕ РасходныйОрдерЗапасы.Ссылка.ДокументПоступления
	|						КОНЕЦ
	|				КОНЕЦ
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ДокументОснование
	|ИЗ
	|	Документ.РасходныйОрдер.Запасы КАК РасходныйОрдерЗапасы
	|ГДЕ
	|	РасходныйОрдерЗапасы.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаРасходныйОрдер);
	Запрос.УстановитьПараметр("Дата", СтруктураДополнительныеСвойства.ДляПроведения.Дата);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("ИспользоватьХарактеристики", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьХарактеристики);
	Запрос.УстановитьПараметр("УчетПоЯчейкам", СтруктураДополнительныеСвойства.УчетнаяПолитика.УчетПоЯчейкам);
	Запрос.УстановитьПараметр("ИспользоватьПартии", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьПартии);
	
	Запрос.УстановитьПараметр("ИспользоватьСерииНоменклатуры", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьСерииНоменклатуры);
	Запрос.УстановитьПараметр("ОстаткиСерийНоменклатуры", СтруктураДополнительныеСвойства.УчетнаяПолитика.ОстаткиСерийНоменклатуры);
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", ДокументСсылкаРасходныйОрдер.СтруктурнаяЕдиница);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасыНаСкладах", МассивРезультатов[0].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасыКРасходуСоСкладов", МассивРезультатов[4].Выгрузить());
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерииНоменклатурыГарантии", Новый ТаблицаЗначений);
	
	ТаблицаСерииНоменклатуры = МассивРезультатов[2].Выгрузить();
	ТаблицаСерииНоменклатурыКРасходу = МассивРезультатов[3].Выгрузить();
	
	ПараметрыОтбора = Новый Структура("ОстаткиСерийНоменклатуры", Истина);
	
	Если СтруктураДополнительныеСвойства.КонтролироватьОстатковПоОрерам Тогда
		
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерииНоменклатуры", Новый ТаблицаЗначений);
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДвиженияСерииНоменклатуры", Новый ТаблицаЗначений);
		
	Иначе
		
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДвиженияСерииНоменклатуры", МассивРезультатов[1].Выгрузить());
		
		ОстаткиСерийНоменклатурыСтроки = ТаблицаСерииНоменклатуры.НайтиСтроки(ПараметрыОтбора);
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерииНоменклатуры", ТаблицаСерииНоменклатуры.Скопировать(ОстаткиСерийНоменклатурыСтроки));
		
	КонецЕсли;
	
	
	ОстаткиСерийНоменклатурыСтроки = ТаблицаСерииНоменклатурыКРасходу.НайтиСтроки(ПараметрыОтбора);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерииНоменклатурыКРасходу", ТаблицаСерииНоменклатурыКРасходу.Скопировать(ОстаткиСерийНоменклатурыСтроки));
	
	ПроведениеДокументовУНФ.СформироватьТаблицуПроводок(ДокументСсылкаРасходныйОрдер, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылкаРасходныйОрдер, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если ПроведениеДокументовУНФ.КонтрольОстатковВыключен() Тогда
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Если временные таблицы "ДвиженияЗапасыНаСкладахИзменение", "ДвиженияЗапасыИзменение"
	// содержат записи, необходимо выполнить контроль реализации товаров.
	
	Если СтруктураВременныеТаблицы.ДвиженияЗапасыНаСкладахИзменение 
		ИЛИ СтруктураВременныеТаблицы.ДвиженияСерииНоменклатурыИзменение
		ИЛИ СтруктураВременныеТаблицы.ДвиженияСерииНоменклатурыКРасходуИзменение 
		ИЛИ СтруктураВременныеТаблицы.ДвиженияЗапасыКРасходуСоСкладовИзменение Тогда 

		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗапасыНаСкладахИзменение.НомерСтроки КАК НомерСтроки,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Организация) КАК ОрганизацияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница) КАК СтруктурнаяЕдиницаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Номенклатура) КАК НоменклатураПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Характеристика) КАК ХарактеристикаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Партия) КАК ПартияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыНаСкладахИзменение.Ячейка) КАК ЯчейкаПредставление,
		|	ЗапасыНаСкладахОстатки.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы КАК ТипСтруктурнойЕдиницы,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЗапасыНаСкладахОстатки.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
		|	ЕСТЬNULL(ДвиженияЗапасыНаСкладахИзменение.КоличествоИзменение, 0) + ЕСТЬNULL(ЗапасыНаСкладахОстатки.КоличествоОстаток, 0) КАК ОстатокЗапасыНаСкладах,
		|	ЕСТЬNULL(ЗапасыНаСкладахОстатки.КоличествоОстаток, 0) КАК КоличествоОстатокЗапасыНаСкладах
		|ИЗ
		|	ДвиженияЗапасыНаСкладахИзменение КАК ДвиженияЗапасыНаСкладахИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыНаСкладах.Остатки(
		|				&МоментКонтроля,
		|				(Организация, СтруктурнаяЕдиница, Номенклатура, Характеристика, Партия, Ячейка) В
		|					(ВЫБРАТЬ
		|						ДвиженияЗапасыНаСкладахИзменение.Организация КАК Организация,
		|						ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|						ДвиженияЗапасыНаСкладахИзменение.Номенклатура КАК Номенклатура,
		|						ДвиженияЗапасыНаСкладахИзменение.Характеристика КАК Характеристика,
		|						ДвиженияЗапасыНаСкладахИзменение.Партия КАК Партия,
		|						ДвиженияЗапасыНаСкладахИзменение.Ячейка КАК Ячейка
		|					ИЗ
		|						ДвиженияЗапасыНаСкладахИзменение КАК ДвиженияЗапасыНаСкладахИзменение)) КАК ЗапасыНаСкладахОстатки
		|		ПО ДвиженияЗапасыНаСкладахИзменение.Организация = ЗапасыНаСкладахОстатки.Организация
		|			И ДвиженияЗапасыНаСкладахИзменение.СтруктурнаяЕдиница = ЗапасыНаСкладахОстатки.СтруктурнаяЕдиница
		|			И ДвиженияЗапасыНаСкладахИзменение.Номенклатура = ЗапасыНаСкладахОстатки.Номенклатура
		|			И ДвиженияЗапасыНаСкладахИзменение.Характеристика = ЗапасыНаСкладахОстатки.Характеристика
		|			И ДвиженияЗапасыНаСкладахИзменение.Партия = ЗапасыНаСкладахОстатки.Партия
		|			И ДвиженияЗапасыНаСкладахИзменение.Ячейка = ЗапасыНаСкладахОстатки.Ячейка
		|ГДЕ
		|	ЕСТЬNULL(ЗапасыНаСкладахОстатки.КоличествоОстаток, 0) < 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияСерииНоменклатурыИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияСерииНоменклатурыИзменение.Серия КАК СерияПредставление,
		|	ДвиженияСерииНоменклатурыИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиницаПредставление,
		|	ДвиженияСерииНоменклатурыИзменение.Номенклатура КАК НоменклатураПредставление,
		|	ДвиженияСерииНоменклатурыИзменение.Характеристика КАК ХарактеристикаПредставление,
		|	ДвиженияСерииНоменклатурыИзменение.Партия КАК ПартияПредставление,
		|	ДвиженияСерииНоменклатурыИзменение.Ячейка КАК ЯчейкаПредставление,
		|	СерииНоменклатурыОстатки.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы КАК ТипСтруктурнойЕдиницы,
		|	СерииНоменклатурыОстатки.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмеренияПредставление,
		|	ЕСТЬNULL(ДвиженияСерииНоменклатурыИзменение.КоличествоИзменение, 0) + ЕСТЬNULL(СерииНоменклатурыОстатки.КоличествоОстаток, 0) КАК ОстатокЗапасыНаСкладах,
		|	ЕСТЬNULL(СерииНоменклатурыОстатки.КоличествоОстаток, 0) КАК КоличествоОстатокЗапасыНаСкладах
		|ИЗ
		|	ДвиженияСерииНоменклатурыИзменение КАК ДвиженияСерииНоменклатурыИзменение
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.СерииНоменклатуры.Остатки(&МоментКонтроля, ) КАК СерииНоменклатурыОстатки
		|		ПО ДвиженияСерииНоменклатурыИзменение.СтруктурнаяЕдиница = СерииНоменклатурыОстатки.СтруктурнаяЕдиница
		|			И ДвиженияСерииНоменклатурыИзменение.Номенклатура = СерииНоменклатурыОстатки.Номенклатура
		|			И ДвиженияСерииНоменклатурыИзменение.Характеристика = СерииНоменклатурыОстатки.Характеристика
		|			И ДвиженияСерииНоменклатурыИзменение.Партия = СерииНоменклатурыОстатки.Партия
		|			И ДвиженияСерииНоменклатурыИзменение.Серия = СерииНоменклатурыОстатки.Серия
		|			И ДвиженияСерииНоменклатурыИзменение.Ячейка = СерииНоменклатурыОстатки.Ячейка
		|			И (ЕСТЬNULL(СерииНоменклатурыОстатки.КоличествоОстаток, 0) < 0)
		|ГДЕ
		|	ВЫБОР
		|			КОГДА СерииНоменклатурыОстатки.СтруктурнаяЕдиница.ВидУчетаОрдерныхСкладов = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаОрдерныхСкладов.УчетОстатковПоСкладскимОрдерам)
		|					ИЛИ СерииНоменклатурыОстатки.СтруктурнаяЕдиница.ВидУчетаОрдерныхСкладов = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаОрдерныхСкладов.УчетОстатковПоПрочимДокументам)
		|				ТОГДА ЕСТЬNULL(СерииНоменклатурыОстатки.КоличествоОстаток, 0) < 0
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияСерииНоменклатурыКРасходуИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияСерииНоменклатурыКРасходуИзменение.Серия КАК СерияПредставление,
		|	ДвиженияСерииНоменклатурыКРасходуИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиницаПредставление,
		|	ДвиженияСерииНоменклатурыКРасходуИзменение.Номенклатура КАК НоменклатураПредставление,
		|	ДвиженияСерииНоменклатурыКРасходуИзменение.Характеристика КАК ХарактеристикаПредставление,
		|	ДвиженияСерииНоменклатурыКРасходуИзменение.Партия КАК ПартияПредставление,
		|	СерииНоменклатурыКРасходуОстатки.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы КАК ТипСтруктурнойЕдиницы,
		|	СерииНоменклатурыКРасходуОстатки.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмеренияПредставление,
		|	ЕСТЬNULL(ДвиженияСерииНоменклатурыКРасходуИзменение.КоличествоИзменение, 0) + ЕСТЬNULL(СерииНоменклатурыКРасходуОстатки.КоличествоОстаток, 0) КАК ОстатокЗапасыНаСкладах,
		|	ЕСТЬNULL(СерииНоменклатурыКРасходуОстатки.КоличествоОстаток, 0) КАК КоличествоОстатокЗапасыНаСкладах
		|ИЗ
		|	ДвиженияСерииНоменклатурыКРасходуИзменение КАК ДвиженияСерииНоменклатурыКРасходуИзменение
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.СерииНоменклатурыКРасходу.Остатки(&МоментКонтроля, ) КАК СерииНоменклатурыКРасходуОстатки
		|		ПО ДвиженияСерииНоменклатурыКРасходуИзменение.СтруктурнаяЕдиница = СерииНоменклатурыКРасходуОстатки.СтруктурнаяЕдиница
		|			И ДвиженияСерииНоменклатурыКРасходуИзменение.Номенклатура = СерииНоменклатурыКРасходуОстатки.Номенклатура
		|			И ДвиженияСерииНоменклатурыКРасходуИзменение.Характеристика = СерииНоменклатурыКРасходуОстатки.Характеристика
		|			И ДвиженияСерииНоменклатурыКРасходуИзменение.Партия = СерииНоменклатурыКРасходуОстатки.Партия
		|			И ДвиженияСерииНоменклатурыКРасходуИзменение.Серия = СерииНоменклатурыКРасходуОстатки.Серия
		|			И (ЕСТЬNULL(СерииНоменклатурыКРасходуОстатки.КоличествоОстаток, 0) < 0)
		|ГДЕ
		|	ВЫБОР
		|			КОГДА СерииНоменклатурыКРасходуОстатки.СтруктурнаяЕдиница.ВидУчетаОрдерныхСкладов = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаОрдерныхСкладов.УчетОстатковПоСкладскимОрдерам)
		|				ТОГДА ЕСТЬNULL(СерииНоменклатурыКРасходуОстатки.КоличествоОстаток, 0) > 0
		|			КОГДА СерииНоменклатурыКРасходуОстатки.СтруктурнаяЕдиница.ВидУчетаОрдерныхСкладов = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаОрдерныхСкладов.УчетОстатковПоПрочимДокументам)
		|				ТОГДА ЕСТЬNULL(СерииНоменклатурыКРасходуОстатки.КоличествоОстаток, 0) < 0
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|	И &КонтрольОстатковПоЗапасамКОтгрузке
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияЗапасыКРасходуСоСкладовИзменение.НомерСтроки КАК НомерСтроки,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыКРасходуСоСкладовИзменение.ДокументОснование) КАК ДокументПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыКРасходуСоСкладовИзменение.Организация) КАК ОрганизацияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыКРасходуСоСкладовИзменение.СтруктурнаяЕдиница) КАК СтруктурнаяЕдиницаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыКРасходуСоСкладовИзменение.Номенклатура) КАК НоменклатураПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыКРасходуСоСкладовИзменение.Характеристика) КАК ХарактеристикаПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыКРасходуСоСкладовИзменение.Партия) КАК ПартияПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыКРасходуСоСкладовИзменение.ДокументОснование) КАК ДокументОснованиеПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ДвиженияЗапасыКРасходуСоСкладовИзменение.Ячейка) КАК ЯчейкаПредставление,
		|	ЗапасыКРасходуСоСкладовОстатки.СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы КАК ТипСтруктурнойЕдиницы,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЗапасыКРасходуСоСкладовОстатки.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
		|	ЕСТЬNULL(ДвиженияЗапасыКРасходуСоСкладовИзменение.КоличествоИзменение, 0) + ЕСТЬNULL(ЗапасыКРасходуСоСкладовОстатки.КоличествоОстаток, 0) КАК ОстатокЗапасыНаСкладах,
		|	ЕСТЬNULL(ЗапасыКРасходуСоСкладовОстатки.КоличествоОстаток, 0) КАК КоличествоОстатокЗапасыНаСкладах
		|ИЗ
		|	ДвиженияЗапасыКРасходуСоСкладовИзменение КАК ДвиженияЗапасыКРасходуСоСкладовИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыКРасходуСоСкладов.Остатки(
		|				&МоментКонтроля,
		|				(Организация, СтруктурнаяЕдиница, Номенклатура, Характеристика, Партия, ДокументОснование, Ячейка) В
		|					(ВЫБРАТЬ
		|						ДвиженияЗапасыКРасходуСоСкладовИзменение.Организация КАК Организация,
		|						ДвиженияЗапасыКРасходуСоСкладовИзменение.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|						ДвиженияЗапасыКРасходуСоСкладовИзменение.Номенклатура КАК Номенклатура,
		|						ДвиженияЗапасыКРасходуСоСкладовИзменение.Характеристика КАК Характеристика,
		|						ДвиженияЗапасыКРасходуСоСкладовИзменение.Партия КАК Партия,
		|						ДвиженияЗапасыКРасходуСоСкладовИзменение.ДокументОснование КАК ДокументОснование,
		|						ДвиженияЗапасыКРасходуСоСкладовИзменение.Ячейка КАК Ячейка
		|					ИЗ
		|						ДвиженияЗапасыКРасходуСоСкладовИзменение КАК ДвиженияЗапасыКРасходуСоСкладовИзменение)) КАК ЗапасыКРасходуСоСкладовОстатки
		|		ПО ДвиженияЗапасыКРасходуСоСкладовИзменение.Организация = ЗапасыКРасходуСоСкладовОстатки.Организация
		|			И ДвиженияЗапасыКРасходуСоСкладовИзменение.СтруктурнаяЕдиница = ЗапасыКРасходуСоСкладовОстатки.СтруктурнаяЕдиница
		|			И ДвиженияЗапасыКРасходуСоСкладовИзменение.Номенклатура = ЗапасыКРасходуСоСкладовОстатки.Номенклатура
		|			И ДвиженияЗапасыКРасходуСоСкладовИзменение.Характеристика = ЗапасыКРасходуСоСкладовОстатки.Характеристика
		|			И ДвиженияЗапасыКРасходуСоСкладовИзменение.Партия = ЗапасыКРасходуСоСкладовОстатки.Партия
		|			И ДвиженияЗапасыКРасходуСоСкладовИзменение.ДокументОснование = ЗапасыКРасходуСоСкладовОстатки.ДокументОснование
		|			И (ВЫБОР
		|				КОГДА ЗапасыКРасходуСоСкладовОстатки.СтруктурнаяЕдиница.УчетОстатковПоЯчейкам
		|					ТОГДА ДвиженияЗапасыКРасходуСоСкладовИзменение.Ячейка = ЗапасыКРасходуСоСкладовОстатки.Ячейка
		|				ИНАЧЕ ЛОЖЬ
		|			КОНЕЦ)
		|ГДЕ
		|	ВЫБОР
		|			КОГДА ЗапасыКРасходуСоСкладовОстатки.СтруктурнаяЕдиница.ВидУчетаОрдерныхСкладов = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаОрдерныхСкладов.УчетОстатковПоСкладскимОрдерам)
		|				ТОГДА ЕСТЬNULL(ЗапасыКРасходуСоСкладовОстатки.КоличествоОстаток, 0) > 0
		|			КОГДА ЗапасыКРасходуСоСкладовОстатки.СтруктурнаяЕдиница.ВидУчетаОрдерныхСкладов = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаОрдерныхСкладов.УчетОстатковПоПрочимДокументам)
		|				ТОГДА ЕСТЬNULL(ЗапасыКРасходуСоСкладовОстатки.КоличествоОстаток, 0) < 0
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ
		|	И &КонтрольОстатковПоЗапасамКОтгрузке
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		Запрос.УстановитьПараметр("КонтрольОстатковПоЗапасамКОтгрузке", ДополнительныеСвойства.КонтрольОстатковПоЗапасамКОтгрузке);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		Если НЕ МассивРезультатов[0].Пустой()
			ИЛИ НЕ МассивРезультатов[1].Пустой()
			ИЛИ НЕ МассивРезультатов[2].Пустой()
			ИЛИ НЕ МассивРезультатов[3].Пустой() Тогда
				ДокументОбъектРасходныйОрдер = ДокументСсылкаРасходныйОрдер.ПолучитьОбъект()
		КонецЕсли;
		
		// Отрицательный остаток запасов на складе.
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			КонтрольОстатковУНФ.ЗапасыНаСкладах(ДокументОбъектРасходныйОрдер, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток учета серий номенклатуры.
		Если НЕ МассивРезультатов[1].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
			КонтрольОстатковУНФ.СерииНоменклатуры(ДокументОбъектРасходныйОрдер, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток учета серий номенклатуры к расходу.
		Если НЕ МассивРезультатов[2].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
			КонтрольОстатковУНФ.СерииНоменклатурыКРасходу(ДокументОбъектРасходныйОрдер, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток запасов к расходу.
		Если ДополнительныеСвойства.КонтрольОстатковПоЗапасамКОтгрузке И НЕ МассивРезультатов[3].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[3].Выбрать();
			КонтрольОстатковУНФ.ЗапасыКРасходу(ДокументОбъектРасходныйОрдер, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКонтроль()

#Область ИнтерфейсПечати

Функция УниверсальныйЗапросПоДаннымДокумента(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = 
	"
	// :::Шапка
	|ВЫБРАТЬ
	|	РасходныйОрдер.Ссылка КАК Ссылка
	|	,""Расходный ордер"" КАК ПредставлениеРегистратора
	|	,РасходныйОрдер.Номер КАК Номер
	|	,РасходныйОрдер.Дата КАК ДатаДокумента
	|	,РасходныйОрдер.СтруктурнаяЕдиница КАК ПредставлениеСклада
	|	,РасходныйОрдер.Ячейка КАК ПредставлениеЯчейки
	|	,РасходныйОрдер.Организация.Префикс КАК Префикс
	|
	// :::Табличная часть "Запасы"
	|	,РасходныйОрдер.Запасы.(
	|		НомерСтроки КАК НомерСтроки
	|		,Неопределено КАК Содержание
	|		,Выбор КОГДА(ВЫРАЗИТЬ(РасходныйОрдер.Запасы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|			ТОГДА РасходныйОрдер.Запасы.Номенклатура.Наименование
	|			ИНАЧЕ ВЫРАЗИТЬ(РасходныйОрдер.Запасы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) КОНЕЦ КАК ПредставлениеНоменклатуры
	|		,Характеристика
	|		,Номенклатура.Артикул КАК Артикул
	|		,Номенклатура.Штрихкод КАК Штрихкод
	|		,Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры
	|		,Номенклатура.Склад КАК Склад
	|		,Номенклатура.Ячейка КАК Ячейка
	|		,ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|		,Количество КАК Количество
	|		,КлючСвязи
	|	) КАК ТаблицаЗапасы
	|
	// :::Табличная часть "СерииНоменклатуры"
	|	,РасходныйОрдер.СерииНоменклатуры.(
	|		Серия
	|		,КлючСвязи
	|	) КАК ТаблицаСерииНоменклатуры
	|ИЗ Документ.РасходныйОрдер КАК РасходныйОрдер
	|ГДЕ РасходныйОрдер.Ссылка В(&МассивОбъектов)
	|УПОРЯДОЧИТЬ ПО Ссылка, НомерСтроки";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура СформироватьРасходныйОрдер(ПечатнаяФорма, МассивОбъектов, ОбъектыПечати)
	Перем ПервыйДокумент, НомерСтрокиНачало, Ошибки;
	
	ПараметрыНоменклатуры = Новый Структура;
	
	ТабличныйДокумент = ПечатнаяФорма.ТабличныйДокумент;
	Макет = УправлениеПечатью.МакетПечатнойФормы(ПечатнаяФорма.ПолныйПутьКМакету);
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасходныйОрдер.Дата КАК ДатаДокумента,
		|	РасходныйОрдер.Организация КАК Организация,
		|	РасходныйОрдер.Номер КАК Номер,
		|	РасходныйОрдер.Организация.Префикс КАК Префикс,
		|	РасходныйОрдер.ПодписьКладовщика.Должность КАК ДолжностьКладовщика,
		|	РасходныйОрдер.ПодписьКладовщика.РасшифровкаПодписи КАК РасшифровкаПодписиКладовщика,
		|	РасходныйОрдер.Запасы.(
		|		НомерСтроки КАК НомерСтроки,
		|		Номенклатура.НаименованиеПолное КАК Запас,
		|		Номенклатура.Код КАК Код,
		|		Номенклатура.Артикул КАК Артикул,
		|		Номенклатура.Штрихкод КАК Штрихкод,
		|		ЕдиницаИзмерения КАК ЕдиницаХранения,
		|		Количество КАК Количество,
		|		Характеристика,
		|		КлючСвязи
		|	),
		|	РасходныйОрдер.СерииНоменклатуры.(
		|		Серия,
		|		КлючСвязи
		|	)
		|ИЗ
		|	Документ.РасходныйОрдер КАК РасходныйОрдер
		|ГДЕ
		|	РасходныйОрдер.Ссылка = &ТекущийДокумент
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		
		ВыборкаСтрокЗапасы = Шапка.Запасы.Выбрать();
		ВыборкаСтрокСерииНоменклатуры = Шапка.СерииНоменклатуры.Выбрать();
		
		СведенияОбОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента, ,);
		
		НомерДокумента = ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(Шапка.ДатаДокумента,
			Шапка.Номер, Шапка.Префикс);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Расходный ордер № %1 от %2'"), НомерДокумента,
			Формат(Шапка.ДатаДокумента, "ДЛФ=DD"));
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		ОбластьМакета.Параметры.ПредставлениеПолучателя = ПечатьДокументовУНФ.ОписаниеОрганизации(
			СведенияОбОрганизации, "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		
		Количество = 0;
		Пока ВыборкаСтрокЗапасы.Следующий() Цикл
			
			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокЗапасы);
			
			СтрокаСерииНоменклатуры = СерииНоменклатурыУНФ.СтрокаСерииНоменклатурыИзВыборки(
				ВыборкаСтрокСерииНоменклатуры, ВыборкаСтрокЗапасы.КлючСвязи);
			ОбластьМакета.Параметры.Запас = ПечатьДокументовУНФ.ПредставлениеНоменклатурыДляПечати(
				ВыборкаСтрокЗапасы.Запас, ВыборкаСтрокЗапасы.Характеристика, ВыборкаСтрокЗапасы.Артикул,
				СтрокаСерииНоменклатуры);
			
			ОбластьМакета.Параметры.ПредставлениеКодаНоменклатуры = ПечатьДокументовУНФ.ПредставлениеКодаНоменклатуры(
				ВыборкаСтрокЗапасы);
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			Количество = Количество + 1;
			
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
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
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "РасходныйОрдер");
	Если ПечатнаяФорма <> Неопределено Тогда
		
		ПечатнаяФорма.ТабличныйДокумент = Новый ТабличныйДокумент;
		ПечатнаяФорма.ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РасходныйОрдер_РасходныйОрдер";
		ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РасходныйОрдер.ПФ_MXL_РасходныйОрдер";
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Расходный ордер'");
		
		СформироватьРасходныйОрдер(ПечатнаяФорма, МассивОбъектов, ОбъектыПечати);
		
	КонецЕсли;
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "БланкТоварногоНаполнения");
	Если ПечатнаяФорма <> Неопределено Тогда
		
		ПечатнаяФорма.ТабличныйДокумент = Новый ТабличныйДокумент;
		ПечатнаяФорма.ТабличныйДокумент.КлючПараметровПечати = Обработки.ПечатьБланкТоварногоНаполнения.КлючПараметровПечати();
		ПечатнаяФорма.ПолныйПутьКМакету = Обработки.ПечатьБланкТоварногоНаполнения.ПолныйПутьКМакету();
		ПечатнаяФорма.СинонимМакета = Обработки.ПечатьБланкТоварногоНаполнения.ПредставлениеПФ();
		
		ДанныеОбъектовПечати = УниверсальныйЗапросПоДаннымДокумента(МассивОбъектов);
		Обработки.ПечатьБланкТоварногоНаполнения.СформироватьПФ(ПечатнаяФорма, ДанныеОбъектовПечати, ОбъектыПечати);
		
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
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "РасходныйОрдер";
	КомандаПечати.Представление = НСтр("ru = 'Расходный ордер'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "БланкТоварногоНаполнения";
	КомандаПечати.Представление = Обработки.ПечатьБланкТоварногоНаполнения.ПредставлениеПФ();
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 4;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли