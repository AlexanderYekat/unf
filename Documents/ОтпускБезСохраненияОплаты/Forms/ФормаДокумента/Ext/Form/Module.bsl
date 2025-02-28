﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если Параметры.Свойство("Сотрудник") И ЗначениеЗаполнено(Параметры.Сотрудник) Тогда 
			Объект.Сотрудник = Параметры.Сотрудник;
		КонецЕсли;
		Объект.Основание = НСтр("ru='Заявление'");
		
		// Заполнение нового документа.
		ЗначенияДляЗаполнения = Новый Структура;
		Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
			ЗначенияДляЗаполнения.Вставить("Организация", "Объект.Организация");
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.Ответственный) Тогда
			ЗначенияДляЗаполнения.Вставить("Ответственный", "Объект.Ответственный");
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.ПериодРегистрации) Тогда
			ЗначенияДляЗаполнения.Вставить("Месяц", "Объект.ПериодРегистрации");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ЗначенияДляЗаполнения) Тогда
			ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		КонецЕсли;
		
		ЗаполнитьДанныеФормыПоОрганизации();
		
		Если ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
			ПриИзмененииПериодаОтпуска()
		КонецЕсли;
		
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
	Элементы.ПериодРегистрации.Видимость = НачалоМесяца(Объект.Дата) <> НачалоМесяца(Объект.ПериодРегистрации);

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
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПриСозданииНаСервереФормыОбъекта(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПриСозданииНаСервереФормыОбъекта(ЭтотОбъект, Отказ, СтандартнаяОбработка, Объект);
	// Конец КадровыйЭДО
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
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

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// КадровыйЭДО
	КадровыйЭДОКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец КадровыйЭДО
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПриЧтенииНаСервереФормыОбъекта(ЭтотОбъект, ТекущийОбъект);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПриЧтенииНаСервереФормыОбъекта(ЭтотОбъект, ТекущийОбъект, Объект);
	// Конец КадровыйЭДО
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(
			ЭтотОбъект,
			ТекущийОбъект,
			ПараметрыЗаписи);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ОтпускБезСохраненияОплаты", ПараметрыЗаписи, Объект.Ссылка);
	Оповестить("ЗаявкиСотрудниковЗаписанДокумент", Объект.Ссылка, ВладелецФормы);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПослеЗаписиНаСервереФормыОбъекта(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПослеЗаписиНаСервереФормыОбъекта(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи, Объект);
	// Конец КадровыйЭДО
	
	УстановитьСостояниеДокумента();
	
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
Процедура ДатаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Дата) Тогда
		Если НачалоМесяца(Объект.ПериодРегистрации) <> НачалоМесяца(Объект.Дата) Тогда
			Объект.ПериодРегистрации = НачалоМесяца(Объект.Дата);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЗаполнитьДанныеФормыПоОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	СотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	ДатаНачалаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	
	ПриИзмененииПериодаОтпуска();
	ОбновитьКоличествоДнейОтпуска(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", , );
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Направление, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

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
	ОбновитьПодключаемыеКоманды(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.КонтрольВеденияУчета

&НаКлиенте
Процедура Подключаемый_ОткрытьОтчетПоПроблемам(ЭлементИлиКоманда, НавигационнаяСсылка, СтандартнаяОбработка)
	
	КонтрольВеденияУчетаКлиентБЗК.ОткрытьОтчетПоПроблемамОбъекта(ЭтотОбъект, Объект.Ссылка, СтандартнаяОбработка);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтрольВеденияУчета

// БлокировкаИзмененияОбъектов

&НаКлиенте
Процедура Подключаемый_РазблокироватьФормуОбъекта(Команда)
	
	БлокировкаИзмененияОбъектовКлиент.РазблокироватьФормуОбъекта(ЭтотОбъект, Объект.Ссылка);
	
КонецПроцедуры

// Конец БлокировкаИзмененияОбъектов

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(
			Команда,
			ЭтотОбъект,
			Объект);
	КонецЕсли;
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

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

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой");
	УстановитьКоличествоДнейОтпуска();
	ОбновитьКоличествоДнейОтпуска(ЭтаФорма);
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));
	
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		Объект.ФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Сотрудник, "ФизическоеЛицо");
	Иначе
		Объект.ФизическоеЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
	КонецЕсли;
	
	ЗаполнитьНачисления();
	
КонецПроцедуры

&НаСервере
Процедура ДатаНачалаПриИзмененииНаСервере()
	
	ПриИзмененииПериодаОтпуска();
	ОбновитьКоличествоДнейОтпуска(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииПериодаОтпуска()
	
	Если Объект.ДатаНачала > Объект.ДатаОкончания
		И ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда
		
		Объект.ДатаОкончания = Объект.ДатаНачала;
		
	КонецЕсли;
	
	УстановитьКоличествоДнейОтпуска();
	ЗаполнитьНачисления();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКоличествоДнейОтпуска()
	
	КоличествоДнейОтпуска = ЗарплатаКадрыКлиентСервер.ДнейВПериоде(Объект.ДатаНачала, Объект.ДатаОкончания, Истина);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьКоличествоДнейОтпуска(Форма)
	
	Если ЗначениеЗаполнено(Форма.КоличествоДнейОтпуска) Тогда
		НадписьДней = СтрокаСЧислом( НСтр("ru='; день; ; дня; дней; дня'"),
								Форма.КоличествоДнейОтпуска,
								ВидЧисловогоЗначения.Количественное,
								"L=ru_RU");
		Форма.НадписьДней = СтрШаблон(НСтр("ru='%1 %2'"), Форма.КоличествоДнейОтпуска, НадписьДней);
	Иначе
		Форма.НадписьДней = "";	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачисления()
	
	Документы.ОтпускБезСохраненияОплаты.ЗаполнитьНачисленияВДокументе(Объект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = 0;
	РасчетЗарплатыДляНебольшихОрганизацийПереопределяемый.СостояниеДокумента(Объект, СостояниеДокумента);
	
КонецПроцедуры

// КадровыйЭДО

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПодключаемыеКоманды(УправляемаяФорма)
	КадровыйЭДОКлиентСервер.ОбновитьКоманды(УправляемаяФорма, УправляемаяФорма.Объект, Истина);
КонецПроцедуры

// Конец КадровыйЭДО

#КонецОбласти
