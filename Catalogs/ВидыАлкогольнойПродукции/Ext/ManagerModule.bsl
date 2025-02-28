﻿#Область ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияЕГАИС.ЭтоРасширеннаяВерсияГосИС() Тогда
		МодульИнтеграцияЕГАИСВызовСервера = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияЕГАИСВызовСервера");
		МодульИнтеграцияЕГАИСВызовСервера.ПриПолученииФормыСправочника(
			"ВидыАлкогольнойПродукции",
			ВидФормы,
			Параметры,
			ВыбраннаяФорма,
			ДополнительнаяИнформация,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли

#КонецОбласти
