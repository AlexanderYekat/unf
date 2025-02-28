﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВидыЗаказНарядов") Тогда
		ВызватьИсключение НСтр("ru='Включена функциональная опция использования видов заказ-нарядов.
			| Используйте список состояний.'");
	КонецЕсли;
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеСостоянияЗавершен(СписокСостояний.КомпоновщикНастроек.Настройки.УсловноеОформление,
		ПредопределенноеЗначение("Справочник.СостоянияЗаказНарядов.Завершен"));
	
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
	
	СостояниеВыполнения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.ВидыЗаказНарядов.Основной, "СостояниеВыполнения");
	ЗаполнитьСписокВыбораСостоянияВыполнения();
	
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
	
	Если ИмяСобытия = "Запись_СостоянияЗаказНарядов" Тогда
		УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
		ЗаполнитьСписокВыбораСостоянияВыполнения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СостояниеВыполненияПриИзменении(Элемент)
	
	СохранитьСостояниеВыполнения(СостояниеВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСостоянийПриАктивизацииСтроки(Элемент)
	
	Элементы.КнопкиВверхВниз.Доступность =
		Элементы.СписокСостояний.ТекущаяСтрока <> ПредопределенноеЗначение("Справочник.СостоянияЗаказНарядов.Завершен")
	
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
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеПоЦветамСостояний(
		СписокСостояний.КомпоновщикНастроек.Настройки.УсловноеОформление,
		Метаданные.Справочники.СостоянияЗаказНарядов.ПолноеИмя(),
		"Ссылка");
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлемент(Смещение)
	
	Если Не ЗначениеЗаполнено(Элементы.СписокСостояний.ТекущаяСтрока)
		Или Элементы.СписокСостояний.ТекущаяСтрока = ПредопределенноеЗначение("Справочник.СостоянияЗаказНарядов.Завершен") Тогда
		
		Возврат;
	КонецЕсли;
	
	СостоянияЗаказовВызовСервера.ПереместитьСостояние("Справочник.ВидыЗаказНарядов",
		Элементы.СписокСостояний.ТекущаяСтрока,
		Смещение);
	Элементы.СписокСостояний.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьСостояниеВыполнения(СостояниеВыполнения)
	
	ВидОбъект = Справочники.ВидыЗаказНарядов.Основной.ПолучитьОбъект();
	ВидОбъект.СостояниеВыполнения = СостояниеВыполнения;
	ВидОбъект.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораСостоянияВыполнения()
	
	Элементы.СостояниеВыполнения.СписокВыбора.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыЗаказНарядовПорядокСостояний.Состояние КАК Состояние
		|ИЗ
		|	Справочник.ВидыЗаказНарядов.ПорядокСостояний КАК ВидыЗаказНарядовПорядокСостояний
		|ГДЕ
		|	ВидыЗаказНарядовПорядокСостояний.Ссылка = ЗНАЧЕНИЕ(Справочник.ВидыЗаказНарядов.Основной)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВидыЗаказНарядовПорядокСостояний.НомерСтроки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Элементы.СостояниеВыполнения.СписокВыбора.Добавить(Выборка.Состояние);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
