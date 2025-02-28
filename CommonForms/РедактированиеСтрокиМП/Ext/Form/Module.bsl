﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОткрытиеЭкранаВGA(ЭтаФорма.ИмяФормы);
	// Конец Сбор статистики
	
	Товар = Параметры.Товар;
	Цена = Параметры.Цена;
	Количество = Параметры.Количество;
	Сумма = Параметры.Сумма;
	
	#Если НЕ МобильноеПриложениеСервер Тогда
		Элементы.Группа1.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		Элементы.ФормаУдалитьСтроку.Отображение = ОтображениеКнопки.КартинкаИТекст;
		Элементы.Декорация1.Видимость = Ложь;
		Элементы.ДекорацияОтступ4.РастягиватьПоГоризонтали = Ложь;
		Элементы.ДекорацияОтступ4.Ширина = 12;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Закрытие",,,ЗавершениеРаботы);
	// Конец Сбор статистики
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Кнопка2Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики

	Количество = Количество + 1;
	РассчитатьСумму();
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка4Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики

	Количество = Количество - 1;
	РассчитатьСумму();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	
	РассчитатьЦену();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенаПриИзменении(Элемент)
	
	РассчитатьСумму();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	РассчитатьСумму();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("Цена",       Цена);
	ПараметрыЗакрытия.Вставить("Количество", Количество);
	ПараметрыЗакрытия.Вставить("Сумма",      Сумма);
	ПараметрыЗакрытия.Вставить("Сохранить");
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтроку(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	ТекстВопроса = НСтр("ru='Строка будет удалена из чека."
		"Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УдалитьСтрокуЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РассчитатьСумму()
	
	Сумма = Количество * Цена;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьЦену()
	
	Если Количество <> 0 Тогда
		Цена = Сумма / Количество;
	Иначе
		Цена = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтрокуЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("УдалитьСтроку");
	
	Закрыть(ПараметрыЗакрытия);

КонецПроцедуры

#КонецОбласти