﻿
#Область ПрограммныйИнтерфейс

// Процедура позволяет переопределить начальное заполнение пользовательских настроек
//
// @skip-warning
Процедура ПереопределитьНачальноеЗаполнениеНастроекПодбора(Пользователь, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры // ПереопределитьНачальноеЗаполнениеНастроекПодбора()

#Область ПолнотекстовыйПоиск

// Функция - Поиск товаров по строке
//
// Параметры:
//  СтрокаПоиска	 - Строка	 - Искомая строка
//  ОписаниеОшибки	 - Строка	 - Текст ошибки. Если пустая строка - ошибок нет
// 
// Возвращаемое значение:
//  Структура - Структура результата. Обязательные свойства:
//		Номенклатура - Массив
//		ХарактеристикиНоменклатуры - Массив
//
Функция ПоискТоваров(СтрокаПоиска, ОписаниеОшибки) Экспорт
	
	РезультатПоиска = Новый Структура;
	РезультатПоиска.Вставить("Номенклатура", Новый Массив);
	РезультатПоиска.Вставить("ХарактеристикиНоменклатуры", Новый Массив);
	
	Результат = ПолнотекстовыйПоискТоваров(СтрокаПоиска, РезультатПоиска);
	
	Если Результат = "ВыполненоУспешно" Тогда
		
		Возврат РезультатПоиска;
		
	ИначеЕсли Результат = "СлишкомМногоРезультатов" Тогда
		
		ОписаниеОшибки = НСтр("ru = 'Слишком много результатов. Уточните запрос.'");
		Возврат РезультатПоиска;
		
	ИначеЕсли Результат = "НичегоНеНайдено" Тогда
		
		ОписаниеОшибки = НСтр("ru = 'Ничего не найдено'");
		Возврат РезультатПоиска;
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Неизвестная ошибка'");
		
	КонецЕсли;
	
КонецФункции

// Функция - Возвращает запрос поиска номенклатуры по штрихкоду
// 
// Возвращаемое значение:
//  Запрос - Возвращаемый запрос
//
Функция НовыйЗапросШтрихкодыНоменклатуры() Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Номенклатура КАК Номенклатура,
	|	ШтрихкодыНоменклатуры.Характеристика КАК Характеристика
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Штрихкод В(&МассивШтрихкодов)
	|	И ШтрихкодыНоменклатуры.Номенклатура ССЫЛКА Справочник.Номенклатура";
	
	Возврат Новый Запрос(ТекстЗапроса);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолнотекстовыйПоискТоваров(СтрокаПоиска, РезультатПоиска)
	
	МассивШтрихкодов = Новый Массив;
	
	// Поиск данных
	РазмерПорции = 200;
	ОбластьПоиска = Новый Массив;
	ОбластьПоиска.Добавить(Метаданные.Справочники.Номенклатура);
	ОбластьПоиска.Добавить(Метаданные.Справочники.ХарактеристикиНоменклатуры);
	ОбластьПоиска.Добавить(Метаданные.РегистрыСведений.ДополнительныеСведения);
	ОбластьПоиска.Добавить(Метаданные.РегистрыСведений.ШтрихкодыНоменклатуры);
	
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(СтрокаПоиска, РазмерПорции);
	СписокПоиска.ПолучатьОписание = Ложь;
	СписокПоиска.ПолучатьПредставление = Ложь;
	СписокПоиска.ОбластьПоиска = ОбластьПоиска;
	СписокПоиска.ПерваяЧасть();
	
	Если СписокПоиска.СлишкомМногоРезультатов() Тогда
		
		Возврат "СлишкомМногоРезультатов";
		
	КонецЕсли;
	
	Если СписокПоиска.ПолноеКоличество() = 0 Тогда
		
		Возврат "НичегоНеНайдено";
		
	КонецЕсли;
	
	Пока Истина Цикл
		
		Для Каждого Элемент Из СписокПоиска Цикл
			
			Если Элемент.Метаданные = Метаданные.Справочники.Номенклатура Тогда
				
				РезультатПоиска.Номенклатура.Добавить(Элемент.Значение);
				
			ИначеЕсли Элемент.Метаданные = Метаданные.Справочники.ХарактеристикиНоменклатуры Тогда
				
				РезультатПоиска.ХарактеристикиНоменклатуры.Добавить(Элемент.Значение);
				
			ИначеЕсли Элемент.Метаданные = Метаданные.РегистрыСведений.ДополнительныеСведения Тогда
				
				Если ТипЗнч(Элемент.Значение.Объект) = Тип("СправочникСсылка.Номенклатура") Тогда
					
					РезультатПоиска.Номенклатура.Добавить(Элемент.Значение.Объект);
					
				КонецЕсли;
				
			ИначеЕсли Элемент.Метаданные = Метаданные.РегистрыСведений.ШтрихкодыНоменклатуры Тогда
				
				МассивШтрихкодов.Добавить(Элемент.Значение.Штрихкод);
				
			Иначе
				
				ВызватьИсключение НСтр("ru = 'Неизвестная ошибка'");
				
			КонецЕсли;
			
		КонецЦикла;
		
		Попытка
			
			// Работать с общим размером выборки нельзя, так как он динамичен:
			// - пока мы обрабатываем результат может пройти операция обновления индекса
			//   поэтому работаем до первого исключения, после выходим с полученными данными.
			СписокПоиска.СледующаяЧасть();
			
		Исключение
			
			Прервать;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если МассивШтрихкодов.Количество() > 0 Тогда
		
		Запрос = НовыйЗапросШтрихкодыНоменклатуры();
		
		Запрос.УстановитьПараметр("МассивШтрихкодов", МассивШтрихкодов);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			РезультатПоиска.Номенклатура.Добавить(Выборка.Номенклатура);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат "ВыполненоУспешно";
	
КонецФункции

#КонецОбласти 

