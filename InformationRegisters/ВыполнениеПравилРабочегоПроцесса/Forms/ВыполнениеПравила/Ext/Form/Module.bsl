﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.Правило) Тогда
		ВызватьИсключение НСтр("ru='Не указано правило рабочего процесса'")
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Правило", Параметры.Правило);
	
	Заголовок = СтрШаблон(НСтр("ru='Выполнение правила рабочего процесса: ""%1""'"), Параметры.Правило);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЖурналРегистрацииВыполнениеПравил(Команда)
	
	ПараметрыОтбора = ПолучитьПараметрыОтбораЖурналаРегистрации();
	
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(ПараметрыОтбора, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СозданныйОбъект" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.СозданныйОбъект) Тогда
			ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.СозданныйОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьПараметрыОтбораЖурналаРегистрации()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Данные", Параметры.Правило);
	ПараметрыФормы.Вставить("СобытиеЖурналаРегистрации", РабочиеПроцессы.СобытиеЖурналаРегистрации());
	
	Возврат ПараметрыФормы;
	
КонецФункции

#КонецОбласти
