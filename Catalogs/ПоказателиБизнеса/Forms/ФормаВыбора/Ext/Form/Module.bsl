﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПоказателиБизнесаФормы.ИнициализироватьСлужебныеРеквизитыФормы(ЭтаФорма);
	УстановитьОтбор();
	УстановитьУсловноеОформление();
	
	Если Параметры.Отбор.Свойство("ВидОтчета") И ЗначениеЗаполнено(Параметры.Отбор.ВидОтчета) Тогда
		Элементы.СтраницыВариантовОтчета.Видимость = Ложь;
		ВыбранныйОтчет = Параметры.Отбор.ВидОтчета;
	Иначе
		ПереключитьСтраницу(Элементы, ВидыОтчетов, "ДекорацияДоходыРасходы");
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ВидОтчета", ВыбранныйОтчет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ПереключениеСтраниц

&НаКлиенте
Процедура ДекорацияВидОтчетаНажатие(Элемент)
	
	Если Элемент.Имя = "ДекорацияДоходыРасходы" Тогда
		ВыбранныйОтчет = ПредопределенноеЗначение("Перечисление.ВидыФинансовыхОтчетов.ДоходыРасходы");
	ИначеЕсли Элемент.Имя = "ДекорацияДенежныйПоток" Тогда
		ВыбранныйОтчет = ПредопределенноеЗначение("Перечисление.ВидыФинансовыхОтчетов.ДенежныйПоток");
	Иначе // Баланс
		ВыбранныйОтчет =  ПредопределенноеЗначение("Перечисление.ВидыФинансовыхОтчетов.Баланс");
	КонецЕсли;
	
	ПереключитьСтраницу(Элементы, ВидыОтчетов, Элемент.Имя);
	Список.Параметры.УстановитьЗначениеПараметра("ВидОтчета", ВыбранныйОтчет);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПереключитьСтраницу(Элементы, ВидыОтчетов, АктивнаяСтраница)
	
	Для каждого ВидОтчета Из ВидыОтчетов Цикл
		
		ИмяДекорации = "Декорация" + ВидОтчета.Представление;
		
		Если ИмяДекорации = АктивнаяСтраница Тогда
			Элементы[ИмяДекорации].Шрифт = Новый Шрифт(Элементы[ИмяДекорации].Шрифт,,,Истина);
		Иначе
			Элементы[ИмяДекорации].Шрифт = Новый Шрифт(Элементы[ИмяДекорации].Шрифт,,,Ложь);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	
	НовоеУсловноеОформление = Список.УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "ТипПоказателя", Перечисления.ТипыПоказателейБизнеса.Доход, ВидСравненияКомпоновкиДанных.Равно);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветФона", Новый Цвет(238,255,240));
	
	НовоеУсловноеОформление = Список.УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "ТипПоказателя", Перечисления.ТипыПоказателейБизнеса.Расход, ВидСравненияКомпоновкиДанных.Равно);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветФона", Новый Цвет(255,238,240));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор()

	Если Параметры.Свойство("ПоказательБизнеса") Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипПоказателя");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.ПравоеЗначение = Перечисления.ТипыПоказателейБизнеса.Формула;
		// Баланс временно не функционирует
		Элементы.ДекорацияБаланс.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
