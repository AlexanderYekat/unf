﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		ПроверяемыеРеквизиты.Добавить("Организация");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("УчетПоНесколькимСкладам") Тогда
		ПроверяемыеРеквизиты.Добавить("СтруктурнаяЕдиница");
	КонецЕсли;
	
	ПроверяемыеРеквизиты.Добавить("ПолитикаУчетаСерий");
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");

#КонецЕсли
