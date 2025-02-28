﻿#Область ПрограммныйИнтерфейс

// Получает заказ из шапки документа расчетов.
//
Функция ПолучитьЗаказ(Документ, ЭтоРасчетыСПокупателями, УстановитьЗаказ) Экспорт
	
	Если ЭтоРасчетыСПокупателями Тогда
		
		Если ТипЗнч(Документ) = Тип("ДокументСсылка.АктВыполненныхРабот")
			ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.ОтчетОПереработке") Тогда
			
			Заказ = Документ.ЗаказПокупателя;
			УстановитьЗаказ = Истина;
			
		ИначеЕсли (ТипЗнч(Документ) = Тип("ДокументСсылка.Взаимозачет")
			ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.ПриходнаяНакладная")
			ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.РасходнаяНакладная")
			ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.ЧекККМ"))
			И ТипЗнч(Документ.Заказ) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
			
			Заказ = Документ.Заказ;
			УстановитьЗаказ = Истина;
			
		Иначе
			
			Заказ = Документы.ЗаказПокупателя.ПустаяСсылка();
			УстановитьЗаказ = Ложь;
			
		КонецЕсли;
			
	Иначе
		
		Если ТипЗнч(Документ) = Тип("ДокументСсылка.ДополнительныеРасходы") Тогда
			
			Заказ = Документ.ЗаказПоставщику;
			УстановитьЗаказ = Истина;
			
		ИначеЕсли (ТипЗнч(Документ) = Тип("ДокументСсылка.Взаимозачет")
			ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.ПриходнаяНакладная")
			ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.РасходнаяНакладная"))
			И ТипЗнч(Документ.Заказ) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
			
			Заказ = Документ.Заказ;
			УстановитьЗаказ = Истина;
			
		Иначе
			
			Заказ = Документы.ЗаказПоставщику.ПустаяСсылка();
			УстановитьЗаказ = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Заказ;
	
КонецФункции

// Получает счет на оплату, связанный с документом расчетов.
//
Функция ПолучитьСчетНаОплатуПоОснованию(ДокументОснование, ЭтоРасчетыСПокупателями) Экспорт

	Если ЭтоРасчетыСПокупателями Тогда
		
		СчетНаОплату = Документы.СчетНаОплату.ПустаяСсылка();
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СчетНаОплату.Ссылка КАК СчетНаОплату
		|ИЗ
		|	Документ.СчетНаОплату КАК СчетНаОплату
		|ГДЕ
		|	СчетНаОплату.ДокументОснование = &ДокументОснование";
		
		Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Количество() = 1
			И Выборка.Следующий() Тогда
			
			СчетНаОплату = Выборка.СчетНаОплату;
			
		КонецЕсли;
		
	Иначе
		
		СчетНаОплату = Документы.СчетНаОплатуПоставщика.ПустаяСсылка();
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СчетНаОплатуПоставщика.Ссылка КАК СчетНаОплату
		|ИЗ
		|	Документ.СчетНаОплатуПоставщика КАК СчетНаОплатуПоставщика
		|ГДЕ
		|	СчетНаОплатуПоставщика.ДокументОснование = &ДокументОснование";
		
		Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Количество() = 1
			И Выборка.Следующий() Тогда
			
			СчетНаОплату = Выборка.СчетНаОплату;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СчетНаОплату;

КонецФункции

// Получает документ расчетов, связанный с счетом на оплату.
//
Функция ПолучитьДокументРасчетовПоОснованиюСчетНаОплату(ДокументОснование, ЭтоРасчетыСПокупателями) Экспорт
	
	ДокументРасчетов = Неопределено;
	Если ЭтоРасчетыСПокупателями Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	АктВыполненныхРабот.Ссылка КАК ДокументРасчетов
		|ИЗ
		|	Документ.АктВыполненныхРабот КАК АктВыполненныхРабот
		|ГДЕ
		|	АктВыполненныхРабот.ДокументОснование = &ДокументОснование
		|	И АктВыполненныхРабот.Проведен
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РасходнаяНакладная.Ссылка
		|ИЗ
		|	Документ.РасходнаяНакладная КАК РасходнаяНакладная
		|ГДЕ
		|	РасходнаяНакладная.ДокументОснование = &ДокументОснование
		|	И РасходнаяНакладная.Проведен";
		
		Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Количество() = 1
			И Выборка.Следующий() Тогда
			
			ДокументРасчетов = Выборка.ДокументРасчетов;
			
		КонецЕсли;
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПриходнаяНакладная.Ссылка КАК ДокументРасчетов
		|ИЗ
		|	Документ.ПриходнаяНакладная КАК ПриходнаяНакладная
		|ГДЕ
		|	ПриходнаяНакладная.ДокументОснование = &ДокументОснование
		|	И ПриходнаяНакладная.Проведен";
		
		Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Количество() = 1
			И Выборка.Следующий() Тогда
			
			ДокументРасчетов = Выборка.ДокументРасчетов;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДокументРасчетов;

КонецФункции
	

// Получает счет на оплату, связанный с документом расчетов.
//
Функция ПолучитьСчетНаОплату(Документ, Заказ, ЭтоРасчетыСПокупателями) Экспорт

	Если ЭтоРасчетыСПокупателями Тогда
		
		СчетНаОплату = Документы.СчетНаОплату.ПустаяСсылка();
		
		Если ТипЗнч(Документ) = Тип("ДокументСсылка.АктВыполненныхРабот")
			ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.ОтчетОПереработке")
			ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.РасходнаяНакладная")
			ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.ОтчетКомиссионера")
			ИЛИ (ТипЗнч(Документ) = Тип("ДокументСсылка.ЗаказПокупателя")
			И Документ.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд) Тогда
			
			ДокументОснование = Документ;
			ДокументОснование2 = Заказ;
		Иначе
			ДокументОснование = Заказ;
			ДокументОснование2 = Документ;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДокументОснование) Тогда
			Возврат СчетНаОплату;
		КонецЕсли;
		
		Если ДокументОснование.Ссылка.Метаданные().Реквизиты.Найти("ДокументОснование") <> Неопределено Тогда
			Если ТипЗнч(ДокументОснование.ДокументОснование) = Тип("ДокументСсылка.СчетНаОплату")
				И ЗначениеЗаполнено(ДокументОснование.ДокументОснование) Тогда
				СчетНаОплату = ДокументОснование.ДокументОснование;
			КонецЕсли;
		КонецЕсли;
		
		Если СчетНаОПлату.Пустая() Тогда
			СчетНаОплату = ПолучитьСчетНаОплатуПоОснованию(ДокументОснование, ЭтоРасчетыСПокупателями);
			Если СчетНаОПлату.Пустая() Тогда
				СчетНаОплату = ПолучитьСчетНаОплатуПоОснованию(ДокументОснование2, ЭтоРасчетыСПокупателями);
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		СчетНаОплату = Документы.СчетНаОплатуПоставщика.ПустаяСсылка();
		
		Если ЗначениеЗаполнено(Документ)
			И Документ.Ссылка.Метаданные().Реквизиты.Найти("ДокументОснование") <> Неопределено Тогда
			Если ТипЗнч(Документ.ДокументОснование) = Тип("ДокументСсылка.СчетНаОплатуПоставщика")
				И ЗначениеЗаполнено(Документ.ДокументОснование) Тогда
				Возврат Документ.ДокументОснование;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Заказ) Тогда
			Возврат СчетНаОплату;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СчетНаОплатуПоставщика.Ссылка КАК СчетНаОплату
		|ИЗ
		|	Документ.СчетНаОплатуПоставщика КАК СчетНаОплатуПоставщика
		|ГДЕ
		|	СчетНаОплатуПоставщика.ДокументОснование = &ДокументОснование";
		
		Запрос.УстановитьПараметр("ДокументОснование", Заказ);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Количество() = 1
			И Выборка.Следующий() Тогда
			
			СчетНаОплату = Выборка.СчетНаОплату;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СчетНаОплату;

КонецФункции

Процедура ПолучитьЗаказИСчетНаОплатуПоДокументу(ДанныеДокумента, ЭтоРасчетыСПокупателями) Экспорт
	
	Заказ = ПолучитьЗаказ(ДанныеДокумента.Документ, ЭтоРасчетыСПокупателями, ДанныеДокумента.УстановитьЗаказ);
	ДанныеДокумента.Заказ = Заказ;
	
	СчетНаОплату = ПолучитьСчетНаОплату(ДанныеДокумента.Документ, Заказ, ЭтоРасчетыСПокупателями);
	ДанныеДокумента.СчетНаОплату = СчетНаОплату;
	
КонецПроцедуры

#КонецОбласти