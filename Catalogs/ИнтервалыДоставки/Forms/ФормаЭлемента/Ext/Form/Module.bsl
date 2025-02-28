﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.ИдентификаторЯндекса) Тогда
		УстановитьПредупреждениеПриРедактировании(Элементы.ВремяДоставкиС);
		УстановитьПредупреждениеПриРедактировании(Элементы.ВремяДоставкиПо);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПредупреждениеПриРедактировании(Элемент)
	
	Элемент.ПредупреждениеПриРедактировании = НСтр("ru = 'Изменять интервал Яндекс.Доставки не рекомендуется.'");
	
КонецПроцедуры

#КонецОбласти