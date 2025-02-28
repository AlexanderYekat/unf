﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(Список);
	
	//УНФ.ОтборыСписка
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект);
	ЗаполнитьВидыОпераций();
	Если Параметры.Свойство("ЭтоНачальнаяСтраница") Тогда
		РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
		ЭтоНачальнаяСтраница = Ложь;
	Иначе
		ЭтоНачальнаяСтраница = Истина;
		РаботаСОтборами.СвернутьРазвернутьОтборыНаСервере(ЭтотОбъект, Ложь);
		РаботаСОтборамиКлиентСервер.УстановитьОтображениеКомандыСброситьВсеОтборы(ЭтотОбъект);
		ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(Неопределено);
	КонецЕсли;
	//Конец УНФ.ОтборыСписка
	
	// УНФ.ПанельКонтактнойИнформации
	КонтактнаяИнформацияПанельУНФ.ПриСозданииНаСервере(ЭтотОбъект, "КонтактнаяИнформация", "СписокКонтекстноеМеню");
	// Конец УНФ.ПанельКонтактнойИнформации
	
	//МобильныйКлиент
	АдаптироватьИнтерфейсПодМобильныйКлиент();
	//Конец МобильныйКлиент
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// УНФ.ПанельКонтактнойИнформации
	Если КонтактнаяИнформацияПанельУНФКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьПанельКонтактнойИнформации();
	КонецЕсли;
	// Конец УНФ.ПанельКонтактнойИнформации
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборТипЗаказСчет = Настройки.Получить("ОтборТипЗаказСчет");
	ОтборТипНакладные = Настройки.Получить("ОтборТипНакладные");
	ОтборТипДопРасходы	 = Настройки.Получить("ОтборТипДопРасходы");
	ОтборТипСчетаФактуры = Настройки.Получить("ОтборТипСчетаФактуры");
	
	УстановитьОтборПоТипуДокумента();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	КонтактнаяИнформацияПанельУНФКлиент.ПриАктивизацииДинамическогоСписка(ЭтотОбъект, Элемент, ТекущийКонтрагент,
		"Контрагент");
	
КонецПроцедуры

&НаКлиенте
Процедура ТипДокументаПриИзменении(Элемент)
	
	УстановитьОтборПоТипуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Контрагент", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура ОтборОперацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ВидОперации", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Ответственный", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметр) Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	СтруктураПараметров = Новый Структура();
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "Контрагент");
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "ВидОперации");
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "Организация");
		
	ИмяФормыСтрока = РаботаСФормойДокументаКлиент.ИмяДокументаПоТипу(Параметр);
	ОткрытьФорму("Документ."+ИмяФормыСтрока+".ФормаОбъекта", Новый Структура("ЗначенияЗаполнения",СтруктураПараметров));

КонецПроцедуры

&НаКлиенте
Процедура ОтборОперацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыВыбора = Новый Структура("ДеревоВидовОпераций", ДеревоВидовОпераций);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбораВидаОперацииЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборВидаОперации", ПараметрыВыбора, ЭтотОбъект,,,,ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбораВидаОперацииЗавершение(Результат, ДополнительныеПараметры) Экспорт

	ОтборОперацияОбработкаВыбора(Элементы.ОтборОперация, Результат, Ложь);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	ИсключитьТипы = Новый Массив;
	ИсключитьТипы.Добавить(Тип("ДокументСсылка.СчетФактураПолученный"));
	ИсключитьТипы.Добавить(Тип("ДокументСсылка.КорректировкаПоступления"));
	
	ЗаполнениеОбъектовУНФКлиент.ПоказатьВыборШаблонаДляСозданияДокументаИзСписка(
	"ЖурналДокументов.ДокументыПоЗакупкам",
	Список.КомпоновщикНастроек.Настройки.Отбор.Элементы,
	Элементы.Список.ТекущаяСтрока,
	ИсключитьТипы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьВидыОпераций()
	
	СписокОпераций = ДеревоВидовОпераций.ПолучитьЭлементы().Добавить();
	СписокОпераций.ВидОперации = "Заказ поставщику";
	Для каждого ВидОперации Из Метаданные.Перечисления.ВидыОперацийЗаказПоставщику.ЗначенияПеречисления Цикл
		НоваяОперация = СписокОпераций.ПолучитьЭлементы().Добавить();
		НоваяОперация.ВидОперации = Перечисления.ВидыОперацийЗаказПоставщику[ВидОперации.Имя];
	КонецЦикла;
	
	СписокОпераций = ДеревоВидовОпераций.ПолучитьЭлементы().Добавить();
	СписокОпераций.ВидОперации = "Приходная накладная";
	Для каждого ВидОперации Из Метаданные.Перечисления.ВидыОперацийПриходнаяНакладная.ЗначенияПеречисления Цикл
		НоваяОперация = СписокОпераций.ПолучитьЭлементы().Добавить();
		НоваяОперация.ВидОперации = Перечисления.ВидыОперацийПриходнаяНакладная[ВидОперации.Имя];
	КонецЦикла;
	
	СписокОпераций = ДеревоВидовОпераций.ПолучитьЭлементы().Добавить();
	СписокОпераций.ВидОперации = "Счет-фактура (полученный)";
	Для каждого ВидОперации Из Метаданные.Перечисления.ВидыОперацийСчетФактураПолученный.ЗначенияПеречисления Цикл
		НоваяОперация = СписокОпераций.ПолучитьЭлементы().Добавить();
		НоваяОперация.ВидОперации = Перечисления.ВидыОперацийСчетФактураПолученный[ВидОперации.Имя];
	КонецЦикла;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКорректировкиПоступлений") Тогда
		СписокОпераций = ДеревоВидовОпераций.ПолучитьЭлементы().Добавить();
		СписокОпераций.ВидОперации = "Корректировка поступления / реализации";
		Для каждого ВидОперации Из Метаданные.Перечисления.ВидыОперацийИсправленияПоступленияРеализации.ЗначенияПеречисления Цикл
			НоваяОперация = СписокОпераций.ПолучитьЭлементы().Добавить();
			НоваяОперация.ВидОперации = Перечисления.ВидыОперацийИсправленияПоступленияРеализации[ВидОперации.Имя];
		КонецЦикла;
	КонецЕсли; 
	
	ДеревоОпераций = РеквизитФормыВЗначение("ДеревоВидовОпераций");
	РаботаСФормойДокумента.УдалитьНедоступныеВидыОперацийДокументов(ДеревоОпераций);
	ЗначениеВРеквизитФормы(ДеревоОпераций, "ДеревоВидовОпераций");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоТипуДокумента()
	
	МассивОтбора = Новый Массив;
	Если ОтборТипЗаказСчет Тогда
		МассивОтбора.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
		МассивОтбора.Добавить(Тип("ДокументСсылка.СчетНаОплатуПоставщика"));
	КонецЕсли;
	Если ОтборТипНакладные Тогда
		МассивОтбора.Добавить(Тип("ДокументСсылка.ПриходнаяНакладная"));
		МассивОтбора.Добавить(Тип("ДокументСсылка.КорректировкаПоступления"));
	КонецЕсли;
	Если ОтборТипДопРасходы Тогда
		МассивОтбора.Добавить(Тип("ДокументСсылка.ДополнительныеРасходы"));
	КонецЕсли;
	Если ОтборТипСчетаФактуры Тогда
		МассивОтбора.Добавить(Тип("ДокументСсылка.СчетФактураПолученный"));
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Тип", МассивОтбора, , ,
		ЗначениеЗаполнено(МассивОтбора));
	
КонецПроцедуры

&НаСервере
Процедура АдаптироватьИнтерфейсПодМобильныйКлиент()
	
	Если НЕ ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Отборы.ОтображатьЗаголовок = Истина;
	Элементы.Отборы.Поведение = ПоведениеОбычнойГруппы.Свертываемая;
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);
	
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
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	Если НЕ ЭтоНачальнаяСтраница Тогда
		РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтборы(Команда)
	
	ИмяРеквизитаСписка = "Список";
	ИмяТЧДанныеМеток = "ДанныеМеток";
	ИмяТЧДанныеОтборов = "ДанныеОтборов";
	ИмяГруппыОтборов = "ГруппаОтборы";
	ИмяПредопределенныеОтборыПоУмолчанию = "ПредопределенныеОтборыПоУмолчанию";
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяРеквизитаСписка", ИмяРеквизитаСписка);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеМеток", ИмяТЧДанныеМеток);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеОтборов", ИмяТЧДанныеОтборов);
	ДополнительныеПараметры.Вставить("ИмяГруппыОтборов", ИмяГруппыОтборов);
	ДополнительныеПараметры.Вставить("ИмяПредопределенныеОтборыПоУмолчанию", ИмяПредопределенныеОтборыПоУмолчанию);
	
	РаботаСОтборамиКлиент.НастроитьОтборыНажатие(ЭтотОбъект, ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры), ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры)
	
	Возврат РаботаСОтборами.ПараметрыДляОткрытияФормыСНастройкамиОтборов(ЭтотОбъект, ДополнительныеПараметры);
	
КонецФункции

&НаКлиенте
Процедура НастройкаОтборовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаОтборовЗавершениеНаСервере(Результат.АдресВыбранныеОтборы, Результат.АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура НастройкаОтборовЗавершениеНаСервере(АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры)
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ИмяРеквизитаСписка = "Список";
		ИмяТЧДанныеМеток = "ДанныеМеток";
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	Иначе
		ИмяРеквизитаСписка = ДополнительныеПараметры.ИмяРеквизитаСписка;
		ИмяТЧДанныеМеток = ДополнительныеПараметры.ИмяТЧДанныеМеток;
		ИмяТЧДанныеОтборов = ДополнительныеПараметры.ИмяТЧДанныеОтборов;
	КонецЕсли;
	
	РаботаСОтборами.НастройкаОтборовЗавершение(ЭтотОбъект, АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОтборПриИзменении(Элемент)
	
	Подключаемый_ОтборПриИзмененииНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборПриИзмененииНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборПриИзменении(ЭтотОбъект, ЭлементИмя, ЭлементРодительИмя);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОтборОчистка(Элемент)
	
	Подключаемый_ОтборОчисткаНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборОчисткаНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборОчистка(ЭтотОбъект, ЭлементИмя);

КонецПроцедуры

&НаКлиенте
Процедура СброситьВсеОтборы(Команда)
	РаботаСОтборамиКлиент.СброситьОтборПоПериоду(ЭтотОбъект, "Список", "Дата");
	СброситьВсеМеткиОтбораНаСервере();
КонецПроцедуры

&НаСервере
Процедура СброситьВсеМеткиОтбораНаСервере()
	РаботаСОтборами.УдалитьМеткиОтбораСервер(ЭтотОбъект, Список);
КонецПроцедуры

#КонецОбласти

#Область ПанельКонтактнойИнформации

// УНФ.ПанельКонтактнойИнформации
&НаКлиенте
Процедура Подключаемый_ОбработатьАктивизациюСтрокиСписка()
	
	ОбновитьПанельКонтактнойИнформации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПанельКонтактнойИнформации()
	
	ДанныеПанелиКИ = ДанныеПанелиКонтактнойИнформации(ТекущийКонтрагент);
	КонтактнаяИнформацияПанельУНФКлиент.ЗаполнитьДанныеПанелиКИ(ЭтотОбъект, ДанныеПанелиКИ);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеПанелиКонтактнойИнформации(Контрагент)
	
	Возврат КонтактнаяИнформацияПанельУНФ.ДанныеПанелиКонтактнойИнформации(Контрагент);
	
КонецФункции

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииВыбор(ЭтотОбъект, Элемент, ВыбраннаяСтрока,
		Поле, СтандартнаяОбработка);
	
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
