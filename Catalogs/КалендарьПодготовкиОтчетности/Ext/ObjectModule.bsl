﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Задача.ВидЗадачи = Перечисления.ВидыЗадачСобытийКалендаря.ЗаполнениеДанных Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ДатаДокументаОбработкиСобытия"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Наименование = ""+ Задача + " (%1)";
	Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Наименование, ПредставлениеПериода(ДатаНачалаСобытия, КонецДня(ДатаОкончанияСобытия), "ФП=Истина"));
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли