﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура УдалитьPLU(ПравилоОбмена, PLU) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.КодыТоваровPLUНаОборудовании.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ПравилоОбмена  = ПравилоОбмена;
	МенеджерЗаписи.КодТовараPLU   = PLU;
	
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Удалить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
