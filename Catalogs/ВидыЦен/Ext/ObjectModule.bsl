﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеОбработчики

Процедура ПодготовитьДополнительныеСвойства()
	
	ДополнительныеСвойства.Вставить("ТаблицыДляДвижений", Новый Структура);
	
КонецПроцедуры

Процедура ЗаписатьНаборыЗаписей()
	
	Для каждого ЗаписьОТаблице Из ДополнительныеСвойства.ТаблицыДляДвижений Цикл
		
		НаборЗаписей = РегистрыСведений[ЗаписьОТаблице.Ключ].СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ВидЦенРасчетный.Установить(Ссылка, Истина);
		НаборЗаписей.Загрузить(ЗаписьОТаблице.Значение);
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПредопределенныеОбработчикиОбъекта

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ТипВидаЦен = Перечисления.ТипыВидовЦен.ДинамическийФормула Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("БазовыйВидЦен");
		МассивНепроверяемыхРеквизитов.Добавить("Процент");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеновыеГруппы.БазовыйВидЦен");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеновыеГруппы.Процент");
		МассивНепроверяемыхРеквизитов.Добавить("СхемаКомпоновкиДанных");
		
	ИначеЕсли ТипВидаЦен = Перечисления.ТипыВидовЦен.ДинамическийПроцент Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаЦены");
		МассивНепроверяемыхРеквизитов.Добавить("Формула");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеновыеГруппы.Формула");
		МассивНепроверяемыхРеквизитов.Добавить("СхемаКомпоновкиДанных");
		
		Если БазовыйВидЦен = Ссылка Тогда
			
			ТекстОшибки = НСтр("ru='Базовый вид цены не может быть равен текущему виду цены'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "БазовыйВидЦен",, Отказ);
			
		КонецЕсли;
		
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("БазовыйВидЦен");
		МассивНепроверяемыхРеквизитов.Добавить("Процент");
		МассивНепроверяемыхРеквизитов.Добавить("Формула");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеновыеГруппы.БазовыйВидЦен");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеновыеГруппы.Процент");
		МассивНепроверяемыхРеквизитов.Добавить("ЦеновыеГруппы.Формула");
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если ПустаяСтрока(ИдентификаторФормул)
		ИЛИ ЦенообразованиеФормулыСервер.НайтиВидЦенПоИдентификатору(ИдентификаторФормул, Ссылка).ИдентификаторЗанят Тогда
		
		ЦенообразованиеФормулыСервер.СформироватьНовыйИдентификаторВидаЦен(ИдентификаторФормул, Наименование);
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ПередЗаписью(Отказ) 
	
	Если ОбменДанными.Загрузка = Истина Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПорядокКолонок)
		И Справочники.ВидыЦен.ПолучитьМаксимальныйПорядокКолонок() <> 0 Тогда
		
		ПорядокКолонок = Справочники.ВидыЦен.ПолучитьМаксимальныйПорядокКолонок() + 1;
		
	КонецЕсли;
	
	Если НЕ ЦенообразованиеФормулыСервер.ИдентификаторВидаЦенКорректный(ИдентификаторФормул) Тогда
		
		ЦенообразованиеФормулыСервер.ИсправитьИдентификаторФормул(Ссылка, ИдентификаторФормул);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриЗаписи объекта
//
Процедура ПриЗаписи(Отказ)
	Перем УдалитьВсеТекущиеЦены;
	
	Если ОбменДанными.Загрузка = Истина Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ТипВидаЦен = Перечисления.ТипыВидовЦен.Статический 
		ИЛИ ТипВидаЦен = Перечисления.ТипыВидовЦен.ПроизвольныйЗапрос
		ИЛИ ТипВидаЦен = Перечисления.ТипыВидовЦен.Расширение Тогда
		
		Справочники.ВидыЦен.ОчиститьСвязиВидовЦен(Ссылка);
		
	КонецЕсли;
	
	ДополнительныеСвойства.Свойство("УдалитьВсеТекущиеЦены", УдалитьВсеТекущиеЦены);
	Если УдалитьВсеТекущиеЦены = Истина Тогда
		
		Справочники.ВидыЦен.УдалитьВсеЦеныПоВидуЦен(Ссылка);
		
	КонецЕсли;
	
	Если НЕ ЦеныАктуальны Тогда
		
		ЦенообразованиеСервер.УстановитьИспользованиеРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОчередьРасчетаЦен, Истина);
		
	КонецЕсли;
	
	Если ТипВидаЦен = Перечисления.ТипыВидовЦен.Статический
		ИЛИ ТипВидаЦен = Перечисления.ТипыВидовЦен.ПроизвольныйЗапрос
		ИЛИ ТипВидаЦен = Перечисления.ТипыВидовЦен.Расширение Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПодготовитьДополнительныеСвойства();
	Справочники.ВидыЦен.ИнициализироватьДанные(Ссылка, ДополнительныеСвойства, ЭтотОбъект);
	
	ЗаписатьНаборыЗаписей();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли