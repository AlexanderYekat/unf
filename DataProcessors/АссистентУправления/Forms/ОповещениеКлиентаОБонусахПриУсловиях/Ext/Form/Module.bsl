﻿
#Область ОписаниеПеременных

#Область ПеременныеФормы

&НаКлиенте
Перем ИзмененПризнакВРаботе;

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ТипПредмета = "БонусныеПрограммы";
	НастройкиSMSВыполнены = ОтправкаSMS.НастройкаОтправкиSMSВыполнена();
	ДоступноПравоНастройкиSMS = Пользователи.ЭтоПолноправныйПользователь();
	ИспользоватьБонусныеПрограммы = ПолучитьФункциональнуюОпцию("ИспользоватьБонусныеПрограммы");
	
	ПолучателиСообщений.Загрузить(АссистентУправления.ПолучателиПредметаСообщения(ТипПредмета));
	
	Для Каждого ПолучательСообщений Из ПолучателиСообщений Цикл
		ТаблицаВидыКИ = ПолучитьВидыКонтактнойИнформации(ПолучательСообщений.Путь);
		Для Каждого ВидКИ Из ТаблицаВидыКИ Цикл
			НовыйВид = ВидыКИ.Добавить();
			НовыйВид.Получатель = ПолучательСообщений.Путь;
			ЗаполнитьЗначенияСвойств(НовыйВид, ВидКИ,"Вид,Представление,ТипКИ");
		КонецЦикла;
	КонецЦикла;
	
	//ЗадачиАссистента
	ИдентификаторГруппы = "ОповещениеКлиентаОБонусахПриУсловиях";

	РазрешеноИзменятьЗадачи = Обработки.АссистентУправления.РазрешеноИзменятьЗадачи();
	
	Элементы.ДобавитьДействие.Видимость = РазрешеноИзменятьЗадачи;
	Элементы.ДействияАссистента.ТолькоПросмотр = НЕ РазрешеноИзменятьЗадачи;
	Элементы.ВРаботе.ТолькоПросмотр = НЕ РазрешеноИзменятьЗадачи;
	Элементы.ГруппаДопФункция_0.Видимость = РазрешеноИзменятьЗадачи;
	ЭтотОбъект.ТолькоПросмотр = НЕ РазрешеноИзменятьЗадачи;
	
	Если РазрешеноИзменятьЗадачи Тогда
		ВремяОтправкиПисьма = РаботаСБонусами.ПолучитьВремяОтправкиУведомлений();
	КонецЕсли;
	
	ОбновитьБлокиНастроекАссистента();
	ОбновитьЭлементыДействийАссистента();
	ЗаполнитьСписокВыбораЭлементовФормы();
	
	ИнформационнаяБазаЗарегистрирована = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	
	КлючСохраненияПоложенияОкна = Новый УникальныйИдентификатор();
	//Конец ЗадачиАссистента
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИзмененПризнакВРаботе = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ИзмененныеЗадачи = НастройкиЗадач.НайтиСтроки(Новый Структура("Модифицированность", Истина));
	ЗадачиИзменены = ИзмененныеЗадачи.Количество() <> 0;
	
	Если НЕ ЗадачиИзменены Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РазрешеноИзменятьЗадачи Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтотОбъект.ВРаботе Тогда
		
		СоздатьИзменитьЗадачиАссистента();
		ЗакрытьФормуЗадач();
		Возврат;
		
	КонецЕсли;
	
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ТипКИ", ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон"));
	Отбор.Вставить("Удалена", Ложь);
	
	ЗадачиОтправкиSMS = НастройкиЗадач.НайтиСтроки(Отбор);
	ЕстьЗадачиSMS = ЗадачиОтправкиSMS.Количество() <> 0;
		
	Если ВРаботе И НЕ НастройкиSMSВыполнены И ЕстьЗадачиSMS Тогда
		ВРаботе = Ложь;
		Элементы.ПанельОшибки.Видимость = Истина;
		Элементы.ОшибкаНеПодключенПровайдер.Видимость = Истина;
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СоздатьИзменитьЗадачиАссистента();
	ЗакрытьФормуЗадач();

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ЕстьОшибки = Ложь;
	Для каждого СтрокаНастроек Из НастройкиЗадач Цикл
		
		Если СтрокаНастроек.Удалена Тогда
			Продолжить;
		КонецЕсли;
				
		Если Не ЗначениеЗаполнено(СтрокаНастроек.Получатель) Тогда
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаНастроек.ВидКИ) Тогда
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаНастроек.ШаблонСообщения) Тогда
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаНастроек.СобытиеИдентификатор) Тогда
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаНастроек.ТипКИ) = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты И НЕ ЗначениеЗаполнено(СтрокаНастроек.УчетнаяЗапись) Тогда
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ВремяОтправкиПисьма) Тогда
			ЕстьОшибки = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЕстьОшибки Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не заполнены обязательные данные'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолучательПриИзменении(Элемент)

	Индекс = ИндексБлока(Элемент.Имя);
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
	СтрокаНастроек.Модифицированность = Истина;
	ОбработатьИзменениеПолучателя(Индекс);

КонецПроцедуры

&НаКлиенте
Процедура ШаблонСообщенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Индекс = ИндексБлока(Элемент.Имя);
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
	СтрокаНастроек.Модифицированность = Истина;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоШаблонуПослеВыбораШаблона", ЭтотОбъект, Новый Структура("Индекс", Индекс));
	
	Если СтрокаНастроек.ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон") Тогда
		ТипШаблона = "СообщениеSMS";
	Иначе
		ТипШаблона = "Письмо";
	КонецЕсли;
	
	ПодготовитьСообщениеПоШаблону(Неопределено, ТипШаблона, ОписаниеОповещения,, Новый Структура);

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияУдалитьНажатие(Элемент)
	
	Индекс = ИндексБлока(Элемент.Имя);
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
	СтрокаНастроек.Модифицированность = Истина;
	СтрокаНастроек.Удалена = Истина;
	
	ОбновитьЭлементыДействийИЗаполнитьСписокВыбора();

КонецПроцедуры

&НаКлиенте
Процедура ВидКИПриИзменении(Элемент)
	
	Индекс = ИндексБлока(Элемент.Имя);
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
	СтрокаНастроек.Модифицированность = Истина;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Вид",СтрокаНастроек.ВидКИ);
	Отбор.Вставить("Получатель",СтрокаНастроек.Получатель);
	
	ТипКИПолучателя = ВидыКИ.НайтиСтроки(Отбор);
	Если ТипКИПолучателя.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаНастроек.ТипКИ = ТипКИПолучателя[0].ТипКИ;
	СогласоватьТипКИШаблонСообщения(Индекс);
	
	Если НЕ Элементы.ПанельОшибки.Видимость Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ВРаботеПриИзменении(Элемент)
	
	ИзмененПризнакВРаботе = Истина;
	УстановитьМодифицированностьЗадач();
	
	Если НЕ ВРаботе Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстОшибкиSMSНажатие(Элемент)
	ОткрытьФорму("ОбщаяФорма.НастройкаОтправкиSMS",,ЭтаФорма,,,,Новый ОписаниеОповещения("ОтправкаSMSПроверкаНастроек", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура УчетнаяЗаписьПриИзменении(Элемент)
	Индекс = ИндексБлока(Элемент.Имя);
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
	СтрокаНастроек.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СобытиеИдентификаторПриИзменении(Элемент)
	Индекс = ИндексБлока(Элемент.Имя);
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
	СтрокаНастроек.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТекстОшибкиОбсуждениеНажатие(Элемент)
	НачатьПодключениеОбсуждений();
КонецПроцедуры

&НаКлиенте
Процедура ТекстОшибкиНеВключеныБонусыНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СтрокаПоиска", "Бонусные программы");
	ОткрытьФорму("Обработка.НастройкаПрограммы.Форма.НастройкаПрограммы", ПараметрыФормы,ЭтаФорма,,,,Новый ОписаниеОповещения("ПроверкаНастроекПоБонусам", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОтправкиПисьмаПриИзменении(Элемент)
	УстановитьМодифицированностьЗадач();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьДействие(Команда)
	
	ДобавитьДействиеСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьЭлементыДействийИЗаполнитьСписокВыбора()
	ОбновитьЭлементыДействийАссистента();
	ЗаполнитьСписокВыбораЭлементовФормы();
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИндексБлока(ЭлементИмя)
	
	Возврат Прав(ЭлементИмя, СтрДлина(ЭлементИмя) - СтрНайти(ЭлементИмя, "_"));
	
КонецФункции

&НаСервере
Процедура ДобавитьДействиеСервер()
	
	ДобавитьНовыеНастройкиЗадачи();
	ОбновитьЭлементыДействийАссистента();
	ЗаполнитьСписокВыбораЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьНовыеНастройкиЗадачи()
	
	Если ПолучателиСообщений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Получатель = ПолучателиСообщений[0].Путь;
	
	ОтборПоТипуКИ = Новый Структура;
	ОтборПоТипуКИ.Вставить("Получатель", Получатель);
	ОтборПоТипуКИ.Вставить("ТипКИ", Перечисления.ТипыКонтактнойИнформации.Телефон);
	ВидыКИПолучателя = ВидыКИ.НайтиСтроки(ОтборПоТипуКИ);
	
	Если ВидыКИПолучателя.Количество() = 0 Тогда
		ВидыКИПолучателя = ВидыКИ.НайтиСтроки(Новый Структура("Получатель", Получатель));
	КонецЕсли;
	
	Если ВидыКИПолучателя.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
		
	ОбщиеНастройки = Новый Структура;
	ОбщиеНастройки.Вставить("Получатель", Получатель);
	ОбщиеНастройки.Вставить("ВидКИ",      ВидыКИПолучателя[0].Вид);
	ОбщиеНастройки.Вставить("ТипКИ",      ВидыКИПолучателя[0].ТипКИ);
	ОбщиеНастройки.Вставить("УчетнаяЗапись", Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты);
	ОбщиеНастройки.Вставить("Модифицированность", Истина);
	
	НоваяНастройка = НастройкиЗадач.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяНастройка, ОбщиеНастройки);
	НоваяНастройка.СобытиеИдентификатор = "НачислениеБонусовНаДеньРождения";
	НоваяНастройка.ШаблонСообщения = Справочники.ШаблоныНаименований.НайтиПоНаименованию(РаботаСБонусами.НаименованиеШаблонаСообщенияНачислениеБонусовНаДеньРождения(), Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьНаименованиеЗадачи(Задача)
	
	Если Задача.События.Количество() = 0 Тогда
		Задача.Наименование = "";
		Возврат;
	КонецЕсли;
	
	Событие = Задача.События[0].СобытиеИдентификатор;
	
	Наименование = "";
	Если Событие = "НачислениеБонусовНаДеньРождения" Тогда
		Наименование = НСтр("ru='Оповещение клиента о начислении бонусов на день рождения'");
	ИначеЕсли Событие = "СписаниеБонусовПриСгорании" Тогда
		Наименование = НСтр("ru='Оповещение клиента при при сгорании неиспользованных бонусов'");
	КонецЕсли;
	
	Задача.Наименование = Наименование;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьПодключениеОбсуждений()
	
	Продолжение = Новый ОписаниеОповещения("ЗавершитьПодключениеОбсуждений", ЭтотОбъект);
	ОбсужденияКлиент.ПоказатьПодключение(Продолжение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПодключениеОбсуждений(Результат, ДополнительныеПараметры) Экспорт
	
	УправлениеФормой();

КонецПроцедуры

&НаКлиенте
Процедура ПроверкаНастроекПоБонусам(Результат, ДополнительныеПараметры) Экспорт
	
	ПроверкаНастроекПоБонусамСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПроверкаНастроекПоБонусамСервер()
	
	ИспользоватьБонусныеПрограммы = ПолучитьФункциональнуюОпцию("ИспользоватьБонусныеПрограммы");
	Элементы.ПанельОшибки.Видимость = НЕ ИспользоватьБонусныеПрограммы;
	Элементы.ОшибкаНеВключеныБонусы.Видимость = НЕ ИспользоватьБонусныеПрограммы;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьМодифицированностьЗадач()
	
	Для Каждого СтрокаНастроек Из НастройкиЗадач Цикл
		СтрокаНастроек.Модифицированность = Истина;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область КонтактнаяИнформация

&НаСервере
Функция ПолучитьВидыКонтактнойИнформации(ОписаниеПолучателя)
	
	РодительКИ = Неопределено;
	
	Если ОписаниеПолучателя = "ВладелецКарты" Тогда
		РодительКИ = Справочники.ВидыКонтактнойИнформации.СправочникКонтрагенты;
	Иначе
		РодительКИ = Справочники.ВидыКонтактнойИнформации.СправочникКонтактныеЛица;
	КонецЕсли;
	
	Если РодительКИ = Неопределено Тогда
		Возврат РодительКИ;
	КонецЕсли;
	
	СписокВыбораВидовКИ = ПолучитьСписокВыбораВидовКонтактнойИнформации(РодительКИ);
	
	Возврат СписокВыбораВидовКИ;
	
КонецФункции

&НаСервере
Функция ПолучитьСписокВыбораВидовКонтактнойИнформации(РодительКИ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыКонтактнойИнформации.Ссылка КАК Вид,
		|	ВидыКонтактнойИнформации.Наименование КАК Представление,
		|	ВидыКонтактнойИнформации.Тип КАК ТипКИ
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
		|ГДЕ
		|	ВидыКонтактнойИнформации.Родитель = &РодительКИ
		|	И ВидыКонтактнойИнформации.Тип В(&ТипКИ)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВидыКонтактнойИнформации.РеквизитДопУпорядочивания,
		|	ВидыКонтактнойИнформации.Наименование";
	
	ТипКИ = Новый Массив;
	ТипКИ.Добавить(Перечисления.ТипыКонтактнойИнформации.Телефон);
	ТипКИ.Добавить(Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	
	Запрос.УстановитьПараметр("РодительКИ", РодительКИ);
	Запрос.УстановитьПараметр("ТипКИ", ТипКИ);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции
	
#КонецОбласти

#Область ШаблоныСообщений

&НаКлиенте
Процедура ЗаполнитьПоШаблонуПослеВыбораШаблона(ДанныеСообщения, ДополнительныеПараметры) Экспорт
	
	Если ДанныеСообщения = Неопределено ИЛИ ДополнительныеПараметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаНастроек = НастройкиЗадач.Получить(ДополнительныеПараметры.Индекс);
	СтрокаНастроек.ШаблонСообщения = ДанныеСообщения;
	СтрокаНастроек.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьСообщениеПоШаблону(ПредметСообщения, ВидСообщения, ОписаниеОповещенияОЗакрытии = Неопределено, 
	ВладелецШаблона = Неопределено, ПараметрыСообщения = Неопределено) Экспорт
	
	ПараметрыФормы = ПараметрыФормыСообщения(ПредметСообщения, ВидСообщения, ВладелецШаблона, ПараметрыСообщения);
	ПараметрыФормы.Вставить("ПодготовитьШаблон", Истина);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	
	ПоказатьФормуСформироватьСообщение(ПараметрыФормы, ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыФормыСообщения(ПредметШаблона, ВидСообщения, ВладелецШаблона, ПараметрыСообщения)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Предмет",            "НачислениеСписаниеБонусов");
	ПараметрыФормы.Вставить("ВидСообщения",       ВидСообщения);
	ПараметрыФормы.Вставить("ВладелецШаблона",    ВладелецШаблона);
	ПараметрыФормы.Вставить("ПараметрыСообщения", ПараметрыСообщения);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьФормуСформироватьСообщение(ПараметрыФормы, ОписаниеОповещенияОЗакрытии)
	
	ОткрытьФорму("Справочник.ШаблоныСообщений.Форма.СформироватьСообщение", ПараметрыФормы, ЭтотОбъект,,,,ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправкаSMSПроверкаНастроек(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеФормой

&НаСервере
Процедура ЗаполнитьСписокВыбораЭлементовФормы()
	
	
	Для Итератор = 0 По НастройкиЗадач.Количество() - 1 Цикл
		
		Если НастройкиЗадач[Итератор].Удалена Тогда
			Продолжить;
		КонецЕсли;
		
		Элементы["Получатель_" + Итератор].СписокВыбора.Очистить();
		Для каждого ПолучательСообщения Из ПолучателиСообщений Цикл
			Элементы["Получатель_" + Итератор].СписокВыбора.Добавить(ПолучательСообщения.Путь, ПолучательСообщения.Представление);
		КонецЦикла;
		
		Элементы["ВидКИ_" + Итератор].СписокВыбора.Очистить();
		ВидыКИПолучателя = ВидыКИ.НайтиСтроки(Новый Структура("Получатель", НастройкиЗадач[Итератор].Получатель));
		
		Для каждого ВидКИ Из ВидыКИПолучателя Цикл
			Элементы["ВидКИ_" + Итератор].СписокВыбора.Добавить(ВидКИ.Вид, ВидКИ.Представление);
		КонецЦикла;
		
		Элементы["СобытиеИдентификатор_" + Итератор].СписокВыбора.Очистить();
		Элементы["СобытиеИдентификатор_" + Итератор].СписокВыбора.Добавить("СписаниеБонусовПриСгорании", НСтр("ru='сгорании неиспользованных бонусов'"));
		Элементы["СобытиеИдентификатор_" + Итератор].СписокВыбора.Добавить("НачислениеБонусовНаДеньРождения", НСтр("ru='начислении бонусов на день рождения'"));
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере 
Процедура СогласоватьТипКИШаблонСообщения(Индекс)
	
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
	
	Элементы["УчетнаяЗапись_"+Строка(Индекс)].Видимость = 
		СтрокаНастроек.ТипКИ = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
		
	Если НЕ ЗначениеЗаполнено(СтрокаНастроек.УчетнаяЗапись) И Элементы["УчетнаяЗапись_"+Строка(Индекс)].Видимость Тогда
		СтрокаНастроек.УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтрокаНастроек.ШаблонСообщения) Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонПредназначенДляSMS = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаНастроек.ШаблонСообщения, "ПредназначенДляSMS");
	СогласованныеДанные = (СтрокаНастроек.ТипКИ = Перечисления.ТипыКонтактнойИнформации.Телефон И ШаблонПредназначенДляSMS)
		ИЛИ (СтрокаНастроек.ТипКИ = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты И НЕ ШаблонПредназначенДляSMS);
		
	Если СогласованныеДанные Тогда
		Возврат;
	КонецЕсли;
		
	СтрокаНастроек.ШаблонСообщения = Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДействийАссистента()
	
	Элементы.Переместить(Элементы.ДобавитьДействие, Элементы.Действие_0);
	УдаляемыеЭлементы = Новый Массив;
	// Группа первой задачи создана в конфигураторе
	Для ИндексГруппы = 1 По Элементы.ДействияАссистента.ПодчиненныеЭлементы.Количество()-1 Цикл
		УдаляемыеЭлементы.Добавить(Элементы.ДействияАссистента.ПодчиненныеЭлементы[ИндексГруппы]);
	КонецЦикла;

	Для Каждого УдаляемыйЭлемент Из УдаляемыеЭлементы Цикл
		Элементы.Удалить(УдаляемыйЭлемент);
	КонецЦикла;
	
	Для Каждого СтрокаНастроек Из НастройкиЗадач Цикл
		
		ИндексНастройки = НастройкиЗадач.Индекс(СтрокаНастроек);
		
		Если НастройкиЗадач[ИндексНастройки].Удалена Тогда
			Продолжить;
		КонецЕсли;
		
		Если ИндексНастройки > 0 Тогда
			
			ОбщаяГруппаДействия = Элементы.Добавить("ГруппаДействие_" + ИндексНастройки, Тип("ГруппаФормы"), Элементы.ДействияАссистента);
			ОбщаяГруппаДействия.Вид = Элементы.ГруппаДействие_0.Вид;
			ОбщаяГруппаДействия.Отображение = Элементы.ГруппаДействие_0.Отображение;
			ОбщаяГруппаДействия.Группировка = Элементы.ГруппаДействие_0.Группировка;
			ОбщаяГруппаДействия.ОтображатьЗаголовок = Элементы.ГруппаДействие_0.ОтображатьЗаголовок;
			ОбщаяГруппаДействия.ЦветФона = Элементы.ГруппаДействие_0.ЦветФона;
			
			ГруппаДействия = Элементы.Добавить("Действие_" + ИндексНастройки, Тип("ГруппаФормы"), ОбщаяГруппаДействия);
			ГруппаДействия.Вид = Элементы.Действие_0.Вид;
			ГруппаДействия.Отображение = Элементы.Действие_0.Отображение;
			ГруппаДействия.Группировка = Элементы.Действие_0.Группировка;
			ГруппаДействия.ОтображатьЗаголовок = Элементы.Действие_0.ОтображатьЗаголовок;
			ГруппаДействия.ЦветФона = Элементы.Действие_0.ЦветФона;
			
			ГруппаСтроки = Элементы.Добавить("Строки_" + ИндексНастройки, Тип("ГруппаФормы"), ГруппаДействия);
			ГруппаСтроки.Вид = Элементы.Строки_0.Вид;
			ГруппаСтроки.Отображение = Элементы.Строки_0.Отображение;
			ГруппаСтроки.Группировка = Элементы.Строки_0.Группировка;
			ГруппаСтроки.ОтображатьЗаголовок = Элементы.Строки_0.ОтображатьЗаголовок;
			ГруппаСтроки.ЦветФона = Элементы.Строки_0.ЦветФона;

			ГруппаПервойСтрокиДействия = Элементы.Добавить("ГруппаДействие_" + ИндексНастройки + "_Строка_1", Тип("ГруппаФормы"), ГруппаСтроки);
			ГруппаПервойСтрокиДействия.Вид = Элементы.ГруппаДействие_0_Строка_1.Вид;
			ГруппаПервойСтрокиДействия.Отображение = Элементы.ГруппаДействие_0_Строка_1.Отображение;
			ГруппаПервойСтрокиДействия.Группировка = Элементы.ГруппаДействие_0_Строка_1.Группировка;
			ГруппаПервойСтрокиДействия.ОтображатьЗаголовок = Элементы.ГруппаДействие_0_Строка_1.ОтображатьЗаголовок;
			ГруппаПервойСтрокиДействия.СквозноеВыравнивание = Элементы.ГруппаДействие_0_Строка_1.СквозноеВыравнивание;
			
			ПолеПолучатель = Элементы.Добавить("Получатель_" + ИндексНастройки, Тип("ПолеФормы"), ГруппаПервойСтрокиДействия);
			ПолеПолучатель.Вид = Элементы.Получатель_0.Вид;
			ПолеПолучатель.ПутьКДанным = "НастройкиЗадач[" + ИндексНастройки + "].Получатель";
			ПолеПолучатель.ПоложениеЗаголовка = Элементы.Получатель_0.ПоложениеЗаголовка;
			ПолеПолучатель.Заголовок = Элементы.Получатель_0.Заголовок;
			ПолеПолучатель.АвтоМаксимальнаяШирина = Элементы.Получатель_0.АвтоМаксимальнаяШирина;
			ПолеПолучатель.МаксимальнаяШирина = Элементы.Получатель_0.МаксимальнаяШирина;
			ПолеПолучатель.РежимВыбораИзСписка = Элементы.Получатель_0.РежимВыбораИзСписка;
			ПолеПолучатель.КнопкаВыпадающегоСписка = Элементы.Получатель_0.КнопкаВыпадающегоСписка;
			ПолеПолучатель.АвтоОтметкаНезаполненного = Элементы.Получатель_0.АвтоОтметкаНезаполненного;
			ПолеПолучатель.УстановитьДействие("ПриИзменении", "ПолучательПриИзменении");
			
			ПолеВидКИ = Элементы.Добавить("ВидКИ_" + ИндексНастройки, Тип("ПолеФормы"), ГруппаПервойСтрокиДействия);
			ПолеВидКИ.Вид = Элементы.ВидКИ_0.Вид;
			ПолеВидКИ.ПутьКДанным = "НастройкиЗадач[" + ИндексНастройки + "].ВидКИ";
			ПолеВидКИ.ПоложениеЗаголовка = Элементы.ВидКИ_0.ПоложениеЗаголовка;
			ПолеВидКИ.Заголовок = Элементы.ВидКИ_0.Заголовок;
			ПолеВидКИ.АвтоМаксимальнаяШирина = Элементы.ВидКИ_0.АвтоМаксимальнаяШирина;
			ПолеВидКИ.МаксимальнаяШирина = Элементы.ВидКИ_0.МаксимальнаяШирина;
			ПолеВидКИ.РежимВыбораИзСписка = Элементы.ВидКИ_0.РежимВыбораИзСписка;
			ПолеВидКИ.КнопкаСоздания = Элементы.ВидКИ_0.КнопкаСоздания;
			ПолеВидКИ.КнопкаОткрытия = Элементы.ВидКИ_0.КнопкаОткрытия;
			ПолеВидКИ.АвтоОтметкаНезаполненного = Элементы.Получатель_0.АвтоОтметкаНезаполненного;
			ПолеВидКИ.УстановитьДействие("ПриИзменении","ВидКИПриИзменении");
			
			ПолеШаблонСообщения = Элементы.Добавить("ШаблонСообщения_" + ИндексНастройки, Тип("ПолеФормы"), ГруппаПервойСтрокиДействия);
			ПолеШаблонСообщения.Вид = Элементы.ШаблонСообщения_0.Вид;
			ПолеШаблонСообщения.ПутьКДанным = "НастройкиЗадач[" + ИндексНастройки + "].ШаблонСообщения";
			ПолеШаблонСообщения.ПоложениеЗаголовка = Элементы.ШаблонСообщения_0.ПоложениеЗаголовка;
			ПолеШаблонСообщения.Заголовок = Элементы.ШаблонСообщения_0.Заголовок;
			ПолеШаблонСообщения.АвтоМаксимальнаяШирина = Элементы.ШаблонСообщения_0.АвтоМаксимальнаяШирина;
			ПолеШаблонСообщения.МаксимальнаяШирина = Элементы.ШаблонСообщения_0.МаксимальнаяШирина;
			ПолеШаблонСообщения.КнопкаСоздания = Элементы.ШаблонСообщения_0.КнопкаСоздания;
			ПолеШаблонСообщения.ИсторияВыбораПриВводе = Элементы.ШаблонСообщения_0.ИсторияВыбораПриВводе;
			ПолеШаблонСообщения.АвтоОтметкаНезаполненного = Элементы.Получатель_0.АвтоОтметкаНезаполненного;
			ПолеШаблонСообщения.УстановитьДействие("НачалоВыбора","ШаблонСообщенияНачалоВыбора");
			
			ДекорацияУдалить = Элементы.Добавить("ДекорацияУдалить_" + ИндексНастройки, Тип("ДекорацияФормы"), ОбщаяГруппаДействия);
			ДекорацияУдалить.Вид = Элементы.ДекорацияУдалить_0.Вид;
			ДекорацияУдалить.Заголовок = Элементы.ДекорацияУдалить_0.Заголовок;
			ДекорацияУдалить.Ширина = Элементы.ДекорацияУдалить_0.Ширина;
			ДекорацияУдалить.Высота = Элементы.ДекорацияУдалить_0.Высота;
			ДекорацияУдалить.Картинка = Элементы.ДекорацияУдалить_0.Картинка;
			ДекорацияУдалить.РазмерКартинки = Элементы.ДекорацияУдалить_0.РазмерКартинки;
			ДекорацияУдалить.Гиперссылка = Элементы.ДекорацияУдалить_0.Гиперссылка;
			ДекорацияУдалить.УстановитьДействие("Нажатие", "ДекорацияУдалитьНажатие");

			ГруппаВторойСтрокиДействия = Элементы.Добавить("ГруппаДействие_" + ИндексНастройки + "_Строка_2", Тип("ГруппаФормы"), ГруппаСтроки);
			ГруппаВторойСтрокиДействия.Вид = Элементы.ГруппаДействие_0.Вид;
			ГруппаВторойСтрокиДействия.Отображение = Элементы.ГруппаДействие_0_Строка_2.Отображение;
			ГруппаВторойСтрокиДействия.Группировка = Элементы.ГруппаДействие_0_Строка_2.Группировка;
			ГруппаВторойСтрокиДействия.ОтображатьЗаголовок = Элементы.ГруппаДействие_0_Строка_2.ОтображатьЗаголовок;
			
			ПолеУчетнаяЗапись = Элементы.Добавить("УчетнаяЗапись_" + ИндексНастройки, Тип("ПолеФормы"), ГруппаВторойСтрокиДействия);
			ПолеУчетнаяЗапись.Вид = Элементы.УчетнаяЗапись_0.Вид;
			ПолеУчетнаяЗапись.ПутьКДанным = "НастройкиЗадач[" + ИндексНастройки + "].УчетнаяЗапись";
			ПолеУчетнаяЗапись.ПоложениеЗаголовка = Элементы.УчетнаяЗапись_0.ПоложениеЗаголовка;
			ПолеУчетнаяЗапись.Заголовок = Элементы.УчетнаяЗапись_0.Заголовок;
			ПолеУчетнаяЗапись.АвтоМаксимальнаяШирина = Элементы.УчетнаяЗапись_0.АвтоМаксимальнаяШирина;
			ПолеУчетнаяЗапись.МаксимальнаяШирина = Элементы.УчетнаяЗапись_0.МаксимальнаяШирина;
			ПолеУчетнаяЗапись.Видимость = НастройкиЗадач[ИндексНастройки].ТипКИ = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
			ПолеУчетнаяЗапись.АвтоОтметкаНезаполненного = Элементы.Получатель_0.АвтоОтметкаНезаполненного;
			ПолеУчетнаяЗапись.УстановитьДействие("ПриИзменении", "УчетнаяЗаписьПриИзменении");
			ПолеУчетнаяЗапись.КнопкаСоздания = Элементы.УчетнаяЗапись_0.КнопкаСоздания;
			
			ПолеСобытиеИдентификатор = Элементы.Добавить("СобытиеИдентификатор_" + ИндексНастройки, Тип("ПолеФормы"), ГруппаВторойСтрокиДействия);
			ПолеСобытиеИдентификатор.Вид = Элементы.СобытиеИдентификатор_0.Вид;
			ПолеСобытиеИдентификатор.ПутьКДанным = "НастройкиЗадач[" + ИндексНастройки + "].СобытиеИдентификатор";
			ПолеСобытиеИдентификатор.ПоложениеЗаголовка = Элементы.СобытиеИдентификатор_0.ПоложениеЗаголовка;
			ПолеСобытиеИдентификатор.Заголовок = Элементы.СобытиеИдентификатор_0.Заголовок;
			ПолеСобытиеИдентификатор.АвтоМаксимальнаяШирина = Элементы.СобытиеИдентификатор_0.АвтоМаксимальнаяШирина;
			ПолеСобытиеИдентификатор.МаксимальнаяШирина = Элементы.СобытиеИдентификатор_0.МаксимальнаяШирина;
			ПолеСобытиеИдентификатор.РежимВыбораИзСписка = Элементы.СобытиеИдентификатор_0.РежимВыбораИзСписка;
			ПолеСобытиеИдентификатор.АвтоОтметкаНезаполненного = Элементы.Получатель_0.АвтоОтметкаНезаполненного;
			ПолеСобытиеИдентификатор.УстановитьДействие("ПриИзменении", "СобытиеИдентификаторПриИзменении");
			
			ДекорацияТекстОбсуждение = Элементы.Добавить("ТекстОбсуждение_" + ИндексНастройки, Тип("ДекорацияФормы"), ГруппаВторойСтрокиДействия);
			ДекорацияТекстОбсуждение.Вид = Элементы.ТекстОбсуждение_0.Вид;
			ДекорацияТекстОбсуждение.Заголовок = Элементы.ТекстОбсуждение_0.Заголовок;
			ДекорацияТекстОбсуждение.Ширина = Элементы.ТекстОбсуждение_0.Ширина;
			
			Элементы.Переместить(Элементы.ДобавитьДействие, Элементы["Действие_" + ИндексНастройки]);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.УчетнаяЗапись_0.Видимость = НастройкиЗадач[0].ТипКИ = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеПолучателя(Индекс)
	
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
	Элементы["ВидКИ_" + Индекс].СписокВыбора.Очистить();
	
	ВидыКИПолучателя = ВидыКИ.НайтиСтроки(Новый Структура("Получатель", СтрокаНастроек.Получатель));
	
	Если ВидыКИПолучателя.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ВидКИ Из ВидыКИПолучателя Цикл
		Элементы["ВидКИ_" + Индекс].СписокВыбора.Добавить(ВидКИ.Вид, ВидКИ.Представление);
	КонецЦикла;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Получатель", СтрокаНастроек.Получатель);
	Отбор.Вставить("ТипКИ", СтрокаНастроек.ТипКИ);
	
	СтрокаТипКИ = ВидыКИ.НайтиСтроки(Отбор);
	
	Если СтрокаТипКИ.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаНастроек.ВидКИ = СтрокаТипКИ[0].Вид;
	
	СогласоватьТипКИШаблонСообщения(Индекс);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	ИспользоватьБонусныеПрограммы = ПолучитьФункциональнуюОпцию("ИспользоватьБонусныеПрограммы");
	ИнформационнаяБазаЗарегистрирована = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	НастройкиSMSВыполнены = ОтправкаSMS.НастройкаОтправкиSMSВыполнена();
	
	Если НЕ ИспользоватьБонусныеПрограммы Тогда
		ВРаботе = Ложь;
		Элементы.ПанельОшибки.Видимость = Истина;
		Элементы.ОшибкаНеВключеныБонусы.Видимость = Истина;
		Элементы.ОшибкаНеПодключенПровайдер.Видимость = Ложь;
		Элементы.ОшибкаНеПодключеныОбсуждения.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ТипКИ", ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон"));
	Отбор.Вставить("Удалена", Ложь);
	
	ЗадачиОтправкиSMS = НастройкиЗадач.НайтиСтроки(Отбор);
	ЕстьЗадачиSMS = ЗадачиОтправкиSMS.Количество() <> 0;
		
	ЕстьОшибкиSMS = ЕстьЗадачиSMS И НЕ НастройкиSMSВыполнены;
	ЕстьОшибкиПодключенияБазы = НЕ ИнформационнаяБазаЗарегистрирована;
		
	ВРаботе = НЕ ЕстьОшибкиSMS И НЕ ЕстьОшибкиПодключенияБазы;
	
	Элементы.ПанельОшибки.Видимость = ЕстьОшибкиSMS ИЛИ ЕстьОшибкиПодключенияБазы;
	
	Элементы.ОшибкаНеПодключенПровайдер.Видимость = ЕстьОшибкиSMS;
	Элементы.ОшибкаНеПодключеныОбсуждения.Видимость = ЕстьОшибкиПодключенияБазы;
	Элементы.ОшибкаНеВключеныБонусы.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ЗадачиАссистента

&НаСервере
Процедура УдалитьОдинаковыеДействияИзНастроек()
	
	Для Каждого СтрокаНастроек Из НастройкиЗадач Цикл
			
		ОтборПоУсловиям = Новый Структура;
		ОтборПоУсловиям.Вставить("Удалена", Ложь);
		ОтборПоУсловиям.Вставить("Получатель", СтрокаНастроек.Получатель);
		ОтборПоУсловиям.Вставить("ВидКИ", СтрокаНастроек.ВидКИ);
		ОтборПоУсловиям.Вставить("СобытиеИдентификатор", СтрокаНастроек.СобытиеИдентификатор);
		ОтборПоУсловиям.Вставить("УчетнаяЗапись", СтрокаНастроек.УчетнаяЗапись);
		ОтборПоУсловиям.Вставить("ШаблонСообщения", СтрокаНастроек.ШаблонСообщения);
		
		ЕстьЗадачиСОдинаковымиУсловиями = НастройкиЗадач.НайтиСтроки(ОтборПоУсловиям).Количество() > 1;
		
		Если ЕстьЗадачиСОдинаковымиУсловиями Тогда
			СтрокаНастроек.Удалена = Истина;
			СтрокаНастроек.Модифицированность = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьБлокиНастроекАссистента()
		
	ГруппаЗадач = Справочники.ЗадачиАссистентаУправления.СсылкаНаГруппуЗадач(ИдентификаторГруппы);
	
	Если НЕ ЗначениеЗаполнено(ГруппаЗадач) Тогда
		ДобавитьПустыеНастройкиЗадачи();
		Возврат;
	КонецЕсли;
	
	ОтобранныеЗадачи = Справочники.ЗадачиАссистентаУправления.ПолучитьЗадачиПоГруппе(ГруппаЗадач);
	НастройкиЗадач.Очистить();
	
	Для каждого Задача Из ОтобранныеЗадачи Цикл
		
		ДанныеЗадачи       = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Задача, "Используется");
		ЗначенияЗаполнения = Справочники.ЗадачиАссистентаУправления.ЗначенияЗаполнения(Задача);
		
		Отбор = Новый Структура;
		Отбор.Вставить("Получатель",ЗначенияЗаполнения.Получатель);
		Отбор.Вставить("Вид",ЗначенияЗаполнения.ВидКИ);
		СтрокаТипКИ = ВидыКИ.НайтиСтроки(Отбор);
		
		СтрокаНастроек = НастройкиЗадач.Добавить();
		СтрокаНастроек.Задача        = Задача;
		СтрокаНастроек.Получатель    = ЗначенияЗаполнения.Получатель;
		СтрокаНастроек.ВидКИ         = ЗначенияЗаполнения.ВидКИ;
		СтрокаНастроек.ШаблонСообщения  = ЗначенияЗаполнения.ШаблонСообщения;
		СтрокаНастроек.УчетнаяЗапись = ЗначенияЗаполнения.УчетнаяЗапись;
		СтрокаНастроек.Удалена       = Ложь;
		СтрокаНастроек.Модифицированность = Ложь;

		
		СобытиеИдентификатор = Неопределено;
		Если Задача.События.Количество() <> 0 Тогда
			СобытиеИдентификатор = Задача.События[0].СобытиеИдентификатор;
		КонецЕсли;
		
		СтрокаНастроек.СобытиеИдентификатор = СобытиеИдентификатор;
		ЭтотОбъект.ВРаботе = ДанныеЗадачи.Используется;
		
		Если СтрокаТипКИ.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаНастроек.ТипКИ = СтрокаТипКИ[0].ТипКИ;

	КонецЦикла;
	
	Если НастройкиЗадач.Количество() = 0 Тогда
		ДобавитьПустыеНастройкиЗадачи();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПустыеНастройкиЗадачи()
	
	Если ПолучателиСообщений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Получатель = ПолучателиСообщений[0].Путь;
	
	ОтборПоТипуКИ = Новый Структура;
	ОтборПоТипуКИ.Вставить("Получатель", Получатель);
	ОтборПоТипуКИ.Вставить("ТипКИ", Перечисления.ТипыКонтактнойИнформации.Телефон);
	ВидыКИПолучателя = ВидыКИ.НайтиСтроки(ОтборПоТипуКИ);
	
	Если ВидыКИПолучателя.Количество() = 0 Тогда
		ВидыКИПолучателя = ВидыКИ.НайтиСтроки(Новый Структура("Получатель", Получатель));
	КонецЕсли;
	
	Если ВидыКИПолучателя.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОбщиеНастройки = Новый Структура;
	ОбщиеНастройки.Вставить("Получатель", Получатель);
	ОбщиеНастройки.Вставить("ВидКИ",      ВидыКИПолучателя[0].Вид);
	ОбщиеНастройки.Вставить("ТипКИ",      ВидыКИПолучателя[0].ТипКИ);
	ОбщиеНастройки.Вставить("УчетнаяЗапись", Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты);
	ОбщиеНастройки.Вставить("Модифицированность", Истина);
	
	// 1.
	НоваяНастройка = НастройкиЗадач.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяНастройка, ОбщиеНастройки);
	НоваяНастройка.СобытиеИдентификатор = "СписаниеБонусовПриСгорании";
	НоваяНастройка.ШаблонСообщения = Справочники.ШаблоныНаименований.НайтиПоНаименованию(РаботаСБонусами.НаименованиеШаблонаСообщенияСгораниеБонусов(), Истина);
	
	// 2.
	НоваяНастройка = НастройкиЗадач.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяНастройка, ОбщиеНастройки);
	НоваяНастройка.СобытиеИдентификатор = "НачислениеБонусовНаДеньРождения";
	НоваяНастройка.ШаблонСообщения = Справочники.ШаблоныНаименований.НайтиПоНаименованию(РаботаСБонусами.НаименованиеШаблонаСообщенияНачислениеБонусовНаДеньРождения(), Истина);
		
КонецПроцедуры

&НаСервере
Процедура СоздатьИзменитьЗадачиАссистента()
	
	ДействиеИдентификатор = "ОповеститьКлиента";
	УдалитьОдинаковыеДействияИзНастроек();
	РаботаСБонусами.ИзменитьПараметрыУведомленияОбАвтоматическомНачисленииСписанииБонусов(ВРаботе,ВремяОтправкиПисьма);
	
	НачатьТранзакцию();
	
	Попытка
		
		ГруппаЗадач = Справочники.ЗадачиАссистентаУправления.СсылкаНаГруппуЗадач(ИдентификаторГруппы);
		
		Если НЕ ЗначениеЗаполнено(ГруппаЗадач) Тогда
			ГруппаЗадач = Справочники.ЗадачиАссистентаУправления.СоздатьГруппу();
			ГруппаЗадач.Наименование = НСтр("ru = 'Оповестить клиента о бонусах при условиях'");
			ГруппаЗадач.ИдентификаторГруппы = ИдентификаторГруппы;
			ГруппаЗадач.Записать();
		КонецЕсли;
		
		Для каждого СтрокаНастроек Из НастройкиЗадач Цикл
			
			Если СтрокаНастроек.ТипКИ = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
				ДействиеИдентификатор = "СоздатьОтправитьSMS";
			ИначеЕсли СтрокаНастроек.ТипКИ = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
				ДействиеИдентификатор = "СоздатьОтправитьЭлектронноеПисьмо";
			КонецЕсли;
			
			ЗадачаИзменена = СтрокаНастроек.Модифицированность;
			
			Если НЕ ЗадачаИзменена Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаНастроек.Задача) Тогда
				ЗадачаОбъект = СтрокаНастроек.Задача.ПолучитьОбъект();
			Иначе
				ЗадачаОбъект = Справочники.ЗадачиАссистентаУправления.СоздатьЭлемент();
				АвторИзменений = Пользователи.АвторизованныйПользователь();
				ЕстьЗадачиПользователя = Справочники.ЗадачиАссистентаУправления.ЕстьЗадачиПользователя(АвторИзменений);
			КонецЕсли;
			
			Если СтрокаНастроек.Удалена И ЗначениеЗаполнено(ЗадачаОбъект.Ссылка) Тогда
				УдалитьОсновнуюИВспомогательныеЗадачи(ЗадачаОбъект);
			КонецЕсли;
			
			Если СтрокаНастроек.Удалена Тогда
				СтрокаНастроек.Модифицированность = Ложь;
				Продолжить;
			КонецЕсли;
			
			ЗадачаОбъект.ДействиеИдентификатор = ДействиеИдентификатор;
			
			ЗадачаОбъект.События.Очистить();
			НовоеСобытие = ЗадачаОбъект.События.Добавить();
			НовоеСобытие.СобытиеИдентификатор = СтрокаНастроек.СобытиеИдентификатор;
			
			ЗадачаОбъект.ТипПредмета      = ТипПредмета;
			ЗадачаОбъект.СпособОповещения = Перечисления.СпособОповещенияАссистентаУправления.СообщениеКонтекстногоОбсужденияБезОповещения;
			ЗадачаОбъект.Используется     = ЭтотОбъект.ВРаботе;
			ЗадачаОбъект.Родитель         = ГруппаЗадач.Ссылка;
			
			ЗадачаОбъект.ЗначенияЗаполнения.Очистить();
			ЗадачаОбъект.ПараметрыУсловия.Очистить();

			ДобавитьПараметрЗадачи(ЗадачаОбъект.ЗначенияЗаполнения, "Получатель", СтрокаНастроек.Получатель);
			ДобавитьПараметрЗадачи(ЗадачаОбъект.ЗначенияЗаполнения, "ВидКИ", СтрокаНастроек.ВидКИ);
			ДобавитьПараметрЗадачи(ЗадачаОбъект.ЗначенияЗаполнения, "ШаблонСообщения", СтрокаНастроек.ШаблонСообщения);
			ДобавитьПараметрЗадачи(ЗадачаОбъект.ЗначенияЗаполнения, "УчетнаяЗапись", СтрокаНастроек.УчетнаяЗапись);
			
			ОпределитьНаименованиеЗадачи(ЗадачаОбъект);
			ЗадачаОбъект.Записать();
			
			СтрокаНастроек.Модифицированность = Ложь;
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ТекстОшибки;
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПараметрЗадачи(Таблица, Параметр, Значение)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Параметр = Параметр;
	НоваяСтрока.Значение = Новый ХранилищеЗначения(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуЗадач()
	
	Результат = Новый Структура();
	
	Результат.Вставить("ИзмененПризнакВРаботе", ИзмененПризнакВРаботе);
	Результат.Вставить("АвторИзменений", АвторИзменений);
	Результат.Вставить("ГруппаЗадач", ИдентификаторГруппы);
	Результат.Вставить("НужноДобавитьВОбсуждение", НЕ ЕстьЗадачиПользователя);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьОсновнуюИВспомогательныеЗадачи(ЗадачаОбъект)
	
	Отбор = Справочники.ЗадачиАссистентаУправления.НовыйОтборЗадач();
	Отбор.ОсновнаяЗадача = ЗадачаОбъект.Ссылка;
	ОтобранныеЗадачи = Справочники.ЗадачиАссистентаУправления.ПолучитьЗадачи(Отбор);
	ЗадачаОбъект.Удалить();

	Если ОтобранныеЗадачи.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ВспомогательнаяЗадача Из ОтобранныеЗадачи Цикл
		Если НЕ ЗначениеЗаполнено(ВспомогательнаяЗадача.Ссылка) Тогда
			Продолжить;
		КонецЕсли;
		ВспомогательнаяЗадачаОбъект = ВспомогательнаяЗадача.ПолучитьОбъект();
		ВспомогательнаяЗадачаОбъект.Удалить();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
