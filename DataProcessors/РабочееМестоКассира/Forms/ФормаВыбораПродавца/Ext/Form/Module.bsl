﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПустаяСтрока(Параметры.АдресХранилищаСотрудники) Тогда
		ТаблицаСотрудников.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресХранилищаСотрудники));
		ВыборСотрудникаИзТаблицы = Параметры.ПодборПродавцов;
	КонецЕсли;
	
	ПодборПродавцов = Параметры.ПодборПродавцов;
	НастроитьКассировДляВхода = Параметры.НастроитьКассировДляВхода;
	
	ОбщегоНазначенияРМКПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСотрудниковПриИзменении(Элемент)
	ОтборСотрудниковСервер();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаЧеков

&НаКлиенте
Процедура СписокПродавцовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗафиксироватьВыбор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ЗафиксироватьВыбор();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗафиксироватьВыбор()
	Если ВыборСотрудникаИзТаблицы Тогда
		ТекущиеДанные = Элементы.ТаблицаСотрудников.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.СписокПродавцов.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Закрыть();
	Иначе
		Закрыть(?(ВыборСотрудникаИзТаблицы, ТекущиеДанные.ИдентификаторСотрудника, ТекущиеДанные.Продавец));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтборСотрудниковСервер()
	ОбщегоНазначенияРМКПереопределяемый.ПереопределитьЗапросДоступныхПродавцов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСотрудниковВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ЗафиксироватьВыбор();
КонецПроцедуры

#КонецОбласти
