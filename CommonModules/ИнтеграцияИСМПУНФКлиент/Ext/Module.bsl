﻿#Область СобытияФормИСМПКлиентПереопределяемый

// Клиентская переопределяемая процедура, вызываемая из обработчика события элемента.
//
// Параметры:
//   Форма                   - УправляемаяФорма - форма, из которой происходит вызов процедуры.
//   Элемент                 - Строка           - имя элемента-источника события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	Если Форма.ИмяФормы = "Документ.РасходнаяНакладная.Форма.ФормаДокумента"
		ИЛИ Форма.ИмяФормы = "Документ.ПриходнаяНакладная.Форма.ФормаДокумента"
		ИЛИ Форма.ИмяФормы = "Документ.КорректировкаРеализации.Форма.ФормаДокумента"
		ИЛИ Форма.ИмяФормы = "Документ.ПередачаТоваровМеждуОрганизациями.Форма.ФормаДокумента"
		ИЛИ Форма.ИмяФормы = "Документ.ОтчетОПереработке.Форма.ФормаДокумента"
		ИЛИ Форма.ИмяФормы = "Документ.ОтчетПереработчика.Форма.ФормаДокумента"
		ИЛИ Форма.ИмяФормы = "Документ.ЗаказПокупателя.Форма.ФормаЗаказНаряда" Тогда
		
		ИмяТабличнойЧасти = Форма.КэшДанныхГОСИС.ИмяТабличнойЧасти;
		КэшСтроки         = Форма.КэшДанныхГОСИС.ТекущаяСтрока;
		
		Если Элемент = ИмяТабличнойЧасти Тогда
			
			Если ДополнительныеПараметры.Свойство("ПередУдалением") Тогда
				Для Каждого СтрокаТовары Из Форма.Элементы[ИмяТабличнойЧасти].ВыделенныеСтроки Цикл
					Если Форма.Элементы[ИмяТабличнойЧасти].ДанныеСтроки(СтрокаТовары).МаркируемаяПродукция Тогда
						Форма.КэшДанныхГОСИС.Вставить("ТребуетсяПересчетМарокПослеУдаленияСтрок");
					КонецЕсли;
				КонецЦикла;
				Возврат;
			КонецЕсли;
			
			Если ДополнительныеПараметры.Свойство("ПослеУдаления") Тогда
				Если Форма.КэшДанныхГОСИС.Свойство("ТребуетсяПересчетМарокПослеУдаленияСтрок") Тогда
					Форма.КэшДанныхГОСИС.Удалить("ТребуетсяПересчетМарокПослеУдаленияСтрок");
					ДополнительныеПараметры.Вставить("ТребуетсяСерверныйВызов");
				КонецЕсли;
				Возврат;
			КонецЕсли;
			
			ТекущаяСтрока = Форма.Элементы[ИмяТабличнойЧасти].ТекущиеДанные;
			Если ТекущаяСтрока = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			Если НЕ ТекущаяСтрока.Номенклатура = КэшСтроки.Номенклатура
				ИЛИ НЕ ТекущаяСтрока.ЕдиницаИзмерения = КэшСтроки.ЕдиницаИзмерения Тогда
				ДополнительныеПараметры.Вставить("ТребуетсяСерверныйВызов");
				ДополнительныеПараметры.Вставить("ТребуетсяЗаполнениеСлужебныхРеквизитов", ТекущаяСтрока.ПолучитьИдентификатор());
			Иначе
				
				Если НЕ ТекущаяСтрока.Количество = КэшСтроки.Количество Тогда
					ТекущаяСтрока.КоличествоВБазовыхЕдиницахГосИС = ТекущаяСтрока.Количество * ТекущаяСтрока.КоэффициентЕдиницыИзмеренияГосИС;
				КонецЕсли;
				
				НужноПересчитатьКеш = ПроверкаИПодборПродукцииИСКлиент.ПрименитьКешПоСтроке(
					Форма,
					Форма.Объект[ИмяТабличнойЧасти],
					ТекущаяСтрока,
					КэшСтроки,,,
					"КоличествоВБазовыхЕдиницахГосИС");
				
				Если НужноПересчитатьКеш Тогда
					ДополнительныеПараметры.Вставить("ТребуетсяСерверныйВызов");
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли Форма.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаЭлемента"
		И Элемент = Форма.Элементы.ВидПродукцииИС Тогда
		ИнтеграцияИСУНФКлиентСервер.ЗаполнитьДанныеНастройкиПараметровНоменклатурыИС(Форма, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры) Экспорт
	
	Если СтрНачинаетсяС(ИмяСобытия, "ЗакрытиеФормыПроверкиИПодбораГосИС") Тогда
		ДополнительныеПараметры.СтандартнаяОбработка = Ложь;
		Если Источник = Форма.УникальныйИдентификатор Тогда
			ДополнительныеПараметры.ТребуетсяСерверныйВызов = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// В процедуре нужно реализовать алгоритм заполнения формы данными из ТСД.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - процедура, которую нужно вызвать после заполнения данных формы,
//  Форма - УправляемаяФорма - форма, данные в которой требуется заполнить,
//  РезультатВыполнения - (См. МенеджерОборудованияКлиент.ПараметрыВыполненияОперацииНаОборудовании).
Процедура ПриПолученииДанныхИзТСД(ОписаниеОповещения, Форма, РезультатВыполнения) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения.ТаблицаТоваров);
		
	Иначе
		
		СобытияФормИСКлиент.СообщитьОбОшибке(РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняется при начале выбора номенклатуры. Требуется определить и открыть форму выбора.
//
// Параметры:
//  Владелец             - ФормаКлиентскогоПриложения  - Форма владелец (возможен владелец - элемент формы).
//  ВидыПродукции        - ПеречислениеСсылка.ВидыПродукцииИС, Массив Из ПеречислениеСсылка.ВидыПродукцииИС - Виды продукции.
//  СтандартнаяОбработка - Булево - Использовать стандартную обработку события.
//  ОписаниеОповещения   - ОписаниеОповещения - Вызывается при выборе значения в форме выбора.
//  Реквизиты            - Структура - параметры формы создания номенклатуры.
//
Процедура ПриНачалеВыбораНоменклатуры(Владелец, ВидыПродукции, СтандартнаяОбработка, ОписаниеОповещения, Реквизиты) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ТипНоменклатуры", ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Запас"));
	
	// Формируем массив видов продукции, чтобы в форме установить отбор с условием ИЛИ по видам продукции
	ОтборВидПродукцииИС = Новый Массив;
	Если ТипЗнч(ВидыПродукции) = Тип("Массив") Тогда
		
		Для Каждого ВидПродукции Из ВидыПродукции Цикл
			
			Если ЗначениеЗаполнено(ВидПродукции) Тогда
			
				ОтборВидПродукцииИС.Добавить(ВидПродукции);
			
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли ЗначениеЗаполнено(ВидыПродукции) Тогда
		
		ОтборВидПродукцииИС.Добавить(ВидыПродукции);
		
	КонецЕсли;
	
	ПараметрыФормы  = Новый Структура;
	ПараметрыФормы.Вставить("ОтборВидПродукцииИС", ОтборВидПродукцииИС);
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", ПараметрыФормы, Владелец,,,, ОписаниеОповещения);
	
КонецПроцедуры

// Выполняется при начале выбора характеристики. Требуется определить и открыть форму выбора.
//
// Параметры:
//  Владелец     - УправляемаяФорма            - форма, в которой вызывается команда выбора характеристики.
//  ДанныеСтроки - ДанныеФормыЭлементКоллекции - текущие данные строки таблицы товаров откуда производится выбор.
//  СтандартнаяОбработка - Булево - Выключается в переопределении
//  Описание - ОписаниеОповещения - Вызывается при выборе значения в форме выбора.
//
Процедура ПриНачалеВыбораХарактеристики(
	Владелец, ДанныеСтроки, СтандартнаяОбработка, ИмяКолонкиНоменклатура, Описание) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("Отбор", Новый Структура("Владелец", ДанныеСтроки[ИмяКолонкиНоменклатура]));
	
	ОткрытьФорму("Справочник.ХарактеристикиНоменклатуры.ФормаВыбора", ПараметрыФормыВыбора, Владелец,,,, Описание);
	
КонецПроцедуры

// Выполняется при создании номенклатуры из формы МОТП. Требуется определить и открыть форму (диалога) создания номенклатуры.
//
// Параметры:
//  Владелец     - УправляемаяФорма            - Форма владелец.
//  ДанныеСтроки - ДанныеФормыЭлементКоллекции - текущие данные строки таблицы товаров откуда производится создание.
Процедура ПриСозданииНоменклатуры(Владелец, ДанныеСтроки, СтандартнаяОбработка, ВидПродукцииИС) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипНоменклатуры", ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Запас"));
	
	Если ВидПродукцииИС = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак") Тогда
		ПараметрыФормы.Вставить("ТабачнаяПродукция", Истина);
	ИначеЕсли ВидПродукцииИС = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Обувь") Тогда
		ПараметрыФормы.Вставить("ОбувнаяПродукция", Истина);
	КонецЕсли;
	
	Если ДанныеСтроки.Свойство("ПредставлениеНоменклатуры") Тогда
		ПараметрыФормы.Вставить("Наименование", ДанныеСтроки.ПредставлениеНоменклатуры);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", ПараметрыФормы, Владелец);
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора номенклатуры.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - Метод формы, который обрабатывает событие выбора.
//  ВыбранноеЗначение       - ОпределяемыйТип..Номенклатура - Результат выбора.
//  ИсточникВыбора          - УправляемаяФорма - Форма, в которой произведен выбор.
Процедура ОбработкаВыбораНоменклатуры(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	Если СтрНачинаетсяС(ИсточникВыбора.ИмяФормы, "Справочник.Номенклатура") Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при изменении номенклатуры в строке таблицы формы.
//
// Параметры:
//  Форма                  - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - текущие данные редактируемой строки таблицы товаров,
//  КэшированныеЗначения   - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураРеквизитов = УправлениеНебольшойФирмойВызовСервера.ЗначенияРеквизитовОбъекта(
		ТекущаяСтрока.Номенклатура,
		"ЕдиницаИзмерения, ИспользоватьХарактеристики, ТоварнаяНоменклатураВЭД",
		Истина);
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Упаковка") Тогда
		ТекущаяСтрока.Упаковка = СтруктураРеквизитов.ЕдиницаИзмерения;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ХарактеристикиИспользуются") Тогда
		ТекущаяСтрока.ХарактеристикиИспользуются = СтруктураРеквизитов.ИспользоватьХарактеристики;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "КодТНВЭД") Тогда
		ТекущаяСтрока.КодТНВЭД = СтруктураРеквизитов.ТоварнаяНоменклатураВЭД;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Серия") Тогда
		ДанныеСтроки = ИнтеграцияИСУНФКлиентСервер.ДанныеСтроки(ТекущаяСтрока, "ПроверитьСериюРассчитатьСтатус");
		ИмяФормы = Форма.ИмяФормы;
		ИнтеграцияИСМПУНФВызовСервера.ПроверитьСериюРассчитатьСтатус(ДанныеСтроки, ИмяФормы);
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ДанныеСтроки);
	КонецЕсли;
	
	СлужебныеРеквизиты = Новый Структура;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ТребуетВзвешивания") Тогда
		СлужебныеРеквизиты.Вставить("ТребуетВзвешивания");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ПроизвольнаяЕдиницаУчета") Тогда
		СлужебныеРеквизиты.Вставить("ПроизвольнаяЕдиницаУчета");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СкоропортящаясяПродукция") Тогда
		СлужебныеРеквизиты.Вставить("СкоропортящаясяПродукция", ТекущаяСтрока.СкоропортящаясяПродукция);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "АвтоматическийОСУИС") Тогда
		СлужебныеРеквизиты.Вставить("АвтоматическийОСУИС", ТекущаяСтрока.АвтоматическийОСУИС);
	КонецЕсли;
	
	Если СлужебныеРеквизиты.Количество() Тогда
		ИнтеграцияИСУНФКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтроки(Форма, ТекущаяСтрока, СлужебныеРеквизиты);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму подбора номенклатуры.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой вызывается команда открытия обработки сопоставления,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы подбора.
Процедура ОткрытьФормуПодбораНоменклатуры(Форма, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	Объект = Форма.Объект;
	ТипОбъекта = ТипЗнч(Объект.Ссылка);
	ЭтоПриходныйДокумент = Истина;
	ИмяТабличнойЧасти = Форма.ТекущийЭлемент.Имя;
	
	Если ТипОбъекта = Тип("ДокументСсылка.МаркировкаТоваровИСМП") ИЛИ ТипОбъекта = Тип("ДокументСсылка.ПеремаркировкаТоваровИСМП") Тогда
		ЭтоПриходныйДокумент = Истина;
	ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.СписаниеКодовМаркировкиИСМП") ИЛИ ТипОбъекта = Тип("ДокументСсылка.ВыводИзОборотаИСМП") Тогда
		ЭтоПриходныйДокумент = Ложь;
	Иначе
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЭтоМаркировка", Истина); 
	ПодборНоменклатурыВДокументахКлиент.ОткрытьФормуПодбораНоменклатуры(Форма,, ПараметрыФормы, ОповещениеПриЗавершении);
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора характеристики.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - Метод формы, который обрабатывает событие выбора.
//  ВыбранноеЗначение       - ОпределяемыйТип.ХарактеристикаНоменклатуры - результат выбора.
//  ИсточникВыбора          - УправляемаяФорма - Форма, в которой произведен выбор.
Процедура ОбработкаВыбораХарактеристики(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	Если СтрНачинаетсяС(ИсточникВыбора.ИмяФормы, "Справочник.ХарактеристикиНоменклатуры") Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при изменении подобранного количества в строке таблицы формы.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	СтруктураДействий = Новый Структура;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Упаковка") Тогда
		
		Если ТекущаяСтрока.КоличествоУпаковок = 0 Тогда
			ТекущаяСтрока.Количество = 0;
		Иначе
			Коэффициент = ?(ТипЗнч(ТекущаяСтрока.Упаковка) = Тип("СправочникСсылка.ЕдиницыИзмерения"),
							УправлениеНебольшойФирмойВызовСервера.ЗначениеРеквизитаОбъекта(ТекущаяСтрока.Упаковка, "Коэффициент"),
							1);
			Если Коэффициент <> 0 Тогда
				ТекущаяСтрока.Количество = ТекущаяСтрока.КоличествоУпаковок * Коэффициент;
			Иначе
				ТекстИсключения = НСтр("ru = 'При попытке пересчета количества из %ЕдИзмерения% превышена допустимая разрядность.'");
				ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ЕдИзмерения%", ТекущаяСтрока.Упаковка);
				
				ТекущаяСтрока.Количество = 0;
				ТекущаяСтрока.КоличествоУпаковок = 0;
				ТекущаяСтрока.Упаковка = ПредопределенноеЗначение("Справочник.ЕдиницыИзмерения.ПустаяСсылка");
				
				ВызватьИсключение ТекстИсключения;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Форма.ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаДокумента" Тогда
		
		ПараметрыРасчета = Новый Структура("РассчитатьСумму, СуммаВключаетНДС", Истина, Истина);
		ТабличныеЧастиУНФКлиент.РассчитатьСуммыВСтрокеТЧ(ТекущаяСтрока, ПараметрыРасчета);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при изменении суммы в строке таблицы формы.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров
Процедура ПриИзмененииСуммы(Форма, ТекущаяСтрока) Экспорт
	
	Если Форма.ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаДокумента" Тогда
		
		ПараметрыРасчета = Новый Структура("РассчитатьЦену, СуммаВключаетНДС", Истина, Истина);
		ТабличныеЧастиУНФКлиент.РассчитатьСуммыВСтрокеТЧ(ТекущаяСтрока, ПараметрыРасчета);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при изменении цены в строке таблицы формы.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров
Процедура ПриИзмененииЦены(Форма, ТекущаяСтрока) Экспорт
	
	Если Форма.ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаДокумента" Тогда
		
		ПараметрыРасчета = Новый Структура("РассчитатьСумму, СуммаВключаетНДС", Истина, Истина);
		ТабличныеЧастиУНФКлиент.РассчитатьСуммыВСтрокеТЧ(ТекущаяСтрока, ПараметрыРасчета);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при изменении ставки НДС в строке таблицы формы.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров
Процедура ПриИзмененииСтавкиНДС(Форма, ТекущаяСтрока) Экспорт
	
	Если Форма.ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаДокумента" Тогда
	
		ПараметрыРасчета = Новый Структура("РассчитатьСумму, СуммаВключаетНДС", Истина, Истина);
		ТабличныеЧастиУНФКлиент.РассчитатьСуммыВСтрокеТЧ(ТекущаяСтрока, ПараметрыРасчета);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриНачалеВыбораКодТНВЭД(Владелец, ДанныеСтроки, СтандартнаяОбработка, Описание = Неопределено) Экспорт
	
	Если ДанныеСтроки <> Неопределено Тогда
		
		ПараметрыФормы = Новый Структура;
		
		ТНВЭД = ИнтеграцияИСМПВызовСервера.КлассификаторТНВЭДПоКоду(ДанныеСтроки.КодТНВЭД);
		Если ЗначениеЗаполнено(ТНВЭД) Тогда
			ПараметрыФормы.Вставить("ТекущаяСтрока", ТНВЭД);
		КонецЕсли;
		
		ОткрытьФорму("Справочник.КлассификаторТНВЭД.ФормаВыбора", ПараметрыФормы, Владелец,,,, Описание);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСлужебныеРеквизитыИСМПВСтрокеТЧ(СтрокаТЧ, СтруктураДанные) Экспорт
	
	СписокСвойств = "
		|МаркируемаяПродукция,
		|ВидПродукцииИС";
	
	ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтруктураДанные, СписокСвойств);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Получает данные для печати и открывает форму обработки печати этикеток и ценников.
//
// Параметры:
//	ОписаниеКоманды - Структура - структура с описанием команды.
//
// Возвращаемое значение:
//	Неопределено
//
Функция ПечатьШтрихкодовУпаковок(ОписаниеКоманды) Экспорт
	
	ДанныеДляПечати = ИнтеграцияИСМПУНФВызовСервера.ДанныеДляПечатиШтрихкодовУпаковок(ОписаниеКоманды.ОбъектыПечати);
	
	ОткрытьФорму(
		"Справочник.ШаблоныЭтикетокИЦенников.Форма.ФормаШтрихкодыУпаковокИС",
		Новый Структура("АдресВХранилище", ДанныеДляПечати),
		ОписаниеКоманды.Форма,
		Новый УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти