﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	РазрешеноРедактированиеЦенДокументов = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ЦеныНоменклатуры);
	Элементы.Список.ТолькоПросмотр = Не РазрешеноРедактированиеЦенДокументов;

КонецПроцедуры

#КонецОбласти