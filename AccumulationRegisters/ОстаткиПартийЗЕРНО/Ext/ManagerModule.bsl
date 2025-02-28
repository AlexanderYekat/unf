﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Записывает движения документа в регистр.
// 
// Параметры:
//  ДополнительныеСвойства - Структура - Дополнительные свойства:
//   * ТаблицыДляДвижений - Структура - таблицы движений документа:
//     ** ТаблицаОстаткиПартийЗЕРНО - см. ПустаяТаблицаОстаткиПартийЗЕРНО
//  Движения - Структура - движения документа по регистрам:
//    * ОстаткиПартийЗЕРНО - РегистрНакопленияНаборЗаписей.ОстаткиПартийЗЕРНО - движения документа
//  Отказ - Булево - Отказ от проведения / записи движений
Процедура ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	Если Отказ Или ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаОстаткиПартийЗЕРНО.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияОстаткиПартийЗЕРНО = Движения.ОстаткиПартийЗЕРНО;
	ДвиженияОстаткиПартийЗЕРНО.Записывать = Истина;
	ДвиженияОстаткиПартийЗЕРНО.Загрузить(ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаОстаткиПартийЗЕРНО);
	
КонецПроцедуры

// Обновить движения при изменении статуса документа.
// 
// Параметры:
//  ДокументСсылка - ДокументСсылка - регистратор текущего регистра
Процедура ОбновитьДвиженияПриИзмененииСтатусаДокумента(ДокументСсылка) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Установить(ДокументСсылка);
	
	ДополнительныеСвойства = Новый Структура;
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(ДокументСсылка, ДополнительныеСвойства);
	Документы[ДополнительныеСвойства.ДляПроведения.МетаданныеДокумента.Имя].ИнициализироватьДанныеДокумента(
		ДокументСсылка, ДополнительныеСвойства, "ОстаткиПартийЗЕРНО");
	НаборЗаписей.Загрузить(ДополнительныеСвойства.ТаблицыДляДвижений["ТаблицаОстаткиПартийЗЕРНО"]);
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Пустая таблица остатки партий ЗЕРНО.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Пустая таблица остатки партий ЗЕРНО
Функция ПустаяТаблицаОстаткиПартийЗЕРНО() Экспорт
	Возврат СоздатьНаборЗаписей().Выгрузить();
КонецФункции

#КонецОбласти

#КонецЕсли
