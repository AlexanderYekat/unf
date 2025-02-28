﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ОбязательныеДляЗаполненияРеквизитыОбъекта(Объект) Экспорт
	
	МассивРеквизитов = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбязательностьЗаполненияРеквизитов.Реквизит КАК Реквизит
	|ИЗ
	|	РегистрСведений.ОбязательностьЗаполненияРеквизитов КАК ОбязательностьЗаполненияРеквизитов
	|ГДЕ
	|	ОбязательностьЗаполненияРеквизитов.Объект = &Объект
	|	И ОбязательностьЗаполненияРеквизитов.ОбязательноеЗаполнение = ИСТИНА";
	
	Запрос.УстановитьПараметр("Объект", Объект);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		МассивРеквизитов.Добавить(Выборка.Реквизит);
	КонецЦикла;
	
	Возврат МассивРеквизитов;
	
КонецФункции

Функция ОбязательностьЗаполненияРеквизита(Объект, Реквизит) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОбязательностьЗаполненияРеквизитов.ОбязательноеЗаполнение КАК ОбязательноеЗаполнение
	|ИЗ
	|	РегистрСведений.ОбязательностьЗаполненияРеквизитов КАК ОбязательностьЗаполненияРеквизитов
	|ГДЕ
	|	ОбязательностьЗаполненияРеквизитов.Объект = &Объект
	|	И ОбязательностьЗаполненияРеквизитов.Реквизит = &Реквизит";
	
	Запрос.УстановитьПараметр("Объект", Объект);
	Запрос.УстановитьПараметр("Реквизит", Реквизит);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.ОбязательноеЗаполнение;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ОбъектыДляОбязательногоЗаполненияРеквизита(Реквизит) Экспорт
	
	МассивОбъектов = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбязательностьЗаполненияРеквизитов.Объект КАК Объект
	|ИЗ
	|	РегистрСведений.ОбязательностьЗаполненияРеквизитов КАК ОбязательностьЗаполненияРеквизитов
	|ГДЕ
	|	ОбязательностьЗаполненияРеквизитов.Реквизит = &Реквизит
	|	И ОбязательностьЗаполненияРеквизитов.ОбязательноеЗаполнение = ИСТИНА";
	
	Запрос.УстановитьПараметр("Реквизит", Реквизит);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		МассивОбъектов.Добавить(Выборка.Объект);
	КонецЦикла;
	
	Возврат МассивОбъектов;
	
КонецФункции

#КонецОбласти

#КонецЕсли
