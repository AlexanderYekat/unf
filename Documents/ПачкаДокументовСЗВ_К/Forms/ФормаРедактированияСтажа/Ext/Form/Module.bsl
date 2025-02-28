﻿#Область ОписаниеПеременных

&НаКлиенте
Перем СтруктураВозвращаемыхДанных;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДанныеОСтаже();
			
	ТолькоПросмотр = Параметры.ДанныеОСтаже.ТолькоПросмотр;
	
	ЗакрыватьПриВыборе = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Данные о стаже: %1'"), Сотрудник);
	
	Модифицированность = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
	Если Не Модифицированность Тогда
		ОповеститьОВыборе(СтруктураВозвращаемыхДанных);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	ВыбратьИЗакрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Модифицированность = Ложь;
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВозвращаемыхДанных = Новый Структура;
	
	СтруктураВозвращаемыхДанных.Вставить("ДатаНачалаПериода", ДатаНачалаПериода);
	СтруктураВозвращаемыхДанных.Вставить("ДатаОкончанияПериода", ДатаОкончанияПериода);
	СтруктураВозвращаемыхДанных.Вставить("ВидДеятельности", ВидДеятельности);
	СтруктураВозвращаемыхДанных.Вставить("ОсобыеУсловияТруда", ОсобыеУсловияТруда);
	СтруктураВозвращаемыхДанных.Вставить("КодПозицииСписка", КодПозицииСписка);
	СтруктураВозвращаемыхДанных.Вставить("ОснованиеИсчисляемогоСтажа", ОснованиеИсчисляемогоСтажа);
	СтруктураВозвращаемыхДанных.Вставить("ОрганизацияТрудовойДеятельности", ОрганизацияТрудовойДеятельности);
	СтруктураВозвращаемыхДанных.Вставить("Должность", Должность);
	СтруктураВозвращаемыхДанных.Вставить("НулевойПараметрИсчисляемогоСтажа", НулевойПараметрИсчисляемогоСтажа);
	СтруктураВозвращаемыхДанных.Вставить("ПервыйПараметрИсчисляемогоСтажа", ПервыйПараметрИсчисляемогоСтажа);
	СтруктураВозвращаемыхДанных.Вставить("ВторойПараметрИсчисляемогоСтажа", ВторойПараметрИсчисляемогоСтажа);
	СтруктураВозвращаемыхДанных.Вставить("ТретийПараметрИсчисляемогоСтажа", ТретийПараметрИсчисляемогоСтажа);
	СтруктураВозвращаемыхДанных.Вставить("ОснованиеВыслугиЛет", ОснованиеВыслугиЛет);
	СтруктураВозвращаемыхДанных.Вставить("ПервыйПараметрВыслугиЛет", ПервыйПараметрВыслугиЛет);
	СтруктураВозвращаемыхДанных.Вставить("ВторойПараметрВыслугиЛет", ВторойПараметрВыслугиЛет);
	СтруктураВозвращаемыхДанных.Вставить("ТретийПараметрВыслугиЛет", ТретийПараметрВыслугиЛет);
	СтруктураВозвращаемыхДанных.Вставить("ТерриториальныеУсловия", ТерриториальныеУсловия);
	СтруктураВозвращаемыхДанных.Вставить("РайонныйКоэффициент", РайонныйКоэффициент);
	СтруктураВозвращаемыхДанных.Вставить("ИндексСтроки", ИндексСтроки);
	СтруктураВозвращаемыхДанных.Вставить("НоваяСтрока", НоваяСтрока);
	СтруктураВозвращаемыхДанных.Вставить("Отмена", Ложь);
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеОСтаже()
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ДанныеОСтаже);
КонецПроцедуры	

#КонецОбласти

#Область Инициализация

СтруктураВозвращаемыхДанных = Новый Структура("ИндексСтроки, НоваяСтрока, Отмена", ИндексСтроки, НоваяСтрока, Истина);

#КонецОбласти
