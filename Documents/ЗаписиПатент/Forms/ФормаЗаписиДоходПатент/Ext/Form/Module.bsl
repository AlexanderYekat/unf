﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Дата = ТекущаяДатаСеанса();
		Объект.РучныеЗаписи = Истина;
		
		Если Параметры.Свойство("Организация") И ЗначениеЗаполнено(Параметры.Организация) Тогда
			Объект.Организация = Параметры.Организация;
		КонецЕсли;
		
		Если Параметры.Свойство("Патент") И ЗначениеЗаполнено(Параметры.Патент) Тогда
			Объект.Патент = Параметры.Патент;
		КонецЕсли; 
	КонецЕсли;
	
	НомерСтроки = Параметры.НомерСтроки;
	Если Объект.ЗаписиКнигаДоходовПатент.Количество() > 0 Тогда
		РабочаяСтрока = Объект.ЗаписиКнигаДоходовПатент[НомерСтроки-1];
		Доходы = РабочаяСтрока.Доход;
		НомерПервичногоДокумента = РабочаяСтрока.НомерПервичногоДокумента;
		ДатаПервичногоДокумента = РабочаяСтрока.ДатаПервичногоДокумента;
		Содержание = РабочаяСтрока.Содержание;
		ПервичныйДокумент = РабочаяСтрока.ПервичныйДокумент;
	КонецЕсли;
	
	ТолькоПросмотр = Не Объект.РучныеЗаписи;
	Элементы.ПервичныйДокумент.Видимость = Не Объект.РучныеЗаписи;
	Элементы.ГруппаПредупреждения.Видимость = Не Объект.РучныеЗаписи;
	
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если Объект.РучныеЗаписи Тогда
		ПроверяемыеРеквизиты.Добавить("ДатаПервичногоДокумента");
		ПроверяемыеРеквизиты.Добавить("НомерПервичногоДокумента");
		ПроверяемыеРеквизиты.Добавить("Содержание");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ТекущийОбъект.РучныеЗаписи Тогда
		// сохраняем ручные данные первой строки
		ТекущийОбъект.Дата = ДатаПервичногоДокумента;
		ТекущийОбъект.ЗаписиКнигаДоходовПатент.Очистить();
		РабочаяСтрока = ТекущийОбъект.ЗаписиКнигаДоходовПатент.Добавить();
		РабочаяСтрока.Доход = Доходы;
		РабочаяСтрока.ДатаПервичногоДокумента = ДатаПервичногоДокумента;
		РабочаяСтрока.НомерПервичногоДокумента = НомерПервичногоДокумента;
		РабочаяСтрока.Содержание = Содержание;
	Иначе
		Если ТекущийОбъект.ЗаписиКнигаДоходовПатент.Количество() > 0 Тогда
			РабочаяСтрока = ТекущийОбъект.ЗаписиКнигаДоходовПатент[НомерСтроки-1];
			РабочаяСтрока.Доход = Доходы;
			РабочаяСтрока.ДатаПервичногоДокумента = ДатаПервичногоДокумента;
			РабочаяСтрока.НомерПервичногоДокумента = НомерПервичногоДокумента;
			РабочаяСтрока.Содержание = Содержание;
			РабочаяСтрока.ПервичныйДокумент = ПервичныйДокумент;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПервичныйДокументНажатие(Элемент, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ПервичныйДокумент) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(,ПервичныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьФормуДляРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	Элементы.ГруппаПредупреждения.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗапись(Команда)
	
	Если НомерСтроки <> 0 Тогда
		УдалитьЗаписьСервер();
		ОповеститьОбИзменении(Тип("РегистрНакопленияКлючЗаписи.КнигаУчетаДоходовПатент"));
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УдалитьЗаписьСервер()
	
	РабочаяСтрока = Объект.ЗаписиКнигаДоходовПатент[НомерСтроки-1];
	Объект.ЗаписиКнигаДоходовПатент.Удалить(РабочаяСтрока);
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры

#КонецОбласти
