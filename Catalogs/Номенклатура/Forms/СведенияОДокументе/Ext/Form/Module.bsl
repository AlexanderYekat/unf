﻿#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ДанныеЗаполнения);
	
	Если Не Параметры.ДанныеЗаполнения.ТипНоменклатуры = Неопределено Тогда
		
		Для Каждого ЭлементСписка Из Параметры.ДанныеЗаполнения.ТипНоменклатуры Цикл
			Элементы.ДекорацияТипыНоменклатурыСодержание.Заголовок = Элементы.ДекорацияТипыНоменклатурыСодержание.Заголовок 
			+ ?(ПустаяСтрока(Элементы.ДекорацияТипыНоменклатурыСодержание.Заголовок), "", ", ") + Строка(ЭлементСписка);
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Организация", "Видимость", ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций"));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтруктурнаяЕдиница", "Видимость", ПолучитьФункциональнуюОпцию("УчетПоНесколькимСкладам"));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВидСкидкиНаценки", "Видимость", Параметры.ДанныеЗаполнения.СкидкиНаценкиВидны);
	
	Элементы.СтруктурнаяЕдиницаПолучатель.Видимость = ЗначениеЗаполнено(СтруктурнаяЕдиницаПолучатель);
	
	Если ЗначениеЗаполнено(СтруктурнаяЕдиницаПолучатель) Тогда
		Элементы.СтруктурнаяЕдиница.Заголовок = НСтр("ru='Отправитель'");
		Элементы.ВалютаДокумента.Видимость = Ложь;
		Элементы.ГруппаЦены.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти


