﻿
#Область СлужебныеОбработчики

&НаКлиенте
Процедура УправлениеДоступностьИВидимостью()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаМинимальноеКоличество", "Доступность", СпособОчисткиЦен = 1);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаДействующиеЦены", "Доступность", СпособОчисткиЦен = 2);
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеСвойствамиЭлементовОтбораВидовЦен()
	
	КоличествоВыбранных = ВидыЦен.Количество();
	Если КоличествоВыбранных = 0 Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияОтборы", "Заголовок", НСтр("ru ='Применимо ко всем видам цен'"));
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияОчиститьОтбор", "Доступность", Ложь);
		
	Иначе
		
		ТекстУточнения = ?(КоличествоВыбранных > 1, СтрШаблон(НСтр("ru =' (и еще %1)'"), КоличествоВыбранных - 1), "");
		ТекстЗаголовка = СтрШаблон(НСтр("ru ='Применимо к %1%2'"), ВидыЦен[0].Значение, ТекстУточнения);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияОтборы", "Заголовок", ТекстЗаголовка);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияОчиститьОтбор", "Доступность", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#Область ДлительныеОперации

&НаКлиенте
Процедура УдалитьЦеныВДлительнойОперации()
	
	ДлительнаяОперация = НачатьУдалениеЦен();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	ПараметрыОжидания.ТекстСообщения = НСтр("ru ='Удаляются устаревшие записи о ценах номенклатуры.'");
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПослеУдаленияЦенВДлительнойОперации", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУдаленияЦенВДлительнойОперации(Результат, ДополнительныеПараметры) Экспорт
	
	ПоказатьПредупреждение(, НСтр("ru ='Удаление завершено'"));
	
КонецПроцедуры

&НаСервере
Функция НачатьУдалениеЦен()
	
	Если ДлительнаяОперация <> Неопределено Тогда
		
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
		
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Удаление устаревших цен номенклатуры'");
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	ПараметрыУдаления = Новый Структура;
	ПараметрыУдаления.Вставить("СпособОчисткиЦен", СпособОчисткиЦен);
	ПараметрыУдаления.Вставить("МинимальноеКоличествоЦенНоменклатуры", МинимальноеКоличествоЦенНоменклатуры);
	ПараметрыУдаления.Вставить("ПериодДействующихЦен", ПериодДействующихЦен);
	
	Если ВидыЦен.Количество() > 0 Тогда
		
		ПараметрыУдаления.Вставить("ВидыЦен", ВидыЦен);
		
	КонецЕсли;
	
	ПараметрыОтложенногоОбработчика = Новый Структура("ПараметрыУдаления", ПараметрыУдаления);
	
	ИмяМетода = "Обработки.УдалениеУстаревшихЦен.УдалитьНеактуальныеЦены";
	Результат = ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыУдаления, ПараметрыВыполнения);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МинимальноеКоличествоЦенНоменклатуры = 3;
	ПериодДействующихЦен = ДобавитьМесяц(НачалоКвартала(ТекущаяДатаСеанса()), -3);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура СпособОчисткиЦенПриИзменении(Элемент)
	
	УправлениеДоступностьИВидимостью();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ДекорацияОтборыНажатие(Элемент)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("МножественныйВыбор", Истина);
	ПараметрыОткрытия.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыОткрытия.Вставить("ВидыЦен", ВидыЦен);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеУстановкиОтбораПоВидамЦен", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.УдалениеУстаревшихЦен.Форма.ФормаОтбораВидовЦен", ПараметрыОткрытия, ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУстановкиОтбораПоВидамЦен(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("СписокЗначений") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ВидыЦен.Очистить();
	Для каждого ЭлементСписка Из Результат Цикл
		
		Если НЕ ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ИскомоеЗначение = ВидыЦен.НайтиПоЗначению(ЭлементСписка.Значение);
		Если ИскомоеЗначение = Неопределено Тогда
			
			ВидыЦен.Добавить(ЭлементСписка.Значение);
			
		КонецЕсли;
		
	КонецЦикла;
	
	УправлениеСвойствамиЭлементовОтбораВидовЦен();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОчиститьОтборНажатие(Элемент)
	
	ВидыЦен.Очистить();
	
	УправлениеСвойствамиЭлементовОтбораВидовЦен();
	
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЦены(Команда)
	
	УдалитьЦеныВДлительнойОперации();
	
КонецПроцедуры

#КонецОбласти

