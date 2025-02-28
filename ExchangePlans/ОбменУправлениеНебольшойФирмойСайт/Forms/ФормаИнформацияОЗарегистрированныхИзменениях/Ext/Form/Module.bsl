﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УзелОбмена = Параметры.УзелОбмена;
	
	Если УзелОбмена = ПланыОбмена.ОбменУправлениеНебольшойФирмойСайт.ЭтотУзел() Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	ОбновитьДеревоИзмененийСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ДеревоИзменений.ПолучитьЭлементы().Количество() = 0 Тогда
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Изменения не зарегистрированы.'")
			,,,
			БиблиотекаКартинок.Информация32);
			
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДеревоОбъектНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектОчистка(Элемент, СтандартнаяОбработка)
	
	Родитель = Элементы.ДеревоИзменений.ТекущиеДанные.ПолучитьРодителя();
	
	Если Родитель = НеОпределено Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьРегистрациюСервер(Элементы.ДеревоИзменений.ТекущиеДанные.Объект);
	Родитель.ПолучитьЭлементы().Удалить(Элементы.ДеревоИзменений.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьДеревоИзмененийСервер();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДеревоИзмененийСервер()
	
	СтруктураИзменений = ОбменССайтом.ЗаполнитьСтруктуруИзмененийДляУзла(УзелОбмена);
	
	СтрокиДерева = ДеревоИзменений.ПолучитьЭлементы();
	СтрокиДерева.Очистить();
	
	Если СтруктураИзменений.Товары.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'Товары'");
	
		Для Каждого ЭлементМассива Из СтруктураИзменений.Товары Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураИзменений.Услуги.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'Услуги'");
	
		Для Каждого ЭлементМассива Из СтруктураИзменений.Услуги Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураИзменений.Ресурсы.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'Ресурсы'");
	
		Для Каждого ЭлементМассива Из СтруктураИзменений.Ресурсы Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураИзменений.Файлы.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'Файлы'");
		
		Для Каждого ЭлементМассива Из СтруктураИзменений.Файлы Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураИзменений.Заказы.Количество() > 0 Тогда
		
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ВидОбъекта = НСтр("ru = 'Заказы'");
		
		Для Каждого ЭлементМассива Из СтруктураИзменений.Заказы Цикл
			СтрокаОбъекта = СтрокаДерева.ПолучитьЭлементы().Добавить();
			СтрокаОбъекта.Объект = ЭлементМассива;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРегистрациюСервер(ДанныеСсылка);
	
	ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбмена, ДанныеСсылка);
	
КонецПроцедуры

#КонецОбласти


