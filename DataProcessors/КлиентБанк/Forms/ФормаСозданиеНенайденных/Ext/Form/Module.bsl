﻿
#Область ОписаниеПеременных

#Область ПеременныеФормы

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресХранилищаРаспознанныеДанныеИзБанка = Параметры.АдресХранилищаРаспознанныеДанныеИзБанка;
	ДеревоКонтрагентов                      = ПолучитьИзВременногоХранилища(Параметры.АдресХранилищаКонтрагентов);
	
	ЗначениеВРеквизитФормы(ДеревоКонтрагентов, "ТаблицаКонтрагентов");
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	РезультатСоздания = СоздатьНенайденное();
	
	Если НЕ РезультатСоздания.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтотОбъект, ИдентификаторЗадания);
		
		ИдентификаторЗадания    = РезультатСоздания.ИдентификаторЗадания;
		АдресХранилища          = РезультатСоздания.АдресХранилища;
	Иначе
		Закрыть(РезультатСоздания.ПодготовленныеДанные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыДеревоКонтрагентов

&НаКлиенте
Процедура СнятьВсеПометки(Команда)
	
	УстановитьПометки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВсеПометки(Команда)
	
	УстановитьПометки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтрагентовПометкаПриИзменении(Элемент)
	
	// Количество элементов в ветви дерева заведомо небольшое, поэтому операцию
	// выполняем на клиенте
	
	ТекущийЭлементДерева = ТаблицаКонтрагентов.НайтиПоИдентификатору(Элементы.ДеревоКонтрагентов.ТекущаяСтрока);
	
	РодительЭлемента = ТекущийЭлементДерева.ПолучитьРодителя();
	Если РодительЭлемента <> Неопределено Тогда
		Если ТекущийЭлементДерева.Пометка Тогда
			РодительЭлемента.Пометка = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ПодчиненныеТекущемуЭлементы = ТекущийЭлементДерева.ПолучитьЭлементы();
	
	Для каждого ПодчиненныйЭлемент Из ПодчиненныеТекущемуЭлементы Цикл
		Если ТекущийЭлементДерева.ЭтоРодитель Тогда
			ПодчиненныйЭлемент.Пометка = ТекущийЭлементДерева.Пометка;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СоздатьНенайденное()
	
	ПараметрыСозданияНовыхОбъектов = Новый Структура;
	ПараметрыСозданияНовыхОбъектов.Вставить("РаспознанныеДанныеИзБанка",               ПолучитьИзВременногоХранилища(АдресХранилищаРаспознанныеДанныеИзБанка));
	ПараметрыСозданияНовыхОбъектов.Вставить("ОтборСсылкиКСозданию",                    ОтборСсылкиКСозданию());
	ПараметрыСозданияНовыхОбъектов.Вставить("АдресХранилищаРаспознанныеДанныеИзБанка", АдресХранилищаРаспознанныеДанныеИзБанка);
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Обработки.КлиентБанк.ФоноваяСозданиеНовыхОбъектов",
		ПараметрыСозданияНовыхОбъектов,
		НСтр("ru = 'Создание контрагентов, договоров, банковских счетов'"));
	
	АдресХранилища = Результат.АдресХранилища;
	
	Если Результат.ЗаданиеВыполнено Тогда
		Результат.Вставить("ПодготовленныеДанные", ПолучитьИзВременногоХранилища(АдресХранилища));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ОтборСсылкиКСозданию()
	
	ДеревоКонтрагентов = РеквизитФормыВЗначение("ТаблицаКонтрагентов");
	
	ОтборСсылкиКСозданию = Новый Соответствие;
	ОтборСсылкиКСозданию.Вставить(Тип("СправочникСсылка.Контрагенты"),          Новый Соответствие);
	ОтборСсылкиКСозданию.Вставить(Тип("СправочникСсылка.ФизическиеЛица"),       Новый Соответствие);
	ОтборСсылкиКСозданию.Вставить(Тип("СправочникСсылка.ДоговорыКонтрагентов"), Новый Соответствие);
	ОтборСсылкиКСозданию.Вставить(Тип("СправочникСсылка.БанковскиеСчета"),      Новый Соответствие);
	
	Для Каждого СтрокаКонтрагент Из ДеревоКонтрагентов.Строки Цикл
		ДобавитьСсылкуВОтбор(ОтборСсылкиКСозданию, СтрокаКонтрагент);
	КонецЦикла;
	
	Возврат ОтборСсылкиКСозданию;
	
КонецФункции

&НаСервере
Процедура ДобавитьСсылкуВОтбор(ОтборСсылкиКСозданию, СтрокаДерева)
	
	Если НЕ СтрокаДерева.Пометка ИЛИ НЕ ЗначениеЗаполнено(СтрокаДерева.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтрокаДерева.Реквизит) Тогда
		Ссылка = СтрокаДерева.Ссылка;
		ОтборСсылкиКСозданию[ТипЗнч(Ссылка)].Вставить(Ссылка, Истина);
	КонецЕсли;
	
	Для Каждого ПодстрокаДерева Из СтрокаДерева.Строки Цикл
		ДобавитьСсылкуВОтбор(ОтборСсылкиКСозданию, ПодстрокаДерева);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// ДеревоКонтрагентовПометка
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДеревоКонтрагентовПометка");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ТаблицаКонтрагентов.ЭтоРодитель", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометки(Флаг)
	
	Для каждого Строка Из ТаблицаКонтрагентов.ПолучитьЭлементы() Цикл
		Если Строка.ЭтоРодитель Тогда
			Строка.Пометка = Флаг;
		КонецЕсли;
		
		Для Каждого Подстрока Из Строка.ПолучитьЭлементы() Цикл
			Если Подстрока.ЭтоРодитель Тогда
				Подстрока.Пометка = Флаг;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыРаботаМеханизмаДлительныхОпераций

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			ПодготовленныеДанные = ПолучитьИзВременногоХранилища(АдресХранилища);
			Закрыть(ПодготовленныеДанные);
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,
				Истина);
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
