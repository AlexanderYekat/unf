﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.НастройкаОбмена) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "НастройкаОбмена", Параметры.НастройкаОбмена);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
