﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Для каждого ТекущаяЗапись Из ЭтотОбъект Цикл
		ТекущаяЗапись.ДатаСостояния = ТекущаяДатаСеанса();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли