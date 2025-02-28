﻿
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриИзмененииВидаВремени(ИмяРеквизита)
	
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект[ИмяРеквизита]) Тогда
		
		Индекс = СтрЗаменить(ИмяРеквизита, "ВидВремени", "");
		
		ИмяРеквизитаДни = "Дней" + Индекс;
		ЭтотОбъект[ИмяРеквизитаДни] = 0;
		
		ИмяРеквизитаЧасы = "Часов" + Индекс;
		ЭтотОбъект[ИмяРеквизитаЧасы] = 0;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКоличестваДней(ИмяРеквизита)
	
	Если ЭтотОбъект[ИмяРеквизита] > 0 Тогда
		
		Индекс = СтрЗаменить(ИмяРеквизита, "Дней", "");
		ИмяРеквизитаВидВремени = "ВидВремени" + Индекс;
		Если НЕ ЗначениеЗаполнено(ЭтотОбъект[ИмяРеквизитаВидВремени]) Тогда
			
			ЭтотОбъект[ИмяРеквизитаВидВремени] = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Справочник.ВидыРабочегоВремени.Работа");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКоличестваЧасов(ИмяРеквизита)
	
	Если ЭтотОбъект[ИмяРеквизита] > 0 Тогда
		
		Индекс = СтрЗаменить(ИмяРеквизита, "Часов", "");
		ИмяРеквизитаВидВремени = "ВидВремени" + Индекс;
		Если НЕ ЗначениеЗаполнено(ЭтотОбъект[ИмяРеквизитаВидВремени]) Тогда
			
			ЭтотОбъект[ИмяРеквизитаВидВремени] = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Справочник.ВидыРабочегоВремени.Работа");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ЗначенияРеквизитовСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ЗначенияРеквизитовСтроки = Новый Структура;
	
	ИменаРеквизитов = Новый Массив(3);
	ИменаРеквизитов[0] = "ВидВремени";
	ИменаРеквизитов[1] = "Дней";
	ИменаРеквизитов[2] = "Часов";
	
	ЗначенияРеквизитовСтроки.Вставить("Сотрудник", Сотрудник);
	ЗначенияРеквизитовСтроки.Вставить("Должность", Должность);
	ЗначенияРеквизитовСтроки.Вставить("СтрокаТаблицы", СтрокаТаблицы);
	
	Для Итератор = 1 По 6 Цикл
		
		Для каждого ИмяРеквизита Из ИменаРеквизитов Цикл
			
			Ключ = ИмяРеквизита + Строка(Итератор);
			ЗначенияРеквизитовСтроки.Вставить(Ключ, ЭтотОбъект[Ключ]);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Закрыть(ЗначенияРеквизитовСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитов

&НаКлиенте
Процедура ВидВремениПриИзменении(Элемент)
	
	ПриИзмененииВидаВремени(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДнейПриИзменении(Элемент)
	
	ПриИзмененииКоличестваДней(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ЧасовПриИзменении(Элемент)
	
	ПриИзмененииКоличестваЧасов(Элемент.Имя);
	
КонецПроцедуры

#КонецОбласти