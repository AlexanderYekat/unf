﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Макет = ПланыОбмена.СОтборами.ПолучитьМакет("ПодробнаяИнформация");
	ПолеHTMLДокумента = Макет.ПолучитьТекст();
	
	Заголовок = НСтр("ru = 'Распределенная информационная база с фильтром'");

КонецПроцедуры

#КонецОбласти
