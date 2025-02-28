﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект[0], ДанныеЗаполнения);
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ЭтотОбъект[0].Организация) И ЗначениеЗаполнено(ЭтотОбъект[0].ДоговорКонтрагента) Тогда
		ЭтотОбъект[0].Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтотОбъект[0].ДоговорКонтрагента,
			"Организация");
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ЭтотОбъект[0].Контрагент) И ЗначениеЗаполнено(ЭтотОбъект[0].ДоговорКонтрагента) Тогда
		ЭтотОбъект[0].Контрагент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтотОбъект[0].ДоговорКонтрагента,
			"Владелец");
		;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли