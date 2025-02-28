﻿////////////////////////////////////////////////////////////////////////////////
// ПосетителиВызовСервера содержит процедуры и функции 
// для обработки посетителей.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызов серверного метода загрузки внешних данных из клиентского модуля.
//
// Параметры:
//  ДанныеНастройки - Справочник.НастройкиЗагрузкиДанныхСчетчиковПодсчетаПосетителей - данные настройки загрузки.
//
Процедура ЗагрузитьВнешниеДанные(ДанныеНастройки) Экспорт
	
	Посетители.ЗагрузитьВнешниеДанные(ДанныеНастройки);
	
КонецПроцедуры // ЗагрузкаВнешнихДанных()

#КонецОбласти
