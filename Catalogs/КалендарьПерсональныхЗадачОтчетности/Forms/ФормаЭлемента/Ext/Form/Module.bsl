﻿
#Область ОбработчикиСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Задача.ВидЗадачи = Перечисления.ВидыЗадачСобытийКалендаря.ЗаполнениеДанных Тогда
		Элементы.ДатаДокументаОбработкиСобытия.ТолькоПросмотр = Истина;
		Элементы.ДатаДокументаОбработкиСобытия.АвтоОтметкаНезаполненного = Ложь;
	Иначе
		Элементы.ДатаДокументаОбработкиСобытия.ТолькоПросмотр = Ложь;
		Элементы.ДатаДокументаОбработкиСобытия.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗадачаПриИзменении(Элемент)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции



&НаКлиенте
Процедура УстановитьДоступностьЭлементов()
	
	Если ПолучитьВидЗадачи(Объект.Задача) = ПредопределенноеЗначение("Перечисление.ВидыЗадачСобытийКалендаря.ЗаполнениеДанных") Тогда
		Элементы.ДатаДокументаОбработкиСобытия.ТолькоПросмотр = Истина;
		Элементы.ДатаДокументаОбработкиСобытия.АвтоОтметкаНезаполненного = Ложь;
	Иначе
		Элементы.ДатаДокументаОбработкиСобытия.ТолькоПросмотр = Ложь;
		Элементы.ДатаДокументаОбработкиСобытия.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВидЗадачи(Задача)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Задача,"ВидЗадачи")
КонецФункции


#КонецОбласти
