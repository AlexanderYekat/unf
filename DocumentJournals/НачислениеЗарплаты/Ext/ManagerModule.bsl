﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЧтениеОбъектаРазрешено(Ссылка)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "ЖурналДокументов.НачислениеЗарплаты";
	КомандаПечати.Идентификатор = "ПФ_MXL_РасчетныйЛисток";
	КомандаПечати.Представление = НСтр("ru = 'Расчетные листки'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "ЖурналДокументов.НачислениеЗарплаты";
	КомандаПечати.Идентификатор = "ПФ_MXL_Т51";
	КомандаПечати.Представление = НСтр("ru = 'Расчетная ведомость (Т-51)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_РасчетныйЛисток") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ПФ_MXL_РасчетныйЛисток", НСтр("ru = 'Расчетные листки'"), ПечатнаяФорма("ПФ_MXL_РасчетныйЛисток", МассивОбъектов, ОбъектыПечати));
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Т51") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, 
		"ПФ_MXL_Т51", НСтр("ru = 'Расчетная ведомость (Т-51)'"), ПечатнаяФорма("ПФ_MXL_Т51", МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатнаяФорма(ИдентификаторПечатнойФормы, МассивОбъектов, ОбъектыПечати)
	
	ДокументРезультат = Новый ТабличныйДокумент;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	НачислениеЗарплаты.Месяц КАК Месяц,
	|	НачислениеЗарплаты.Организация КАК Организация
	|ИЗ
	|	ЖурналДокументов.НачислениеЗарплаты КАК НачислениеЗарплаты
	|ГДЕ
	|	НачислениеЗарплаты.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Месяц,
	|	Организация";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ОтчетОбъект = Отчеты.АнализНачисленийИУдержаний.Создать();
		ОтчетОбъект.ИнициализироватьОтчет();
		
		Если ИдентификаторПечатнойФормы = "ПФ_MXL_РасчетныйЛисток" Тогда
			ВариантОтчета = ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек.Найти("РасчетныйЛисток");
		Иначе
			ВариантОтчета = ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек.Найти("Т51");
		КонецЕсли;
		
		НастройкиОтчета = ВариантОтчета.Настройки;
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("Месяц") Цикл
			
			ПараметрКомпоновкиДанных = Новый ПараметрКомпоновкиДанных("Период");
			ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрКомпоновкиДанных);
			Если ЗначениеПараметра <> Неопределено Тогда
				ЗначениеПараметра.Значение = Новый СтандартныйПериод(НачалоМесяца(Выборка.Месяц), КонецМесяца(Выборка.Месяц));
				ЗначениеПараметра.Использование = Истина;
			КонецЕсли; 
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			НастройкиОтчета.Отбор, "Организация", Выборка.Организация, ВидСравненияКомпоновкиДанных.Равно, , Истина);
			
			ОтчетЗаМесяц = Новый ТабличныйДокумент;
			ОтчетОбъект.КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиОтчета);
			ОтчетОбъект.СкомпоноватьРезультат(ОтчетЗаМесяц);
			
			Если ДокументРезультат.ВысотаТаблицы > 0 Тогда
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
				ДокументРезультат.Вывести(ОтчетЗаМесяц);
			Иначе
				ДокументРезультат = ОтчетЗаМесяц;
			КонецЕсли;
			
		КонецЦикла; 
		
	КонецЕсли; 
	
	Возврат ДокументРезультат;
	
КонецФункции

#КонецОбласти

#КонецЕсли