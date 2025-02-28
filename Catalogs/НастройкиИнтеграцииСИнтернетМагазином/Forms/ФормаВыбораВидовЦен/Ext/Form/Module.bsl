﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокВидовЦен();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ВыбранныеВидыЦен = Новый СписокЗначений;
	
	Для каждого ЭлементСЗ Из СписокВидовЦен Цикл
		
		Если ЭлементСЗ.Пометка Тогда
			
			НовыйЭлемент = ВыбранныеВидыЦен.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, ЭлементСЗ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Закрыть(ВыбранныеВидыЦен);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокВидовЦен()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыЦен.Ссылка КАК Значение,
	|	ВидыЦен.Наименование КАК Представление,
	|	ЛОЖЬ КАК Пометка
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|ГДЕ
	|	НЕ ВидыЦен.Ссылка В (&ВидыЦен)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВидыЦен.Ссылка,
	|	ВидыЦен.Наименование,
	|	ИСТИНА
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|ГДЕ
	|	ВидыЦен.Ссылка В(&ВидыЦен)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Представление";
	
	Запрос.УстановитьПараметр("ВидыЦен", Параметры.СписокВидовЦен); 
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НовыйЭлемент = СписокВидовЦен.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, Выборка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
