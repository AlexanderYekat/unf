﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Формирует таблицу значение, содержащую данные для проведения по регистру.
// Таблицу значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаБонусныеБаллы(ДокументСсылкаНачислениеСписаниеБонусныхБаллов, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = РаботаСБонусами.СформироватьТекстЗапросаПоБонуснымБаллам();
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ТаблицаБонусныеБаллы = РезультатЗапроса[0].Выгрузить();
	ТаблицаОплатаБонусами = РезультатЗапроса[1].Выгрузить();
	
	Для Каждого СтрокаОплаты Из ТаблицаОплатаБонусами Цикл
		НоваяСтрока = ТаблицаБонусныеБаллы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОплаты);
	КонецЦикла;
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаБонусныеБаллы", ТаблицаБонусныеБаллы);
	
КонецПроцедуры

Процедура СформироватьТаблицаНачисленияБонусныхБаллов(ДокументСсылкаОтчетОРозничныхПродажах, СтруктураДополнительныеСвойства)
	
	Если ДокументСсылкаОтчетОРозничныхПродажах.НачисленияБонусов.Количество() = 0 Тогда
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаНачисленияБонусныхБаллов", Новый ТаблицаЗначений);
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = РаботаСБонусами.СформироватьТекстЗапросаПоНачислениямБонусныхБаллов();
	ТаблицаНачисленияБонусныхБаллов = Запрос.Выполнить().Выгрузить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаНачисленияБонусныхБаллов", ТаблицаНачисленияБонусныхБаллов);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаНачислениеСписаниеБонусныхБаллов, СтруктураДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачислениеСписаниеБонусныхБалловНачисленияБонусов.НомерСтроки КАК НомерСтроки,
	|	НачислениеСписаниеБонусныхБалловНачисленияБонусов.Ссылка.Дата КАК Период,
	|	НачислениеСписаниеБонусныхБалловНачисленияБонусов.БонуснаяКарта КАК БонуснаяКарта,
	|	НачислениеСписаниеБонусныхБалловНачисленияБонусов.АналитикаНачисленияБонусов КАК АналитикаНачисленияБонусов,
	|	НачислениеСписаниеБонусныхБалловНачисленияБонусов.Количество КАК Количество,
	|	НачислениеСписаниеБонусныхБалловНачисленияБонусов.ДатаНачисления КАК ДатаНачисления,
	|	НачислениеСписаниеБонусныхБалловНачисленияБонусов.ДатаСгорания КАК ДатаСгорания,
	|	НачислениеСписаниеБонусныхБалловНачисленияБонусов.Ссылка КАК Ссылка,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК Номенклатура,
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК Характеристика
	|ПОМЕСТИТЬ ВременнаяТаблицаНачисленияБонусов
	|ИЗ
	|	Документ.НачислениеСписаниеБонусныхБаллов.НачисленияБонусов КАК НачислениеСписаниеБонусныхБалловНачисленияБонусов
	|ГДЕ
	|	НачислениеСписаниеБонусныхБалловНачисленияБонусов.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НачислениеСписаниеБонусныхБалловСписанияБонусов.НомерСтроки КАК НомерСтроки,
	|	НачислениеСписаниеБонусныхБалловСписанияБонусов.Ссылка.Дата КАК Период,
	|	НачислениеСписаниеБонусныхБалловСписанияБонусов.БонуснаяКарта КАК БонуснаяКарта,
	|	НачислениеСписаниеБонусныхБалловСписанияБонусов.Количество КАК Количество,
	|	НачислениеСписаниеБонусныхБалловСписанияБонусов.КорректировкаКСписанию КАК КСписанию,
	|	НачислениеСписаниеБонусныхБалловСписанияБонусов.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВременнаяТаблицаСписанияБонусов
	|ИЗ
	|	Документ.НачислениеСписаниеБонусныхБаллов.СписанияБонусов КАК НачислениеСписаниеБонусныхБалловСписанияБонусов
	|ГДЕ
	|	НачислениеСписаниеБонусныхБалловСписанияБонусов.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаНачислениеСписаниеБонусныхБаллов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СформироватьТаблицаБонусныеБаллы(ДокументСсылкаНачислениеСписаниеБонусныхБаллов, СтруктураДополнительныеСвойства);
	СформироватьТаблицаНачисленияБонусныхБаллов(ДокументСсылкаНачислениеСписаниеБонусныхБаллов, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#КонецЕсли