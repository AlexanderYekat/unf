﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Параметры:
//  ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументВходящийЭДО,ДокументСсылка.ЭлектронныйДокументИсходящийЭДО
// 
// Возвращаемое значение:
//  Неопределено,
//  УникальныйИдентификатор
Функция ИдентификаторПакетаДокумента(ЭлектронныйДокумент) Экспорт
	
	Выборка = ВыборкаИдентификатораПакетаДокумента(ЭлектронныйДокумент);
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ИдентификаторПакета;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  ЭлектронныйДокумент - ДокументСсылка.ЭлектронныйДокументВходящийЭДО,ДокументСсылка.ЭлектронныйДокументИсходящийЭДО
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
//  * ИдентификаторПакета - см. РегистрСведений.ПакетыДокументовЭДО.ИдентификаторПакета
Функция ВыборкаИдентификатораПакетаДокумента(ЭлектронныйДокумент)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СоставПакетовЭлектронныхДокументов.ИдентификаторПакета КАК ИдентификаторПакета
		|ИЗ
		|	РегистрСведений.СоставПакетовДокументовЭДО КАК СоставПакетовЭлектронныхДокументов
		|ГДЕ
		|	СоставПакетовЭлектронныхДокументов.ЭлектронныйДокумент = &ЭлектронныйДокумент";
	
	Запрос.УстановитьПараметр("ЭлектронныйДокумент", ЭлектронныйДокумент);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

#КонецОбласти

#КонецЕсли