﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаДокумента = Объект.Дата;
	Если Не ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	// Документ основание.
	Элементы.ДокументОснованиеНадпись.Заголовок
		= РаботаСФормойДокументаКлиентСервер.СформироватьНадписьДокументОснование(Объект.ДокументОснование);
	
	НовыйМассив = Новый Массив();
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	ПараметрыВыбораДокументаОснования = НовыеПараметры;
	// Конец Документ основание.
	
	АвтоподборКонтактов.ПодключитьОбработчикиСобытияАвтоподбор(ЭтотОбъект);
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	Если Параметры.ЗаполнитьПриСоздании Тогда
		ЗаполнитьНаСервере();
	КонецЕсли;	
	
	ЗаполнитьТипыДокументов();
	
	УстановитьУсловноеОформлениеФормы();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = УправлениеСвойствамиУНФ.ЗаполнитьДополнительныеПараметры(Объект,
		"ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	НаборСвойств_Документ_ЗакрытиеПланируемыхОплат =
		УправлениеСвойствами.НаборСвойствПоИмени("Документ_ЗакрытиеПланируемыхОплат");
	// Конец СтандартныеПодсистемы.Свойства
	
	// МобильныйКлиент
	МобильныйКлиентУНФ.НастроитьФормуОбъектаМобильныйКлиент(Элементы);
	// Конец МобильныйКлиент
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// Обсуждения
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Модифицированность",Модифицированность);
	// Конец Обсуждения
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обсуждения
	ОбсужденияУНФ.ПослеЗаписиНаСервере(ТекущийОбъект);
	// Конец Обсуждения
	
	ЗаполнитьТипыДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Дата", Объект.Дата);
	Оповестить("ИзменениеДанныхПлатежногоКалендаря", ПараметрыОповещения,Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// Обсуждения
	ОбсужденияУНФКлиент.ОбработкаОповещения(ИмяСобытия, Параметр, Источник, ЭтотОбъект, Объект.Ссылка);
	// Конец Обсуждения
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДанныеДляИзмененияДаты = ДокументыУНФКлиент.ДанныеДляИзмененияДаты(ЭтотОбъект, Объект);
	Если ДанныеДляИзмененияДаты.ДатаНеМенялась Тогда
		Возврат;
	КонецЕсли;
	
	ДатаПриИзмененииНаСервере(ДанныеДляИзмененияДаты);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура вызывает обработку заполнения документа по основанию.
//
Процедура ЗаполнитьПоДокументу(ДокОснование)
	
	Документ 			= РеквизитФормыВЗначение("Объект");
	Документ.Заполнить(ДокОснование);
	ЗначениеВРеквизитФормы(Документ, "Объект");
	Модифицированность 	= Истина;
	
КонецПроцедуры // ЗаполнитьПоДокументу()

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ДокументыУНФ.ОрганизацияПриИзменении(ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере(ДанныеДляИзмененияДаты)
	
	ДокументыУНФ.ДатаПриИзменении(ДанныеДляИзмененияДаты, ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
// Процедура вызывается при нажатии кнопки "ЗаполнитьПоОснованию" командной панели
//
Процедура ЗаполнитьПоОснованию(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		
		ТекстСообщения = НСтр("ru = 'Требуется заполнить документ-основание.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.ДокументОснование");
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Документ будет полностью перезаполнен по ""Основанию"". Продолжить выполнение операции?'");
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоОснованиюЗавершение", ЭтотОбъект),
		ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОснованиюЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ЗаполнитьПоДокументу(Объект.ДокументОснование);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипыДокументов()
	
	МассивДокументов = Объект.ЗакрываемыеДокументы.Выгрузить().ВыгрузитьКолонку("ДокументПлатежногоКалендаря");
	
	Для ОбратныйИндекс = 1 - МассивДокументов.Количество() По 0 Цикл
		Если ТипЗнч(МассивДокументов[-ОбратныйИндекс]) = Тип("ДокументСсылка.ПеремещениеДСПлан") Тогда
			МассивДокументов.Удалить(-ОбратныйИндекс);
		КонецЕсли;	
	КонецЦикла;
	
	КонтрагентыСоответствие = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивДокументов, "Контрагент", Истина);
	
	Для Каждого СтрокаТЧ Из Объект.ЗакрываемыеДокументы Цикл
		СтрокаТЧ.Контрагент = КонтрагентыСоответствие[СтрокаТЧ.ДокументПлатежногоКалендаря];
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	УсловноеОформление.Элементы.Очистить();
		
	НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьОформляемоеПоле(НовоеУсловноеОформление,
		Элементы.ЗакрываемыеДокументыКонтрагент.Имя);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветТекста",
		ЦветаСтиля.ВычисленноеПравоДоступаЦвет);
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеОбъектов

// АПК:78-выкл Проектное решение.
&НаКлиенте
Процедура СохранитьДокументКакШаблон(Параметр) Экспорт
	
	ЗаполнениеОбъектовУНФКлиент.СохранитьДокументКакШаблон(Объект, ОтображаемыеРеквизиты(), Параметр);
	
КонецПроцедуры
// АПК:78-вкл

&НаСервере
Функция ОтображаемыеРеквизиты()
	
	Возврат ЗаполнениеОбъектовУНФ.ОтображаемыеРеквизиты(ЭтотОбъект);
	
КонецФункции

#КонецОбласти

#Область АвтоподборКонтактов

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	АвтоподборКонтактовКлиент.Подключаемый_ОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_АвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	АвтоподборКонтактовКлиент.Подключаемый_АвтоПодбор(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, Параметры, Ожидание,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область Основание

&НаСервереБезКонтекста
Функция СписокДляВыбораДокументаОснования()
	
	СписокОснований = Новый СписокЗначений;
	
	СписокОснований.Добавить("Документ.ПоступлениеДСПлан.ФормаВыбора", НСтр("ru = 'Поступление денег (план)'"));
	СписокОснований.Добавить("Документ.ЗаказПокупателя.ФормаВыбора", НСтр("ru = 'Заказ покупателя'"));
	СписокОснований.Добавить("Документ.СчетНаОплату.ФормаВыбора", НСтр("ru = 'Счет на оплату'"));
	СписокОснований.Добавить("Документ.РасходДСПлан.ФормаВыбора", НСтр("ru = 'Заявка на расход денег'"));
	СписокОснований.Добавить("Документ.ПеремещениеДСПлан.ФормаВыбора", НСтр("ru = 'Перемещение денег (план)'"));
	СписокОснований.Добавить("Документ.ЗаказПоставщику.ФормаВыбора", НСтр("ru = 'Заказ поставщику'"));
	СписокОснований.Добавить("Документ.СчетНаОплатуПоставщика.ФормаВыбора", НСтр("ru = 'Счет на оплату (полученный)'"));
	
	СписокОснований.СортироватьПоПредставлению(НаправлениеСортировки.Возр);
	
	Возврат СписокОснований;
	
КонецФункции

&НаКлиенте
Процедура ДокументОснованиеНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НЕ ТолькоПросмотр И НавигационнаяСсылкаФорматированнойСтроки = "удалить" Тогда
		
		Объект.ДокументОснование = Неопределено;
		Элементы.ДокументОснованиеНадпись.Заголовок = РаботаСФормойДокументаКлиентСервер.СформироватьНадписьДокументОснование(Неопределено);
		Модифицированность = Истина;
		
	ИначеЕсли НЕ ТолькоПросмотр И НавигационнаяСсылкаФорматированнойСтроки = "заполнить" Тогда
		
		ЗаполнитьПоОснованиюНачало();
		
	ИначеЕсли НЕ ТолькоПросмотр И НавигационнаяСсылкаФорматированнойСтроки = "выбрать" Тогда
		
		// Выбрать основание
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыборТипаОснованияЗавершение", ЭтотОбъект);
		ПоказатьВыборИзМеню(ОписаниеОповещения, СписокДляВыбораДокументаОснования(), Элемент);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "открыть" Тогда
		
		РаботаСФормойДокументаКлиент.ОткрытьФормуДокументаПоСсылке(Объект.ДокументОснование);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборТипаОснованияЗавершение(ВыбранныйЭлемент, Параметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметровОтбора = Новый Структура();
	Для каждого элОтбора Из ПараметрыВыбораДокументаОснования Цикл
		ИмяПоляОтбора = СтрЗаменить(элОтбора.Имя,"Отбор.","");
		СтруктураПараметровОтбора.Вставить(ИмяПоляОтбора, элОтбора.Значение);
	КонецЦикла;
	СтруктураПараметровОтбора.Вставить("РежимВыбора", Истина);
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыбратьОснованиеЗавершение", ЭтотОбъект);
	ОткрытьФорму(ВыбранныйЭлемент.Значение, СтруктураПараметровОтбора, ЭтотОбъект,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОснованиеЗавершение(ВыбранноеЗначение, Параметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ДокументОснование = ВыбранноеЗначение;
	Элементы.ДокументОснованиеНадпись.Заголовок = РаботаСФормойДокументаКлиентСервер.СформироватьНадписьДокументОснование(ВыбранноеЗначение);
	Модифицированность = Истина;
	
	ЗаполнитьПоОснованиюНачало();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОснованиюНачало()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоОснованиюЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Заполнить документ по выбранному основанию?'"),
		РежимДиалогаВопрос.ДаНет, 0);
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура ДобавитьДополнительныйРеквизит(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущийНаборСвойств", НаборСвойств_Документ_ЗакрытиеПланируемыхОплат);
	ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", Ложь);
	
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ФормаОбъекта", ПараметрыФормы, , , , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ТаблицаДокументов = Документы.ЗакрытиеПланируемыхОплат.ДокументыДляЗакрытияПланируемыхОплат(Объект.Организация,
		Объект.Контрагент, Объект.Ссылка);
	
	Объект.ЗакрываемыеДокументы.Загрузить(ТаблицаДокументов);
	
	ЗаполнитьТипыДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗакрываемыеДокументыДокументПриИзменении(Элемент)
	ЗакрываемыеДокументыДокументПриИзмененииНаСервере(Элементы.ЗакрываемыеДокументы.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ЗакрываемыеДокументыДокументПриИзмененииНаСервере(ИдентификаторСтроки)
	ТекущиеДанные = Объект.ЗакрываемыеДокументы.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если ТипЗнч(ТекущиеДанные.ДокументПлатежногоКалендаря) = Тип("ДокументСсылка.ПеремещениеДСПлан") Тогда
		Возврат;
	КонецЕсли;	
	ТекущиеДанные.Контрагент =
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ДокументПлатежногоКалендаря, "Контрагент");
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
