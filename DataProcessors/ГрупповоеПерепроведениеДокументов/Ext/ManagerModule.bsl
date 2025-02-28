﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ПерепроведениеДокументов(СтруктураПараметров, АдресХранилища) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", ?(СтруктураПараметров.НачалоПериода = Неопределено, '00010101', НачалоДня(СтруктураПараметров.НачалоПериода)));
	Если ЗначениеЗаполнено(СтруктураПараметров.КонецПериода) Тогда
		Запрос.УстановитьПараметр("КонецПериода", КонецДня(СтруктураПараметров.КонецПериода));
	КонецЕсли;
	Запрос.УстановитьПараметр("Организация", СтруктураПараметров.Организация);
	
	ВозвращаемыеПараметры = Новый Структура("ПроведеноДокументов, НеУдалосьПровести, Ошибки", 0, 0, Неопределено);
	
	Запрос.Текст = ТекстЗапросаПоПервичнымДокументам();
	
	// Устанавливаем отбор по организации
	ТекстУсловияПоОрганизации = ?(ЗначениеЗаполнено(СтруктураПараметров.Организация), "И Журнал.Организация В (&Организация)", "");
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеОрганизации", ТекстУсловияПоОрганизации);
	
	// Устанавливаем отбор по периоду
	Если ЗначениеЗаполнено(СтруктураПараметров.КонецПериода) Тогда
		ТекстУсловияПериода = ?(ЗначениеЗаполнено(СтруктураПараметров.НачалоПериода), "И Журнал.Дата МЕЖДУ &НачалоПериода И &КонецПериода", " И Журнал.Дата <= &КонецПериода");
	ИначеЕсли ЗначениеЗаполнено(СтруктураПараметров.НачалоПериода) Тогда
		ТекстУсловияПериода = " И Журнал.Дата >= &НачалоПериода";
	Иначе
		ТекстУсловияПериода = "";
	КонецЕсли; 
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПериода", ТекстУсловияПериода);
	Запрос.Текст = Запрос.Текст + "
		|УПОРЯДОЧИТЬ ПО
		|	Дата, Ссылка";
	
	ВсеДокументы = Запрос.Выполнить().Выгрузить();
	
	ИндексСтрокиНачалаДаты	= Неопределено;
	ТекущаяДатаПроведения	= Неопределено;
	ВсегоДокументов			= ВсеДокументы.Количество();
	
	Для Индекс = 0 По ВсегоДокументов - 1 Цикл
		
		СтрокаДокумента = ВсеДокументы[Индекс];
		ДокументОбъект = СтрокаДокумента.Ссылка.ПолучитьОбъект();
		
		Если ТекущаяДатаПроведения <> ДокументОбъект.Дата Тогда
			
			ИндексСтрокиНачалаДаты = Индекс;
			ТекущаяДатаПроведения  = ДокументОбъект.Дата;
			
		КонецЕсли;
		
		ПредставлениеДокумента = Строка(ДокументОбъект.Ссылка);
		
		Попытка
			
			Если ДокументОбъект.ПроверитьЗаполнение() Тогда
				
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
				ВозвращаемыеПараметры.ПроведеноДокументов = ВозвращаемыеПараметры.ПроведеноДокументов + 1;
				
			Иначе
				
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Документ %1 не проведен %2 по причине: ошибка проверки заполнения.'"), ПредставлениеДокумента, Символы.ПС);
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(ВозвращаемыеПараметры.Ошибки, Неопределено, ТекстСообщения, "");
				
			КонецЕсли;
			
		Исключение
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			
			ТекстСообщения = НСтр("ru = 'Документ %1 не проведен %2 по причине: %3'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, ПредставлениеДокумента, Символы.ПС, ОписаниеОшибки());
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(ВозвращаемыеПараметры.Ошибки, Неопределено, ТекстСообщения, "");
			
			ВозвращаемыеПараметры.НеУдалосьПровести = ВозвращаемыеПараметры.НеУдалосьПровести + 1;
			
			Если СтруктураПараметров.ОстанавливатьсяПоОшибке Тогда
				
				Прервать;
				
			КонецЕсли;
			
		КонецПопытки;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ВозвращаемыеПараметры, АдресХранилища);
	
КонецПроцедуры

Функция ТекстЗапросаПоПервичнымДокументам()

	КомпонентыЗапроса = Новый Массив;
	
	Для Каждого МетаданныеДокумента Из Метаданные.Документы Цикл
		
		// У некоторых ролей нет прав на отдельные документы
		Если Не ПравоДоступа("Чтение", МетаданныеДокумента) Тогда
			Продолжить;
		КонецЕсли;
		
		// Отсекаем документы, которые не следует перепроводить
		Если МетаданныеДокумента.Проведение <> Метаданные.СвойстваОбъектов.Проведение.Разрешить Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяДокумента = МетаданныеДокумента.Имя;
		СинонимДокумента = СтрЗаменить(МетаданныеДокумента.Синоним, """", """""");
		
		ТекстЗапроса = СтрШаблон(
		"ВЫБРАТЬ
		|	Журнал.Дата КАК Дата,
		|	""%1"" КАК ИмяДокумента,
		|	""%2"" КАК СинонимДокумента,
		|	Журнал.Ссылка КАК Ссылка,
		|	NULL КАК Поле1,
		|	NULL КАК Поле2,
		|	NULL КАК Поле3,
		|	ЛОЖЬ КАК Выполнена,
		|	Журнал.Представление КАК Представление,
		|	ЛОЖЬ КАК БылаОшибка
		|ИЗ
		|	&ТаблицаДокумента КАК Журнал
		|ГДЕ
		|	Журнал.Проведен
		|	И &УсловиеПериода", ИмяДокумента, СинонимДокумента);
		
		Если Не ЗначениеЗаполнено(КомпонентыЗапроса) Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВЫБРАТЬ", "ВЫБРАТЬ РАЗРЕШЕННЫЕ");
		КонецЕсли;
		
		ТаблицаДокумента = МетаданныеДокумента.ПолноеИмя();
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТаблицаДокумента", ТаблицаДокумента);
		
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Организация", МетаданныеДокумента) Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеПериода", "И &УсловиеПериода
			|	И &УсловиеОрганизации");
		КонецЕсли;
		
		КомпонентыЗапроса.Добавить(ТекстЗапроса);
		
	КонецЦикла;
	
	Результат = СтрСоединить(КомпонентыЗапроса, "
	|ОБЪЕДИНИТЬ ВСЕ
	|");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли