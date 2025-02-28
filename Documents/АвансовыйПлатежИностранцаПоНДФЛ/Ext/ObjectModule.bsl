﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаЗапрета = Документы.АвансовыйПлатежИностранцаПоНДФЛ.ДатаЗапрета(Дата, НалоговыйПериод);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	УчетНДФЛ.СформироватьАвансовыйПлатежИностранца(Движения, Отказ, Организация, ДатаОперации, ПолучитьДанныеДляПроведения())
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АвансовыйПлатежИностранцаПоНДФЛ.НалоговыйПериод КАК Год,
	|	АвансовыйПлатежИностранцаПоНДФЛ.Сотрудник КАК ФизическоеЛицо,
	|	АвансовыйПлатежИностранцаПоНДФЛ.Сумма
	|ИЗ
	|	Документ.АвансовыйПлатежИностранцаПоНДФЛ КАК АвансовыйПлатежИностранцаПоНДФЛ
	|ГДЕ
	|	АвансовыйПлатежИностранцаПоНДФЛ.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли