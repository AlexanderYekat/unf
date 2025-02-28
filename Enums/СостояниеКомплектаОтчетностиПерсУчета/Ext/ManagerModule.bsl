﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ВключатьСостояниеСкорректирован = Истина;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	ДанныеВыбора.Добавить(СведенияСформированы);
	ДанныеВыбора.Добавить(СведенияОтправлены);
	ДанныеВыбора.Добавить(СведенияНеБудутПередаваться);
	
	Если Параметры.Свойство("НеВключатьСостояниеСкорректирован")
		И Параметры.НеВключатьСостояниеСкорректирован = Истина Тогда
		
		ВключатьСостояниеСкорректирован = Ложь;
	КонецЕсли;	
	
	Если ВключатьСостояниеСкорректирован Тогда
		ДанныеВыбора.Добавить(СведенияСкорректированы);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли