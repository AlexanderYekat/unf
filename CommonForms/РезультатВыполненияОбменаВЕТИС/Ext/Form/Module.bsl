﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементДанных Из Параметры.Изменения Цикл
		
		Если ТипЗнч(ЭлементДанных.Объект) = Тип("Соответствие") Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Изменения.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементДанных,,"Объект");
		
		Если ТипЗнч(ЭлементДанных.Объект) = Тип("Массив") Тогда
			СписокОбъектов = Новый СписокЗначений;
			СписокОбъектов.ЗагрузитьЗначения(ЭлементДанных.Объект);
			НоваяСтрока.Объект = СписокОбъектов;
		Иначе
			НоваяСтрока.Объект = ЭлементДанных.Объект;
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмененияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Изменения.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.ИзмененияХозяйствующийСубъект Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, ТекущиеДанные.ХозяйствующийСубъект);
		
	ИначеЕсли Поле = Элементы.ИзмененияДокументОснование Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, ТекущиеДанные.ДокументОснование);
		
	ИначеЕсли Поле = Элементы.ИзмененияВходящееСообщение Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, ТекущиеДанные.ВходящееСообщение);
		
	ИначеЕсли Поле = Элементы.ИзмененияИсходящееСообщение Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, ТекущиеДанные.ИсходящееСообщение);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти