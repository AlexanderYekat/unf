﻿#Область ПрограммныйИнтерфейс

// Подписка на события при копировании документа.
//
// Параметры:
// 	Источник - ДокументОбъект
Процедура ПриКопированииОбъекта(Источник) Экспорт

	Если Не ПустаяСтрока(Источник.Комментарий) Тогда
		Источник.Комментарий = "";
	КонецЕсли;

	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ИдентификаторПлатежа", Источник.Метаданные()) Тогда
		Источник.ИдентификаторПлатежа = "";
	КонецЕсли;

КонецПроцедуры

#КонецОбласти