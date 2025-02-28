﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияБЭД.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
	ОбъектУчета = Параметры.ОбъектУчета;
	
	Если Параметры.ИспользуемыеВариантыВыбораФайла.Количество() > 1 Тогда
		
		Элементы.ВариантыВыбораФайла.Видимость = Истина;
		СписокВыбораВариантов = Элементы.ВариантыВыбораФайла.СписокВыбора;
		
		Для Каждого ИспользуемыйВариант Из Параметры.ИспользуемыеВариантыВыбораФайла Цикл
			
			Если ИспользуемыйВариант = "СДиска" Тогда
				
				СписокВыбораВариантов.Добавить("СДиска", НСтр("ru = 'Файл с диска'"));
			
			ИначеЕсли ИспользуемыйВариант = "ПрисоединенныйФайл" Тогда
				
				СписокВыбораВариантов.Добавить("ПрисоединенныйФайл", НСтр("ru = 'Файл, присоединенный к документу'"));
				ПодготовитьДанныеОПрисоединенныхФайлахОбъектаУчета();
			
			ИначеЕсли ИспользуемыйВариант = "ПечатнаяФорма" Тогда
				
				СписокВыбораВариантов.Добавить("ПечатнаяФорма", НСтр("ru = 'Печатная форма документа'"));
				ПодготовитьДанныеПечатныхФормОбъектаУчета();
			
			Иначе
				
				Продолжить;
				
			КонецЕсли;
			
			Если ИспользуемыйВариант = Параметры.ВариантВыбораФайлаПоУмолчанию Тогда
				ВариантыВыбораФайла = ИспользуемыйВариант;
			КонецЕсли;
			
		КонецЦикла;
		
		// Устанавливаем текст справки
		Элементы.НадписьПодсказка.Заголовок = РеквизитФормыВЗначение("Объект").ТекстСправки();
		
	Иначе
		
		ВариантыВыбораФайла = Параметры.ИспользуемыеВариантыВыбораФайла[0];
		
		Если ВариантыВыбораФайла = "ПрисоединенныйФайл" Тогда
			ПодготовитьДанныеОПрисоединенныхФайлахОбъектаУчета();
		ИначеЕсли ВариантыВыбораФайла = "ПечатнаяФорма" Тогда
			ПодготовитьДанныеПечатныхФормОбъектаУчета();
		КонецЕсли;
		
		ОдинВариантВыбораФайла = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Если вариант выбора файла только один, то пропускаем этап подготовки и прячем команду Назад.
	Если ОдинВариантВыбораФайла Тогда
		
		Элементы.СтраницаПодготовка.Видимость = Ложь;
		Элементы.Назад.Видимость              = Ложь;
		Элементы.СтраницаФинал.Видимость      = Истина;
		
		НастроитьВидимостьГруппВыбораФайла();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбора.Фильтр                  = НСтр("ru = 'Файл PDF'") + " (*.pdf)|*.pdf";
	ДиалогВыбора.Заголовок               = НСтр("ru = 'Выберите договорный документ'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеУказанияПутиКФайлуСДиска", ЭтотОбъект);
	ДиалогВыбора.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если НЕ ПустаяСтрока(Текст) Тогда
		ПутьКФайлу = СокрЛП(Текст);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	Элементы.СтраницаПодготовка.Видимость = Ложь;
	Элементы.СтраницаФинал.Видимость = Истина;
	НастроитьВидимостьГруппВыбораФайла();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.СтраницаПодготовка.Видимость = Истина;
	Элементы.СтраницаФинал.Видимость = Ложь;
	Элементы.Продолжить.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ГотовоФайлы(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаФайлов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиКлиент.ДанныеФайла(ТекущиеДанные.ПрисоединенныйФайл);
	
	ПараметрыФайла = КлиентскиеМетодыФормата().НовыеПараметрыФайла();
	ПараметрыФайла.Вставить("Имя",      ДанныеФайла.ИмяФайла);
	ПараметрыФайла.Вставить("Хранение", ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);

	Закрыть(ПараметрыФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ГотовоСДиска(Команда)
	
	Если Не ЗначениеЗаполнено(ПутьКФайлу) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не заполнен путь к файлу.'"));
		Возврат;
	КонецЕсли;
	
	Файл = Новый Файл(ПутьКФайлу);
	Файл.НачатьПроверкуСуществования(Новый ОписаниеОповещения("ПроверкаСуществованияФайлаЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ГотовоПечатныеФормы(Команда)
	
	ТекущиеДанные = Элементы.ПечатныеФормы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РезультатПечати = ИнтерфейсДокументовЭДОВызовСервера.ПечатныеФормыДокументов(ТекущиеДанные.ДанныеФормирования,
		ОбъектУчета, ТипФайлаТабличногоДокумента.PDF_A_3);
	
	Если РезультатПечати = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не удалось сформировать печатную форму.'"));
		Возврат;
	КонецЕсли;
	
	Для Каждого ПечатныйДокумент Из РезультатПечати Цикл
		
		Хранение = ПоместитьВоВременноеХранилище(ПечатныйДокумент.ДвоичныеДанные, УникальныйИдентификатор);
		
		ПараметрыФайла = КлиентскиеМетодыФормата().НовыеПараметрыФайла();
		ПараметрыФайла.Вставить("Имя",      ПечатныйДокумент.ИмяФайла);
		ПараметрыФайла.Вставить("Хранение", Хранение);
		
		Закрыть(ПараметрыФайла);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция КлиентскиеМетодыФормата()
	Возврат ИнтерфейсДокументовЭДОКлиент.ФормаДоговорныйДокумент101Клиент();
КонецФункции

&НаКлиенте
Процедура НастроитьВидимостьГруппВыбораФайла()

	Если ВариантыВыбораФайла = "СДиска" Тогда
		
		Элементы.ГруппаФайлы.Видимость         = Ложь;
		Элементы.ГруппаПечатныеФормы.Видимость = Ложь;
		Элементы.ГруппаСДиска.Видимость        = Истина;
		Элементы.ГотовоФайлы.Видимость         = Ложь;
		Элементы.ГотовоПечатныеФормы.Видимость = Ложь;
		Элементы.ГотовоСДиска.Видимость        = Истина;
		
		Элементы.ГотовоСДиска.КнопкаПоУмолчанию = Истина;
		
	ИначеЕсли ВариантыВыбораФайла = "ПрисоединенныйФайл" Тогда
		
		Элементы.ГруппаФайлы.Видимость         = Истина;
		Элементы.ГруппаПечатныеФормы.Видимость = Ложь;
		Элементы.ГруппаСДиска.Видимость        = Ложь;
		Элементы.ГотовоФайлы.Видимость         = Истина;
		Элементы.ГотовоПечатныеФормы.Видимость = Ложь;
		Элементы.ГотовоСДиска.Видимость        = Ложь;
		
		Элементы.ГотовоФайлы.КнопкаПоУмолчанию = Истина;
		
	ИначеЕсли ВариантыВыбораФайла = "ПечатнаяФорма" Тогда
		
		Элементы.ГруппаФайлы.Видимость         = Ложь;
		Элементы.ГруппаПечатныеФормы.Видимость = Истина;
		Элементы.ГруппаСДиска.Видимость        = Ложь;
		Элементы.ГотовоФайлы.Видимость         = Ложь;
		Элементы.ГотовоПечатныеФормы.Видимость = Истина;
		Элементы.ГотовоСДиска.Видимость        = Ложь;
		
		Элементы.ГотовоПечатныеФормы.КнопкаПоУмолчанию = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Подготавливает таблицу присоединенных файлов по объекту учета
&НаСервере
Процедура ПодготовитьДанныеОПрисоединенныхФайлахОбъектаУчета()
	
	ДоступныеФайлы = Новый Массив; // Массив из ОпределяемыйТип.ПрисоединенныйФайл
	РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(ОбъектУчета, ДоступныеФайлы);
	
	Файлы.Очистить();
	
	СписокДопустимыхРасширений = "pdf";
	
	Для Каждого ДоступныйФайл Из ДоступныеФайлы Цикл
		
		ПометкаУдаленияФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоступныйФайл, "ПометкаУдаления");
		
		Если ПометкаУдаленияФайла <> Ложь Тогда
			Продолжить;
		КонецЕсли;
	
		ДанныеФайла = РаботаСФайлами.ДанныеФайла(ДоступныйФайл);
		Если РаботаСФайламиБЭДКлиентСервер.РасширениеФайлаВСписке(
			СписокДопустимыхРасширений, ДанныеФайла.Расширение) Тогда
			
			ИндексКартинки = ИнтеграцияБСПБЭД.ИндексПиктограммыФайла(ДанныеФайла.Расширение);
			
			НоваяСтрока = Файлы.Добавить();
			НоваяСтрока.Наименование = ДанныеФайла.Наименование;
			НоваяСтрока.ПрисоединенныйФайл = ДанныеФайла.Ссылка;
			НоваяСтрока.ИндексКартинки = ИндексКартинки;
			
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

// Подготавливает таблицу доступных печатных форм по объекту учета
&НаСервере
Процедура ПодготовитьДанныеПечатныхФормОбъектаУчета()
	
	МетаданныеОбъектаУчета = ОбъектУчета.Метаданные();
	ТаблицаКомандПечати = ИнтеграцияЭДО.КомандыПечатиДляВнутреннегоЭДО(МетаданныеОбъектаУчета);
	
	ДоступныеКомандыПечати = ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаКомандПечати);
	
	Для Каждого ДоступнаяКоманда Из ДоступныеКомандыПечати Цикл
		
		НоваяСтрока = ПечатныеФормы.Добавить();
		НоваяСтрока.Представление = ДоступнаяКоманда.Представление;
		НоваяСтрока.ДанныеФормирования = ДоступнаяКоманда;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУказанияПутиКФайлуСДиска(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		
		ПутьКФайлу = ВыбранныеФайлы.Получить(0);

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаСуществованияФайлаЗавершение(ФайлСуществует, ДополнительныеПараметры) Экспорт
	
	Если Не ФайлСуществует Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Файл не существует.'"));
		
	Иначе
		
		ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
		ПараметрыЗагрузки.Интерактивно = Ложь;
		
		ОбработчикЗавершения = Новый ОписаниеОповещения("ПослеПомещенияФайлаСДиска", ЭтотОбъект);
		
		ФайловаяСистемаКлиент.ЗагрузитьФайл(ОбработчикЗавершения, ПараметрыЗагрузки, ПутьКФайлу);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПомещенияФайлаСДиска(РезультатПомещения, ДополнительныеПараметры) Экспорт

	Если РезультатПомещения <> Неопределено Тогда
		Закрыть(РезультатПомещения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти