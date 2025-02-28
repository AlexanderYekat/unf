﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
		
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.ТипШаблона.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ОбъектИсточник = Параметры.ЗначениеКопирования.ПолучитьОбъект();
	Иначе
		ОбъектИсточник = РеквизитФормыВЗначение("Объект", Тип("СправочникОбъект.ШаблоныЭтикетокИЦенников"));
	КонецЕсли;
	
	СтруктураШаблона = ОбъектИсточник.Шаблон.Получить();
	
	Если ТипЗнч(СтруктураШаблона) = Тип("Структура") Тогда
		СтруктураШаблона.Свойство("XMLОписаниеМакета", XMLОписаниеМакета);
	КонецЕсли;
	
	АдресШаблона = ПоместитьВоВременноеХранилище(СтруктураШаблона, УникальныйИдентификатор);
	
	Если НЕ ЗначениеЗаполнено(Объект.ТипШаблона) Тогда
		Объект.ТипШаблона = Перечисления.ТипыШаблонов.ЭтикеткаЦенник;
	КонецЕсли;
	
		УстановитьВидимостьЭлементов();

	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененШаблон" Тогда
		АдресШаблона = Параметр;
		Модифицированность = Истина;
		Если ЗначениеЗаполнено(АдресШаблона) Тогда
			СтруктураШаблона = ПолучитьИзВременногоХранилища(АдресШаблона);
			Если СтруктураШаблона <> Неопределено Тогда
				Если СтруктураШаблона.Свойство("АдресСКДВХранилище")
					И ЗначениеЗаполнено(СтруктураШаблона.АдресСКДВХранилище) Тогда
					АдресСКД = СтруктураШаблона.АдресСКДВХранилище;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(АдресШаблона) Тогда
		СтруктураШаблона = ПолучитьИзВременногоХранилища(АдресШаблона);
		ТекущийОбъект.Шаблон = Новый ХранилищеЗначения(СтруктураШаблона);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.ТипШаблона.ТолькоПросмотр = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФормуРедактированияМакета(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		Оповещение = Новый ОписаниеОповещения("ПерейтиКРедактированиюМакетаЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Для редактирования шаблона необходимо записать элемент! Записать?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	Иначе
		ПерейтиКРедактированиюМакета();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипШаблонаПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПерейтиКРедактированиюМакетаЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Если ПроверитьЗаполнение() Тогда
			
			ЭтотОбъект.Записать();
			ПерейтиКРедактированиюМакета();
			
		КонецЕсли;;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКРедактированиюМакета()
	
	Если Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЭтикеткаЦенникПринтераЭтикеток") Тогда
		
		Если НЕ ЗначениеЗаполнено(АдресСКД) Тогда
			УстановитьСКДПоУмолчанию();
		КонецЕсли;
		
		ОповещениеПриЗавершении = Новый ОписаниеОповещения("НачатьРедактированиеМакетаЗавершение", ЭтотОбъект);
		ОборудованиеПринтерыЭтикетокКлиент.НачатьРедактированиеМакета(ОповещениеПриЗавершении, XMLОписаниеМакета, АдресСКД);
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыОткрытия.Вставить("ТипШаблона", Объект.ТипШаблона);
	ПараметрыОткрытия.Вставить("АдресШаблона", АдресШаблона);
	ПараметрыОткрытия.Вставить("АдресСКД", АдресСКД);
	
	ОткрытьФорму("Справочник.ШаблоныЭтикетокИЦенников.Форма.ФормаРедактированияШаблонаЭтикетокИЦенников",
		ПараметрыОткрытия,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьРедактированиеМакетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		Объект.РазмерМакета = ДополнительныеПараметры.РазмерМакета;
		XMLОписаниеМакета = ДополнительныеПараметры.XMLОписаниеМакета;
		Поля.Очистить();
		
		Для Каждого ТекПоле Из ДополнительныеПараметры.Поля Цикл
			
			НовоеПоле = Поля.Добавить();
			ЗаполнитьЗначенияСвойств(НовоеПоле, ТекПоле);
			
		КонецЦикла;
		
		АдресШаблона = СохранитьЗакрытьСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СохранитьЗакрытьСервер()
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураМакетаШаблона(), Новый УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	Элементы.РазмерМакета.Видимость = Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЭтикеткаЦенникПринтераЭтикеток");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСКДПоУмолчанию()
	
	СКД = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("ПоляШаблона");
	АдресСКД = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Функция СтруктураМакетаШаблона()
	
	СтруктураМакетаШаблона = Новый Структура;
	
	СтруктураМакетаШаблона.Вставить("РазмерМакета", Объект.РазмерМакета);
	СтруктураМакетаШаблона.Вставить("XMLОписаниеМакета", XMLОписаниеМакета);
	СтруктураМакетаШаблона.Вставить("АдресСКДВХранилище", АдресСКД);
	
	ПоляМакета = Новый Массив;
	
	Для Каждого ТекПоле Из Поля Цикл
		
		НовоеПоле = Новый Структура("Наименование, ТипЗаполнения, Значение, ЗначениеПоУмолчанию, Тип",
			ТекПоле.Наименование,
			ТекПоле.ТипЗаполнения,
			ТекПоле.Значение,
			ТекПоле.ЗначениеПоУмолчанию,
			ТекПоле.Тип);
			
		ПоляМакета.Добавить(НовоеПоле);
		
	КонецЦикла;
	
	СтруктураМакетаШаблона.Вставить("ПоляМакета", ПоляМакета);
	
	Возврат СтруктураМакетаШаблона;
	
КонецФункции

#КонецОбласти