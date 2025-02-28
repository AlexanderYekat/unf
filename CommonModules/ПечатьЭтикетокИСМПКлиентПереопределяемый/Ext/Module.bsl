﻿#Область ПрограммныйИнтерфейс

// Открыват форму для выбора шаблона этикетки для печати.
// 
// Параметры:
// 	ДанныеДляПечати - Структура - Структура данных для печати.
// 	Форма - ФормаКлиентскогоПриложения - Источник (фарма) команды печати.
// 	СтандартнаяОбработка - Булево - Признак необходимости выполнять печать БГосИС.
// 	ДополнительныеПараметры - Структура - Дополнительные параметры для открытия формы.
Процедура ОткрытьФормуВыбораШаблонаЭтикеткиИСМППоДаннымПечати(
	ДанныеДляПечати, Форма, СтандартнаяОбработка, ДополнительныеПараметры=Неопределено) Экспорт
	
	Перем Оповещение;
	Перем ПереданныеПараметрыОткрытия;
	
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия = Новый Структура("АдресВХранилище", ПоместитьВоВременноеХранилище(ДанныеДляПечати));
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		
		ДополнительныеПараметры.Свойство("Оповещение", Оповещение);
		
		Если ДополнительныеПараметры.Свойство("Параметры", ПереданныеПараметрыОткрытия) Тогда
			Для Каждого КлючЗначение Из ПереданныеПараметрыОткрытия Цикл
				ПараметрыОткрытия.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	ОткрытьФорму(
		"Справочник.ШаблоныЭтикетокИЦенников.Форма.ФормаШтрихкодыЭтикетокИСМП",
		ПараметрыОткрытия,
		Форма,
		Новый УникальныйИдентификатор,,,
		Оповещение);
	
КонецПроцедуры

// Получает данные для печати и открывает форму обработки печати этикеток и ценников.
//
// Параметры:
//  ОбъектыПечати        - Структура        - структура с описанием данных печати:
//   * ОбъектыПечати - Массив из ПечатьЭтикетокИСМПКлиентСервер.СтурктураПечатиЭтикеткиОбувь - строки описания товаров
//     и кодов для печати
//   * Документ - ДокументСсылка.ЗаказНаЭмиссиюКодовМаркировкиСУЗ,
//     ОпределеямыйТип.ОснованиеЗаказНаЭмиссиюКодовМаркировкиИСМП - Документ, в рамках которого выполняется печать.
//   * КаждаяЭтикеткаНаНовомЛисте - Булево - Выводить разрыв страницы после каждой этикетки (для термопечати этикетки).
//  Форма                - УправляемаяФорма - форма-владелец из которой выполняется печать.
//  СтандартнаяОбработка - Булево           - Отключает печать встроенными средставами библиотеки.
Процедура ПечатьЭтикеткиИСМП(ДанныеПечати, Форма, СтандартнаяОбработка) Экспорт

	СтандартнаяОбработка = Ложь;
	
	ОписаниеКоманды = Новый Структура;
	ОписаниеКоманды.Вставить("Вид",            "Печать");
	ОписаниеКоманды.Вставить("Идентификатор",  "ЭтикеткаПоПереданнымДаннымОбувь");
	ОписаниеКоманды.Вставить("СтруктураДанных", ДанныеПечати);
	ОписаниеКоманды.Вставить("Представление",  НСтр("ru = 'Печать: Этикетка (одежда, обувь, табак...)';"));
	ОписаниеКоманды.Вставить("Форма",          Форма);
	
	ПечатьЭтикетокОбувь(ОписаниеКоманды);

	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииРТ


#Область ЭтикеткиИСМП

// Выполняет команду печати этикеток обуви
//
// Параметры:
//	ОписаниеКоманды - Структура - структура с описанием команды.
//
// Возвращаемое значение:
//	Неопределено
//
Функция ПечатьЭтикетокОбувь(ОписаниеКоманды) Экспорт
	
	Если ОписаниеКоманды.СтруктураДанных.ОбъектыПечати.Количество() = 0 Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Нет данных для печати этикеток обуви.';"));
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрКоманды = Новый Массив;
	ПараметрКоманды.Добавить(ПредопределенноеЗначение("Документ.МаркировкаТоваровИСМП.ПустаяСсылка"));
	
	ПараметрыПечати = Новый Структура();
	ПараметрыПечати.Вставить("КоличествоЭкземпеляров", 1);
	ПараметрыПечати.Вставить("Документ", ОписаниеКоманды.СтруктураДанных.Документ);
	ПараметрыПечати.Вставить("СтруктураДанных", ОписаниеКоманды.СтруктураДанных);
	ПараметрыПечати.Вставить("АдресВХранилище", "");
	ПараметрыПечати.Вставить("КаждаяЭтикеткаНаНовомЛисте", ОписаниеКоманды.СтруктураДанных.КаждаяЭтикеткаНаНовомЛисте);
	ПараметрыПечати.Вставить("РежимПечати", "ЭтикеткаКодМаркировкиИСМП");
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Обработка.ПечатьЭтикетокИЦенников",
		"ЭтикеткаКодМаркировкиИСМП",
		ПараметрКоманды,
		ОписаниеКоманды.Форма.ВладелецФормы,
		ПараметрыПечати);
		
КонецФункции

#КонецОбласти

#КонецОбласти

