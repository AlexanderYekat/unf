﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ВнесениеСведенийОСобранномУрожаеЗЕРНО") Тогда
		ЗаполнитьПоВнесениюСведенийОСобранномУрожаеЗЕРНО(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнтеграцияЗЕРНОПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	ЗаполнитьОбъектПоСтатистике();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПродуктыПереработкиЗерна") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ГодУрожая");
		МассивНепроверяемыхРеквизитов.Добавить("ВладелецПартии");
		Если ИнтеграцияЗЕРНО.ОпределитьТипОрганизацияКонтрагент(Товаропроизводитель) = 0 Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Товаропроизводитель");
		КонецЕсли;
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Товаропроизводитель");
		Если Не ПоставитьПартиюНаХранение
			Или ИнтеграцияЗЕРНО.ОпределитьТипОрганизацияКонтрагент(ВладелецПартии) = 0 Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ВладелецПартии");
		КонецЕсли;
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ДатаИзготовления");
	КонецЕсли;
	
	Если Операция <> Перечисления.ВидыОперацийЗЕРНО.ФормированиеПартииПриСбореУрожая Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДокументОснование");
	КонецЕсли;
	
	Если Операция = Перечисления.ВидыОперацийЗЕРНО.ФормированиеПартииИмпорт
		Или Операция = Перечисления.ВидыОперацийЗЕРНО.ФормированиеПартииИзОстатков
		Или Операция = Перечисления.ВидыОперацийЗЕРНО.ФормированиеПартииПриСбореУрожая Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.РезультатИсследования");
	КонецЕсли;
	
	Если Операция = Перечисления.ВидыОперацийЗЕРНО.ФормированиеПартииИмпорт
		Или Операция = Перечисления.ВидыОперацийЗЕРНО.ФормированиеПартииИзОстатков
		Или Операция = Перечисления.ВидыОперацийЗЕРНО.ФормированиеПартииПоРезультатамГосмониторинга Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ИдентификаторСведенийОСобранномУрожае");
	КонецЕсли;
	
	Если Не ИнтеграцияЗЕРНОКлиентСервер.ТребуетсяЗаполнениеКодаТНВЭД(НазначениеПартии) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КодТНВЭД");
	КонецЕсли;
	
	Если НазначениеПартии <> ПредопределенноеЗначение("Справочник.КлассификаторНСИЗЕРНО.НазначениеПартииВывозСТерриторииРФ") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтранаНазначения");
	КонецЕсли;
	
	Если Операция <> Перечисления.ВидыОперацийЗЕРНО.ФормированиеПартииИмпорт Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ПроисхождениеСтрокой");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Происхождение");
	КонецЕсли;
	
	ВыполнятьПроверкуПотребительскихСвойств = Истина;
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ТекущееСостояние = РегистрыСведений.СтатусыОбъектовСинхронизацииЗЕРНО.ТекущееСостояние(Ссылка);
		КонечныеСтатусы = Документы.ФормированиеПартийЗЕРНО.КонечныеСтатусы(Ложь);
		Если КонечныеСтатусы.Найти(ТекущееСостояние.Статус) <> Неопределено Тогда
			ВыполнятьПроверкуПотребительскихСвойств = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ВыполнятьПроверкуПотребительскихСвойств Тогда
		
		ТаблицаОшибок = ПустыеПотребительскиеСвойстваПродукцииПоДокументу();
		
		Для Каждого СтрокаТаблицы Из ТаблицаОшибок Цикл
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'В строке %1 для с/х продукции %2 значение потребительского свойства %3 вне диапазона.'"),
				СтрокаТаблицы.НомерСтроки,
				СтрокаТаблицы.ТоварыОКПД2,
				СтрокаТаблицы.ПотребительскоеСвойство);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект, 
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"Товары", СтрокаТаблицы.НомерСтроки, "ОКПД2"),, Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ИнтеграцияЗЕРНОПереопределяемый.ПриОпределенииОбработкиПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ИнтеграцияЗЕРНО.ОпределитьТипОрганизацияКонтрагент(ВладелецПартии) = 1 Тогда
		ПодразделениеВладельцаПартии = ОбщегоНазначенияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение");
	КонецЕсли;
	
	Если ИнтеграцияЗЕРНО.ОпределитьТипОрганизацияКонтрагент(Товаропроизводитель) = 1 Тогда
		ПодразделениеТоваропроизводителя = ОбщегоНазначенияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение");
	КонецЕсли;
	
	ИнтеграцияЗЕРНО.ЗаписатьСоответствиеНоменклатуры(ЭтотОбъект);
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	ИнтеграцияЗЕРНО.ЗаписатьСтатусДокументаЗЕРНОПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Для Каждого СтрокаТоваров Из Товары Цикл
		СтрокаТоваров.Партия = Неопределено;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ФормированиеПартийЗЕРНО.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыНакопления.ОстаткиПартийЗЕРНО.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	ИнтеграцияИСПереопределяемый.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьПоВнесениюСведенийОСобранномУрожаеЗЕРНО(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДокументОснование", ДанныеЗаполнения);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНО.ДатаСбораУрожая КАК ДатаСбораУрожая,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНО.Организация КАК Организация,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНО.Подразделение КАК Подразделение,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНО.СкладКонтрагент КАК СкладКонтрагент,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНО.МестоХранения КАК Местоположение,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНО.МестоХраненияСтрокой КАК МестоположениеСтрокой
	|ИЗ
	|	Документ.ВнесениеСведенийОСобранномУрожаеЗЕРНО КАК ВнесениеСведенийОСобранномУрожаеЗЕРНО
	|ГДЕ
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНО.Ссылка = &ДокументОснование";
	Шапка = Запрос.Выполнить().Выбрать();
	
	Если Шапка.Следующий() Тогда
		ВидПродукции      = Перечисления.ВидыПродукцииИС.Зерно;
		ДокументОснование = ДанныеЗаполнения;
		Если Не ЗначениеЗаполнено(Операция) Тогда
			Операция = Перечисления.ВидыОперацийЗЕРНО.ФормированиеПартииПриСбореУрожая;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(НазначениеПартии) 
			Или НазначениеПартии = Справочники.КлассификаторНСИЗЕРНО.НазначениеПартииВвозНаТерриториюРФ Тогда
			НазначениеПартии = Справочники.КлассификаторНСИЗЕРНО.НазначениеПартииХранениеОбработка;
		КонецЕсли;
		ГодУрожая         = Год(Шапка.ДатаСбораУрожая);
		Организация       = Шапка.Организация;
		Подразделение     = Шапка.Подразделение;
	КонецЕсли;
	
	Если Операция = Перечисления.ВидыОперацийЗЕРНО.ФормированиеПартииПоРезультатамГосмониторинга Тогда
		ЗаполнитьПоВнесениюСведенийОСобранномУрожаеВключаяРезультатыГосмониторинга(Шапка, Запрос, ДанныеЗаполнения);
	Иначе
		ЗаполнитьПоВнесениюСведенийОСобранномУрожаеБезГосмониторинга(Шапка, Запрос, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоВнесениюСведенийОСобранномУрожаеВключаяРезультатыГосмониторинга(Шапка, Запрос, ДанныеЗаполнения)
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.ОКПД2,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Номенклатура,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Характеристика,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Серия,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.СтатусУказанияСерий,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Количество,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.КоличествоЗЕРНО,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Ссылка.СкладКонтрагент КАК СкладКонтрагент,
	|	РезультатыИсследованийЗЕРНО.Ссылка КАК РезультатИсследования
	|ПОМЕСТИТЬ ОжидаемыеПартии
	|ИЗ
	|	Документ.ВнесениеСведенийОСобранномУрожаеЗЕРНО.Товары КАК ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РезультатыИсследованийЗЕРНО КАК РезультатыИсследованийЗЕРНО
	|		ПО РезультатыИсследованийЗЕРНО.МестоФормированияПартии = ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.МестоФормированияПартии
	|ГДЕ
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФормированиеПартийЗЕРНО.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ОформленныеДокументы
	|ИЗ
	|	Документ.ФормированиеПартийЗЕРНО КАК ФормированиеПартийЗЕРНО
	|ГДЕ
	|	ФормированиеПартийЗЕРНО.Ссылка <> &Ссылка
	|	И ФормированиеПартийЗЕРНО.Проведен
	|	И ФормированиеПартийЗЕРНО.ДокументОснование = &ДокументОснование
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ФормированиеПартийЗЕРНОТовары.Количество) КАК Количество,
	|	СУММА(ФормированиеПартийЗЕРНОТовары.КоличествоЗЕРНО) КАК КоличествоЗЕРНО,
	|	ФормированиеПартийЗЕРНОТовары.РезультатИсследования
	|ПОМЕСТИТЬ ОформленныеТовары
	|ИЗ
	|	Документ.ФормированиеПартийЗЕРНО.Товары КАК ФормированиеПартийЗЕРНОТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы КАК ОформленныеДокументы
	|		ПО ФормированиеПартийЗЕРНОТовары.Ссылка = ОформленныеДокументы.Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ФормированиеПартийЗЕРНОТовары.РезультатИсследования
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОжидаемыеПартии.ОКПД2 КАК ОКПД2
	|ИЗ
	|	ОжидаемыеПартии КАК ОжидаемыеПартии
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОформленныеТовары КАК ОформленныеТовары
	|		ПО ОжидаемыеПартии.РезультатИсследования = ОформленныеТовары.РезультатИсследования
	|ГДЕ
	|	ОжидаемыеПартии.КоличествоЗЕРНО > ЕСТЬNULL(ОформленныеТовары.КоличествоЗЕРНО, 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОжидаемыеПартии.ОКПД2 КАК ОКПД2,
	|	ОжидаемыеПартии.Номенклатура КАК Номенклатура,
	|	ОжидаемыеПартии.Характеристика КАК Характеристика,
	|	ОжидаемыеПартии.Серия КАК Серия,
	|	ОжидаемыеПартии.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ОжидаемыеПартии.СкладКонтрагент КАК СкладКонтрагент,
	|	ОжидаемыеПартии.РезультатИсследования КАК РезультатИсследования,
	|	ОжидаемыеПартии.Количество - ЕСТЬNULL(ОформленныеТовары.Количество, 0) КАК Количество,
	|	ОжидаемыеПартии.КоличествоЗЕРНО - ЕСТЬNULL(ОформленныеТовары.КоличествоЗЕРНО, 0) КАК КоличествоЗЕРНО
	|ИЗ
	|	ОжидаемыеПартии КАК ОжидаемыеПартии
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОформленныеТовары КАК ОформленныеТовары
	|		ПО ОжидаемыеПартии.РезультатИсследования = ОформленныеТовары.РезультатИсследования
	|ГДЕ
	|	ОжидаемыеПартии.КоличествоЗЕРНО > ЕСТЬNULL(ОформленныеТовары.КоличествоЗЕРНО, 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПотребительскиеСвойства.Ссылка   КАК РезультатИсследования,
	|	ПотребительскиеСвойства.ПотребительскоеСвойство КАК ПотребительскоеСвойство,
	|	ПотребительскиеСвойства.Значение КАК Значение
	|ИЗ
	|	ОжидаемыеПартии КАК ОжидаемыеПартии
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РезультатыИсследованийЗЕРНО.ПотребительскиеСвойства КАК ПотребительскиеСвойства
	|		ПО ПотребительскиеСвойства.Ссылка = ОжидаемыеПартии.РезультатИсследования";
	
	Пакет = Запрос.ВыполнитьПакет();
	ПотребительскиеСвойстваПоРезультатамГМ = Пакет[Пакет.ВГраница()].Выгрузить();
	ПотребительскиеСвойстваПоРезультатамГМ.Индексы.Добавить("РезультатИсследования, ПотребительскоеСвойство");
	Выборка = Пакет[Пакет.ВГраница()-1].Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru='В %1 отсутствует продукция для заполнения.'"), ДанныеЗаполнения);
	КонецЕсли;
	
	КодыОКПД2 = Пакет[Пакет.ВГраница()-2].Выгрузить().ВыгрузитьКолонку("ОКПД2");
	ПотребительскиеСвойстваПоОКПД2 = ИнтеграцияЗЕРНО.ПотребительскиеСвойстваПродукцииПоДаннымОКПД2(
		КодыОКПД2, НазначениеПартии);
	
	ЗаполнитьПотребительскиеСвойства = ПотребительскиеСвойстваПоОКПД2 <> Неопределено;
	
	Товары.Очистить();
	ПотребительскиеСвойства.Очистить();
	
	Отбор                        = Новый Структура("РезультатИсследования, ПотребительскоеСвойство"); 
	ОтборПотребительскиеСвойства = Новый Структура("ОКПД2");
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Шапка);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.Идентификатор = Новый УникальныйИдентификатор;
		
		Если ЗаполнитьПотребительскиеСвойства Тогда
			
			Отбор.РезультатИсследования = НоваяСтрока.РезультатИсследования;
			
			ОтборПотребительскиеСвойства.ОКПД2 = НоваяСтрока.ОКПД2;
			СвойстваПродукцииПоОКПД2 = ПотребительскиеСвойстваПоОКПД2.НайтиСтроки(ОтборПотребительскиеСвойства);
			Для Каждого СвойствоПродукции Из СвойстваПродукцииПоОКПД2 Цикл
				
				НовоеСвойство = ПотребительскиеСвойства.Добавить();
				НовоеСвойство.ИдентификаторСтрокиТоваров = НоваяСтрока.Идентификатор;
				ЗаполнитьЗначенияСвойств(НовоеСвойство, СвойствоПродукции);
				
				Отбор.ПотребительскоеСвойство = НовоеСвойство.ПотребительскоеСвойство;
				СвойстваПродукцииПоРезультатамГМ = ПотребительскиеСвойстваПоРезультатамГМ.НайтиСтроки(Отбор);
				
				Для Каждого СвойствоПродукцииГМ Из СвойстваПродукцииПоРезультатамГМ Цикл
					НовоеСвойство.Значение = СвойствоПродукцииГМ.Значение;
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПоВнесениюСведенийОСобранномУрожаеБезГосмониторинга(Шапка, Запрос, ДанныеЗаполнения)
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.ОКПД2,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Номенклатура,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Характеристика,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Серия,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.СтатусУказанияСерий,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Количество,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.КоличествоЗЕРНО,
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Ссылка.СкладКонтрагент КАК СкладКонтрагент,
	|	СтатусыОбъектовСинхронизацииЗЕРНО.ИдентификаторЗаявки КАК ИдентификаторСведенийОСобранномУрожае
	|ПОМЕСТИТЬ ОжидаемыеПартии
	|ИЗ
	|	Документ.ВнесениеСведенийОСобранномУрожаеЗЕРНО.Товары КАК ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыОбъектовСинхронизацииЗЕРНО КАК СтатусыОбъектовСинхронизацииЗЕРНО
	|		ПО ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Ссылка = СтатусыОбъектовСинхронизацииЗЕРНО.ОбъектСинхронизации
	|			И ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Идентификатор = СтатусыОбъектовСинхронизацииЗЕРНО.ИдентификаторСтроки
	|ГДЕ
	|	ВнесениеСведенийОСобранномУрожаеЗЕРНОТовары.Ссылка = &ДокументОснование
	|	И СтатусыОбъектовСинхронизацииЗЕРНО.ИдентификаторСтроки <> """"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФормированиеПартийЗЕРНО.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ОформленныеДокументы
	|ИЗ
	|	Документ.ФормированиеПартийЗЕРНО КАК ФормированиеПартийЗЕРНО
	|ГДЕ
	|	ФормированиеПартийЗЕРНО.Ссылка <> &Ссылка
	|	И ФормированиеПартийЗЕРНО.Проведен
	|	И ФормированиеПартийЗЕРНО.ДокументОснование = &ДокументОснование
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ФормированиеПартийЗЕРНОТовары.Количество) КАК Количество,
	|	СУММА(ФормированиеПартийЗЕРНОТовары.КоличествоЗЕРНО) КАК КоличествоЗЕРНО,
	|	ФормированиеПартийЗЕРНОТовары.ИдентификаторСведенийОСобранномУрожае КАК ИдентификаторСведенийОСобранномУрожае
	|ПОМЕСТИТЬ ОформленныеТовары
	|ИЗ
	|	Документ.ФормированиеПартийЗЕРНО.Товары КАК ФормированиеПартийЗЕРНОТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы КАК ОформленныеДокументы
	|		ПО ФормированиеПартийЗЕРНОТовары.Ссылка = ОформленныеДокументы.Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ФормированиеПартийЗЕРНОТовары.ИдентификаторСведенийОСобранномУрожае
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОжидаемыеПартии.ОКПД2 КАК ОКПД2
	|ИЗ
	|	ОжидаемыеПартии КАК ОжидаемыеПартии
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОформленныеТовары КАК ОформленныеТовары
	|		ПО ОжидаемыеПартии.ИдентификаторСведенийОСобранномУрожае = ОформленныеТовары.ИдентификаторСведенийОСобранномУрожае
	|ГДЕ
	|	ОжидаемыеПартии.КоличествоЗЕРНО > ЕСТЬNULL(ОформленныеТовары.КоличествоЗЕРНО, 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОжидаемыеПартии.ОКПД2 КАК ОКПД2,
	|	ОжидаемыеПартии.Номенклатура КАК Номенклатура,
	|	ОжидаемыеПартии.Характеристика КАК Характеристика,
	|	ОжидаемыеПартии.Серия КАК Серия,
	|	ОжидаемыеПартии.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ОжидаемыеПартии.СкладКонтрагент КАК СкладКонтрагент,
	|	ОжидаемыеПартии.ИдентификаторСведенийОСобранномУрожае КАК ИдентификаторСведенийОСобранномУрожае,
	|	ОжидаемыеПартии.Количество - ЕСТЬNULL(ОформленныеТовары.Количество, 0) КАК Количество,
	|	ОжидаемыеПартии.КоличествоЗЕРНО - ЕСТЬNULL(ОформленныеТовары.КоличествоЗЕРНО, 0) КАК КоличествоЗЕРНО
	|ИЗ
	|	ОжидаемыеПартии КАК ОжидаемыеПартии
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОформленныеТовары КАК ОформленныеТовары
	|		ПО ОжидаемыеПартии.ИдентификаторСведенийОСобранномУрожае = ОформленныеТовары.ИдентификаторСведенийОСобранномУрожае
	|ГДЕ
	|	ОжидаемыеПартии.КоличествоЗЕРНО > ЕСТЬNULL(ОформленныеТовары.КоличествоЗЕРНО, 0)
	|";
	
	Пакет = Запрос.ВыполнитьПакет();
	Выборка = Пакет[Пакет.ВГраница()].Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru='В %1 отсутствует продукция для заполнения.'"), ДанныеЗаполнения);
	КонецЕсли;
	
	КодыОКПД2 = Пакет[Пакет.ВГраница()-1].Выгрузить().ВыгрузитьКолонку("ОКПД2");
	ПотребительскиеСвойстваПоОКПД2 = ИнтеграцияЗЕРНО.ПотребительскиеСвойстваПродукцииПоДаннымОКПД2(
		КодыОКПД2, НазначениеПартии);
	
	ЗаполнитьПотребительскиеСвойства = ПотребительскиеСвойстваПоОКПД2 <> Неопределено;
	
	ЗаполнитьТНВЭД = Ложь;
	Если НазначениеПартии = Справочники.КлассификаторНСИЗЕРНО.НазначениеПартииВывозСТерриторииРФ Тогда
		ТаблицаОКПД2ТНВЭД = РегистрыСведений.ВидыСельскохозяйственныхКультурЗЕРНО.ДанныеТНВЭДПоОКПД2(КодыОКПД2);
		ЗаполнитьТНВЭД = Истина;
		Отбор = Новый Структура("ОКПД2");
	КонецЕсли;
	Товары.Очистить();
	ПотребительскиеСвойства.Очистить();
	
	ОтборПотребительскиеСвойства = Новый Структура("ОКПД2");
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Шапка);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.Идентификатор = Новый УникальныйИдентификатор;
		
		Если ЗаполнитьТНВЭД Тогда
			Отбор.ОКПД2 = НоваяСтрока.ОКПД2;
			ДанныеОКПД2ТНВЭД = ТаблицаОКПД2ТНВЭД.НайтиСтроки(Отбор);
			Если ДанныеОКПД2ТНВЭД.Количество() Тогда
				НоваяСтрока.КодТНВЭД = ДанныеОКПД2ТНВЭД[0].КодТНВЭД;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗаполнитьПотребительскиеСвойства Тогда
			
			ОтборПотребительскиеСвойства.ОКПД2 = НоваяСтрока.ОКПД2;
			СвойстваПродукцииПоОКПД2 = ПотребительскиеСвойстваПоОКПД2.НайтиСтроки(ОтборПотребительскиеСвойства);
			Для Каждого СвойствоПродукции Из СвойстваПродукцииПоОКПД2 Цикл
				
				НовоеСвойство = ПотребительскиеСвойства.Добавить();
				НовоеСвойство.ИдентификаторСтрокиТоваров = НоваяСтрока.Идентификатор;
				ЗаполнитьЗначенияСвойств(НовоеСвойство, СвойствоПродукции);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьОбъектПоСтатистике()
	
	ДанныеСтатистики = ЗаполнениеОбъектовПоСтатистикеЗЕРНО.ДанныеЗаполненияФормированиеПартийЗЕРНО(Организация);
	
	Для Каждого КлючИЗначение Из ДанныеСтатистики Цикл
		ЗаполнениеОбъектовПоСтатистикеЗЕРНО.ЗаполнитьПустойРеквизит(ЭтотОбъект, ДанныеСтатистики, КлючИЗначение.Ключ);
	КонецЦикла;
	
	ПроверитьАктуальностьВладельцаПартии();
	ПроверитьАктуальностьОперации();
	
КонецПроцедуры 

Процедура ПроверитьАктуальностьВладельцаПартии()
	
	Если ВидПродукции = Перечисления.ВидыПродукцииИС.Зерно Тогда
		Если Не ПоставитьПартиюНаХранение Тогда
			ВладелецПартии = Неопределено;
			ПодразделениеВладельцаПартии = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьАктуальностьОперации()
	
	ВидыОперацийПоВидуПродукцииИС = Документы.ФормированиеПартийЗЕРНО.ДоступныеВидыОперацийПоВидуПродукцииИС();
	ВидыОперацийПоВидуПродукции   = ВидыОперацийПоВидуПродукцииИС.Получить(ВидПродукции);
	
	Если ВидыОперацийПоВидуПродукции <> Неопределено
		И ВидыОперацийПоВидуПродукции.Найти(Операция) = Неопределено Тогда
		Операция = ВидыОперацийПоВидуПродукции[0];
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Функция ПустыеПотребительскиеСвойстваПродукцииПоДокументу()
	
	ТаблицаТовары = Товары.Выгрузить(, "НомерСтроки, Идентификатор, ОКПД2");
	ТаблицаПотребительскиеСвойства = ПотребительскиеСвойства.Выгрузить(, "ПотребительскоеСвойство, Значение, ИдентификаторСтрокиТоваров");
	
	НазначениеПотребительскогоСвойства = ИнтеграцияЗЕРНО.НазначениеПотребительскогоСвойстваДаннымПартии(НазначениеПартии);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Идентификатор КАК Идентификатор,
	|	Товары.ОКПД2 КАК ОКПД2
	|ПОМЕСТИТЬ ВТ_Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|/////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПотребительскиеСвойства.ПотребительскоеСвойство КАК ПотребительскоеСвойство,
	|	ПотребительскиеСвойства.Значение КАК Значение,
	|	ПотребительскиеСвойства.ИдентификаторСтрокиТоваров КАК ИдентификаторСтрокиТоваров
	|ПОМЕСТИТЬ ВТ_ПотребительскиеСвойства
	|ИЗ
	|	&ПотребительскиеСвойства КАК ПотребительскиеСвойства
	|;
	|/////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	ПРЕДСТАВЛЕНИЕ(Товары.ОКПД2) КАК ТоварыОКПД2,
	|	ПРЕДСТАВЛЕНИЕ(ПотребительскиеСвойства.ПотребительскоеСвойство) КАК ПотребительскоеСвойство
	|ИЗ
	|	ВТ_Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПотребительскиеСвойства КАК ПотребительскиеСвойства
	|		ПО Товары.Идентификатор = ПотребительскиеСвойства.ИдентификаторСтрокиТоваров
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДопустимыеЗначенияПотребительскихСвойствЗЕРНО КАК
	|			ДопустимыеЗначенияПотребительскихСвойствЗЕРНО
	|		ПО (ПотребительскиеСвойства.ПотребительскоеСвойство = ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ПотребительскоеСвойство)
	|		И Товары.ОКПД2 = ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ОКПД2
	|		И (ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.Назначение = &Назначение)
	|		И (ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДействуетПо >= &Дата
	|		ИЛИ ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДействуетПо = ДАТАВРЕМЯ(1, 1, 1))
	|		И (ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.КодСтраны = &КодСтраны)
	|		И (ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ТипЗначения = ЗНАЧЕНИЕ(Перечисление.ТипыЗначенияПотребительскогоСвойстваЗЕРНО.Число)
	|			И (ПотребительскиеСвойства.Значение < ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДиапазонС
	|				ИЛИ ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДиапазонПо > 0
	|				И ПотребительскиеСвойства.Значение > ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДиапазонПо)
	|			ИЛИ ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ТипЗначения = ЗНАЧЕНИЕ(Перечисление.ТипыЗначенияПотребительскогоСвойстваЗЕРНО.Перечисление)
	|				И ПотребительскиеСвойства.Значение = """"
	|				И ВЫРАЗИТЬ(ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДопустимыеЗначения КАК СТРОКА(1)) <> """")";
	
	Запрос.УстановитьПараметр("Товары",                  ТаблицаТовары);
	Запрос.УстановитьПараметр("ПотребительскиеСвойства", ТаблицаПотребительскиеСвойства);
	
	Запрос.УстановитьПараметр("Назначение", НазначениеПотребительскогоСвойства);
	Запрос.УстановитьПараметр("Дата",       ТекущаяУниверсальнаяДата());
	Запрос.УстановитьПараметр("КодСтраны", "RU");
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
