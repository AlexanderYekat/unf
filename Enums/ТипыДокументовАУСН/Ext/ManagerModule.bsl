﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает идентификатор типа документа сервиса Автоматизированная УСН
//
// Параметры:
//  ТипДокумента - ПеречислениеСссылка.ТипыДокументовАУСН
//
// Возвращаемое значение:
//  Строка - строковый идентификатор типа, указанного в параметре
//
Функция Идентификатор(ТипДокумента) Экспорт
	
	Если Не ЗначениеЗаполнено(ТипДокумента) Тогда
		Возврат "";
	КонецЕсли;
	
	ТипыДокументов = ВсеТипыДокументовАУСН();
	Возврат ТипыДокументов[ТипДокумента];
	
КонецФункции

// Возвращает значение перечисления, соответствующее переданному идентификатору,
// возвращает пустую ссылку, если не найдено значение перечисления по идентификатору
//
// Параметры:
//  Идентификатор - Строка - возможные идентификаторы см. ВсеТипыДокументовАУСН()
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыДокументовАУСН
//
Функция ЗначениеПоИдентификатору(Знач Идентификатор) Экспорт
	
	Идентификатор = НРег(Идентификатор);
	ТипыДокументов = ВсеТипыДокументовАУСН();
	Для Каждого ТипДокумента Из ТипыДокументов Цикл
		Если НРег(ТипДокумента.Значение) = Идентификатор Тогда
			Возврат ТипДокумента.Ключ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПустаяСсылка();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВсеТипыДокументовАУСН()
	
	Идентификаторы = Новый Соответствие;
	
	Идентификаторы.Вставить(БезналичнаяОперация,               "AccountOperation");
	Идентификаторы.Вставить(НалоговыеНачисления,               "BalanceAccountV2");
	Идентификаторы.Вставить(НалоговыеНачисленияВерсия1,        "BalanceAccount");
	Идентификаторы.Вставить(Задолженность,                     "ENSBalance");
	Идентификаторы.Вставить(ПлатежныеРеквизиты,                "ENSRequisites");
	Идентификаторы.Вставить(ИсторияНалоговыхНачислений,        "TaxChargeHistoryV2");
	Идентификаторы.Вставить(БанковскаяВыписка,                 "Statement");
	Идентификаторы.Вставить(БанковскаяВыпискаБезРазметки,      "NotMarkedStatement");
	Идентификаторы.Вставить(БанковскаяВыпискаСАвтоРазметкой,   "AutoMarkedStatement");
	Идентификаторы.Вставить(БанковскаяВыпискаСРучнойРазметкой, "UserMarkedStatement");
	Идентификаторы.Вставить(РасчетНДФЛ,                        "EmployeeInfo");
	Идентификаторы.Вставить(УведомлениеОтФНС,                  "Notifications");
		
	Возврат Идентификаторы; 
	
КонецФункции

#КонецОбласти

#КонецЕсли