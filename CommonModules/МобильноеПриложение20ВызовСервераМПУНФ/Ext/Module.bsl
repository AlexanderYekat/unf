﻿#Область СлужебныйПрограммныйИнтерфейс

Функция ВключенПробныйПериод() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВключенПробныйПериодМПУНФ.Значение КАК Значение
	|ИЗ
	|	Константа.ВключенПробныйПериодМПУНФ КАК ВключенПробныйПериодМПУНФ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Значение;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецФункции

#КонецОбласти