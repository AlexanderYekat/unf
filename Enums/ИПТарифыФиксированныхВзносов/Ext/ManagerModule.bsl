﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяДата = ОбщегоНазначения.ТекущаяДатаПользователя();
	
	ДанныеВыбора = Новый СписокЗначений;
	// п.1.2 ст.430 НК РФ
	ДанныеВыбора.Добавить(Перечисления.ИПТарифыФиксированныхВзносов.Единый);
	
	Если РегламентированнаяОтчетностьУСНВызовСервера.ДоступенТарифДляВоенныхПенсионеров(ТекущаяДата) Тогда
		// п.1.4 ст.430 НК РФ
		ДанныеВыбора.Добавить(Перечисления.ИПТарифыФиксированныхВзносов.ВоенныйПенсионер);
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьУСНВызовСервера.ПрименяетсяТарифУчастникСЭЗ(ТекущаяДата)
		И ИнтеграцияСБанкамиПовтИсп.ИнтеграцияВИнформационнойБазеВключена() Тогда
		// п.1.3 ст.430 НК РФ
		ДанныеВыбора.Добавить(Перечисления.ИПТарифыФиксированныхВзносов.УчастникСЭЗнаНТ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли