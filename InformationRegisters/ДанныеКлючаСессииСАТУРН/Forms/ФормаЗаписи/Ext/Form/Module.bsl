﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДанныеКлюча = ТекущийОбъект.Данные.Получить();
	Если ДанныеКлюча <> Неопределено Тогда
		Токен         = ДанныеКлюча.ТокенАвторизации;
		Идентификатор = ДанныеКлюча.Идентификатор;
		ДействуетДо   = ДанныеКлюча.ДействуетДо;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТокенОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элементы.Токен.РежимПароля = Не Элементы.Токен.РежимПароля;
	
КонецПроцедуры

#КонецОбласти