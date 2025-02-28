﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных
Перем ЕдиницаИзмеренияПередЗаписью;
#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		ЕдиницаИзмеренияПередЗаписью = Ссылка.ЕдиницаИзмерения;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		ЗаписатьИнформациюОСменеЕдиницыИзмерения(Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьИнформациюОСменеЕдиницыИзмерения(Отказ)
	
	Если Отказ Тогда
		Возврат
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЕдиницаИзмеренияПередЗаписью) И Не ЕдиницаИзмеренияПередЗаписью = ЕдиницаИзмерения Тогда
		
		МенеджерЗаписи = РегистрыСведений.ИсторияИзмененийЕдиницИзмерения.СоздатьМенеджерЗаписи();
	
		МенеджерЗаписи.Период = ТекущаяДатаСеанса();
		МенеджерЗаписи.ВладелецЕдиницыИзмерения = Ссылка;
		МенеджерЗаписи.Пользователь = Пользователи.ТекущийПользователь();
		МенеджерЗаписи.СтараяЕдиницаИзмерения = ЕдиницаИзмеренияПередЗаписью;
		МенеджерЗаписи.НоваяЕдиницаИзмерения = ЕдиницаИзмерения;

		МенеджерЗаписи.Записать()
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли