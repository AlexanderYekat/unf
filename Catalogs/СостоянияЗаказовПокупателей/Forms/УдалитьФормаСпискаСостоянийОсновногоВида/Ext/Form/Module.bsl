﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВидыЗаказовПокупателей") Тогда
		ВызватьИсключение НСтр("ru='Включена функциональная опция использования видов заказов покупателей.
			| Используйте список состояний.'");
	КонецЕсли;
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеСостоянияЗавершен(СписокСостояний.КомпоновщикНастроек.Настройки.УсловноеОформление,
		ПредопределенноеЗначение("Справочник.СостоянияЗаказовПокупателей.Завершен"));
	
	УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	
	СписокСостояний.Порядок.Элементы.Очистить();
	
	Порядок = СписокСостояний.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	Порядок.Использование = Истина;
	Порядок.Поле = Новый ПолеКомпоновкиДанных("ЗавершенПоследним");
	Порядок.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
	Порядок = СписокСостояний.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	Порядок.Использование = Истина;
	Порядок.Поле = Новый ПолеКомпоновкиДанных("НомерСтроки");
	Порядок.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
	// Установим настройки формы для случая открытия в режиме выбора
	Элементы.СписокСостояний.РежимВыбора = Параметры.РежимВыбора;
	Элементы.СписокСостояний.МножественныйВыбор = ?(Параметры.ЗакрыватьПриВыборе = Неопределено, Ложь, Не Параметры.ЗакрыватьПриВыборе);
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = КлючНазначенияИспользования + "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе
		КлючНазначенияИспользования = КлючНазначенияИспользования + "Список";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СостоянияЗаказовПокупателей" Тогда
		УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокСостоянийПриАктивизацииСтроки(Элемент)
	
	Если Элементы.СписокСостояний.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.КнопкиВверхВниз.Доступность =
		Элементы.СписокСостояний.ТекущаяСтрока <> ПредопределенноеЗначение("Справочник.СостоянияЗаказовПокупателей.Завершен")
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПереместитьЭлементВверх(Команда)
	
	ПереместитьЭлемент(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлементВниз(Команда)
	
	ПереместитьЭлемент(1);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеПоЦветамСостоянийСервер()
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеПоЦветамСостояний(СписокСостояний.КомпоновщикНастроек.Настройки.УсловноеОформление,
		Метаданные.Справочники.СостоянияЗаказовПокупателей.ПолноеИмя(),
		"Ссылка");
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлемент(Смещение)
	
	Если Не ЗначениеЗаполнено(Элементы.СписокСостояний.ТекущаяСтрока)
		Или Элементы.СписокСостояний.ТекущаяСтрока = ПредопределенноеЗначение("Справочник.СостоянияЗаказовПокупателей.Завершен") Тогда
		
		Возврат;
	КонецЕсли;
	
	СостоянияЗаказовВызовСервера.ПереместитьСостояние("Справочник.ВидыЗаказовПокупателей",
		Элементы.СписокСостояний.ТекущаяСтрока,
		Смещение);
	Элементы.СписокСостояний.Обновить();
	
	Оповестить("Запись_ВидыЗаказовПокупателей", ПредопределенноеЗначение("Справочник.ВидыЗаказовПокупателей.Основной"), ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
