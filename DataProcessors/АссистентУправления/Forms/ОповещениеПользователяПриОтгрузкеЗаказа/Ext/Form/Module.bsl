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
	
	ЭтотОбъект.ИспользоватьВидыЗаказовПокупателей = ПолучитьФункциональнуюОпцию("ИспользоватьВидыЗаказовПокупателей");
	ЭтотОбъект.ИспользоватьВидыЗаказНарядов = ПолучитьФункциональнуюОпцию("ИспользоватьВидыЗаказНарядов");
	ЭтотОбъект.ИспользоватьПодсистемуРаботы = ПолучитьФункциональнуюОпцию("ИспользоватьПодсистемуРаботы");
	НадписьЗаказПокупателя = НСтр("ru = 'Когда заказ покупателя'"); 
	
	ИдентификаторГруппы = "ОповещениеПользователяПриОтгрузкеЗаказа";

	РазрешеноИзменятьЗадачи = Обработки.АссистентУправления.РазрешеноИзменятьЗадачи();
	
	ИнформационнаяБазаЗарегистрирована = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	
	ЗаполнитьСпособыОповещения();

	ОбновитьБлокиНастроекАссистента();
	ОбновитьЭлементыДействийАссистента();
	ЗаполнитьСписокВыбораЭлементовФормы();
	
	КлючСохраненияПоложенияОкна = Новый УникальныйИдентификатор();
	
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
	
	Если НЕ РазрешеноИзменятьЗадачи Тогда
		Возврат;
	КонецЕсли;

	ИзмененныеЗадачи = НастройкиЗадач.НайтиСтроки(Новый Структура("Модифицированность", Истина));
	ЗадачиИзменены = ИзмененныеЗадачи.Количество() <> 0;
	
	Если НЕ ЗадачиИзменены Тогда
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
		
		Индекс = НастройкиЗадач.Индекс(СтрокаНастроек);
				
		Если Не ЗначениеЗаполнено(СтрокаНастроек.ВидЗаказа) Тогда
			ЕстьОшибки = Истина;
		КонецЕсли;
				
		Если Не ЗначениеЗаполнено(СтрокаНастроек.СтатусОтгрузки) Тогда
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаНастроек.СпособОповещения) Тогда
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
Процедура СтатусОтгрузкиПриИзменении(Элемент)
	СтрокаНастроек = НастройкиЗадач.Получить(ИндексБлока(Элемент.Имя));
	СтрокаНастроек.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СпособОповещенияПриИзменении(Элемент)
	
	ИндексЭлемента = ИндексБлока(Элемент.Имя);
	СтрокаНастроек = НастройкиЗадач.Получить(ИндексЭлемента);
	СтрокаНастроек.Модифицированность = Истина;
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ВРаботеПриИзменении(Элемент)
	
	ИзмененПризнакВРаботе = Истина;
	
	УстановитьМодифицированностьЗадач();
	
	Если НЕ ВРаботе Тогда
		Возврат;
	КонецЕсли;
	
	Если ИнформационнаяБазаЗарегистрирована Тогда
		Возврат;
	КонецЕсли;
	
	ВРаботе = Ложь;
	Элементы.ПанельОшибки.Видимость = Истина;

	
КонецПроцедуры

&НаКлиенте
Процедура ВидЗаказаПриИзменении(Элемент)
	
	Индекс = ИндексБлока(Элемент.Имя);
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
	СтрокаНастроек.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияУдалитьНажатие(Элемент)
	
	Индекс = ИндексБлока(Элемент.Имя);
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
	СтрокаНастроек.Удалена = Истина;
	СтрокаНастроек.Модифицированность = Истина;
	
	ОбновитьЭлементыДействийИЗаполнитьСписокВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОповещенияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Индекс = ИндексБлока(Элемент.Имя);
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
	СтрокаНастроек.Модифицированность = Истина;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи") Тогда
		
		Элементы["СпособОповещения_" + Индекс].ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Пользователи");
		НастройкиЗадач[Число(Индекс)].СпособОповещения = ВыбранноеЗначение;
		НастройкиЗадач[Число(Индекс)].ПользовательДляОповещения = ВыбранноеЗначение;
		
		Возврат;
		
	КонецЕсли;
	
	ЗначениеСпособаОповещения = СпособыОповещения.НайтиСтроки(Новый Структура("Представление", ВыбранноеЗначение));
	
	Если ЗначениеСпособаОповещения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеСпособаОповещения[0].Значение <> ПредопределенноеЗначение("Перечисление.СпособОповещенияАссистентаУправления.СообщениеКонтекстногоОбсужденияПользователю") Тогда
		
		Элементы["СпособОповещения_" + Индекс].ОграничениеТипа = Новый ОписаниеТипов("Строка");
		НастройкиЗадач[Число(Индекс)].СпособОповещения = ВыбранноеЗначение;
		НастройкиЗадач[Число(Индекс)].ПользовательДляОповещения = Неопределено;
		Возврат;
		
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Индекс", Индекс);
	
	Оповещение = Новый ОписаниеОповещения("ВыборПользователя", ЭтотОбъект, ДополнительныеПараметры);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора",Истина);
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора",ПараметрыФормы,,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

КонецПроцедуры

&НаКлиенте
Процедура СпособОповещенияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Индекс = ИндексБлока(Элемент.Имя);
	ЗаполнитьДанныеВыбора(ДанныеВыбора, Индекс);
КонецПроцедуры

&НаКлиенте
Процедура СпособОповещенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Индекс = ИндексБлока(Элемент.Имя);
	ЗаполнитьДанныеВыбора(ДанныеВыбора, Индекс);
КонецПроцедуры

&НаКлиенте
Процедура ТекстОшибкиНажатие(Элемент)
	НачатьПодключениеОбсуждений();
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
Процедура ДобавитьДействиеСервер()
	
	ДобавитьПустыеНастройкиЗадачи();
	ОбновитьЭлементыДействийАссистента();
	ЗаполнитьСписокВыбораЭлементовФормы();

КонецПроцедуры

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
Процедура ОпределитьНаименованиеЗадачи(Задача, СтрокаНастроек)
	
	Наименование = "";
	Если СтрокаНастроек.СтатусОтгрузки = Перечисления.СтатусОтгрузки.Полная Тогда
		Наименование = НСтр("ru='Оповестить пользователя при полной отгрузке заказа'");
	ИначеЕсли СтрокаНастроек.СтатусОтгрузки = Перечисления.СтатусОтгрузки.Частичная Тогда
		Наименование = НСтр("ru='Оповестить пользователя при частичной отгрузке заказа'");
	КонецЕсли;
		
	Задача.Наименование = Наименование;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеВыбора(ДанныеВыбора,Индекс)
	
	Если ДанныеВыбора = Неопределено Тогда
		ДанныеВыбора = Новый СписокЗначений;
	КонецЕсли;
	
	СпособНикогоНеОповещать = СпособыОповещения.НайтиСтроки(Новый Структура("Значение", Перечисления.СпособОповещенияАссистентаУправления.СообщениеКонтекстногоОбсужденияБезОповещения));
	Если СпособНикогоНеОповещать.Количество() > 0 Тогда
		ДанныеВыбора.Добавить(СпособНикогоНеОповещать[0].Представление,
		,,БиблиотекаКартинок.СпособОповещенияНикогоНеОповещать);
	КонецЕсли;
	
	СпособОповестиОтветственного = СпособыОповещения.НайтиСтроки(Новый Структура("Значение", Перечисления.СпособОповещенияАссистентаУправления.СообщениеКонтекстногоОбсужденияОтветственному));
	Если СпособОповестиОтветственного.Количество() > 0 Тогда
		ДанныеВыбора.Добавить(СпособОповестиОтветственного[0].Представление,
		,,БиблиотекаКартинок.СпособОповещенияОповеститьВыбранного);
	КонецЕсли;
	
	ДанныеВыбора.Добавить(Пользователи.АвторизованныйПользователь(), ,,БиблиотекаКартинок.СпособОповещенияОповеститьВыбранного);
		
	СпособОповестиПользователя = СпособыОповещения.НайтиСтроки(Новый Структура("Значение", Перечисления.СпособОповещенияАссистентаУправления.СообщениеКонтекстногоОбсужденияПользователю));
	Если СпособОповестиПользователя.Количество() > 0 Тогда
		ДанныеВыбора.Добавить(СпособОповестиПользователя[0].Представление,
		,,БиблиотекаКартинок.СпособОповещенияОповеститьВыбранного);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ВыборПользователя(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено ИЛИ ДополнительныеПараметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Индекс = ДополнительныеПараметры.Индекс;
	Элементы["СпособОповещения_"+Индекс].ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Пользователи");
	НастройкиЗадач[Число(Индекс)].СпособОповещения = Результат;
	НастройкиЗадач[Число(Индекс)].ПользовательДляОповещения = Результат;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьМодифицированностьЗадач()
	
	Для Каждого СтрокаНастроек Из НастройкиЗадач Цикл
		СтрокаНастроек.Модифицированность = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьПодключениеОбсуждений()
	
	Продолжение = Новый ОписаниеОповещения("ЗавершитьПодключениеОбсуждений", ЭтотОбъект);
	ОбсужденияКлиент.ПоказатьПодключение(Продолжение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПодключениеОбсуждений(Результат, ДополнительныеПараметры) Экспорт
	
	ИнформационнаяБазаЗарегистрирована = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	Элементы.ПанельОшибки.Видимость = НЕ ИнформационнаяБазаЗарегистрирована;
	ВРаботе = ИнформационнаяБазаЗарегистрирована;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпособыОповещения()
	
	СпособыОповещения.Очистить();
	
	СпособНикогоНеОповещать = СпособыОповещения.Добавить();
	СпособНикогоНеОповещать.Значение = Перечисления.СпособОповещенияАссистентаУправления.СообщениеКонтекстногоОбсужденияБезОповещения;
	СпособНикогоНеОповещать.Представление = НСтр("ru = 'Никого не оповещать'");
	
	СпособОповестиОтветственного = СпособыОповещения.Добавить();
	СпособОповестиОтветственного.Значение = Перечисления.СпособОповещенияАссистентаУправления.СообщениеКонтекстногоОбсужденияОтветственному;
	СпособОповестиОтветственного.Представление = НСтр("ru = 'Ответственного за заказ'");
	
	СпособОповестиПользователя = СпособыОповещения.Добавить();
	СпособОповестиПользователя.Значение = Перечисления.СпособОповещенияАссистентаУправления.СообщениеКонтекстногоОбсужденияПользователю;
	СпособОповестиПользователя.Представление = НСтр("ru = 'Другого пользователя'");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпособОповещенияПоЗначению(СтрокаНастроек, ПользовательДляОповещения, СпособОповещения)
	
	Если НЕ ЗначениеЗаполнено(ПользовательДляОповещения) Тогда
		
		ПредставлениеСпособаОповещения = СпособыОповещения.НайтиСтроки(Новый Структура("Значение", СпособОповещения));
		
		Если ПредставлениеСпособаОповещения.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаНастроек.СпособОповещения = ПредставлениеСпособаОповещения[0].Представление;
		
		Возврат;
		
	КонецЕсли;
	
	СтрокаНастроек.СпособОповещения = ПользовательДляОповещения;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпособОповещенияПоПредставлению(СтрокаНастроек, ЗадачаОбъект)
		
	ЗначениеСпособаОповещения = СпособыОповещения.НайтиСтроки(Новый Структура("Представление", СтрокаНастроек.СпособОповещения));
	
	Если ЗначениеСпособаОповещения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗадачаОбъект.СпособОповещения = ЗначениеСпособаОповещения[0].Значение;
			
КонецПроцедуры

&НаСервере
Процедура ОпределитьСобытияЗадачи(ТаблицаСобытий, СтрокаНастроек, СобытиеПолнаяОтгрузка, СобытиеЧастичнаяОтгрузка)
	
	Если СтрокаНастроек.СтатусОтгрузки = Перечисления.СтатусОтгрузки.Полная Тогда
		НовоеСобытие = ТаблицаСобытий.Добавить();
		НовоеСобытие.СобытиеИдентификатор = СобытиеПолнаяОтгрузка;
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ВидЗаказа", СтрокаНастроек.ВидЗаказа);
	Отбор.Вставить("СтатусОтгрузки", Перечисления.СтатусОтгрузки.Полная);
	
	ЗадачиПолнойОтгрузки = НастройкиЗадач.НайтиСтроки(Отбор);
	ЕстьЗадачиПолнойОтгрузки = ЗадачиПолнойОтгрузки.Количество() > 0;
	
	Если ЕстьЗадачиПолнойОтгрузки Тогда
		НовоеСобытие = ТаблицаСобытий.Добавить();
		НовоеСобытие.СобытиеИдентификатор = СобытиеЧастичнаяОтгрузка;
	Иначе 
		НовоеСобытиеЧастичнаяОтгрузка = ТаблицаСобытий.Добавить();
		НовоеСобытиеЧастичнаяОтгрузка.СобытиеИдентификатор = СобытиеЧастичнаяОтгрузка;
		
		НовоеСобытиеПолнаяОтгрузка = ТаблицаСобытий.Добавить();
		НовоеСобытиеПолнаяОтгрузка.СобытиеИдентификатор = СобытиеПолнаяОтгрузка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьПараметрыУсловияОтгрузки(СтрокаНастроек, ТаблицаУсловий)
	
	Если СтрокаНастроек.СтатусОтгрузки = Перечисления.СтатусОтгрузки.Полная Тогда
		ДобавитьПараметрУсловия(ТаблицаУсловий, "СтатусОтгрузки", Перечисления.ВидСравненияЗначений.Равно, СтрокаНастроек.СтатусОтгрузки, СтрокаНастроек.СтатусОтгрузки);
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ВидЗаказа", СтрокаНастроек.ВидЗаказа);
	Отбор.Вставить("СтатусОтгрузки", Перечисления.СтатусОтгрузки.Полная);
	
	ЗадачиПолнойОтгрузки = НастройкиЗадач.НайтиСтроки(Отбор);
	ЕстьЗадачиПолнойОтгрузки = ЗадачиПолнойОтгрузки.Количество() > 0;
	
	Если ЕстьЗадачиПолнойОтгрузки Тогда
		ДобавитьПараметрУсловия(ТаблицаУсловий, "СтатусОтгрузки", Перечисления.ВидСравненияЗначений.Равно, СтрокаНастроек.СтатусОтгрузки, СтрокаНастроек.СтатусОтгрузки);
	Иначе 
		ЗначенияОтгрузки = Новый Массив;
		ЗначенияОтгрузки.Добавить(Перечисления.СтатусОтгрузки.Полная);
		ЗначенияОтгрузки.Добавить(Перечисления.СтатусОтгрузки.Частичная);
		СписокЗначенийОтгрузки = Новый ФиксированныйМассив(ЗначенияОтгрузки);
		
		ДобавитьПараметрУсловия(ТаблицаУсловий, "СтатусОтгрузки", Перечисления.ВидСравненияЗначений.ВСписке, СписокЗначенийОтгрузки, СтрокаНастроек.СтатусОтгрузки);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область УправлениеФормой

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
						
			ДекорацияНадписьЗаказ = Элементы.Добавить("НадписьЗаказПокупателя_" + ИндексНастройки, Тип("ПолеФормы"), ГруппаПервойСтрокиДействия);
			ДекорацияНадписьЗаказ.ПутьКДанным = Элементы.НадписьЗаказПокупателя_0.ПутьКДанным;
			ДекорацияНадписьЗаказ.Вид = Элементы.НадписьЗаказПокупателя_0.Вид;
			ДекорацияНадписьЗаказ.Заголовок = Элементы.НадписьЗаказПокупателя_0.Заголовок;
			ДекорацияНадписьЗаказ.Ширина = Элементы.НадписьЗаказПокупателя_0.Ширина;
			ДекорацияНадписьЗаказ.Видимость = Элементы.НадписьЗаказПокупателя_0.Видимость;
			ДекорацияНадписьЗаказ.РастягиватьПоГоризонтали = Элементы.НадписьЗаказПокупателя_0.РастягиватьПоГоризонтали;
			ДекорацияНадписьЗаказ.ПоложениеЗаголовка = Элементы.НадписьЗаказПокупателя_0.ПоложениеЗаголовка;

			ПолеВидЗаказа = Элементы.Добавить("ВидЗаказа_" + ИндексНастройки, Тип("ПолеФормы"), ГруппаПервойСтрокиДействия);
			ПолеВидЗаказа.Вид = Элементы.ВидЗаказа_0.Вид;
			ПолеВидЗаказа.ПутьКДанным = "НастройкиЗадач[" + ИндексНастройки + "].ВидЗаказа";
			ПолеВидЗаказа.ПоложениеЗаголовка = Элементы.ВидЗаказа_0.ПоложениеЗаголовка;
			ПолеВидЗаказа.Заголовок = Элементы.ВидЗаказа_0.Заголовок;
			ПолеВидЗаказа.АвтоМаксимальнаяШирина = Элементы.ВидЗаказа_0.АвтоМаксимальнаяШирина;
			ПолеВидЗаказа.МаксимальнаяШирина = Элементы.ВидЗаказа_0.МаксимальнаяШирина;
			ПолеВидЗаказа.КнопкаВыбора = Элементы.ВидЗаказа_0.КнопкаВыбора;
			ПолеВидЗаказа.УстановитьДействие("ПриИзменении","ВидЗаказаПриИзменении");
			ПолеВидЗаказа.КнопкаОткрытия = Элементы.ВидЗаказа_0.КнопкаОткрытия;
			
			ПолеСтатусОтгрузки = Элементы.Добавить("СтатусОтгрузки_" + ИндексНастройки, Тип("ПолеФормы"), ГруппаПервойСтрокиДействия);
			ПолеСтатусОтгрузки.Вид = Элементы.СтатусОтгрузки_0.Вид;
			ПолеСтатусОтгрузки.ПутьКДанным = "НастройкиЗадач[" + ИндексНастройки + "].СтатусОтгрузки";
			ПолеСтатусОтгрузки.ПоложениеЗаголовка = Элементы.СтатусОтгрузки_0.ПоложениеЗаголовка;
			ПолеСтатусОтгрузки.Заголовок = Элементы.СтатусОтгрузки_0.Заголовок;
			ПолеСтатусОтгрузки.АвтоМаксимальнаяШирина = Элементы.СтатусОтгрузки_0.АвтоМаксимальнаяШирина;
			ПолеСтатусОтгрузки.МаксимальнаяШирина = Элементы.СтатусОтгрузки_0.МаксимальнаяШирина;
			ПолеСтатусОтгрузки.ОтображениеПодсказки = Элементы.СтатусОтгрузки_0.ОтображениеПодсказки;
			ПолеСтатусОтгрузки.Подсказка = Элементы.СтатусОтгрузки_0.Подсказка;
			ПолеСтатусОтгрузки.РежимВыбораИзСписка = Элементы.СтатусОтгрузки_0.РежимВыбораИзСписка;
			ПолеСтатусОтгрузки.УстановитьДействие("ПриИзменении", "СтатусОтгрузкиПриИзменении");
			ПолеСтатусОтгрузки.АвтоОтметкаНезаполненного = Элементы.СтатусОтгрузки_0.АвтоОтметкаНезаполненного;
						
			ДекорацияУдалить = Элементы.Добавить("ДекорацияУдалить_" + ИндексНастройки, Тип("ДекорацияФормы"), ОбщаяГруппаДействия);
			ДекорацияУдалить.Вид = Элементы.ДекорацияУдалить_0.Вид;
			ДекорацияУдалить.Заголовок = Элементы.ДекорацияУдалить_0.Заголовок;
			ДекорацияУдалить.Ширина = Элементы.ДекорацияУдалить_0.Ширина;
			ДекорацияУдалить.Высота = Элементы.ДекорацияУдалить_0.Высота;
			ДекорацияУдалить.Картинка = Элементы.ДекорацияУдалить_0.Картинка;
			ДекорацияУдалить.РазмерКартинки = Элементы.ДекорацияУдалить_0.РазмерКартинки;
			ДекорацияУдалить.Гиперссылка = Элементы.ДекорацияУдалить_0.Гиперссылка;
			ДекорацияУдалить.УстановитьДействие("Нажатие", "ДекорацияУдалитьНажатие");
			
			ПолеВидЗаказа.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ВидыЗаказовПокупателей");
			ПолеВидЗаказа.Видимость = ИспользоватьВидыЗаказовПокупателей;
		
			ГруппаВторойСтрокиДействия = Элементы.Добавить("ГруппаДействие_" + ИндексНастройки + "_Строка_2", Тип("ГруппаФормы"), ГруппаСтроки);
			ГруппаВторойСтрокиДействия.Вид = Элементы.ГруппаДействие_0.Вид;
			ГруппаВторойСтрокиДействия.Отображение = Элементы.ГруппаДействие_0_Строка_2.Отображение;
			ГруппаВторойСтрокиДействия.Группировка = Элементы.ГруппаДействие_0_Строка_2.Группировка;
			ГруппаВторойСтрокиДействия.ОтображатьЗаголовок = Элементы.ГруппаДействие_0_Строка_2.ОтображатьЗаголовок;

			
			ДекорацияТекстОбсуждение = Элементы.Добавить("ТекстОбсуждение_" + ИндексНастройки, Тип("ДекорацияФормы"), ГруппаВторойСтрокиДействия);
			ДекорацияТекстОбсуждение.Вид = Элементы.ТекстОбсуждение_0.Вид;
			ДекорацияТекстОбсуждение.Заголовок = Элементы.ТекстОбсуждение_0.Заголовок;
			ДекорацияТекстОбсуждение.Ширина = Элементы.ТекстОбсуждение_0.Ширина;
			
			ПолеСпособОповещения = Элементы.Добавить("СпособОповещения_" + ИндексНастройки, Тип("ПолеФормы"), ГруппаВторойСтрокиДействия);
			ПолеСпособОповещения.Вид = Элементы.СпособОповещения_0.Вид;
			ПолеСпособОповещения.ПутьКДанным = "НастройкиЗадач[" + ИндексНастройки + "].СпособОповещения";
			ПолеСпособОповещения.ПоложениеЗаголовка = Элементы.СпособОповещения_0.ПоложениеЗаголовка;
			ПолеСпособОповещения.Заголовок = Элементы.СпособОповещения_0.Заголовок;
			ПолеСпособОповещения.АвтоМаксимальнаяШирина = Элементы.СпособОповещения_0.АвтоМаксимальнаяШирина;
			ПолеСпособОповещения.МаксимальнаяШирина = Элементы.СпособОповещения_0.МаксимальнаяШирина;
			ПолеСпособОповещения.РежимВыбораИзСписка = Элементы.СпособОповещения_0.РежимВыбораИзСписка;
			ПолеСпособОповещения.КнопкаВыпадающегоСписка = Элементы.СпособОповещения_0.КнопкаВыпадающегоСписка;
			ПолеСпособОповещения.КнопкаСоздания = Элементы.СпособОповещения_0.КнопкаСоздания;
			ПолеСпособОповещения.КнопкаОткрытия = Элементы.СпособОповещения_0.КнопкаОткрытия;
			ПолеСпособОповещения.КнопкаВыбора = Элементы.СпособОповещения_0.КнопкаВыбора;
			ПолеСпособОповещения.ИсторияВыбораПриВводе = Элементы.СпособОповещения_0.ИсторияВыбораПриВводе;
			ПолеСпособОповещения.АвтоОтметкаНезаполненного = Элементы.СпособОповещения_0.АвтоОтметкаНезаполненного;
			ПолеСпособОповещения.УстановитьДействие("ПриИзменении", "СпособОповещенияПриИзменении");
			ПолеСпособОповещения.УстановитьДействие("АвтоПодбор", "СпособОповещенияАвтоПодбор");
			ПолеСпособОповещения.УстановитьДействие("НачалоВыбора", "СпособОповещенияНачалоВыбора");
			ПолеСпособОповещения.УстановитьДействие("ОбработкаВыбора", "СпособОповещенияОбработкаВыбора");

						
			Элементы.Переместить(Элементы.ДобавитьДействие, Элементы["Действие_" + ИндексНастройки]);
		КонецЕсли;
		
	КонецЦикла;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораЭлементовФормы()
	
	Для Итератор = 0 По НастройкиЗадач.Количество() - 1 Цикл
		
		Если НастройкиЗадач[Итератор].Удалена Тогда
			Продолжить;
		КонецЕсли;
		
		Элементы["СтатусОтгрузки_" + Итератор].СписокВыбора.Очистить();
		Элементы["СтатусОтгрузки_" + Итератор].СписокВыбора.Добавить(Перечисления.СтатусОтгрузки.Полная, НСтр("ru='Полностью'"));
		Элементы["СтатусОтгрузки_" + Итератор].СписокВыбора.Добавить(Перечисления.СтатусОтгрузки.Частичная, НСтр("ru='Частично'"));
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	Элементы.ДобавитьДействие.Видимость = РазрешеноИзменятьЗадачи;
	Элементы.ДействияАссистента.ТолькоПросмотр = НЕ РазрешеноИзменятьЗадачи;
	Элементы.ВРаботе.ТолькоПросмотр = НЕ РазрешеноИзменятьЗадачи;
	ЭтотОбъект.ТолькоПросмотр = НЕ РазрешеноИзменятьЗадачи;
	
	Для Каждого СтрокаНастроек Из НастройкиЗадач Цикл
		
		ИндексНастройки = НастройкиЗадач.Индекс(СтрокаНастроек);
		
		Если СтрокаНастроек.Удалена Тогда 
			Продолжить;
		КонецЕсли;
		
		ПолеВидЗаказа = Элементы["ВидЗаказа_"+ИндексНастройки];
		ПолеСпособОповещения = Элементы["СпособОповещения_"+ИндексНастройки];
		ПолеСтатусОтгрузки = Элементы["СтатусОтгрузки_"+ИндексНастройки];
		ДекорацияТекстОбсуждение = Элементы["ТекстОбсуждение_"+ИндексНастройки];
		ДекорацияУдалить = Элементы["ДекорацияУдалить_"+ИндексНастройки];
		ЭлементНадписьЗаказПокупателя = Элементы["НадписьЗаказПокупателя_"+ИндексНастройки];
		ПолеСтатусОтгрузки = Элементы["СтатусОтгрузки_"+ИндексНастройки];
		
		ПолеВидЗаказа.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ВидыЗаказовПокупателей");
		ПолеВидЗаказа.Видимость = ИспользоватьВидыЗаказовПокупателей;
		ПолеСтатусОтгрузки.Заголовок = НСтр("ru = 'будет отгружен'");
		ПолеСтатусОтгрузки.Видимость = Истина;
		
		ПолеВидЗаказа.АвтоМаксимальнаяШирина = НЕ ПолеВидЗаказа.Видимость;
		
		Если ПолеВидЗаказа.Видимость Тогда
			
			ПолеВидЗаказа.МаксимальнаяШирина = 28;
			ПолеСтатусОтгрузки.МаксимальнаяШирина = 13;
			Элементы.Переместить(ДекорацияТекстОбсуждение,Элементы["ГруппаДействие_" + ИндексНастройки + "_Строка_2"], ПолеСпособОповещения);
		Иначе
			Элементы.Переместить(ДекорацияТекстОбсуждение,Элементы["ГруппаДействие_" + ИндексНастройки + "_Строка_1"]);
		КонецЕсли;
		
		Если ТипЗнч(СтрокаНастроек.СпособОповещения) = Тип("Строка") Тогда
			ПолеСпособОповещения.ОграничениеТипа = Новый ОписаниеТипов("Строка");
		ИначеЕсли ТипЗнч(СтрокаНастроек.СпособОповещения) = Тип("СправочникСсылка.Пользователи") Тогда
			ПолеСпособОповещения.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Пользователи");
		КонецЕсли;
		
		ДекорацияУдалить.Доступность = РазрешеноИзменятьЗадачи И ИндексНастройки <> 0;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ЗадачиАссистента

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
				
		ДанныеЗадачи       = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Задача, "ТипПредмета,СпособОповещения,Используется,ПользовательДляОповещения");
		ЗначенияЗаполнения = Справочники.ЗадачиАссистентаУправления.ЗначенияЗаполнения(Задача);
		ПараметрыУсловия   = Справочники.ЗадачиАссистентаУправления.ПредставленияПараметровУсловия(Задача);
		
		СтрокаНастроек = НастройкиЗадач.Добавить();
		СтрокаНастроек.Задача             = Задача;
		СтрокаНастроек.ВидЗаказа          = ПараметрыУсловия.ВидЗаказа;
		СтрокаНастроек.Удалена            = Ложь;
		СтрокаНастроек.Модифицированность = Ложь;
		СтрокаНастроек.СтатусОтгрузки     = ПараметрыУсловия.СтатусОтгрузки;
		СтрокаНастроек.ПользовательДляОповещения = ДанныеЗадачи.ПользовательДляОповещения;
		ЗаполнитьСпособОповещенияПоЗначению(СтрокаНастроек, ДанныеЗадачи.ПользовательДляОповещения, ДанныеЗадачи.СпособОповещения);
		
		ЭтотОбъект.ВРаботе = ДанныеЗадачи.Используется;
		
	КонецЦикла;
	
	Если НастройкиЗадач.Количество() = 0 Тогда
		ДобавитьПустыеНастройкиЗадачи();
	КонецЕсли;
	
	НастройкиЗадач.Сортировать("ВидЗаказа Возр, СтатусОтгрузки Возр");
	
КонецПроцедуры

&НаСервере
Процедура УдалитьОдинаковыеДействияИзНастроек()
	
	Для Каждого СтрокаНастроек Из НастройкиЗадач Цикл
					
		ОтборПоУсловиям = Новый Структура;
		ОтборПоУсловиям.Вставить("Удалена", Ложь);
		ОтборПоУсловиям.Вставить("ВидЗаказа", СтрокаНастроек.ВидЗаказа);
		ОтборПоУсловиям.Вставить("СтатусОтгрузки", СтрокаНастроек.СтатусОтгрузки);
		ОтборПоУсловиям.Вставить("СпособОповещения", СтрокаНастроек.СпособОповещения);
		ОтборПоУсловиям.Вставить("ПользовательДляОповещения", СтрокаНастроек.ПользовательДляОповещения);
		
		ЕстьЗадачиСОдинаковымиУсловиями = НастройкиЗадач.НайтиСтроки(ОтборПоУсловиям).Количество() > 1;
		
		Если ЕстьЗадачиСОдинаковымиУсловиями Тогда
			СтрокаНастроек.Удалена = Истина;
			СтрокаНастроек.Модифицированность = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьИзменитьЗадачиАссистента()
	
	ДействиеИдентификатор = "ОповеститьОформлениеОтгрузкиОплаты";
	УдалитьОдинаковыеДействияИзНастроек();
	НастройкиЗадач.Сортировать("ВидЗаказа Возр, СтатусОтгрузки Возр");
	ТипПредмета = "ЗаказПокупателя";
	
	НачатьТранзакцию();
	
	Попытка
		ГруппаЗадач = Справочники.ЗадачиАссистентаУправления.СсылкаНаГруппуЗадач(ИдентификаторГруппы);
		
		Если НЕ ЗначениеЗаполнено(ГруппаЗадач) Тогда
			ГруппаЗадач = Справочники.ЗадачиАссистентаУправления.СоздатьГруппу();
			ГруппаЗадач.Наименование = НСтр("ru = 'Оповестить пользователя при отгрузке заказа'");
			ГруппаЗадач.ИдентификаторГруппы = ИдентификаторГруппы;
			ГруппаЗадач.Записать();
		КонецЕсли;
		
		Для каждого СтрокаНастроек Из НастройкиЗадач Цикл
			
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
			ЗадачаОбъект.События.Очистить();
			ОпределитьСобытияЗадачи(ЗадачаОбъект.События, СтрокаНастроек, "ПолнаяОтгрузкаПоступила", "ЧастичнаяОтгрузкаПоступила");
			
			ЗадачаОбъект.ТипПредмета               = ТипПредмета;
			ЗадачаОбъект.ПользовательДляОповещения = СтрокаНастроек.ПользовательДляОповещения;
			ЗадачаОбъект.Используется              = ЭтотОбъект.ВРаботе;
			ЗадачаОбъект.Родитель                  = ГруппаЗадач.Ссылка;
			
			Если ЗначениеЗаполнено(СтрокаНастроек.ПользовательДляОповещения) Тогда
				ЗадачаОбъект.СпособОповещения = Перечисления.СпособОповещенияАссистентаУправления.СообщениеКонтекстногоОбсужденияПользователю;
			Иначе
				ЗаполнитьСпособОповещенияПоПредставлению(СтрокаНастроек, ЗадачаОбъект);
			КонецЕсли;
			
			ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаПродажу;

			ЗадачаОбъект.ЗначенияЗаполнения.Очистить();
			ЗадачаОбъект.ПараметрыУсловия.Очистить();
			
			ОпределитьПараметрыУсловияОтгрузки(СтрокаНастроек, ЗадачаОбъект.ПараметрыУсловия);
			
			ДобавитьПараметрУсловия(ЗадачаОбъект.ПараметрыУсловия, "ВидЗаказа", Перечисления.ВидСравненияЗначений.Равно, СтрокаНастроек.ВидЗаказа, СтрокаНастроек.ВидЗаказа);
			ДобавитьПараметрУсловия(ЗадачаОбъект.ПараметрыУсловия, "ВидОперации", Перечисления.ВидСравненияЗначений.Равно, ВидОперации, ВидОперации);
			
			ОпределитьНаименованиеЗадачи(ЗадачаОбъект, СтрокаНастроек);
			ЗадачаОбъект.Записать();
			
			СтрокаНастроек.Модифицированность = Ложь;
			СоздатьВспомогательныеЗадачи(ЗадачаОбъект, СтрокаНастроек);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ТекстОшибки;
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьВспомогательныеЗадачи(ЗадачаОбъект, СтрокаНастроек)
	
	Наименование = "";
	СобытиеИдентификатор = "";
	ТипПредмета = "ЗаказПокупателя";
	
	// 1. При отмене отгрузки проконтролировать и предложить вернуть предыдущее состояние заказа покупателя.
	ДействиеИдентификатор = "ОповеститьОтсутствиеОтгрузкиОплаты";
	
	МассивСобытий = Новый Массив;
	МассивСобытий.Добавить("ЧастичнаяОтгрузкаОтмена");
	МассивСобытий.Добавить("ПолнаяОтгрузкаОтмена");
	
	Отбор = Справочники.ЗадачиАссистентаУправления.НовыйОтборЗадач();
	Отбор.ОсновнаяЗадача = ЗадачаОбъект.Ссылка;
	Отбор.СобытиеИдентификатор.Добавить(МассивСобытий);
	Отбор.ДействиеИдентификатор.Добавить(ДействиеИдентификатор);
	
	ОтобранныеЗадачи = Справочники.ЗадачиАссистентаУправления.ПолучитьЗадачи(Отбор);
	
	Если ОтобранныеЗадачи.Количество() = 0 Тогда
		ВспомогательнаяЗадача = Справочники.ЗадачиАссистентаУправления.СоздатьЭлемент();
	Иначе
		ВспомогательнаяЗадача = ОтобранныеЗадачи[0].ПолучитьОбъект();
	КонецЕсли;
	
	Если СтрокаНастроек.СтатусОтгрузки = Перечисления.СтатусОтгрузки.Частичная Тогда
		Наименование = НСтр("ru='Проверить свойства заказа при отмене частичной отгрузки'");
	Иначе
		Наименование = НСтр("ru='Проверить свойства заказа при отмене полной отгрузки'");
	КонецЕсли;
	
	ДанныеОсновнойЗадачи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗадачаОбъект.Ссылка, "Родитель");
	
	ВспомогательнаяЗадача.Наименование              = Наименование;
	ВспомогательнаяЗадача.ОсновнаяЗадача            = ЗадачаОбъект.Ссылка;
	ВспомогательнаяЗадача.ДействиеИдентификатор     = ДействиеИдентификатор;
	ВспомогательнаяЗадача.Используется              = ЭтотОбъект.ВРаботе;
	ВспомогательнаяЗадача.Родитель                  = ДанныеОсновнойЗадачи.Родитель;
	ВспомогательнаяЗадача.ТипПредмета               = ТипПредмета;
	ВспомогательнаяЗадача.ПользовательДляОповещения = СтрокаНастроек.ПользовательДляОповещения;
	
	Если ЗначениеЗаполнено(СтрокаНастроек.ПользовательДляОповещения) Тогда
		ВспомогательнаяЗадача.СпособОповещения = Перечисления.СпособОповещенияАссистентаУправления.СообщениеКонтекстногоОбсужденияПользователю;
	Иначе
		ЗаполнитьСпособОповещенияПоПредставлению(СтрокаНастроек, ВспомогательнаяЗадача);
	КонецЕсли;
	
	ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаПродажу;
	
	ВспомогательнаяЗадача.ЗначенияЗаполнения.Очистить();
	ВспомогательнаяЗадача.ПараметрыУсловия.Очистить();
	ВспомогательнаяЗадача.События.Очистить();
	
	ОпределитьСобытияЗадачи(ВспомогательнаяЗадача.События, СтрокаНастроек, "ПолнаяОтгрузкаОтмена", "ЧастичнаяОтгрузкаОтмена");
	
	ДобавитьПараметрЗадачи(ВспомогательнаяЗадача.ЗначенияЗаполнения, "СтатусОтгрузки", СтрокаНастроек.СтатусОтгрузки);
	ДобавитьПараметрУсловия(ВспомогательнаяЗадача.ПараметрыУсловия, "ВидЗаказа", Перечисления.ВидСравненияЗначений.Равно, СтрокаНастроек.ВидЗаказа, СтрокаНастроек.ВидЗаказа);
	ДобавитьПараметрУсловия(ВспомогательнаяЗадача.ПараметрыУсловия, "ВидОперации", Перечисления.ВидСравненияЗначений.Равно, ВидОперации, ВидОперации);

	ВспомогательнаяЗадача.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПараметрЗадачи(Таблица, Параметр, Значение)
		
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Параметр = Параметр;
	НоваяСтрока.Значение = Новый ХранилищеЗначения(Значение);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПустыеНастройкиЗадачи()
	
	НовыеНастройки = НастройкиЗадач.Добавить();
	НовыеНастройки.ВидЗаказа = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыЗаказовПокупателей.Основной");
	НовыеНастройки.СтатусОтгрузки = Перечисления.СтатусОтгрузки.Полная;
	НовыеНастройки.Модифицированность = Истина;
	
	ЗаполнитьСпособОповещенияПоЗначению(
		НовыеНастройки,
		НовыеНастройки.ПользовательДляОповещения,
		Перечисления.СпособОповещенияАссистентаУправления.СообщениеКонтекстногоОбсужденияБезОповещения);

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

&НаСервере
Процедура ДобавитьПараметрУсловия(Таблица, Параметр,ВидСравнения, Значение, ЗначениеПредставление)
		
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Параметр = Параметр;
	НоваяСтрока.Значение = Новый ХранилищеЗначения(Значение);
	НоваяСтрока.ВидСравнения = ВидСравнения;
	НоваяСтрока.ЗначениеПредставление = Новый ХранилищеЗначения(ЗначениеПредставление);
	
КонецПроцедуры

#КонецОбласти
