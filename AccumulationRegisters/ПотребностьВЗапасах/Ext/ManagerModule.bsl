﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура создает пустую временную таблицу изменения движений.
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	ПотребностьВЗапасах.НомерСтроки КАК НомерСтроки,
	|	ПотребностьВЗапасах.Организация КАК Организация,
	|	ПотребностьВЗапасах.Склад КАК Склад,
	|	ПотребностьВЗапасах.ТипДвижения КАК ТипДвижения,
	|	ПотребностьВЗапасах.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ПотребностьВЗапасах.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	ПотребностьВЗапасах.Номенклатура КАК Номенклатура,
	|	ПотребностьВЗапасах.Характеристика КАК Характеристика,
	|	ПотребностьВЗапасах.Количество КАК КоличествоПередЗаписью,
	|	ПотребностьВЗапасах.Количество КАК КоличествоИзменение,
	|	ПотребностьВЗапасах.Количество КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияПотребностьВЗапасахИзменение
	|ИЗ
	|	РегистрНакопления.ПотребностьВЗапасах КАК ПотребностьВЗапасах");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияПотребностьВЗапасахИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()

// Процедура - Изменяет таблицу движений с учетом текущих остатков
//
// Параметры:
//  Регистратор		 - 	ДокументСсылка - Документ движений
//  ТаблицаДвижений	 - 	ТаблицаЗначений - Таблица движений регистра
//
Процедура ДобавитьДвиженияСУчетомСкладовИОстатков(Регистратор, ТаблицаДвижений) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаДвижений", ТаблицаДвижений);
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДвижений.Организация КАК Организация,
	|	ТаблицаДвижений.ТипДвижения КАК ТипДвижения,
	|	ТаблицаДвижений.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ТаблицаДвижений.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	ТаблицаДвижений.Склад КАК Склад,
	|	ТаблицаДвижений.Номенклатура КАК Номенклатура,
	|	ТаблицаДвижений.Характеристика КАК Характеристика
	|ПОМЕСТИТЬ ТаблицаДвижений
	|ИЗ
	|	&ТаблицаДвижений КАК ТаблицаДвижений";
	Запрос.Выполнить();
	
	// Установка исключительной блокировки контролируемых заказов покупателей
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаДвижений.Организация КАК Организация,
	|	ТаблицаДвижений.ТипДвижения КАК ТипДвижения,
	|	ТаблицаДвижений.Номенклатура КАК Номенклатура,
	|	ТаблицаДвижений.Характеристика КАК Характеристика,
	|	ТаблицаДвижений.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ТаблицаДвижений.ЗаказНаПроизводство КАК ЗаказНаПроизводство
	|ИЗ
	|	ТаблицаДвижений КАК ТаблицаДвижений";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ПотребностьВЗапасах");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
	
	Для каждого КолонкаРезультатЗапроса Из РезультатЗапроса.Колонки Цикл
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных(КолонкаРезультатЗапроса.Имя, КолонкаРезультатЗапроса.Имя);
	КонецЦикла;
	Блокировка.Заблокировать();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Организация КАК Организация,
	|	ВложенныйЗапрос.Склад КАК Склад,
	|	ВложенныйЗапрос.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ВложенныйЗапрос.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	ВложенныйЗапрос.Характеристика КАК Характеристика,
	|	СУММА(ВложенныйЗапрос.Количество) КАК Количество
	|ИЗ
	|	(ВЫБРАТЬ
	|		РегистрОстатки.Организация КАК Организация,
	|		РегистрОстатки.Склад КАК Склад,
	|		РегистрОстатки.ЗаказПокупателя КАК ЗаказПокупателя,
	|		РегистрОстатки.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|		РегистрОстатки.Номенклатура КАК Номенклатура,
	|		РегистрОстатки.Характеристика КАК Характеристика,
	|		РегистрОстатки.КоличествоОстаток КАК Количество
	|	ИЗ
	|		РегистрНакопления.ПотребностьВЗапасах.Остатки(
	|				,
	|				(Организация, ТипДвижения, ЗаказПокупателя, ЗаказНаПроизводство, Номенклатура, Характеристика) В
	|					(ВЫБРАТЬ
	|						ТаблицаДвижений.Организация КАК Организация,
	|						ТаблицаДвижений.ТипДвижения КАК ТипДвижения,
	|						ТаблицаДвижений.ЗаказПокупателя КАК ЗаказПокупателя,
	|						ТаблицаДвижений.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|						ТаблицаДвижений.Номенклатура КАК Номенклатура,
	|						ТаблицаДвижений.Характеристика КАК Характеристика
	|					ИЗ
	|						ТаблицаДвижений КАК ТаблицаДвижений)) КАК РегистрОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокумента.Организация,
	|		ДвиженияДокумента.Склад,
	|		ДвиженияДокумента.ЗаказПокупателя,
	|		ДвиженияДокумента.ЗаказНаПроизводство,
	|		ДвиженияДокумента.Номенклатура,
	|		ДвиженияДокумента.Характеристика,
	|		ВЫБОР
	|			КОГДА ДвиженияДокумента.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|				ТОГДА ЕСТЬNULL(ДвиженияДокумента.Количество, 0)
	|			ИНАЧЕ -ЕСТЬNULL(ДвиженияДокумента.Количество, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ПотребностьВЗапасах КАК ДвиженияДокумента
	|	ГДЕ
	|		ДвиженияДокумента.Регистратор = &Регистратор
	|		И (ДвиженияДокумента.Организация, ДвиженияДокумента.ТипДвижения, ДвиженияДокумента.ЗаказПокупателя, ДвиженияДокумента.ЗаказНаПроизводство, ДвиженияДокумента.Номенклатура, ДвиженияДокумента.Характеристика) В
	|				(ВЫБРАТЬ
	|					ТаблицаДвижений.Организация КАК Организация,
	|					ТаблицаДвижений.ТипДвижения КАК ТипДвижения,
	|					ТаблицаДвижений.ЗаказПокупателя КАК ЗаказПокупателя,
	|					ТаблицаДвижений.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|					ТаблицаДвижений.Номенклатура КАК Номенклатура,
	|					ТаблицаДвижений.Характеристика КАК Характеристика
	|				ИЗ
	|					ТаблицаДвижений КАК ТаблицаДвижений)) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Организация,
	|	ВложенныйЗапрос.Склад,
	|	ВложенныйЗапрос.ЗаказПокупателя,
	|	ВложенныйЗапрос.ЗаказНаПроизводство,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.Характеристика";
	ТаблицаОстатки = Запрос.Выполнить().Выгрузить();
	ТаблицаОстатки.Индексы.Добавить("Организация, ЗаказПокупателя, ЗаказНаПроизводство, Номенклатура, Характеристика");
	ТаблицаОстатки.Индексы.Добавить("Организация, Склад, ЗаказПокупателя, ЗаказНаПроизводство, Номенклатура, Характеристика");
	
	НоваяТаблицаДвижений = ТаблицаДвижений.СкопироватьКолонки();
	СтруктураОтбора = Новый Структура;
	
	// Итерация 1: поиск остатка по нужному складу
	Для каждого СтрокаТаблицы Из ТаблицаДвижений Цикл
		Если СтрокаТаблицы.Количество <= 0 Тогда
			Прервать;
		КонецЕсли; 
		СтруктураОтбора.Очистить();
		СтруктураОтбора.Вставить("Организация", СтрокаТаблицы.Организация);
		СтруктураОтбора.Вставить("ЗаказПокупателя", СтрокаТаблицы.ЗаказПокупателя);
		СтруктураОтбора.Вставить("ЗаказНаПроизводство", СтрокаТаблицы.ЗаказНаПроизводство);
		СтруктураОтбора.Вставить("Номенклатура", СтрокаТаблицы.Номенклатура);
		СтруктураОтбора.Вставить("Характеристика", СтрокаТаблицы.Характеристика);
		СтруктураОтбора.Вставить("Склад", СтрокаТаблицы.Склад);
		НайденныеСтроки = ТаблицаОстатки.НайтиСтроки(СтруктураОтбора);
		Для каждого СтрокаОстатка Из НайденныеСтроки Цикл
			Если СтрокаОстатка.Количество <= 0 Тогда
				Продолжить;
			КонецЕсли; 
			Количество = Мин(СтрокаТаблицы.Количество, СтрокаОстатка.Количество);
			НоваяСтрока = НоваяТаблицаДвижений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			НоваяСтрока.Количество = Количество;
			СтрокаТаблицы.Количество = СтрокаТаблицы.Количество - Количество;
			СтрокаОстатка.Количество = СтрокаОстатка.Количество - Количество;
			Если СтрокаТаблицы.Количество <= 0 Тогда
				Прервать;
			КонецЕсли; 
		КонецЦикла; 
	КонецЦикла; 
	
	// Итерация 2: поиск остатка на других складах
	Для каждого СтрокаТаблицы Из ТаблицаДвижений Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Склад) Тогда
			// Только если используется учет потребности по складам
			Продолжить;
		КонецЕсли; 
		Если СтрокаТаблицы.Количество <= 0 Тогда
			Прервать;
		КонецЕсли; 
		СтруктураОтбора.Очистить();
		СтруктураОтбора.Вставить("Организация", СтрокаТаблицы.Организация);
		СтруктураОтбора.Вставить("ЗаказПокупателя", СтрокаТаблицы.ЗаказПокупателя);
		СтруктураОтбора.Вставить("ЗаказНаПроизводство", СтрокаТаблицы.ЗаказНаПроизводство);
		СтруктураОтбора.Вставить("Номенклатура", СтрокаТаблицы.Номенклатура);
		СтруктураОтбора.Вставить("Характеристика", СтрокаТаблицы.Характеристика);
		НайденныеСтроки = ТаблицаОстатки.НайтиСтроки(СтруктураОтбора);
		Для каждого СтрокаОстатка Из НайденныеСтроки Цикл
			Если СтрокаОстатка.Количество <= 0 Тогда
				Продолжить;
			КонецЕсли; 
			Количество = Мин(СтрокаТаблицы.Количество, СтрокаОстатка.Количество);
			НоваяСтрока = НоваяТаблицаДвижений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			НоваяСтрока.Количество = Количество;
			СтрокаТаблицы.Количество = СтрокаТаблицы.Количество - Количество;
			СтрокаОстатка.Количество = СтрокаОстатка.Количество - Количество;
			ИндексВставки = НоваяТаблицаДвижений.Индекс(НоваяСтрока);
			НоваяСтрокаПриход = НоваяТаблицаДвижений.Вставить(ИндексВставки);
			ЗаполнитьЗначенияСвойств(НоваяСтрокаПриход, СтрокаТаблицы);
			НоваяСтрокаПриход.Количество = Количество;
			НоваяСтрокаПриход.ВидДвижения = ВидДвиженияНакопления.Приход;
			НоваяСтрокаРасход = НоваяТаблицаДвижений.Вставить(ИндексВставки);
			ЗаполнитьЗначенияСвойств(НоваяСтрокаРасход, НоваяСтрокаПриход);
			НоваяСтрокаРасход.Количество = - Количество;
			НоваяСтрокаРасход.Склад = СтрокаОстатка.Склад;
			Если СтрокаТаблицы.Количество <= 0 Тогда
				Прервать;
			КонецЕсли; 
		КонецЦикла; 
	КонецЦикла;
	
	// Потребность закрывается только в объеме, не превышающем остаток
	
	ТаблицаДвижений = НоваяТаблицаДвижений;
	
КонецПроцедуры

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
	|	И ЗначениеРазрешено(Склад)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли