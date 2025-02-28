﻿#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(Список);
	
	Если Параметры.Свойство("ОрганизацияДляОтбора") И НЕ Константы.УчетПоКомпании.Получить() Тогда
		Параметры.Отбор.Вставить("Организация", Параметры.ОрганизацияДляОтбора);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
