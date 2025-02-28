﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
//@skip-warning
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

//
// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Касса)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьКоличествоЛистовКассовойКнигиЗаПериодПоОрганизации(Организация, ДоговорКонтрагента, ДатаНач, ДатаКон)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ КассоваяКнигаДокументы.НомерЛиста) КАК КоличествоЛистов
	|ИЗ
	|	Документ.КассоваяКнига КАК ДанныеДокумента
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.КассоваяКнига.КассовыеОрдера КАК КассоваяКнигаДокументы
	|	ПО	
	|		ДанныеДокумента.Ссылка = КассоваяКнигаДокументы.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И ДанныеДокумента.Организация = &Организация
	|	И ДанныеДокумента.ДоговорКонтрагента = &ДоговорКонтрагента
	|	И ДанныеДокумента.Проведен
	|");
	
	Запрос.УстановитьПараметр("ДатаНач",     ДатаНач);
	Запрос.УстановитьПараметр("ДатаКон",     ДатаКон);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КоличествоЛистов;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

Процедура ДобавитьОбороты(РабочаяТаблица, Приход, Расход)
	
	НоваяСтрока = РабочаяТаблица.Добавить();
	
	НоваяСтрока.Остаток    = 0;
	НоваяСтрока.Приход     = Приход;
	НоваяСтрока.Расход     = Расход;
	
КонецПроцедуры


// Проверяет возможность совершения операции на предмет согласования функциональной опции
// "ИспользоватьНесколькоОрганизаций"  и количеством, непомеченных на удаление организаций. 
// Возвращает организацию по умолчанию для документа.
//
// Параметры:
//  Отказ - Булево - признак отказа от выполнения операции.
//  ИспользоватьНесколькоОрганизаций - Булево - признак использования нескольких организаций.
//  Организация - СправочникСсылка.Организации - организация для проверки.
//
Функция ПолучитьОрганизацию(Пользователь = неопределено, Организация = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Возврат Организация;
	КонецЕсли;
	Организация = ОрганизацияПоУмолчанию(Пользователь);
	Компания = Справочники.Организации.ОрганизацияКомпания();
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
		Если ИспользоватьНесколькоОрганизаций Тогда
			Если ЗначениеЗаполнено(Компания) Тогда
				Организация = Компания;
			Иначе
				ТекстИсключения = НСтр("ru = 'Не определена организация по умолчанию для пользователя.
				|Для продолжения работы необходимо создать организацию или
				|включить опцию ""Использовать несколько организаций"" (Администрирование - Организации и финансы).'");
				ВызватьИсключение(ТекстИсключения);
			КонецЕсли;
		Иначе
			Если ЗначениеЗаполнено(Компания) Тогда
				Организация = Компания;
			Иначе
				Организация = Справочники.Организации.ОсновнаяОрганизация;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат Организация;
	
КонецФункции

Функция ОрганизацияПоУмолчанию(Знач Пользователь = Неопределено)
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь()
	КонецЕсли;
	ОрганизацияПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
	Пользователь,
	"ОсновнаяОрганизация");
	Возврат ОрганизацияПоУмолчанию;
КонецФункции

#КонецОбласти


#Область ИнтерфейсПечати

Функция ОписатьПравилаЗаполненияПодписей() Экспорт
	
	РеквизитыОбъекта = Новый Соответствие;
	
	РеквизитыОбъекта.Вставить("ПодписьРуководителя", "Организация.ПодписьРуководителя");
	РеквизитыОбъекта.Вставить("ПодписьКассира", "Касса.ПодписьКассира");
	РеквизитыОбъекта.Вставить("ПодписьГлавногоБухгалтера", "Организация.ПодписьГлавногоБухгалтера");
	
	Возврат РеквизитыОбъекта;
	
КонецФункции

Функция СформироватьПечатнуюФормуОбложкиИПоследнегоЛистаКассовойКниги(ОписаниеПечатнойФормы, МассивОбъектов, ОбъектыПечати)
	
	// Печать обложки и титульного листа.
	ТабличныйДокумент = ОписаниеПечатнойФормы.ТабличныйДокумент;
	
	МакетОбложка 	  = УправлениеПечатью.МакетПечатнойФормы("Документ.КассоваяКнига.ПФ_MXL_ОбложкаКассовойКниги");
	ОбластьОбложка 	  = МакетОбложка.ПолучитьОбласть("Обложка");
	
	Запрос = Новый Запрос;
	// Если среди объектов печати есть листы, отмеченные как "последний в месяце" или "последний в году", печатаем
	// титульный лист именно для них В противном случае, титульный лист будет распечатан для последнего по дате листа среди
	// объектов печати, независимо от его типа Ссылка на конкретный лист нужно для пакетной печати титульных листов.
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПоследнийЛистКниги.Организация КАК Организация,
	|	ПоследнийЛистКниги.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ПоследнийЛистКниги.Касса КАК Касса,
	|	НАЧАЛОПЕРИОДА(ПоследнийЛистКниги.Дата, ГОД) КАК Год
	|ПОМЕСТИТЬ вт_ПериодыСПоследнимЛистом
	|ИЗ
	|	Документ.КассоваяКнига КАК ПоследнийЛистКниги
	|ГДЕ
	|	ПоследнийЛистКниги.Ссылка В(&МассивОбъектов)
	|	И НЕ ПоследнийЛистКниги.ТипЛиста = ЗНАЧЕНИЕ(ПЕречисление.ТипыЛистовКассовойКниги.Обычный)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(КассоваяКнига.Дата, ГОД) КАК Год,
	|	КассоваяКнига.Организация КАК Организация,
	|	КассоваяКнига.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ПРЕДСТАВЛЕНИЕ(КассоваяКнига.Касса) КАК КассаПредставление,
	|	КассоваяКнига.Организация.КодПоОКПО КАК КодПоОКПО,
	|	ПОДСТРОКА(КассоваяКнига.Организация.НаименованиеПолное, 1, 200) КАК НаименованиеОрганизации,
	|	КассоваяКнига.ПодписьГлавногоБухгалтера.ФизическоеЛицо КАК ГлавныйБухгалтер,
	|	КассоваяКнига.ПодписьГлавногоБухгалтера.Должность КАК ПодписьГлавногоБухгалтераДолжность,
	|	КассоваяКнига.ПодписьГлавногоБухгалтера.РасшифровкаПодписи КАК РасшифровкаПодписиГлавногоБухгалтера,
	|	КассоваяКнига.ПодписьРуководителя.ФизическоеЛицо КАК Руководитель,
	|	КассоваяКнига.ПодписьРуководителя.Должность КАК ДолжностьРуководителя,
	|	КассоваяКнига.ПодписьРуководителя.РасшифровкаПодписи КАК РасшифровкаПодписиРуководителя,
	|	КассоваяКнига.Ссылка КАК ПоследнийЛистКниги
	|ИЗ
	|	Документ.КассоваяКнига КАК КассоваяКнига
	|ГДЕ
	|	КассоваяКнига.Ссылка В(&МассивОбъектов)
	|	И НЕ КассоваяКнига.ТипЛиста = ЗНАЧЕНИЕ(ПЕречисление.ТипыЛистовКассовойКниги.Обычный)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(КассоваяКнига.Дата, ГОД),
	|	КассоваяКнига.Организация,
	|	КассоваяКнига.ДоговорКонтрагента,
	|	ПРЕДСТАВЛЕНИЕ(КассоваяКнига.Касса),
	|	КассоваяКнига.Организация.КодПоОКПО,
	|	ПОДСТРОКА(КассоваяКнига.Организация.НаименованиеПолное, 1, 200),
	|	КассоваяКнига.ПодписьГлавногоБухгалтера.ФизическоеЛицо,
	|	КассоваяКнига.ПодписьГлавногоБухгалтера.Должность,
	|	КассоваяКнига.ПодписьГлавногоБухгалтера.РасшифровкаПодписи,
	|	КассоваяКнига.ПодписьРуководителя.ФизическоеЛицо,
	|	КассоваяКнига.ПодписьРуководителя.Должность,
	|	КассоваяКнига.ПодписьРуководителя.РасшифровкаПодписи,
	|	КассоваяКнига.Ссылка
	|ИЗ
	|	Документ.КассоваяКнига КАК КассоваяКнига
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(ПоследнийЛистКниги.Ссылка) КАК Ссылка,
	|			ПоследнийЛистКниги.Организация КАК Организация,
	|			ПоследнийЛистКниги.Касса КАК Касса,
	|			НАЧАЛОПЕРИОДА(ПоследнийЛистКниги.Дата, ГОД) КАК Год,
	|			ПоследнийЛистКниги.ДоговорКонтрагента КАК ДоговорКонтрагента
	|		ИЗ
	|			Документ.КассоваяКнига КАК ПоследнийЛистКниги
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|					ПоследнийЛистКниги.Организация КАК Организация,
	|					ПоследнийЛистКниги.Касса КАК Касса,
	|					ПоследнийЛистКниги.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|					НАЧАЛОПЕРИОДА(ПоследнийЛистКниги.Дата, ГОД) КАК Год,
	|					МАКСИМУМ(ПоследнийЛистКниги.Дата) КАК Дата
	|				ИЗ
	|					Документ.КассоваяКнига КАК ПоследнийЛистКниги
	|						ЛЕВОЕ СОЕДИНЕНИЕ вт_ПериодыСПоследнимЛистом КАК Периоды
	|						ПО ПоследнийЛистКниги.Организация = Периоды.Организация
	|							И ПоследнийЛистКниги.Касса = Периоды.Касса
	|							И ПоследнийЛистКниги.ДоговорКонтрагента = Периоды.ДоговорКонтрагента
	|							И (НАЧАЛОПЕРИОДА(ПоследнийЛистКниги.Дата, ГОД) = Периоды.Год)
	|				ГДЕ
	|					ПоследнийЛистКниги.Ссылка В(&МассивОбъектов)
	|					И Периоды.Организация ЕСТЬ NULL
	|				
	|				СГРУППИРОВАТЬ ПО
	|					НАЧАЛОПЕРИОДА(ПоследнийЛистКниги.Дата, ГОД),
	|					ПоследнийЛистКниги.Организация,
	|					ПоследнийЛистКниги.Касса,
	|					ПоследнийЛистКниги.ДоговорКонтрагента) КАК ПоследниеДатыЛистов
	|				ПО (ПоследниеДатыЛистов.Организация = ПоследнийЛистКниги.Организация)
	|					И (ПоследниеДатыЛистов.Касса = ПоследнийЛистКниги.Касса)
	|					И (ПоследниеДатыЛистов.ДоговорКонтрагента = ПоследнийЛистКниги.ДоговорКонтрагента)
	|					И (ПоследниеДатыЛистов.Дата = ПоследнийЛистКниги.Дата)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ПоследнийЛистКниги.Организация,
	|			ПоследнийЛистКниги.Касса,
	|			НАЧАЛОПЕРИОДА(ПоследнийЛистКниги.Дата, ГОД),
	|			ПоследнийЛистКниги.ДоговорКонтрагента) КАК ПоследнийЛист
	|		ПО КассоваяКнига.Ссылка = ПоследнийЛист.Ссылка
	|ГДЕ
	|	КассоваяКнига.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Результат = Запрос.Выполнить();
	Выборка   = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		КоличествоЛистов = ПолучитьКоличествоЛистовКассовойКнигиЗаПериодПоОрганизации(
		Выборка.Организация,
		Выборка.ДоговорКонтрагента,
		НачалоГода(Выборка.Год),
		КонецГода(Выборка.Год));
		
		ПредставлениеКассы = Выборка.НаименованиеОрганизации;
		ОбластьОбложка.Параметры.НазваниеОрганизации = ПредставлениеКассы;
		ОбластьОбложка.Параметры.Подразделение = Выборка.КассаПредставление;
		ОбластьОбложка.Параметры.НадписьОбложка = " на "+Формат(Выборка.Год, "ДФ=yyyy") + " г.";
		ОбластьОбложка.Параметры.КодОКПО 		= Выборка.КодПоОКПО;
		
		ТабличныйДокумент.Вывести(ОбластьОбложка);
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ТабличныйДокумент.Вывести(ОбластьОбложка);
		
		// Последний лист кассовой книги.
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ОбластьПослДеньГода = МакетОбложка.ПолучитьОбласть("ПослДеньГода");
			
		ОбластьПослДеньГода.Параметры.ГлБухгалтер 			= Выборка.РасшифровкаПодписиГлавногоБухгалтера;
		ОбластьПослДеньГода.Параметры.Руководитель 			= Выборка.РасшифровкаПодписиРуководителя;
		ОбластьПослДеньГода.Параметры.РуководительДолжность = Выборка.ДолжностьРуководителя;
		ОбластьПослДеньГода.Параметры.ЛистовЗаГод 			= КоличествоЛистов;
		
		ТабличныйДокумент.Вывести(ОбластьПослДеньГода);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
		ТабличныйДокумент,
		НомерСтрокиНачало,
		ОбъектыПечати,
		Выборка.ПоследнийЛистКниги);
		
	КонецЦикла;
	
	ТабличныйДокумент.ОтображатьСетку     = Ложь;
	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция СформироватьПечатнуюФормуЛистаКассовойКниги(ОписаниеПечатнойФормы, МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = ОписаниеПечатнойФормы.ТабличныйДокумент;
	ВыводитьОснования = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КассоваяКнига.Ссылка КАК Ссылка,
	|	КассоваяКнига.ТипЛиста КАК ТипЛиста,
	|	КассоваяКнига.Дата КАК Дата,
	|	КассоваяКнига.Организация КАК Организация,
	|	КассоваяКнига.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	КассоваяКнига.Касса КАК Касса,
	|	КассоваяКнига.Ответственный.ФизическоеЛицо КАК Ответственный,
	|	КассоваяКнига.ПодписьРуководителя.ФизическоеЛицо КАК Руководитель,
	|	КассоваяКнига.ПодписьРуководителя.Должность КАК ДолжностьРуководителя,
	|	КассоваяКнига.ПодписьРуководителя.РасшифровкаПодписи КАК РасшифровкаПодписиРуководителя,
	|	КассоваяКнига.ПодписьГлавногоБухгалтера.ФизическоеЛицо КАК ГлавныйБухгалтер,
	|	КассоваяКнига.ПодписьГлавногоБухгалтера.Должность КАК ДолжностьГлавногоБухгалтера,
	|	КассоваяКнига.ПодписьГлавногоБухгалтера.РасшифровкаПодписи КАК РасшифровкаПодписиГлавногоБухгалтера,
	|	КассоваяКнига.ПодписьКассира.ФизическоеЛицо КАК Кассир,
	|	КассоваяКнига.ПодписьКассира.Должность КАК ДолжностьКассира,
	|	КассоваяКнига.ПодписьКассира.РасшифровкаПодписи КАК РасшифровкаПодписиКассира
	|ИЗ
	|	Документ.КассоваяКнига КАК КассоваяКнига
	|ГДЕ
	|	КассоваяКнига.Ссылка В(&МассивДокументов)
	|	И КассоваяКнига.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	
	Результат = Запрос.Выполнить();
	ВыборкаПоДокументамКассоваяКнига = Результат.Выбрать();
	
	Пока ВыборкаПоДокументамКассоваяКнига.Следующий() Цикл
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Начало года. В этом случае не требуется получать номера листов кассовой книги.
		ДатаНач = НачалоДня(ВыборкаПоДокументамКассоваяКнига.Дата);
		
		Организация = ВыборкаПоДокументамКассоваяКнига.Организация;
		ДоговорКонтрагента = ВыборкаПоДокументамКассоваяКнига.ДоговорКонтрагента;
		Касса = ВыборкаПоДокументамКассоваяКнига.Касса;
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.КассоваяКнига.ПФ_MXL_ЛистКассовойКниги");
		
		ОбластьПодвалОтчет                  = Макет.ПолучитьОбласть("Подвал|Отчет");
		ОбластьЛистовЗаМесяцОтчет           = Макет.ПолучитьОбласть("ЛистовЗаМесяц|Отчет");
		ОбластьЛистовЗаГодОтчет             = Макет.ПолучитьОбласть("ЛистовЗаГод|Отчет");
		ОбластьВкладнойЛистОтчет            = Макет.ПолучитьОбласть("ВкладнойЛист|Отчет");
		ОбластьВкладнойЛист373ПОтчет        = Макет.ПолучитьОбласть("ВкладнойЛист373П|Отчет");
		ОбластьОтчетКассираОтчет            = Макет.ПолучитьОбласть("ОтчетКассира|Отчет");
		ОбластьОтчетКассира373ПОтчет        = Макет.ПолучитьОбласть("ОтчетКассира373П|Отчет");
		ОбластьШапкаОтчет                   = Макет.ПолучитьОбласть("Шапка|Отчет");
		ОбластьОстатокНаНДОтчет             = Макет.ПолучитьОбласть("ОстатокНаНД|Отчет");
		ОбластьПереносОтчет                 = Макет.ПолучитьОбласть("Перенос|Отчет");
		ОбластьСтрокаШирокаяОтчет           = Макет.ПолучитьОбласть("СтрокаШирокая|Отчет");
		ОбластьСтрокаОтчет                  = Макет.ПолучитьОбласть("Строка|Отчет");
		ОбластьОборотОтчет                  = Макет.ПолучитьОбласть("Оборот|Отчет");
		ОбластьКонечныйОстатокОтчет         = Макет.ПолучитьОбласть("КонечныйОстаток|Отчет");
		
		ЗапросПоИтогам = Новый Запрос;
		ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	&ДатаНачала КАК Период,
		|	ДенежныеСредстваНаличныеОстатки.СуммаОстаток КАК СуммаНачальныйОстатокДт,
		|	0 КАК СуммаОборотДт,
		|	0 КАК СуммаОборотКт,
		|	0 КАК СуммаОборот
		|ИЗ
		|	РегистрНакопления.ДенежныеСредства.Остатки(
		|			&ДатаНачала,
		|			Организация = &Организация
		|			И ТипДенежныхСредств = Значение(Перечисление.ТипыДенежныхСредств.Наличные)		
		|			И ДоговорКонтрагента = &ДоговорКонтрагента
		|				%УсловиеКасса%) КАК ДенежныеСредстваНаличныеОстатки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(ДенежныеСредства.Период, ДЕНЬ),
		|	0,
		|	ВЫБОР
		|		КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ДенежныеСредства.Сумма
		|		ИНАЧЕ 0
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|			ТОГДА -ДенежныеСредства.Сумма
		|		ИНАЧЕ 0
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|			ТОГДА -ДенежныеСредства.Сумма
		|		ИНАЧЕ ДенежныеСредства.Сумма
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ДенежныеСредства КАК ДенежныеСредства
		|ГДЕ
		|	ДенежныеСредства.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ДенежныеСредства.Организация = &Организация
		|	И ДенежныеСредства.ТипДенежныхСредств = Значение(Перечисление.ТипыДенежныхСредств.Наличные)
		|	И ДенежныеСредства.ДоговорКонтрагента = &ДоговорКонтрагента
		|	%УсловиеКасса1%
		|	И НЕ ДенежныеСредства.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Справочник.ХозяйственныеОперации.ПеремещениеВКассуККМ))
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период
		|ИТОГИ
		|	СУММА(СуммаНачальныйОстатокДт),
		|	СУММА(СуммаОборотДт),
		|	СУММА(СуммаОборотКт),
		|	СУММА(СуммаОборот)
		|ПО
		|	ОБЩИЕ,
		|	Период ПЕРИОДАМИ(ДЕНЬ, , )";
		
		Если ЗначениеЗаполнено(Касса) Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеКасса%", " И БанковскийСчетКасса = &Касса");
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеКасса1%", " И ДенежныеСредства.БанковскийСчетКасса = &Касса");
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеКасса%", "");
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеКасса1%", "");
		КонецЕсли;
		
		ЗапросПоИтогам.Текст = ТекстЗапроса;
		
		ЗапросПоИтогам.УстановитьПараметр("ДатаНачала",НачалоДня(ДатаНач));
		ЗапросПоИтогам.УстановитьПараметр("ДатаОкончания", КонецДня(ДатаНач));
		ЗапросПоИтогам.УстановитьПараметр("Организация",Организация);
		ЗапросПоИтогам.УстановитьПараметр("ДоговорКонтрагента",ДоговорКонтрагента);
		ЗапросПоИтогам.УстановитьПараметр("Касса", Касса);
		
		РезультатЗапросаПоИтогам = ЗапросПоИтогам.Выполнить();
		
		Если РезультатЗапросаПоИтогам.Пустой() Тогда
			Продолжить;
		КонецЕсли;
		
		ЗапросПоДокументам = Новый Запрос;
		ЗапросПоДокументам.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КассоваяКнигаДокументы.КассовыйОрдер КАК Документ,
		|	НАЧАЛОПЕРИОДА(КассоваяКнигаДокументы.КассовыйОрдер.Дата, ДЕНЬ) КАК День,
		|	КассоваяКнигаДокументы.КассовыйОрдер.Дата КАК ДатаДок,
		|	КассоваяКнигаДокументы.КассовыйОрдер.Номер КАК НомерДок,
		|	ПОДСТРОКА(КассоваяКнигаДокументы.КассовыйОрдер.Основание, 1, 200) КАК Основание,
		|	ВЫБОР
		|		КОГДА КассоваяКнигаДокументы.КассовыйОрдер ССЫЛКА Документ.ПоступлениеВКассу
		|			ТОГДА КассоваяКнигаДокументы.КассовыйОрдер.ПринятоОт
		|		ИНАЧЕ КассоваяКнигаДокументы.КассовыйОрдер.Выдать
		|	КОНЕЦ КАК ТекстДок,
		|	ЕСТЬNULL(КассоваяКнигаДокументы.Приход, 0) КАК Приход,
		|	ЕСТЬNULL(КассоваяКнигаДокументы.Расход, 0) КАК Расход,
		|	КассоваяКнигаДокументы.КорреспондирующийСчет КАК Счет,
		|	КассоваяКнигаДокументы.НомерЛиста КАК НомерЛиста,
		|	КассоваяКнигаДокументы.НомерСтроки КАК НомерСтроки,
		|	ДанныеДокумента.ТипЛиста КАК ТипЛиста,
		|	ДанныеДокумента.ДоговорКонтрагента КАК ДоговорКонтрагента
		|ИЗ
		|	Документ.КассоваяКнига КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.КассоваяКнига.КассовыеОрдера КАК КассоваяКнигаДокументы
		|		ПО ДанныеДокумента.Ссылка = КассоваяКнигаДокументы.Ссылка
		|ГДЕ
		|	ДанныеДокумента.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ДанныеДокумента.Организация = &Организация
		|	И ДанныеДокумента.ДоговорКонтрагента = &ДоговорКонтрагента
		|	И ДанныеДокумента.Касса = &Касса
		|	И ДанныеДокумента.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	День,
		|	НомерЛиста,
		|	НомерСтроки
		|ИТОГИ
		|	СУММА(Приход),
		|	СУММА(Расход),
		|	МИНИМУМ(НомерЛиста)
		|ПО
		|	День,
		|	Документ,
		|	Счет";
		
		ЗапросПоДокументам.УстановитьПараметр("ДатаНачала", НачалоДня(ДатаНач));
		ЗапросПоДокументам.УстановитьПараметр("ДатаОкончания", КонецДня(ДатаНач));
		ЗапросПоДокументам.УстановитьПараметр("Организация", Организация);
		ЗапросПоДокументам.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
		ЗапросПоДокументам.УстановитьПараметр("Касса", Касса);
		РезультатЗапросаПоДокументам = ЗапросПоДокументам.Выполнить();
		
		ТаблицаДокументы = РезультатЗапросаПоДокументам.Выгрузить();
		ТаблицаДокументы.Очистить();
		ТаблицаДокументы.Колонки.Добавить("СтрокаСчет");
		ТаблицаДокументы.Колонки.Добавить("ВидДокумента");
		
		ТипЧисло = ОбщегоНазначения.ОписаниеТипаЧисло(15,2);
		
		РабочаяТаблица = Новый ТаблицаЗначений;
		РабочаяТаблица.Колонки.Добавить("Остаток",   ТипЧисло);
		РабочаяТаблица.Колонки.Добавить("Приход",    ТипЧисло);
		РабочаяТаблица.Колонки.Добавить("Расход",    ТипЧисло);
		
		ВыборкаОбщихИтогов = РезультатЗапросаПоИтогам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Общие");
		
		Строка        = РабочаяТаблица.Добавить();
		
		Если ВыборкаОбщихИтогов.Следующий() Тогда
			Строка.Остаток    = ВыборкаОбщихИтогов["СуммаНачальныйОстатокДт"]-РабочаяТаблица.Итог("Остаток");
		Иначе
			Строка.Остаток    = 0
		КонецЕсли;
		
		ВыборкаИтоговПоДням     = РезультатЗапросаПоИтогам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Период");
		ВыборкаДокументовПоДням = РезультатЗапросаПоДокументам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"День");
		
		ПоПроводкам  = ВыборкаИтоговПоДням.Следующий();
		ПоДокументам = ВыборкаДокументовПоДням.Следующий();
		
		БылиОшибки    = Ложь;
		ВывестиПодвал = Ложь;
		
		СведенияОбОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(Организация, ДатаНач);
		
		ТипПКО = Тип("ДокументСсылка.ПоступлениеВКассу");
		ТипРКО = Тип("ДокументСсылка.РасходИзКассы");
		
		Пока ПоПроводкам Или ПоДокументам  Цикл
			
			Если НЕ ПоПроводкам  Тогда
				ДатаЛиста = ВыборкаДокументовПоДням.День;
			ИначеЕсли НЕ ПоДокументам Тогда
				ДатаЛиста = ВыборкаИтоговПоДням.Период;
			Иначе
				ДатаЛиста = Мин(ВыборкаДокументовПоДням.День, ВыборкаИтоговПоДням.Период);
			КонецЕсли;
			
			Если ВыборкаИтоговПоДням.СуммаОборотДт = 0 И ВыборкаИтоговПоДням.СуммаОборотКт = 0 Тогда
				Если НЕ ПоДокументам ИЛИ ДатаЛиста <> ВыборкаДокументовПоДням.День Тогда
					ПоПроводкам = ВыборкаИтоговПоДням.Следующий();
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			КоличествоПриходныхДокументов = 0;
			КоличествоРасходныхДокументов = 0;
			
			ДатаДействияПриказа373П = Дата('20120101');
			
			Остаток = РабочаяТаблица.Итог("Остаток");
			Если ДатаЛиста >= ДатаНач Тогда
				
				Если ДатаЛиста < ДатаДействияПриказа373П Тогда
					
					ЗаголовокЛиста = НСтр("ru = 'КАССА за'") + " " + Формат(ДатаЛиста, "ДЛФ=D");
					ОбластьВкладнойЛистОтчет.Параметры.ЗаголовокЛиста = ЗаголовокЛиста;
					ТабличныйДокумент.Вывести(ОбластьВкладнойЛистОтчет);
					
					ОбластьОтчетКассираОтчет.Параметры.ЗаголовокЛиста = ЗаголовокЛиста;
					ТабличныйДокумент.Присоединить(ОбластьОтчетКассираОтчет);
					
					// Номер первого листа документа "Кассовая книга".
					ОбластьШапкаОтчет.Параметры.ТекстНомерЛиста = НСтр("ru = 'Лист'") + " " + ВыборкаДокументовПоДням.НомерЛиста;
					
				Иначе
					
					ЗаголовокЛиста = НСтр("ru = 'КАССА за'") + " " + Формат(ДатаЛиста, "ДЛФ=DD");
					ТекстНомерЛиста = НСтр("ru = 'Лист'") + " " + ВыборкаДокументовПоДням.НомерЛиста;
					
					ОбластьВкладнойЛист373ПОтчет.Параметры.ЗаголовокЛиста = ЗаголовокЛиста;
					ОбластьВкладнойЛист373ПОтчет.Параметры.ТекстНомерЛиста = ТекстНомерЛиста;
					ТабличныйДокумент.Вывести(ОбластьВкладнойЛист373ПОтчет);
					
					ОбластьОтчетКассира373ПОтчет.Параметры.ЗаголовокЛиста = ЗаголовокЛиста;
					ОбластьОтчетКассира373ПОтчет.Параметры.ТекстНомерЛиста = ТекстНомерЛиста;
					ТабличныйДокумент.Присоединить(ОбластьОтчетКассира373ПОтчет);
					
				КонецЕсли;
				
				ТабличныйДокумент.Вывести(ОбластьШапкаОтчет);
				ТабличныйДокумент.Присоединить(ОбластьШапкаОтчет);
				
				ОбластьОстатокНаНДОтчет.Параметры.ОстатокНачало = Остаток;
				ТабличныйДокумент.Вывести(ОбластьОстатокНаНДОтчет);
				ТабличныйДокумент.Присоединить(ОбластьОстатокНаНДОтчет);
				
			КонецЕсли;
			
			ТаблицаДокументы.Очистить();
			
			Если ПоДокументам И ВыборкаДокументовПоДням.День = ДатаЛиста Тогда
				
				ВыборкаДокументов = ВыборкаДокументовПоДням.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Документ");
				
				Пока ВыборкаДокументов.Следующий() Цикл
					
					НоваяСтрока = ТаблицаДокументы.Добавить();
					НоваяСтрока.ВидДокумента = ?(ТипЗнч(ВыборкаДокументов.Документ) = ТипПКО, "ПриходныйОрдер", "РасходныйОрдер");
					НоваяСтрока.Документ     = ВыборкаДокументов.Документ;
					НоваяСтрока.ДатаДок      = ВыборкаДокументов.ДатаДок;
					НоваяСтрока.День         = ВыборкаДокументов.День;
					НоваяСтрока.НомерДок     = ВыборкаДокументов.НомерДок;
					НоваяСтрока.Приход       = ВыборкаДокументов.Приход;
					НоваяСтрока.Расход       = ВыборкаДокументов.Расход;
					НоваяСтрока.Основание    = ВыборкаДокументов.Основание;
					НоваяСтрока.ТекстДок     = ВыборкаДокументов.ТекстДок;
					НоваяСтрока.НомерЛиста   = ВыборкаДокументов.НомерЛиста;

					ОбработатьДокументПеремещениеДенег(НоваяСтрока, ТипЗнч(ВыборкаДокументов.Документ));
					
					ВыборкаСчетов = ВыборкаДокументов.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Счет");
					СписокСчетов  = Новый ТаблицаЗначений;
					СписокСчетов.Колонки.Добавить("Счет");
					Пока ВыборкаСчетов.Следующий() Цикл
						
						СтрокаТаблицыСчетов      = СписокСчетов.Добавить();
						СтрокаТаблицыСчетов.Счет = ВыборкаСчетов.Счет;
						
					КонецЦикла;
					
					СписокСчетов.Свернуть("Счет");
					
					СтрокаСчет = "";
					Для Каждого СтрокаТаблицыСчетов Из СписокСчетов Цикл
						СтрокаСчет = СтрокаСчет + СтрокаТаблицыСчетов.Счет + Символы.ПС;
					КонецЦикла;
					
					НоваяСтрока.СтрокаСчет = СтрокаСчет;
					
				КонецЦикла;
				
			КонецЕсли;
			
			ПерваяСтрока = 1;
			
			ПредыдущийНомерЛиста = ВыборкаДокументовПоДням.НомерЛиста;
			
			Для Каждого Документ Из ТаблицаДокументы Цикл
				
				Если Документ.ВидДокумента = "РасходныйОрдер" Тогда
					Клиент = НСтр("ru = 'Выдано'") + " " + СокрЛП(Документ.ТекстДок) + ?(ВыводитьОснования = 1, " " + СокрЛП(Документ.Основание), "");
					КоличествоРасходныхДокументов = КоличествоРасходныхДокументов + 1;
					Расход    = Окр(?(Документ.Расход=null,0,Документ.Расход),2,1);
					Приход    = 0;
				Иначе
					Клиент = НСтр("ru = 'Принято от'") + " " + СокрЛП(Документ.ТекстДок) + ?(ВыводитьОснования = 1, " " + СокрЛП(Документ.Основание), "");
					КоличествоПриходныхДокументов = КоличествоПриходныхДокументов + 1;
					Приход    = Окр(?(Документ.Приход=null,0,Документ.Приход),2,1);
					Расход    = 0;
				КонецЕсли;
				
				НомерДокПечатнойФормы = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(
				Документ.НомерДок,
				Ложь,
				Истина);
				КоррСчет = Документ.СтрокаСчет;
				
				// Начинаем новую страницу
				Если ПредыдущийНомерЛиста <> Документ.НомерЛиста Тогда
					
					ПриходЗаДень = РабочаяТаблица.Итог("Приход");
					РасходЗаДень = РабочаяТаблица.Итог("Расход");
					
					Если ДатаЛиста >= ДатаНач Тогда
						
						ОбластьПереносОтчет.Параметры.ПриходЗаДень = ПриходЗаДень;
						ОбластьПереносОтчет.Параметры.РасходЗаДень = РасходЗаДень;
						ТабличныйДокумент.Вывести(ОбластьПереносОтчет);
						ТабличныйДокумент.Присоединить(ОбластьПереносОтчет);
						
						ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
						ОбластьШапкаОтчет.Параметры.ТекстНомерЛиста = "Лист " + Документ.НомерЛиста;
						ТабличныйДокумент.Вывести(ОбластьШапкаОтчет);
						ТабличныйДокумент.Присоединить(ОбластьШапкаОтчет);
						
					КонецЕсли;
					
					ПредыдущийНомерЛиста = Документ.НомерЛиста;
					
				КонецЕсли;
				
				Если ДатаЛиста >= ДатаНач Тогда
					Если ВыводитьОснования Тогда
						
						ОбластьСтрокаШирокаяОтчет.Параметры.НомерДокПечатнойФормы = НомерДокПечатнойФормы;
						ОбластьСтрокаШирокаяОтчет.Параметры.Контрагент = Клиент;
						ОбластьСтрокаШирокаяОтчет.Параметры.КоррСчет   = КоррСчет;
						ОбластьСтрокаШирокаяОтчет.Параметры.Приход     = Приход;
						ОбластьСтрокаШирокаяОтчет.Параметры.Расход     = Расход;
						ОбластьСтрокаШирокаяОтчет.Параметры.Документ   = Документ.Документ;
						
						ТабличныйДокумент.Вывести(ОбластьСтрокаШирокаяОтчет);
						ТабличныйДокумент.Присоединить(ОбластьСтрокаШирокаяОтчет);
						
					Иначе
						
						ОбластьСтрокаОтчет.Параметры.НомерДокПечатнойФормы = НомерДокПечатнойФормы;
						ОбластьСтрокаОтчет.Параметры.Контрагент = Клиент;
						ОбластьСтрокаОтчет.Параметры.КоррСчет   = КоррСчет;
						ОбластьСтрокаОтчет.Параметры.Приход     = Приход;
						ОбластьСтрокаОтчет.Параметры.Расход     = Расход;
						ОбластьСтрокаОтчет.Параметры.Документ   = Документ.Документ;
						
						ТабличныйДокумент.Вывести(ОбластьСтрокаОтчет);
						ТабличныйДокумент.Присоединить(ОбластьСтрокаОтчет);
					КонецЕсли;
				КонецЕсли;
				
				ДобавитьОбороты(РабочаяТаблица, Приход, Расход);
				
			КонецЦикла;
			
			ПриходЗаДень = РабочаяТаблица.Итог("Приход");
			РасходЗаДень = РабочаяТаблица.Итог("Расход");
			
			Если ДатаЛиста >= ДатаНач Тогда
				
				ОбластьОборотОтчет.Параметры.ПриходЗаДень = ПриходЗаДень;
				ОбластьОборотОтчет.Параметры.РасходЗаДень = РасходЗаДень;
				
				ТабличныйДокумент.Вывести(ОбластьОборотОтчет);
				ТабличныйДокумент.Присоединить(ОбластьОборотОтчет);
				
			КонецЕсли;
			
			ПерваяСтрока = Истина;
			Остаток      = Остаток + ПриходЗаДень - РасходЗаДень;
			
			Если ДатаЛиста >= ДатаНач Тогда
				
				ОбластьКонечныйОстатокОтчет.Параметры.ОстатокКонец = Остаток;
				
				ТабличныйДокумент.Вывести(ОбластьКонечныйОстатокОтчет);
				ТабличныйДокумент.Присоединить(ОбластьКонечныйОстатокОтчет);
				
				ОбластьПодвалОтчет.Параметры.НадписьКолПриходныхРасходных= ?(КоличествоПриходныхДокументов>0, ЧислоПрописью(КоличествоПриходныхДокументов,"НД=Ложь",",,,,,,,,0")," - ")
					+ НСтр("ru = 'приходных и'") + " "
					+ ?(КоличествоРасходныхДокументов>0,ЧислоПрописью(КоличествоРасходныхДокументов,"НД=Ложь",",,,,,,,,0")," - ")
					+ НСтр("ru = 'расходных получил.'");
					
				
				
				ОбластьПодвалОтчет.Параметры.ГлБухгалтер = ВыборкаПоДокументамКассоваяКнига.РасшифровкаПодписиГлавногоБухгалтера;
				ОбластьПодвалОтчет.Параметры.Кассир = ВыборкаПоДокументамКассоваяКнига.РасшифровкаПодписиКассира;
				
				ТабличныйДокумент.Вывести(ОбластьПодвалОтчет);
				ТабличныйДокумент.Присоединить(ОбластьПодвалОтчет);
			КонецЕсли;
			
			Строка.Остаток = 0;
			
			Если (ДатаЛиста = ВыборкаИтоговПоДням.Период) Тогда
				СуммаКонечныйОстатокДт = ВыборкаИтоговПоДням.СуммаНачальныйОстатокДт + ВыборкаИтоговПоДням.СуммаОборот;
				Строка.Остаток = СуммаКонечныйОстатокДт - РабочаяТаблица.Итог("Остаток");
			Иначе
				Если ПоПроводкам Тогда
					Строка.Остаток = ВыборкаИтоговПоДням.СуммаНачальныйОстатокДт - РабочаяТаблица.Итог("Остаток");
				Иначе
					Строка.Остаток = -РабочаяТаблица.Итог("Остаток");
				КонецЕсли;
			КонецЕсли;
			
			РабочаяТаблица.ЗаполнитьЗначения(0,"Приход, Расход");
			
			Если ПоПроводкам И ДатаЛиста = ВыборкаИтоговПоДням.Период Тогда
				ПоПроводкам = ВыборкаИтоговПоДням.Следующий();
			КонецЕсли;
			Если ПоДокументам И ДатаЛиста = ВыборкаДокументовПоДням.День Тогда
				ПоДокументам = ВыборкаДокументовПоДням.Следующий();
			КонецЕсли;
			
			ВывестиПодвал = Истина;
			
		КонецЦикла;
		
		Если ВывестиПодвал Тогда
			
			Если ВыборкаПоДокументамКассоваяКнига.ТипЛиста = Перечисления.ТипыЛистовКассовойКниги.ПоследнийВМесяце Тогда
				
				КоличествоЛистов = ПолучитьКоличествоЛистовКассовойКнигиЗаПериодПоОрганизации(
				ВыборкаПоДокументамКассоваяКнига.Организация,
				ВыборкаПоДокументамКассоваяКнига.ДоговорКонтрагента,
				НачалоМесяца(ВыборкаПоДокументамКассоваяКнига.Дата),
				КонецМесяца(ВыборкаПоДокументамКассоваяКнига.Дата));
				
				ОбластьЛистовЗаМесяцОтчет.Параметры.НадписьЛистовЗаМесяц = НСтр("ru = 'Количество листов кассовой книги за месяц:'")
																			+ " " + КоличествоЛистов;
				ТабличныйДокумент.Вывести(ОбластьЛистовЗаМесяцОтчет);
				ТабличныйДокумент.Присоединить(ОбластьЛистовЗаМесяцОтчет);
				
			КонецЕсли;
			
			Если ВыборкаПоДокументамКассоваяКнига.ТипЛиста = Перечисления.ТипыЛистовКассовойКниги.ПоследнийВГоду Тогда
				
				КоличествоЛистов = ПолучитьКоличествоЛистовКассовойКнигиЗаПериодПоОрганизации(
				ВыборкаПоДокументамКассоваяКнига.Организация,
				ВыборкаПоДокументамКассоваяКнига.ДоговорКонтрагента,
				НачалоГода(ВыборкаПоДокументамКассоваяКнига.Дата),
				КонецГода(ВыборкаПоДокументамКассоваяКнига.Дата));
				
				ОбластьЛистовЗаГодОтчет.Параметры.НадписьЛистовЗаГод = НСтр("ru = 'Количество листов кассовой книги за год:'")
																			+ " " + КоличествоЛистов;
				ТабличныйДокумент.Вывести(ОбластьЛистовЗаГодОтчет);
				ТабличныйДокумент.Присоединить(ОбластьЛистовЗаГодОтчет);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
		ТабличныйДокумент,
		НомерСтрокиНачало,
		ОбъектыПечати,
		ВыборкаПоДокументамКассоваяКнига.Ссылка);
		
	КонецЦикла; // Цикл по выделенным документам.
	
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ОбработатьДокументПеремещениеДенег(НоваяСтрока, ТипДокумента)

	Если ТипДокумента = Тип("ДокументСсылка.ПеремещениеДС") Тогда
		НоваяСтрока.ВидДокумента = ?(НоваяСтрока.Приход <> 0, "ПриходныйОрдер", "РасходныйОрдер");  // Не локализуется
	КонецЕсли;
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// Параметры:
//  МассивОбъектов - Массив - список объектов, для которых была выполнена процедура Печать;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - содержит сформированные табличные документы и дополнительную информацию;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах, где
//                                   значение - Объект, представление - имя области с объектом в табличных документах;
//  ПараметрыВывода - Структура - параметры, связанные с выводом табличных документов:
//   * ПараметрыОтправки - Структура - для заполнения письма при отправке печатной формы по электронной почте.
//                    см. РаботаСПочтовымиСообщениямиКлиент.РаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	//Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КассоваяКнига") Тогда
	//	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
	//	КоллекцияПечатныхФорм,
	//	"КассоваяКнига",
	//	НСтр("ru = 'Кассовая книга'"),
	//	СформироватьПечатнуюФормуЛистаКассовойКниги(МассивОбъектов, ОбъектыПечати));
	//КонецЕсли;
	//
	//Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Обложка") Тогда
	//	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
	//	КоллекцияПечатныхФорм,
	//	"Обложка",
	//	НСтр("ru = 'Титульный лист кассовой книги'"),
	//	СформироватьПечатнуюФормуОбложкиИПоследнегоЛистаКассовойКниги(МассивОбъектов, ОбъектыПечати));
	//КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЛистКассовойКниги") Тогда
		ОписаниеПечатнойФормы = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "ЛистКассовойКниги");
		Если ОписаниеПечатнойФормы <> Неопределено Тогда
			
			ОписаниеПечатнойФормы.ТабличныйДокумент = Новый ТабличныйДокумент;
			ОписаниеПечатнойФормы.ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЛистКассовойКниги";
			ОписаниеПечатнойФормы.ПолныйПутьКМакету = "Документ.КассоваяКнига.ПФ_MXL_ЛистКассовойКниги";
			ОписаниеПечатнойФормы.СинонимМакета = НСтр("ru = 'КО-4 (Лист кассовой книги)'");
			
			СформироватьПечатнуюФормуЛистаКассовойКниги(ОписаниеПечатнойФормы, МассивОбъектов, ОбъектыПечати);
			
		КонецЕсли;
	
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Обложка") Тогда
		
		ОписаниеПечатнойФормы = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "Обложка");
		Если ОписаниеПечатнойФормы <> Неопределено Тогда
			
			ОписаниеПечатнойФормы.ТабличныйДокумент = Новый ТабличныйДокумент;
			ОписаниеПечатнойФормы.ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОбложкаКассовойКниги";
			ОписаниеПечатнойФормы.ПолныйПутьКМакету = "Документ.КассоваяКнига.ПФ_MXL_ОбложкаКассовойКниги";
			ОписаниеПечатнойФормы.СинонимМакета = НСтр("ru = 'КО-4 (Обложка кассовой книги)'");
			
			СформироватьПечатнуюФормуОбложкиИПоследнегоЛистаКассовойКниги(ОписаниеПечатнойФормы, МассивОбъектов, ОбъектыПечати);
			
		КонецЕсли;
	
	КонецЕсли;
	
	// параметры отправки печатных форм по электронной почте
	ЭлектроннаяПочтаУНФ.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов,
		КоллекцияПечатныхФорм);
	
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЛистКассовойКниги,Обложка";
	КомандаПечати.Представление = ПечатьДокументовУНФ.ПредставлениеКомплектаДокументов();
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ЛистКассовойКниги";
	КомандаПечати.Представление = НСтр("ru = 'Лист кассовой книги (без обложки)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 4;	
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Обложка";
	КомандаПечати.Представление = НСтр("ru = 'Титульный лист кассовой книги'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 8;	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
