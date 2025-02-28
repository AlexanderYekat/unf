﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Контрагент)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ИнтерфейсПечати

Функция ЗаполнитьДопустимыеВидыДокументов()
	
	ДопустимыеВидыДокументов = Новый Массив;
	ДопустимыеВидыДокументов.Добавить(Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ);
	ДопустимыеВидыДокументов.Добавить(Справочники.ВидыДокументовФизическихЛиц.ЗагранпаспортРФ);
	
	ПаспортИностранногоГражданина = Справочники.ВидыДокументовФизическихЛиц.НайтиПоНаименованию("Паспорт иностранного гражданина");
	Если ЗначениеЗаполнено(ПаспортИностранногоГражданина) Тогда
		
		ДопустимыеВидыДокументов.Добавить(ПаспортИностранногоГражданина);
		
	КонецЕсли;
	
	Возврат ДопустимыеВидыДокументов;
	
КонецФункции

// Процедура формирует печатную форму документа по указанному макету.
//
Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, ТипДокумента)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Доверенность.ПФ_MXL_М2");
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_Доверенность";
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Доверенность.Ссылка КАК Ссылка,
	|	Доверенность.Номер КАК Номер,
	|	Доверенность.Дата КАК ДатаДокумента,
	|	Доверенность.Организация,
	|	Доверенность.ПодписьРуководителя.РасшифровкаПодписи КАК РасшифровкаПодписиРуководителя,
	|	Доверенность.ПодписьГлавногоБухгалтера.РасшифровкаПодписи КАК РасшифровкаПодписиГлавногоБухгалтера,
	|	Доверенность.Организация.Префикс КАК Префикс,
	|	Доверенность.ФизЛицо,
	|	Доверенность.ФизЛицо.Наименование КАК ФамилияИмяОтчествоДоверенного,
	|	Доверенность.БанковскийСчет КАК БанковскийСчет,
	|	Доверенность.Контрагент КАК Поставщик,
	|	Доверенность.НаПолучениеОт КАК ПоставщикПредставление,
	|	Доверенность.ДатаДействия КАК СрокДействия,
	|	Доверенность.ПоДокументу КАК РеквизитыДокументаНаПолучение,
	|	Доверенность.Запасы.(
	|		НомерСтроки КАК Номер,
	|		НаименованиеТовара КАК Ценности,
	|		НаименованиеТовара КАК ЦенностиПредставление,
	|		ЕдиницаИзмерения КАК ЕдиницаИзмеренияПредставление,
	|		Количество
	|	)
	|ИЗ
	|	Документ.Доверенность КАК Доверенность
	|ГДЕ
	|	Доверенность.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Номер";
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
	
		ВыборкаСтрокТовары = Шапка.Запасы.Выбрать();
		
		ДопустимыеВидыДокументов = ЗаполнитьДопустимыеВидыДокументов();
		ДанныеОФизЛице = Справочники.ФизическиеЛица.ДанныеФизЛица(Шапка.Организация, Шапка.ФизЛицо, Шапка.ДатаДокумента);
		Если ЗначениеЗаполнено(ДанныеОФизЛице.ДокументВид)
			И ДопустимыеВидыДокументов.Найти(ДанныеОФизЛице.ДокументВид) = Неопределено Тогда
			
			ДанныеОФизЛице.ДокументСерия = Неопределено;
			ДанныеОФизЛице.ДокументНомер = Неопределено;
			ДанныеОФизЛице.ДокументКемВыдан = Неопределено;
			ДанныеОФизЛице.ДокументДатаВыдачи = Неопределено;
			
		КонецЕсли;
		
		ФамилияИмяОтчествоДоверенного = СокрЛП(ДанныеОФизЛице.Фамилия) + " " + СокрЛП(ДанныеОФизЛице.Имя) + " " + СокрЛП(ДанныеОФизЛице.Отчество);
		Должность = СокрЛП(ДанныеОФизЛице.Должность);
		
		НомерДокумента = ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(Шапка.ДатаДокумента, Шапка.Номер, Шапка.Префикс);
		
		Если ТипДокумента = "М2" Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("Отрез");
			ОбластьМакета.Параметры.Заполнить(Шапка);
			ОбластьМакета.Параметры.НомерДокумента = НомерДокумента;
			ОбластьМакета.Параметры.ФИОДоверенного = "" + ?(ПустаяСтрока(Должность), "", Должность + ", " + Символы.ПС) + (ФамилияИмяОтчествоДоверенного);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			НазваниеФормы = "Типовая межотраслевая форма № М-2";
			КодПоОКУД = "0315001";
		Иначе
			НазваниеФормы = "Типовая межотраслевая форма № М-2а";
			КодПоОКУД = "0315002";
		КонецЕсли;
		
		СведенияОбОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента,, Шапка.БанковскийСчет);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.НомерДокумента               = НомерДокумента;
		ОбластьМакета.Параметры.НазваниеФормы                = НазваниеФормы;
		ОбластьМакета.Параметры.КодПоОКУД               	 = КодПоОКУД;
		ОбластьМакета.Параметры.ОрганизацияПредставление     = ПечатьДокументовУНФ.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		ОбластьМакета.Параметры.РеквизитыСчета               = ПечатьДокументовУНФ.ОписаниеОрганизации(СведенияОбОрганизации, "НомерСчета,Банк,БИК,КоррСчет,");
		ОбластьМакета.Параметры.РеквизитыПотребителя         = ПечатьДокументовУНФ.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		ОбластьМакета.Параметры.РеквизитыПлательщика         = ПечатьДокументовУНФ.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		ОбластьМакета.Параметры.ОрганизацияКодПоОКПО         = СведенияОбОрганизации.КодПоОКПО;
		ОбластьМакета.Параметры.ПаспортСерия                 = ДанныеОФизЛице.ДокументСерия;
		ОбластьМакета.Параметры.ПаспортНомер                 = ДанныеОФизЛице.ДокументНомер;
		ОбластьМакета.Параметры.ПаспортВыдан                 = ДанныеОФизЛице.ДокументКемВыдан;
		ОбластьМакета.Параметры.ПаспортДатаВыдачи            = ДанныеОФизЛице.ДокументДатаВыдачи;
		ОбластьМакета.Параметры.ФамилияИмяОтчествоДоверенного = ФамилияИмяОтчествоДоверенного;
		ОбластьМакета.Параметры.ДолжностьДоверенного         = Должность;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		
		Пока ВыборкаСтрокТовары.Следующий() Цикл
			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
			ОбластьМакета.Параметры.КоличествоПрописью = ?(ВыборкаСтрокТовары.Количество = 0,
														   "",
														   Строка(ВыборкаСтрокТовары.Количество) + " (" + 
														   ПечатьДокументовУНФ.КоличествоПрописью(ВыборкаСтрокТовары.Количество) + ")");
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М2") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "М2", НСтр("ru = 'Типовая межотраслевая форма № М-2'"), ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "М2"));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М2а") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "М2а", НСтр("ru = 'Типовая межотраслевая форма № М-2а'"), ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "М2-а"));
		
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
	КомандаПечати.Идентификатор = "М2";
	КомандаПечати.Представление = НСтр("ru = 'М-2'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "М2а";
	КомандаПечати.Представление = НСтр("ru = 'М-2а'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 4;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли