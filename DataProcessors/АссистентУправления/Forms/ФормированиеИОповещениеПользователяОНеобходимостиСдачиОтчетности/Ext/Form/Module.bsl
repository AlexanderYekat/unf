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
	
	ЗаполнитьСпособыОповещения();
	
	//ЗадачиАссистента
	ИдентификаторЗадач = "ФормированиеИОповещениеПользователяОНеобходимостиСдачиОтчетности";
	
	РазрешеноИзменятьЗадачи = Обработки.АссистентУправления.РазрешеноИзменятьЗадачи();
	
	Элементы.ДобавитьДействие.Видимость = РазрешеноИзменятьЗадачи;
	Элементы.ДействияАссистента.ТолькоПросмотр = НЕ РазрешеноИзменятьЗадачи;
	Элементы.ВРаботе.ТолькоПросмотр = НЕ РазрешеноИзменятьЗадачи;
	Элементы.ГруппаДопФункция_0.Видимость = РазрешеноИзменятьЗадачи;
	ЭтотОбъект.ТолькоПросмотр = НЕ РазрешеноИзменятьЗадачи;
	
	ОбновитьБлокиНастроекАссистента();
	ОбновитьЭлементыДействийИЗаполнитьСписокВыбора();
	
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
	
	Если НЕ ЗадачиЗаполненыКорректно() Тогда
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

		Если НЕ ЗначениеЗаполнено(СтрокаНастроек.СпособОповещения) Тогда
			ЕстьОшибки = Истина;
		КонецЕсли;
				
		Если Не ЗначениеЗаполнено(СтрокаНастроек.Налог) Тогда
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
Процедура СпособОповещенияПриИзменении(Элемент)

	СтрокаНастроек = НастройкиЗадач.Получить(ИндексБлока(Элемент.Имя));
	СтрокаНастроек.Модифицированность = Истина;
	УправлениеФормой();

КонецПроцедуры

&НаКлиенте
Процедура СпособОповещенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Индекс = ИндексБлока(Элемент.Имя);
	ЗаполнитьДанныеВыбора(ДанныеВыбора, Индекс);
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
	Индекс = Прав(Элемент.Имя, СтрДлина(Элемент.Имя) - СтрНайти(Элемент.Имя, "_"));
	ЗаполнитьДанныеВыбора(ДанныеВыбора, Индекс);
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
Процедура ОповещатьСНачалаСобытияПриИзменении(Элемент)
	
	Индекс = ИндексБлока(Элемент.Имя);
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
	СтрокаНастроек.Модифицированность = Истина;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПочтаПриИзменении(Элемент)
	Индекс = ИндексБлока(Элемент.Имя);
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
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
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура НалогПриИзменении(Элемент)
	Индекс = ИндексБлока(Элемент.Имя);
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
	СтрокаНастроек.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КоличествоДнейПриИзменении(Элемент)
	Индекс = ИндексБлока(Элемент.Имя);
	СтрокаНастроек = НастройкиЗадач.Получить(Индекс);
	СтрокаНастроек.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТекстОшибкиОбсуждениеНажатие(Элемент)
	НачатьПодключениеОбсуждений();
КонецПроцедуры

&НаКлиенте
Процедура ТекстОшибкиПочтаНажатие(Элемент)
	ПоказатьЗначение(Новый ОписаниеОповещения("ЗавершитьПодключениеПочты", ЭтотОбъект),ПредопределенноеЗначение("Справочник.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты"));
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
	
	ДобавитьПустыеНастройкиЗадачи();
	ОбновитьЭлементыДействийАссистента();
	ЗаполнитьСписокВыбораЭлементовФормы();
	
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
Процедура ЗавершитьПодключениеПочты(Результат, ДополнительныеПараметры) Экспорт
	
	УправлениеФормой();

КонецПроцедуры

&НаКлиенте
Процедура УстановитьМодифицированностьЗадач()
	
	Для Каждого СтрокаНастроек Из НастройкиЗадач Цикл
		СтрокаНастроек.Модифицированность = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпособыОповещения()
	
	СпособыОповещения.Очистить();
	
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

#КонецОбласти

#Область УправлениеФормой

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
			
			ПолеСпособОповещения = Элементы.Добавить("СпособОповещения_" + ИндексНастройки, Тип("ПолеФормы"), ГруппаПервойСтрокиДействия);
			ПолеСпособОповещения.Вид = Элементы.СпособОповещения_0.Вид;
			ПолеСпособОповещения.ПутьКДанным = "НастройкиЗадач[" + ИндексНастройки + "].СпособОповещения";
			ПолеСпособОповещения.ПоложениеЗаголовка = Элементы.СпособОповещения_0.ПоложениеЗаголовка;
			ПолеСпособОповещения.Заголовок = Элементы.СпособОповещения_0.Заголовок;
			ПолеСпособОповещения.АвтоМаксимальнаяШирина = Элементы.СпособОповещения_0.АвтоМаксимальнаяШирина;
			ПолеСпособОповещения.МаксимальнаяШирина = Элементы.СпособОповещения_0.МаксимальнаяШирина;
			ПолеСпособОповещения.РежимВыбораИзСписка = Элементы.СпособОповещения_0.РежимВыбораИзСписка;
			ПолеСпособОповещения.КнопкаВыпадающегоСписка = Элементы.СпособОповещения_0.КнопкаВыпадающегоСписка;
			ПолеСпособОповещения.АвтоОтметкаНезаполненного = Элементы.СпособОповещения_0.АвтоОтметкаНезаполненного;
			ПолеСпособОповещения.ИсторияВыбораПриВводе = Элементы.СпособОповещения_0.ИсторияВыбораПриВводе;
			ПолеСпособОповещения.КнопкаСоздания = Элементы.СпособОповещения_0.КнопкаСоздания;
			ПолеСпособОповещения.КнопкаОткрытия = Элементы.СпособОповещения_0.КнопкаОткрытия;
			ПолеСпособОповещения.КнопкаВыбора = Элементы.СпособОповещения_0.КнопкаВыбора;
			ПолеСпособОповещения.УстановитьДействие("ПриИзменении", "СпособОповещенияПриИзменении");
			ПолеСпособОповещения.УстановитьДействие("АвтоПодбор", "СпособОповещенияАвтоПодбор");
			ПолеСпособОповещения.УстановитьДействие("НачалоВыбора", "СпособОповещенияНачалоВыбора");
			ПолеСпособОповещения.УстановитьДействие("ОбработкаВыбора", "СпособОповещенияОбработкаВыбора");
			
			ПолеОповещатьСНачалаСобытия = Элементы.Добавить("ОповещатьСНачалаСобытия_" + ИндексНастройки, Тип("ПолеФормы"), ГруппаПервойСтрокиДействия);
			ПолеОповещатьСНачалаСобытия.Вид = Элементы.ОповещатьСНачалаСобытия_0.Вид;
			ПолеОповещатьСНачалаСобытия.ПутьКДанным = "НастройкиЗадач[" + ИндексНастройки + "].ОповещатьСНачалаСобытия";
			ПолеОповещатьСНачалаСобытия.ПоложениеЗаголовка = Элементы.ОповещатьСНачалаСобытия_0.ПоложениеЗаголовка;
			ПолеОповещатьСНачалаСобытия.Заголовок = Элементы.ОповещатьСНачалаСобытия_0.Заголовок;
			ПолеОповещатьСНачалаСобытия.ФорматРедактирования = Элементы.ОповещатьСНачалаСобытия_0.ФорматРедактирования;
			ПолеОповещатьСНачалаСобытия.АвтоМаксимальнаяШирина = Элементы.ОповещатьСНачалаСобытия_0.АвтоМаксимальнаяШирина;
			ПолеОповещатьСНачалаСобытия.МаксимальнаяШирина = Элементы.ОповещатьСНачалаСобытия_0.МаксимальнаяШирина;
			ПолеОповещатьСНачалаСобытия.Ширина = Элементы.ОповещатьСНачалаСобытия_0.Ширина;
			ПолеОповещатьСНачалаСобытия.РежимВыбораИзСписка = Элементы.ОповещатьСНачалаСобытия_0.РежимВыбораИзСписка;
			ПолеОповещатьСНачалаСобытия.КнопкаВыпадающегоСписка = Элементы.ОповещатьСНачалаСобытия_0.КнопкаВыпадающегоСписка;
			ПолеОповещатьСНачалаСобытия.АвтоОтметкаНезаполненного = Элементы.ОповещатьСНачалаСобытия_0.АвтоОтметкаНезаполненного;
			ПолеОповещатьСНачалаСобытия.ИсторияВыбораПриВводе = Элементы.ОповещатьСНачалаСобытия_0.ИсторияВыбораПриВводе;
			ПолеОповещатьСНачалаСобытия.КнопкаСоздания = Элементы.ОповещатьСНачалаСобытия_0.КнопкаСоздания;
			ПолеОповещатьСНачалаСобытия.КнопкаОткрытия = Элементы.ОповещатьСНачалаСобытия_0.КнопкаОткрытия;
			ПолеОповещатьСНачалаСобытия.КнопкаВыбора = Элементы.ОповещатьСНачалаСобытия_0.КнопкаВыбора;
			ПолеОповещатьСНачалаСобытия.РежимРедактирования = Элементы.ОповещатьСНачалаСобытия_0.РежимРедактирования;
			ПолеОповещатьСНачалаСобытия.УстановитьДействие("ПриИзменении", "ОповещатьСНачалаСобытияПриИзменении");
			
			ПолеКоличествоДней = Элементы.Добавить("КоличествоДней_" + ИндексНастройки, Тип("ПолеФормы"), ГруппаПервойСтрокиДействия);
			ПолеКоличествоДней.Вид = Элементы.КоличествоДней_0.Вид;
			ПолеКоличествоДней.ПутьКДанным = "НастройкиЗадач[" + ИндексНастройки + "].КоличествоДней";
			ПолеКоличествоДней.ПоложениеЗаголовка = Элементы.КоличествоДней_0.ПоложениеЗаголовка;
			ПолеКоличествоДней.Заголовок = Элементы.КоличествоДней_0.Заголовок;
			ПолеКоличествоДней.ПоложениеЗаголовка = Элементы.КоличествоДней_0.ПоложениеЗаголовка;
			ПолеКоличествоДней.АвтоМаксимальнаяШирина = Элементы.КоличествоДней_0.АвтоМаксимальнаяШирина;
			ПолеКоличествоДней.МаксимальнаяШирина = Элементы.КоличествоДней_0.МаксимальнаяШирина;
			ПолеКоличествоДней.РежимВыбораИзСписка = Элементы.КоличествоДней_0.РежимВыбораИзСписка;
			ПолеКоличествоДней.КнопкаВыпадающегоСписка = Элементы.КоличествоДней_0.КнопкаВыпадающегоСписка;
			ПолеКоличествоДней.АвтоОтметкаНезаполненного = Элементы.КоличествоДней_0.АвтоОтметкаНезаполненного;
			ПолеКоличествоДней.ИсторияВыбораПриВводе = Элементы.КоличествоДней_0.ИсторияВыбораПриВводе;
			ПолеКоличествоДней.УстановитьДействие("ПриИзменении", "КоличествоДнейПриИзменении");
			
			ДекорацияНадпись = Элементы.Добавить("НадписьТекстОповещения_" + ИндексНастройки, Тип("ДекорацияФормы"), ГруппаПервойСтрокиДействия);
			ДекорацияНадпись.Вид = Элементы.ТекстОбсуждение_0.Вид;
			ДекорацияНадпись.Заголовок = Элементы.НадписьТекстОповещения_0.Заголовок;
			ДекорацияНадпись.Ширина = Элементы.НадписьТекстОповещения_0.Ширина;
			ДекорацияНадпись.Видимость = Элементы.НадписьТекстОповещения_0.Видимость;
			ДекорацияНадпись.РастягиватьПоГоризонтали = Элементы.НадписьТекстОповещения_0.РастягиватьПоГоризонтали;
			
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
			ГруппаВторойСтрокиДействия.СквозноеВыравнивание = Элементы.ГруппаДействие_0_Строка_2.СквозноеВыравнивание;
			ГруппаВторойСтрокиДействия.Группировка = Элементы.ГруппаДействие_0_Строка_2.Группировка;
			ГруппаВторойСтрокиДействия.ОтображатьЗаголовок = Элементы.ГруппаДействие_0_Строка_2.ОтображатьЗаголовок;
			
			ПолеНалог = Элементы.Добавить("Налог_" + ИндексНастройки, Тип("ПолеФормы"), ГруппаВторойСтрокиДействия);
			ПолеНалог.Вид = Элементы.Налог_0.Вид;
			ПолеНалог.ПутьКДанным = "НастройкиЗадач[" + ИндексНастройки + "].Налог";
			ПолеНалог.ПоложениеЗаголовка = Элементы.Налог_0.ПоложениеЗаголовка;
			ПолеНалог.Заголовок = Элементы.Налог_0.Заголовок;
			ПолеНалог.АвтоМаксимальнаяШирина = Элементы.Налог_0.АвтоМаксимальнаяШирина;
			ПолеНалог.МаксимальнаяШирина = Элементы.Налог_0.МаксимальнаяШирина;
			ПолеНалог.РежимВыбораИзСписка = Элементы.Налог_0.РежимВыбораИзСписка;
			ПолеНалог.КнопкаВыпадающегоСписка = Элементы.Налог_0.КнопкаВыпадающегоСписка;
			ПолеНалог.АвтоОтметкаНезаполненного = Элементы.Налог_0.АвтоОтметкаНезаполненного;
			ПолеНалог.ИсторияВыбораПриВводе = Элементы.Налог_0.ИсторияВыбораПриВводе;
			ПолеНалог.КнопкаСоздания = Элементы.Налог_0.КнопкаСоздания;
			ПолеНалог.КнопкаОткрытия = Элементы.Налог_0.КнопкаОткрытия;
			ПолеНалог.КнопкаВыбора = Элементы.Налог_0.КнопкаВыбора;
			ПолеНалог.УстановитьДействие("ПриИзменении", "НалогПриИзменении");
			
			ДекорацияТекстОбсуждение = Элементы.Добавить("ТекстОбсуждение_" + ИндексНастройки, Тип("ДекорацияФормы"), ГруппаВторойСтрокиДействия);
			ДекорацияТекстОбсуждение.Вид = Элементы.ТекстОбсуждение_0.Вид;
			ДекорацияТекстОбсуждение.Заголовок = Элементы.ТекстОбсуждение_0.Заголовок;
			ДекорацияТекстОбсуждение.Ширина = Элементы.ТекстОбсуждение_0.Ширина;
			
			ПолеПочта = Элементы.Добавить("Почта_" + ИндексНастройки, Тип("ПолеФормы"), ГруппаВторойСтрокиДействия);
			ПолеПочта.Вид = Элементы.Почта_0.Вид;
			ПолеПочта.ПутьКДанным = "НастройкиЗадач[" + ИндексНастройки + "].ПочтаДляОповещения";
			ПолеПочта.ПоложениеЗаголовка = Элементы.Почта_0.ПоложениеЗаголовка;
			ПолеПочта.Заголовок = Элементы.Почта_0.Заголовок;
			ПолеПочта.АвтоМаксимальнаяШирина = Элементы.Почта_0.АвтоМаксимальнаяШирина;
			ПолеПочта.МаксимальнаяШирина = Элементы.Почта_0.МаксимальнаяШирина;
			ПолеПочта.РежимВыбораИзСписка = Элементы.Почта_0.РежимВыбораИзСписка;
			ПолеПочта.КнопкаВыпадающегоСписка = Элементы.Почта_0.КнопкаВыпадающегоСписка;
			ПолеПочта.АвтоОтметкаНезаполненного = Элементы.Почта_0.АвтоОтметкаНезаполненного;
			ПолеПочта.ИсторияВыбораПриВводе = Элементы.Почта_0.ИсторияВыбораПриВводе;
			ПолеПочта.КнопкаСоздания = Элементы.Почта_0.КнопкаСоздания;
			ПолеПочта.КнопкаОткрытия = Элементы.Почта_0.КнопкаОткрытия;
			ПолеПочта.КнопкаВыбора = Элементы.Почта_0.КнопкаВыбора;
			ПолеПочта.УстановитьДействие("ПриИзменении", "ПочтаПриИзменении");
			
			Элементы.Переместить(Элементы.ДобавитьДействие, Элементы["Действие_" + ИндексНастройки]);
			
		КонецЕсли;
		
	КонецЦикла;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	ИнформационнаяБазаЗарегистрирована = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	
	ЕстьОшибкиПодключенияБазы = НЕ ИнформационнаяБазаЗарегистрирована;
	Элементы.ПанельОшибки.Видимость = (ЕстьОшибкиПодключенияБазы) И ВРаботе;
	
	Элементы.ОшибкаНеПодключеныОбсуждения.Видимость = ЕстьОшибкиПодключенияБазы И ВРаботе;
	ВРаботе = НЕ ЕстьОшибкиПодключенияБазы И ЭтотОбъект.ВРаботе;
	
	Для Каждого СтрокаНастроек Из НастройкиЗадач Цикл
		
		ИндексНастройки = НастройкиЗадач.Индекс(СтрокаНастроек);
		Если СтрокаНастроек.Удалена Тогда 
			Продолжить;
		КонецЕсли;
		
		Если СтрокаНастроек.ОповещатьСНачалаСобытия Тогда
			Элементы["НадписьТекстОповещения_"+ИндексНастройки].Заголовок = НСтр("ru = 'дней после начала периода сдачи'");
		Иначе
			Элементы["НадписьТекстОповещения_"+ИндексНастройки].Заголовок = НСтр("ru = 'дней до окончания срока сдачи'");
		КонецЕсли;
		
	КонецЦикла;
		
	Если НЕ ЭтотОбъект.ВРаботе Тогда
		Возврат;
	КонецЕсли;
	
	НезаполненныеУчетныеЗаписи = НастройкиЗадач.НайтиСтроки(Новый Структура("ПочтаДляОповещения",""));
	Если НастройкиЗадач.Количество() = НезаполненныеУчетныеЗаписи.Количество() Тогда
		Возврат;
	КонецЕсли;

	УчетнаяЗаписьНастроена = РаботаСПочтовымиСообщениями.УчетнаяЗаписьНастроена(Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты, Истина);
	
	Если НЕ УчетнаяЗаписьНастроена Тогда
		Элементы.ПанельОшибки.Видимость            = Истина;
		Элементы.ОшибкаНеПодключенаПочта.Видимость = Истина;
		ВРаботе = Ложь;
		Возврат;
	КонецЕсли;
	
	СообщениеОбОшибке = "";
	ДополнительноеСообщение = "";
	РаботаСПочтовымиСообщениями.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты, 
	СообщениеОбОшибке, 
	ДополнительноеСообщение);
	
	Элементы.ОшибкаНеПодключенаПочта.Видимость = ЗначениеЗаполнено(СообщениеОбОшибке);
	Элементы.ПанельОшибки.Видимость            = Элементы.ОшибкаНеПодключенаПочта.Видимость;
	ВРаботе                                    = НЕ Элементы.ПанельОшибки.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСостояниеПослеВыбора(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено ИЛИ ДополнительныеПараметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаНастроек = НастройкиЗадач.Получить(ДополнительныеПараметры.Индекс);
	СтрокаНастроек.СостояниеЗаказа = ВыбранноеЗначение;
	СтрокаНастроек.Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ЗадачиАссистента

&НаСервере
Процедура УдалитьОдинаковыеДействияИзНастроек()
	
	Для Каждого СтрокаНастроек Из НастройкиЗадач Цикл
			
		ОтборПоУсловиям = Новый Структура;
		ОтборПоУсловиям.Вставить("Удалена", Ложь);
		ОтборПоУсловиям.Вставить("Налог", СтрокаНастроек.Налог);
		ОтборПоУсловиям.Вставить("УчетнаяЗапись",             СтрокаНастроек.УчетнаяЗапись);
		ОтборПоУсловиям.Вставить("СпособОповещения",          СтрокаНастроек.СпособОповещения);
		ОтборПоУсловиям.Вставить("ПользовательДляОповещения", СтрокаНастроек.ПользовательДляОповещения);
		ОтборПоУсловиям.Вставить("ОповещатьСНачалаСобытия",   СтрокаНастроек.ОповещатьСНачалаСобытия);
		ОтборПоУсловиям.Вставить("КоличествоДней",            СтрокаНастроек.КоличествоДней);

		ЕстьЗадачиСОдинаковымиУсловиями = НастройкиЗадач.НайтиСтроки(ОтборПоУсловиям).Количество() > 1;
		
		Если ЕстьЗадачиСОдинаковымиУсловиями Тогда
			СтрокаНастроек.Удалена = Истина;
			СтрокаНастроек.Модифицированность = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ЗадачиПоИдентификатору()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗадачиАссистентаПоРасчетуНалогов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЗадачиАссистентаПоРасчетуНалогов КАК ЗадачиАссистентаПоРасчетуНалогов
	|ГДЕ
	|	ЗадачиАссистентаПоРасчетуНалогов.Идентификатор = &Идентификатор";
	Запрос.УстановитьПараметр("Идентификатор", ИдентификаторЗадач);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаСервере
Процедура ОбновитьБлокиНастроекАссистента()
	
	СписокЗадач = ЗадачиПоИдентификатору();
	
	Если СписокЗадач.Количество() = 0 Тогда
		ДобавитьПустыеНастройкиЗадачи();
		Возврат;
	КонецЕсли;
	
	НастройкиЗадач.Очистить();
	
	Для каждого Задача Из СписокЗадач Цикл
		
		ДанныеЗадачи = Задача.ПолучитьОбъект();
		
		СтрокаНастроек = НастройкиЗадач.Добавить();
		СтрокаНастроек.Задача             = Задача;
		СтрокаНастроек.ОповещатьСНачалаСобытия    = ДанныеЗадачи.ОповещатьСНачалаСобытия;
		СтрокаНастроек.КоличествоДней      = ДанныеЗадачи.КоличествоДней;
		СтрокаНастроек.Налог      = ДанныеЗадачи.Налог;
		СтрокаНастроек.ПочтаДляОповещения      = ДанныеЗадачи.ПочтаДляОповещения;
		СтрокаНастроек.Удалена            = Ложь;
		СтрокаНастроек.Модифицированность = Ложь;
		СтрокаНастроек.ПользовательДляОповещения = ДанныеЗадачи.ПользовательДляОповещения;
		ЗаполнитьСпособОповещенияПоЗначению(
			СтрокаНастроек,
			СтрокаНастроек.ПользовательДляОповещения,
			ДанныеЗадачи.СпособОповещения);
				ЭтотОбъект.ВРаботе = ДанныеЗадачи.Используется;
		
	КонецЦикла;
	
	Если НастройкиЗадач.Количество() = 0 Тогда
		ДобавитьПустыеНастройкиЗадачи();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПустыеНастройкиЗадачи()
	
	
	ОбщиеНастройки = Новый Структура;
	ОбщиеНастройки.Вставить("Модифицированность", Истина);
	ОбщиеНастройки.Вставить("ОповещатьСНачалаСобытия", Истина);
	
	ОбщиеНастройки.Вставить("КоличествоДней", 1);
	ОбщиеНастройки.Вставить("Налог",   ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ЗадачиКалендаряПодготовкиОтчетности.АвансовыйПлатежПоУСН"));
	
	// 1.
	НоваяНастройка = НастройкиЗадач.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяНастройка, ОбщиеНастройки);
	Элементы.НадписьТекстОповещения_0.Заголовок = НСтр("ru = 'дней после начала периода сдачи");
	НоваяНастройка.Модифицированность = Истина;
	
	ЗаполнитьСпособОповещенияПоЗначению(
		НоваяНастройка,
		НоваяНастройка.ПользовательДляОповещения,
		Перечисления.СпособОповещенияАссистентаУправления.СообщениеКонтекстногоОбсужденияБезОповещения);
	
КонецПроцедуры

&НаКлиенте
Функция ЗадачиЗаполненыКорректно()
	
	ЕстьОшибкиУсловий = Ложь;

	Для каждого СтрокаНастроек Из НастройкиЗадач Цикл
		
		ОтборУсловия = Новый Структура;
		ОтборУсловия.Вставить("Удалена",Ложь);
		ОтборУсловия.Вставить("СпособОповещения",          СтрокаНастроек.СпособОповещения);
		ОтборУсловия.Вставить("ПользовательДляОповещения", СтрокаНастроек.ПользовательДляОповещения);
		ОтборУсловия.Вставить("Налог",                     СтрокаНастроек.Налог);
		ОтборУсловия.Вставить("ОповещатьСНачалаСобытия",   СтрокаНастроек.ОповещатьСНачалаСобытия);
		ОтборУсловия.Вставить("КоличествоДней",            СтрокаНастроек.КоличествоДней);
		
		ЗадачиСОдинаковымиУсловиями = НастройкиЗадач.НайтиСтроки(ОтборУсловия);
		
		Если ЗадачиСОдинаковымиУсловиями.Количество() > 1 Тогда
			
			ЕстьОшибкиУсловий = Истина;
			ОбщегоНазначенияКлиент.СообщитьПользователю(
					НСтр("ru = 'Настроено несколько действий с одинаковыми условиями'"));
					
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НЕ ЕстьОшибкиУсловий;
	
КонецФункции

&НаСервере
Процедура СоздатьИзменитьЗадачиАссистента()
	
	УдалитьОдинаковыеДействияИзНастроек();
	
	НачатьТранзакцию();
	
	Попытка
		
		Для каждого СтрокаНастроек Из НастройкиЗадач Цикл
			
			ЗадачаИзменена = СтрокаНастроек.Модифицированность;
			
			Если НЕ ЗадачаИзменена Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаНастроек.Задача) Тогда
				ЗадачаОбъект = СтрокаНастроек.Задача.ПолучитьОбъект();
			Иначе
				ЗадачаОбъект = Справочники.ЗадачиАссистентаПоРасчетуНалогов.СоздатьЭлемент();
				
				АвторИзменений = Пользователи.АвторизованныйПользователь();
				ЕстьЗадачиПользователя = АссистентУправления.ЕстьЗадачиПользователя(АвторИзменений);
			КонецЕсли;
			
			Если СтрокаНастроек.Удалена И ЗначениеЗаполнено(ЗадачаОбъект.Ссылка) Тогда
				ЗадачаОбъект.Удалить();
			КонецЕсли;
			
			Если СтрокаНастроек.Удалена Тогда
				СтрокаНастроек.Модифицированность = Ложь;
				Продолжить;
			КонецЕсли;
			
			ЗадачаОбъект.Наименование = НСтр("ru = 'Оповещение клиента о необходимости сдачи отчетности'");
			ЗадачаОбъект.Идентификатор = ИдентификаторЗадач;
			Если ЗначениеЗаполнено(СтрокаНастроек.ПользовательДляОповещения) Тогда
				ЗадачаОбъект.СпособОповещения = Перечисления.СпособОповещенияАссистентаУправления.СообщениеКонтекстногоОбсужденияПользователю;
			Иначе
				ЗаполнитьСпособОповещенияПоПредставлению(СтрокаНастроек, ЗадачаОбъект);
			КонецЕсли;
			ЗадачаОбъект.Используется     = ЭтотОбъект.ВРаботе;
			ЗадачаОбъект.ПользовательДляОповещения = СтрокаНастроек.ПользовательДляОповещения;
			ЗадачаОбъект.ОповещатьСНачалаСобытия = СтрокаНастроек.ОповещатьСНачалаСобытия;
			ЗадачаОбъект.КоличествоДней = СтрокаНастроек.КоличествоДней;
			ЗадачаОбъект.Налог = СтрокаНастроек.Налог;
			ЗадачаОбъект.ПочтаДляОповещения = СтрокаНастроек.ПочтаДляОповещения;
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
Процедура ЗаполнитьСписокВыбораЭлементовФормы()
	
	Для Итератор = 1 По НастройкиЗадач.Количество() - 1 Цикл
		
		Если НастройкиЗадач[Итератор].Удалена Тогда
			Продолжить;
		КонецЕсли;
		
		Элементы["Налог_" + Итератор].СписокВыбора.Очистить();
		Для Каждого ЭлементСписка Из Элементы.Налог_0.СписокВыбора Цикл
			Элементы["Налог_" + Итератор].СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуЗадач()
	
	Результат = Новый Структура();
	
	Результат.Вставить("ИзмененПризнакВРаботе", ИзмененПризнакВРаботе);
	Результат.Вставить("АвторИзменений", АвторИзменений);
	Результат.Вставить("ГруппаЗадач", ИдентификаторЗадач);
	Результат.Вставить("НужноДобавитьВОбсуждение", НЕ ЕстьЗадачиПользователя);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти
