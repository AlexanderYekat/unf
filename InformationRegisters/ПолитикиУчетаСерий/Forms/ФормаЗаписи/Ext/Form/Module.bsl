﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ЗначенияЗаполнения") И Параметры.ЗначенияЗаполнения.Свойство("Владелец") Тогда
		Запись.Владелец = Параметры.ЗначенияЗаполнения.Владелец;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Запись.Организация) Тогда
		Запись.Организация = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Запись.СтруктурнаяЕдиница) Тогда
		Запись.СтруктурнаяЕдиница = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнойСклад");
	КонецЕсли;
	
	ПолитикаУчетаСерийПриОткрытии = Запись.ПолитикаУчетаСерий;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолитикаУчетаСерийПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Запись.ПолитикаУчетаСерий) Тогда 
		Возврат
	КонецЕсли;
	
	СтруктураПроверки = ИзменениеПолитикиУчетаСерийВозможно();
	
	Если Не СтруктураПроверки.ИзменениеВозможно Тогда
		
		Запись.ПолитикаУчетаСерий = СтруктураПроверки.ПолитикаДоИзменения;
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Серии данной номенклатуры по текущим измерениям участвуют в движениях. Изменение/установка политики не возможна'");
		Сообщение.Сообщить();
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ИзменениеПолитикиУчетаСерийВозможно()
		
	СтруктураВозврата = Новый Структура("ИзменениеВозможно, ПолитикаДоИзменения"); 
	
	Если Не ТипЗнч(Запись.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		СтруктураВозврата.ИзменениеВозможно = Истина;
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Номенклатура", Запись.Владелец);
	Запрос.УстановитьПараметр("Организация", Запись.Организация);
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", Запись.СтруктурнаяЕдиница);
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДвиженияСерииНоменклатуры.Серия КАК Серия
	|ИЗ
	|	РегистрНакопления.ДвиженияСерииНоменклатуры КАК ДвиженияСерииНоменклатуры
	|ГДЕ
	|	ДвиженияСерииНоменклатуры.Номенклатура = &Номенклатура
	|	И НЕ ДвиженияСерииНоменклатуры.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	И ДвиженияСерииНоменклатуры.Организация = &Организация
	|	И ДвиженияСерииНоменклатуры.СтруктурнаяЕдиница = &СтруктурнаяЕдиница";
	
	Если Запрос.Выполнить().Пустой() Тогда
		СтруктураВозврата.ИзменениеВозможно = Истина;
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПолитикаУчетаСерийПриОткрытии) И 
		Запись.ПолитикаУчетаСерий.ТипПолитики = Запись.Владелец.ПолитикаУчетаСерий.ТипПолитики Тогда
		СтруктураВозврата.ИзменениеВозможно = Истина;
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	Если Не ПолитикаУчетаСерийПриОткрытии.ТипПолитики = Запись.ПолитикаУчетаСерий.ТипПолитики Тогда
		СтруктураВозврата.ИзменениеВозможно = Ложь;
		СтруктураВозврата.ПолитикаДоИзменения = ПолитикаУчетаСерийПриОткрытии;
		Возврат СтруктураВозврата;
	Иначе
		СтруктураВозврата.ИзменениеВозможно = Истина;
		Возврат СтруктураВозврата;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
