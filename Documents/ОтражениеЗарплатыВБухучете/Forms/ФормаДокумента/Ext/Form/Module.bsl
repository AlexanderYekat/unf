﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтражениеЗарплатыВБухучете.УстановитьУсловноеОформлениеДокументОтражениеВУчете(ЭтаФорма);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если Параметры.Свойство("ПериодРегистрацииНовогоДокумента")
			И ЗначениеЗаполнено(Параметры.ПериодРегистрацииНовогоДокумента) Тогда
			
			Объект.ПериодРегистрации = НачалоМесяца(Параметры.ПериодРегистрацииНовогоДокумента);
			
		КонецЕсли; 
		
		// создается новый документ
		ЗначенияДляЗаполнения = Новый Структура("ПредыдущийМесяц, Организация, Ответственный", 
			"Объект.ПериодРегистрации",
			"Объект.Организация",
			"Объект.Ответственный");
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	УдержанияСКонтрагентом = Новый ФиксированныйМассив(ОтражениеЗарплатыВБухучете.ВидыОперацийУдержанийТребующиеВВодаКонтрагента());
	УдержанияСДокументом = Новый ФиксированныйМассив(ОтражениеЗарплатыВБухучете.ВидыОперацийУдержанийТребующиеВводаДокументаОснования());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ОтражениеЗарплатыВБухучете.ЗаполнитьРегистрациюВНалоговомОрганеВКоллекцииСтрок(Объект.Организация, Объект.ПериодРегистрации, Объект.НачисленныйНДФЛ);
	
	ПриПолученииДанныхНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ОтражениеЗарплатыВБухучете.ЗаполнитьРегистрациюВНалоговомОрганеВКоллекцииСтрок(Объект.Организация, Объект.ПериодРегистрации, Объект.НачисленныйНДФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ОтражениеЗарплатыВБухучете", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
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

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ОтражениеЗарплатыВБухучете.УстановитьВидимостьКолонкиКПП(ЭтаФорма, Объект.Организация);
	УстановитьФункциональныеОпцииФормы();
	ЗаполнитьГоловнуюОрганизацию();
	ОтражениеЗарплатыВБухучете.УстановитьВидимостьКолонокРезервовПоОплатеТруда(ЭтаФорма, Объект.Организация, Объект.ПериодРегистрации);
	ОтражениеЗарплатыВБухучете.УстановитьУсловноеОформлениеВыплатаЗаСчетРезерва(ЭтаФорма, Объект.Организация, Объект.ПериодРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаОтраженаВБухучетеПриИзменении(Элемент)
	
	Если Объект.ЗарплатаОтраженаВБухучете Тогда
		Объект.Бухгалтер = ПользователиКлиент.ТекущийПользователь();
	Иначе
		Объект.Бухгалтер = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Модифицированность);
	ОбработатьИзменениеМесяцНачисленияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПериодРегистрацииНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеВыбрано Тогда
		ОбработатьИзменениеМесяцНачисленияНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Направление, Модифицированность);
	ПодключитьОбработчикОжидания("ОбработчикОжиданияМесяцНачисленияПриИзменении", 0.3, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияМесяцНачисленияПриИзменении()

	ОбработатьИзменениеМесяцНачисленияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеМесяцНачисленияНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	ОтражениеЗарплатыВБухучете.УстановитьВидимостьКолонокВзносов(ЭтаФорма, Объект.ПериодРегистрации);
	ОтражениеЗарплатыВБухучете.УстановитьВидимостьКолонокКодовТерриторийДокументОтражениеВУчете(ЭтаФорма, Объект.ПериодРегистрации, "НачисленныйНДФЛ");
	ОтражениеЗарплатыВБухучете.УстановитьВидимостьКолонокРезервовПоОплатеТруда(ЭтаФорма, Объект.Организация, Объект.ПериодРегистрации);
	ОтражениеЗарплатыВБухучете.УстановитьУсловноеОформлениеВыплатаЗаСчетРезерва(ЭтаФорма, Объект.Организация, Объект.ПериодРегистрации);
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисленныйНДФЛ

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыРезервПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Резерв) Тогда
		ТекущиеДанные.РезервБУ = Ложь;
		ТекущиеДанные.РезервНУ = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисленныйНДФЛ

&НаКлиенте
Процедура НачисленныйНДФЛРегистрацияВНалоговомОрганеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.НачисленныйНДФЛ.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ТекущиеДанные.РегистрацияВНалоговомОргане) Тогда
		ТекущиеДанные.КодПоОКАТО = Неопределено;
		ТекущиеДанные.КодПоОКТМО = Неопределено;
		ТекущиеДанные.КПП = Неопределено;
		ТекущиеДанные.КодНалоговогоОргана = Неопределено;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, СведенияОРегистрацииВНалоговомОргане(ТекущиеДанные.РегистрацияВНалоговомОргане), "КодПоОКАТО,КодПоОКТМО,КПП,КодНалоговогоОргана");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СведенияОРегистрацииВНалоговомОргане(РегистрацияВНалоговомОргане)
	СведенияОРегистрации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РегистрацияВНалоговомОргане, "КодПоОКАТО,КодПоОКТМО,КПП,Код");
	СведенияОРегистрации.Вставить("КодНалоговогоОргана", СведенияОРегистрации.Код);
	Возврат СведенияОРегистрации;
КонецФункции

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если НЕ ЗарплатаКадрыКлиент.ОрганизацияЗаполнена(Объект) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Объект.НачисленнаяЗарплатаИВзносы.Количество() > 0 
		Или Объект.НачисленныйНДФЛ.Количество() > 0 
		Или Объект.УдержаннаяЗарплата.Количество() > 0 
		Или Объект.ВыплатаЗаСчетРезерва.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличные части документа будут очищены. Продолжить?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьЗавершение(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#Область ВспомогательныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
	
	УстановитьФункциональныеОпцииФормы();
	ЗаполнитьГоловнуюОрганизацию();
	
	ПерсональныеДанныеНеВыгружаются = Ложь;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиЗарплата3Бухгалтерия3");
		НастройкиОбмена = Неопределено;
		ОбменИспользуется = Модуль.ОбменИспользуется(Объект.Организация, НастройкиОбмена);
		ПерсональныеДанныеНеВыгружаются = НастройкиОбмена.ПерсональныеДанныеНеВыгружаются;
	КонецЕсли;
	
	Если ОбменИспользуется Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Заполнить", "Видимость", Ложь);
		
		ПользователюРазрешеноФормированиеПроводок = ПравоДоступа("Редактирование", Метаданные.Документы.ОтражениеЗарплатыВБухучете);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗарплатаОтраженаВБухучете", "ТолькоПросмотр", Не ПользователюРазрешеноФормированиеПроводок);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Бухгалтер", "ТолькоПросмотр", Не ПользователюРазрешеноФормированиеПроводок);
		
		Если НЕ ПользователюРазрешеноФормированиеПроводок Тогда
			ТолькоПросмотр = Объект.ЗарплатаОтраженаВБухучете;
		КонецЕсли;
		
		Если ПерсональныеДанныеНеВыгружаются Тогда
			
			УстановитьУсловноеОформлениеПерсональныеДанныеНеВыгружаются();
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОтражениеЗарплатыВБухучете.УстановитьВидимостьКолонокВзносов(ЭтаФорма, Объект.ПериодРегистрации);
	ОтражениеЗарплатыВБухучете.УстановитьВидимостьКолонокКодовТерриторийДокументОтражениеВУчете(ЭтаФорма, Объект.ПериодРегистрации, "НачисленныйНДФЛ");
	ОтражениеЗарплатыВБухучете.УстановитьВидимостьКолонкиКПП(ЭтаФорма, Объект.Организация);
	ОтражениеЗарплатыВБухучете.УстановитьВидимостьКолонокРезервовПоОплатеТруда(ЭтаФорма, Объект.Организация, Объект.ПериодРегистрации);
	ОтражениеЗарплатыВБухучете.УстановитьУсловноеОформлениеВыплатаЗаСчетРезерва(ЭтаФорма, Объект.Организация, Объект.ПериодРегистрации);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеПерсональныеДанныеНеВыгружаются()
	
	СтатьиРасходовПоСпособамРасчетов = ЗарплатаКадры.СтатьиРасходовПоСпособамРасчетовСФизическимиЛицами();
	СтатьяОплатаТруда = СтатьиРасходовПоСпособамРасчетов[Перечисления.СпособыРасчетовСФизическимиЛицами.ОплатаТруда];
	
	
	// Таблица НачисленнаяЗарплатаИВзносы, поле НачисленнаяЗарплатаИВзносыСотрудник.
	ВидыОпераций = Новый Массив;
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ДоходыКонтрагентов);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВыплатыБывшимСотрудникам);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПрочиеРасчетыСПерсоналом);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПособиеНаПогребение);
	ВидыОперацийПоЗарплатеДоходыКонтрагентов = Новый ФиксированныйМассив(ВидыОпераций);
	
	ВидыОперацийИсключения = Новый СписокЗначений;
	ВидыОперацийИсключения.ЗагрузитьЗначения(ВидыОпераций);
	
	ДобавитьЭлементОформленияПерсональныеДанныеНеВыгружаются("НачисленнаяЗарплатаИВзносы", "НачисленнаяЗарплатаИВзносыСотрудник", ВидыОперацийИсключения, СтатьяОплатаТруда);
	
	// Таблица НачисленныйНДФЛ, поле НачисленныйНДФЛФизическоеЛицо.
	ВидыОпераций = Новый Массив;
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НДФЛДоходыКонтрагентов);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НДФЛРасчетыСБывшимиСотрудниками);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НДФЛПрочиеРасчетыСПерсоналом);
	ВидыОперацийПоЗарплатеНДФЛДоходыКонтрагентов = Новый ФиксированныйМассив(ВидыОпераций);
	
	ВидыОперацийИсключения = Новый СписокЗначений;
	ВидыОперацийИсключения.ЗагрузитьЗначения(ВидыОпераций);
	
	ДобавитьЭлементОформленияПерсональныеДанныеНеВыгружаются("НачисленныйНДФЛ", "НачисленныйНДФЛФизическоеЛицо", ВидыОперацийИсключения, СтатьяОплатаТруда);
	
	// Таблица УдержаннаяЗарплата, поле УдержаннаяЗарплатаСотрудник.
	ВидыОпераций = Новый Массив;
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.АлиментыПрочиеИсполнительныеЛистыКонтрагенты);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВознаграждениеПлатежногоАгентаКонтрагенты);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.УдержаниеНеизрасходованныхПодотчетныхСумм);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.УдержаниеПоПрочимОперациямСРаботниками);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВозмещениеУщерба);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НачисленоПроцентовПоЗайму);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПогашениеЗаймов);
	ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПроцентыПоЗайму);
	ВидыОперацийПоЗарплатеУдержанияКонтрагентов = Новый ФиксированныйМассив(ВидыОпераций);
	
	ВидыОперацийИсключения = Новый СписокЗначений;
	ВидыОперацийИсключения.ЗагрузитьЗначения(ВидыОпераций);
	
	ДобавитьЭлементОформленияПерсональныеДанныеНеВыгружаются("УдержаннаяЗарплата", "УдержаннаяЗарплатаСотрудник", ВидыОперацийИсключения, СтатьяОплатаТруда);
	
	Элементы.НачисленнаяЗарплатаИВзносыСотрудник.Заголовок 	= НСтр("ru = 'Контрагент'");
	Элементы.УдержаннаяЗарплатаСотрудник.Заголовок 			= НСтр("ru = 'Сотрудник/Контрагент'");
	Элементы.НачисленныйНДФЛФизическоеЛицо.Заголовок 		= НСтр("ru = 'Контрагент'");
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЭлементОформленияПерсональныеДанныеНеВыгружаются(ИмяТЧ, ИмяПоляКомпоновки, ВидыОперацийИсключения, СтатьяОплатаТруда)
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	// Вид оформления
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	// Оформляемое поле
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(ИмяПоляКомпоновки);
	
	Если ИмяТЧ = "УдержаннаяЗарплата" Тогда
		
		// Условие для оформления
		ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		ГруппаОтбораПервая = ГруппаОтбора.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбораПервая.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		
		Отбор = ГруппаОтбораПервая.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект."+ИмяТЧ+".ДокументОснование");
		Отбор.ПравоеЗначение = Истина;
		
		Отбор = ГруппаОтбораПервая.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект."+ИмяТЧ+".ЯвляетсяОснованиемОформленияКассовогоЧека");
		Отбор.ПравоеЗначение = Истина;
		
		Отбор = ГруппаОтбораПервая.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеВСписке;
		Отбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект."+ИмяТЧ+".ВидОперации");
		Отбор.ПравоеЗначение = ВидыОперацийИсключения;
		
		Отбор = ГруппаОтбораПервая.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		Отбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект."+ИмяТЧ+".СтатьяРасходов");
		Отбор.ПравоеЗначение = СтатьяОплатаТруда;
		
		ГруппаОтбораВторая = ГруппаОтбора.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбораВторая.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		
		Отбор = ГруппаОтбораВторая.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект."+ИмяТЧ+".ДокументОснование");
		Отбор.ПравоеЗначение = Истина;
		
		Отбор = ГруппаОтбораВторая.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект."+ИмяТЧ+".ЯвляетсяОснованиемОформленияКассовогоЧека");
		Отбор.ПравоеЗначение = Истина;
		
		Отбор = ГруппаОтбораВторая.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеВСписке;
		Отбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект."+ИмяТЧ+".ВидОперации");
		Отбор.ПравоеЗначение = ВидыОперацийИсключения;
		
		Отбор = ГруппаОтбораВторая.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
		Отбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект."+ИмяТЧ+".СтатьяРасходов");
		
	Иначе
		
		// Условие для оформления
		ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		ГруппаОтбораСтатья = ГруппаОтбора.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбораСтатья.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		
		Отбор = ГруппаОтбораСтатья.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект."+ИмяТЧ+".СтатьяРасходов");
		
		Отбор = ГруппаОтбораСтатья.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект."+ИмяТЧ+".СтатьяРасходов");
		Отбор.ПравоеЗначение = СтатьяОплатаТруда;
		
		ГруппаОтбораВидОперации = ГруппаОтбора.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбораВидОперации.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		
		Отбор = ГруппаОтбораВидОперации.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект."+ИмяТЧ+".СтатьяРасходов");
		
		Отбор = ГруппаОтбораВидОперации.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеВСписке;
		Отбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект."+ИмяТЧ+".ВидОперации");
		Отбор.ПравоеЗначение = ВидыОперацийИсключения;
		
	КонецЕсли;

КонецПроцедуры


&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ПараметрыФО = Новый Структура("Организация, Период", Объект.Организация, НачалоДня(Объект.ПериодРегистрации));
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	// Начисленная зарплата и взносы.
	Объект.НачисленнаяЗарплатаИВзносы.Очистить();
	Объект.НачисленныйНДФЛ.Очистить();
	Объект.УдержаннаяЗарплата.Очистить();
	Объект.ВыплатаЗаСчетРезерва.Очистить();

	// Получим структуру с отражением в бухучете зарплаты, удержаний, взносов.
	РезультатыОтраженияЗарплаты = ОтражениеЗарплатыВБухучете.ДанныеДляОтраженияЗарплатыВБухучете(Объект.Организация, Объект.ПериодРегистрации);
	РезультатыОтраженияЗарплаты.Вставить("ВыплатаЗаСчетРезерва", ОтражениеЗарплатыВБухучете.НоваяТаблицаНачисленоЗаСчетРезерва());
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОценочныеОбязательстваЗарплатаКадры") Тогда
		
		МодульРезервОтпусков = ОбщегоНазначения.ОбщийМодуль("РезервОтпусков");
		НастройкиРезервовОтпусков = МодульРезервОтпусков.НастройкиРезервовОтпусков(Объект.Организация, Объект.ПериодРегистрации);
		
		Если НастройкиРезервовОтпусков.ФормироватьРезервБУ Тогда
			
			ПараметрыДляСписанияРасходов = МодульРезервОтпусков.ПараметрыДляСписанияРасходовПоОплатеОтпуска();
			ПараметрыДляСписанияРасходов.Организация 				= Объект.Организация;
			ПараметрыДляСписанияРасходов.ПериодРегистрации 			= Объект.ПериодРегистрации;
			ПараметрыДляСписанияРасходов.НачисленнаяЗарплатаИВзносы = РезультатыОтраженияЗарплаты.НачисленнаяЗарплатаИВзносы;
			ПараметрыДляСписанияРасходов.НачисленныеОтпуска 		= РезультатыОтраженияЗарплаты.ВыплатаЗаСчетРезерва;
			ПараметрыДляСписанияРасходов.ДокументСсылка 			= Объект.Ссылка;
			МодульРезервОтпусков.СписатьРасходыПоОтпускамЗаСчетОценочныхОбязательств(ПараметрыДляСписанияРасходов);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Таблицы в данных заполнения содержат различные вспомогательные колонки.
	// Приведем структуру таблиц к структуре табличных частей документа.
	ОтражениеЗарплатыВБухучете.ПривестиРезультатыЗаполненияКСтруктуреТаблицДокумента(РезультатыОтраженияЗарплаты, Объект.Ссылка);
	
	ОтражениеЗарплатыВБухучете.СвернутьДанныеДляОтраженияЗарплатыВБухучете(РезультатыОтраженияЗарплаты, "");
	
	ОтражениеЗарплатыВБухучете.УпорядочитьДанныеДляОтраженияЗарплатыВБухучете(РезультатыОтраженияЗарплаты);
	
	// Перенесем данные в табличные части документа.
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатыОтраженияЗарплаты.НачисленнаяЗарплатаИВзносы, Объект.НачисленнаяЗарплатаИВзносы);
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатыОтраженияЗарплаты.НачисленныйНДФЛ, Объект.НачисленныйНДФЛ);
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатыОтраженияЗарплаты.УдержаннаяЗарплата, Объект.УдержаннаяЗарплата);
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатыОтраженияЗарплаты.ВыплатаЗаСчетРезерва, Объект.ВыплатаЗаСчетРезерва);
	
	ОтражениеЗарплатыВБухучете.ЗаполнитьРегистрациюВНалоговомОрганеВКоллекцииСтрок(Объект.Организация, Объект.ПериодРегистрации, Объект.НачисленныйНДФЛ);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыВидОперацииПриИзменении(Элемент)
	
	Если ПерсональныеДанныеНеВыгружаются Тогда
		ДанныеСтроки = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
		Если ДанныеСтроки <> Неопределено И ЗначениеЗаполнено(ДанныеСтроки.ФизическоеЛицо) Тогда
			ПроверитьОчиститьПолеФизическоеЛицо(ДанныеСтроки, ВидыОперацийПоЗарплатеДоходыКонтрагентов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыСтатьяРасходовПриИзменении(Элемент)
	
	Если ПерсональныеДанныеНеВыгружаются Тогда
		ДанныеСтроки = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
		Если ДанныеСтроки <> Неопределено И ЗначениеЗаполнено(ДанныеСтроки.ФизическоеЛицо) Тогда
			ПроверитьОчиститьПолеФизическоеЛицо(ДанныеСтроки, ВидыОперацийПоЗарплатеДоходыКонтрагентов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленныйНДФЛВидОперацииПриИзменении(Элемент)
	
	Если ПерсональныеДанныеНеВыгружаются Тогда
		ДанныеСтроки = Элементы.НачисленныйНДФЛ.ТекущиеДанные;
		Если ДанныеСтроки <> Неопределено И ЗначениеЗаполнено(ДанныеСтроки.ФизическоеЛицо) Тогда
			ПроверитьОчиститьПолеФизическоеЛицо(ДанныеСтроки, ВидыОперацийПоЗарплатеНДФЛДоходыКонтрагентов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленныйНДФЛСтатьяРасходовПриИзменении(Элемент)
	
	Если ПерсональныеДанныеНеВыгружаются Тогда
		ДанныеСтроки = Элементы.НачисленныйНДФЛ.ТекущиеДанные;
		Если ДанныеСтроки <> Неопределено И ЗначениеЗаполнено(ДанныеСтроки.ФизическоеЛицо) Тогда
			ПроверитьОчиститьПолеФизическоеЛицо(ДанныеСтроки, ВидыОперацийПоЗарплатеНДФЛДоходыКонтрагентов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдержаннаяЗарплатаВидОперацииПриИзменении(Элемент)
		
	ДанныеСтроки = Элементы.УдержаннаяЗарплата.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если УдержанияСКонтрагентом.Найти(ДанныеСтроки.ВидОперации) = Неопределено И ЗначениеЗаполнено(ДанныеСтроки.Контрагент) Тогда
		ДанныеСтроки.Контрагент = "";
	КонецЕсли;
	
	Если УдержанияСДокументом.Найти(ДанныеСтроки.ВидОперации) = Неопределено И ЗначениеЗаполнено(ДанныеСтроки.ДокументОснование) Тогда
		ДанныеСтроки.ДокументОснование = "";
	КонецЕсли;
	
	Если ДанныеСтроки.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.НачисленоПроцентовПоЗайму")
				И ЗначениеЗаполнено(ДанныеСтроки.СтатьяРасходов) Тогда
		ДанныеСтроки.СтатьяРасходов = "";
	КонецЕсли;
	
	Если ПерсональныеДанныеНеВыгружаются И ЗначениеЗаполнено(ДанныеСтроки.ФизическоеЛицо) Тогда
		ПроверитьОчиститьПолеФизическоеЛицоУдержаний(ДанныеСтроки, ВидыОперацийПоЗарплатеУдержанияКонтрагентов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдержаннаяЗарплатаСтатьяРасходовПриИзменении(Элемент)
	
	Если ПерсональныеДанныеНеВыгружаются Тогда
		ДанныеСтроки = Элементы.УдержаннаяЗарплата.ТекущиеДанные;
		Если ДанныеСтроки <> Неопределено И ЗначениеЗаполнено(ДанныеСтроки.ФизическоеЛицо) Тогда
			ПроверитьОчиститьПолеФизическоеЛицоУдержаний(ДанныеСтроки, ВидыОперацийПоЗарплатеУдержанияКонтрагентов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдержаннаяЗарплатаЯвляетсяОснованиемОформленияКассовогоЧекаПриИзменении(Элемент)
	
	ДанныеСтроки = Элементы.УдержаннаяЗарплата.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеСтроки.ОписаниеУдержанияДляЧека) И Не ДанныеСтроки.ЯвляетсяОснованиемОформленияКассовогоЧека Тогда
		ДанныеСтроки.ОписаниеУдержанияДляЧека = "";
	КонецЕсли;
	
	Если ПерсональныеДанныеНеВыгружаются Тогда
		Если ЗначениеЗаполнено(ДанныеСтроки.ФизическоеЛицо) Тогда
			ПроверитьОчиститьПолеФизическоеЛицоУдержаний(ДанныеСтроки, ВидыОперацийПоЗарплатеУдержанияКонтрагентов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

&НаСервере
Процедура ЗаполнитьГоловнуюОрганизацию()
	
	ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Объект.Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьОчиститьПолеФизическоеЛицо(ДанныеСтроки, ВидыОперацийИсключения)
	
	Если (ЗначениеЗаполнено(ДанныеСтроки.СтатьяРасходов) И ДанныеСтроки.СтатьяРасходов = СтатьяОплатаТруда
		Или Не ЗначениеЗаполнено(ДанныеСтроки.СтатьяРасходов) И ВидыОперацийИсключения.Найти(ДанныеСтроки.ВидОперации) = Неопределено) Тогда
		ДанныеСтроки.ФизическоеЛицо = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьОчиститьПолеФизическоеЛицоУдержаний(ДанныеСтроки, ВидыОперацийИсключения)
	
	Если ВидыОперацийИсключения.Найти(ДанныеСтроки.ВидОперации) <> Неопределено
					Или ДанныеСтроки.ЯвляетсяОснованиемОформленияКассовогоЧека
					Или ЗначениеЗаполнено(ДанныеСтроки.ДокументОснование) Тогда
		// не очищаем поле
	ИначеЕсли Не ЗначениеЗаполнено(ДанныеСтроки.СтатьяРасходов) Или ДанныеСтроки.СтатьяРасходов = СтатьяОплатаТруда Тогда
		ДанныеСтроки.ФизическоеЛицо = "";
	КонецЕсли;	
	
КонецПроцедуры



#КонецОбласти
