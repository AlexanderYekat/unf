﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьПоследовательностьПартийКУДиР = Константы.ИспользоватьПоследовательностьПартийКУДиР.Получить();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПоследовательностьПартийКУДиРПриИзменении(Элемент)
	ИспользоватьПоследовательностьПартийКУДиРПриИзмененииНаСервере(ИспользоватьПоследовательностьПартийКУДиР);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИспользоватьПоследовательностьПартийКУДиРПриИзмененииНаСервере(ИспользоватьПоследовательностьПартийКУДиР)
	
	Константы.ИспользоватьПоследовательностьПартийКУДиР.Установить(ИспользоватьПоследовательностьПартийКУДиР);
	ОбновитьЗначениеРавноИстина = Истина;
	ПоследовательностьПартийДляКУДиРПовтИсп.ИспользоватьПоследовательностьПартийКУДиР(ОбновитьЗначениеРавноИстина);
	Если ИспользоватьПоследовательностьПартийКУДиР Тогда
		// Определим дату начала последовательности
		ГраницаПоследовательности = ОпределитьМинимальнуюДатуНачала();
		
		// Очистим регистр ПоследовательностьПартийДляКУДиР
		НаборЗаписей = РегистрыСведений.ПоследовательностьПартийДляКУДиР.СоздатьНаборЗаписей();
		НаборЗаписей.Записать(Истина);
		
		// Добавим записи для каждой организации с минимальной датой.
		НаборЗаписей = РегистрыСведений.ПоследовательностьПартийДляКУДиР.СоздатьНаборЗаписей();
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Организации.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Организации КАК Организации";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Организация = ВыборкаДетальныеЗаписи.Ссылка;
			НоваяЗапись.НачалоМесяца = ГраницаПоследовательности;
		КонецЦикла;
		
		НаборЗаписей.Записать(Истина);
		
	Иначе
		
		// Очистим регистр ПоследовательностьПартийДляКУДиР
		НаборЗаписей = РегистрыСведений.ПоследовательностьПартийДляКУДиР.СоздатьНаборЗаписей();
		НаборЗаписей.Записать(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОпределитьМинимальнуюДатуНачала()
	
	МинимальнаяДатаНачала = Неопределено;
	
	// ПН
	Выборка = Документы.ПриходнаяНакладная.Выбрать(,,, "Дата");
	Если Выборка.Следующий() Тогда
		Если МинимальнаяДатаНачала = Неопределено Или Выборка.Дата < МинимальнаяДатаНачала Тогда
			МинимальнаяДатаНачала = Выборка.Дата;
		КонецЕсли;
	КонецЕсли;
	
	// РН
	Выборка = Документы.РасходнаяНакладная.Выбрать(,,, "Дата");
	Если Выборка.Следующий() Тогда
		Если МинимальнаяДатаНачала = Неопределено Или Выборка.Дата < МинимальнаяДатаНачала Тогда
			МинимальнаяДатаНачала = Выборка.Дата;
		КонецЕсли;
	КонецЕсли;
	
	// ВводНачальныхОстатков
	Выборка = Документы.ВводНачальныхОстатков.Выбрать(,,, "Дата");
	Если Выборка.Следующий() Тогда
		Если МинимальнаяДатаНачала = Неопределено Или Выборка.Дата < МинимальнаяДатаНачала Тогда
			МинимальнаяДатаНачала = Выборка.Дата;
		КонецЕсли;
	КонецЕсли;
	
	// ЗапасыНаСкладах
	Выборка = РегистрыНакопления.ЗапасыНаСкладах.Выбрать(); //(,,, "Период");
	Если Выборка.Следующий() Тогда
		Если МинимальнаяДатаНачала = Неопределено Или Выборка.Период < МинимальнаяДатаНачала Тогда
			МинимальнаяДатаНачала = Выборка.Период;
		КонецЕсли;
	КонецЕсли;
	
	// ЗакупкиДляКУДиР
	Выборка = РегистрыНакопления.ЗакупкиДляКУДиР.Выбрать(); //(,,, "Период");
	Если Выборка.Следующий() Тогда
		Если МинимальнаяДатаНачала = Неопределено Или Выборка.Период < МинимальнаяДатаНачала Тогда
			МинимальнаяДатаНачала = Выборка.Период;
		КонецЕсли;
	КонецЕсли;
	
	Если МинимальнаяДатаНачала = Неопределено Тогда
		МинимальнаяДатаНачала = '00010101';
	КонецЕсли;
	
	Возврат НачалоМесяца(НачалоГода(МинимальнаяДатаНачала) - 1);
	
КонецФункции

&НаКлиенте
Процедура ДекорацияОткрытьПартииНажатие(Элемент)
	ОткрытьФорму("РегистрНакопления.ПартииТоваровДляКУДиР.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияДатыИзмененныхДокументовНажатие(Элемент)
	ОткрытьФорму("РегистрСведений.ДатыИзмененныхДокументов.ФормаСписка");
КонецПроцедуры
