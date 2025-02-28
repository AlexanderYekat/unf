﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьДатуГраницыДляОрганизации(пОрганизация) Экспорт
	
	Если Не ЗначениеЗаполнено(пОрганизация) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МИНИМУМ(ПоследовательностьПартийДляКУДиР.НачалоМесяца) КАК НачалоМесяца
		|ИЗ
		|	РегистрСведений.ПоследовательностьПартийДляКУДиР КАК ПоследовательностьПартийДляКУДиР
		|ГДЕ
		|	ПоследовательностьПартийДляКУДиР.Организация = &пОрганизация";
	
	Запрос.УстановитьПараметр("пОрганизация", пОрганизация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.НачалоМесяца;
	Иначе
		// Нет записей по организации, значит, нет необходимости восстанавливать по ней последовательность.
		// При добавлении организации запись в регистре не создается, т.к. она не нужна.
		// Запись добавляется при записи документа, который входит в последовательность.
		// Если по организации нет документов, то нет необходимости рассчитывать партии для КУДиР.
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли
