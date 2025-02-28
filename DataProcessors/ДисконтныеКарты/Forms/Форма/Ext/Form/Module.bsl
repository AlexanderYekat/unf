﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ДанныеСчитывателя; // Кэш данных считывателя магнитной карты

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Обрабатывает событие активизации строки списка элементов справочника.
//
&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()
	
	ПараметрыИнфоПанели = Новый Структура;
	ПараметрыИнфоПанели.Вставить("РеквизитКИ", "ВладелецКарты");
	ПараметрыИнфоПанели.Вставить("ДисконтнаяКарта", Элементы.Список.ТекущаяСтрока);
	ПараметрыИнфоПанели.Вставить("ПроцентСкидкиПоДисконтнойКарте");
	ПараметрыИнфоПанели.Вставить("Контрагент");
	ПараметрыИнфоПанели.Вставить("КонтактноеЛицо");
	ДисконтныеКартыУНФКлиент.ДисконтныеКартыИнформационнаяПанельОбработатьАктивизациюСтрокиСписка(ЭтотОбъект,
		ПараметрыИнфоПанели);
	ОбновитьПанельКонтактнойИнформацииСервер();
	
КонецПроцедуры // ОбработатьАктивизациюСтрокиСписка()

// Процедура - обработчик события ПриСозданииНаСервере формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнформацияУпрВалюта = Константы.ВалютаУчета.Получить();
	
	// Установка доступности цен для редактирования.
	РазрешеноРедактированиеЦенДокументов = УправлениеДоступомУНФ.РазрешеноРедактированиеЦенДокументов();
	
	Элементы.ВидыДисконтныхКарт.ТолькоПросмотр = НЕ РазрешеноРедактированиеЦенДокументов;
	
	// УНФ.ПанельКонтактнойИнформации
	КонтактнаяИнформацияПанельУНФ.ПриСозданииНаСервере(ЭтотОбъект, "КонтактнаяИнформация", "СписокКонтекстноеМеню");
	// Конец УНФ.ПанельКонтактнойИнформации
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	Если ИспользоватьПодключаемоеОборудование Тогда
		ТипыОборудования = МенеджерОборудованияКлиентСервер.ПараметрыТипыОборудования();
		ТипыОборудования.СканерШтрихкода = Истина;
		ТипыОборудования.СчитывательМагнитныхКарт = Истина;
		МенеджерОборудования.ПриСозданииНаСервере(ЭтотОбъект, ТипыОборудования);
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// МобильныйКлиент
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокКомментарий", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ДеталиСпискаПроцентСкидкиИВладелец", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДеталиСпискаКонтрагент",
			"Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РасшифровкаДокументы", "Видимость",
			Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СвернутьОтборы", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияРазвернутьОтборы",
			"Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"СписокКонтекстноеМенюПоказатьДополнительнуюИнформацию", "Видимость", Истина);
		
		РаботаСОтборами.НастроитьПанельОтборовМобильныйКлиент(ЭтотОбъект, , , , , Истина);
		
	КонецЕсли;
	// Конец МобильныйКлиент
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование

КонецПроцедуры

// Процедура - обработчик события ПриЗакрытии формы.
//
&НаКлиенте
Процедура ПриЗакрытии()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование

КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения формы.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// УНФ.ПанельКонтактнойИнформации
	Если КонтактнаяИнформацияПанельУНФКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьПанельКонтактнойИнформацииСервер();
	КонецЕсли;
	// Конец УНФ.ПанельКонтактнойИнформации
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			ОбработатьШтрихкоды(ДисконтныеКартыУНФКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
			ТекущийЭлемент = Элементы.ОтборШтрихКод;
		ИначеЕсли ИмяСобытия ="TracksData" Тогда
			// Обработка ситуации, когда считыватель магнитных карт имитирует нажатие клавиши "Enter" после считывания магнитной карты.
			ТекДата = ТекущаяДата();
			
			ОбработатьДанныеСчитывателяМагнитныхКарт(Параметр);
			ТекущийЭлемент = Элементы.ОтборМагнитныйКод;
			
			// Обработка ситуации, когда считыватель магнитных карт имитирует нажатие клавиши "Enter" после считывания магнитной карты.
			// Символ перевода строки можно обрезать с помощью настроек подключаемого оборудования для считывателя магнитных карт.
			Пока (ТекущаяДата() - ТекДата) < 1 Цикл КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "ПослеЗаписи_ДисконтнаяКарта" Тогда
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено И ТекущиеДанные.Ссылка = Источник Тогда
			Комментарий = СтрЗаменить(Параметр, Символы.ПС, " ");
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ПослеЗаписи_ВидыДисконтныхКарт" Тогда
		ТекущиеДанные = Элементы.ВидыДисконтныхКарт.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено И ТекущиеДанные.Ссылка = Источник Тогда
			КомментарийВидыДисконтныхКарт = СтрЗаменить(Параметр, Символы.ПС, " ");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриЗагрузкеДанныхИзНастроекНаСервере формы.
//
&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборВидКарты = Настройки.Получить("ОтборВидКарты");
	ОтборВладелецКарты = Настройки.Получить("ОтборВладелецКарты");
	ОтборШтрихКод = Настройки.Получить("ОтборШтрихКод");
	ОтборМагнитныйКод = Настройки.Получить("ОтборМагнитныйКод");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДисконтныеКарты, "Владелец", ОтборВидКарты,
		, , ЗначениеЗаполнено(ОтборВидКарты));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДисконтныеКарты, "ВладелецКарты",
		ОтборВладелецКарты, , , ЗначениеЗаполнено(ОтборВладелецКарты));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДисконтныеКарты, "КодКартыШтрихкод",
		ОтборШтрихКод, ВидСравненияКомпоновкиДанных.Содержит, , ЗначениеЗаполнено(ОтборШтрихКод));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДисконтныеКарты, "КодКартыМагнитный", 
		ОтборМагнитныйКод, ВидСравненияКомпоновкиДанных.Содержит, , ЗначениеЗаполнено(ОтборМагнитныйКод),);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

// Процедура - обработчик события Нажатие элемента ГиперссылкаКакРаботатьСДисконтнымиКартамиВПрограмме формы.
//
&НаКлиенте
Процедура ГиперссылкаКакРаботатьСДисконтнымиКартамиВПрограммеНажатие(Элемент)
	
	ПараметрыОткрытия = Новый Структура("Заголовок, КлючПодсказки", 
		"Как работать с дисконтными картами",
		"ДисконтныеКарты_КакРаботатьСДисконтнымиКартами");
	
	ОткрытьФорму("Обработка.МенеджерПодсказок.Форма", ПараметрыОткрытия,, УникальныйИдентификатор);
	
КонецПроцедуры

// Процедура - обработчик события Нажатие элемента ГиперссылкаНаВидеоурокНажатие формы.
//
&НаКлиенте
Процедура ГиперссылкаНаВидеоурокНажатие(Элемент)
	
	АдресСтраницы = "http://youtu.be/HP1Xt5oW2xI";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);
	
КонецПроцедуры

// Процедура - обработчик нажатия на кнопку ОтправитьEmailКонтрагенту.
//
&НаКлиенте
Процедура ОтправитьEmailКонтрагенту(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если СписокТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Получатели = Новый Массив;
	Если ЗначениеЗаполнено(ИнформацияКонтрагентЭП) Тогда
		СтруктураПолучателя = Новый Структура;
		СтруктураПолучателя.Вставить("Представление", СписокТекущиеДанные.Ссылка);
		СтруктураПолучателя.Вставить("Адрес", ИнформацияКонтрагентЭП);
		Получатели.Добавить(СтруктураПолучателя);
	КонецЕсли;
	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("Получатель", Получатели);
	
	РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыОтправки);
	
КонецПроцедуры // ОтправитьEmailКонтрагенту()

&НаКлиенте
Процедура ОтборШтрихКодПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("СписокДисконтныхКартОтборШтрихКод");
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДисконтныеКарты, "КодКартыШтрихкод",
		ОтборШтрихКод, ВидСравненияКомпоновкиДанных.Содержит, , ЗначениеЗаполнено(ОтборШтрихКод));
	
	#Если МобильныйКлиент Тогда
		
		ОбновитьЗаголовокПанелиПослеУстановкиОтбора();
		
	#КонецЕсли
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении элемента ОтборМагнитныйКод.
//
&НаКлиенте
Процедура ОтборМагнитныйКодПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("СписокДисконтныхКартОтборМагнитныйКод");
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДисконтныеКарты, "КодКартыМагнитный",
		ОтборМагнитныйКод, ВидСравненияКомпоновкиДанных.Содержит, , ЗначениеЗаполнено(ОтборМагнитныйКод));
	
	#Если МобильныйКлиент Тогда
		
		ОбновитьЗаголовокПанелиПослеУстановкиОтбора();
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВладелецКартыКодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("СписокДисконтныхКартОтборВладелецКарты");
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	СтандартнаяОбработка = Ложь;
	УстановитьМеткуИОтборСписка("ВладелецКарты", Элемент.Родитель.Имя, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидКартыКодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("СписокДисконтныхКартОтборВидКарты");
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	СтандартнаяОбработка = Ложь;
	УстановитьМеткуИОтборСписка("Владелец", Элемент.Родитель.Имя, ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийДинамическихСписков

// Процедура - обработчик события ПриАктивизацииСтроки динамического списка Список.
//
&НаКлиенте
Процедура ДисконтныеКартыПриАктивизацииСтроки(Элемент)
	
	Если ТипЗнч(Элемент.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		
		Если Элемент.ТекущиеДанные = Неопределено Тогда
			Комментарий = "";
		Иначе
			Комментарий = СтрЗаменить(Элемент.ТекущиеДанные.Комментарий, Символы.ПС, " ");
		КонецЕсли;
		
		КонтрагентАктивнойСтроки = ?(Элемент.ТекущиеДанные = Неопределено, Неопределено, Элемент.ТекущиеДанные.ВладелецКарты);
		Если КонтрагентАктивнойСтроки <> ТекущийКонтрагент Тогда
		
			ТекущийКонтрагент = КонтрагентАктивнойСтроки;
		КонецЕсли;
		
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДисконтныхКартПриАктивизацииСтроки(Элемент)
	
	Если ТипЗнч(Элемент.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		
		Если Элемент.ТекущиеДанные = Неопределено Тогда
			КомментарийВидыДисконтныхКарт = "";
		Иначе
			КомментарийВидыДисконтныхКарт = СтрЗаменить(Элемент.ТекущиеДанные.Комментарий, Символы.ПС, " ");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродажиПоДисконтнойКарте(Команда)
	
	Если Не ЗначениеЗаполнено(Элементы.Список.ТекущаяСтрока) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючВарианта", "ПродажиПоДисконтнойКарте");
	ПараметрыФормы.Вставить("Отбор", Новый Структура("СтПериод,ДисконтнаяКарта", Новый СтандартныйПериод, Элементы.Список.ТекущаяСтрока));
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	
	ОткрытьФорму("Отчет.ПродажиПоДисконтнымКартам.Форма", ПараметрыФормы, ЭтотОбъект, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДополнительнуюИнформацию(Команда)
	
	Если Не ЗначениеЗаполнено(Элементы.Список.ТекущаяСтрока) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ДисконтнаяКарта", Элементы.Список.ТекущаяСтрока);
	ПараметрыОткрытия.Вставить("ИнформацияКонтрагентТелефон", ИнформацияКонтрагентТелефон);
	ПараметрыОткрытия.Вставить("ИнформацияКонтрагентЭП", ИнформацияКонтрагентЭП);
	ПараметрыОткрытия.Вставить("ИнформацияПроцентСкидкиПоДисконтнойКарте", ИнформацияПроцентСкидкиПоДисконтнойКарте);
	ПараметрыОткрытия.Вставить("ИнформацияСуммаПродажПоДисконтнойКарте", ИнформацияСуммаПродажПоДисконтнойКарте);
	ПараметрыОткрытия.Вставить("ИнформацияУпрВалюта", ИнформацияУпрВалюта);
	ПараметрыОткрытия.Вставить("ЭлементыСписокТекущиеДанныеВладелецКарты", Элементы.Список.ТекущиеДанные.ВладелецКарты);
	
	ОткрытьФорму("Обработка.ДисконтныеКарты.Форма.ДополнительнаяИнформация_МК", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область МеткиОтборов

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, ДисконтныеКарты, ИмяПоляОтбораСписка);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_") + 1);
	УдалитьМеткуОтбора(МеткаИД);

КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, ДисконтныеКарты, МеткаИД);

КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокПанелиПослеУстановкиОтбора()
	
	РеквизитыОтбора = "ОтборШтрихКод, ОтборМагнитныйКод";
	РаботаСОтборами.УстановитьЗаголовокПравойПанелиМобильныйКлиент(ЭтотОбъект, "ПраваяПанель", "ДанныеМеток", РеквизитыОтбора);
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

// Процедура обрабатывает данные штрихкода, которые передаются из обработки оповещения формы.
//
&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Если ТипЗнч(ДанныеШтрихкодов) = Тип("Массив") Тогда
		МассивШтрихкодов = ДанныеШтрихкодов;
	Иначе
		МассивШтрихкодов = Новый Массив;
		МассивШтрихкодов.Добавить(ДанныеШтрихкодов);
	КонецЕсли;
	
	ОбработатьПолученныйКодНаКлиенте(МассивШтрихкодов[0].Штрихкод, ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод"), Ложь);
	
КонецПроцедуры

// Процедура обрабатывает данные со считывателя магнитных карт, которые передаются из обработки оповещения формы.
//
&НаКлиенте
Процедура ОбработатьДанныеСчитывателяМагнитныхКарт(Данные)
	
	ДанныеСчитывателя = Данные;
	ОбработатьПолученныйКодНаКлиенте(ДанныеСчитывателя, ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод"), Истина);
	
КонецПроцедуры

// Функция проверяет магнитный код на соответствие шаблону и возвращает список ДК, магнитный код или штрихкод.
//
&НаСервере
Функция ОбработатьПолученныйКодНаСервере(Данные, ТипКодаКарты, Предобработка, ЕстьНайденныеКарты = Ложь, ЕстьШаблон = Ложь)
	
	ЕстьНайденныеКарты = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипКода = ТипКодаКарты;
	Если ТипКода = Перечисления.ТипыКодовКарт.МагнитныйКод Тогда
		// При вызове функции параметр "Предобработка" будем устанавливать в значение Ложь, чтобы не использовались шаблоны
		// магнитных карт. В качестве кода карты будет использоваться строка, полученная конкатенацией строк со всех магнитных дорожек.
		// В большинстве дисконтных карт используется только одна дорожка, на которой записан только номер карты в формате ";КодКарты?".
		Если Предобработка Тогда
			ТекКодКарты = Данные[0]; // Данные 3х дорожек магнитной карты. На данный момент не используется. Можно использовать если карта не найдена.
			                        // В случае, когда карта не соответствует ни одному шаблону, то будет выдано предупреждение,
			                        // но кнопка "Готова" в форме нажата не будет.
			ДисконтныеКартыСтруктура = ДисконтныеКартыУНФВызовСервера.НайтиВидыДисконтныхКартПоДаннымСоСчитывателяМагнитныхКарт(Данные, ТипКода, Справочники.ВидыДисконтныхКарт.ПустаяСсылка());
			
			Возврат ДисконтныеКартыСтруктура;
		Иначе
			Если ТипЗнч(Данные) = Тип("Массив") Тогда
				ТекКодКарты = Данные[0];
			Иначе
				ТекКодКарты = Данные;
			КонецЕсли;
			ДисконтныеКартыУНФВызовСервера.ПодготовитьКодКартыПоНастройкамПоУмолчанию(ТекКодКарты);
			
			Возврат ТекКодКарты;
		КонецЕсли;
	Иначе
		Возврат Данные;
	КонецЕсли;
	
КонецФункции

// Функция проверяет магнитный код на соответствие шаблону и устанавливает магнитный код или штрихкод элемента справочника.
// Если ДК несколько, то пользователь выбирает нужный код из списка.
//
&НаКлиенте
Процедура ОбработатьПолученныйКодНаКлиенте(Данные, ПолученныйТипКода, Предобработка)
	
	Перем ЕстьНайденныеКарты, ЕстьШаблон;
	
	Результат = ОбработатьПолученныйКодНаСервере(Данные, ПолученныйТипКода, Предобработка, ЕстьНайденныеКарты, ЕстьШаблон);
	Если ПолученныйТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод") Тогда
		Если ТипЗнч(Результат) = Тип("Строка") Тогда
			ОтборМагнитныйКод = Результат;
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДисконтныеКарты,
				"КодКартыМагнитный", ОтборМагнитныйКод, ВидСравненияКомпоновкиДанных.Содержит, ,
				ЗначениеЗаполнено(ОтборМагнитныйКод));
		Иначе
			Если Результат.Количество() = 1 Тогда
				ОтборМагнитныйКод = Результат.Получить(0).Значение;
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДисконтныеКарты,
					"КодКартыМагнитный", ОтборМагнитныйКод, ВидСравненияКомпоновкиДанных.Содержит, ,
					ЗначениеЗаполнено(ОтборМагнитныйКод));
			ИначеЕсли Результат.Количество() = 0 Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр(
					"ru = 'Код карты не соответствует ни одному из шаблонов магнитных карт.'"));
			Иначе
				Оповещение = Новый ОписаниеОповещения("ОбработатьПолученныйКодНаКлиентеЗавершение", ЭтаФорма);
				Результат.ПоказатьВыборЭлемента(Оповещение, НСтр("ru = 'Выбор кода магнитной карты'"));
			КонецЕсли;
		КонецЕсли;
	Иначе
		ОтборШтрихКод = Результат;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДисконтныеКарты, "КодКартыШтрихкод",
			ОтборШтрихКод, ВидСравненияКомпоновкиДанных.Содержит, , ЗначениеЗаполнено(ОтборШтрихКод));
	КонецЕсли;

КонецПроцедуры

// Обработка выбора кода магнитной карты из списка, если найдено несколько дисконтных карт.
//
&НаКлиенте
Процедура ОбработатьПолученныйКодНаКлиентеЗавершение(ВыбранныйЭлемент, Параметры) Экспорт
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ОтборМагнитныйКод = ВыбранныйЭлемент.Значение;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДисконтныеКарты, "КодКартыМагнитный",
			ОтборМагнитныйКод, ВидСравненияКомпоновкиДанных.Содержит, , ЗначениеЗаполнено(ОтборМагнитныйКод));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ПанельКонтактнойИнформации

// УНФ.ПанельКонтактнойИнформации
&НаСервере
Процедура ОбновитьПанельКонтактнойИнформацииСервер()
	
	КонтактнаяИнформацияПанельУНФ.ОбновитьДанныеПанели(ЭтотОбъект, ТекущийКонтрагент);
	
	Если ИнформацияПроцентСкидкиПоДисконтнойКарте = "<Автоскидки>" Тогда
		Элементы.РасшифровкаПроцентСкидкиПоДисконтнойКарте.ЦветТекста = ЦветаСтиля.ЦветНедоступногоТекстаТабличнойЧасти;
	Иначе
		Элементы.РасшифровкаПроцентСкидкиПоДисконтнойКарте.ЦветТекста = Новый Цвет;
	КонецЕсли;
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииВыбор(ЭтотОбъект, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(Элемент)
	
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(ЭтотОбъект, Элемент);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыполнитьКоманду(Команда)
	
	КонтактнаяИнформацияПанельУНФКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, ТекущийКонтрагент);
	
КонецПроцедуры
// Конец УНФ.ПанельКонтактнойИнформации

#КонецОбласти

#КонецОбласти
