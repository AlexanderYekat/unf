﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗначениеПоискаНоменклатуры = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода ЗначениеПоискаНоменклатуры.
//
&НаКлиенте
Процедура ЗначениеПоискаНоменклатурыПриИзменении(Элемент)
	
	Закрыть(ЗначениеПоискаНоменклатуры);
	
КонецПроцедуры

#КонецОбласти
