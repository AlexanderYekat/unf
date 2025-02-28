﻿#Область ПрограммныйИнтерфейс

#Область ЗакрытиеФормыПроверкиИПодбора

Процедура ПриЗакрытииФормыПроверкиИПодбора(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ЭтоАдресВременногоХранилища(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	Форма        = ДополнительныеПараметры.Форма;
	ВидПродукции = ДополнительныеПараметры.ВидПродукции;
	
	Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная") Тогда
		Оповестить("ЗакрытиеФормыПроверкиИПодбораЕГАИС", Результат, Форма.УникальныйИдентификатор);
	Иначе
		Событие = СтрШаблон("ЗакрытиеФормыПроверкиИПодбораГосИС%1", ОбщегоНазначенияИСКлиентСервер.ИндексВидаПродукцииИС(ДополнительныеПараметры.ВидПродукции));
		Оповестить(Событие, Результат, Форма.УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Процедура ПослеЗаписи(Форма, ПараметрыЗаписи) Экспорт
	
	СобытияФормИСКлиент.ПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("КэшированныеЗначения",    Неопределено);
		ДополнительныеПараметры.Вставить("СтандартнаяОбработка",    Истина);
		ДополнительныеПараметры.Вставить("ТребуетсяСерверныйВызов", Ложь);
	КонецЕсли;
	
	Если Форма.ИмяФормы = "Документ.ПередачаТоваровМеждуОрганизациями.Форма.ФормаДокумента"
		ИЛИ Форма.ИмяФормы = "Документ.РасходнаяНакладная.Форма.ФормаДокумента" Тогда
		Если Форма.КэшДанныхГОСИС.Свойство("ИнтеграцияВЕТИС") Тогда
			ИнтеграцияИСКлиент.ОбработкаОповещенияВФормеДокументаОснования(
				Форма,
				Форма.Объект,
				ИмяСобытия,
				Параметр,
				Источник);
		КонецЕсли;
	КонецЕсли;
	
	СобытияФормИСКлиент.ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	СобытияФормИСКлиент.ОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ВыполнитьПереопределяемуюКоманду(Форма, Команда, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	СобытияФормИСКлиент.ВыполнитьПереопределяемуюКоманду(Форма, Команда, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если НЕ Форма.КэшДанныхГОСИС.Свойство("Инициализация") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	Если Элемент = "ТабличнаяЧасть" Тогда
		ИмяТабличнойЧасти = Форма.КэшДанныхГОСИС.ИмяТабличнойЧасти;
		
		Если ДополнительныеПараметры.Свойство("ПриНачалеРедактирования") Тогда
			ИнтеграцияИСУНФКлиент.КешироватьТекущуюСтроку(Форма, ИмяТабличнойЧасти);
		ИначеЕсли ДополнительныеПараметры.Свойство("ПередУдалением") Тогда
			ИнтеграцияИСУНФКлиент.КешироватьТекущуюСтроку(Форма, ИмяТабличнойЧасти);
			СобытияФормИСКлиент.ПриИзмененииЭлемента(Форма, ИмяТабличнойЧасти, ДополнительныеПараметры);
		ИначеЕсли ДополнительныеПараметры.Свойство("ПриОкончанииРедактирования")
			ИЛИ ДополнительныеПараметры.Свойство("ПослеУдаления") Тогда
			СобытияФормИСКлиент.ПриИзмененииЭлемента(Форма, ИмяТабличнойЧасти, ДополнительныеПараметры);
			Если ДополнительныеПараметры.Свойство("ТребуетсяСерверныйВызов") Тогда
				ОбработчикОповещения = Новый ОписаниеОповещения(ДополнительныеПараметры.ОповещениеСерверногоВызова, Форма, ДополнительныеПараметры);
				ВыполнитьОбработкуОповещения(ОбработчикОповещения);
			КонецЕсли;
		КонецЕсли;
	Иначе
		СобытияФормИСКлиент.ПриИзмененииЭлемента(Форма, ИмяТабличнойЧасти, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ЕГАИС

Процедура ОбработатьВыборТТНЕГАИСИзСписка(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИСВызовСервера.ЗаписатьСвязьДокументаПоступленияИТТНЕГАИС(
		Результат,
		ДополнительныеПараметры.Форма.Объект.Ссылка);
		
	СформироватьТекстДокументаЕГАИС(ДополнительныеПараметры.Форма);
	
КонецПроцедуры

Процедура СформироватьТекстДокументаЕГАИС(Форма, ОчищатьВместоИзмененияВидимости = Ложь) Экспорт
	
	ПараметрыИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить("ЕГАИС");
	Объект = Форма[ПараметрыИнтеграции.ИмяРеквизитаФормыОбъект];
	
	ПараметрыИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить("ЕГАИС.ДокументОснование");
	ЭлементИнтерфейса  = Форма.Элементы[ПараметрыИнтеграции.ИмяЭлементаФормы];
	
	Если Форма.ИмяФормы = "Документ.ПриходнаяНакладная.Форма.ФормаДокумента" Тогда
		ТекстГиперссылки = ИнтеграцияЕГАИСУНФВызовСервера.ТекстДокументаЕГАИСВПриходнойНакладной(Объект, Форма.ТТНВходящаяЕГАИС);
	Иначе
		ТекстГиперссылки = ИнтеграцияЕГАИСВызовСервера.ТекстДокументаЕГАИС(Объект.Ссылка);
	КонецЕсли;
	
	ЭлементИнтерфейса.Видимость = ОчищатьВместоИзмененияВидимости ИЛИ ЗначениеЗаполнено(ТекстГиперссылки);
	Форма[ПараметрыИнтеграции.ИмяРеквизитаФормы] = ТекстГиперссылки;
	
КонецПроцедуры

Процедура ПриЗакрытииФормыСопоставленнойАлкогольнойПродукции(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	Форма.Элементы.СопоставленнаяАлкогольнаяПродукция.Заголовок = ИнтеграцияЕГАИСУНФВызовСервера.ПредставлениеСопоставленнойАлкогольнойПродукция(
		Форма.Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти