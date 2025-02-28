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

#КонецОбласти

#КонецОбласти

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаПеремещениеПоЯчейкам, СтруктураДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПеремещениеПоЯчейкамЗапасы.НомерСтроки КАК НомерСтроки,
	|	ПеремещениеПоЯчейкамЗапасы.КлючСвязи КАК КлючСвязи,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ПеремещениеПоЯчейкамЗапасы.Ссылка.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ПеремещениеПоЯчейкамЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ВЫБОР
	|		КОГДА ПеремещениеПоЯчейкамЗапасы.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПеремещениеПоЯчейкам.ИзОднойВНесколько)
	|			ТОГДА ПеремещениеПоЯчейкамЗапасы.Ссылка.Ячейка
	|		ИНАЧЕ ПеремещениеПоЯчейкамЗапасы.Ячейка
	|	КОНЕЦ КАК Ячейка,
	|	ВЫБОР
	|		КОГДА ПеремещениеПоЯчейкамЗапасы.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПеремещениеПоЯчейкам.ИзОднойВНесколько)
	|			ТОГДА ПеремещениеПоЯчейкамЗапасы.Ячейка
	|		ИНАЧЕ ПеремещениеПоЯчейкамЗапасы.Ссылка.Ячейка
	|	КОНЕЦ КАК ЯчейкаПолучатель,
	|	ПеремещениеПоЯчейкамЗапасы.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &ИспользоватьХарактеристики
	|			ТОГДА ПеремещениеПоЯчейкамЗапасы.Характеристика
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Характеристика,
	|	ВЫБОР
	|		КОГДА &ИспользоватьПартии
	|			ТОГДА ПеремещениеПоЯчейкамЗапасы.Партия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Партия,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ПеремещениеПоЯчейкамЗапасы.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
	|			ТОГДА ПеремещениеПоЯчейкамЗапасы.Количество
	|		ИНАЧЕ ПеремещениеПоЯчейкамЗапасы.Количество * ПеремещениеПоЯчейкамЗапасы.ЕдиницаИзмерения.Коэффициент
	|	КОНЕЦ КАК Количество
	|ИЗ
	|	Документ.ПеремещениеПоЯчейкам.Запасы КАК ПеремещениеПоЯчейкамЗапасы
	|ГДЕ
	|	ПеремещениеПоЯчейкамЗапасы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка.Дата КАК ДатаСобытия,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииСерийНоменклатуры.Движение) КАК Операция,
	|	ТаблицаСерииНоменклатуры.Серия КАК Серия,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
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
	|	Документ.ПеремещениеПоЯчейкам.Запасы КАК ТаблицаЗапасы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеПоЯчейкам.СерииНоменклатуры КАК ТаблицаСерииНоменклатуры
	|		ПО ТаблицаЗапасы.Ссылка = ТаблицаСерииНоменклатуры.Ссылка
	|			И ТаблицаЗапасы.КлючСвязи = ТаблицаСерииНоменклатуры.КлючСвязи
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|		ПО ТаблицаЗапасы.Номенклатура = ПолитикиУчетаСерий.Владелец
	|			И (&Организация = ПолитикиУчетаСерий.Организация)
	|			И (&СтруктурнаяЕдиница = ПолитикиУчетаСерий.СтруктурнаяЕдиница)
	|ГДЕ
	|	ТаблицаСерииНоменклатуры.Ссылка = &Ссылка
	|	И &ИспользоватьСерииНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ТаблицаСерииНоменклатуры.Серия КАК Серия,
	|	&Организация КАК Организация,
	|	ТаблицаЗапасы.Номенклатура КАК Номенклатура,
	|	ТаблицаЗапасы.Характеристика КАК Характеристика,
	|	ТаблицаЗапасы.Партия КАК Партия,
	|	ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ВЫБОР
	|		КОГДА ТаблицаЗапасы.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПеремещениеПоЯчейкам.ИзОднойВНесколько)
	|			ТОГДА ТаблицаЗапасы.Ссылка.Ячейка
	|		ИНАЧЕ ТаблицаЗапасы.Ячейка
	|	КОНЕЦ КАК Ячейка,
	|	ВЫБОР
	|		КОГДА ТаблицаСерииНоменклатуры.Количество = 0
	|			ТОГДА 1
	|		ИНАЧЕ ТаблицаСерииНоменклатуры.Количество
	|	КОНЕЦ КАК Количество,
	|	ТаблицаЗапасы.Ссылка.Дата КАК ДатаСобытия,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииСерийНоменклатуры.Расход) КАК Операция,
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
	|	Документ.ПеремещениеПоЯчейкам.Запасы КАК ТаблицаЗапасы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеПоЯчейкам.СерииНоменклатуры КАК ТаблицаСерииНоменклатуры
	|		ПО ТаблицаЗапасы.Ссылка = ТаблицаСерииНоменклатуры.Ссылка
	|			И ТаблицаЗапасы.КлючСвязи = ТаблицаСерииНоменклатуры.КлючСвязи
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|		ПО ТаблицаЗапасы.Номенклатура = ПолитикиУчетаСерий.Владелец
	|			И (&Организация = ПолитикиУчетаСерий.Организация)
	|			И (&СтруктурнаяЕдиница = ПолитикиУчетаСерий.СтруктурнаяЕдиница)
	|ГДЕ
	|	ТаблицаСерииНоменклатуры.Ссылка = &Ссылка
	|	И &ИспользоватьСерииНоменклатуры
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаЗапасы.Ссылка.Дата,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	ТаблицаСерииНоменклатуры.Серия,
	|	&Организация,
	|	ТаблицаЗапасы.Номенклатура,
	|	ТаблицаЗапасы.Характеристика,
	|	ТаблицаЗапасы.Партия,
	|	ТаблицаЗапасы.Ссылка.СтруктурнаяЕдиница,
	|	ВЫБОР
	|		КОГДА ТаблицаЗапасы.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПеремещениеПоЯчейкам.ИзОднойВНесколько)
	|			ТОГДА ТаблицаЗапасы.Ячейка
	|		ИНАЧЕ ТаблицаЗапасы.Ссылка.Ячейка
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТаблицаСерииНоменклатуры.Количество = 0
	|			ТОГДА 1
	|		ИНАЧЕ ТаблицаСерииНоменклатуры.Количество
	|	КОНЕЦ,
	|	ТаблицаЗапасы.Ссылка.Дата,
	|	ЗНАЧЕНИЕ(Перечисление.ОперацииСерийНоменклатуры.Приход),
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
	|	КОНЕЦ
	|ИЗ
	|	Документ.ПеремещениеПоЯчейкам.Запасы КАК ТаблицаЗапасы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеПоЯчейкам.СерииНоменклатуры КАК ТаблицаСерииНоменклатуры
	|		ПО ТаблицаЗапасы.Ссылка = ТаблицаСерииНоменклатуры.Ссылка
	|			И ТаблицаЗапасы.КлючСвязи = ТаблицаСерииНоменклатуры.КлючСвязи
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|		ПО ТаблицаЗапасы.Номенклатура = ПолитикиУчетаСерий.Владелец
	|			И (&Организация = ПолитикиУчетаСерий.Организация)
	|			И (&СтруктурнаяЕдиница = ПолитикиУчетаСерий.СтруктурнаяЕдиница)
	|ГДЕ
	|	ТаблицаСерииНоменклатуры.Ссылка = &Ссылка
	|	И &ИспользоватьСерииНоменклатуры");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаПеремещениеПоЯчейкам);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("ИспользоватьХарактеристики", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьХарактеристики);
	Запрос.УстановитьПараметр("ИспользоватьПартии", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьПартии);
	
	Запрос.УстановитьПараметр("ИспользоватьСерииНоменклатуры", СтруктураДополнительныеСвойства.УчетнаяПолитика.ИспользоватьСерииНоменклатуры);
	Запрос.УстановитьПараметр("ОстаткиСерийНоменклатуры", СтруктураДополнительныеСвойства.УчетнаяПолитика.ОстаткиСерийНоменклатуры);
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", ДокументСсылкаПеремещениеПоЯчейкам.СтруктурнаяЕдиница);

	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗапасыНаСкладах", МассивРезультатов[0].Выгрузить());
	Выборка = МассивРезультатов[0].Выбрать();
	Пока Выборка.Следующий() Цикл
			
		НоваяСтрока = СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаЗапасыНаСкладах.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Приход;
		НоваяСтрока.Ячейка = Выборка.ЯчейкаПолучатель;
		
	КонецЦикла;
	
	// Серии номенклатуры
	
	ТаблицаСерииНоменклатуры = МассивРезультатов[2].Выгрузить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДвиженияСерииНоменклатуры", ТаблицаСерииНоменклатуры);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерииНоменклатурыГарантии", Новый ТаблицаЗначений);
	
	ПараметрыОтбора = Новый Структура("ОстаткиСерийНоменклатуры", Истина);
	ОстаткиСерийНоменклатурыСтроки = ТаблицаСерииНоменклатуры.НайтиСтроки(ПараметрыОтбора);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСерииНоменклатуры", ТаблицаСерииНоменклатуры.Скопировать(ОстаткиСерийНоменклатурыСтроки));
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылкаПеремещениеПоЯчейкам, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если ПроведениеДокументовУНФ.КонтрольОстатковВыключен() Тогда
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Если временные таблицы "ДвиженияЗапасыНаСкладахИзменение", "ДвиженияЗапасыИзменение"
	// содержат записи, необходимо выполнить контроль реализации товаров.
	
	Если СтруктураВременныеТаблицы.ДвиженияЗапасыНаСкладахИзменение Тогда

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
		|	НомерСтроки");

		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();

		// Отрицательный остаток запасов на складе.
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ДокументОбъектПеремещениеПоЯчейкам = ДокументСсылкаПеремещениеПоЯчейкам.ПолучитьОбъект();
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			КонтрольОстатковУНФ.ЗапасыНаСкладахСписком(ДокументОбъектПеремещениеПоЯчейкам, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ВыполнитьКонтроль()

#Область ИнтерфейсПечати

Процедура СформироватьПеремещениеЗапасовПоЯчейкам(ОписаниеПечатнойФормы, МассивОбъектов, ОбъектыПечати)
	Перем ПервыйДокумент, НомерСтрокиНачало, Ошибки;
	
	ТабличныйДокумент = ОписаниеПечатнойФормы.ТабличныйДокумент;
	Макет = УправлениеПечатью.МакетПечатнойФормы(ОписаниеПечатнойФормы.ПолныйПутьКМакету);
	
	ДанныеПечати = Новый Структура;
	
	Для каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало, ДанныеПечати);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПеремещениеПоЯчейкам.Номер КАК НомерДокумента,
		|	ПеремещениеПоЯчейкам.Дата КАК ДатаДокумента,
		|	ПеремещениеПоЯчейкам.ВидОперации КАК ВидОперации,
		|	ПеремещениеПоЯчейкам.Организация КАК Организация,
		|	ПеремещениеПоЯчейкам.Организация.Префикс КАК Префикс,
		|	ПеремещениеПоЯчейкам.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ПеремещениеПоЯчейкам.ПодписьКладовщика.РасшифровкаПодписи КАК РасшифровкаПодписиКладовщика,
		|	ПеремещениеПоЯчейкам.ПодписьИсполнителя.РасшифровкаПодписи КАК РасшифровкаПодписиИсполнителя,
		|	ПеремещениеПоЯчейкам.Ячейка КАК Ячейка
		|ИЗ
		|	Документ.ПеремещениеПоЯчейкам КАК ПеремещениеПоЯчейкам
		|ГДЕ
		|	ПеремещениеПоЯчейкам.Ссылка = &ТекущийДокумент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПеремещениеПоЯчейкамЗапасы.НомерСтроки,
		|	ПеремещениеПоЯчейкамЗапасы.Ячейка,
		|	ПеремещениеПоЯчейкамЗапасы.Номенклатура.Код КАК КодНоменклатуры,
		|	ПеремещениеПоЯчейкамЗапасы.Номенклатура.Артикул КАК Артикул,
		|	ПеремещениеПоЯчейкамЗапасы.Номенклатура.Штрихкод КАК Штрихкод,
		|	ВЫБОР
		|		КОГДА (ВЫРАЗИТЬ(ПеремещениеПоЯчейкамЗапасы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))) = """"
		|			ТОГДА ПеремещениеПоЯчейкамЗапасы.Номенклатура.Наименование
		|		ИНАЧЕ ВЫРАЗИТЬ(ПеремещениеПоЯчейкамЗапасы.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))
		|	КОНЕЦ КАК ПредставлениеНоменклатуры,
		|	ПеремещениеПоЯчейкамЗапасы.Характеристика,
		|	ПРЕДСТАВЛЕНИЕ(ПеремещениеПоЯчейкамЗапасы.Партия) КАК Партия,
		|	ПеремещениеПоЯчейкамЗапасы.Количество,
		|	ПеремещениеПоЯчейкамЗапасы.ЕдиницаИзмерения,
		|	ПеремещениеПоЯчейкамЗапасы.КлючСвязи
		|ИЗ
		|	Документ.ПеремещениеПоЯчейкам.Запасы КАК ПеремещениеПоЯчейкамЗапасы
		|ГДЕ
		|	ПеремещениеПоЯчейкамЗапасы.Ссылка = &ТекущийДокумент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПеремещениеПоЯчейкамЗапасы.Ссылка,
		|	МАКСИМУМ(ПеремещениеПоЯчейкамЗапасы.НомерСтроки) КАК КоличествоПозиций,
		|	СУММА(ПеремещениеПоЯчейкамЗапасы.Количество) КАК ИтогКоличество
		|ИЗ
		|	Документ.ПеремещениеПоЯчейкам.Запасы КАК ПеремещениеПоЯчейкамЗапасы
		|ГДЕ
		|	ПеремещениеПоЯчейкамЗапасы.Ссылка = &ТекущийДокумент
		|
		|СГРУППИРОВАТЬ ПО
		|	ПеремещениеПоЯчейкамЗапасы.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПеремещениеПоЯчейкамСерииНоменклатуры.Серия,
		|	ПеремещениеПоЯчейкамСерииНоменклатуры.КлючСвязи
		|ИЗ
		|	Документ.ПеремещениеПоЯчейкам.СерииНоменклатуры КАК ПеремещениеПоЯчейкамСерииНоменклатуры
		|ГДЕ
		|	ПеремещениеПоЯчейкамСерииНоменклатуры.Ссылка = &ТекущийДокумент";
		
		РезультатВыполнения = Запрос.ВыполнитьПакет();
		
		ШапкаДокумента = РезультатВыполнения[0].Выбрать();
		ШапкаДокумента.Следующий();
		
		ТабличнаяЧасть = РезультатВыполнения[1].Выбрать();
		
		ВыборкаИтогов = РезультатВыполнения[2].Выбрать();
		ВыборкаИтогов.Следующий();
		
		ВыборкаСерииНоменклатуры = РезультатВыполнения[3].Выбрать();
		
		//::: Заголовок
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		НомерДокумента = ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(ШапкаДокумента.ДатаДокумента, ШапкаДокумента.НомерДокумента, ШапкаДокумента.Префикс);
		ТекстЗаголовка = НСтр("ru = 'Перемещение запасов по ячейкам № '") + НомерДокумента + НСтр("ru = ' от '") + Формат(ШапкаДокумента.ДатаДокумента, "ДЛФ=DD");
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("СтруктурнаяЕдиница", ШапкаДокумента.СтруктурнаяЕдиница);
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// ::: Шапка таблицы
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ДанныеПечати.Вставить("ВидПеремещения", НСтр("ru = 'Вид перемещения: '") + Строка(ШапкаДокумента.ВидОперации));
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// ::: Строки таблицы
		ОбластьМакета = Макет.ПолучитьОбласть("СтрокаТаблицы");
		
		ЭтоПеремещениеИзОднойВНесколько = (ШапкаДокумента.ВидОперации = Перечисления.ВидыОперацийПеремещениеПоЯчейкам.ИзОднойВНесколько);
		ПараметрыНоменклатуры = Новый Структура;
		
		Пока ТабличнаяЧасть.Следующий() Цикл
			
			ДанныеПечати.Очистить();
			ДанныеПечати.Вставить("НомерСтроки", ТабличнаяЧасть.НомерСтроки);
			
			ЯчейкаОтправитель = ?(ЭтоПеремещениеИзОднойВНесколько,	ШапкаДокумента.Ячейка, ТабличнаяЧасть.Ячейка);
			ЯчейкаПолучать = ?(ЭтоПеремещениеИзОднойВНесколько, 	ТабличнаяЧасть.Ячейка, ШапкаДокумента.Ячейка);
			
			ДанныеПечати.Вставить("ЯчейкаОтправитель", ЯчейкаОтправитель);
			ДанныеПечати.Вставить("ЯчейкаПолучать", ЯчейкаПолучать);
			
			СтрокаСерииНоменклатуры = СерииНоменклатурыУНФ.СтрокаСерииНоменклатурыИзВыборки(ВыборкаСерииНоменклатуры, ТабличнаяЧасть.КлючСвязи);
			
			ПараметрыНоменклатуры.Очистить();
			ПараметрыНоменклатуры.Вставить("ПредставлениеНоменклатуры", ТабличнаяЧасть.ПредставлениеНоменклатуры);
			ПараметрыНоменклатуры.Вставить("ПредставлениеХарактеристики", ТабличнаяЧасть.Характеристика);
			ПараметрыНоменклатуры.Вставить("ПредставлениеСерииНоменклатуры", СтрокаСерииНоменклатуры);
			
			ДанныеПечати.Вставить("ПредставлениеНоменклатуры", ПечатьДокументовУНФ.ПредставлениеНоменклатуры(ПараметрыНоменклатуры));
			ДанныеПечати.Вставить("ПредставлениеПартии", ТабличнаяЧасть.Партия);
			ДанныеПечати.Вставить("Количество", ТабличнаяЧасть.Количество);
			ДанныеПечати.Вставить("ЕдиницаИзмерения", ТабличнаяЧасть.ЕдиницаИзмерения);
			
			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;
		
		// ::: Подвал таблицы
		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалТаблицы");
		ДанныеПечати.Очистить();
		
		ДанныеПечати.Вставить("ИтогКоличество", ВыборкаИтогов.ИтогКоличество);
		
		Если ВыборкаИтогов.ИтогКоличество = 0 Тогда
			
			КоличествоПеремещенныхЗапасовПрописью = НСтр("ru = 'В документе не указаны перемещаемые запасы.'");
			
		ИначеЕсли ЭтоПеремещениеИзОднойВНесколько Тогда
			
			КоличествоПеремещенныхЗапасовПрописью = НСтр("ru = 'Из ячейки ""%1"" изъято позиций: %2.
			|Общим количеством: %3.'");
			
		Иначе
			
			КоличествоПеремещенныхЗапасовПрописью = НСтр("ru = 'В ячейку ""%1"" поступило позиций: %2.
			|Общим количеством: %3.'");
			
		КонецЕсли;
		
		КоличествоПеремещенныхЗапасовПрописью = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			КоличествоПеремещенныхЗапасовПрописью, 
			ШапкаДокумента.Ячейка, 
			?(ВыборкаИтогов.КоличествоПозиций = Неопределено, 0, ВыборкаИтогов.КоличествоПозиций), 
			ЧислоПрописью(
				?(ВыборкаИтогов.ИтогКоличество = Неопределено, 0, ВыборкаИтогов.ИтогКоличество), 
				"L= ru_RU;SN=true;FN=false;FS=false", "единица, единицы, единиц, ж, , , , , 0"));
		
		ДанныеПечати.Вставить("КоличествоПеремещенныхЗапасовПрописью", КоличествоПеремещенныхЗапасовПрописью);
		
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		//::: Подписи
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(ШапкаДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
КонецПроцедуры // СформироватьПеремещениеЗапасовПоЯчейкам()

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
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "ПеремещениеЗапасовПоЯчейкам");
	Если ПечатнаяФорма <> Неопределено Тогда
		
		ПечатнаяФорма.ТабличныйДокумент = Новый ТабличныйДокумент;
		ПечатнаяФорма.ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПеремещениеПоЯчейкам_ПеремещениеЗапасовПоЯчейкам";
		ПечатнаяФорма.ПолныйПутьКМакету = "Документ.ПеремещениеПоЯчейкам.ПФ_MXL_ПеремещениеЗапасовПоЯчейкам";
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Перемещение запасов по ячейкам'");
		
		СформироватьПеремещениеЗапасовПоЯчейкам(ПечатнаяФорма, МассивОбъектов, ОбъектыПечати);
		
	КонецЕсли;
	
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
	КомандаПечати.Идентификатор = "ПеремещениеЗапасовПоЯчейкам";
	КомандаПечати.Представление = НСтр("ru = 'Перемещение запасов по ячейкам'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли