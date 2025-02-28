﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВалютаУчета = УправлениеНебольшойФирмойПовтИсп.ПолучитьНациональнуюВалюту();
	ОбработатьПараметрыФормы();
	
	Элементы.ГруппаКурсКратностьПересчетаЦен.Видимость = ПересчитатьЦены;
	
	// ДисконтныеКарты
	НастроитьНадписьПоДисконтнойКарте();
	
	МобильныйКлиентУНФ.НастроитьВспомогательнуюФормуМобильныйКлиент(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РасчетыРаботаСФормамиКлиент.ЗаполнитьСписокВыбораВалютЭлементаФормы(Элементы.КурсРасчетов, ВалютаРасчетов,
		ДатаДокумента);
	Если ВалютаДокумента = УправлениеНебольшойФирмойПовтИсп.ПолучитьНациональнуюВалюту() Тогда
		РасчетыРаботаСФормамиКлиент.ЗаполнитьСписокВыбораВалютЭлементаФормы(Элементы.КурсПересчетаЦен,
			Параметры.ВалютаДокумента, ДатаДокумента);
	Иначе
		РасчетыРаботаСФормамиКлиент.ЗаполнитьСписокВыбораВалютЭлементаФормы(Элементы.КурсПересчетаЦен, ВалютаРасчетов,
			ДатаДокумента);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидЦеныПриИзменении(Элемент)
	
	Если Параметры.ВидЦенЕстьРеквизит И Параметры.ВидЦен <> ВидЦен Тогда
		ПерезаполнитьЦены = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЦенКонтрагентаПриИзменении(Элемент)
	
	Если Параметры.ВидЦенКонтрагентаЕстьРеквизит И Параметры.ВидЦенКонтрагента <> ВидЦенКонтрагента Тогда
		ПерезаполнитьЦены = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидСкидкиПриИзменении(Элемент)
	
	Если Параметры.ВидСкидкиНаценки <> ВидСкидкиНаценки Тогда
		ПерезаполнитьЦены = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();
	
	РасчетыРаботаСФормамиКлиент.ЗаполнитьСписокВыбораВалютЭлементаФормы(Элементы.КурсПересчетаЦен, ВалютаДокумента,
		ДатаДокумента);
	
	Если ЗначениеЗаполнено(ВалютаДокумента) И Параметры.ВалютаДокумента <> ВалютаДокумента Тогда
		ПересчитатьЦены = Истина;
		ПересчитатьЦеныПриИзменении(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаРасчетовПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура КурсРасчетовПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура КратностьРасчетовПриИзменении(Элемент)
	
	ЗаполнитьКурсКратностьВалютыДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьЦеныПриИзменении(Элемент)

	Если Параметры.ВидЦенЕстьРеквизит Тогда

		Если ПерезаполнитьЦены Тогда
			Если ВидСкидкиНаценки.Пустая() И Не ДисконтнаяКарта.Пустая() Тогда // ДисконтныеКарты
				Элементы.ВидЦен.АвтоОтметкаНезаполненного = Ложь;
			Иначе
				Элементы.ВидЦен.АвтоОтметкаНезаполненного = Истина;
			КонецЕсли;
		Иначе
			Элементы.ВидЦен.АвтоОтметкаНезаполненного = Ложь;
			ОтключитьОтметкуНезаполненного();
		КонецЕсли;

	КонецЕсли;

	Если Параметры.ВидЦенКонтрагентаЕстьРеквизит Тогда

		Если ПерезаполнитьЦены Или РегистрироватьЦеныПоставщика Тогда
			Элементы.ВидЦенКонтрагента.АвтоОтметкаНезаполненного = Истина;
		Иначе
			Элементы.ВидЦенКонтрагента.АвтоОтметкаНезаполненного = Ложь;
			ОтключитьОтметкуНезаполненного();
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РегистрироватьЦеныПоставщикаПриИзменении(Элемент)
	
	Если РегистрироватьЦеныПоставщика ИЛИ ПерезаполнитьЦены Тогда
		Элементы.ВидЦенКонтрагента.АвтоОтметкаНезаполненного = Истина;
	Иначе	
		Элементы.ВидЦенКонтрагента.АвтоОтметкаНезаполненного = Ложь;
		ОтключитьОтметкуНезаполненного();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДисконтнаяКартаПриИзменении(Элемент)
	
	Если Параметры.ДисконтнаяКарта <> ДисконтнаяКарта Тогда
		
		ПерезаполнитьЦены = Истина;
		
	КонецЕсли;
	
	// Мог измениться % накопительной скидки, т.ч. обновляем надпись, даже если дисконтная карта не поменялась.
	НастроитьНадписьПоДисконтнойКарте();
	
	ПерезаполнитьЦеныПриИзменении(Элементы.ПерезаполнитьЦены);
	
КонецПроцедуры

&НаКлиенте
Процедура ДисконтнаяКартаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораДисконтнойКартыЗавершение", ЭтотОбъект);
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ПараметрыФормы = Новый Структура("Контрагент, ОтборПоКонтрагенту", Контрагент, Истина);
	КонецЕсли;
	ОткрытьФорму("Справочник.ДисконтныеКарты.ФормаВыбора", ПараметрыФормы, ДисконтнаяКарта, УникальныйИдентификатор, ,
		, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура КурсРасчетовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = 0 Тогда
		СтандартнаяОбработка = Ложь;
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("КурсРасчетовОбработкаВыбораЗавершение", ЭтотОбъект);
		Подсказка = НСтр("ru = 'Укажите дату курса валюты'");
		ПоказатьВводДаты(ОбработчикОповещенияОЗакрытии, ДатаДокумента, Подсказка, ЧастиДаты.Дата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КурсПересчетаЦенОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = 0 Тогда
		СтандартнаяОбработка = Ложь;
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("КурсПересчетаЦенОбработкаВыбораЗавершение",
			ЭтотОбъект);
		Подсказка = НСтр("ru = 'Укажите дату курса валюты'");
		ПоказатьВводДаты(ОбработчикОповещенияОЗакрытии, ДатаДокумента, Подсказка, ЧастиДаты.Дата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьЦеныПриИзменении(Элемент)
	
	Элементы.ГруппаКурсКратностьПересчетаЦен.Видимость = ПересчитатьЦены;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПереключитьИспользованиеВидовЦенДляВозвратов(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если ЕстьОшибкиВЗаполненииПолей() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ЦеныИВалютаКлиентСервер.РезультатФормыЦеныИВалюта();
	
	Результат.БылиВнесеныИзменения = БылиВнесеныИзменения();
	
	Результат.ВидЦен = ВидЦен;
	Результат.ВидЦенКонтрагента = ВидЦенКонтрагента;
	Результат.РегистрироватьЦеныПоставщика = РегистрироватьЦеныПоставщика;
	Результат.ВидСкидкиНаценки = ВидСкидкиНаценки;
	
	Результат.ВалютаДокумента = ВалютаДокумента;
	Результат.НалогообложениеНДС = НалогообложениеНДС;
	Результат.СпециальныйНалоговыйРежим = СпециальныйНалоговыйРежим;
	Результат.СуммаВключаетНДС = СуммаВключаетНДС;
	Результат.НДСВключатьВСтоимость = НДСВключатьВСтоимость;
	
	Результат.ВалютаРасчетов = ВалютаРасчетов;
	Результат.КурсРасчетов = КурсРасчетов;
	Результат.КратностьРасчетов = КратностьРасчетов;
	
	Результат.ПредВалютаДокумента = Параметры.ВалютаДокумента;
	Результат.ПредНалогообложениеНДС = Параметры.НалогообложениеНДС;
	Результат.ПредСпециальныйНалоговыйРежим = Параметры.СпециальныйНалоговыйРежим;
	Результат.ПредСуммаВключаетНДС = Параметры.СуммаВключаетНДС;
	
	Результат.ПерезаполнитьЦены = ПерезаполнитьЦены;
	Результат.ПересчитатьЦены = ПересчитатьЦены;
	
	Результат.КурсПересчетаЦен.Курс = КурсПересчетаЦен;
	Результат.КурсПересчетаЦен.Кратность = КратностьПересчетаЦен;
	
	// ДисконтныеКарты
	Результат.ПерезаполнитьСкидки = ПерезаполнитьЦены ИЛИ СуммаВключаетНДС <> Параметры.СуммаВключаетНДС;
	
	Результат.ДисконтнаяКарта = ДисконтнаяКарта;
	Результат.ИзмененаДисконтнаяКарта = Параметры.ДисконтнаяКарта <> ДисконтнаяКарта;
	Результат.ПроцентСкидкиПоДисконтнойКарте = ПроцентСкидкиПоДисконтнойКарте;
	Результат.Контрагент = ПолучитьВладельцаКарты(ДисконтнаяКарта);
	// Конец ДисконтныеКарты
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьИспользованиеВидовЦенДляВозвратов(Команда)
	
	Если ЭтоВозврат Тогда
		
		СпособИспользования = СпособИспользованияЦенДляВозвратов();
		ЭтотОбъект.Модифицированность = Истина;
		
	Иначе
		
		СпособИспользования = Неопределено;
		
	КонецЕсли;
	
	УстановитьВидимостьЭлементовПереключенияЦенДляВозвратов(СпособИспользования);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработатьПараметрыФормы()
	
	КлючПоложения = Новый Массив;
	
	ДатаДокумента = Параметры.ДатаДокумента;
	ЭтоВозврат = Параметры.ЭтоВозврат;
	ТипОбъектаВладельца = Параметры.ТипОбъектаВладельца;
	
	ЗаполнитьТаблицуКурсовВалют();
	ОбработатьПараметрТекстПредупреждения(КлючПоложения); 
	ОбработатьПараметрыВидовЦен(КлючПоложения);
	ОбработатьПараметрыРегистрацииЦенПоставщика(КлючПоложения);
	ОбработатьПараметрыСкидок(КлючПоложения);
	ОбработатьПараметрыВалютыДокумента(КлючПоложения);
	ОбработатьПараметрыНалогообложения(КлючПоложения);
	ОбработатьПараметрыДоговора(КлючПоложения);
	УстановитьВидимостьФлажкаПерезаполнитьЦены(КлючПоложения);
	УстановитьПодсказкуВидаЦен(КлючПоложения);
	УстановитьПодсказкуПереходаНаВидыЦенПродажиДляВозвратов(КлючПоложения);

	Если ЗначениеЗаполнено(Параметры.ВалютаПередИзменением) Тогда
		Параметры.ВалютаДокумента = Параметры.ВалютаПередИзменением;
	КонецЕсли;

	ПерезаполнитьЦены = Параметры.ПерезаполнитьЦены;
	ПересчитатьЦены   = Параметры.ПересчитатьЦены;
		
	Хеш = Новый ХешированиеДанных(ХешФункция.MD5);
	Хеш.Добавить(СтрСоединить(КлючПоложения));
	КлючСохраненияПоложенияОкна = "ЦеныИВалюта" + СтрЗаменить(Хеш.ХешСумма, " ", "");
	
	Если Параметры.Свойство("МассивПартий") Тогда
		ЕстьКомиссияСНДС = РаботаСКомиссионерамиКомитентамиСервер.ВТабличнойЧастиЕстьКомиссионнаяПартияСНалогообложениемНДС(Параметры.МассивПартий);
		НалогообложениеНДСИзДокумента = НалогообложениеНДС;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуКурсовВалют()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаДокумента", ДатаДокумента);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Валюта КАК Валюта,
	|	КурсыВалютСрезПоследних.Курс КАК Курс,
	|	КурсыВалютСрезПоследних.Кратность КАК Кратность
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаДокумента, ) КАК КурсыВалютСрезПоследних";
	
	ТаблицаРезультатаЗапроса = Запрос.Выполнить().Выгрузить();
	КурсыВалют.Загрузить(ТаблицаРезультатаЗапроса);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметрТекстПредупреждения(КлючПоложения)

	Если ЗначениеЗаполнено(Параметры.ТекстПредупреждения) Тогда
		Элементы.Предупреждение.Заголовок = Параметры.ТекстПредупреждения;
		КлючПоложения.Добавить("ТекстПредупреждения");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаПредупреждение", "Видимость",
			Ложь);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметрыСкидок(КлючПоложения)
	
	Если Параметры.ВидСкидкиНаценкиЕстьРеквизит Тогда
		ВидСкидкиНаценки = Параметры.ВидСкидкиНаценки;
		КлючПоложения.Добавить("ВидСкидкиНаценки");
	Иначе
		Элементы.ВидСкидкиНаценки.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.ДисконтнаяКартаЕстьРеквизит Тогда
		ДисконтнаяКарта = Параметры.ДисконтнаяКарта;
		Если Параметры.КонтрагентЕстьРеквизит Тогда
			Контрагент = Параметры.Контрагент;
		КонецЕсли;
		Элементы.ДисконтнаяКарта.Видимость = Истина;
		КлючПоложения.Добавить("ДисконтнаяКарта");
	Иначе
		Элементы.ДисконтнаяКарта.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметрыВидовЦен(КлючПоложения)
	
	ВидЦен = Параметры.ВидЦен;
	Если Параметры.ВидЦенЕстьРеквизит Тогда
		КлючПоложения.Добавить("ВидЦен");
	Иначе
		Элементы.ВидЦен.Видимость = Ложь;
		Элементы.ВидСкидкиНаценки.Видимость = Ложь;
	КонецЕсли;
	
	ВидЦенКонтрагента = Параметры.ВидЦенКонтрагента;
	Если Параметры.ВидЦенКонтрагентаЕстьРеквизит Тогда
		Контрагент = Параметры.Контрагент;
		
		МассивЗначений = Новый Массив;
		МассивЗначений.Добавить(Контрагент);
		МассивЗначений = Новый ФиксированныйМассив(МассивЗначений);
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Владелец", МассивЗначений);
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(НовыйПараметр);
		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
		Элементы.ВидЦенКонтрагента.ПараметрыВыбора = НовыеПараметры;
		
		УчетЦенКонтрагентов = ПолучитьФункциональнуюОпцию("УчетЦенКонтрагентов");
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПерезаполнитьЦены", "Видимость",
			УчетЦенКонтрагентов);
		КлючПоложения.Добавить("ВидЦенКонтрагента");
		
	Иначе
		Элементы.ВидЦенКонтрагента.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметрыРегистрацииЦенПоставщика(КлючПоложения)
	
	Если Параметры.РегистрироватьЦеныПоставщикаЕстьРеквизит Тогда
		РегистрироватьЦеныПоставщика = Параметры.РегистрироватьЦеныПоставщика;
		КлючПоложения.Добавить("РегистрироватьЦеныПоставщика");
	Иначе
		Элементы.РегистрироватьЦеныПоставщика.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметрыВалютыДокумента(КлючПоложения)

	Если Параметры.ЗапретитьИзменениеВалюты Тогда
		Элементы.Валюта.Доступность = Ложь;
		Элементы.ПересчитатьЦены.Видимость = Ложь;
	КонецЕсли;

	Если Параметры.ВалютаДокументаЕстьРеквизит Тогда
		ВалютаДокумента = Параметры.ВалютаДокумента;
		КлючПоложения.Добавить("ВалютаДокумента");
	Иначе
		Элементы.ВалютаДокумента.Видимость = Ложь;
		Элементы.КурсПересчетаЦен.Видимость = Ложь;
		Элементы.КратностьПересчетаЦен.Видимость = Ложь;
		Элементы.ПересчитатьЦены.Видимость = Ложь;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
		Возврат;
	КонецЕсли;

	МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаДокумента));
	Если ВалютаДокумента = ВалютаРасчетов И КурсРасчетов <> 0 И КратностьРасчетов <> 0 Тогда
		Курс = КурсРасчетов;
		Кратность = КратностьРасчетов;
	Иначе
		Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
			Курс = МассивКурсКратность[0].Курс;
			Кратность = МассивКурсКратность[0].Кратность;
		Иначе
			Курс = 0;
			Кратность = 0;
		КонецЕсли;
	КонецЕсли;

	МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаРасчетов));
	Если ВалютаДокумента = УправлениеНебольшойФирмойПовтИсп.ПолучитьНациональнуюВалюту() Тогда
		МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", Параметры.ВалютаДокумента));
		Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
			КурсПересчетаЦен = МассивКурсКратность[0].Курс;
			КратностьПересчетаЦен = МассивКурсКратность[0].Кратность;
		Иначе
			КурсПересчетаЦен = Курс;
			КратностьПересчетаЦен = Кратность;
		КонецЕсли;
	Иначе
		КурсПересчетаЦен = Курс;
		КратностьПересчетаЦен = Кратность;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметрыНалогообложения(КлючПоложения)

	Если Параметры.НалогообложениеНДСЕстьРеквизит Тогда
		НалогообложениеНДС = Параметры.НалогообложениеНДС;
		КлючПоложения.Добавить("НалогообложениеНДС");
	Иначе
		Элементы.НалогообложениеНДС.Видимость = Ложь;
	КонецЕсли;

	Если Параметры.СпециальныйНалоговыйРежимЕстьРеквизит Тогда
		СпециальныйНалоговыйРежим = Параметры.СпециальныйНалоговыйРежим;
		КлючПоложения.Добавить("СпециальныйНалоговыйРежим");
		
		Если Параметры.Свойство("Организация")
			И ЗначениеЗаполнено(Параметры.Организация)
			И Параметры.Организация.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо Тогда
			
			РежимПСН = Перечисления.СпециальныеНалоговыеРежимы.ПСН;
			ДоступныеРежимы = Новый Массив;
			Для Каждого Значение Из Перечисления.СпециальныеНалоговыеРежимы Цикл
				Если Значение <> РежимПСН И СпециальныйНалоговыйРежим <> РежимПСН  Тогда
					ДоступныеРежимы.Добавить(Значение);
				КонецЕсли;
			КонецЦикла;
			ОтборРежима = Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(ДоступныеРежимы));
			
			ПараметрыВыбораРежима = Новый Массив;
			ПараметрыВыбораРежима.Добавить(ОтборРежима);
			Элементы.СпециальныйНалоговыйРежим.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораРежима);
		КонецЕсли;
	Иначе
		Элементы.СпециальныйНалоговыйРежим.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.СуммаВключаетНДСЕстьРеквизит Тогда
		СуммаВключаетНДС = Параметры.СуммаВключаетНДС;
		КлючПоложения.Добавить("СуммаВключаетНДС");
	Иначе
		Элементы.СуммаВключаетНДС.Видимость = Ложь;
	КонецЕсли;	
	
	Если Параметры.НДСВключатьВСтоимостьЕстьРеквизит Тогда
		НДСВключатьВСтоимость = Параметры.НДСВключатьВСтоимость;
		КлючПоложения.Добавить("НДСВключатьВСтоимость");
	Иначе
		Элементы.НДСВключатьВСтоимость.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметрыДоговора(КлючПоложения)
	
	Если Параметры.ДоговорЕстьРеквизит Тогда
		
		Договор = Параметры.Договор;
		ВалютаРасчетов = Параметры.Договор.ВалютаРасчетов;
		РасчетыВУЕ = Параметры.Договор.РасчетыВУсловныхЕдиницах;
		КурсРасчетов = Параметры.Курс;
		КратностьРасчетов = Параметры.Кратность;
		
		КлючПоложения.Добавить("Договор");
		
		Если Параметры.ЭтоСчетФактура Тогда
			
			Элементы.ВалютаРасчетов.Видимость = Ложь;
			Элементы.КурсРасчетов.Видимость = Ложь;
			Элементы.КратностьРасчетов.Видимость = Ложь;
			
			КлючПоложения.Добавить("ЭтоСчетФактура");
			
		КонецЕсли;
		
		НовыйМассив = Новый Массив;
		Если РасчетыВУЕ И ВалютаУчета <> ВалютаРасчетов Тогда
			НовыйМассив.Добавить(ВалютаУчета);
		КонецЕсли;
		НовыйМассив.Добавить(ВалютаРасчетов);
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(НовыйМассив));
		НовыйМассив2 = Новый Массив;
		НовыйМассив2.Добавить(НовыйПараметр);
		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив2);
		Элементы.Валюта.ПараметрыВыбора = НовыеПараметры;
		
	Иначе
		
		Элементы.ВалютаРасчетов.Видимость = Ложь;
		Элементы.КурсРасчетов.Видимость = Ложь;
		Элементы.КратностьРасчетов.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьФлажкаПерезаполнитьЦены(КлючПоложения)
	Если Не (Параметры.ВидЦенЕстьРеквизит Или Параметры.ВидЦенКонтрагентаЕстьРеквизит) Тогда
		Элементы.ПерезаполнитьЦены.Видимость = Ложь;
		КлючПоложения.Добавить("НеПерезаполнятьЦены");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьПодсказкуВидаЦен(КлючПоложения)
	
	Если Не ЦенообразованиеСерверПовтИсп.МинимальныеЦеныИспользуются() Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительнаяИнформацияМинимальныеЦены = "";
	Если СтрНайти(Параметры.ДополнительнаяИнформацияМинимальныеЦены, "%1") > 1 Тогда
		
		ОбщийВидМинимальныхЦен = ЦенообразованиеСерверПовтИсп.ПолучитьОбщийВидМинимальныхЦен();
		ДополнительнаяИнформацияМинимальныеЦены = СтрШаблон(Параметры.ДополнительнаяИнформацияМинимальныеЦены,
			ОбщийВидМинимальныхЦен);
			
	КонецЕсли;
		
	СтрокаШаблона = "";
	
	Если ЗначениеЗаполнено(Параметры.СтруктурныеЕдиницы) Тогда

		Если Параметры.СтруктурныеЕдиницы.Количество() > 0 Тогда

			ВидМинимальнойЦены = ЦенообразованиеСерверПовтИсп.ПолучитьВидМинимальныхЦен(Параметры.СтруктурныеЕдиницы[0]);
			Если Не ЗначениеЗаполнено(ВидМинимальнойЦены) Тогда
				ВидМинимальнойЦены = НСтр("ru = '<Не указан>'");
			КонецЕсли;

			Если Параметры.СтруктурныеЕдиницы.Количество() = 1 Тогда

				СтрокаШаблона = НСтр("ru = 'Минимальные цены: %1'");
				Элементы.ВидЦенРасширеннаяПодсказка.Заголовок = СтрШаблон(СтрокаШаблона
					+ ДополнительнаяИнформацияМинимальныеЦены, ВидМинимальнойЦены);

			Иначе

				Количество = Параметры.СтруктурныеЕдиницы.Количество() - 1;
				СтрокаШаблона = НСтр("ru = 'Минимальные цены: %1 и еще %2'");

				Элементы.ВидЦенРасширеннаяПодсказка.Заголовок = СтрШаблон(СтрокаШаблона
					+ ДополнительнаяИнформацияМинимальныеЦены, ВидМинимальнойЦены, Количество);

			КонецЕсли;

		КонецЕсли;

	Иначе

		ВидМинимальныхЦен = ЦенообразованиеСерверПовтИсп.ПолучитьВидМинимальныхЦен(Параметры.СтруктурнаяЕдиница);
		СтрокаШаблона = НСтр("ru = 'Минимальные цены: %1'");
		Элементы.ВидЦенРасширеннаяПодсказка.Заголовок = СтрШаблон(СтрокаШаблона, ВидМинимальныхЦен);

	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаШаблона) Тогда
		КлючПоложения.Добавить(СтрокаШаблона);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ЕстьОшибкиВЗаполненииПолей()
	
	Результат = Ложь;
	
	НеЗаполненВидЦен(Результат);
	НеЗаполненВидЦенКонтрагента(Результат);
	НеЗаполненаВалютаДокумента(Результат);
	НеЗаполненоНалогообложениеНДС(Результат);
	НеЗаполненСпециальныйНалоговыйРежим(Результат);
	НеЗаполненыКурсИлиКратностьРасчетов(Результат);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура НеЗаполненВидЦен(Результат)

	Если ЗначениеЗаполнено(ВидЦен) Тогда
		Возврат;
	КонецЕсли;

	Если Не ПерезаполнитьЦены Тогда
		Возврат;
	КонецЕсли;

	Если Не Параметры.ВидЦенЕстьРеквизит Тогда
		Возврат;
	КонецЕсли;

	Если ЗначениеЗаполнено(ДисконтнаяКарта) И Не ЗначениеЗаполнено(ВидСкидкиНаценки) Тогда
		Возврат;
	КонецЕсли;

	Результат = Истина;

	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = НСтр("ru = 'Не выбран вид цены для заполнения.'");
	Сообщение.Поле = "ВидЦен";
	Сообщение.Сообщить();

КонецПроцедуры

&НаКлиенте
Процедура НеЗаполненВидЦенКонтрагента(Результат)
	
	Если ЗначениеЗаполнено(ВидЦенКонтрагента) Тогда
		Возврат;
	КонецЕсли;
	
	Если (ПерезаполнитьЦены Или РегистрироватьЦеныПоставщика) И Параметры.ВидЦенКонтрагентаЕстьРеквизит Тогда
		Результат = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не заполнен вид цен контрагента.'");
		Сообщение.Поле = "ВидЦенКонтрагента";
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеЗаполненаВалютаДокумента(Результат)
	
	Если Параметры.ВалютаДокументаЕстьРеквизит И Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
		Результат = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не заполнена валюта документа.'");
		Сообщение.Поле = "ВалютаДокумента";
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеЗаполненоНалогообложениеНДС(Результат)
	
	Если Параметры.НалогообложениеНДСЕстьРеквизит И Не ЗначениеЗаполнено(НалогообложениеНДС) Тогда
		Результат = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не заполнено налогообложение.'");
		Сообщение.Поле = "НалогообложениеНДС";
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеЗаполненСпециальныйНалоговыйРежим(Результат)
	
	Если Параметры.СпециальныйНалоговыйРежимЕстьРеквизит И Не ЗначениеЗаполнено(СпециальныйНалоговыйРежим) Тогда
		Результат = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не заполнен специальный налоговый режим.'");
		Сообщение.Поле = "СпециальныйНалоговыйРежим";
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеЗаполненыКурсИлиКратностьРасчетов(Результат)
	
	Если Не Параметры.ДоговорЕстьРеквизит Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КурсРасчетов) Тогда
		Результат = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Обнаружен нулевой курс валюты расчетов'");
		Сообщение.Поле = "КурсРасчетов";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КратностьРасчетов) Тогда
		Результат = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Обнаружена нулевая кратность курса валюты расчетов.'");
		Сообщение.Поле = "КратностьРасчетов";
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция БылиВнесеныИзменения()

	Если ПерезаполнитьЦены Тогда
		Возврат Истина;
	КонецЕсли;

	Если ПересчитатьЦены Тогда
		Возврат Истина;
	КонецЕсли;

	Для Каждого ТекРеквизит Из ЦеныИВалютаКлиентСервер.НеобязательныеСвойства() Цикл
		Если Не Параметры[СтрШаблон("%1ЕстьРеквизит", ТекРеквизит)] Тогда
			Продолжить;
		КонецЕсли;
		Если ЭтотОбъект[ТекРеквизит] <> Параметры[ТекРеквизит] Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;

	Если Параметры.ДоговорЕстьРеквизит И Параметры.Курс <> КурсРасчетов Тогда
		Возврат Истина;
	КонецЕсли;

	Если Параметры.ДоговорЕстьРеквизит И Параметры.Кратность <> КратностьРасчетов Тогда
		Возврат Истина;
	КонецЕсли;

	Возврат Ложь;

КонецФункции

&НаКлиенте
Процедура ЗаполнитьКурсКратностьВалютыДокумента()

	Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
		Возврат;
	КонецЕсли;

	МассивКурсКратность = КурсыВалют.НайтиСтроки(Новый Структура("Валюта", ВалютаДокумента));
	
	Если ВалютаДокумента = ВалютаРасчетов И КурсРасчетов <> 0 И КратностьРасчетов <> 0 Тогда
		Курс = КурсРасчетов;
		Кратность = КратностьРасчетов;
	Иначе
		Если ЗначениеЗаполнено(МассивКурсКратность) Тогда
			Курс = МассивКурсКратность[0].Курс;
			Кратность = МассивКурсКратность[0].Кратность;
			Если ВалютаДокумента = ВалютаРасчетов Тогда
				КурсРасчетов = Курс;
				КратностьРасчетов = Кратность;
			КонецЕсли;
		Иначе
			Курс = 0;
			Кратность = 0;
		КонецЕсли;
	КонецЕсли;
	
	Если ВалютаДокумента <> УправлениеНебольшойФирмойПовтИсп.ПолучитьНациональнуюВалюту() Тогда
		КурсПересчетаЦен = Курс;
		КратностьПересчетаЦен = Кратность;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КурсРасчетовОбработкаВыбораЗавершение(ДатаКурса, ДополнительныеПараметры) Экспорт
	
	Если ДатаКурса <> Неопределено Тогда
		КурсРасчетовОбработкаВыбораНаСервере(ДатаКурса);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КурсПересчетаЦенОбработкаВыбораЗавершение(ДатаКурса, ДополнительныеПараметры) Экспорт
	
	Если ДатаКурса <> Неопределено Тогда
		КурсПересчетаЦенОбработкаВыбораНаСервере(ДатаКурса);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КурсРасчетовОбработкаВыбораНаСервере(ДатаКурса)
	
	КурсНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаКурса);
	КурсРасчетов = КурсНаДату.Курс;
	КратностьРасчетов = КурсНаДату.Кратность;
	
КонецПроцедуры

&НаСервере
Процедура КурсПересчетаЦенОбработкаВыбораНаСервере(ДатаКурса)
	
	КурсНаДату = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРасчетов, ДатаКурса);
	КурсПересчетаЦен = КурсНаДату.Курс;
	КратностьПересчетаЦен = КурсНаДату.Кратность;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовПереключенияЦенДляВозвратов(СпособИспользования)
	
	ЭтоПриходнаяНакладная = ТипОбъектаВладельца = "ПриходнаяНакладная";
	ЭтоРасходнаяНакладная = ТипОбъектаВладельца = "РасходнаяНакладная";
	
	Если ЭтоПриходнаяНакладная Тогда
		ВидЦенСтрокой1 = НСтр("ru = 'продажи'");
		ВидЦенСтрокой2 = НСтр("ru = 'поставщиков'");
	ИначеЕсли ЭтоРасходнаяНакладная Тогда
		ВидЦенСтрокой1 = НСтр("ru = 'поставщиков'");
		ВидЦенСтрокой2 = НСтр("ru = 'продажи'");
	Иначе
		ВидЦенСтрокой1 = "";
		ВидЦенСтрокой2 = "";
	КонецЕсли;
		
	Если СпособИспользования = Перечисления.СпособыИспользованияВидовЦенДляВозвратов.СтарыйСпособ Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ИнформацияПоПереходуНаВидыЦенПродажиДляВозвратов", "Видимость", Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ПереключитьИспользованиеВидовЦенДляВозвратов", "Видимость", 
			Ложь);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ВидЦен", "Видимость", ЭтоРасходнаяНакладная);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ВидЦенКонтрагента", "Видимость", ЭтоПриходнаяНакладная);
		
		Параметры.РегистрироватьЦеныПоставщикаЕстьРеквизит = Истина;
		Параметры.ВидЦенЕстьРеквизит = ЭтоРасходнаяНакладная;
		Параметры.ВидЦенКонтрагентаЕстьРеквизит = ЭтоПриходнаяНакладная;
		
		ПерезаполнитьЦены = Истина;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"РегистрироватьЦеныПоставщика", "Видимость", Параметры.ВидЦенКонтрагентаЕстьРеквизит);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ПереключитьИспользованиеВидовЦенДляВозвратов", 
			"ОтображениеПодсказки", ОтображениеПодсказки.Нет);
		
		СодержимоеСтроки = СтрШаблон(НСтр("ru = 'В следующих обновлениях в новых документах возврата будут использоваться виды цен %1, а не виды цен %2. Сейчас можно переключиться на новую функциональность вручную:'"),
			ВидЦенСтрокой1, ВидЦенСтрокой2);
			
		СодержимоеСсылки = Новый ФорматированнаяСтрока(
			СтрШаблон(НСтр("ru = 'использовать цены %1 для возвратов'"), ВидЦенСтрокой1),,,,
				НСтр("ru = 'переключить цены для возвратов'"));
			
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(СодержимоеСтроки);
		МассивСтрок.Добавить(СодержимоеСсылки);
		
		ФорматированнаяСтрока = Новый ФорматированнаяСтрока(МассивСтрок);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ПереходНаВидыЦенПродажиДляВозвратов", "Заголовок",
			ФорматированнаяСтрока);
		
	ИначеЕсли СпособИспользования = Перечисления.СпособыИспользованияВидовЦенДляВозвратов.НовыйСпособ Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ИнформацияПоПереходуНаВидыЦенПродажиДляВозвратов", "Видимость", Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ПереключитьИспользованиеВидовЦенДляВозвратов", "Видимость", Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ПереключитьИспользованиеВидовЦенДляВозвратов", "Заголовок", 
			СтрШаблон(НСтр("ru = 'Вернуть использование цен %1 для возвратов'"), ВидЦенСтрокой2));
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ВидЦен", "Видимость", ЭтоПриходнаяНакладная);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ВидЦенКонтрагента", "Видимость", ЭтоРасходнаяНакладная);
		
		Параметры.РегистрироватьЦеныПоставщикаЕстьРеквизит = ЭтоПриходнаяНакладная;
		Параметры.РегистрироватьЦеныПоставщика = Ложь;
		Параметры.ВидЦенЕстьРеквизит = ЭтоПриходнаяНакладная;
		Параметры.ВидЦенКонтрагентаЕстьРеквизит = ЭтоРасходнаяНакладная;
		
		ПерезаполнитьЦены = Истина;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"РегистрироватьЦеныПоставщика", "Видимость", Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ПереключитьИспользованиеВидовЦенДляВозвратов", 
			"ОтображениеПодсказки", ОтображениеПодсказки.Кнопка);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ПереключитьИспользованиеВидовЦенДляВозвратовРасширеннаяПодсказка", 
			"Заголовок", 
			СтрШаблон(НСтр("ru = 'В следующих обновлениях в новых документах возврата будут использоваться виды цен %1, а не виды цен %2. Эта функциональность уже включена.'")
				, ВидЦенСтрокой1, ВидЦенСтрокой2));
			
	Иначе
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ПереключениеИспользованияВидовЦенДляВозвратов", "Видимость", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПодсказкуПереходаНаВидыЦенПродажиДляВозвратов(КлючПоложения)
	
	Если ЭтоВозврат Тогда
		
		СпособИспользования = ЦенообразованиеСерверПовтИсп.ПолучитьСпособИспользованияВидовЦенДляВозвратов();
		
	Иначе
		
		СпособИспользования = Неопределено;
		
	КонецЕсли;
	
	УстановитьВидимостьЭлементовПереключенияЦенДляВозвратов(СпособИспользования);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СпособИспользованияЦенДляВозвратов()
	
	ЦенообразованиеСервер.ПереключитьСпособИспользованияЦенДляВозвратов();
	Возврат Константы.СпособИспользованияВидовЦенДляВозвратов.Получить();
	
КонецФункции

#Область ДисконтныеКарты

&НаСервереБезКонтекста
Функция ПолучитьВладельцаКарты(ДисконтнаяКарта)

	Возврат ДисконтнаяКарта.ВладелецКарты;

КонецФункции

// Процедура вызывается после выбора дисконтной карты из формы выбора справочника ДисконтныеКарты.
//
&НаКлиенте
Процедура ОткрытьФормуВыбораДисконтнойКартыЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда 
		ДисконтнаяКарта = РезультатЗакрытия;
	
		Если Параметры.ДисконтнаяКарта <> ДисконтнаяКарта Тогда
			
			ПерезаполнитьЦены = Истина;
			
		КонецЕсли;
	КонецЕсли;
	
	// Мог измениться % накопительной скидки, т.ч. обновляем надпись, даже если дисконтная карта не поменялась.
	НастроитьНадписьПоДисконтнойКарте();
	
КонецПроцедуры

// Процедура заполняет подсказку дисконтной карты информацией о скидке по дисконтной карте.
//
&НаСервере
Процедура НастроитьНадписьПоДисконтнойКарте()
	
	Если ЗначениеЗаполнено(ДисконтнаяКарта) Тогда
		Если Не Контрагент.Пустая() И ДисконтнаяКарта.Владелец.ЭтоИменнаяКарта И ДисконтнаяКарта.ВладелецКарты
			<> Контрагент Тогда

			ДисконтнаяКарта = Справочники.ДисконтныеКарты.ПустаяСсылка();

			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Владелец дисконтной карты не совпадает с контрагентом в документе.'");
			Сообщение.Поле = "ДисконтнаяКарта";
			Сообщение.Сообщить();

		КонецЕсли;
	КонецЕсли;
	
	Если ДисконтнаяКарта.Пустая() Или Не ДисконтнаяКарта.Владелец.СтарыйМеханизмСкидок Тогда
		ПроцентСкидкиПоДисконтнойКарте = 0;
		Элементы.ДисконтнаяКарта.Подсказка = "";
	Иначе
		ПроцентСкидкиПоДисконтнойКарте = ДисконтныеКартыУНФСервер.ВычислитьПроцентСкидкиПоДисконтнойКарте(ДатаДокумента,
			ДисконтнаяКарта);
		Элементы.ДисконтнаяКарта.Подсказка = СтрШаблон(НСтр("ru = 'Скидка по карте составляет %1%%'"),
			ПроцентСкидкиПоДисконтнойКарте);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НалогообложениеНДСПриИзменении(Элемент)
	
	Если ЕстьКомиссияСНДС И НалогообложениеНДСИзДокумента = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДС")
		И Не НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДС") Тогда
		НалогообложениеНДС = НалогообложениеНДСИзДокумента;
		СтрокаСообщения = НСтр("ru = 'В табличной части присутствует комиссионная номенклатура облагаемая НДС. Тип налогообложения НДС не изменен.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаСообщения);
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура РегистрироватьЦеныПоставщикаExtendedTooltipОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки); 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
