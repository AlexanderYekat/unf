﻿////////////////////////////////////////////////////////////////////////////////
// Выплата зарплаты для небольших организаций
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбновлениеИБ

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "ВыплатаЗарплатыДляНебольшихОрганизаций.ПреобразоватьСпособВыплатыВМестоВыплатыВедомостиНаВыплатуЗарплаты";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.13.5";
	Обработчик.РежимВыполнения = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ОсновнойРежимВыполненияОбновления();
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("c3931717-328f-4d14-82b3-458ebb2faaa6");
	Обработчик.Процедура = "ВыплатаЗарплатыДляНебольшихОрганизаций.СпособыВыплатыЗарплатыЗаполнитьОкругление";
	Обработчик.Комментарий = НСтр("ru = 'Заполнение округления в способах выплаты зарплаты.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.13.6";
	Обработчик.РежимВыполнения = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ОсновнойРежимВыполненияОбновления();
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("a0f1a0a3-645a-4fb7-8db7-7b4350992d5e");
	Обработчик.Процедура = "ВыплатаЗарплатыДляНебольшихОрганизаций.СпособыВыплатыЗарплатыЗаполнитьСтатьюРасходов";
	Обработчик.Комментарий = НСтр("ru = 'Заполнение статей расходов в способах выплаты зарплаты.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.13.7";
	Обработчик.РежимВыполнения = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ОсновнойРежимВыполненияОбновления();
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("e77eb31e-f75a-40d5-8112-d1eabbb203a3");
	Обработчик.Процедура = "ВыплатаЗарплатыДляНебольшихОрганизаций.СпособыВыплатыЗарплатыДобавитьВознаграждениеПоДоговорамГПХ";
	Обработчик.Комментарий = НСтр("ru = 'Добавление способа выплаты вознаграждения по договорам ГПХ.'");
	
КонецПроцедуры

#КонецОбласти

#Область ДатыЗапретаИзменения

// См. ДатыЗапретаИзмененияПереопределяемый.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения.
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВедомостьНаВыплатуЗарплаты", "ПериодРегистрации", "Зарплата", "Организация");
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// См. УправлениеПечатьюПереопределяемый.ПриОпределенииОбъектовСКомандамиПечати.
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить(Документы.ВедомостьНаВыплатуЗарплаты);
	
КонецПроцедуры

#КонецОбласти

#Область ЗащитаПерсональныхДанных

// См. ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьСведенияОПерсональныхДанных
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	Документы.ВедомостьНаВыплатуЗарплаты.ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений)
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	Списки.Вставить(Метаданные.Документы.ВедомостьНаВыплатуЗарплаты, Истина);
	Списки.Вставить(Метаданные.Справочники.ВедомостьНаВыплатуЗарплатыПрисоединенныеФайлы, Истина);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных.
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	Описание = Описание + "
	|Документ.ВедомостьНаВыплатуЗарплаты.Чтение.ГруппыФизическихЛиц
	|Документ.ВедомостьНаВыплатуЗарплаты.Чтение.Организации
	|Документ.ВедомостьНаВыплатуЗарплаты.Изменение.ГруппыФизическихЛиц
	|Документ.ВедомостьНаВыплатуЗарплаты.Изменение.Организации
	|Справочник.ВедомостьНаВыплатуЗарплатыПрисоединенныеФайлы.Чтение.ГруппыФизическихЛиц
	|Справочник.ВедомостьНаВыплатуЗарплатыПрисоединенныеФайлы.Чтение.Организации
	|Справочник.ВедомостьНаВыплатуЗарплатыПрисоединенныеФайлы.Изменение.ГруппыФизическихЛиц
	|Справочник.ВедомостьНаВыплатуЗарплатыПрисоединенныеФайлы.Изменение.Организации";
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПреобразоватьСпособВыплатыВМестоВыплатыВедомостиНаВыплатуЗарплаты() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВедомостьНаВыплатуЗарплаты.Ссылка,
	|	ВЫБОР
	|		КОГДА ВедомостьНаВыплатуЗарплаты.УдалитьСпособВыплаты = ЗНАЧЕНИЕ(Перечисление.УдалитьСпособыВыплатыЗарплаты.ЧерезБанк)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыМестВыплатыЗарплаты.Касса)
	|	КОНЕЦ КАК ВидМестаВыплаты
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплаты КАК ВедомостьНаВыплатуЗарплаты
	|ГДЕ
	|	ВедомостьНаВыплатуЗарплаты.ВидМестаВыплаты = ЗНАЧЕНИЕ(Перечисление.ВидыМестВыплатыЗарплаты.ПустаяСсылка)";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДокОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ДокОбъект.ВидМестаВыплаты	= Выборка.ВидМестаВыплаты;
		ДокОбъект.ОбменДанными.Загрузка = Истина;
		ДокОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

Процедура СпособыВыплатыЗарплатыЗаполнитьОкругление(ПараметрыОбновления = НеОпределено) Экспорт
	
	ОбновлениеИБ = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпособыВыплатыЗарплаты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СпособыВыплатыЗарплаты КАК СпособыВыплатыЗарплаты
	|ГДЕ
	|	СпособыВыплатыЗарплаты.Округление = &ПустаяСсылка";
	Запрос.УстановитьПараметр(
		"ПустаяСсылка", 
		Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПустаяСсылка());
	
	ОписаниеБлокировки = ОбновлениеИБ.ОписаниеБлокируемыхДанных(Метаданные.Справочники.СпособыВыплатыЗарплаты);
	
	ОбновляемыеДанные = ОбновлениеИБ.ВыполнитьЗапросПолученияОбновляемыхДанных(Запрос, ПараметрыОбновления);
	
	Если ОбновляемыеДанные.Пустой() Тогда
		ОбновлениеИБ.ЗавершитьОбработчик(ПараметрыОбновления);
		Возврат;
	Иначе
		ОбновлениеИБ.ПродолжитьОбработчик(ПараметрыОбновления);
	КонецЕсли;	
	
	ВыборкаОбновляемыхДанных = ОбновляемыеДанные.Выбрать();
	Пока ВыборкаОбновляемыхДанных.Следующий() Цикл
		
		ОписаниеБлокировки.ПоляБлокировки.Ссылка = ВыборкаОбновляемыхДанных.Ссылка;
		Если Не ОбновлениеИБ.НачатьОбновлениеДанных(ОписаниеБлокировки, ПараметрыОбновления) Тогда
			Возврат	
		КонецЕсли;
		
		СпособВыплаты = ВыборкаОбновляемыхДанных.Ссылка.ПолучитьОбъект();
		СпособВыплаты.Округление = Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПоУмолчанию();
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СпособВыплаты);
		ОбновлениеИБ.ЗавершитьОбновлениеДанных(ПараметрыОбновления);			
		
	КонецЦикла;
		
КонецПроцедуры

Процедура СпособыВыплатыЗарплатыЗаполнитьСтатьюРасходов(ПараметрыОбновления = НеОпределено) Экспорт
	
	ОбновлениеИБ = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпособыВыплатыЗарплаты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СпособыВыплатыЗарплаты КАК СпособыВыплатыЗарплаты
	|ГДЕ
	|	СпособыВыплатыЗарплаты.СтатьяРасходов = &СтатьяРасходовПустаяСсылка";
	Запрос.УстановитьПараметр(
		"СтатьяРасходовПустаяСсылка", 
		Справочники.СтатьиРасходовЗарплата.ПустаяСсылка());
	
	ОписаниеБлокировки = ОбновлениеИБ.ОписаниеБлокируемыхДанных(Метаданные.Справочники.СпособыВыплатыЗарплаты);
	
	ОбновляемыеДанные = ОбновлениеИБ.ВыполнитьЗапросПолученияОбновляемыхДанных(Запрос, ПараметрыОбновления);
	
	Если ОбновляемыеДанные.Пустой() Тогда
		ОбновлениеИБ.ЗавершитьОбработчик(ПараметрыОбновления);
		Возврат;
	Иначе
		ОбновлениеИБ.ПродолжитьОбработчик(ПараметрыОбновления);
	КонецЕсли;	
	
	СтатьиРасходов = ЗарплатаКадры.СтатьиРасходовПоСпособамРасчетовСФизическимиЛицами();
	ОплатаТруда	= СтатьиРасходов[Перечисления.СпособыРасчетовСФизическимиЛицами.ОплатаТруда];

	ВыборкаОбновляемыхДанных = ОбновляемыеДанные.Выбрать();
	Пока ВыборкаОбновляемыхДанных.Следующий() Цикл
		
		ОписаниеБлокировки.ПоляБлокировки.Ссылка = ВыборкаОбновляемыхДанных.Ссылка;
		Если Не ОбновлениеИБ.НачатьОбновлениеДанных(ОписаниеБлокировки, ПараметрыОбновления) Тогда
			Возврат	
		КонецЕсли;
		
		СпособВыплаты = ВыборкаОбновляемыхДанных.Ссылка.ПолучитьОбъект();
		СпособВыплаты.СтатьяРасходов = ОплатаТруда;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СпособВыплаты);
		ОбновлениеИБ.ЗавершитьОбновлениеДанных(ПараметрыОбновления);			
		
	КонецЦикла;
		
КонецПроцедуры

Процедура СпособыВыплатыЗарплатыДобавитьВознаграждениеПоДоговорамГПХ(ПараметрыОбновления = НеОпределено) Экспорт

	СтатьиРасходов = ЗарплатаКадры.СтатьиРасходовПоСпособамРасчетовСФизическимиЛицами();
	ДоговораГПХ = СтатьиРасходов[Перечисления.СпособыРасчетовСФизическимиЛицами.РасчетыСКонтрагентами];
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СпособыВыплатыЗарплаты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СпособыВыплатыЗарплаты КАК СпособыВыплатыЗарплаты
	|ГДЕ
	|	СпособыВыплатыЗарплаты.СтатьяРасходов = &ПоДоговорамГПХ
	|	И СпособыВыплатыЗарплаты.Поставляемый";
	Запрос.УстановитьПараметр("ПоДоговорамГПХ", ДоговораГПХ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		СпособВыплаты = Справочники.СпособыВыплатыЗарплаты.СоздатьЭлемент();
		СпособВыплаты.Наименование         = НСтр("ru = 'По договорам ГПХ'");
		СпособВыплаты.Поставляемый         = Истина;
		СпособВыплаты.СпособПолучения      = Перечисления.СпособыПолученияЗарплатыКВыплате.ОкончательныйРасчет;
		СпособВыплаты.ХарактерВыплаты      = Перечисления.ХарактерВыплатыЗарплаты.Зарплата;
		СпособВыплаты.СтатьяРасходов       = ДоговораГПХ;
		СпособВыплаты.ОкончательныйРасчетНДФЛ = Истина;
		СпособВыплаты.Округление           = Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПоУмолчанию();	
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СпособВыплаты);
		
	КонецЕсли

КонецПроцедуры

Функция СоздатьВТЗарплатаКВыплатеАванс(МенеджерВременныхТаблиц, ТолькоРазрешенные, Параметры, ИмяВТСотрудники) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРасчетПервойПоловиныМесяца") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация",				Параметры.Организация);
	Запрос.УстановитьПараметр("ПериодРегистрации",			Параметры.ПериодРегистрации);
	Запрос.УстановитьПараметр("ИгнорируемыеРегистраторы",	Параметры.ИгнорируемыеРегистраторы);	
	Запрос.УстановитьПараметр("СтатьяФинансирования",     Параметры.СтатьяФинансирования);
	Запрос.УстановитьПараметр("СтатьяРасходов",           Параметры.СтатьяРасходов);
	Запрос.УстановитьПараметр("ВидыДоходов",              Параметры.ВидыДоходов);	
	
	// Определяем суммы авансов к выплате
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗарплатаКВыплатеОстатки.Сотрудник КАК Сотрудник,
	|	ЗарплатаКВыплатеОстатки.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗарплатаКВыплатеОстатки.Подразделение КАК Подразделение,
	|	&ПериодРегистрации КАК ПериодВзаиморасчетов,
	|	ЗарплатаКВыплатеОстатки.СтатьяФинансирования КАК СтатьяФинансирования,
	|	ЗарплатаКВыплатеОстатки.СтатьяРасходов КАК СтатьяРасходов,
	|	ЗарплатаКВыплатеОстатки.ВидДоходаИсполнительногоПроизводства КАК ВидДоходаИсполнительногоПроизводства,
	|	ЗарплатаКВыплатеОстатки.ДокументОснование КАК ДокументОснование,
	|	СУММА(ЗарплатаКВыплатеОстатки.СуммаКВыплате) КАК КВыплате
	|ПОМЕСТИТЬ ВТЗарплатаКВыплате
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗарплатаКВыплатеОстатки.Сотрудник КАК Сотрудник,
	|		ЗарплатаКВыплатеОстатки.ФизическоеЛицо КАК ФизическоеЛицо,
	|		ЗарплатаКВыплатеОстатки.Подразделение КАК Подразделение,
	|		ЗарплатаКВыплатеОстатки.СтатьяФинансирования КАК СтатьяФинансирования,
	|		ЗарплатаКВыплатеОстатки.СтатьяРасходов КАК СтатьяРасходов,
	|		ЗарплатаКВыплатеОстатки.ВидДоходаИсполнительногоПроизводства КАК ВидДоходаИсполнительногоПроизводства,
	|		ЗарплатаКВыплатеОстатки.ДокументОснование КАК ДокументОснование,
	|		ЗарплатаКВыплатеОстатки.СуммаКВыплатеОстаток КАК СуммаКВыплате
	|	ИЗ
	|		РегистрНакопления.ЗарплатаКВыплатеАвансом.Остатки(
	|				КОНЕЦПЕРИОДА(&ПериодРегистрации, МЕСЯЦ),
	|				ПериодВзаиморасчетов = &ПериодРегистрации
	|					И Организация = &Организация
	|					И &ОтборПоСтатьям
	|					И ВидДоходаИсполнительногоПроизводства В (&ВидыДоходов)
	|					И Сотрудник В
	|						(ВЫБРАТЬ
	|							Сотрудники.Сотрудник
	|						ИЗ
	|							#ВТСотрудники КАК Сотрудники)) КАК ЗарплатаКВыплатеОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗарплатаКВыплате.Сотрудник,
	|		ЗарплатаКВыплате.ФизическоеЛицо,
	|		ЗарплатаКВыплате.Подразделение,
	|		ЗарплатаКВыплате.СтатьяФинансирования,
	|		ЗарплатаКВыплате.СтатьяРасходов,
	|		ЗарплатаКВыплате.ВидДоходаИсполнительногоПроизводства,
	|		ЗарплатаКВыплате.ДокументОснование,
	|		ВЫБОР
	|			КОГДА ЗарплатаКВыплате.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЗарплатаКВыплате.СуммаКВыплате
	|			ИНАЧЕ ЗарплатаКВыплате.СуммаКВыплате
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ЗарплатаКВыплатеАвансом КАК ЗарплатаКВыплате
	|	ГДЕ
	|		ЗарплатаКВыплате.Регистратор В(&ИгнорируемыеРегистраторы)
	|		И ЗарплатаКВыплате.Период < КОНЕЦПЕРИОДА(&ПериодРегистрации, МЕСЯЦ)
	|		И ЗарплатаКВыплате.ПериодВзаиморасчетов = &ПериодРегистрации
	|		И ЗарплатаКВыплате.Организация = &Организация
	|		И &ОтборПоСтатьям
	|		И ЗарплатаКВыплате.ВидДоходаИсполнительногоПроизводства В(&ВидыДоходов)
	|		И ЗарплатаКВыплате.Сотрудник В
	|				(ВЫБРАТЬ
	|					Сотрудники.Сотрудник
	|				ИЗ
	|					#ВТСотрудники КАК Сотрудники)) КАК ЗарплатаКВыплатеОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗарплатаКВыплатеОстатки.Сотрудник,
	|	ЗарплатаКВыплатеОстатки.ФизическоеЛицо,
	|	ЗарплатаКВыплатеОстатки.Подразделение,
	|	ЗарплатаКВыплатеОстатки.СтатьяФинансирования,
	|	ЗарплатаКВыплатеОстатки.СтатьяРасходов,
	|	ЗарплатаКВыплатеОстатки.ВидДоходаИсполнительногоПроизводства,
	|	ЗарплатаКВыплатеОстатки.ДокументОснование
	|
	|ИМЕЮЩИЕ
	|	СУММА(ЗарплатаКВыплатеОстатки.СуммаКВыплате) <> 0";
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст, 
		"&ОтборПоСтатьям", 
		ВзаиморасчетыССотрудниками.ОтборПоСтатьямЗарплатыКВыплате(Параметры));
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст, 
		"#ВТСотрудники", 
		ИмяВТСотрудники);
	
	Запрос.Выполнить();
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
