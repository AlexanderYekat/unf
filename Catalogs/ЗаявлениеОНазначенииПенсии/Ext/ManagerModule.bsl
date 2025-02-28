﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СравнитьТабличныеДокументыЗаявлений(Параметры) Экспорт
	
	Объект 			 = Параметры.Объект;
	ТабДокПредыдущий = Параметры.ТабДокПредыдущий;
	АдресХранилища 	 = Параметры.АдресХранилища;
	ИмяМетода        = Параметры.ИмяМетода;
	
	ЕстьИзменения    = Ложь;
	
	Если ТабДокПредыдущий <> Неопределено Тогда
		
		Если ИмяМетода = "ТабличныйДокументЗаявлениеОНазначении" Тогда
			ТабДокПроверяемый = Справочники.ЗаявлениеОНазначенииПенсии.ТабличныйДокументЗаявлениеОНазначении(Объект);
		Иначе
			ТабДокПроверяемый = Справочники.ЗаявлениеОНазначенииПенсии.ТабличныйДокументЗаявлениеОДоставке(Объект);
		КонецЕсли;
		ЕстьИзменения = СравнитьТабличныеДокументы(ТабДокПредыдущий, ТабДокПроверяемый, ИмяМетода);
		
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(ЕстьИзменения, АдресХранилища);
	
КонецПроцедуры

Функция СравнитьТабличныеДокументы(Знач ТабДок1, Знач ТабДок2, ИмяМетода)
	
	ЕстьИзменения = Ложь;
	Для НомерСтроки = 1 по Макс(ТабДок1.ВысотаТаблицы, ТабДок2.ВысотаТаблицы) Цикл
		Для НомерКолонки = 1 по Макс(ТабДок1.ШиринаТаблицы, ТабДок2.ШиринаТаблицы) Цикл
			
			ЯчейкаТабДокПредыдущий  = ТабДок1.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
			ЯчейкаТабДокПроверяемый = ТабДок2.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
			
			Если ЯчейкаТабДокПредыдущий.Текст <> ЯчейкаТабДокПроверяемый.Текст Тогда
				
				ЕстьИзменения = Истина;
				
				Прервать;
				
			КонецЕсли;
		
		КонецЦикла;
		
		Если ЕстьИзменения Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЕстьИзменения;
	
КонецФункции
	
Функция ТабличныйДокументЗаявлениеОНазначении(Ссылка) Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	Бланк = ПолучитьМакет("ЗаявлениеОНазначении");
	
	ЗаполнитьРаздел1(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьРаздел2(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьРаздел3ЗаявлениеОНазначении(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьРаздел4ЗаявлениеОНазначении(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьРаздел5ЗаявлениеОНазначении(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьРаздел6ЗаявлениеОНазначении(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьРаздел7ЗаявлениеОНазначении(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьПодписи(Ссылка, Бланк, ТабДокумент);
	
	ТабДокумент.МасштабПечати = 100;
	
	ТабДокумент.НижнийКолонтитул.ТекстВЦентре = "[&НомерСтраницы]";
	ТабДокумент.НижнийКолонтитул.Выводить = Истина;
	
	Возврат ТабДокумент;

КонецФункции

Процедура ЗаполнитьПодписи(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Подписи");
	
	Область.Параметры.ДатаЗаполнения = Ссылка.ДатаСоздания;
	
	Если Ссылка.ЕстьПредставитель Тогда
		ФИО = ФамилияИнициалы(Ссылка.ПредставительФамилия, Ссылка.ПредставительИмя, Ссылка.ПредставительОтчество);
	Иначе
		ФИО = ФамилияИнициалы(Ссылка.Фамилия, Ссылка.Имя, Ссылка.Отчество);
	КонецЕсли;
	Область.Параметры.РасшифровкаПодписи = ФИО;
		
	ТабДокумент.Вывести(Область);
	
КонецПроцедуры

Функция ФамилияИнициалы(Фамилия, Имя, Отчество)
	
	Если ПустаяСтрока(Отчество) Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1. %2", Лев(Имя, 1), Фамилия);
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1.%2. %3", Лев(Имя, 1), Лев(Отчество, 1), Фамилия);
	
КонецФункции

Процедура ЗаполнитьРаздел7ЗаявлениеОНазначении(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел7");
	
	// Уведомление
		
	Если Ссылка.ЭтоЗаявлениеОДоставкеПенсии Тогда
		
		Уведомить = Ссылка.КогоУведомлятьПочта = Перечисления.ВидыПолучателейПенсии.Пенсионер
			ИЛИ Ссылка.КогоУведомлятьПочта = Перечисления.ВидыПолучателейПенсии.Представитель;
		ПоставитьX(Уведомить, Область.Параметры.Уведомить);
		
		Если Уведомить Тогда
			Если Ссылка.КогоУведомлятьПочта = Перечисления.ВидыПолучателейПенсии.Пенсионер Тогда
				
				// Подчеркиваем пенсионера
				ОбластьУведомитьПенсионера = Область.Области.УведомитьПенсионера;
				ОбластьУведомитьПенсионера.Шрифт = Новый Шрифт(ОбластьУведомитьПенсионера.Шрифт,,,,,Истина);
				
				Область.Параметры.ЭлектроннаяПочтаДляУведомления = Ссылка.ЭлектроннаяПочта;
				
			ИначеЕсли Ссылка.КогоУведомлятьПочта = Перечисления.ВидыПолучателейПенсии.Представитель Тогда
				
				// Подчеркиваем представителя
				ОбластьУведомитьПредставителя = Область.Области.УведомитьПредставителя;
				ОбластьУведомитьПредставителя.Шрифт = Новый Шрифт(ОбластьУведомитьПредставителя.Шрифт,,,,,Истина);

				Область.Параметры.ЭлектроннаяПочтаДляУведомления = Ссылка.ПредставительЭлектроннаяПочта;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
		
	// Информирование
	
	Если Ссылка.ЭтоЗаявлениеОНазначенииПенсии Тогда

		ИнформироватьПоПочте = Ссылка.КогоИнформироватьПочта = Перечисления.ВидыПолучателейПенсии.Пенсионер
			ИЛИ Ссылка.КогоИнформироватьПочта = Перечисления.ВидыПолучателейПенсии.Представитель;
			
		ИнформироватьПоТелефону = Ссылка.КогоИнформироватьТелефон = Перечисления.ВидыПолучателейПенсии.Пенсионер
			ИЛИ Ссылка.КогоИнформироватьТелефон = Перечисления.ВидыПолучателейПенсии.Представитель;
		
		Информировать = ИнформироватьПоПочте ИЛИ ИнформироватьПоТелефону;
			
		ПоставитьX(Информировать, Область.Параметры.Информировать);
		ПоставитьX(ИнформироватьПоПочте, Область.Параметры.ИнформироватьПоПочте);
		ПоставитьX(ИнформироватьПоТелефону, Область.Параметры.ИнформироватьПоТелефону);
		
		Если ИнформироватьПоПочте Тогда
			Если Ссылка.КогоИнформироватьПочта = Перечисления.ВидыПолучателейПенсии.Пенсионер Тогда
				
				// Подчеркиваем пенсионера
				ОбластьИнформироватьПенсионера = Область.Области.ИнформироватьПенсионера;
				ОбластьИнформироватьПенсионера.Шрифт = Новый Шрифт(ОбластьИнформироватьПенсионера.Шрифт,,,,,Истина);
				
				Область.Параметры.ЭлектроннаяПочтаДляИнформирования = Ссылка.ЭлектроннаяПочта;
				
			ИначеЕсли Ссылка.КогоИнформироватьПочта = Перечисления.ВидыПолучателейПенсии.Представитель Тогда
				
				// Подчеркиваем представителя
				ОбластьИнформироватьПредставиетеля = Область.Области.ИнформироватьПредставиетеля;
				ОбластьИнформироватьПредставиетеля.Шрифт = Новый Шрифт(ОбластьИнформироватьПредставиетеля.Шрифт,,,,,Истина);
				
				Область.Параметры.ЭлектроннаяПочтаДляИнформирования = Ссылка.ПредставительЭлектроннаяПочта;
				
			КонецЕсли;
		Конецесли;
		
		Если ИнформироватьПоТелефону Тогда
			Если Ссылка.КогоИнформироватьТелефон = Перечисления.ВидыПолучателейПенсии.Пенсионер Тогда
				Область.Параметры.ТелефонДляИнформирования = Ссылка.Телефон;
			ИначеЕсли Ссылка.КогоИнформироватьТелефон = Перечисления.ВидыПолучателейПенсии.Представитель Тогда
				Область.Параметры.ТелефонДляИнформирования = Ссылка.ПредставительТелефон;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ТабДокумент.Вывести(Область);
	
КонецПроцедуры

Процедура ЗаполнитьРаздел6ЗаявлениеОНазначении(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел6");
	ТабДокумент.Вывести(Область);
	
	Номер = 0;
	
	Если ТипЗнч(Ссылка.ЭлектронныеДокументы) = Тип("Массив") Тогда
		
		Для Каждого ЭлектронныйДокумент Из Ссылка.ЭлектронныеДокументы Цикл
			
			Если ЭлектронныйДокумент.Документ <> ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ВидДокументаВложения() Тогда
				Продолжить;
			КонецЕсли;
			
			Номер   = Номер + 1;
			Область = Бланк.ПолучитьОбласть("Раздел6Документы");
			
			Область.Параметры.Номер = Номер;
			Область.Параметры.НаименованиеДокумента = ЭлектронныйДокумент.ИсходноеИмя;
			
			ТабДокумент.Вывести(Область);
			
		КонецЦикла;
		
	Иначе
		
		Для Каждого ЭлектронныйДокумент Из Ссылка.ЭлектронныеДокументы Цикл
			
			ДополнительныеПараметры = РаботаСФайламиКлиентСервер.ПараметрыДанныхФайла();
			ДополнительныеПараметры.ИдентификаторФормы 				= Новый УникальныйИдентификатор;
			ДополнительныеПараметры.ПолучатьСсылкуНаДвоичныеДанные 	= Истина;
			ДанныеФайла 			= РаботаСФайлами.ДанныеФайла(ЭлектронныйДокумент.Файл, ДополнительныеПараметры);
			ЭтоВидДокументаВложения = ЭлектронныйДокумент.Документ = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ВидДокументаВложения();
			
			Если ЭтоВидДокументаВложения Тогда
				
				Номер   = Номер + 1;
				Область = Бланк.ПолучитьОбласть("Раздел6Документы");
				
				Область.Параметры.Номер = Номер;
				Область.Параметры.НаименованиеДокумента = ДанныеФайла.ИмяФайла;
				
				ТабДокумент.Вывести(Область);
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Если Номер = 0 Тогда
		Область = Бланк.ПолучитьОбласть("Раздел6Документы");
		ТабДокумент.Вывести(Область);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРаздел5ЗаявлениеОНазначении(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел5");
	ТабДокумент.Вывести(Область);
	
КонецПроцедуры

Процедура ЗаполнитьРаздел4ЗаявлениеОНазначении(Ссылка, Бланк, ТабДокумент)
	
	ЗаполнитьПункт4а_4в(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьПункт4г_4д(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьПункт4е(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьПункт4ж(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьПункт4з(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьПункт4и(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьПункт4к_4м(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьПункт4н(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьПункт4о_4п(Ссылка, Бланк, ТабДокумент);
	
КонецПроцедуры

Процедура ЗаполнитьПункт4а_4в(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел4а_4в");
	Область.Параметры.Заполнить(Ссылка);

	ПоставитьX(Ссылка.Работает, Область.Параметры.РаботаетПредставление);
	ПоставитьX(НЕ Ссылка.Работает, Область.Параметры.НеРаботаетПредставление);
	
	Если Ссылка.НетрудоспособныхЧленов > 0 Тогда
		Область.Параметры.НетрудоспособныхЧленовПредставление = Ссылка.НетрудоспособныхЧленов;
	Иначе
		Область.Параметры.НетрудоспособныхЧленовПредставление = "Нет";
	КонецЕсли;
	
	ТабДокумент.Вывести(Область);
	
	// ТЧ Дети
	Если Ссылка.Дети.Количество() > 0 Тогда
		Для каждого СтрокаДети Из Ссылка.Дети Цикл
			
			Область = Бланк.ПолучитьОбласть("Раздел4Дети");
			Область.Параметры.Дети_ФИО 			= СтрокаДети.ФИО;
			Область.Параметры.Дети_ДатаРождения = СтрокаДети.ДатаРождения;
			Область.Параметры.Дети_СНИЛС 		= СтрокаДети.СНИЛС;
			
			ТабДокумент.Вывести(Область);
		КонецЦикла;
	Иначе
		Область = Бланк.ПолучитьОбласть("Раздел4Дети");
		ТабДокумент.Вывести(Область);
	КонецЕсли;
	
КонецПроцедуры
	
Процедура ЗаполнитьПункт4г_4д(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел4г_4д");
	Область.Параметры.Заполнить(Ссылка);
	ТабДокумент.Вывести(Область);
	
	// ТЧ ВоеннаяСлужба
	Если Ссылка.ВоеннаяСлужба.Количество() > 0 Тогда
		Для каждого СтрокаВоеннаяСлужба Из Ссылка.ВоеннаяСлужба Цикл
			
			Область = Бланк.ПолучитьОбласть("Раздел4ВоеннаяСлужба");
			Область.Параметры.ВоеннаяСлужба_ДатаНачала 	  = СтрокаВоеннаяСлужба.ДатаНачала;
			Область.Параметры.ВоеннаяСлужба_ДатаОкончания = СтрокаВоеннаяСлужба.ДатаОкончания;
			
			ТабДокумент.Вывести(Область);
			
		КонецЦикла;
	Иначе
		Область = Бланк.ПолучитьОбласть("Раздел4ВоеннаяСлужба");
		ТабДокумент.Вывести(Область);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПункт4е(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел4_3");
	ТабДокумент.Вывести(Область);
	
	Если Ссылка.ИнвалидыПожилые.Количество() > 0 Тогда
		Для каждого СтрокаИнвалидыПожилые Из Ссылка.ИнвалидыПожилые Цикл
			
			Область = Бланк.ПолучитьОбласть("Раздел4ИнвалидыПожилые");
			Область.Параметры.ИнвалидыПожилые_ФИО 	  	 	= СтрокаИнвалидыПожилые.ФИО;
			Область.Параметры.ИнвалидыПожилые_СНИЛС 	 	= СтрокаИнвалидыПожилые.СНИЛС;
			Область.Параметры.ИнвалидыПожилые_ДатаНачала 	= СтрокаИнвалидыПожилые.ДатаНачала;
			Область.Параметры.ИнвалидыПожилые_ДатаОкончания = СтрокаИнвалидыПожилые.ДатаОкончания;
			
			ТабДокумент.Вывести(Область);
			
		КонецЦикла;
	Иначе
		Область = Бланк.ПолучитьОбласть("Раздел4ИнвалидыПожилые");
		ТабДокумент.Вывести(Область);
	КонецЕсли;
	
КонецПроцедуры
	
Процедура ЗаполнитьПункт4ж(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел4ж");
	Область.Параметры.Заполнить(Ссылка);
	
	ПоставитьXДляПолучателяИКормильца(
		Ссылка, 
		Область, 
		"ПолучаетПенсиюДругогоГосударства", 
		"УмершийКормилецПолучалПенсиюДругогоГосударства");
		
	Если Ссылка.ПолучаетПенсиюДругогоГосударства = Перечисления.ОтветыНаВопросыОПенсии.Да Тогда
		Область.Параметры.СтранаВыплачивающаяПенсиюПредставление = Ссылка.СтранаВыплачивающаяПенсию;
	КонецЕсли;
	
	Если ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоСтраховаяПенсияПоПотереКормильца(Ссылка)
		И Ссылка.УмершийКормилецПолучалПенсиюДругогоГосударства = Перечисления.ОтветыНаВопросыОПенсии.Да Тогда
		
		Область.Параметры.СтранаВыплачивающаяПенсиюУмершемуКормильцуПредставление = Ссылка.СтранаВыплачивающаяПенсиюУмершемуКормильцу;
		
	КонецЕсли;
	
	ТабДокумент.Вывести(Область);
	
КонецПроцедуры

Процедура ЗаполнитьПункт4з(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел4з");
	Область.Параметры.Заполнить(Ссылка);
	
	ПоставитьXДляПолучателяИКормильца(
		Ссылка, 
		Область, 
		"ПолучаетПенсиюПоФЗ4468_1", 
		"УмершийКормилецПолучаетПенсиюПоФЗ4468_1");
	
	Если Ссылка.ПолучаетПенсиюПоФЗ4468_1 = Перечисления.ОтветыНаВопросыОПенсии.Да Тогда
		Область.Параметры.ВидПенсииПоФЗ4468_1Представление = Ссылка.ВидПенсииПоФЗ4468_1;
	КонецЕсли;
	
	Если ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоСтраховаяПенсияПоПотереКормильца(Ссылка)
		И Ссылка.УмершийКормилецПолучаетПенсиюПоФЗ4468_1 = Перечисления.ОтветыНаВопросыОПенсии.Да Тогда
		
		Область.Параметры.ОрганВыплачивающийПенсиюУмершемуКормильцуПредставление = Ссылка.ОрганВыплачивающийПенсиюУмершемуКормильцу;
		
	КонецЕсли;
	
	ТабДокумент.Вывести(Область);
	
КонецПроцедуры

Процедура ЗаполнитьПункт4и(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел4и");
	Область.Параметры.Заполнить(Ссылка);
	
	ПоставитьXДляПолучателяИКормильца(
		Ссылка, 
		Область, 
		"ПолучаетПенсиюПоФЗ3132_1", 
		"УмершийКормилецПолучаетПенсиюПоФЗ3132_1");
	
	ТабДокумент.Вывести(Область);
	
КонецПроцедуры

Процедура ЗаполнитьПункт4к_4м(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел4к_4м");
	Область.Параметры.Заполнить(Ссылка);
	
	ПоставитьX(Ссылка.ВступилВБрак, Область.Параметры.ВступилВБрак_Да);
	ПоставитьX(НЕ Ссылка.ВступилВБрак, Область.Параметры.ВступилВБрак_Нет);
	
	ПоставитьX(Ссылка.ПрописанВДругомГосударстве, Область.Параметры.ПрописанВДругомГосударстве_Да);
	ПоставитьX(НЕ Ссылка.ПрописанВДругомГосударстве, Область.Параметры.ПрописанВДругомГосударстве_Нет);
	
	ПоставитьX(Ссылка.СогласенНаПерерасчетПенсии, Область.Параметры.СогласенНаПерерасчетПенсии_Да);
	
	ТабДокумент.Вывести(Область);
	
КонецПроцедуры

Процедура ЗаполнитьПункт4н(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел4н");
	Область.Параметры.Заполнить(Ссылка);
	
	ПоставитьXДляПолучателяИКормильца(
		Ссылка, 
		Область, 
		"ЗамещаетГосударственнуюДолжность", 
		"УмершийКормилецЗамещалГосударственнуюДолжность");
	
	ТабДокумент.Вывести(Область);
	
КонецПроцедуры

Процедура ЗаполнитьПункт4о_4п(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел4о_4п");
	Область.Параметры.Заполнить(Ссылка);
	
	ПоставитьX(Ссылка.СогласенНеУчитыватьСтажИЗаработок, Область.Параметры.СогласенНеУчитыватьСтажИЗаработок_Да);
	ПоставитьX(НЕ Ссылка.СогласенНеУчитыватьСтажИЗаработок, Область.Параметры.СогласенНеУчитыватьСтажИЗаработок_Нет);
	
	ВыбранВариант2 = Ссылка.СекретныйВопрос = Перечисления.СекретныйВопрос.СекретныйКод;
	
	Если ВыбранВариант2 Тогда
		ПоставитьX(Истина, Область.Параметры.СекретныйВопрос_Вариант2);
		Область.Параметры.ОтветНаСекретныйВопросКод = Ссылка.ОтветНаСекретныйВопрос;
	Иначе
		
		ПоставитьX(Истина, Область.Параметры.СекретныйВопрос_Вариант1);
		
		Ответы = Новый Массив;
		Ответы.Добавить("ДевичьяФамилияМатери");
		Ответы.Добавить("КличкаДомашнегоПитомца");
		Ответы.Добавить("ЛюбимоеБлюдо");
		Ответы.Добавить("ЛюбимыйПисатель");
		Ответы.Добавить("НомерШколы");
		
		Для каждого Ответ Из Ответы Цикл
		
			Если Ссылка.СекретныйВопрос = Перечисления.СекретныйВопрос[Ответ] Тогда
				ПоставитьX(Истина, Область.Параметры["СекретныйВопрос_" + Ответ]);
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		Область.Параметры.ОтветНаСекретныйВопросОтвет = Ссылка.ОтветНаСекретныйВопрос;
		
	КонецЕсли;
	
	ТабДокумент.Вывести(Область);
	
КонецПроцедуры

Процедура ПоставитьXДляПолучателяИКормильца(Ссылка, Область, ИмяРеквизита, ИмяРеквизитаУмершегоКормильца)
	
	Результат = Новый Структура;
	ПроверитьОтветыНаВсеВарианты(Ссылка, Результат, ИмяРеквизита);
	
	// При потере кормильца
	Если ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоСтраховаяПенсияПоПотереКормильца(Ссылка) Тогда
		ПроверитьОтветыНаВсеВарианты(Ссылка, Результат, ИмяРеквизитаУмершегоКормильца);
	КонецЕсли;
	
	Область.Параметры.Заполнить(Результат);
	
КонецПроцедуры

Процедура ПроверитьОтветыНаВсеВарианты(Ссылка, Результат, ИмяРеквизита)
	
	Ответы = Новый Массив;
	Ответы.Добавить("Да");
	Ответы.Добавить("Нет");
	Ответы.Добавить("ДаВПрошлом");
	Ответы.Добавить("НетСведений");
	
	Для каждого Ответ Из Ответы Цикл
		
		Получает = Ссылка[ИмяРеквизита] = Перечисления.ОтветыНаВопросыОПенсии[Ответ];
		Если Получает Тогда
			Результат.Вставить(ИмяРеквизита + "_" + Ответ, "X");
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры	
	
Процедура ПоставитьX(Условие, Параметр)

	Если Условие Тогда
		Параметр = "X";
	КонецЕсли;
	
КонецПроцедуры
 	
Процедура ЗаполнитьРаздел1(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел1");
	Область.Параметры.Заполнить(Ссылка);
	
	ЗаполнитьАдреса(Ссылка, Область);
	ЗаполнитьПол(Ссылка, Область);
	
	ТабДокумент.Вывести(Область);
	
КонецПроцедуры
	
Процедура ЗаполнитьАдреса(Ссылка, Область)
	
	Если Ссылка.МестоПроживания = Перечисления.МестоПроживанияПолучателяПенсии.ПроживаетВРФ Тогда
		Область.Параметры.АдресМестаЖительстваВРФПредставление = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Ссылка.АдресМестаЖительства);
		Область.Параметры.АдресМестаПребыванияВРФПредставление = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Ссылка.АдресМестаПребывания);
		Область.Параметры.АдресФактическийВРФПредставление     = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Ссылка.АдресФактический);
	КонецЕсли;
	
	Если Ссылка.МестоПроживания = Перечисления.МестоПроживанияПолучателяПенсии.ПроживаетЗаПределамиРФ Тогда
		Область.Параметры.АдресЗаПределамиРФНаРусском     = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Ссылка.АдресЗаПределамиРФНаРусском);
		Область.Параметры.АдресЗаПределамиРФНаИностранном = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Ссылка.АдресЗаПределамиРФНаИностранном);
	КонецЕсли;
	
	Если Ссылка.МестоПроживания = Перечисления.МестоПроживанияПолучателяПенсии.ПроживалВРФ Тогда
		Область.Параметры.АдресМестаЖительстваБылВРФПредставление = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Ссылка.АдресМестаЖительства);
		Область.Параметры.АдресМестаПребыванияБылВРФПредставление = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Ссылка.АдресМестаПребывания);
		Область.Параметры.АдресФактическийБылВРФПредставление     = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Ссылка.АдресФактический);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПол(Ссылка, Область)
	
	Если Ссылка.Пол = Перечисления.ПолФизическогоЛица.Женский Тогда
		Область.Параметры.Женский = "X";
	КонецЕсли;
	
	Если Ссылка.Пол = Перечисления.ПолФизическогоЛица.Мужской Тогда
		Область.Параметры.Мужской = "X";
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРаздел3ЗаявлениеОНазначении(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел3");
	Область.Параметры.Заполнить(Ссылка);
	
	Если Ссылка.Действие = Перечисления.ДействиеВЗаявленииОНазначенииПенсии.ВыбратьВидПенсии Тогда
		ОтметитьВидПенсии(Ссылка, Область, "СтраховаяПенсияПоСтарости");
		ОтметитьВидПенсии(Ссылка, Область, "СтраховаяПенсияПоИнвалидности");
		ОтметитьВидПенсии(Ссылка, Область, "СтраховаяПенсияПоПотереКормильца");
		ОтметитьВидПенсии(Ссылка, Область, "ДоляСтраховойПенсии");
		ОтметитьВидПенсии(Ссылка, Область, "НакопительнаяПенсия");
		ОтметитьВидПенсии(Ссылка, Область, "ПенсияЗаВыслугуЛетПоГосударственномуПенсионномуОбеспечению");
		ОтметитьВидПенсии(Ссылка, Область, "ПенсияПоСтаростиПоГосударственномуПенсионномуОбеспечению");
		ОтметитьВидПенсии(Ссылка, Область, "ПенсияПоИнвалидностиПоГосударственномуПенсионномуОбеспечению");
		ОтметитьВидПенсии(Ссылка, Область, "ПенсияПоСлучаюПотериКормильцаПоГосударственномуПенсионномуОбеспечению");
		ОтметитьВидПенсии(Ссылка, Область, "СоциальнаяПенсияПоСтарости");
		ОтметитьВидПенсии(Ссылка, Область, "СоциальнаяПенсияПоИнвалидности");
		ОтметитьВидПенсии(Ссылка, Область, "СоциальнаяПенсияПоСлучаюПотериКормильца");
		ОтметитьВидПенсии(Ссылка, Область, "СоциальнаяПенсияДетямРодителиКоторыхНеизвестны");
		ОтметитьВидПенсии(Ссылка, Область, "ПенсияПоЗаконуРФ1032_1");
		ОтметитьВидПенсии(Ссылка, Область, "ПенсияПоСтаростиПоЗаконуРФ1244_2");
		
		Если Ссылка.УстановитьСоцДоплату Тогда
			Область.Параметры.УстановитьСоцДоплатуПредставление = "X";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Ссылка.УточнениеПоВидуПенсии) Тогда
			Область.Параметры.УточнениеПоВидуПенсииПредставление = "X";
		КонецЕсли;

		Область.Параметры.ПредыдущийВидПенсии 	= "";
		Область.Параметры.ЗаконодательныйАкт 	= "";
		Область.Параметры.НовыйВидПенсии 		= "";
		
		Если ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоНакопительнаяПенсия(Ссылка) Тогда
		
			Если Ссылка.УчестьДопСтраховыеВзносыВСоставеНакопительной Тогда
				Область.Параметры.УчестьДопСтраховыеВзносыВСоставеНакопительнойУчитывать = "X";
			Иначе
				Область.Параметры.УчестьДопСтраховыеВзносыВСоставеНакопительнойНеУчитывать = "X";
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли Ссылка.Действие = Перечисления.ДействиеВЗаявленииОНазначенииПенсии.ИзменитьВидПенсии Тогда
		
		Область.Параметры.ИзменитьВидПенсииПредставление = "X";
		
	КонецЕсли;
	
	ТабДокумент.Вывести(Область);
	
КонецПроцедуры

Процедура ОтметитьВидПенсии(Ссылка, Область, Поле)
	
	Если Ссылка.ВидПенсииОсновной = Перечисления.ВидПенсии[Поле]
		ИЛИ Ссылка.ВидПенсииВторой = Перечисления.ВидПенсии[Поле] Тогда
		
		Область.Параметры[Поле] = "X";
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура ЗаполнитьРаздел2(Ссылка, Бланк, ТабДокумент)
	
	Область = Бланк.ПолучитьОбласть("Раздел2");
	
	Если НЕ Ссылка.ЕстьПредставитель Тогда
		ТабДокумент.Вывести(Область);
		Возврат;
	КонецЕсли;
	
	Область.Параметры.Заполнить(Ссылка);
	
	ЗаполнитьЗаголовокПредставителя(Ссылка, Бланк, Область);
	ЗаполнитьФИОПредставителя(Ссылка, Область);
	ЗаполнитьАдресаПредставителя(Ссылка, Область);
	
	ТабДокумент.Вывести(Область);
	
КонецПроцедуры

Процедура ЗаполнитьФИОПредставителя(Ссылка, Область)
	
	// Подчеркиваем нужное
	ПредставительФИО = СокрЛП(Ссылка.ПредставительФамилия + " " + Ссылка.ПредставительИмя + " " + Ссылка.ПредставительОтчество);
	Если Ссылка.ВидПредставителя = Перечисления.ВидПредставителяПолучателяПенсии.ЗаконныйПредставитель
		ИЛИ Ссылка.ВидПредставителя = Перечисления.ВидПредставителяПолучателяПенсии.Организация Тогда
		
		Если ЗначениеЗаполнено(Ссылка.ПредставительНаименованиеОрганизации) Тогда
			ПредставительПредставление = Ссылка.ПредставительНаименованиеОрганизации + ", " + ПредставительФИО;
		Иначе
			ПредставительПредставление = ПредставительФИО;
		КонецЕсли;
		
	Иначе
		
		ПредставительПредставление = ПредставительФИО;
		
	КонецЕсли;
	
	Область.Параметры.ПредставительПредставление = ПредставительПредставление;
	
КонецПроцедуры

Процедура ЗаполнитьЗаголовокПредставителя(Ссылка, Бланк, Область)
	
	// Подчеркиваем нужное
	Если Ссылка.ВидПредставителя = Перечисления.ВидПредставителяПолучателяПенсии.ЗаконныйПредставитель Тогда
		ОбластьЗаконныйПредставитель = Область.Области.ЗаконныйПредставитель;
		ОбластьЗаконныйПредставитель.Шрифт = Новый Шрифт(ОбластьЗаконныйПредставитель.Шрифт,,,,,Истина);
	КонецЕсли;
	
	Если Ссылка.ВидПредставителя = Перечисления.ВидПредставителяПолучателяПенсии.Организация Тогда
		ОбластьОрганизацияОпекун = Область.Области.ОрганизацияОпекун;
		ОбластьОрганизацияОпекун.Шрифт = Новый Шрифт(ОбластьОрганизацияОпекун.Шрифт,,,,,Истина);
	КонецЕсли;
	
	Если Ссылка.ВидПредставителя = Перечисления.ВидПредставителяПолучателяПенсии.ДоверенноеЛицо Тогда
		ОбластьДоверенноеЛицо = Область.Области.ДоверенноеЛицо;
		ОбластьДоверенноеЛицо.Шрифт = Новый Шрифт(ОбластьДоверенноеЛицо.Шрифт,,,,,Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьАдресаПредставителя(Ссылка, Область)
	
	Область.Параметры.ПредставительАдресМестаЖительстваПредставление = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Ссылка.ПредставительАдресМестаЖительства);
	Область.Параметры.ПредставительАдресМестаПребыванияПредставление = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Ссылка.ПредставительАдресМестаПребывания);
	Область.Параметры.ПредставительАдресФактическийПредставление     = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Ссылка.ПредставительАдресФактический);
	Область.Параметры.ПредставительАдресОрганизацииПредставление     = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Ссылка.ПредставительАдресОрганизации);
	
КонецПроцедуры

Функция ТабличныйДокументЗаявлениеОДоставке(Ссылка) Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	Бланк = ПолучитьМакет("ЗаявлениеОДоставке");
	
	ЗаполнитьРаздел1(Ссылка, Бланк, ТабДокумент);
	ЗаполнитьРаздел2(Ссылка, Бланк, ТабДокумент);
	
	Область = Бланк.ПолучитьОбласть("Раздел3");
	ЗаполнитьДоставкуЗаявлениеОДоставке(Ссылка, Бланк, ТабДокумент, Область);
	
	Область = Бланк.ПолучитьОбласть("Раздел4");
	ЗаполнитьДоставкуЗаявлениеОДоставке(Ссылка, Бланк, ТабДокумент, Область, "ДоЗаключенияДоговора");
	
	ЗаполнитьПодписи(Ссылка, Бланк, ТабДокумент);
	
	ТабДокумент.МасштабПечати = 100;
	ТабДокумент.НижнийКолонтитул.ТекстВЦентре = "[&НомерСтраницы]";
	ТабДокумент.НижнийКолонтитул.Выводить = Истина;
	
	Возврат ТабДокумент;
	
КонецФункции

Процедура ЗаполнитьДоставкуЗаявлениеОДоставке(Ссылка, Бланк, ТабДокумент, Область, Постфикс = "")
	
	
	Область.Параметры.Заполнить(Ссылка);
	
	// Кому доставлять
	ИмяПоля = "КомуДоставлятьПенсию" + Постфикс;
	
	Условие = Ссылка[ИмяПоля] = Перечисления.ВидыПолучателейПенсии.Пенсионер;
	ПоставитьX(Условие, Область.Параметры[ИмяПоля + "_Пенсионер"]);
	
	Условие = Ссылка[ИмяПоля] = Перечисления.ВидыПолучателейПенсии.Представитель;
	ПоставитьX(Условие, Область.Параметры[ИмяПоля + "_Представитель"]);
		
	// Способ получения пенсии
	ИмяПоля = "СпособПолученияПенсии" + Постфикс;
	
	Варианты = Новый Массив;
	Варианты.Добавить("ПоМестуЖительства");
	Варианты.Добавить("ПоМестуПребывания");
	Варианты.Добавить("ПоМестуФактическому");
	Варианты.Добавить("ПоМестонахождениюОрганизации");
	
	Для каждого Вариант Из Варианты Цикл
		Условие = Ссылка[ИмяПоля] = Перечисления.СпособыПолученияПенсии[Вариант];
		Если Условие Тогда
			// Чтобы не падало, если такого параметра нет.
			// В разделе "до заключения договора" нет этих параметров
			Свойство = Новый Структура(ИмяПоля + "_" + Вариант, "Х");
			Область.Параметры.Заполнить(Свойство);
		КонецЕсли;
	КонецЦикла;
	
	// Организация доставки пенсии
	ИмяПоля = "ВидОрганизацийДоставкиПенсии" + Постфикс;
	
	Варианты = Новый Массив;
	Варианты.Добавить("Почта");
	Варианты.Добавить("КредитнаяОрганизация");
	Варианты.Добавить("ИнаяОрганизация");

	Для каждого Вариант Из Варианты Цикл
		Условие = Ссылка[ИмяПоля] = Перечисления.ВидыОрганизацийДоставкиПенсии[Вариант];
		ПоставитьX(Условие, Область.Параметры[ИмяПоля + "_" + Вариант]);
	КонецЦикла;
	
	// Название организации доставки пенсии
	ИмяПоляВидОрганизации = "ВидОрганизацийДоставкиПенсии" + Постфикс;
	ИмяПоляНаименование   = "НаименованиеОрганизацииДоставкиПенсии" + Постфикс;
	
	Для каждого Вариант Из Варианты Цикл
		Условие = Ссылка[ИмяПоляВидОрганизации] = Перечисления.ВидыОрганизацийДоставкиПенсии[Вариант];
		Если Условие Тогда
			Область.Параметры[ИмяПоляНаименование + "_" + Вариант] = Ссылка.НаименованиеОрганизацииДоставкиПенсии;
		КонецЕсли;
	КонецЦикла;
	
	ИмяПоляВидОрганизации        = "ВидОрганизацийДоставкиПенсии" + Постфикс;
	ИмяПоляСпособПолученияПенсии = "СпособПолученияПенсии" + Постфикс;
	
	Варианты = Новый Массив;
	Варианты.Добавить("Почта");
	Варианты.Добавить("ИнаяОрганизация");
	
	Для каждого Вариант Из Варианты Цикл
		
		ВыбранЭтотВариант = Ссылка[ИмяПоляВидОрганизации] = Перечисления.ВидыОрганизацийДоставкиПенсии[Вариант];
		Если НЕ ВыбранЭтотВариант Тогда
			Продолжить;
		КонецЕсли;
		
		ВКассе = Ссылка[ИмяПоляСпособПолученияПенсии] = Перечисления.СпособыПолученияПенсии.ВКассе;
		ПоставитьX(ВКассе, Область.Параметры[ИмяПоляВидОрганизации + "_" + Вариант + "_ВКассе"]);
		ПоставитьX(НЕ ВКассе, Область.Параметры[ИмяПоляВидОрганизации + "_" + Вариант + "_НаДому"]);
		
		Если НЕ ВКассе Тогда
			Область.Параметры["АдресПолученияПенсии" + Постфикс + "_" + Вариант] = АдресДоставки(Ссылка, Постфикс);
		КонецЕсли;
	
	КонецЦикла;
	
	ТабДокумент.Вывести(Область);
	
КонецПроцедуры

Функция АдресДоставки(Форма, Постфикс = "") Экспорт
	
	СпособПолученияПенсии   = Форма["СпособПолученияПенсии" + Постфикс];
	ДоставлятьПредставителю = Форма["КомуДоставлятьПенсию" + Постфикс] = ПредопределенноеЗначение("Перечисление.ВидыПолучателейПенсии.Представитель");
		
	Адрес = "";
	Если ДоставлятьПредставителю Тогда
		Если СпособПолученияПенсии = ПредопределенноеЗначение("Перечисление.СпособыПолученияПенсии.ПоМестуЖительства") Тогда
			Адрес = Форма.ПредставительАдресМестаЖительства;
		ИначеЕсли СпособПолученияПенсии = ПредопределенноеЗначение("Перечисление.СпособыПолученияПенсии.ПоМестуПребывания") Тогда
			Адрес = Форма.ПредставительАдресМестаПребывания;
		ИначеЕсли СпособПолученияПенсии = ПредопределенноеЗначение("Перечисление.СпособыПолученияПенсии.ПоМестуФактическому") Тогда
			Адрес = Форма.ПредставительАдресФактический;
		ИначеЕсли СпособПолученияПенсии = ПредопределенноеЗначение("Перечисление.СпособыПолученияПенсии.ПоМестонахождениюОрганизации") Тогда
			Адрес = Форма.ПредставительАдресОрганизации;
		КонецЕсли;
		
	Иначе
		Если СпособПолученияПенсии = ПредопределенноеЗначение("Перечисление.СпособыПолученияПенсии.ПоМестуЖительства") Тогда
			Адрес = Форма.АдресМестаЖительства;
		ИначеЕсли СпособПолученияПенсии = ПредопределенноеЗначение("Перечисление.СпособыПолученияПенсии.ПоМестуПребывания") Тогда
			Адрес = Форма.АдресМестаПребывания;
		ИначеЕсли СпособПолученияПенсии = ПредопределенноеЗначение("Перечисление.СпособыПолученияПенсии.ПоМестуФактическому") Тогда
			Адрес = Форма.АдресФактический;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПредставлениеКонтактнойИнформации(Адрес);

КонецФункции

Функция ПредставлениеКонтактнойИнформации(ЗначениеАдреса)
	
	Если ЗначениеЗаполнено(ЗначениеАдреса) Тогда
		Возврат УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(ЗначениеАдреса);
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли
