﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Начальное заполнение и обновление информационной базы.
Процедура НачальноеЗаполнение() Экспорт
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		Возврат;
	КонецЕсли;
	
	Обновить(ПолучитьМакет("ПредопределенныеЗначения").ПолучитьТекст(), Ложь);
	
КонецПроцедуры

// Обновляет данные регистра.
Процедура Обновить(ТекстXML, ПолучатьДанныеИзСервиса = Истина) Экспорт
	ЗарплатаКадры.ОбновитьКлассификатор(ТекстXML, ПолучатьДанныеИзСервиса);
КонецПроцедуры

#КонецОбласти

#КонецЕсли