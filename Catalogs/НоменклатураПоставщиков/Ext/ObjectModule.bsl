﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЭтоГруппа Тогда 
		
		ОстатокНоменклатурыУПоставщика = НоменклатураВДокументахСервер.ОстатокНоменклатурыПоставщика(Ссылка);
		
		Если ЗначениеЗаполнено(ОстатокНоменклатурыУПоставщика) Тогда
			
			Если Не ЗначениеЗаполнено(СрокПополнения) Тогда
				ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Срок пополнения (дн.)"".'");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "СрокПополнения", , Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли