﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗарегистрироватьВходящийЗвонок(ПользовательКому, АбонентОтКого, НомерТелефонаАбонента) Экспорт
	
	ИдентификаторЗвонка = Новый УникальныйИдентификатор;
	
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.ПользовательКому.Установить(ПользовательКому);
	Набор.Отбор.ИдентификаторЗвонка.Установить(ИдентификаторЗвонка);
	
	ЗаписьНабора = Набор.Добавить();
	ЗаписьНабора.ПользовательКому		= ПользовательКому;
	ЗаписьНабора.ИдентификаторЗвонка	= ИдентификаторЗвонка;
	ЗаписьНабора.АбонентОтКого			= АбонентОтКого;
	ЗаписьНабора.ДатаЗвонка				= ТекущаяДатаСеанса();
	ЗаписьНабора.НомерТелефонаАбонента	= НомерТелефонаАбонента;
	
	Набор.Записать(Истина);
	
КонецПроцедуры

Процедура ПередУдалениемСобытия(Событие) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТекущиеВходящиеЗвонки.ПользовательКому КАК ПользовательКому
	|ИЗ
	|	РегистрСведений.ТекущиеВходящиеЗвонки КАК ТекущиеВходящиеЗвонки
	|ГДЕ
	|	ТекущиеВходящиеЗвонки.Событие = &Событие";
	
	Запрос.УстановитьПараметр("Событие", Событие);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ТекущиеВходящиеЗвонки.СоздатьНаборЗаписей();
	
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей.Отбор.ПользовательКому.Установить(Выборка.ПользовательКому);
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередУдалениемКонтакта(Контакт) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТекущиеВходящиеЗвонки.ПользовательКому КАК ПользовательКому
	|ИЗ
	|	РегистрСведений.ТекущиеВходящиеЗвонки КАК ТекущиеВходящиеЗвонки
	|ГДЕ
	|	ТекущиеВходящиеЗвонки.АбонентОтКого = &АбонентОтКого";
	
	Запрос.УстановитьПараметр("АбонентОтКого", Контакт);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ТекущиеВходящиеЗвонки.СоздатьНаборЗаписей();
	
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей.Отбор.ПользовательКому.Установить(Выборка.ПользовательКому);
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли