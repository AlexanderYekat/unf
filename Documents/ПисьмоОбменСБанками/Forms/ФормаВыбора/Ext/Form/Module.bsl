﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураОтбора = Неопределено;
	Если Параметры.Свойство("Отбор", СтруктураОтбора) И ТипЗнч(СтруктураОтбора) = Тип("Структура") Тогда
		
		Если СтруктураОтбора.Свойство("Организация") Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "Организация", СтруктураОтбора.Организация);
		КонецЕсли;
		
		Если СтруктураОтбора.Свойство("Банк") Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Банк", СтруктураОтбора.Банк);
		КонецЕсли;
		
		Если СтруктураОтбора.Свойство("СписокОрганизаций") Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "Организация", СтруктураОтбора.СписокОрганизаций, ВидСравненияКомпоновкиДанных.ВСписке);
		КонецЕсли;

		Если СтруктураОтбора.Свойство("СписокБанков") Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "Банк", СтруктураОтбора.СписокБанков, ВидСравненияКомпоновкиДанных.ВСписке);
		КонецЕсли;
		
		Если СтруктураОтбора.Свойство("ДляВалютногоКонтроля") Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "ДляВалютногоКонтроля", СтруктураОтбора.ДляВалютногоКонтроля);
		КонецЕсли;

		
	КонецЕсли;

	
КонецПроцедуры

#КонецОбласти