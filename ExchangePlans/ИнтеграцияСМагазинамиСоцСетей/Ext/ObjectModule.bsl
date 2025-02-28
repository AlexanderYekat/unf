﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	СтрШаблон = "Магазин ВКонтакте (%1)";
	Наименование = СтрШаблон(СтрШаблон, НаименованиеГруппы);
	
	Если НЕ ЗначениеЗаполнено(КоличествоФотографийДляКарточки) Тогда
		КоличествоФотографийДляКарточки = 1;
	КонецЕсли;
	
	ЕстьОтборПоСкладам = СтруктурныеЕдиницы.Количество();
	
	ДополнительныеСвойства.Вставить("ОбновитьРасписание",
	ИспользоватьРегламентныеЗадания И РасписаниеРегламентногоЗадания <> Ссылка.РасписаниеРегламентногоЗадания);
	
	Если НастройкаЗавершена Тогда
		
		МассивВидовЦен = Новый Массив;
		Если ВидЦеныНоменклатуры <> Ссылка.ВидЦеныНоменклатуры Тогда
			МассивВидовЦен.Добавить(ВидЦеныНоменклатуры);
		КонецЕсли;
		
		Если ВидЦеныНоменклатурыСтарая <> Ссылка.ВидЦеныНоменклатурыСтарая Тогда
			МассивВидовЦен.Добавить(ВидЦеныНоменклатурыСтарая);
		КонецЕсли;
		
		Если ВыгружатьЦены И МассивВидовЦен.Количество() Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ЦеныНоменклатурыСрезПоследних.Период КАК Период,
			|	ЦеныНоменклатурыСрезПоследних.ВидЦен КАК ВидЦен,
			|	ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
			|	ЦеныНоменклатурыСрезПоследних.Характеристика КАК Характеристика
			|ИЗ
			|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
			|			,
			|			ВидЦен В (&МассивВидовЦен)
			|				И (Номенклатура, Характеристика) В
			|					(ВЫБРАТЬ
			|						НоменклатураХарактеристикДляМагазинаСоцСетей.Номенклатура КАК Номенклатура,
			|						НоменклатураХарактеристикДляМагазинаСоцСетей.Характеристика КАК Характеристика
			|					ИЗ
			|						РегистрСведений.НоменклатураХарактеристикДляМагазинаСоцСетей КАК НоменклатураХарактеристикДляМагазинаСоцСетей
			|					ГДЕ
			|						НоменклатураХарактеристикДляМагазинаСоцСетей.УзелИнформационнойБазы = &УзелИнформационнойБазы)) КАК ЦеныНоменклатурыСрезПоследних";
			
			Запрос.УстановитьПараметр("МассивВидовЦен", МассивВидовЦен);
			Запрос.УстановитьПараметр("УзелИнформационнойБазы", Ссылка);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			МассивИзменений = Новый Массив;
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
				НЗ = РегистрыСведений.ЦеныНоменклатуры.СоздатьНаборЗаписей();
				НЗ.Отбор.Период.Установить(ВыборкаДетальныеЗаписи.Период);
				НЗ.Отбор.ВидЦен.Установить(ВыборкаДетальныеЗаписи.ВидЦен);
				НЗ.Отбор.Номенклатура.Установить(ВыборкаДетальныеЗаписи.Номенклатура);
				НЗ.Отбор.Характеристика.Установить(ВыборкаДетальныеЗаписи.Характеристика);
				
				МассивИзменений.Добавить(НЗ);
			КонецЦикла;
			
			Для Каждого СтрДанные Из МассивИзменений Цикл
				ПланыОбмена.ЗарегистрироватьИзменения(Ссылка, СтрДанные);
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	ПланыОбмена.ИнтеграцияСМагазинамиСоцСетей.УдалитьРегламентноеЗаданиеОбмена(Ссылка);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	ОбновитьРасписание = ДополнительныеСвойства.Свойство("ОбновитьРасписание") И ДополнительныеСвойства.ОбновитьРасписание;
	
	Если ПометкаУдаления Или НЕ ИспользоватьРегламентныеЗадания Или ОбновитьРасписание Тогда
		ПланыОбмена.ИнтеграцияСМагазинамиСоцСетей.УдалитьРегламентноеЗаданиеОбмена(Ссылка, ОбновитьРасписание);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли