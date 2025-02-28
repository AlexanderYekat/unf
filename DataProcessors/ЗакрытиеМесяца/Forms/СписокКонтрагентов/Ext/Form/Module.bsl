﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("Контрагенты") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Параметры.Свойство("Режим", Режим);
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("Месяц", Месяц);
	ОшибкиНаНачало = Ложь;
	Для каждого СтруктураОписания Из Параметры.Контрагенты Цикл
		НоваяСтрока = СписокКонтрагентов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураОписания);
		НоваяСтрока.ОсталосьЗачесть = НоваяСтрока.КЗачету;
		НоваяСтрока.Пометка = Истина;
		ОшибкиНаНачало = ОшибкиНаНачало ИЛИ НоваяСтрока.ОшибкиНаНачало;
	КонецЦикла;
	
	// Автоматический зачет возможен только при включении опции "Автозачет авансов" в настройках программы
	БезАвтоматическогоЗачета = (ПолучитьФункциональнуюОпцию("ЗачитыватьАвансыДолгиАвтоматически") <> Перечисления.ДаНет.Да);
	Если БезАвтоматическогоЗачета Тогда
		Элементы.ФормаЗачестьВыделенные.Видимость = Ложь;
		Элементы.ФормаОткрытьОтчет.КнопкаПоУмолчанию = Истина;
		Элементы.СписокКонтрагентовЗачтеноАвтоматически.Видимость = Ложь;
		Элементы.ДекорацияОшибкиНаНачало.Видимость = Ложь;
	КонецЕсли; 
	
	Если ОшибкиНаНачало Тогда
		Если БезАвтоматическогоЗачета Тогда
			Шаблон = НСтр("ru = 'У некоторых %1 есть незачтенные авансы на начало %2 %3 г. Следует выполнить анализ и зачет авансов более ранних периодов.'");;
		Иначе
			Шаблон = НСтр("ru = 'У некоторых %1 есть незачтенные авансы на начало %2 %3 г. Автоматический зачет выполняется только для документов этого месяца.
		                  |Следует выполнить анализ и зачет авансов более ранних периодов.'");;
		КонецЕсли; 
		Если Режим = "Покупатели" Тогда
			Заголовок = НСтр("ru = 'Список покупателей'");
			Элементы.СписокКонтрагентовКонтрагент.Заголовок = НСтр("ru = 'Покупатель'");
			СтрокаКонтрагенты = НСтр("ru = 'покупателей'");	
		ИначеЕсли Режим = "Поставщики" Тогда
			Заголовок = НСтр("ru = 'Список поставщиков'");
			Элементы.СписокКонтрагентовКонтрагент.Заголовок = НСтр("ru = 'Поставщик'");
			СтрокаКонтрагенты = НСтр("ru = 'поставщиков'");
		Иначе
			СтрокаКонтрагенты = НСтр("ru = 'контрагентов'");
		КонецЕсли;
		ИмяМесяца = ЗакрытиеМесяца.ИмяМесяцаВПадеже(Месяц(Месяц), "Р");
		ГодСтрокой = Формат(Год(Месяц), "ЧГ=0");
		Элементы.ДекорацияОшибкиНаНачало.Заголовок = СтрШаблон(Шаблон, СтрокаКонтрагенты, ИмяМесяца, ГодСтрокой);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокКонтрагентов

&НаКлиенте
Процедура СписокКонтрагентовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПодробныйОтчет();
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗачестьВыделенные(Команда)
	
	ЗачестьВыделенныеСервер();
	Если СписокКонтрагентов.Количество() = 0 Тогда
		Закрыть(Истина);
	КонецЕсли;  
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	Для каждого СтрокаТаблицы Из СписокКонтрагентов Цикл
		СтрокаТаблицы.Пометка = Истина;
	КонецЦикла; 	
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	Для каждого СтрокаТаблицы Из СписокКонтрагентов Цикл
		СтрокаТаблицы.Пометка = Ложь;
	КонецЦикла; 	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчет(Команда)
	
	ПодробныйОтчет();	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗачестьВыделенныеСервер()
	
	Для каждого СтрокаТаблицы Из СписокКонтрагентов Цикл
		
		Если НЕ СтрокаТаблицы.Пометка Тогда
			Продолжить;
		КонецЕсли; 
		
		Если Режим = "Покупатели" Тогда
			ПерезаполнитьДокументыПокупателя(СтрокаТаблицы);
		ИначеЕсли Режим = "Поставщики" Тогда
			ПерезаполнитьДокументыПоставщика(СтрокаТаблицы);
		КонецЕсли; 
			
	КонецЦикла;
	
	ОбновитьДанные();
	
КонецПроцедуры

// В процедуре выполняется заполнение табличных частей "Предоплата" и "РасшифровкаПлатежа"
// а также проведение документов, т.е. производит программный зачет авансов по разделу "Расчеты с покупателями"
//
&НаСервере
Процедура ПерезаполнитьДокументыПокупателя(СтрокаТаблицы)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	РасчетыСПокупателямиОбороты.Регистратор КАК Регистратор,
	|	РасчетыСПокупателямиОбороты.Период КАК Период
	|ИЗ
	|	РегистрНакопления.РасчетыСПокупателями.Обороты(
	|			&ДатаНач,
	|			&ДатаКон,
	|			Регистратор,
	|			Организация = &Организация
	|				И Контрагент = &Контрагент
	|				И Договор = &Договор
	|				И Заказ = &Заказ) КАК РасчетыСПокупателямиОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период,
	|	Регистратор");
	
	Запрос.УстановитьПараметр("ДатаНач", НачалоМесяца(Месяц));
	Запрос.УстановитьПараметр("ДатаКон", КонецМесяца(Месяц));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Контрагент", СтрокаТаблицы.Контрагент);
	Запрос.УстановитьПараметр("Договор", СтрокаТаблицы.Договор);
	Запрос.УстановитьПараметр("Заказ", СтрокаТаблицы.Заказ);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			Если ЭтоДокументОплаты(Выборка.Регистратор) Тогда
				// Перезаполнение расшифровки
				ДокументОбъект = Выборка.Регистратор.ПолучитьОбъект(); 
				ПерезаполнитьСтрокиРасшифровкиПлатежа(ДокументОбъект);
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
				ЗаписатьИсториюИзмененияОбъекта(
				Выборка.Регистратор, 
				НСтр("ru = 'Проведение'", ОбщегоНазначения.КодОсновногоЯзыка()), 
				НСтр("ru = 'Проведение документа.'", ОбщегоНазначения.КодОсновногоЯзыка()));
			ИначеЕсли Выборка.Регистратор.Метаданные().ТабличныеЧасти.Найти("Предоплата") <> Неопределено Тогда
				// Заполнение предоплат
				ДокументОбъект = Выборка.Регистратор.ПолучитьОбъект();
				ДокументОбъект.ЗаполнитьПредоплату();
				Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДокументОбъект, "СпособЗачетаПредоплаты")
					И ДокументОбъект.СпособЗачетаПредоплаты = Перечисления.СпособыЗачетаИРаспределенияПлатежей.Вручную
					И ДокументОбъект.Предоплата.Количество() = 0 Тогда
					ДокументОбъект.СпособЗачетаПредоплаты = Перечисления.СпособыЗачетаИРаспределенияПлатежей.Авто;
				КонецЕсли;
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
				ЗаписатьИсториюИзмененияОбъекта(
				Выборка.Регистратор, 
				НСтр("ru = 'Проведение'", ОбщегоНазначения.КодОсновногоЯзыка()), 
				НСтр("ru = 'Проведение документа.'", ОбщегоНазначения.КодОсновногоЯзыка()));
			КонецЕсли;
		Исключение
			Шаблон = НСтр("ru = 'Не удалось обработать  документ %1 по контрагенту %2'");
			СтрокаОшибки = СтрШаблон(Шаблон, Строка(Выборка.Регистратор), СтрокаТаблицы.Контрагент);
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтрокаОшибки;
			Сообщение.УстановитьДанные(Объект);
			Сообщение.Сообщить(); 
			Ошибки = Истина;
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

// В процедуре выполняется заполнение табличных частей "Предоплата" и "РасшифровкаПлатежа"
// а также проведение документов, т.е. производит программный зачет авансов по разделу "Расчеты с поставщиками"
//
&НаСервере
Процедура ПерезаполнитьДокументыПоставщика(СтрокаТаблицы)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	РасчетыСПоставщикамиОбороты.Регистратор КАК Регистратор,
	|	РасчетыСПоставщикамиОбороты.Период КАК Период
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками.Обороты(
	|			&ДатаНач,
	|			&ДатаКон,
	|			Регистратор,
	|			Организация = &Организация
	|				И Договор = &Договор
	|				И Заказ = &Заказ) КАК РасчетыСПоставщикамиОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период,
	|	Регистратор");
	
	Запрос.УстановитьПараметр("ДатаНач", НачалоМесяца(Месяц));
	Запрос.УстановитьПараметр("ДатаКон", КонецМесяца(Месяц));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Контрагент", СтрокаТаблицы.Контрагент);
	Запрос.УстановитьПараметр("Договор", СтрокаТаблицы.Договор);
	Запрос.УстановитьПараметр("Заказ", СтрокаТаблицы.Заказ);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			Если ЭтоДокументОплаты(Выборка.Регистратор) Тогда 
				// Перезаполнение расшифровки
				ДокументОбъект = Выборка.Регистратор.ПолучитьОбъект(); 
				ПерезаполнитьСтрокиРасшифровкиПлатежа(ДокументОбъект);
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
				ЗаписатьИсториюИзмененияОбъекта(
				Выборка.Регистратор, 
				НСтр("ru = 'Проведение'", ОбщегоНазначения.КодОсновногоЯзыка()), 
				НСтр("ru = 'Проведение документа.'", ОбщегоНазначения.КодОсновногоЯзыка()));
			ИначеЕсли Выборка.Регистратор.Метаданные().ТабличныеЧасти.Найти("Предоплата") <> Неопределено Тогда
				// Заполнение предоплат
				ДокументОбъект = Выборка.Регистратор.ПолучитьОбъект();
				ДокументОбъект.ЗаполнитьПредоплату();
				Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДокументОбъект, "СпособЗачетаПредоплаты")
					И ДокументОбъект.СпособЗачетаПредоплаты = Перечисления.СпособыЗачетаИРаспределенияПлатежей.Вручную
					И ДокументОбъект.Предоплата.Количество() = 0 Тогда
					ДокументОбъект.СпособЗачетаПредоплаты = Перечисления.СпособыЗачетаИРаспределенияПлатежей.Авто;
				КонецЕсли;
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
				ЗаписатьИсториюИзмененияОбъекта(
				Выборка.Регистратор, 
				НСтр("ru = 'Проведение'", ОбщегоНазначения.КодОсновногоЯзыка()), 
				НСтр("ru = 'Проведение документа.'", ОбщегоНазначения.КодОсновногоЯзыка()));
			КонецЕсли;
		Исключение
			Шаблон = НСтр("ru = 'Не удалось обработать  документ %1 по контрагенту %2'");
			СтрокаОшибки = СтрШаблон(Шаблон, Строка(Выборка.Регистратор), СтрокаТаблицы.Контрагент);
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтрокаОшибки;
			Сообщение.УстановитьДанные(Объект);
			Сообщение.Сообщить(); 
			Ошибки = Истина;
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьСтрокиРасшифровкиПлатежа(Знач ДокументОбъект)
	
	Перем СтрокаТЧ;
	
	Для Каждого СтрокаТЧ Из ДокументОбъект.РасшифровкаПлатежа Цикл
		Если СтрокаТЧ.СпособЗачета = Перечисления.СпособыЗачетаИРаспределенияПлатежей.Вручную
			И Не ЗначениеЗаполнено(СтрокаТЧ.Документ) Тогда
			СтрокаТЧ.СпособЗачета = Перечисления.СпособыЗачетаИРаспределенияПлатежей.Авто;	
		КонецЕсли;	
	КонецЦикла;

КонецПроцедуры

// Функция определяет, есть ли тип переданного документа в списке МассивТиповДокументыОплаты
// Параметры:
//	ДокументСсылка - ссылка определяемого документа
//
&НаСервере
Функция ЭтоДокументОплаты(ДокументСсылка)
	
	ТипДокумента = ТипЗнч(ДокументСсылка);
	
	МассивТиповДокументыОплаты = Новый Массив;
	МассивТиповДокументыОплаты.Добавить(Тип("ДокументСсылка.ПоступлениеВКассу"));
	МассивТиповДокументыОплаты.Добавить(Тип("ДокументСсылка.ПоступлениеНаСчет"));
	МассивТиповДокументыОплаты.Добавить(Тип("ДокументСсылка.РасходИзКассы"));
	МассивТиповДокументыОплаты.Добавить(Тип("ДокументСсылка.РасходСоСчета"));
	Возврат МассивТиповДокументыОплаты.Найти(ТипДокумента) <> Неопределено;
	
КонецФункции

// Процедура сохраняет дату и событие изменения (запись, проведение) конкретного объекта
// информационной базы
//
&НаСервере
Процедура ЗаписатьИсториюИзмененияОбъекта(ОбъектСсылка, Событие, Комментарий)
	
	ЗаписьЖурналаРегистрации(
	СтрШаблон(НСтр("ru = 'КонтрольПравильностиУчета.%1'", ОбщегоНазначения.КодОсновногоЯзыка()), Событие), 
	УровеньЖурналаРегистрации.Информация, 
	,
	ОбъектСсылка, 
	Комментарий);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанные()
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Пометка", Истина);
	ТаблицаКонтрагентыДоговора = СписокКонтрагентов.Выгрузить(СтруктураОтбора, "Контрагент, Договор");
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаКонтрагентыДоговора", ТаблицаКонтрагентыДоговора);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Месяц));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Месяц));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаКонтрагентыДоговора.Контрагент КАК Контрагент,
	|	ТаблицаКонтрагентыДоговора.Договор КАК Договор
	|ПОМЕСТИТЬ ТаблицаКонтрагентыДоговора
	|ИЗ
	|	&ТаблицаКонтрагентыДоговора КАК ТаблицаКонтрагентыДоговора
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегРасчетов.Контрагент КАК Контрагент,
	|	РегРасчетов.Договор КАК Договор,
	|	СУММА(ВЫБОР
	|			КОГДА РегРасчетов.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)
	|				ТОГДА -РегРасчетов.СуммаКонечныйОстаток
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК АвансКонец,
	|	СУММА(ВЫБОР
	|			КОГДА РегРасчетов.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)
	|				ТОГДА РегРасчетов.СуммаКонечныйОстаток
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ДолгКонец
	|ИЗ
	|	РегистрНакопления.РасчетыСПокупателями.ОстаткиИОбороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Месяц,
	|			ДвиженияИГраницыПериода,
	|			Организация = &Организация
	|				И (Контрагент, Договор) В
	|					(ВЫБРАТЬ
	|						ТаблицаКонтрагентыДоговора.Контрагент,
	|						ТаблицаКонтрагентыДоговора.Договор
	|					ИЗ
	|						ТаблицаКонтрагентыДоговора)) КАК РегРасчетов
	|
	|СГРУППИРОВАТЬ ПО
	|	РегРасчетов.Контрагент,
	|	РегРасчетов.Договор";
	Если Режим = "Поставщики" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "РегистрНакопления.РасчетыСПокупателями", "РегистрНакопления.РасчетыСПоставщиками");
	КонецЕсли;
	СтруктураОтбора = Новый Структура("Контрагент, Договор");	
	Выборка = Запрос.Выполнить().Выбрать();
	СтрокиКУдалению = Новый Массив;
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СтруктураОтбора, Выборка, "Контрагент, Договор");
		Строки = СписокКонтрагентов.НайтиСтроки(СтруктураОтбора);
		Если Строки.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаСписка = Строки[0];
		СтрокаСписка.Аванс = Выборка.АвансКонец;
		СтрокаСписка.Долг = Выборка.ДолгКонец;
		СтрокаСписка.ЗачтеноАвтоматически = СтрокаСписка.КЗачету - Мин(Выборка.АвансКонец, Выборка.ДолгКонец);
		СтрокаСписка.ОсталосьЗачесть = СтрокаСписка.КЗачету - СтрокаСписка.ЗачтеноАвтоматически;
		Если Выборка.АвансКонец = 0 ИЛИ Выборка.ДолгКонец = 0 ИЛИ СтрокаСписка.ОсталосьЗачесть = 0 Тогда
			СтрокиКУдалению.Добавить(СтрокаСписка);
		КонецЕсли; 
	КонецЦикла;
	
	Если СписокКонтрагентов.Итог("ЗачтеноАвтоматически") = 0 Тогда
		Элементы.ДекорацияОшибкиНаНачало.Заголовок = 
		НСтр("ru = 'Не удалось зачесть авансы автоматически.
              |Для ручного зачета следует воспользоваться данными детального отчета.'");
	ИначеЕсли СписокКонтрагентов.Итог("ОсталосьЗачесть") > 0 Тогда
		Элементы.ДекорацияОшибкиНаНачало.Заголовок = 
		НСтр("ru = 'Автоматический зачет авансов выполнен только частично.
              |Для ручного зачета следует воспользоваться данными детального отчета.'");
	КонецЕсли;
	
	Для каждого СтрокаСписка Из СтрокиКУдалению Цикл
		СписокКонтрагентов.Удалить(СтрокаСписка);
	КонецЦикла; 
	
КонецПроцедуры
 
&НаКлиенте
Процедура ПодробныйОтчет()
	
	ТекущаяСтрока = Элементы.СписокКонтрагентов.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОтборОтчета = Новый Соответствие;
	ОтборОтчета.Вставить("НачалоПериода", НачалоМесяца(Месяц));
	ОтборОтчета.Вставить("КонецПериода", КонецМесяца(Месяц));
	ОтборОтчета.Вставить("Организация", Организация);
	ОтборОтчета.Вставить("Контрагент", ТекущаяСтрока.Контрагент);
	ОтборОтчета.Вставить("Договор", ТекущаяСтрока.Договор);
	ОткрытьФорму("Отчет.Взаиморасчеты.Форма", Новый Структура("КлючВарианта, ОтборРасшифровки", "АнализНезачтенныхАвансовКонтекст", ОтборОтчета), ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
 