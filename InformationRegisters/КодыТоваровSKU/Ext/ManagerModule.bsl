﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ОбновитьКоды_SKU_PLU(ТаблицаТоваров, СоздаватьSKU, ПравилоОбмена = Неопределено, ЗакончилисьSKU = Ложь) Экспорт
	
	Если СоздаватьSKU Тогда
		
		РазмерыСписков = РазмерыСписковТоваров(ТаблицаТоваров);
		
		Если НЕ РазмерыСписков.РазмерСпискаВесовыхТоваров = 0 Тогда
			СвободныеВесовыеSKU = СписокСвободныхВесовыхSKU(РазмерыСписков.РазмерСпискаВесовыхТоваров);
		Иначе
			СвободныеВесовыеSKU = Новый Массив;
		КонецЕсли;
		
		Если НЕ РазмерыСписков.РазмерСпискаШтучныхТоваров = 0 Тогда
			СвободныеШтучныеSKU = СписокСвободныхШтучныхSKU(РазмерыСписков.РазмерСпискаШтучныхТоваров);
		Иначе
			СвободныеШтучныеSKU = Новый Массив;
		КонецЕсли;
		
	КонецЕсли;
	
	PLU = ПолучитьМаксимальныйPLU(ПравилоОбмена);
	
	ОбновлятьКодыТоваровPLUНаОборудовании = Ложь;
	СвояНумерацияPLUНаОборудовании = Ложь;
	
	Если ЗначениеЗаполнено(ПравилоОбмена) Тогда
		ОбновлятьКодыТоваровPLUНаОборудовании = Истина;
		СвояНумерацияPLUНаОборудовании = ПравилоОбмена.СвояНумерацияPLUНаОборудовании;
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из ТаблицаТоваров Цикл
		
		Если СоздаватьSKU И НЕ ЗначениеЗаполнено(СтрокаТЧ.SKU) ИЛИ СтрокаТЧ.SKU = 0 Тогда
			
			Если СтрокаТЧ.Весовой Тогда
				
				СвободныйВесовойSKU = ПолучитьСвободныйSKU(СвободныеВесовыеSKU);
				
				Если СвободныйВесовойSKU = Неопределено Тогда
					ЗакончилисьSKU = Истина;
					Продолжить;
				Иначе
					СтрокаТЧ.SKU = СвободныйВесовойSKU;
				КонецЕсли;
				
			Иначе
				
				СвободныйШтучныйSKU = ПолучитьСвободныйSKU(СвободныеШтучныеSKU);
				
				Если СвободныйШтучныйSKU = Неопределено Тогда
					ЗакончилисьSKU = Истина;
					Продолжить;
				Иначе
					СтрокаТЧ.SKU = СвободныйШтучныйSKU;
				КонецЕсли;
				
			КонецЕсли;
			
			ЗаписатьSKU(СтрокаТЧ.Номенклатура, СтрокаТЧ.Характеристика, СтрокаТЧ.Партия, СтрокаТЧ.ЕдиницаИзмерения ,  СтрокаТЧ.SKU);
			
		КонецЕсли;
		
		Если ОбновлятьКодыТоваровPLUНаОборудовании И ЗначениеЗаполнено(СтрокаТЧ.SKU) И НЕ ЗначениеЗаполнено(СтрокаТЧ.PLU) Тогда
			
			Если СвояНумерацияPLUНаОборудовании Тогда
				PLU = PLU + 1;
				СтрокаТЧ.PLU = PLU;
			Иначе
				СтрокаТЧ.PLU = СтрокаТЧ.SKU;
			КонецЕсли;
			
			ЗаписатьPLU(ПравилоОбмена, СтрокаТЧ.PLU, СтрокаТЧ.SKU);
			
			ЗарегистрироватьИзмененияДляОбмена(ПравилоОбмена, СтрокаТЧ.PLU);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОбновлятьКодыТоваровPLUНаОборудовании Тогда
		УдалитьНеиспользуемыеКодыТоваровPLUНаОборудовании(ТаблицаТоваров, ПравилоОбмена);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьМаксимальныйКодSKU(Весовой, НижняяГраницаВесовогоТовара, ВерхняяГраницаВесовогоТовара) Экспорт
		
	Текст = "ВЫБРАТЬ
	|	МАКСИМУМ(КодыТоваровSKU.SKU) КАК SKU
	|ИЗ
	|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
	|ГДЕ КодыТоваровSKU.SKU >= &Значение1";
	
	Если Весовой Тогда
		Текст = Текст + " И КодыТоваровSKU.SKU <= &Значение2";
		Запрос = Новый Запрос(Текст);
		Запрос.УстановитьПараметр("Значение1", НижняяГраницаВесовогоТовара);
		Запрос.УстановитьПараметр("Значение2", ВерхняяГраницаВесовогоТовара);
		Результат = НижняяГраницаВесовогоТовара;
	Иначе
		Запрос = Новый Запрос(Текст);
		Запрос.УстановитьПараметр("Значение1", ВерхняяГраницаВесовогоТовара);
		Результат = ВерхняяГраницаВесовогоТовара;
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если ЗначениеЗаполнено(Выборка.SKU) Тогда
			Результат = Выборка.SKU + 1;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат; 

КонецФункции 

Функция ПолучитьСвободныеSKUМетодомОбъединения(НижняяГраница = 1, ВерхняяГраница = Неопределено) Экспорт

	Текст = "ВЫБРАТЬ
	|	КодыТоваровSKU.SKU КАК Код
	|ИЗ
	|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
	|ГДЕ
	|	КодыТоваровSKU.SKU >= &НижняяГраница
	|";
	
	Если ВерхняяГраница <> Неопределено Тогда
		Текст = Текст+"
		|	И КодыТоваровSKU.SKU <= &ВерхняяГраница";
	КонецЕсли;
	
	Текст = Текст+"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&НижняяГраница КАК Код
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&ВерхняяГраница КАК Код
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код";
	
	Запрос = Новый Запрос(Текст);
	Запрос.УстановитьПараметр("НижняяГраница", НижняяГраница);
	Запрос.УстановитьПараметр("ВерхняяГраница", ВерхняяГраница);
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	ТаблицаДиапазонов = Новый ТаблицаЗначений;
	ТаблицаДиапазонов.Колонки.Добавить("НачалоИнтервала"       , Новый ОписаниеТипов("Число"));
	ТаблицаДиапазонов.Колонки.Добавить("КонецИнтервала"        , Новый ОписаниеТипов("Число"));
	ТаблицаДиапазонов.Колонки.Добавить("КоличествоСвободныхSKU", Новый ОписаниеТипов("Число"));
	ТаблицаДиапазонов.Колонки.Добавить("SKU"                   , Новый ОписаниеТипов("Число"));
	
	Если ТаблицаЗапроса.Количество() > 1 Тогда
		
		Для Итератор = 2 По ТаблицаЗапроса.Количество() Цикл
			
			СтрокаПредыдущая = ТаблицаЗапроса[Итератор - 2];
			СтрокаТекущая    = ТаблицаЗапроса[Итератор - 1];
			
			Если СтрокаТекущая.Код - СтрокаПредыдущая.Код > 1 Тогда
				
				СтрокаДиапазона = ТаблицаДиапазонов.Добавить();
				СтрокаДиапазона.НачалоИнтервала        = СтрокаПредыдущая.Код + 1;
				СтрокаДиапазона.КонецИнтервала         = СтрокаТекущая.Код - 1;
				СтрокаДиапазона.КоличествоСвободныхSKU = СтрокаДиапазона.КонецИнтервала - СтрокаДиапазона.НачалоИнтервала;
				СтрокаДиапазона.SKU                    = СтрокаДиапазона.НачалоИнтервала;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ТаблицаДиапазонов;

КонецФункции 

Функция SKUСвободен(SKU) Экспорт
	
	Текст = "ВЫБРАТЬ
	        |	КодыТоваровSKU.SKU КАК Код
	        |ИЗ
	        |	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
	        |ГДЕ
	        |	КодыТоваровSKU.SKU = &SKU";
			
	Запрос = Новый Запрос(Текст);
	Запрос.УстановитьПараметр("SKU", SKU);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат НЕ Выборка.Следующий();
	
КонецФункции

Процедура ЗаписатьSKU(Номенклатура, Характеристика, Партия, ЕдиницаИзмерения, SKU) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.КодыТоваровSKU.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.SKU = SKU;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Номенклатура   = Номенклатура;
		МенеджерЗаписи.Характеристика = Характеристика;
		МенеджерЗаписи.Партия = Партия;
		МенеджерЗаписи.ЕдиницаИзмерения = ЕдиницаИзмерения;
		МенеджерЗаписи.Записать();
	Иначе
		МенеджерЗаписи = РегистрыСведений.КодыТоваровSKU.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Номенклатура   = Номенклатура;
		МенеджерЗаписи.Характеристика = Характеристика;
		МенеджерЗаписи.Партия = Партия;
		МенеджерЗаписи.ЕдиницаИзмерения = ЕдиницаИзмерения;
		МенеджерЗаписи.SKU            = SKU;
		МенеджерЗаписи.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьSKU(Номенклатура, Характеристика, Партия, SKU) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.КодыТоваровSKU.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Номенклатура   = Номенклатура;
	МенеджерЗаписи.Характеристика = Характеристика;
	МенеджерЗаписи.Партия = Партия;
	МенеджерЗаписи.SKU            = SKU;
	
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Удалить();
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьSKU(Номенклатура, ЗакончилисьSKU = Ложь) Экспорт
	
	ТаблицаНоменклатурныхПозиций = ПолучитьРазрезыБезSKU(Номенклатура);
	
	ОбновитьКоды_SKU_PLU(ТаблицаНоменклатурныхПозиций, Истина, , ЗакончилисьSKU);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьPLU(ПравилоОбмена, КодТовараPLU, КодТовараSKU)
	
	МенеджерЗаписи = РегистрыСведений.КодыТоваровPLUНаОборудовании.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ПравилоОбмена = ПравилоОбмена;
	МенеджерЗаписи.КодТовараPLU = КодТовараPLU;
	МенеджерЗаписи.Прочитать();
	
	Если НЕ МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи = РегистрыСведений.КодыТоваровPLUНаОборудовании.СоздатьМенеджерЗаписи();
	КонецЕсли;
	
	МенеджерЗаписи.ПравилоОбмена = ПравилоОбмена;
	МенеджерЗаписи.КодТовараPLU  = КодТовараPLU;
	МенеджерЗаписи.КодТовараSKU  = КодТовараSKU;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияДляОбмена(ПравилоОбмена, PLU)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|ГДЕ
		|	ПодключаемоеОборудование.ПравилоОбмена = &ПравилоОбмена
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОфлайнОборудование.УзелИнформационнойБазы
		|ИЗ
		|	Справочник.ОфлайнОборудование КАК ОфлайнОборудование
		|ГДЕ
		|	ОфлайнОборудование.ПравилоОбмена = &ПравилоОбмена";
	
	Запрос.УстановитьПараметр("ПравилоОбмена", ПравилоОбмена);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Набор = РегистрыСведений.КодыТоваровPLUНаОборудовании.СоздатьНаборЗаписей();
	
	Пока Выборка.Следующий() Цикл
		
		Набор.Отбор.ПравилоОбмена.Значение = ПравилоОбмена;
		Набор.Отбор.ПравилоОбмена.Использование = Истина;
		
		Набор.Отбор.КодТовараPLU.Значение = PLU;
		Набор.Отбор.КодТовараPLU.Использование = Истина;
		
		ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Набор);
	
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьНеиспользуемыеКодыТоваровPLUНаОборудовании(ТаблицаТоваров, ПравилоОбмена)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаТоваров.SKU
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КодыТоваровPLUНаОборудовании.ПравилоОбмена,
	|	КодыТоваровPLUНаОборудовании.КодТовараPLU,
	|	КодыТоваровPLUНаОборудовании.КодТовараSKU
	|ИЗ
	|	РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаТоваров КАК ТаблицаТоваров
	|		ПО КодыТоваровPLUНаОборудовании.КодТовараSKU = ТаблицаТоваров.SKU
	|ГДЕ
	|	КодыТоваровPLUНаОборудовании.ПравилоОбмена = &ПравилоОбмена
	|	И ТаблицаТоваров.SKU ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("ТаблицаТоваров", ТаблицаТоваров);
	Запрос.УстановитьПараметр("ПравилоОбмена",  ПравилоОбмена);
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Запись = РегистрыСведений.КодыТоваровPLUНаОборудовании.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
		Запись.Прочитать();
		
		Если Запись.Выбран() Тогда
			Запись.Удалить();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьМаксимальныйPLU(ПравилоОбмена)
	
	Если ПравилоОбмена = Неопределено Тогда
		
		Возврат 0;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЕСТЬNULL(МАКСИМУМ(КодыТоваровPLUНаОборудовании.КодТовараPLU), 0) КАК КодТовараPLU
	|ИЗ
	|	РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
	|ГДЕ
	|	КодыТоваровPLUНаОборудовании.ПравилоОбмена = &ПравилоОбмена");
	
	Запрос.УстановитьПараметр("ПравилоОбмена", ПравилоОбмена);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат Выборка.КодТовараPLU;
	Иначе
		
		Возврат 0;
	КонецЕсли;
	
КонецФункции

Функция СписокСвободныхВесовыхSKU(РазмерСписка)
	
	НижняяГраница  = Константы.НижняяГраницаДиапазонаSKUВесовогоТовара.Получить();
	ВерхняяГраница = Константы.ВерхняяГраницаДиапазонаSKUВесовогоТовара.Получить();
	
	МассивДоступныхSKU = СписокСвободныхSKUВДиапазоне(НижняяГраница, ВерхняяГраница, РазмерСписка);
	
	Возврат МассивДоступныхSKU;
	
КонецФункции

Функция СписокСвободныхШтучныхSKU(РазмерСписка)
	
	ПоправкаНаВключительно = 1;
	МаксимальноВозможныйSKU = 999999999;
	
	НижняяГраница  = Константы.ВерхняяГраницаДиапазонаSKUВесовогоТовара.Получить() + ПоправкаНаВключительно;
	ВерхняяГраница = МаксимальноВозможныйSKU;
	
	МассивДоступныхSKU = СписокСвободныхSKUВДиапазоне(НижняяГраница, ВерхняяГраница, РазмерСписка);
	
	Возврат МассивДоступныхSKU;
	
КонецФункции

Функция СписокСвободныхSKUВДиапазоне(НижняяГраница, ВерхняяГраница, РазмерСписка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МИНИМУМ(КодыТоваровSKU.SKU) КАК МинЗанятыйSKU,
	|	МАКСИМУМ(КодыТоваровSKU.SKU) КАК МаксЗанятыйSKU
	|ИЗ
	|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
	|ГДЕ
	|	КодыТоваровSKU.SKU >= &НижняяГраница
	|	И КодыТоваровSKU.SKU <= &ВерхняяГраница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(КодыТоваровSKU.SKU) КАК КоличествоSKU
	|ИЗ
	|	РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
	|ГДЕ
	|	КодыТоваровSKU.SKU >= &НижняяГраница
	|	И КодыТоваровSKU.SKU <= &ВерхняяГраница";
	
	Запрос.УстановитьПараметр("НижняяГраница",  НижняяГраница);
	Запрос.УстановитьПараметр("ВерхняяГраница", ВерхняяГраница);
	
	РезультатПакет = Запрос.ВыполнитьПакет();
	
	РезультатЗапроса  = РезультатПакет[0];
	РезультатЗапроса1 = РезультатПакет[1];
	
	Выборка1 = РезультатЗапроса1.Выбрать();
	Выборка1.Следующий();
	КоличествоЗанятыхSKU = Выборка1.КоличествоSKU;
	
	Если КоличествоЗанятыхSKU = 0 Тогда
		
		НачалоДиапазонаПоиска = НижняяГраница;
		КонецДиапазонаПоиска  = НачалоДиапазонаПоиска + РазмерСписка - 1;
		
	Иначе
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		МинимальныйЗанятыйSKU  = Выборка.МинЗанятыйSKU;
		МаксимальныйЗанятыйSKU = Выборка.МаксЗанятыйSKU;
		
		КоличествоПробельныхSKU = (МаксимальныйЗанятыйSKU - НижняяГраница + 1) - КоличествоЗанятыхSKU; // количество свободных SKU от нижней границы до последнего занятого SKU
		
		Если КоличествоПробельныхSKU = 0 Тогда // пробелов нет
			
			НачалоДиапазонаПоиска = МаксимальныйЗанятыйSKU + 1;
			КонецДиапазонаПоиска  = МаксимальныйЗанятыйSKU + РазмерСписка;
			
		Иначе
			
			НачалоДиапазонаПоиска = НижняяГраница;
			
			Если КоличествоПробельныхSKU > РазмерСписка Тогда
				
				КонецДиапазонаПоиска = МаксимальныйЗанятыйSKU;
			Иначе
				
				КонецДиапазонаПоиска = МаксимальныйЗанятыйSKU + РазмерСписка - КоличествоПробельныхSKU;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	КонецДиапазонаПоиска = ?(КонецДиапазонаПоиска > ВерхняяГраница, ВерхняяГраница, КонецДиапазонаПоиска);
	
	МассивДоступныхSKU = СоздатьМассивДоступныхSKU(НачалоДиапазонаПоиска, КонецДиапазонаПоиска, РазмерСписка);
	
	Возврат МассивДоступныхSKU;
	
КонецФункции

Функция СоздатьМассивДоступныхSKU(НачалоДиапазона, КонецДиапазона, РазмерСписка)
	
	ТаблицаSKU = Новый ТаблицаЗначений;
	ТаблицаSKU.Колонки.Добавить("SKU", Новый ОписаниеТипов("Число"));
	
	КодSKU = НачалоДиапазона;
	
	Пока НЕ КодSKU > КонецДиапазона Цикл
		
		НоваяСтрока = ТаблицаSKU.Добавить();
		НоваяСтрока.SKU = КодSKU;
		
		КодSKU = КодSKU + 1;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаSKU", ТаблицаSKU);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаSKU.SKU КАК SKU
	|ПОМЕСТИТЬ ТаблицаSKU
	|ИЗ
	|	&ТаблицаSKU КАК ТаблицаSKU
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ %УсловиеПервые%
	|	ТаблицаSKU.SKU КАК SKU,
	|	КодыТоваровSKU.SKU КАК ЗанятыйSKU
	|ИЗ
	|	ТаблицаSKU КАК ТаблицаSKU
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
	|		ПО ТаблицаSKU.SKU = КодыТоваровSKU.SKU
	|ГДЕ
	|	КодыТоваровSKU.SKU ЕСТЬ NULL";
	
	Если РазмерСписка = 0 Тогда
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "%УсловиеПервые%", "");
	Иначе
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "%УсловиеПервые%", "ПЕРВЫЕ " + Формат(РазмерСписка, "ЧГ=0"));
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	
	МассивSKU = Результат.Выгрузить().ВыгрузитьКолонку("SKU");
	
	Возврат МассивSKU;
	
КонецФункции

Функция РазмерыСписковТоваров(ТаблицаТоваров)
	
	РазмерыСписков = Новый Структура;
	РазмерыСписков.Вставить("РазмерСпискаВесовыхТоваров", 0);
	РазмерыСписков.Вставить("РазмерСпискаШтучныхТоваров", 0);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Товары", ТаблицаТоваров);
	Запрос.УстановитьПараметр("ПустоеЗначение", 0);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.Весовой КАК Весовой,
	|	Товары.SKU КАК SKU
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Товары.Весовой
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Весовой,
	|	Товары.SKU КАК SKU,
	|	ВЫБОР
	|		КОГДА Товары.Весовой
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Штучный
	|ПОМЕСТИТЬ ВыбранныеТовары
	|ИЗ
	|	Товары КАК Товары
	|ГДЕ
	|	Товары.SKU = &ПустоеЗначение ИЛИ Товары.SKU ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(ВыбранныеТовары.Весовой), 0) КАК КоличествоВесовыхТоваров,
	|	ЕСТЬNULL(СУММА(ВыбранныеТовары.Штучный), 0) КАК КоличествоШтучныйТоваров
	|ИЗ
	|	ВыбранныеТовары КАК ВыбранныеТовары";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		РазмерыСписков.РазмерСпискаВесовыхТоваров = Выборка.КоличествоВесовыхТоваров;
		РазмерыСписков.РазмерСпискаШтучныхТоваров = Выборка.КоличествоШтучныйТоваров;
	КонецЕсли;
	
	Возврат РазмерыСписков;
	
КонецФункции

Функция ПолучитьСвободныйSKU(СвободныеSKU)
	
	Если СвободныеSKU.Количество() = 0 Тогда
		
		Возврат Неопределено;
		
	Иначе
		
		СвободныйSKU = СвободныеSKU[0];
		СвободныеSKU.Удалить(0);
		
		Возврат СвободныйSKU;
	КонецЕсли;
	
КонецФункции

// Функция возвращает разрезы Номенклатура - Характеристика - Упаковка
// для которых не заполнено SKU в регистре сведений коды товаров SKU.
Функция ПолучитьРазрезыБезSKU(Номенклатура)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Номенклатура,
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК Характеристика
	|ПОМЕСТИТЬ НоменклатураХарактеристики
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	НЕ Номенклатура.ЭтоГруппа
	|	И (&ВсеТовары
	|			ИЛИ Номенклатура.Ссылка В (&Ссылка))
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Номенклатура.Ссылка,
	|	ЕСТЬNULL(ХарактеристикиНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО Номенклатура.Ссылка = ХарактеристикиНоменклатуры.Владелец
	|ГДЕ
	|	НЕ Номенклатура.ЭтоГруппа
	|	И Номенклатура.ИспользоватьХарактеристики
	|	И (&ВсеТовары
	|			ИЛИ Номенклатура.Ссылка В (&Ссылка))
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Номенклатура.Ссылка,
	|	ЕСТЬNULL(ХарактеристикиНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО Номенклатура.КатегорияНоменклатуры = ХарактеристикиНоменклатуры.Владелец
	|ГДЕ
	|	НЕ Номенклатура.ЭтоГруппа
	|	И ЕСТЬNULL(Номенклатура.КатегорияНоменклатуры.ИспользоватьХарактеристики, ЛОЖЬ)
	|	И (&ВсеТовары
	|			ИЛИ Номенклатура.Ссылка В (&Ссылка))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НоменклатураХарактеристики.Номенклатура КАК Номенклатура,
	|	НоменклатураХарактеристики.Характеристика КАК Характеристика,
	|	ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка) КАК Партия
	|ПОМЕСТИТЬ НоменклатураХарактеристиПартииБезЕдиницы
	|ИЗ
	|	НоменклатураХарактеристики КАК НоменклатураХарактеристики
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НоменклатураХарактеристики.Номенклатура,
	|	НоменклатураХарактеристики.Характеристика,
	|	ПартииНоменклатуры.Ссылка
	|ИЗ
	|	НоменклатураХарактеристики КАК НоменклатураХарактеристики
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПартииНоменклатуры КАК ПартииНоменклатуры
	|		ПО НоменклатураХарактеристики.Номенклатура = ПартииНоменклатуры.Владелец
	|ГДЕ
	|	НоменклатураХарактеристики.Номенклатура.ИспользоватьПартии
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НоменклатураХарактеристиПартииБезЕдиницы.Номенклатура КАК Номенклатура,
	|	НоменклатураХарактеристиПартииБезЕдиницы.Характеристика КАК Характеристика,
	|	НоменклатураХарактеристиПартииБезЕдиницы.Партия КАК Партия,
	|	ЗНАЧЕНИЕ(Справочник.ЕдиницыИзмерения.ПустаяСсылка) КАК ЕдиницаИзмерения
	|ПОМЕСТИТЬ НоменклатураХарактеристиПартииСЕдиницами
	|ИЗ
	|	НоменклатураХарактеристиПартииБезЕдиницы КАК НоменклатураХарактеристиПартииБезЕдиницы
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НоменклатураХарактеристиПартииБезЕдиницы.Номенклатура,
	|	НоменклатураХарактеристиПартииБезЕдиницы.Характеристика,
	|	НоменклатураХарактеристиПартииБезЕдиницы.Партия,
	|	ЕдиницыИзмерения.Ссылка
	|ИЗ
	|	НоменклатураХарактеристиПартииБезЕдиницы КАК НоменклатураХарактеристиПартииБезЕдиницы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
	|		ПО НоменклатураХарактеристиПартииБезЕдиницы.Номенклатура = ЕдиницыИзмерения.Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НоменклатураХарактеристиПартии.Номенклатура КАК Номенклатура,
	|	НоменклатураХарактеристиПартии.Характеристика КАК Характеристика,
	|	НоменклатураХарактеристиПартии.Партия КАК Партия,
	|	НоменклатураХарактеристиПартии.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	НоменклатураХарактеристиПартии.Номенклатура.Весовой КАК Весовой,
	|	0 КАК SKU,
	|	0 КАК PLU
	|ИЗ
	|	НоменклатураХарактеристиПартииСЕдиницами КАК НоменклатураХарактеристиПартии
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
	|		ПО НоменклатураХарактеристиПартии.Номенклатура = КодыТоваровSKU.Номенклатура
	|			И НоменклатураХарактеристиПартии.Характеристика = КодыТоваровSKU.Характеристика
	|			И НоменклатураХарактеристиПартии.Партия = КодыТоваровSKU.Партия
	|			И НоменклатураХарактеристиПартии.ЕдиницаИзмерения = КодыТоваровSKU.ЕдиницаИзмерения
	|ГДЕ
	|	КодыТоваровSKU.SKU ЕСТЬ NULL");
	
	Запрос.УстановитьПараметр("ВсеТовары", Номенклатура = Неопределено);
	Запрос.УстановитьПараметр("Ссылка", Номенклатура);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Возврат РезультатЗапроса[3].Выгрузить()
	
КонецФункции

#КонецОбласти

#КонецЕсли
