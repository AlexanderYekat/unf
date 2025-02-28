﻿////////////////////////////////////////////////////////////////////////////////
// Общий модуль ИнтеграцияТорговыеПредложенияКлиент
// 
////////////////////////////////////////////////////////////////////////////////
// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

#Область БизнесСетьКлиент

#Область РегистрацияОрганизаций

// см. БизнесСетьКлиент.ОрганизацияНеПодключенаТребуетсяПовторноеПодключение
//
Функция ОрганизацияНеПодключенаТребуетсяПовторноеПодключение(Организация) Экспорт
	Возврат БизнесСетьКлиент.ОрганизацияНеПодключенаТребуетсяПовторноеПодключение(Организация);
КонецФункции

// см. БизнесСетьКлиент.ОткрытьФормуПодключенияОрганизации
//
Процедура ОткрытьФормуПодключенияОрганизации(
	Организация, Владелец = Неопределено, ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	БизнесСетьКлиент.ОткрытьФормуПодключенияОрганизации(Организация, Владелец, ОписаниеОповещенияОЗакрытии);
КонецПроцедуры

// см. БизнесСетьКлиент.ОткрытьФормуПодключенияОрганизацииСПроверкойПодключения
//
Процедура ОткрытьФормуПодключенияОрганизацииСПроверкойПодключения(
	Организация, Владелец = Неопределено, ОписаниеОповещенияОЗакрытии = Неопределено, Результат = Ложь) Экспорт
	
	БизнесСетьКлиент.ОткрытьФормуПодключенияОрганизацииСПроверкойПодключения(
		Организация, Владелец, ОписаниеОповещенияОЗакрытии, Результат);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти
