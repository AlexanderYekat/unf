﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс


// Функция получает значение системного перечисления.
//
// Параметры:
//  ЗначениеТипДиаграммы - ПеречислениеСсылка.ТипыДиаграмм	 - значение типа для которого получается системное значение
// 
// Возвращаемое значение:
//  ТипДиаграммы - системное значение.
//
Функция ПолучитьСистемныйТипДиаграммы(ЗначениеТипДиаграммы) Экспорт
	
	Возврат ТипДиаграммы[ОбщегоНазначения.ИмяЗначенияПеречисления(ЗначениеТипДиаграммы)];
	
КонецФункции

#КонецОбласти

#КонецЕсли