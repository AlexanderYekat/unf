﻿#Область МаркировкаТоваровГИСМВызовСервераПереопределяемый

#Область ПрограммныйИнтерфейс

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяДокумента - Строка - имя документа, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, УправляемаяФорма - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
//
Процедура ПриПолученииФормыДокумента(ИмяДокумента, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если ИмяДокумента = "МаркировкаТоваровГИСМ" Тогда
		Если ВидФормы = "ФормаОбъекта" Тогда
			ВыбраннаяФорма = "ФормаДокументаУНФ";
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	ИначеЕсли ИмяДокумента = "ПеремаркировкаТоваровГИСМ" Тогда
		Если ВидФормы = "ФормаОбъекта" Тогда
			ВыбраннаяФорма = "ФормаДокументаУНФ";
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Получает массив номенклатуры КиЗ по переданному GTIN маркированного товара и списка номенклатуры КиЗ,
// подходящей под выбранные категории КиЗ в документе.
//
// Параметры:
//  СписокНоменклатураКиЗ	    - Массив - список номенклатуры КиЗ, отобранной по категориям КиЗ в документе.
//  GTIN					    - Массив - массив GTIN маркируемой номенклатуры.
//  СписокНоменклатурыРезультат - Массив - массив номенклатуры КиЗ.
//
Процедура ОтобратьНоменклатуруПоНомеруGTIN(СписокНоменклатураКиЗ, GTIN, СписокНоменклатурыРезультат) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура.Ссылка КАК НоменклатураКИЗ
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО (Номенклатура.Ссылка = ХарактеристикиНоменклатуры.Владелец
	|				ИЛИ Номенклатура.Ссылка = ХарактеристикиНоменклатуры.Владелец)
	|ГДЕ
	|	Номенклатура.Ссылка В (&СписокНоменклатураКиЗ)
	|	И ЕСТЬNULL(ХарактеристикиНоменклатуры.КиЗГИСМGTIN, Номенклатура.КиЗГИСМGTIN) В(&GTIN)";
	
	Запрос.УстановитьПараметр("GTIN", GTIN);
	Запрос.УстановитьПараметр("СписокНоменклатураКиЗ", СписокНоменклатураКиЗ);
	
	СписокНоменклатурыРезультат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("НоменклатураКИЗ");
	
КонецПроцедуры

// Получает массив GTIN для переданного товара
//
// Параметры:
//  Номенклатура	    - СправочникСсылка.Номенклатура - номенклатура (маркируемый товар).
//  Характеристика	    - СправочникСсылка.Номенклатура - характеристика номенклатуры (маркируемого товара).
//  СписокGTINРезультат - Массив - массив GTIN.
//
Процедура МассивGTINМаркированногоТовара(Номенклатура, Характеристика, СписокGTINРезультат) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Штрихкод
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Номенклатура = &Номенклатура
	|	И ШтрихкодыНоменклатуры.Характеристика = &Характеристика");
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	
	МассивШтрихкодов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Штрихкод");
	
	Для Каждого Штрихкод Из МассивШтрихкодов Цикл
		
		Если МенеджерОборудованияКлиентСервер.ПроверитьКорректностьGTIN(Штрихкод) Тогда
			СписокGTINРезультат.Добавить(Штрихкод);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
	
КонецФункции

#КонецОбласти

#КонецОбласти