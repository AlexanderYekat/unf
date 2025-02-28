﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДаннымиСобытияУНФ.ПропуститьДозаполнениеДокумента(ЭтотОбъект, РежимЗаписи) Тогда
		Возврат;
	КонецЕсли;
	
	#Если МобильноеПриложениеСервер Тогда
		
		Если НЕ ЗначениеЗаполнено(КассаККМ) Тогда
			КассаККМ = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("КассаККММобильногоПриложения");
		КонецЕсли;
		Если ЗначениеЗаполнено(КассаККМ)
			И НЕ ЗначениеЗаполнено(РозничнаяТочка) Тогда
			РозничнаяТочка = КассаККМ.РозничнаяТочка;
		КонецЕсли;
		
	#КонецЕсли
	
	Если НЕ ПометкаУдаления Тогда
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
	КонецЕсли;
	
	СуммаДокумента = Товары.Итог("Сумма") - СуммаСкидки;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли