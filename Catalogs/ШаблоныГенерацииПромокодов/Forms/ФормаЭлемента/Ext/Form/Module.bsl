﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Объект.СловарьСимволов.Количество() = 0 Тогда
		ЗагрузитьСписокСимволов();	
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.КоличествоРазПрименения = 1;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если СтрНайти(Объект.МаскаПромокода, "[Промокод]") = 0 Тогда
		Объект.МаскаПромокода = "[Промокод]";
	КонецЕсли;
	Если Объект.КоличествоСимволов = 0 Тогда
		Объект.КоличествоСимволов = 6;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура МаскаПромокодаПриИзменении(Элемент)
	Если стрНайти(Объект.МаскаПромокода, "[Промокод]") = 0 Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Поле = "МаскаПромокода";
		Сообщение.Текст = Нстр("ru = 'Шаблон промокода должен содержать секцию [Промокод], куда будет подставляться сгенерированное значение.'");
		Сообщение.Сообщить();
		Объект.МаскаПромокода = "[Промокод]";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСписокСимволов()
	Объект.СловарьСимволов.Очистить();
	МассивСимволов = ПромокодыУНФ.БазовыйСловарьСимволов();
	Для Каждого Символ Из МассивСимволов Цикл
		СтрокаСловаря = Объект.СловарьСимволов.Добавить();
		СтрокаСловаря.Символ = Символ;
	КонецЦикла;
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
