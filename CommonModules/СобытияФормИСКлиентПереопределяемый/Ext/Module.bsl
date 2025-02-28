﻿#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытийФормы

// Клиентский обработчик проверки заполнения форм ГосИС
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - проверяемая форма
//   Отказ - Булево - Истина если проверка заполнения не пройдена
Процедура ПроверитьЗаполнение(Форма, Отказ) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Обрабатывает нажатие на гиперссылку со статусом обработки в ИС.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой произошло нажатие на гиперссылку,
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - значение гиперссылки форматированной строки,
//  СтандартнаяОбработка - Булево - признак стандартной (системной) обработки события.
//
Процедура ОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	Если Форма.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаЭлемента"
		И СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ГиперссылкаОткрытьФормуНастройкиПараметровНоменклатурыИС") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыОповещения = Новый Структура();
		ПараметрыОповещения.Вставить("Гиперссылка", НавигационнаяСсылкаФорматированнойСтроки);
		ПараметрыОповещения.Вставить("ИмяЭлемента", "НастройкаПараметровНоменклатурыИС");
		
		Оповестить("ГиперссылкаОткрытьФормуНастройкиПараметровНоменклатурыИС", ПараметрыОповещения, Форма);
		
		
	ИначеЕсли Форма.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаЭлемента"
		И СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ГиперссылкаОткрытьФормуНастройкиВидовУпаковокПоGTINИСМП") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыОповещения = Новый Структура();
		ПараметрыОповещения.Вставить("Гиперссылка", НавигационнаяСсылкаФорматированнойСтроки);
		ПараметрыОповещения.Вставить("ИмяЭлемента", "ОткрытьФормуНастройкиВидовУпаковокПоGTINИСМП");
		
		Оповестить("ГиперссылкаОткрытьФормуНастройкиВидовУпаковокПоGTINИСМП", ПараметрыОповещения, Форма);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчики событий обрабатываемых БГосИС в прикладных формах
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения - оповещаемая форма,
//  ИмяСобытия              - Строка           - имя события,
//  Параметр                - Произвольный     - параметр сообщения. Могут быть переданы любые необходимые данные,
//  Источник                - Произвольный     - источник события.
//  ДополнительныеПараметры - Структура        - дополнительные параметры обработки
Процедура ОбработкаОповещенияИС(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры) Экспорт
	
	ИнтеграцияИСУНФКлиент.ОбработкаОповещенияИС(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры);
	
КонецПроцедуры

// Переопределенный сценарий обработки оповещения прикладных объектов об изменениях в библиотечных.
//   Вызывается для обновления гиперссылок в прикладных документах и при необходимости выполнить дополнительные действия.
//   Для переопределения обработчика установить Событие.Обработано = Истина, для дополнения не менять это значение.
// 
// Параметры:
//   МестоВызова - Структура - сведения о месте в котором требуется обработка:
//    * Форма  - ФормаКлиентскогоПриложения     - источник вызова
//    * Объект - ДанныеФормыСтруктура - основной реквизит формы
//   Событие     - Структура - сведения о событии:
//    * Имя        - Строка       - имя события формы
//    * Параметр   - Произвольный - параметр события формы
//    * Источник   - Произвольный - источник события формы
//    * Обработано - Булево       - признак что событие уже обработано
//
Процедура ОбработкаОповещенияВФормеДокументаОснования(МестоВызова, Событие) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Выполняет переопределяемую команду
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения - форма, в которой расположена команда
//  Команда                 - КомандаФормы     - команда формы
//  ДополнительныеПараметры - Структура        - дополнительные параметры.
//
Процедура ВыполнитьПереопределяемуюКомандуИС(Форма, Команда, ДополнительныеПараметры) Экспорт
	
	ИнтеграцияИСУНФКлиент.ВыполнитьПереопределяемуюКомандуИС(Форма, Команда, ДополнительныеПараметры);
	
КонецПроцедуры

// Обработчики БГосИС элементов прикладных форм
//   Ограничения: не предполагает контекстный серверный вызов.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Произвольный - элемент-источник события "При изменении". Может быть любой идентификатор
//                                            (примеры: поле ввода, строка).
//   ДополнительныеПараметры - Структура    - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	ИнтеграцияИСУНФКлиент.ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

// Переопределяемая часть обработки события при изменении в формах списков.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма в которой возникло событие ПриИзменении.
//   Элемент - ТаблицаФормы - Элемент формы связанный со списком в котором возникло событие ПриИзменении.
Процедура СписокПриИзменении(Форма, Элемент) Экспорт

	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

// Обработчик переопределяемой команды формы.
//
// Параметры:
//  Форма   - ФормаКлиентскогоПриложения - форма объекта справочника или документа,
//  Команда - КомандаФормы     - команда формы.
Процедура ВыполнитьПереопределяемуюКоманду(Форма, Команда) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Выполняет процедуру разбиения строки табличной части. Установить СтандартнаяОбработка = Ложь при реализации.
// 
// Параметры:
//  СтандартнаяОбработка - Булево - признак библиотечной обработки события
//  ТабличнаяЧасть - ТабличнаяЧасть - Табличная часть объекта где происходит разбиение
//  ЭлементФормы   - ТаблицаФормы   - Элемент табличной части в пользовательском интерфейсе.
//  ПараметрыРазбиенияСтроки - См. ПараметрыРазбиенияСтроки
//  ОповещениеПослеРазбиения - ОписаниеОповещения - действия после разбиения (ожидаемый результат действия - новая строка)
Процедура РазбитьСтрокуТабличнойЧасти(СтандартнаяОбработка, ТабличнаяЧасть, ЭлементФормы, ПараметрыРазбиенияСтроки, ОповещениеПослеРазбиения) Экспорт
	
	ИнтеграцияИСУНФКлиент.РазбитьСтрокуТабличнойЧасти(СтандартнаяОбработка, ТабличнаяЧасть, ЭлементФормы, ПараметрыРазбиенияСтроки, ОповещениеПослеРазбиения);
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемоеОборудование

// Вызывается перед обработкой штрихкодов, не привязанных ни к одной номенклатуре.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - процедура, которую нужно вызвать после выполнения обработки,
//  Форма - ФормаКлиентскогоПриложения - форма, в которой отсканировали штрихкоды,
//  ИмяСобытия - Строка - имя события, инициировавшее оповещение,
//  Параметр - Структура - данные для обработки,
//  Источник - Произвольный - источник события.
Процедура ОбработкаОповещенияОбработаныНеизвестныеШтрихкоды(ОписаниеОповещения, Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если Источник = "ПодключаемоеОборудование"
		И ИмяСобытия = "НеизвестныеШтрихкоды"
		И Параметр.ФормаВладелец = Форма.УникальныйИдентификатор Тогда
		
		ДанныеШтрихкодов = Новый Массив;
		Для Каждого ПолученныйШтрихкод Из Параметр.ПолученыНовыеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		Для Каждого ПолученныйШтрихкод Из Параметр.ЗарегистрированныеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, ДанныеШтрихкодов);
		
	КонецЕсли;
	
КонецПроцедуры

// В процедуре нужно реализовать алгоритм преобразования данных из подсистемы подключаемого оборудования.
//
// Параметры:
//  Результат - Структура - со свойствами Штрихкод, Количество
//  Параметр  - Массив    - входящие данные.
Процедура ПреобразоватьДанныеСоСканераВСтруктуру(Результат, Параметр) Экспорт
	
	глПодключаемоеОборудованиеСобытиеОбработано = Истина;
	
	Если Параметр[1] = Неопределено Тогда
		Результат = Новый Структура("Штрихкод, Количество", Параметр[0], 1);    // Достаем штрихкод из основных данных
	Иначе
		Результат = Новый Структура("Штрихкод, Количество", Параметр[1][1], 1); // Достаем штрихкод из дополнительных данных
	КонецЕсли;
	
КонецПроцедуры

// В процедуре нужно реализовать алгоритм преобразования данных из подсистемы подключаемого оборудования.
//
// Параметры:
//  Результат - Массив - Массив структур со свойствами Штрихкод, Количество.
//  Параметр  - Массив - входящие данные.
Процедура ПреобразоватьДанныеСоСканераВМассив(Результат, Параметр) Экспорт
	
	МенеджерОборудованияКлиентПереопределяемый.ОбработатьСобытие();
	
	Если Параметр[1] = Неопределено Тогда
		ДанныеСтруктура = Новый Структура("Штрихкод, Количество", Параметр[0], 1);    // Достаем штрихкод из основных данных
	Иначе
		ДанныеСтруктура = Новый Структура("Штрихкод, Количество", Параметр[1][1], 1); // Достаем штрихкод из дополнительных данных
	КонецЕсли;
	
	Результат = Новый Массив;
	Результат.Добавить(ДанныеСтруктура);
	
КонецПроцедуры

Процедура ПриПолученииДанныхИзТСД(ОписаниеОповещения, Форма, РезультатВыполнения) Экспорт
	
	ИнтеграцияИСУНФКлиент.ПриПолученииДанныхИзТСД(ОписаниеОповещения, Форма, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОповещений

// Вызывает процедуру обработки подбора, если произошло оповещение из формы подбора.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура завершения подбора номенклатуры,
//  ИмяСобытия - Строка - имя события, о котором происходит оповещение,
//  Параметр - Произвольный - переданный в сообщение параметр,
//  Источник - ФормаКлиентскогоПриложения - форма, в которой произошло оповещение.
Процедура ОбработкаОповещенияПодборНоменклатуры(ОповещениеПриЗавершении, ИмяСобытия, Параметр, Источник) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Вызывает процедуру обработки подбора, если произошел выбор из формы подбора.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура завершения подбора номенклатуры,
//  ВыбранноеЗначение - Произвольный - результат выбора в подчиненной форме,
//  ИсточникВыбора - ФормаКлиентскогоПриложения - форма, где осуществлен выбор.
Процедура ОбработкаВыбораПодборНоменклатуры(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваровВДокументПродажи.Форма.Форма" Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

// Вызывает процедуру обработки выбора контрагента, если произошел выбор из формы выбора.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура завершения подбора номенклатуры,
//  ВыбранноеЗначение - Произвольный - результат выбора в подчиненной форме,
//  ИсточникВыбора - ФормаКлиентскогоПриложения - форма, где осуществлен выбор.
Процедура ОбработкаВыбораКонтрагента(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	Если СтрНачинаетсяС(ИсточникВыбора.ИмяФормы, "Справочник.Контрагенты") Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора серии.
// 
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - Форма для которой требуется обработать событие выбора.
//  ВыбранноеЗначение      - ОпределяемыйТип.СерияНоменклатуры - результат выбора.
//  ИсточникВыбора         - ФормаКлиентскогоПриложения - Форма, в которой произведен выбор.
//  ПараметрыУказанияСерий - Произвольный - параметры указания серий формы.
Процедура ОбработкаВыбораСерии(Форма, ВыбранноеЗначение, ИсточникВыбора, ПараметрыУказанияСерий) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#Область Номенклатура

// Выполняется при начале выбора номенклатуры. Требуется определить и открыть форму выбора.
//
// Параметры:
//  Владелец             - ФормаКлиентскогоПриложения  - Форма владелец (возможен владелец - элемент формы).
//  ВидыПродукции        - ПеречислениеСсылка.ВидыПродукцииИС, Массив Из ПеречислениеСсылка.ВидыПродукцииИС - Виды продукции.
//  СтандартнаяОбработка - Булево - Использовать стандартную обработку события.
//  ОписаниеОповещения   - ОписаниеОповещения - Вызывается при выборе значения в форме выбора.
//  Реквизиты            - Структура - параметры формы создания номенклатуры.
//
Процедура ПриНачалеВыбораНоменклатуры(Владелец, ВидыПродукции, СтандартнаяОбработка, ОписаниеОповещения=Неопределено, Знач Реквизиты = Неопределено) Экспорт
	
	ИнтеграцияИСМПУНФКлиент.ПриНачалеВыбораНоменклатуры(Владелец, ВидыПродукции, СтандартнаяОбработка, ОписаниеОповещения, Реквизиты);
	
КонецПроцедуры

// Выполняется при начале выбора упаковки номенклатуры. Требуется определить и открыть форму выбора.
//
// Параметры:
//  Владелец             - ФормаКлиентскогоПриложения  - Форма владелец (возможен владелец - элемент формы).
//  Номенклатура         - ОпределяемыйТип.Номенклатура - Номенклатура для отбора.
//  СтандартнаяОбработка - Булево - Использовать стандартную обработку события.
//  ОписаниеОповещения   - ОписаниеОповещения - Вызывается при выборе значения в форме выбора.
//  Реквизиты            - Структура - параметры формы создания номенклатуры.
//
Процедура ПриНачалеВыбораУпаковки(Владелец, Номенклатура, СтандартнаяОбработка, ОписаниеОповещения=Неопределено, Знач Реквизиты = Неопределено) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура);
	ПараметрыФормы.Вставить("Владелец", Номенклатура);
	ПараметрыФормы.Отбор.Вставить("Владелец", Номенклатура);
	ПараметрыФормы.Вставить("НеИспользоватьКлассификатор", Истина);
	
	ОткрытьФорму(
		"Справочник.ЕдиницыИзмерения.ФормаВыбора",
		ПараметрыФормы, Владелец,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

// Выполняется при выборе действия открытия формы для выбора элемента ссылочного типа в поле составного типа.
// Можно переопределить Параметры, например, ИмяФормы.
// Можно отключить стандартную обработку и определить свой обработчик выбора (не рекомендуется).
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения  - Форма из которой вызывается событие.
//  Элемент              - ПолеФормы - Поле формы для которого выполняется действие.
//  Параметры            - Структура - структура параметров из:
//   Вид      - Строка - вид метаданных, например, Справочник
//   Имя      - Строка - имя объекта метаданных, например, Организации
//   ИмяФормы - Строка - имя формы для выбора, например, ФормаВыбора.
//  СтандартнаяОбработка - Булево - Использовать стандартную обработку события.
//  ПараметрыОткрытияФормы - Структура - Параметры, которые будут переданы в открываемую форму.
//  ОписаниеОповещения     - ОписаниеОповещения - Описание оповещения о закрытии открываемой формы.
//
Процедура ПолеСоставногоТипаОткрытьФормуВыбора(Форма, Элемент, Параметры, СтандартнаяОбработка, ПараметрыОткрытияФормы, ОписаниеОповещения) Экспорт
	
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗначениеЭлементаФормыПоИмени(Элемент, Имя)
	
	ТипЭлемента = ТипЗнч(Элемент);
	Если ТипЭлемента = Тип("ТаблицаФормы") Тогда
		Результат = Неопределено;
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			Элемент.ТекущиеДанные.Свойство(Имя, Результат);
		КонецЕсли;
		Возврат Результат;
	ИначеЕсли ТипЭлемента = Тип("ФормаКлиентскогоПриложения") Тогда
		Результат = Неопределено;
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Элемент, Имя) Тогда
			Результат = Элемент[Имя];
		ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Элемент, "Объект")
			И ТипЗнч(Элемент.Объект) = Тип("ДанныеФормыСтруктура") Тогда
			Элемент.Объект.Свойство(Имя, Результат);
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;
	
	Возврат ЗначениеЭлементаФормыПоИмени(Элемент.Родитель, Имя);
	
КонецФункции

#КонецОбласти
