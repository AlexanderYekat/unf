﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ВыполнитьАрхивациюЧековНаСервере(ПараметрКоманды);
	
	Оповестить("ОбновитьФормыПослеЗакрытияКассовойСмены");
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Архивация чеков ККМ выполнена'"));
	
КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВыполнитьАрхивациюЧековНаСервере(ПараметрКоманды)

	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтчетОРозничныхПродажах.Ссылка
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах
	|ГДЕ
	|	ОтчетОРозничныхПродажах.Ссылка В (&ПараметрКоманды)
	|	И ОтчетОРозничныхПродажах.Проведен
	|	И ОтчетОРозничныхПродажах.СтатусКассовойСмены = &СтатусКассовойСмены
	|	И ОтчетОРозничныхПродажах.КассаККМ.ТипКассы = &ТипКассыФискальныйРегистратор";
	
	Запрос.УстановитьПараметр("ПараметрКоманды", ПараметрКоманды);
	Запрос.УстановитьПараметр("СтатусКассовойСмены", Перечисления.СтатусыОтчетаОРозничныхПродажах.Закрыта);
	Запрос.УстановитьПараметр("ТипКассыФискальныйРегистратор", Перечисления.ТипыКассККМ.ФискальныйРегистратор);

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
	
		ОтчетОРозничныхПродажахОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Если ОтчетОРозничныхПродажахОбъект.СтатусКассовойСмены = Перечисления.СтатусыОтчетаОРозничныхПродажах.Закрыта Тогда
			
			ОписаниеОшибки = "";
			Документы.ОтчетОРозничныхПродажах.ВыполнитьАрхивациюЧековККМ(ОтчетОРозничныхПродажахОбъект, ОписаниеОшибки);
			
			Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = ОписаниеОшибки;
				Сообщение.Сообщить();
				
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры // ВыполнитьАрхивациюЧековНаСервере()

#КонецОбласти
