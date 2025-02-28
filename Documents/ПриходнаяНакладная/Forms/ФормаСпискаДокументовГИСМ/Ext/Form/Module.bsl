﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();

	
	
	
	ЗаполнитьСписокХозяйственныхОпераций();
	
	Элементы.СоздатьВозвратОтРозничногоПокупателя.Видимость = ПравоДоступа("Добавление", Метаданные.Документы.ПриходнаяНакладная);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияГИСМ
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокВозвратыТоваровОтКлиентов, "СтатусГИСМ", СтатусГИСМ, СтруктураБыстрогоОтбора);
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокВозвратыТоваровОтКлиентов, "Менеджер", Менеджер, СтруктураБыстрогоОтбора);
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокВозвратыТоваровОтКлиентов, "Организация", Организация, СтруктураБыстрогоОтбора);
	
	Если ИнтеграцияГИСМКлиентСервер.НеобходимОтборПоДальнейшемуДействиюГИСМПриСозданииНаСервере(ДальнейшееДействиеГИСМ, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	ИнтеграцияГИСМ.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.ДальнейшееДействиеГИСМОтбор.СписокВыбора,
		ИнтеграцияГИСМ.ВсеТребующиеДействияСтатусыИнформирования(), 
		ИнтеграцияГИСМ.ВсеТребующиеОжиданияСтатусыИнформирования());
	// Конец ИнтеграцияГИСМ
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	Если ИспользоватьПодключаемоеОборудование Тогда
		ТипыОборудования = МенеджерОборудованияКлиентСервер.ПараметрыТипыОборудования();
		ТипыОборудования.СканерШтрихкода = Истина;
		МенеджерОборудования.ПриСозданииНаСервере(ЭтотОбъект, ТипыОборудования);
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбработкаОповещенияФрагмент(ИмяСобытия);
	
	// ИнтеграцияГИСМ
	Если ИмяСобытия = "ИзменениеСостоянияГИСМ"
		И ТипЗнч(Параметр.Ссылка) = Тип("ДокументСсылка.ПриходнаяНакладная") Тогда
		
		Элементы.СписокВозвратыТоваровОтКлиентов.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменГИСМ"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусГИСМФормахВДокументах)) Тогда
		
		Элементы.СписокВозвратыТоваровОтКлиентов.Обновить();
		
	КонецЕсли;
	// Конец ИнтеграцияГИСМ
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ИмяСобытия = ДополнительныеПараметры.ИмяСобытия;
    
    
    ОбработкаОповещенияФрагмент(ИмяСобытия);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияФрагмент(Знач ИмяСобытия)
    
    Если ИмяСобытия = "Запись_ВозвратТоваровОтКлиента" Тогда
        
        Элементы.СписокРаспоряженияНаОформление.Обновить();
        
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Склад    = Настройки.Получить("Склад");
		
	// ИнтеграцияГИСМ
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокВозвратыТоваровОтКлиентов,
	                                                                     "СтатусГИСМ",
	                                                                     СтатусГИСМ,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	Если ИнтеграцияГИСМКлиентСервер.НеобходимОтборПоДальнейшемуДействиюГИСМПередЗагрузкойИзНастроек(ДальнейшееДействиеГИСМ, СтруктураБыстрогоОтбора, Настройки) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокВозвратыТоваровОтКлиентов,
	                                                                     "Менеджер",
	                                                                     Менеджер,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокВозвратыТоваровОтКлиентов,
	                                                                     "Организация",
	                                                                     Организация,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	// Конец ИнтеграцияГИСМ
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокВозвратыТоваровОтКлиентов,
	                                                                        "Организация",
	                                                                        Организация,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

// ИнтеграцияГИСМ
&НаКлиенте
Процедура СтатусГИСМОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокВозвратыТоваровОтКлиентов,
		"СтатусГИСМ",
		СтатусГИСМ,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(СтатусГИСМ));
		
КонецПроцедуры

&НаКлиенте
Процедура ДальнейшееДействиеГИСМОтборПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры
// Конец ИнтеграцияГИСМ

&НаКлиенте
Процедура СписокВозвратыТоваровОтКлиентовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.СписокДальнейшееДействиеГИСМ Тогда
		
		СтандартнаяОбработка = Ложь;
		ТекущиеДанные = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
		
		ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
			Элементы.СписокВозвратыТоваровОтКлиентов,
			Элемент.ДанныеСтроки(ВыбраннаяСтрока).ДальнейшееДействиеГИСМ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокВозвратыТоваровОтКлиентов

&НаКлиенте
Процедура СписокВозвратыТоваровОтКлиентовПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПередатьДанные(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
		Элементы.СписокВозвратыТоваровОтКлиентов,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратОтРозничногоПокупателя(Команда)
	
	СоздатьВозвратТоваровОтКлиента(0);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокВозвратыТоваровОтКлиентов);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокВозвратыТоваровОтКлиентов, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокВозвратыТоваровОтКлиентов);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Условное оформление динамического списка "СписокРаспоряженияНаОформление"
	СписокУсловноеОформление = СписокВозвратыТоваровОтКлиентов.КомпоновщикНастроек.Настройки.УсловноеОформление;
	СписокУсловноеОформление.Элементы.Очистить();
	
	// ИнтеграцияГИСМ
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокВозвратыТоваровОтКлиентов, "ЕстьМаркируемаяПродукцияГИСМ", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокВозвратыТоваровОтКлиентов, "ВидОперации", Перечисления.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя, ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеСтатусДальнейшееДействиеГИСМ(
		СписокУсловноеОформление,
		Элементы,
		Элементы.СтатусГИСМ.Имя,
		Элементы.СписокДальнейшееДействиеГИСМ.Имя,
		"СтатусГИСМ",
		"ДальнейшееДействиеГИСМ");
		
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеСтатусИнформированияГИСМ(
		СписокУсловноеОформление,
		Элементы,
		Элементы.СтатусГИСМ.Имя,
		"СтатусГИСМ");
	// Конец ИнтеграцияГИСМ

КонецПроцедуры

#Область Прочее



&НаСервере
Процедура ЗаполнитьСписокХозяйственныхОпераций()
	
	СписокХозяйственныхОпераций.Очистить();
	СписокХозяйственныхОпераций.Добавить(Перечисления.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратТоваровОтКлиента(ХозяйственнаяОперацияИндекс)

	ВидОперации = СписокХозяйственныхОпераций[ХозяйственнаяОперацияИндекс].Значение;

	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура("ВидОперации", ВидОперации));
	ОткрытьФорму("Документ.ПриходнаяНакладная.ФормаОбъекта", СтруктураПараметры, Элементы.СписокВозвратыТоваровОтКлиентов);

КонецПроцедуры

// ИнтеграцияГИСМ
#Область ОтборДальнейшиеДействия

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияГИСМ.УстановитьОтборПоДальнейшемуДействию(СписокВозвратыТоваровОтКлиентов,
	                                                    ДальнейшееДействиеГИСМ,
	                                                    ИнтеграцияГИСМ.ВсеТребующиеДействияСтатусыИнформирования(), 
	                                                    ИнтеграцияГИСМ.ВсеТребующиеОжиданияСтатусыИнформирования());
	
КонецПроцедуры

#КонецОбласти
// Конец ИнтеграцияГИСМ

#КонецОбласти

#КонецОбласти
