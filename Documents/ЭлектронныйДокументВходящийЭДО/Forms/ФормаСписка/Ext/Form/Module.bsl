﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбщегоНазначенияБЭДКлиент.ЗаблокироватьОткрытиеФормыНаМобильномКлиенте(Отказ);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	Оповестить(ИнтерфейсДокументовЭДОКлиент.ИмяСобытияОбновленияТекущихДелЭДО());

КонецПроцедуры

#КонецОбласти