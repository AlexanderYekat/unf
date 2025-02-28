﻿
#Область ПрограммныйИнтерфейс

Функция ОписаниеОбъектовПодключаемыхКоманд() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Справочники", Новый Массив);

	Результат.Справочники.Добавить("Банки");
	Результат.Справочники.Добавить("БанковскиеСчета");
	Результат.Справочники.Добавить("ВидыНалогов");
	Результат.Справочники.Добавить("ВидыСкидокНаценок");
	Результат.Справочники.Добавить("ВидыЦен");
	Результат.Справочники.Добавить("ВидыЦенКонтрагентов");
	Результат.Справочники.Добавить("ВнеоборотныеАктивы");
	Результат.Справочники.Добавить("ДоговорыКонтрагентов");
	Результат.Справочники.Добавить("Кассы");
	Результат.Справочники.Добавить("КассыККМ");
	Результат.Справочники.Добавить("Комиссии");
	Результат.Справочники.Добавить("КлючевыеРесурсы");
	Результат.Справочники.Добавить("КонтактныеЛица");
	Результат.Справочники.Добавить("Контрагенты");
	Результат.Справочники.Добавить("НаправленияДеятельности");
	Результат.Справочники.Добавить("Номенклатура");
	Результат.Справочники.Добавить("КатегорииНоменклатуры");
	Результат.Справочники.Добавить("НомераГТД");
	Результат.Справочники.Добавить("Организации");
	Результат.Справочники.Добавить("ПартииНоменклатуры");
	Результат.Справочники.Добавить("СценарииПланирования");
	Результат.Справочники.Добавить("ПравилаОбменаСПодключаемымОборудованиемOffline");
	Результат.Справочники.Добавить("Проекты");
	Результат.Справочники.Добавить("Сотрудники");
	Результат.Справочники.Добавить("Спецификации");
	Результат.Справочники.Добавить("СтатьиДвиженияДенежныхСредств");
	Результат.Справочники.Добавить("СтруктурныеЕдиницы");
	Результат.Справочники.Добавить("ФизическиеЛица");
	Результат.Справочники.Добавить("ХарактеристикиНоменклатуры");
	Результат.Справочники.Добавить("Ячейки");
	Результат.Справочники.Добавить("КомплектацииНоменклатуры");
	Результат.Справочники.Добавить("ШаблоныГенерацииПромокодов");	
	
	Результат.Вставить("Документы", Новый Массив);
	Результат.Документы.Добавить("АвансовыйОтчет");
	Результат.Документы.Добавить("АктВыполненныхРабот");
	Результат.Документы.Добавить("АмортизацияВА");
	Результат.Документы.Добавить("Бюджет");
	Результат.Документы.Добавить("ВводНачальныхОстатков");
	Результат.Документы.Добавить("Взаимозачет");
	Результат.Документы.Добавить("ВыработкаВА");
	Результат.Документы.Добавить("Доверенность");
	Результат.Документы.Добавить("ДополнительныеРасходы");
	Результат.Документы.Добавить("ЗаданиеНаРаботу");
	Результат.Документы.Добавить("ЗаказНаПроизводство");
	Результат.Документы.Добавить("ЗаказПокупателя");
	Результат.Документы.Добавить("ЗаказПоставщику");
	Результат.Документы.Добавить("ЗаказНаПеремещение");
	Результат.Документы.Добавить("ЗакрытиеМесяца");
	Результат.Документы.Добавить("ЗаявленияОПредоставленииСведенийОТрудовойДеятельности");
	Результат.Документы.Добавить("ИзменениеПараметровВА");
	Результат.Документы.Добавить("ИнвентаризацияЗапасов");
	Результат.Документы.Добавить("КадровоеПеремещениеУНФ");
	Результат.Документы.Добавить("КорректировкаРеализации");
	Результат.Документы.Добавить("КорректировкаРегистров");
	Результат.Документы.Добавить("МаршрутныйЛист");
	Результат.Документы.Добавить("НачислениеЗарплатыУНФ");
	Результат.Документы.Добавить("НачислениеНалогов");
	Результат.Документы.Добавить("НачисленияПоКредитамИЗаймам");
	Результат.Документы.Добавить("Операция");
	Результат.Документы.Добавить("ОперацияПоПлатежнымКартам");
	Результат.Документы.Добавить("ОписьОДВ_1");
	Результат.Документы.Добавить("ОприходованиеЗапасов");
	Результат.Документы.Добавить("ОтчетКомиссионера");
	Результат.Документы.Добавить("ОтчетКомитенту");
	Результат.Документы.Добавить("ОтчетОПереработке");
	Результат.Документы.Добавить("ОтчетОРозничныхПродажах");
	Результат.Документы.Добавить("ОтчетПереработчика");
	Результат.Документы.Добавить("ПередачаВА");
	Результат.Документы.Добавить("ПеремещениеДС");
	Результат.Документы.Добавить("ПеремещениеДСПлан");
	Результат.Документы.Добавить("ПеремещениеЗапасов");
	Результат.Документы.Добавить("ПеремещениеПоЯчейкам");
	Результат.Документы.Добавить("ПереоценкаВРозницеСуммовойУчет");
	Результат.Документы.Добавить("ПересортицаЗапасов");
	Результат.Документы.Добавить("ПланПродаж");
	Результат.Документы.Добавить("ПлатежнаяВедомость");
	Результат.Документы.Добавить("ПлатежноеПоручение");
	Результат.Документы.Добавить("ПоступлениеВКассу");
	Результат.Документы.Добавить("ПоступлениеДСПлан");
	Результат.Документы.Добавить("ПоступлениеНаСчет");
	Результат.Документы.Добавить("ПриемИПередачаВРемонт");
	Результат.Документы.Добавить("ПриемНаРаботуУНФ");
	Результат.Документы.Добавить("ПринятиеКУчетуВА");
	Результат.Документы.Добавить("ПриходнаяНакладная");
	Результат.Документы.Добавить("ПриходныйОрдер");
	Результат.Документы.Добавить("ПрочиеРасходы");
	Результат.Документы.Добавить("РаспределениеЗатрат");
	Результат.Документы.Добавить("РасходДСПлан");
	Результат.Документы.Добавить("РасходИзКассы");
	Результат.Документы.Добавить("РасходнаяНакладная");
	Результат.Документы.Добавить("РасходныйОрдер");
	Результат.Документы.Добавить("РасходСоСчета");
	Результат.Документы.Добавить("РезервированиеЗапасов");
	Результат.Документы.Добавить("СборкаЗапасов");
	Результат.Документы.Добавить("СведенияОЗастрахованныхЛицахСЗВ_М");
	Результат.Документы.Добавить("СведенияОСтраховомСтажеЗастрахованныхЛицСЗВ_СТАЖ");
	Результат.Документы.Добавить("СведенияОТрудовойДеятельностиРаботникаСТД_Р");
	Результат.Документы.Добавить("СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД");
	Результат.Документы.Добавить("ДанныеОКорректировкеСведенийЗастрахованныхЛицСЗВ_КОРР");
	Результат.Документы.Добавить("СверкаВзаиморасчетов");
	Результат.Документы.Добавить("СдельныйНаряд");
	Результат.Документы.Добавить("Событие");
	Результат.Документы.Добавить("СписаниеВА");
	Результат.Документы.Добавить("СписаниеЗапасов");
	Результат.Документы.Добавить("СправкаНДФЛУНФ");
	Результат.Документы.Добавить("СчетНаОплату");
	Результат.Документы.Добавить("СчетНаОплатуПоставщика");
	Результат.Документы.Добавить("СчетФактура");
	Результат.Документы.Добавить("СчетФактураПолученный");
	Результат.Документы.Добавить("Табель");
	Результат.Документы.Добавить("УвольнениеУНФ");
	Результат.Документы.Добавить("УчетВремени");
	Результат.Документы.Добавить("ЧекККМ");
	Результат.Документы.Добавить("ЧекККМВозврат");
	Результат.Документы.Добавить("ПереоценкаТоваровНаКомиссии");
	Результат.Документы.Добавить("ОтчетКомиссионераОСписании");
	Результат.Документы.Добавить("ПередачаТоваровМеждуОрганизациями");
	Результат.Документы.Добавить("УстановкаЦенНоменклатуры");
	Результат.Документы.Добавить("КомплектацияЗапасов");
	Результат.Документы.Добавить("АктОРасхожденияхПолученный");
	Результат.Документы.Добавить("АктОРасхождениях");
	Результат.Документы.Добавить("ПоложениеОПремировании");
	Результат.Документы.Добавить("КассоваяКнига");
	Результат.Документы.Добавить("ЕжедневныйОтчет");
	Результат.Документы.Добавить("УведомлениеОбИсчисленныхСуммахНалогов");
	Результат.Документы.Добавить("ОперацияПоЕдиномуНалоговомуСчету");        
	Результат.Документы.Добавить("ЗаявлениеОЗачетеВСчетПредстоящейОбязанности"); 
	Результат.Документы.Добавить("АктивацияПромокодов");
	Результат.Документы.Добавить("ЖурналУчетаСчетовФактур");
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьПредставлениеКомандВидаЗаполнениеОбъектов(Команды) Экспорт
	
	Если ТипЗнч(Команды) <> Тип("ТаблицаЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	ДопустимыйОбработчик = "ДополнительныеОтчетыИОбработкиКлиент.ОткрытьСписокКоманд";
	
	ОтборКоманд = Новый Структура;
	ОтборКоманд.Вставить("Вид", "ЗаполнениеОбъектов");
	
	КомандаЗаполненияОбъектаИзПодключаемойОбработки = Команды.НайтиСтроки(ОтборКоманд);
	Если КомандаЗаполненияОбъектаИзПодключаемойОбработки.Количество() = 1
		И КомандаЗаполненияОбъектаИзПодключаемойОбработки[0].Обработчик = ДопустимыйОбработчик Тогда
		
		Для каждого ОписаниеКоманды Из КомандаЗаполненияОбъектаИзПодключаемойОбработки Цикл
			
			ОписаниеКоманды.Представление = НСтр("ru ='Заполнение...'");
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьКомандыВида(Команды, Вид) Экспорт
	
	Если ТипЗнч(Команды) <> Тип("ТаблицаЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	ОтборКоманд = Новый Структура;
	ОтборКоманд.Вставить("Вид", Вид);
	
	КомандыСвязанныеДокументы = Команды.НайтиСтроки(ОтборКоманд);
	Для Каждого ТекКоманда Из КомандыСвязанныеДокументы Цикл
		Команды.Удалить(ТекКоманда)
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти