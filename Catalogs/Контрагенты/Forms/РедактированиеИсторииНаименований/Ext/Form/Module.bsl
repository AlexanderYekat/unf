﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ИсторияНаименований")
		ИЛИ НЕ Параметры.Свойство("ТекущееНаименованиеПолное") Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ИсторияНаименований.Загрузить(Параметры.ИсторияНаименований.Выгрузить());
	Если ИсторияНаименований.Количество() = 0 Тогда
		ИсторияНаименований.Добавить().НаименованиеПолное = Параметры.ТекущееНаименованиеПолное;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Редактирование", Метаданные.Справочники.Контрагенты) Тогда
		
		ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
	Если ТолькоПросмотр Тогда
		
		Элементы.ФормаКомандаОтмена.КнопкаПоУмолчанию = Истина;
		
	КонецЕсли;
	
	УстановитьПризнакПервоначальногоЗначения(ИсторияНаименований);
	
	Если ИсторияНаименований.Количество() > 0 Тогда
		Элементы.ИсторияНаименований.ТекущаяСтрока = ИсторияНаименований[ИсторияНаименований.Количество()-1].ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыИсторияНаименований

&НаКлиенте
Процедура ИсторияНаименованийПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			
			НовыйПериод = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
			
			// Получим максимальный период в таблице
			ПоследнийПериод = '00010101';
			Для Каждого ЗаписьИстории Из ИсторияНаименований Цикл
				Если ЗаписьИстории.Период > ПоследнийПериод Тогда
					ПоследнийПериод = ЗаписьИстории.Период;
				КонецЕсли;
			КонецЦикла;
			
			Если НовыйПериод <= ПоследнийПериод Тогда
				НовыйПериод = НачалоДня(ПоследнийПериод + 60*60*24);
			КонецЕсли;
			
			Элемент.ТекущиеДанные.Период = НовыйПериод;
			
			ЭтотОбъект.ТекущийЭлемент = Элементы.ИсторияНаименованийНаименованиеПолное;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНаименованийПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПризнакПервоначальногоЗначения(ИсторияНаименований);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияНаименованийПередУдалением(Элемент, Отказ)
	
	Если ИсторияНаименований.Индекс(Элемент.ТекущиеДанные) = 0 Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Отказ = Ложь;
	
	ПроверитьЗаполнениеИстории(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("ИсторияНаименований", ИсторияНаименований);
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПризнакПервоначальногоЗначения(ТаблицаИстории)
	
	ТаблицаИстории.Сортировать("Период");
	// Первая строка должна быть первоначальным значением
	Если ТаблицаИстории.Количество() > 0 Тогда
		ПерваяСтрока = ТаблицаИстории[0];
		ПерваяСтрока.ПервоначальноеЗначение = Истина;
		ПерваяСтрока.Период = '00010101';
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеИстории(Отказ)
	
	ПериодыСтрок = Новый Массив;
	
	Для Каждого Запись Из ИсторияНаименований Цикл
		
		ИндексСтроки = ИсторияНаименований.Индекс(Запись);
		ПрефиксСообщенияСтроки = "ИсторияНаименований["+Формат(ИндексСтроки, "ЧЦ=; ЧДЦ=; ЧГ=")+"].";
		
		Если НЕ ЗначениеЗаполнено(Запись.Период) И ИндексСтроки > 0 Тогда
			СообщениеОбОшибке = НСтр("ru = 'Нужно указать дату начала действия'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке, , ПрефиксСообщенияСтроки+"Период", , Отказ);
		КонецЕсли;
		
		Если ПериодыСтрок.Найти(Запись.Период) = Неопределено Тогда
			Если ЗначениеЗаполнено(Запись.Период) Тогда
				ПериодыСтрок.Добавить(Запись.Период);
			КонецЕсли;
		Иначе
			// Строка с такой датой уже была раньше, это ошибка.
			// Не может быть 2 строки с одинаковой датой.
			СообщениеОбОшибке = НСтр("ru = 'Уже есть запись с указанной датой сведений'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке, , ПрефиксСообщенияСтроки+"Период", , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Запись.НаименованиеПолное) Тогда
			СообщениеОбОшибке = НСтр("ru = 'Поле ""Полное наименование"" не заполнено'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке, , ПрефиксСообщенияСтроки+"НаименованиеПолное",  , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти