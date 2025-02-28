﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что в расположенным ниже коде,
	// реализована логика, которая должна выполняться в том числе при установке этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный план обмена).
	
	Если ЭтоНовый() Тогда
		Если Не СводноеПриложениеВыгрузка И Не СводноеПриложениеЗагрузка Тогда
			УстановитьПризнакИспользованияМиграции(Истина);
		ИначеЕсли СводноеПриложениеВыгрузка Тогда 	
			УстановитьПризнакИспользованияВыгрузкиДанныхВСводноеПриложение(Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что в расположенным ниже коде,
	// реализована логика, которая должна выполняться в том числе при установке этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный план обмена).
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(Ссылка);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не СводноеПриложениеВыгрузка И Не СводноеПриложениеЗагрузка Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Разделитель", ОбластьДанныхОсновныеДанные);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК Проверка
		|ИЗ
		|	ПланОбмена.МиграцияПриложений КАК МиграцияПриложений
		|ГДЕ
		|	НЕ МиграцияПриложений.ЭтотУзел
		|	И МиграцияПриложений.ОбластьДанныхОсновныеДанные = &Разделитель
		|	И МиграцияПриложений.Ссылка <> &Ссылка
		|	И НЕ МиграцияПриложений.СводноеПриложениеВыгрузка
		|	И НЕ МиграцияПриложений.СводноеПриложениеЗагрузка";
		Использование = Не Запрос.Выполнить().Пустой();
		
		УстановитьПризнакИспользованияМиграции(Использование);
		
	ИначеЕсли СводноеПриложениеВыгрузка Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Разделитель", ОбластьДанныхОсновныеДанные);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК Проверка
		|ИЗ
		|	ПланОбмена.МиграцияПриложений КАК МиграцияПриложений
		|ГДЕ
		|	НЕ МиграцияПриложений.ЭтотУзел
		|	И МиграцияПриложений.ОбластьДанныхОсновныеДанные = &Разделитель
		|	И МиграцияПриложений.Ссылка <> &Ссылка
		|	И МиграцияПриложений.СводноеПриложениеВыгрузка";
		Использование = Не Запрос.Выполнить().Пустой();
		
		УстановитьПризнакИспользованияВыгрузкиДанныхВСводноеПриложение(Использование);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПризнакИспользованияМиграции(Использование)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
	
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.ИспользуетсяМиграцияПриложений");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		МенеджерЗначения = Константы.ИспользуетсяМиграцияПриложений.СоздатьМенеджерЗначения();
		МенеджерЗначения.ОбластьДанныхВспомогательныеДанные = ОбластьДанныхОсновныеДанные;
		МенеджерЗначения.Прочитать();
		Если Не МенеджерЗначения.Значение = Использование Тогда
			МенеджерЗначения.Значение = Использование;
			МенеджерЗначения.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура УстановитьПризнакИспользованияВыгрузкиДанныхВСводноеПриложение(Использование)

	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
	
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.ИспользоватьВыгрузкуВСводноеПриложение");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		МенеджерЗначения = Константы.ИспользоватьВыгрузкуВСводноеПриложение.СоздатьМенеджерЗначения();
		МенеджерЗначения.Прочитать();
		Если Не МенеджерЗначения.Значение = Использование Тогда
			МенеджерЗначения.Значение = Использование;
			МенеджерЗначения.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли