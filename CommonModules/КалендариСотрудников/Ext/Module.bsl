﻿
#Область ПрограммныйИнтерфейс

// Обработчик подписки на событие АктуализироватьЗаписиКалендаряПоИсточнику"
// Вызывается ПриЗаписи объекта, являющегося источником данных для записей календаря.
//
Процедура АктуализироватьЗаписиКалендаряПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписиПоИсточнику = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаписиКалендаря.Ссылка КАК Запись
		|ИЗ
		|	Справочник.ЗаписиКалендаряСотрудника КАК ЗаписиКалендаря
		|ГДЕ
		|	ЗаписиКалендаря.Источник = &Источник
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗаписиКалендаря.Начало,
		|	ЗаписиКалендаря.Окончание";
	
	Запрос.УстановитьПараметр("Источник", Источник.Ссылка);
	
	ЗаписиПоИсточнику = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Запись");
	
	Источник.ОбновитьЗаписьКалендаряПриЗаписиИсточника(ЗаписиПоИсточнику);
	
КонецПроцедуры

#КонецОбласти