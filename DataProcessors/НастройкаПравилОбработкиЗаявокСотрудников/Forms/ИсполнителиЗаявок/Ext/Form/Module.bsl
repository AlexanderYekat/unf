﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СписокПользователей") Тогда
		СписокПользователей.ЗагрузитьЗначения(Параметры.СписокПользователей);
	КонецЕсли;
	
	Если Параметры.Свойство("Подразделение") И Параметры.Свойство("РольИсполнителя") Тогда
		ЗаполнитьЗаголовок(Параметры.Подразделение, Параметры.РольИсполнителя);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиПравил

&НаКлиенте
Процедура СписокПользователейОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Для каждого Значение Из ВыбранноеЗначение Цикл
		Если Значение.Пустая() ИЛИ СписокПользователей.НайтиПоЗначению(Значение) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СписокПользователей.Добавить(Значение);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	Закрыть(СписокПользователей.ВыгрузитьЗначения());
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьЗаголовок(Подразделение, РольИсполнителя)
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Подразделение);
	МассивСсылок.Добавить(РольИсполнителя);
	
	МассивНаименований = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивСсылок, "Наименование");
	
	ШаблонЗаголовка = НСтр("ru = 'Исполнители заявок ""%1 %2""'");
	Заголовок = СтрШаблон(ШаблонЗаголовка, МассивНаименований[РольИсполнителя], МассивНаименований[Подразделение]); 
	
КонецПроцедуры

#КонецОбласти