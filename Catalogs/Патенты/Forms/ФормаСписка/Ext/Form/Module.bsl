﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ДанныеВыбораПериодаИзВыпадающегоСписка;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("ЗаписьПатента", Новый Структура());
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		Организация = Параметры.Отбор.Владелец;
	КонецЕсли;
	
	Элементы.Владелец.Видимость = НЕ ЗначениеЗаполнено(Организация);
	
	ДатаПросмотра = ?(ЗначениеЗаполнено(Параметры.Период), Параметры.Период, ТекущаяДатаСеанса());
	
	ВидПериода  = Перечисления.ДоступныеПериодыОтчета.Год;
	ОтборПериодЗначение.ДатаНачала = НачалоГода(ДатаПросмотра);
	ОтборПериодЗначение.ДатаОкончания  = КонецГода(ДатаПросмотра);
	
	ОтборПериодИспользование = Истина;
	ОтборПериод = ОтчетыУНФКлиентСервер.ПредставлениеСтандартногоПериода(ОтборПериодЗначение, ВидПериода);
	УстановитьОтборПоПериоду(ЭтаФорма, ОтборПериодЗначение.ДатаНачала, ОтборПериодЗначение.ДатаОкончания, ОтборПериодИспользование);
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗаявленияПоПатентнойСистеме(Команда)
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("Раздел", ПредопределенноеЗначение("Перечисление.СтраницыЖурналаОтчетность.Уведомления"));
	ПараметрыОткрытия.Вставить("Организация", Организация);
	
	ОткрытьФорму("ОбщаяФорма.РегламентированнаяОтчетность", ПараметрыОткрытия, ЭтаФорма, "1С-Отчетность");
	
	Оповестить("Открытие формы 1С-Отчетность", ПараметрыОткрытия);
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодИспользованиеПриИзменении(Элемент)
	
	УстановитьОтборПоПериоду(ЭтаФорма, ОтборПериодЗначение.ДатаНачала, ОтборПериодЗначение.ДатаОкончания, ОтборПериодИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура КнигаДоходов(Команда)
	текДанные = Элементы.Список.ТекущиеДанные;
	Если текДанные <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("Организация, Патент", текДанные.Владелец, текДанные.Ссылка);
		ОткрытьФорму("Документ.ЗаписиПатент.Форма.ФормаСпискаЗаписиПрочие", ПараметрыФормы);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПериоду(Форма, НачалоПериода, КонецПериода, Использование)
	
	ОтборКомпоновкиДанных = Форма.Список.КомпоновщикНастроек.Настройки.Отбор;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		ОтборКомпоновкиДанных, "ДатаНачала");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ОтборКомпоновкиДанных, "ДатаНачала", НачалоПериода, ВидСравненияКомпоновкиДанных.БольшеИлиРавно, , Использование);
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		ОтборКомпоновкиДанных, "ДатаОкончания");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ОтборКомпоновкиДанных, "ДатаОкончания", КонецПериода, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, , Использование);
	
КонецПроцедуры


&НаКлиенте
Процедура ОтборПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НачалоПериода = ОтборПериодЗначение.ДатаНачала;
	Если НачалоПериода = '00010101' Тогда
		НачалоПериода = ОтчетыУНФКлиентСервер.НачалоПериодаОтчета(ВидПериода, ОбщегоНазначенияКлиент.ДатаСеанса());
	КонецЕсли;
	
	// Параметры для чтения из обработчиков:
	ПараметрыВыбора = Новый Структура;
	// Для выбора значения:
	ПараметрыВыбора.Вставить("Значение",               ОтборПериодЗначение);
	ПараметрыВыбора.Вставить("Элемент",                Элемент);
	// Для загрузки значения:
	ПараметрыВыбора.Вставить("ВидПериода",             ВидПериода);
	
	ВыборПериодаИзВыпадающегоСписка(-1, ПараметрыВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УстановитьОтборПоПериоду(ЭтаФорма, ОтборПериодЗначение.ДатаНачала, ОтборПериодЗначение.ДатаОкончания, ОтборПериодИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПериодаИзВыпадающегоСписка(Результат, ПараметрыВыбора) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат; // Отмена выбора.
	КонецЕсли;
	
	Если Результат = -1 Тогда // Начало выбора.
		// Чтение параметров для формирования списка из сохраненного значения периода.
		ПараметрыВыбора.Вставить("НачалоПериода", ПараметрыВыбора.Значение.ДатаНачала);
		ПараметрыВыбора.Вставить("Вариант",       ПараметрыВыбора.Значение.Вариант);
		ИндексНачальногоЗначения = Неопределено;
	ИначеЕсли ТипЗнч(Результат.Значение) = Тип("Структура") Тогда
		// Чтение параметров для формирования списка из выбранного значения.
		ПараметрыВыбора.Вставить("НачалоПериода", Результат.Значение.НачалоПериода);
		ПараметрыВыбора.Вставить("Вариант",       Результат.Значение.Вариант);
		ИндексНачальногоЗначения = Результат.Значение.ИндексНачальногоЗначения;
	Иначе
		// Загрузка результата выбора.
		ЗагрузитьРезультатВыбораПериодаИзВыпадающегоСписка(Результат, ПараметрыВыбора);
		Возврат;
	КонецЕсли;
	
	// Формирование списка выбора.
	Если ПараметрыВыбора.Вариант = Неопределено Или ПараметрыВыбора.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод Тогда
		
		СписокПериодов = ОтчетыУНФКлиентСервер.СписокФиксированныхПериодов(ПараметрыВыбора.НачалоПериода, ПараметрыВыбора.ВидПериода);
		
		Если ИндексНачальногоЗначения = Неопределено Тогда
			ИндексНачальногоЗначения = СписокПериодов.НайтиПоЗначению(ПараметрыВыбора.НачалоПериода);
		КонецЕсли;
		
		ОписаниеНавигационногоЭлемента = Новый Структура;
		ОписаниеНавигационногоЭлемента.Вставить("НачалоПериода",            СписокПериодов[0].Значение);
		ОписаниеНавигационногоЭлемента.Вставить("Вариант",                  Неопределено);
		ОписаниеНавигационногоЭлемента.Вставить("ИндексНачальногоЗначения", 0);
		СписокПериодов[0].Значение = ОписаниеНавигационногоЭлемента;
		
		ОписаниеНавигационногоЭлемента = Новый Структура;
		ОписаниеНавигационногоЭлемента.Вставить("НачалоПериода",            СписокПериодов[8].Значение);
		ОписаниеНавигационногоЭлемента.Вставить("Вариант",                  Неопределено);
		ОписаниеНавигационногоЭлемента.Вставить("ИндексНачальногоЗначения", 8);
		СписокПериодов[8].Значение = ОписаниеНавигационногоЭлемента;
		
		Если Не ПараметрыВыбора.Свойство("ВариантСтандартногоПериодаПоВиду") Тогда
			ПараметрыВыбора.Вставить("ВариантСтандартногоПериодаПоВиду", ОтчетыУНФКлиентСервер.ПривестиВидПериодаКСтандартному(ПараметрыВыбора.ВидПериода));
		КонецЕсли;
		
		
	Иначе
		
		СписокПериодов = ОтчетыУНФКлиентСервер.СписокВычисляемыхПериодов(ПараметрыВыбора.ВидПериода);
		
		Если ИндексНачальногоЗначения = Неопределено Тогда
			ИндексНачальногоЗначения = СписокПериодов.НайтиПоЗначению(ПараметрыВыбора.Вариант);
		КонецЕсли;
		
		ОписаниеНавигационногоЭлемента = Новый Структура;
		ОписаниеНавигационногоЭлемента.Вставить("НачалоПериода",            ПараметрыВыбора.НачалоПериода);
		ОписаниеНавигационногоЭлемента.Вставить("Вариант",                  Неопределено);
		ОписаниеНавигационногоЭлемента.Вставить("ИндексНачальногоЗначения", Неопределено);
		СписокПериодов.Добавить(ОписаниеНавигационногоЭлемента, НСтр("ru = 'Фиксированный...'"));
		
	КонецЕсли;
	
	Если ИндексНачальногоЗначения = Неопределено Тогда
		ИндексНачальногоЗначения = СписокПериодов.Количество() - 1;
	КонецЕсли;
	
	ДанныеВыбораПериодаИзВыпадающегоСписка = Новый Структура;
	ДанныеВыбораПериодаИзВыпадающегоСписка.Вставить("ПараметрыВыбора", ПараметрыВыбора);
	ДанныеВыбораПериодаИзВыпадающегоСписка.Вставить("СписокПериодов", СписокПериодов);
	ДанныеВыбораПериодаИзВыпадающегоСписка.Вставить("ИндексНачальногоЗначения", ИндексНачальногоЗначения);
	Если Результат = -1 Тогда
		НачатьВыборПериодаИзВыпадающегоСписка();
	Иначе
		ПодключитьОбработчикОжидания("НачатьВыборПериодаИзВыпадающегоСписка", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьВыборПериодаИзВыпадающегоСписка()
	
	Если ДанныеВыбораПериодаИзВыпадающегоСписка.Свойство("ПараметрыВыбора") Тогда
		Контекст = ДанныеВыбораПериодаИзВыпадающегоСписка;
		ДанныеВыбораПериодаИзВыпадающегоСписка = Новый Структура;
		Обработчик = Новый ОписаниеОповещения("ВыборПериодаИзВыпадающегоСписка", ЭтотОбъект, Контекст.ПараметрыВыбора);
		ПоказатьВыборИзСписка(Обработчик, Контекст.СписокПериодов, Контекст.ПараметрыВыбора.Элемент, Контекст.ИндексНачальногоЗначения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРезультатВыбораПериодаИзВыпадающегоСписка(Результат, ПараметрыВыбора)
	
	Значение = ПараметрыВыбора.Значение;
	
	// Запись результата выбора в данные формы и пользовательские настройки КД.
	Если ТипЗнч(Результат.Значение) = Тип("ВариантСтандартногоПериода") Тогда
		ОтборПериод = ?(ПустаяСтрока(Результат.Представление), Строка(Результат.Значение), Результат.Представление);
		Значение.Вариант = Результат.Значение;
	Иначе
		ОтборПериодЗначение.ДатаНачала = ОтчетыУНФКлиентСервер.НачалоПериодаОтчета(ПараметрыВыбора.ВидПериода, Результат.Значение);
		ОтборПериодЗначение.ДатаОкончания  = ОтчетыУНФКлиентСервер.КонецПериодаОтчета(ПараметрыВыбора.ВидПериода, Результат.Значение);
		
		ОтборПериод = Результат.Представление;
		
		Значение.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод;
		Значение.ДатаНачала    = ОтборПериодЗначение.ДатаНачала;
		Значение.ДатаОкончания = ОтборПериодЗначение.ДатаОкончания;
	КонецЕсли;
	
	ОтборПериодЗначение = Значение;
	УстановитьОтборПоПериоду(ЭтаФорма, ОтборПериодЗначение.ДатаНачала, ОтборПериодЗначение.ДатаОкончания, ОтборПериодИспользование);
	
КонецПроцедуры

#КонецОбласти
