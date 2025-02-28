﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#Область ОбновлениеВерсииИБ

// Определяет настройки начального заполнения элементов.
//
// Параметры:
//  Настройки - Структура - настройки заполнения
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Истина;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	Если Справочники.ШаблоныЗаполненияГрафиковРабочегоВремени.Выбрать().Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	ГруппаШаблоновПоДнямНедели = Элементы.Добавить();
	ГруппаШаблоновПоДнямНедели.Наименование = НСтр("ru='Шаблоны по дням недели'");
	ГруппаШаблоновПоДнямНедели.ЭтоГруппа = Истина;
	ГруппаШаблоновПоДнямНедели.Ссылка = Справочники.ШаблоныЗаполненияГрафиковРабочегоВремени.ПолучитьСсылку(Новый УникальныйИдентификатор);
	
	ГруппаШаблоновСменные = Элементы.Добавить();
	ГруппаШаблоновСменные.Наименование = НСтр("ru='Шаблоны сменные'");
	ГруппаШаблоновСменные.ЭтоГруппа = Истина;
	ГруппаШаблоновСменные.Ссылка = Справочники.ШаблоныЗаполненияГрафиковРабочегоВремени.ПолучитьСсылку(Новый УникальныйИдентификатор);
	
	
	// Пятидневка.
	Элемент = Элементы.Добавить();
	Элемент.Наименование = НСтр("ru='Шаблон пятидневка'");
	Элемент.Родитель = ГруппаШаблоновПоДнямНедели.Ссылка;
	Элемент.УчитыватьПраздничныеДни = Истина;
	Элемент.ВидГрафикаПоДнямНедели = Истина;
	Элемент.ТипГрафика = Перечисления.ТипыГрафикаРаботы.КалендарныеДни;
	
	РасписаниеРаботы = ТабличныеЧасти.РасписаниеРаботы.Скопировать();
	ПерерывыРаботы = ТабличныеЧасти.Перерывы.Скопировать();
	ПериодыРаботы = ТабличныеЧасти.Периоды.Скопировать();
	
	Для ИндексДня = 1 По 7 Цикл
		Если ИндексДня <= 5 Тогда
			НоваяСтрокаРасписания = РасписаниеРаботы.Добавить();
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.ВремяНачала = Дата(1,1,1,8,0,0);
			НоваяСтрокаРасписания.ВремяОкончания = Дата(1,1,1,17,0,0);
			НоваяСтрокаРасписания.КоличествоРабочихЧасов = 8;
			НоваяСтрокаРасписания.ВремяПерерывов = 1;
			НоваяСтрокаРасписания.Активность = Истина;
			
			НоваяСтрокаПерерыв = ПерерывыРаботы.Добавить();
			НоваяСтрокаПерерыв.ВремяНачала = Дата(1,1,1,12,00,0);
			НоваяСтрокаПерерыв.ВремяОкончания = Дата(1,1,1,13,00,0);
			НоваяСтрокаПерерыв.Длительность = 1;
			НоваяСтрокаПерерыв.НомерДня = ИндексДня;
			
			НоваяСтрокаПериода = ПериодыРаботы.Добавить();
			НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1,8,0,0);
			НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1,12,0,0);
			НоваяСтрокаПериода.Длительность = 4;
			НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
			
			НоваяСтрокаПериода = ПериодыРаботы.Добавить();
			НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1,13,0,0);
			НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1,17,0,0);
			НоваяСтрокаПериода.Длительность = 4;
			НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
		Иначе
			НоваяСтрокаРасписания = РасписаниеРаботы.Добавить();
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.Активность = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Элемент.РасписаниеРаботы = РасписаниеРаботы;
	Элемент.Перерывы = ПерерывыРаботы;
	Элемент.Периоды = ПериодыРаботы;
	
	
	
	// Шестидневка.
	Элемент = Элементы.Добавить();
	Элемент.Наименование = НСтр("ru='Шаблон шестидневка'");
	Элемент.Родитель = ГруппаШаблоновПоДнямНедели.Ссылка;
	Элемент.УчитыватьПраздничныеДни = Истина;
	Элемент.ВидГрафикаПоДнямНедели = Истина;
	Элемент.ТипГрафика = Перечисления.ТипыГрафикаРаботы.КалендарныеДни;
	
	РасписаниеРаботы = ТабличныеЧасти.РасписаниеРаботы.Скопировать();
	ПерерывыРаботы = ТабличныеЧасти.Перерывы.Скопировать();
	ПериодыРаботы = ТабличныеЧасти.Периоды.Скопировать();
	
	Для ИндексДня = 1 По 7 Цикл
		Если ИндексДня <= 6 Тогда
			НоваяСтрокаРасписания = РасписаниеРаботы.Добавить();
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.ВремяНачала = Дата(1,1,1,8,0,0);
			НоваяСтрокаРасписания.ВремяОкончания = Дата(1,1,1,17,0,0);
			НоваяСтрокаРасписания.КоличествоРабочихЧасов = 8;
			НоваяСтрокаРасписания.ВремяПерерывов = 1;
			НоваяСтрокаРасписания.Активность = Истина;
			
			НоваяСтрокаПерерыв = ПерерывыРаботы.Добавить();
			НоваяСтрокаПерерыв.ВремяНачала = Дата(1,1,1,12,00,0);
			НоваяСтрокаПерерыв.ВремяОкончания = Дата(1,1,1,13,00,0);
			НоваяСтрокаПерерыв.Длительность = 1;
			НоваяСтрокаПерерыв.НомерДня = ИндексДня;
			
			НоваяСтрокаПериода = ПериодыРаботы.Добавить();
			НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1,8,0,0);
			НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1,12,0,0);
			НоваяСтрокаПериода.Длительность = 4;
			НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
			
			НоваяСтрокаПериода = ПериодыРаботы.Добавить();
			НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1,13,0,0);
			НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1,17,0,0);
			НоваяСтрокаПериода.Длительность = 4;
			НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
		Иначе
			НоваяСтрокаРасписания = РасписаниеРаботы.Добавить();
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.Активность = Истина
		КонецЕсли;
	КонецЦикла;
	
	Элемент.РасписаниеРаботы = РасписаниеРаботы;
	Элемент.Перерывы = ПерерывыРаботы;
	Элемент.Периоды = ПериодыРаботы;
	
	
	
	// Сменный: 2 через 2.
	Элемент = Элементы.Добавить();
	Элемент.Наименование = НСтр("ru='Шаблон сменный 12 часов 2 через 2'");
	Элемент.Родитель = ГруппаШаблоновСменные.Ссылка;
	Элемент.ВидГрафикаПоЦикламПроизвольнойДлины = Истина;
	Элемент.ТипГрафика = Перечисления.ТипыГрафикаРаботы.Сменный;
	
	РасписаниеРаботы = ТабличныеЧасти.РасписаниеРаботы.Скопировать();
	ПериодыРаботы = ТабличныеЧасти.Периоды.Скопировать();
	
	Для ИндексДня = 1 По 4 Цикл
		Если ИндексДня <= 2 Тогда
			НоваяСтрокаРасписания = РасписаниеРаботы.Добавить();
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.КоличествоРабочихЧасов = 12;
			НоваяСтрокаРасписания.Активность = Истина;
			
			НоваяСтрокаПериода = ПериодыРаботы.Добавить();
			НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1);
			НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1);
			НоваяСтрокаПериода.Длительность = 12;
			НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
		Иначе
			НоваяСтрокаРасписания = РасписаниеРаботы.Добавить();
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.Активность = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Элемент.РасписаниеРаботы = РасписаниеРаботы;
	Элемент.Периоды = ПериодыРаботы;
	
	
	
	// Сменный: сутки через трое.
	Элемент = Элементы.Добавить();
	Элемент.Наименование = НСтр("ru='Шаблон сменный сутки через трое'");
	Элемент.Родитель = ГруппаШаблоновСменные.Ссылка;
	Элемент.ВидГрафикаПоЦикламПроизвольнойДлины = Истина;
	Элемент.ТипГрафика = Перечисления.ТипыГрафикаРаботы.Сменный;
	
	РасписаниеРаботы = ТабличныеЧасти.РасписаниеРаботы.Скопировать();
	ПериодыРаботы = ТабличныеЧасти.Периоды.Скопировать();
	
	Для ИндексДня = 1 По 4 Цикл
		Если ИндексДня = 1 Тогда
			НоваяСтрокаРасписания = РасписаниеРаботы.Добавить();
			
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.КоличествоРабочихЧасов = 24;
			
			НоваяСтрокаПериода = ПериодыРаботы.Добавить();
			НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1);
			НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1);
			НоваяСтрокаПериода.Длительность = 24;
			НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
			
			НоваяСтрокаРасписания.Активность = Истина;
		Иначе
			НоваяСтрокаРасписания = РасписаниеРаботы.Добавить();
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.Активность = Ложь
		КонецЕсли;
	КонецЦикла;
	
	Элемент.РасписаниеРаботы = РасписаниеРаботы;
	Элемент.Периоды = ПериодыРаботы;
	
	
	
	// Сменный: 3 через 1 (железнодорожный).
	Элемент = Элементы.Добавить();
	Элемент.Наименование = НСтр("ru='Шаблон сменный 3 через 1 (железнодорожный)'");
	Элемент.Родитель = ГруппаШаблоновСменные.Ссылка;
	Элемент.ВидГрафикаПоЦикламПроизвольнойДлины = Истина;
	Элемент.ТипГрафика = Перечисления.ТипыГрафикаРаботы.Сменный;
	
	РасписаниеРаботы = ТабличныеЧасти.РасписаниеРаботы.Скопировать();
	ПериодыРаботы = ТабличныеЧасти.Периоды.Скопировать();
	
	Для ИндексДня = 1 По 4 Цикл
		Если ИндексДня <= 3 Тогда
			НоваяСтрокаРасписания = РасписаниеРаботы.Добавить();
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			
			Если ИндексДня = 1 Тогда
				НоваяСтрокаРасписания.КоличествоРабочихЧасов = 12;
				
				НоваяСтрокаПериода = ПериодыРаботы.Добавить();
				НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1);
				НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1);
				НоваяСтрокаПериода.Длительность = 12;
				НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
				
			ИначеЕсли ИндексДня = 2 Тогда
				НоваяСтрокаРасписания.КоличествоРабочихЧасов = 4;
				НоваяСтрокаПериода = ПериодыРаботы.Добавить();
				
				НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1);
				НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1);
				НоваяСтрокаПериода.Длительность = 4;
				НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
			ИначеЕсли ИндексДня = 3 Тогда
				НоваяСтрокаРасписания.КоличествоРабочихЧасов = 8;
				
				НоваяСтрокаПериода = ПериодыРаботы.Добавить();
				НоваяСтрокаПериода.ВремяНачала = Дата(1,1,1);
				НоваяСтрокаПериода.ВремяОкончания = Дата(1,1,1);
				НоваяСтрокаПериода.Длительность = 8;
				НоваяСтрокаПериода.НомерДняЦикла = ИндексДня;
			КонецЕсли;
			
			НоваяСтрокаРасписания.Активность = Истина;
		Иначе
			НоваяСтрокаРасписания = РасписаниеРаботы.Добавить();
			НоваяСтрокаРасписания.НомерДняЦикла = ИндексДня;
			НоваяСтрокаРасписания.Активность = Ложь
		КонецЕсли;
	КонецЦикла;
	
	Элемент.РасписаниеРаботы = РасписаниеРаботы;
	Элемент.Периоды = ПериодыРаботы;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлемента
//
// Параметры:
//  Объект                  - СправочникОбъект.ВидыКонтактнойИнформации - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения объекта.
//  ДополнительныеПараметры - Структура:
//   * ПредопределенныеДанные - ТаблицаЗначений - данные заполненные в процедуре ПриНачальномЗаполненииЭлементов.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	Объект.УстановитьНовыйКод();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если Не Параметры.Отбор.Свойство("Недействителен") Тогда
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
