﻿#Область ПроцедурыИФункцииОбщегоНазначения

&НаКлиенте
Процедура РассчитатьСуммуДокумента()
	
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") - Объект.СуммаСкидки;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьВРежимеСинхронизации()
	
	#Если МобильноеПриложениеКлиент Тогда
		// АПК:488-выкл методы безопасного запуска обеспечиваются этой функцией
		МодульОбменМобильноеПриложениеВызовСервера = Вычислить("ОбменМобильноеПриложениеВызовСервера");
		// АПК:488-вкл
		Если ТипЗнч(МодульОбменМобильноеПриложениеВызовСервера) = Тип("ОбщийМодуль") Тогда
			ЭтоРежимСборЗаявок = МодульОбменМобильноеПриложениеВызовСервера.ОбменВключен();
		КонецЕсли;
	#Иначе
		ЭтоРежимСборЗаявок = Ложь;
	#КонецЕсли

	Если ЭтоРежимСборЗаявок И Объект.СуммаСкидки = 0 Тогда
		Элементы.ГруппаВсегоВРежимеСинхронизации.Видимость = Ложь;
		Элементы.ГруппаВсего.Видимость = Истина;
	Иначе
		Элементы.ГруппаВсегоВРежимеСинхронизации.Видимость = Истина;
		Элементы.ГруппаВсего.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьСуммуСкидкиЕслиНужно(СПредупреждением = Ложь)
	
	Если Объект.СуммаСкидки > Объект.Товары.Итог("Сумма")Тогда
		Если СПредупреждением Тогда
			ПоказатьПредупреждение(Новый ОписаниеОповещения("СкорректироватьСуммуСкидкиЕслиНужноЗавершение", ЭтаФорма), НСтр("ru='Сумма скидки не может быть больше суммы документа!';en='Discount amount cannot be greater than the sum of the document!'"),,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
			Возврат;
		КонецЕсли;
		Объект.СуммаСкидки = Объект.Товары.Итог("Сумма");
	КонецЕсли;
	
	УстановитьПроцентСкидки();
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьСуммуСкидкиЕслиНужноЗавершение(ДополнительныеПараметры) Экспорт
	
	Объект.СуммаСкидки = Объект.Товары.Итог("Сумма");
	УстановитьПроцентСкидки();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПроцентСкидки()
	
	ТоварыИтог = Объект.Товары.Итог("Сумма");
	Если ТоварыИтог <> 0 Тогда
		Скидка = Окр(Объект.СуммаСкидки / ТоварыИтог * 100, 0);
		ПроцентСкидки = Строка(Скидка) + "%";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеТоварПриИзменении(СтруктураДанных)
	
	ТоварСсылка = СтруктураДанных.Товар;
	
	Если ЗначениеЗаполнено(ТоварСсылка) Тогда
		ТоварОбъект = ТоварСсылка.ПолучитьОбъект();
		ТоварЦена = ?(СтруктураДанных.ПриходТовара, ТоварОбъект.ПолучитьЦенуПоставщиков(), ТоварОбъект.ПолучитьЦенуПродажи());
	Иначе
		ТоварОбъект = Неопределено;
		ТоварЦена = 0;
	КонецЕсли;
	
	СтруктураДанных.Вставить("Цена", ТоварЦена);
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуВСтроке(ТекущаяСтрока)
	
	ТекущаяСтрока.Сумма = ТекущаяСтрока.Количество * ТекущаяСтрока.Цена;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьЦенуВСтроке(ТекущаяСтрока)
	
	Если ТекущаяСтрока.Количество <> 0 Тогда
		ТекущаяСтрока.Цена = ТекущаяСтрока.Сумма / ТекущаяСтрока.Количество;
	Иначе
		ТекущаяСтрока.Цена = 0;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОткрытиеЭкранаВGA(ЭтаФорма.ИмяФормы);
	// Конец Сбор статистики
	
	#Если МобильноеПриложениеСервер Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.КассаККМ) Тогда
			
			Объект.КассаККМ = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("КассаККММобильногоПриложения");
			
		КонецЕсли;
		Если ЗначениеЗаполнено(Объект.КассаККМ)
			И НЕ ЗначениеЗаполнено(Объект.РозничнаяТочка) Тогда
			
			Объект.РозничнаяТочка = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("РозничнаяТочка");
			
		КонецЕсли;
		
	#КонецЕсли

	ЭтаФорма.ТолькоПросмотр = Истина;
	УстановитьВидимостьВРежимеСинхронизации();
	ОбщегоНазначенияМПСервер.УстановитьЗаголовокФормы(ЭтаФорма, НСтр("ru='Кассовая смена';en='Cashier shift'"));
	
	УстановитьОтображениеНомера();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОбщегоНазначенияМПСервер.УстановитьЗаголовокФормы(ЭтаФорма, НСтр("ru='Кассовая смена';en='Cashier shift'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзменилосьКоличествоТовара");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПроцентСкидки();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	#Если НЕ МобильноеПриложениеСервер Тогда
		Если ВРег(Метаданные.Имя) = ВРег("УправлениеНебольшойФирмойНаМобильном") Тогда
			Возврат;
		КонецЕсли;
		// АПК:488-выкл методы безопасного запуска обеспечиваются этой функцией
		МодульСинхронизацияПушУведомленияМПУНФ = Вычислить("СинхронизацияПушУведомленияМПУНФ");
		// АПК:488-вкл
		Если ТипЗнч(МодульСинхронизацияПушУведомленияМПУНФ) = Тип("ОбщийМодуль") Тогда
			МодульСинхронизацияПушУведомленияМПУНФ.ОтправитьПушУведомление("001");
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	СкорректироватьСуммуСкидкиЕслиНужно();
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаСкидкиПриИзменении(Элемент)
	
	СкорректироватьСуммуСкидкиЕслиНужно(Истина);
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	РассчитатьСуммуВСтроке(ТекущаяСтрока);
	СкорректироватьСуммуСкидкиЕслиНужно();
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	РассчитатьСуммуВСтроке(ТекущаяСтрока);
	СкорректироватьСуммуСкидкиЕслиНужно();
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	РассчитатьЦенуВСтроке(ТекущаяСтрока);
	СкорректироватьСуммуСкидкиЕслиНужно();
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыТоварПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	СтруктураДанных = Новый Структура("Товар, ПриходТовара", ТекущаяСтрока.Товар, Ложь);
	ПолучитьДанныеТоварПриИзменении(СтруктураДанных);
	
	Если СтруктураДанных.Цена <> 0 Тогда
		ТекущаяСтрока.Цена = СтруктураДанных.Цена;
	КонецЕсли;
	Если ТекущаяСтрока.Количество = 0 Тогда
		ТекущаяСтрока.Количество = 1;
	КонецЕсли;
	
	РассчитатьСуммуВСтроке(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцентСкидкиПриИзменении(Элемент)
	
	Скидка = Число(СокрЛП(СтрЗаменить(ПроцентСкидки, "%", "")));
	Если Скидка > 100 Тогда
		Скидка = 100;
		ПроцентСкидки = "100%";
	КонецЕсли;
	
	Объект.СуммаСкидки = Объект.Товары.Итог("Сумма") * Скидка / 100;
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура Справка(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	ПерейтиПоНавигационнойСсылке("https://sbm.1c.ru/about/tovarnye-dokumenty/kartochka-dokumenta-prodazha/");
	// АПК:534-вкл
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Закрытие",,,ЗавершениеРаботы);
	// Конец Сбор статистики
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеНомера()
	
	Если Константы.СинхронизацияВключенаМП.Получить() И Объект.НомерПодтвержден = Ложь Тогда
		ЭтаФорма.Элементы.НомерНеПодтвержденЦБ.Видимость = Истина;
		ЭтаФорма.Элементы.Номер.Видимость = Ложь;
	Иначе
		ЭтаФорма.Элементы.НомерНеПодтвержденЦБ.Видимость = Ложь;
		ЭтаФорма.Элементы.Номер.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти