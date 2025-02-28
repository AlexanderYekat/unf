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
	|	ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// АПК:299-выкл: Особенности иерархии библиотек

Процедура ПодготовитьОбновлениеЗависимыхДанныхПриОбменеПередЗаписью(Объект) Экспорт
	
	ЗарплатаКадрыПериодическиеРегистры.КонтрольИзмененийПередЗаписью(Объект);
	
КонецПроцедуры

Процедура ПодготовитьОбновлениеЗависимыхДанныхПриОбменеПриЗаписи(Объект) Экспорт
	
	ЗарплатаКадрыПериодическиеРегистры.КонтрольИзмененийПриЗаписи(Объект);
	
КонецПроцедуры

// АПК:299-вкл

#КонецОбласти

#КонецЕсли
