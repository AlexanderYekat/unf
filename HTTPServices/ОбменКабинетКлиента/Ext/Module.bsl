﻿
#Область ОбработчикиМетодовHTTP

Функция NotificationPOST(Запрос)
	ВложенноеИмяСобытия = "NotificationPOST";
	Ответ = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		ТелоЗапроса = Запрос.ПолучитьТелоКакСтроку();
		ПараметрыТела = ОтправкаЗапросов.ПрочитатьJSONВСтруктуру(ТелоЗапроса);
		
		ОбязательныеПараметры = "Публикация,Оповещение";
		ПроверитьОбязательныеПараметры(ПараметрыТела, ОбязательныеПараметры, Ответ);
		Если Ответ <> Неопределено Тогда
			Возврат Ответ;
		КонецЕсли;
		
		НастройкаИнтеграции = ПроверитьПолучитьНастройкаИнтеграции(ПараметрыТела.Публикация, Ответ);
		Если Ответ <> Неопределено Тогда
			Возврат Ответ;
		КонецЕсли;
		
		Если ПараметрыТела.Оповещение = "ЗаказКлиентаИзменен" Тогда
			ОбработатьИзменениеЗаказаКлиента(НастройкаИнтеграции);
		КонецЕсли;
		
	Исключение
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР(ВложенноеИмяСобытия), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		
		Ответ = Новый HTTPСервисОтвет(500);
		Ответ.УстановитьТелоИзСтроки(ТекстОшибки);
		Возврат Ответ;
		
	КонецПопытки;
	
	Ответ = Новый HTTPСервисОтвет(202);
	Возврат Ответ;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяСобытияЖР(ВложенноеИмяСобытия = "")
	
	ИмяСобытия = НСтр("ru='НастройкиПубликацииМЛК'", ОбщегоНазначения.КодОсновногоЯзыка());
	
	Если ЗначениеЗаполнено(ВложенноеИмяСобытия) Тогда
		ИмяСобытия = ИмяСобытия + "." + ВложенноеИмяСобытия;
	КонецЕсли;
	
	Возврат ИмяСобытия;
	
КонецФункции

Процедура ПроверитьОбязательныеПараметры(ПараметрыТела, ОбязательныеПараметры, Ответ)
	
	ОтсутствующиеПараметрыМассив = Новый Массив;
	
	Если ТипЗнч(ОбязательныеПараметры) = Тип("Строка") Тогда
		МассивПараметров = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ОбязательныеПараметры);
	Иначе
		МассивПараметров = ОбязательныеПараметры;
	КонецЕсли;
	
	Для Каждого ОбязательныйПараметр Из МассивПараметров Цикл
		Если НЕ ПараметрыТела.Свойство(ОбязательныйПараметр) Тогда
			ОтсутствующиеПараметрыМассив.Добавить(ОбязательныйПараметр);
		КонецЕсли;
	КонецЦикла;
	
	Если ОтсутствующиеПараметрыМассив.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОтсутствующиеПараметры = СтрСоединить(ОтсутствующиеПараметрыМассив, ",");
	ТекстОшибки = СтрШаблон(
		НСтр("ru='Отсутствуют обязательные параметры: %1'"),
		ОтсутствующиеПараметры);
	Ответ = Новый HTTPСервисОтвет(400);
	Ответ.УстановитьТелоИзСтроки(ТекстОшибки);
	
КонецПроцедуры

Функция ПроверитьПолучитьНастройкаИнтеграции(ИдентификаторПубликации, Ответ)
	
	НастройкаПубликацииМЛК = НастройкаПубликацииМЛКПоИдентификатору(ИдентификаторПубликации);
	НастройкаИнтеграции = Справочники.НастройкиПубликацииМЛК.НастройкиИнтеграцииКабинетКлиента(НастройкаПубликацииМЛК);
	
	Если НастройкаИнтеграции = Неопределено Тогда
		
		ТекстОшибки = НСтр("ru='Настройка публикации не найдена.'");
		Ответ = Новый HTTPСервисОтвет(400);
		Ответ.УстановитьТелоИзСтроки(ТекстОшибки);
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Возврат НастройкаИнтеграции;
	
КонецФункции

Функция НастройкаПубликацииМЛКПоИдентификатору(ИдентификаторСтрокой)
	
	УникальныйИдентификатор = Новый УникальныйИдентификатор(ИдентификаторСтрокой);
	Возврат Справочники.НастройкиПубликацииМЛК.ПолучитьСсылку(УникальныйИдентификатор);
	
КонецФункции

Процедура ОбработатьИзменениеЗаказаКлиента(НастройкаИнтеграции)
	
	УзелОбмена = ОбменДаннымиСервер.УзелПланаОбменаПоКоду(
		Метаданные.ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Имя,
		НастройкаИнтеграции.КодУзлаОбмена);
	
	Отказ = Ложь;
	ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
	ПараметрыОбмена.ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.WS;
	
	МетодВыполнитьОбмен = "КонструкторМобильногоПриложения.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы";
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияПроцедуры();
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения, МетодВыполнитьОбмен, УзелОбмена, ПараметрыОбмена, Отказ);
	
КонецПроцедуры

#КонецОбласти