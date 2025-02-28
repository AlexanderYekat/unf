﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолеСообщения = Параметры.Сообщение;
	Заголовок     = Параметры.Заголовок;
	
	Параметры.Свойство("ГиперссылкаТекст",     ГиперссылкаТекст);
	Параметры.Свойство("ГиперссылкаНавигация", ГиперссылкаНавигация);
	Параметры.Свойство("ГиперссылкаИмяФормы",  ГиперссылкаИмяФормы);
	Параметры.Свойство("ГиперссылкаПараметры", ГиперссылкаПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ГиперссылкаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ПустаяСтрока(ГиперссылкаНавигация) Тогда
		Попытка
			ПерейтиПоНавигационнойСсылке(ГиперссылкаНавигация);
		Исключение
			// обработка исключения не нужна
		КонецПопытки;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ГиперссылкаИмяФормы) Тогда
		Попытка
			ОткрытьФорму(ГиперссылкаИмяФормы, ГиперссылкаПараметры);
		Исключение
			// обработка исключения не нужна
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
