﻿#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.ЗначенияЗаполнения.Свойство("ОбъектЗагрузки") Тогда
		Если ТипЗнч(Параметры.ЗначенияЗаполнения.ОбъектЗагрузки) = Тип("Строка") Тогда
			ОбъектЗагрузки = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
				Параметры.ЗначенияЗаполнения.ОбъектЗагрузки, Ложь);
		Иначе
			ОбъектЗагрузки = Параметры.ЗначенияЗаполнения.ОбъектЗагрузки;
		КонецЕсли;
		Объект.ОбъектЗагрузки =ОбъектЗагрузки;
	КонецЕсли;

	Если Параметры.ЗначенияЗаполнения.Свойство("Наименование") Тогда
		Объект.Наименование = Параметры.ЗначенияЗаполнения.Наименование;
	КонецЕсли;

	Если Параметры.ЗначенияЗаполнения.Свойство("СоответствияПолей") Тогда
		Для Каждого строка Из Параметры.ЗначенияЗаполнения.СоответствияПолей Цикл
			НоваяСтрока = Объект.СоответствияПолей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, строка);
		КонецЦикла;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ИдентификаторПоставляемогоЭлемента) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, 
			"СоответствияПолейЗаполнитьИзПоставляемойНастройки", "Видимость", Ложь);
			
	Иначе
		МенеджерСправочника = Справочники.СоответствиеПолейЗагрузкиДанныхИзВнешнегоИсточника;
		Если Объект.ИдентификаторПоставляемогоЭлемента = МенеджерСправочника.ИдентификаторWildberriesДетальный()
			Или Объект.ИдентификаторПоставляемогоЭлемента
			= МенеджерСправочника.ИдентификаторWildberriesУведомлениеОВыкупе() Тогда
			
			ТекстЗаголовка = НСтр("ru='По умолчанию для Wildberries'");
			
		ИначеЕсли Объект.ИдентификаторПоставляемогоЭлемента = МенеджерСправочника.ИдентификаторOzonПозаказный() Тогда
			
			ТекстЗаголовка = НСтр("ru='По умолчанию для Ozon'");
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, 
			"СоответствияПолейЗаполнитьИзПоставляемойНастройки", "Заголовок", ТекстЗаголовка);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедураИФункции

&НаКлиенте
Процедура ПоляСоответствияВТабличнуюЧасть(ДобавляемыеПоля)

	ПараметрыОтбора = Новый Структура;
	Для Каждого ЭлементСоответствия Из ДобавляемыеПоля Цикл

		ИмяПоляОтбора = ?(ТипЗнч(ЭлементСоответствия.Ключ) = Тип(
			"ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения"), "ДополнительныйРеквизит", "ИмяПоля");

		ПараметрыОтбора.Очистить();
		ПараметрыОтбора.Вставить(ИмяПоляОтбора, ЭлементСоответствия.Ключ);

		Если Объект.СоответствияПолей.НайтиСтроки(ПараметрыОтбора).Количество() > 0 Тогда

			Продолжить;

		КонецЕсли;

		НоваяСтрока = Объект.СоответствияПолей.Добавить();
		НоваяСтрока[ИмяПоляОтбора] = ЭлементСоответствия.Ключ;
		НоваяСтрока.ПредставлениеПоля = ЭлементСоответствия.Значение;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ДоступныеПоляЗагрузкиДанныхИзВнешнегоИсточника()

	Объект.СоответствияПолей.Очистить();

	ДоступныеПоляЗагрузки = Справочники.СоответствиеПолейЗагрузкиДанныхИзВнешнегоИсточника.ДоступныеПоляЗагрузкиДанныхИзВнешнегоИсточника(
		Объект.ОбъектЗагрузки, "", Истина);
	Для Каждого ЭлементСтруктуры Из ДоступныеПоляЗагрузки Цикл

		НоваяСтрока = Объект.СоответствияПолей.Добавить();
		НоваяСтрока.ИмяПоля = ЭлементСтруктуры.Ключ;
		НоваяСтрока.ПредставлениеПоля = ЭлементСтруктуры.Значение;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоляПоставляемойНастройкой()
	
	Объект.СоответствияПолей.Очистить();
	
	Настройка = Справочники.СоответствиеПолейЗагрузкиДанныхИзВнешнегоИсточника
		.ПоставляемаяНастройкаПоИдентификатору(Объект.ИдентификаторПоставляемогоЭлемента).Настройка;
		
	СправочникОбъект = РеквизитФормыВЗначение("Объект");
	СправочникОбъект.ЗаполнитьНастройкиПолей(Настройка, Ложь);	
	ЗначениеВРеквизитФормы(СправочникОбъект, "Объект");
	
КонецПроцедуры
#КонецОбласти

#Область ЭлементыФормы

&НаКлиенте
Процедура ОбъектЗагрузкиПриИзменении(Элемент)

	Объект.СоответствияПолей.Очистить();

КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура ДобавитьПоле(Команда)

	ВыбранныеПоля = Новый Массив;
	Для Каждого СтрокаТаблицы Из Объект.СоответствияПолей Цикл

		ВыбранныеПоля.Добавить(?(ПустаяСтрока(СтрокаТаблицы.ИмяПоля), СтрокаТаблицы.ДополнительныйРеквизит,
			СтрокаТаблицы.ИмяПоля));

	КонецЦикла;

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВыбранныеПоля", ВыбранныеПоля);
	ПараметрыОткрытия.Вставить("ОбъектЗагрузки", Объект.ОбъектЗагрузки);
	ПараметрыОткрытия.Вставить("ИмяТабличнойЧасти", Объект.ИмяТабличнойЧасти);

	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаДобавленныхПолей", ЭтотОбъект);

	ОткрытьФорму("Справочник.СоответствиеПолейЗагрузкиДанныхИзВнешнегоИсточника.Форма.ФормаПодбораПолей",
		ПараметрыОткрытия, ЭтотОбъект, , , , ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаДобавленныхПолей(Результат, ДополнительныеПараметры) Экспорт

	Если ТипЗнч(Результат) <> Тип("Соответствие") Тогда

		Возврат;

	КонецЕсли;

	ПоляСоответствияВТабличнуюЧасть(Результат);

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПустую(Команда)

	НоваяСтрока = Объект.СоответствияПолей.Добавить();
	НоваяСтрока.ИмяПоля = Неопределено;
	НоваяСтрока.ПредставлениеПоля = НСтр("ru ='Не используется'");

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИзТабличногоДокумента(Команда)

	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаЗаполненияПолей", ЭтотОбъект);

	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru ='Табличная часть будет очищена и заполнена заново. Продолжить?'"),
		РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИзПоставляемойНастройки(Команда)

	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаЗаполненияПолейПоставляемой", ЭтотОбъект);

	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru ='Табличная часть будет очищена и заполнена заново. Продолжить?'"),
		РежимДиалогаВопрос.ДаНет);

КонецПроцедуры
&НаКлиенте
Процедура ОбработкаЗаполненияПолей(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда

		ДоступныеПоляЗагрузкиДанныхИзВнешнегоИсточника();

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаполненияПолейПоставляемой(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда

		ЗаполнитьПоляПоставляемойНастройкой();

	КонецЕсли;

КонецПроцедуры

#КонецОбласти