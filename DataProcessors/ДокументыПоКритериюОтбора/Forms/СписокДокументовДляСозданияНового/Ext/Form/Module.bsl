﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("СписокДокументовДляСозданияНового", СписокДокументов);
	Если Параметры.Свойство("ТипТекущегоДокумента") Тогда
		УстановитьТекущуюСтроку(Параметры.ТипТекущегоДокумента);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ОповеститьОВыборе(Элемент.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	Если Элементы.СписокДокументов.ТекущиеДанные <> Неопределено Тогда
		ОповеститьОВыборе(Элементы.СписокДокументов.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьТекущуюСтроку(ТипТекущегоДокумента)
	
	Если ТипЗнч(ТипТекущегоДокумента) <> Тип("Тип") Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипТекущегоДокумента);
	
	НайденныйЭлемент = СписокДокументов.НайтиПоЗначению(ОбъектМетаданных.Имя);
	
	Если ТипЗнч(НайденныйЭлемент) = Тип("ЭлементСпискаЗначений") Тогда
		Элементы.СписокДокументов.ТекущаяСтрока = НайденныйЭлемент.ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти