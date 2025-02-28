﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("Документы") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Параметры.Свойство("Режим", Режим);
	Если Режим = ТипСообщенияИзмененныеДокументы() Тогда
		Заголовок = НСтр("ru = 'Список измененных документов'");
		Для каждого Документ Из Параметры.Документы Цикл
			НоваяСтрока = СписокДокументов.Добавить();
			НоваяСтрока.Документ = Документ;
		КонецЦикла; 
	ИначеЕсли Режим = ТипСообщенияНеверноВыбранаСтатьяДДС() Тогда
		Заголовок = НСтр("ru = 'Список документов с неверной статьей ДДС'");
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокДокументовСтатья", "Видимость", Истина);
		Для каждого СтруктураОписания Из Параметры.Документы Цикл
			НоваяСтрока = СписокДокументов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураОписания);
		КонецЦикла; 
	ИначеЕсли Режим = ТипСообщенияНесоответствиеДоговоровОрганизаций() Тогда
		Заголовок = НСтр("ru = 'Список документов с несоответствием договоров и организаций'");
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, Параметры.Тип, "Видимость", Истина);
		Для каждого СтруктураОписания Из Параметры.Документы Цикл
			НоваяСтрока = СписокДокументов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураОписания);
		КонецЦикла; 
	ИначеЕсли Режим = ТипСообщенияОткрытыеКассовыеСмены() Тогда
		Заголовок = НСтр("ru = 'Открытые кассовые смены'");
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокДокументовКассаККМ", "Видимость", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаЗакрытьСмену", "Видимость", Истина);
		Для каждого СтруктураОписания Из Параметры.Документы Цикл
			НоваяСтрока = СписокДокументов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураОписания);
		КонецЦикла; 
	ИначеЕсли Режим = ТипСообщенияЧекиВСостоянииРезерва() Тогда
		Заголовок = НСтр("ru = 'Чеки в состоянии резерва'");
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокДокументовКассаККМ", "Видимость", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаПометитьНаУдаление", "Видимость", Истина);
		Для каждого СтруктураОписания Из Параметры.Документы Цикл
			НоваяСтрока = СписокДокументов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураОписания);
		КонецЦикла; 
	ИначеЕсли Режим = ТипСообщенияЧекиСДвижениями() Тогда
		Заголовок = НСтр("ru = 'Чеки с незавершенной архивацией'");
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокДокументовКассаККМ", "Видимость", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаПометитьНаУдаление", "Видимость", Истина);
		Для каждого СтруктураОписания Из Параметры.Документы Цикл
			НоваяСтрока = СписокДокументов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураОписания);
		КонецЦикла; 
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументов

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Поле = Элементы.СписокДокументовДокумент
		ИЛИ Поле = Элементы.СписокДокументовСтатья Тогда
		ПоказатьЗначение(, ТекущаяСтрока.Документ);
	ИначеЕсли Поле = Элементы.СписокДокументовОрганизация1 Тогда
		ПоказатьЗначение(, ТекущаяСтрока.Организация);
	ИначеЕсли Поле = Элементы.СписокДокументовОрганизация1
		ИЛИ Поле = Элементы.СписокДокументовОрганизация2 Тогда
		ПоказатьЗначение(, ТекущаяСтрока.Организация);
	ИначеЕсли Поле = Элементы.СписокДокументовДоговор1
		ИЛИ Поле = Элементы.СписокДокументовДоговор2 Тогда
		ПоказатьЗначение(, ТекущаяСтрока.Договор);
	ИначеЕсли Поле = Элементы.СписокДокументовПодчиненныйДокумент1
		ИЛИ Поле = Элементы.СписокДокументовПодчиненныйДокумент2 Тогда
		ПоказатьЗначение(, ТекущаяСтрока.ПодчиненныйДокумент);
	ИначеЕсли Поле = Элементы.СписокДокументовОрганизацияДоговора Тогда
		ПоказатьЗначение(, ТекущаяСтрока.ОрганизацияДоговора);
	ИначеЕсли Поле = Элементы.СписокДокументовОрганизацияДокумента Тогда
		ПоказатьЗначение(, ТекущаяСтрока.ОрганизацияДокумента);
	ИначеЕсли Поле = Элементы.СписокДокументовДоговорДокумента Тогда
		ПоказатьЗначение(, ТекущаяСтрока.ДоговорДокумента);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	ТекущаяСтрока = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ПоказатьЗначение(, ТекущаяСтрока.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСмену(Команда)
	
	ТекущаяСтрока = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ЗакрытьСменуСервер(ТекущаяСтрока.Документ) Тогда
		СписокДокументов.Удалить(ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	
	ТекущаяСтрока = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ПометитьНаУдалениеСервер(ТекущаяСтрока.Документ) Тогда
		СписокДокументов.Удалить(ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗакрытьСменуСервер(ОтчетОРозничныхПродажах)
	
	ОтчетОРозничныхПродажахОбъект = ОтчетОРозничныхПродажах.ПолучитьОбъект();
	ОписаниеОшибки = "";
	
	Если ОтчетОРозничныхПродажахОбъект.ПометкаУдаления Тогда
		ТекстСообщения = НСтр("ru = 'Отчет о розничных продажах помечен на удаление. Требуется снять пометку и выполнить повторное проведение или удалить связанные чеки.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;
	КонецЕсли; 
	
	Если НЕ ОтчетОРозничныхПродажахОбъект.Проведен Тогда
		// Может свидетельствовать об ошибке при закрытии смены
		ТекстСообщения = НСтр("ru = 'Не удается провести отчет о розничных продажах. Следует устранить ошибки и выполнить закрытие кассовой смены повторно.'");
		Если НЕ ОтчетОРозничныхПродажахОбъект.ПроверитьЗаполнение() Тогда
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;
		КонецЕсли; 
		НачатьТранзакцию();
		Попытка
			ОтчетОРозничныхПродажахОбъект.Записать(РежимЗаписиДокумента.Проведение);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ОбщегоНазначения.СообщитьПользователю(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;
		КонецПопытки; 
	КонецЕсли; 
	
	Если ОтчетОРозничныхПродажахОбъект.СтатусКассовойСмены <> Перечисления.СтатусыОтчетаОРозничныхПродажах.Закрыта
		И ОтчетОРозничныхПродажахОбъект.СтатусКассовойСмены <> Перечисления.СтатусыОтчетаОРозничныхПродажах.ЗакрытаЧекиЗаархивированы Тогда
		Результат = Документы.ОтчетОРозничныхПродажах.ЗакрытьОтчетОРозничныхПродажах(ОтчетОРозничныхПродажахОбъект);
		Если Результат.ОтчетОРозничныхПродажах = Неопределено Тогда
			// Ошибка закрытия
			Возврат Ложь;
		КонецЕсли; 
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтчетОРозничныхПродажахОбъект.КассоваяСмена) Тогда
		НачатьТранзакцию();
		Попытка
			КассоваяСменаОбъект = ОтчетОРозничныхПродажахОбъект.КассоваяСмена.ПолучитьОбъект();
			Если КассоваяСменаОбъект.Статус <> Перечисления.СтатусыКассовойСмены.Закрыта Тогда
				КассоваяСменаОбъект.Дата = ОтчетОРозничныхПродажахОбъект.Дата;
				КассоваяСменаОбъект.Статус = Перечисления.СтатусыКассовойСмены.Закрыта;
				КассоваяСменаОбъект.ОкончаниеКассовойСмены = КассоваяСменаОбъект.Дата;
				Если КассоваяСменаОбъект.ПометкаУдаления Тогда
					КассоваяСменаОбъект.УстановитьПометкуУдаления(Ложь);
				КонецЕсли;
				КассоваяСменаОбъект.Записать(РежимЗаписиДокумента.Проведение);
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ОбщегоНазначения.СообщитьПользователю(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат Ложь;
		КонецПопытки; 
	КонецЕсли; 
	
	Если Константы.УдалятьНепробитыеЧекиПриЗакрытииКассовойСмены.Получить() Тогда
		Документы.ОтчетОРозничныхПродажах.УдалитьОтложенныеЧеки(ОтчетОРозничныхПродажахОбъект, ОписаниеОшибки);
		Если НЕ ПустаяСтрока(ОписаниеОшибки) Тогда
			ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки);
			Возврат Ложь;
		КонецЕсли; 
	КонецЕсли;
	
	Если Константы.АрхивироватьЧекиККМПриЗакрытииКассовойСмены.Получить()
		И ОтчетОРозничныхПродажахОбъект.СтатусКассовойСмены <> Перечисления.СтатусыОтчетаОРозничныхПродажах.Закрыта Тогда
		Документы.ОтчетОРозничныхПродажах.ВыполнитьАрхивациюЧековККМ(ОтчетОРозничныхПродажахОбъект, ОписаниеОшибки);
		Если НЕ ПустаяСтрока(ОписаниеОшибки) Тогда
			ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки);
			Возврат Ложь;
		КонецЕсли; 
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПометитьНаУдалениеСервер(ЧекККМ)
	
	ЧекККМОбъект = ЧекККМ.ПолучитьОбъект();
	ОписаниеОшибки = "";
	
	НачатьТранзакцию();
	Попытка
		ЧекККМОбъект.УстановитьПометкуУдаления(Истина);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ОбщегоНазначения.СообщитьПользователю(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
	КонецПопытки; 
	
	Возврат Истина;
	
КонецФункции

#Область ФиксированныеСтроки

#Область ТипыСообщений

&НаКлиентеНаСервереБезКонтекста
Функция ТипСообщенияНеверноВыбранаСтатьяДДС()
	
	Возврат "НеверноВыбранаСтатьяДДС";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТипСообщенияНесоответствиеДоговоровОрганизаций()
	
	Возврат "НесоответствиеДоговоровОрганизаций";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТипСообщенияИзмененныеДокументы()
	
	Возврат "ИзмененныеДокументы";
	
КонецФункции
 
&НаКлиентеНаСервереБезКонтекста
Функция ТипСообщенияОткрытыеКассовыеСмены()
	
	Возврат "ОткрытыеКассовыеСмены";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТипСообщенияЧекиВСостоянииРезерва()
	
	Возврат "ЧекиВСостоянииРезерва";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТипСообщенияЧекиСДвижениями()
	
	Возврат "ЧекиСДвижениями";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти 
 
