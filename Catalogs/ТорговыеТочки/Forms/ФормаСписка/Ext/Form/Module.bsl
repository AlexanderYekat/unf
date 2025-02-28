﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
		
	ИначеЕсли Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда
		Организация = Параметры.Отбор.Владелец;
		Параметры.Отбор.Удалить("Владелец");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец", Организация, , ,
		ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец", Организация, , ,
		ЗначениеЗаполнено(Организация));
КонецПроцедуры

#КонецОбласти
