﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияЕГАИС.ПометитьНаУдалениеПрисоединенныеФайлыЕГАИС(ЭтотОбъект, Истина);
	
	Сопоставлено = Справочники.КлассификаторОрганизацийЕГАИС.РассчитатьСопоставлено(
		ТорговыйОбъект,
		Контрагент,
		СоответствуетОрганизации);
	
	Если ОбщегоНазначенияЕГАИС.ЭтоРасширеннаяВерсияГосИС() Тогда
		МодульИнтеграцияИСПереопределяемый = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияИСПереопределяемый");
		МодульИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли