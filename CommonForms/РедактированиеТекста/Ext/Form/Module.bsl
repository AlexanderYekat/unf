﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("Текст") Тогда
		Текст = Параметры.Текст;
	КонецЕсли;

	Если Параметры.Свойство("Заголовок") Тогда
		ЭтотОбъект.Заголовок = Параметры.Заголовок;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Ок(Команда)

	Закрыть(Текст);

КонецПроцедуры

#КонецОбласти
