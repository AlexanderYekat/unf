﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые разрешается редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	
	РедактируемыеРеквизиты.Добавить("Действует");
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

#Область ОбновлениеВерсииИБ

// Определяет настройки начального заполнения элементов.
//
// Параметры:
//  Настройки - Структура - настройки заполнения
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Истина;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы   - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	Если Справочники.АвтоматическиеСкидки.Выбрать().Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	Элемент = Элементы.Добавить();
	Элемент.Наименование = НСтр("ru='Без копеек'");
	Элемент.Действует = Ложь;
	Элемент.СпособПредоставления = Перечисления.СпособыПредоставленияСкидокНаценок.Округление;
	Элемент.Назначение = Перечисления.НазначенияАвтоматическихСкидок.Везде;
	Элемент.ОбластьПредоставления = Перечисления.ВариантыОбластейОграниченияСкидокНаценок.ВДокументе;
	Элемент.ВариантОграниченияПоНоменклатуре = Перечисления.ВариантыОграниченийСкидокПоНоменклатуре.ПоНоменклатуре;
	Элемент.ВалютаПредоставления = Справочники.Валюты.ОсновнаяВалютаНачальногоЗаполнения();
	Элемент.ВариантОкругления = Перечисления.ВариантыОкругления.ПоАрифметическимПравилам;
	Элемент.ПорядокОкругления = Перечисления.ПорядкиОкругления.Окр1;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлемента
//
// Параметры:
//  Объект                  - СправочникОбъект.ВидыКонтактнойИнформации - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения объекта.
//  ДополнительныеПараметры - Структура:
//   * ПредопределенныеДанные - ТаблицаЗначений - данные заполненные в процедуре ПриНачальномЗаполненииЭлементов.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	Объект.УстановитьНовыйКод();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

// Функция - Шаблон процедуры расчета подключаемой скидки
//
// Параметры:
//  ИдентификаторСкидки - Строка - реквизит ИдентификаторДляРасчетаВРасширении справочника автоматических скидок
// 
// Возвращаемое значение:
//  Строка - многострочная строка для формы помощника добавления расширения
//
Функция ШаблонПроцедурыПодключаемойСкидки(ИдентификаторСкидки) Экспорт
	
	// АПК:1299-выкл проектное решение
	ШаблонПроцедуры = 
		НСтр("ru = '
		|// Выполняет произвольный алгоритм расчета скидок, и добавляет сработавшие скидки для каждой строки в таблицу ТаблицаСкидок.
		|// Результат расчета помещает в параметр ТаблицаСкидок.
		|// 
		|// Параметры:
		|//  СтрокаДерева		- см. СкидкиНаценкиСервер.ПолучитьДеревоСкидок - Строка дерева действующих скидок, с учетом групп совместного применения
		|//  ПараметрыРасчета	- см. СкидкиНаценкиСервер.ПодготовитьПараметрыРасчетаСкидок - Параметры текущего документа, необходимые для расчета скидок
		|//  ТаблицаСкидок		- см. СкидкиНаценкиСервер.ПолучитьПустуюТаблицуСкидокСРасшифровкой - Таблица скидок, которые следует применить к документу.
		|//  							Осуществляется возврат изменений параметра в вызывающую функцию.
		|Процедура ЗаполнитьТаблицуСкидок_%1(Знач СтрокаДерева, Знач ПараметрыРасчета, ТаблицаСкидок) Экспорт
		|		
		|	ПараметрыРасчетаСкидки = СкидкиНаценкиСервер.ПолучитьПараметрырасчетаПроизвольнойСкидки(СтрокаДерева, ПараметрыРасчета);
		|	// Таблица сообщений, которые будут показаны кассиру в момент расчета скидки, или пробития чека (только в розничном канале продаж)
		|	ТаблицаСообщений 	= СкидкиНаценкиСервер.ПустаяТаблицаСообщений();
		|	// Таблица подарков, которые следует предоставить покупателю. В данной таблице присутствуют только подарки, которые следует выдать на кассе.
		|	// Подарки, которые покупатель берет самостоятельно (например ""Три по цене двух"") предоставляются в виде скидок, добавлять их в таблицу не нужно.
		|	ТаблицаПодарков 	= СкидкиНаценкиСервер.ПустаяТаблицаПодарков();
		|	Для Каждого Товар Из ПараметрыРасчетаСкидки.Товары Цикл
		|		
		|		// Каждая примененная скидка добаляется в специальную таблицу, связанную с табличной частью товаров 
		|		НоваяСтрока           = ТаблицаСкидок.Добавить();
		|		НоваяСтрока.КлючСвязи = Товар.КлючСвязи;
		|		Если ПараметрыРасчетаСкидки.СтрокиСНевыполненнымиУсловиями.Найти(Товар.КлючСвязи) = Неопределено Тогда
		|			НоваяСтрока.Действует = Истина;
		|		Иначе
		|			// Скидка не применится, но она сохраняется в таблице для отображения в расшифровке расчета
		|			// Тогда можно будет увидеть, какие конкретно условия не выполнились
		|			НоваяСтрока.Действует = Ложь;
		|		КонецЕсли;
		|				
		|		Сумма = Товар.Сумма;
		|
		|#Область ПереопределяемыйАлгоритмРасчетаСуммыСкидки
		|
		|		ЗначениеСкидкиНаценки = ПараметрыРасчетаСкидки.ЗначениеСкидкиНаценки;
		|		СуммаСкидки = Окр((ЗначениеСкидкиНаценки / 100) * Сумма, 2);				
		|
		|#КонецОбласти		
		|
		|		НоваяСтрока.Сумма = СуммаСкидки;
		|		НоваяСтрока.ЗначениеСкидкиНаценки = ЗначениеСкидкиНаценки;
		|		НоваяСтрока.ТаблицаСообщений = ТаблицаСообщений;
		|		НоваяСтрока.ТаблицаПодарков = ТаблицаПодарков;
		|		// Информация для отображения в расшифровке расчета скидок
		|		Комментарий = ""Сумма "" + Сумма + "" * "" + ЗначениеСкидкиНаценки + ""%"";
		|		НоваяСтрока.Расшифровка = СкидкиНаценкиСервер.ПолучитьРасшифровкуСкидки(СтрокаДерева, НоваяСтрока.Сумма, ПараметрыРасчета, Комментарий, ЗначениеСкидкиНаценки);
		|		
		|	КонецЦикла;		
		|КонецПроцедуры
		|'");
	// АПК:1299-вкл
	
	АдаптированныйИдентификатор = СтрЗаменить(ИдентификаторСкидки, "-", "_");
	ШаблонПроцедуры = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПроцедуры, АдаптированныйИдентификатор);
	
	Возврат ШаблонПроцедуры;
	
КонецФункции

#КонецОбласти

#КонецЕсли
