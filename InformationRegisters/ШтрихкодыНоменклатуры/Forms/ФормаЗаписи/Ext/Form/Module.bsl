﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	Если ИспользоватьПодключаемоеОборудование Тогда
		ТипыОборудования = МенеджерОборудованияКлиентСервер.ПараметрыТипыОборудования();
		ТипыОборудования.СканерШтрихкода = Истина;
		МенеджерОборудования.ПриСозданииНаСервере(ЭтотОбъект, ТипыОборудования);
	КонецЕсли;
	ИспользоватьОбменСПодключаемымОборудованиемOffline = ПолучитьФункциональнуюОпцию("ИспользоватьОбменСПодключаемымОборудованиемOffline");
	// Конец ПодключаемоеОборудование
	
	Элементы.ФормаУдалитьЗапись.Доступность = Не Параметры.Ключ.Пустой();
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик события ПриЗакрытии.
//
&НаКлиенте
Процедура ПриЗакрытии()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры // ПриЗакрытии()

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			Данные = МенеджерОборудованияУНФКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр);
			ПолученыШтрихкоды(Данные);
		ИначеЕсли ИмяСобытия = "DataCollectionTerminal" Тогда
			ПолученыШтрихкоды(Параметр);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры // ОбработкаОповещения()

// Процедура - обработчик события ОбработкаПроверкиЗаполненияНаСервере.
//
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	Запрос = РегистрыСведений.ШтрихкодыНоменклатуры.НовыйЗапросШтрихкоды(Запись);

	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() // Штрихкод уже записан в БД

		И Запись.ИсходныйКлючЗаписи.Штрихкод <> Запись.Штрихкод Тогда

		ОписаниеОшибки = НСтр("ru='Такой штрихкод уже назначен для номенклатуры %Номенклатура%'");
		ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Номенклатура%", """" + Выборка.НоменклатураПредставление + """"
			+ ?(ЗначениеЗаполнено(Выборка.Характеристика), " " + НСтр("ru='с характеристикой'") + " """
			+ Выборка.ХарактеристикаПредставление + """", "") + ?(ЗначениеЗаполнено(Выборка.Партия), " """ + НСтр(
			"ru='с партией'") + " " + Выборка.ПартияПредставление + """", ""));

		ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки,, "Запись.Штрихкод",, Отказ);

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ПерезаписатьЗначениеШтрихКодаВНоменклатуре = Запись.ИсходныйКлючЗаписи.Штрихкод = Запись.Номенклатура.ШтрихКод;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Номенклатура", Запись.Номенклатура);
	ПараметрыОповещения.Вставить("ШтрихКод", Запись.ШтрихКод);
	ПараметрыОповещения.Вставить("ПерезаписатьЗначениеШтрихКодаВНоменклатуре", ПерезаписатьЗначениеШтрихКодаВНоменклатуре);
	ПараметрыОповещения.Вставить("ШтрихКодУдален", Ложь);
	
	Оповестить("ЗаписьШтрихКода", ПараметрыОповещения);
	
	Элементы.ФормаУдалитьЗапись.Доступность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура обработчик команды НовыйШтрихкод.
//
&НаКлиенте
Процедура НовыйШтрихкод(Команда)
	
	Если Не ЗначениеЗаполнено(Запись.Номенклатура) Тогда
		СтрокаСообщения = НСтр("ru = 'Штрихкод не сгенерирован. Предварительно выберите номенклатуру.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаСообщения);
		Возврат
	КонецЕсли;
	
	Если ИспользоватьОбменСПодключаемымОборудованиемOffline И ВесоваяНоменклатура() Тогда
		СформироватьШтрихкодВесовогоТовара();
	Иначе
		Запись.Штрихкод = СформироватьШтрихкодEAN13();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗапись(Команда)
	
		ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьЗаписьНаКлиенте", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Удалить ""Штрихкоды номенклатуры"" ?'"), РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УдалитьЗаписьНаКлиенте(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьЗаписьНаСервере();
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Номенклатура", Запись.Номенклатура);
	ПараметрыОповещения.Вставить("ШтрихКод", Запись.ШтрихКод);
	ПараметрыОповещения.Вставить("ПерезаписатьЗначениеШтрихКодаВНоменклатуре", Ложь);
	ПараметрыОповещения.Вставить("ШтрихКодУдален", Истина);
	
	Оповестить("ЗаписьШтрихКода", ПараметрыОповещения);

	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЗаписьНаСервере()

	НаборЗаписей = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Номенклатура.Установить(Запись.Номенклатура);
	НаборЗаписей.Отбор.Штрихкод.Установить(Запись.Штрихкод);
	НаборЗаписей.Отбор.Партия.Установить(Запись.Партия);
	НаборЗаписей.Отбор.ЕдиницаИзмерения.Установить(Запись.ЕдиницаИзмерения);
	НаборЗаписей.Отбор.Характеристика.Установить(Запись.Характеристика);
	НаборЗаписей.Записать();
	
КонецПроцедуры

// ПодключаемоеОборудование
&НаКлиенте
Функция ПолученыШтрихкоды(ДанныеШтрихкодов)
	
	Модифицированность = Истина;
	
	Если ДанныеШтрихкодов.Количество() > 0 Тогда
		Штрихкод = ДанныеШтрихкодов[ДанныеШтрихкодов.Количество() - 1].Штрихкод;
		
		ДополнительныеДанныеПоШтрихкоду = ШтрихкодированиеУНФКлиент.ДополнительныеДанныеПоШтрихкоду(Штрихкод, "");
		Если ДополнительныеДанныеПоШтрихкоду.ЭтоКодМаркировки Тогда 
			ОбщегоНазначенияКлиент.СообщитьПользователю(ДополнительныеДанныеПоШтрихкоду.ТекстСообщения);
			Возврат Ложь;
		КонецЕсли;
		Если ДополнительныеДанныеПоШтрихкоду.ЕстьРазделительGS1 Тогда 
			Штрихкод = ДополнительныеДанныеПоШтрихкоду.ПредставлениеШтрихкода;
		КонецЕсли;
		
		Запись.Штрихкод = Штрихкод;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // ПолученыШтрихкоды()
// Конец ПодключаемоеОборудование

&НаСервере
Функция ВесоваяНоменклатура()
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.Номенклатура, "Весовой");
КонецФункции

&НаКлиенте
Процедура СформироватьШтрихкодВесовогоТовара()
	
	ПрефиксВесовогоТовара = 1;
	
	ОбработчикОповещения = Новый ОписаниеОповещения(
	"ПродолжитьФормированиеШтрихкодаВесовогоТовара",
	ЭтотОбъект);
	
	ПоказатьВводЧисла(
	ОбработчикОповещения,
	ПрефиксВесовогоТовара, 
	НСтр("ru = 'Введите префикс весового товара или нажмите кнопку Отмена'"), 1, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьФормированиеШтрихкодаВесовогоТовара(ПрефиксВесовогоТовара, Параметры) Экспорт
	
	Если ПрефиксВесовогоТовара <> Неопределено Тогда
		Запись.Штрихкод = СформироватьШтрихкодEAN13ВесовогоТовара(Формат(ПрефиксВесовогоТовара, "ЧЦ=1; ЧН=0"));
	КонецЕсли;
	
КонецПроцедуры // НовыйШтрихкод()

&НаСервереБезКонтекста
Функция СформироватьШтрихкодEAN13ВесовогоТовара(Знач ПрефиксВесовогоТовара)
	
	Возврат РегистрыСведений.ШтрихкодыНоменклатуры.СформироватьШтрихкодВесовогоТовараEAN13(ПрефиксВесовогоТовара);
	
КонецФункции

// Формирует штрихкод EAN13.
//
&НаСервереБезКонтекста
Функция СформироватьШтрихкодEAN13()
	
	Возврат РегистрыСведений.ШтрихкодыНоменклатуры.СформироватьШтрихкодEAN13();
	
КонецФункции // СформироватьШтрихкодEAN13()

#КонецОбласти
