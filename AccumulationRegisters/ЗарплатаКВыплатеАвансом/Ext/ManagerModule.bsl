﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

Процедура ОчиститьВидыДоходовИсполнительногоПроизводства(ПараметрыОбновления = Неопределено) Экспорт
	УчетНачисленнойЗарплаты.ОчиститьВидыДоходовИсполнительногоПроизводстваРегистра(
		Метаданные.РегистрыНакопления.ЗарплатаКВыплатеАвансом,
		ПараметрыОбновления,
		"Период, ПериодВзаиморасчетов");
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
