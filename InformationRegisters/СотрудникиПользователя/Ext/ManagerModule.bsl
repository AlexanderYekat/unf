﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет запись в регистр по переданным параметрам
//
// СоответствиеДанных - (Соответствие) Соответствие данных, где
//
//		Ключ - (Справочник.Сотрудники) Сотрудник, который назначается пользователю;
//		Значение - (Справочник.Пользователи) Пользователь, который связывается с сотрудником
//
Процедура ДобавитьСотрудниковПользователей(СоответствиеДанных) Экспорт
	
	Для каждого ЭлементСоответствия Из СоответствиеДанных Цикл
		
		МенеджерЗаписи = РегистрыСведений.СотрудникиПользователя.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Сотрудник = ЭлементСоответствия.Ключ;
		МенеджерЗаписи.Пользователь = ЭлементСоответствия.Значение;
		МенеджерЗаписи.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры // ДобавитьСотрудникаПользователя()

// Функция возвращает массив сотрудников для указанного пользователя
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи	 - пользователь, для которого получаются сотрудники. Если не указан, то для текущего пользователя
// 
// Возвращаемое значение:
//  Массив - массив типов СправочникСсылка.Сотрудники
//
Функция ПолучитьСотрудниковПользователя(Пользователь = Неопределено, ПолучатьНедействительных = Ложь) Экспорт
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиПользователя.Сотрудник КАК Сотрудник
		|ИЗ
		|	РегистрСведений.СотрудникиПользователя КАК СотрудникиПользователя
		|ГДЕ
		|	СотрудникиПользователя.Пользователь = &Пользователь
		|	И ВЫБОР
		|			КОГДА &ПолучатьНедействительных
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ НЕ СотрудникиПользователя.Сотрудник.Недействителен
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	СотрудникиПользователя.Сотрудник.Наименование";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("ПолучатьНедействительных", ПолучатьНедействительных);
	
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник");
	
	Возврат Результат;
	
КонецФункции

// Функция возвращает массив сотрудников для указанного пользователя
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи	 - пользователь, для которого получаются сотрудники
// 
// Возвращаемое значение:
//  Массив - массив типов СправочникСсылка.Сотрудники
//
Функция ПолучитьПользователяПоСотруднику(Сотрудник, ПолучатьНедействительных = Ложь) Экспорт
	
	Результат = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СотрудникиПользователя.Пользователь КАК Пользователь
		|ИЗ
		|	РегистрСведений.СотрудникиПользователя КАК СотрудникиПользователя
		|ГДЕ
		|	СотрудникиПользователя.Сотрудник = &Сотрудник
		|	И ВЫБОР
		|			КОГДА &ПолучатьНедействительных
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ НЕ СотрудникиПользователя.Пользователь.Недействителен
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	СотрудникиПользователя.Пользователь.Наименование";
	
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("ПолучатьНедействительных", ПолучатьНедействительных);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Результат = Выборка.Пользователь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли