﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

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


#Область СлужебныйПрограммныйИнтерфейс

#Область ФиксацияВторичныхДанныхВДокументах

Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	ФиксируемыеРеквизиты = ФиксируемыеРеквизиты();
	ФиксируемыеТЧ = Новый Структура("ДанныеЭЛН", СтрРазделить("Больничный", ",", Ложь));
	Возврат ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксации(ФиксируемыеРеквизиты, ФиксируемыеТЧ);
КонецФункции

#КонецОбласти

#Область МногофункциональныеДокументы

// Возвращает метаданные разделов документа.
//
// Возвращаемое значение:
//   Соответствие, Неопределено - Описание разделов документа.
//
Функция ОписаниеРазделовДанных() Экспорт
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("МногофункциональныеДокументыБЗККлиентСервер");
		ВсеРазделы = Модуль.РазделыДанных();
		
		ОписаниеРазделовДанных = Новый Соответствие();
		
		ОписаниеРаздела = Модуль.НовыйОписаниеРазделаДанных();
		ОписаниеРазделовДанных.Вставить(ВсеРазделы.КадровыеДанные, ОписаниеРаздела);
		ОписаниеРаздела.РеквизитСостояние    = "Проведен";
		ОписаниеРаздела.РеквизитОтветсвенный = "Ответственный";
		
		ОписаниеРаздела = Модуль.НовыйОписаниеРазделаДанных();
		ОписаниеРазделовДанных.Вставить(ВсеРазделы.НачисленнаяЗарплата, ОписаниеРаздела);
		Возврат ОписаниеРазделовДанных;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

// Возвращает значения по которым будут проверяться права на документ.
//
// Параметры:
//   ДокументОбъект - ДокументОбъект, ДанныеФормыСтруктура
//
// Возвращаемое значение:
//   Структура - Значения доступа по которым будут проверяться права на документ
//
Функция ЗначенияДоступа(ДокументОбъект) Экспорт
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы") Тогда
		МодульМногофункциональныеДокументыБЗК = ОбщегоНазначения.ОбщийМодуль("МногофункциональныеДокументыБЗК");
		Возврат МодульМногофункциональныеДокументыБЗК.ЗначенияДоступаПоСоставуДокумента(
			ДокументОбъект,
			ДокументОбъект.Организация);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

#КонецОбласти

#Область СоставДокументов

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
//
Функция ОписаниеСоставаОбъекта() Экспорт
	ОписаниеСостава = ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта();
	ОписаниеСостава.ЗаполнятьФизическиеЛицаПоСотрудникам           = Ложь;
	ОписаниеСостава.ИспользоватьКраткийСостав                      = Ложь;
	ОписаниеСостава.ЗаполнятьТабличнуюЧастьФизическиеЛицаДокумента = Ложь;
	
	ЗарплатаКадрыСоставДокументов.ДобавитьОписаниеХраненияСотрудниковФизическихЛиц(
		ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц,
		"ДанныеЭЛН",
		Неопределено,
		"Сотрудник");
	
	Возврат ОписаниеСостава;
КонецФункции

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ФиксацияВторичныхДанныхВДокументах

Функция ФиксируемыеРеквизиты()
	ФиксируемыеРеквизиты = Новый Соответствие;
	
	// Реквизиты организации.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "Организация";
	Шаблон.ОснованиеЗаполнения = "Организация";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "РегистрационныйНомерФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДополнительныйКодФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "КодПодчиненностиФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "РеестрСоставил", Ложь);
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ТелефонСоставителя", Ложь);
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "АдресЭлектроннойПочтыСоставителя", Ложь);
	
	// Кэш строк.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "КэшДанныхЭЛН";
	Шаблон.ОснованиеЗаполнения = "КэшДанныхЭЛН";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СостояниеРеестра", Ложь);
	
	// Роль подписанта Руководитель.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ОснованиеЗаполнения = "Организация";
	Шаблон.ИмяГруппы           = "Руководитель";
	Шаблон.ФиксацияГруппы      = Истина;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Руководитель");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДолжностьРуководителя");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ОснованиеПодписиРуководителя");
	
	// Роль подписанта ГлавныйБухгалтер.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ОснованиеЗаполнения = "Организация";
	Шаблон.ИмяГруппы           = "ГлавныйБухгалтер";
	Шаблон.ФиксацияГруппы      = Истина;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ГлавныйБухгалтер");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДолжностьГлавногоБухгалтера");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ОснованиеПодписиГлавногоБухгалтера");
	
	// Реквизиты табличной части "ДанныеЭЛН".
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.Путь           = "ДанныеЭЛН";
	Шаблон.РеквизитСтроки = Истина;
	
	//   Регистр сведений об ЭЛН.
	Шаблон.ОснованиеЗаполнения = "РегистрСведенийЭЛН";
	Шаблон.ИмяГруппы           = "РегистрСведенийЭЛН";
	Шаблон.ФиксацияГруппы      = Истина;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Исправление", Ложь);
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "КодПричиныИсправления", Ложь);
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ОписаниеПричиныИсправления", Ложь);
	
	//   Документ-основание.
	Шаблон.ОснованиеЗаполнения = "Больничный";
	Шаблон.ИмяГруппы           = "СведенияПервичногоДокумента";
	Шаблон.ФиксацияГруппы      = Ложь;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "НомерЛисткаНетрудоспособности");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Сотрудник");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "БазаДляРасчетаСреднегоЗаработка");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаАктаН1");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаНачалаОплаты");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаНачалаОплатыФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаНачалаРаботы");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаОкончанияОплаты");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаОкончанияОплатыФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ПриступитьКРаботеС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СреднийДневнойЗаработок");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажЛет");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажМесяцев");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажДней");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажРасширенныйЛет");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажРасширенныйМесяцев");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтажРасширенныйДней");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СуммаОплатыЗаСчетРаботодателя");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СуммаОплатыЗаСчетФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "УсловияИсчисленияКод1");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "УсловияИсчисленияКод2");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "УсловияИсчисленияКод3");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ФинансированиеФедеральнымБюджетом");
	
	//   Сотрудник.
	Шаблон.ОснованиеЗаполнения = "Сотрудник";
	Шаблон.ИмяГруппы           = "КадровыеДанныеСотрудника";
	Шаблон.ФиксацияГруппы      = Истина;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ВидЗанятости");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ИНН");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СНИЛС");
	
	Возврат Новый ФиксированноеСоответствие(ФиксируемыеРеквизиты);
КонецФункции

#КонецОбласти

#Область Больничные

// Возвращает таблицу с данными, необходимыми для выгрузки реестра ЭЛН.
Функция ЗапросПоПервичнымДокументам(ТаблицаОснований, СсылкаРеестра, ГоловнаяОрганизация, ИмяВТ) Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаОснований", ТаблицаОснований);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаОснований.Больничный КАК СсылкаБольничного,
	|	ТаблицаОснований.НомерЛисткаНетрудоспособности КАК НомерЛисткаНетрудоспособности
	|ПОМЕСТИТЬ ТаблицаОснований
	|ИЗ
	|	&ТаблицаОснований КАК ТаблицаОснований
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаОснований.НомерЛисткаНетрудоспособности КАК НомерЛисткаНетрудоспособности,
	|	БольничныйЛист.Ссылка КАК Ссылка,
	|	БольничныйЛист.Сотрудник КАК Сотрудник,
	|	БольничныйЛист.ДатаНачала КАК Период
	|ПОМЕСТИТЬ ВТБольничные
	|ИЗ
	|	ТаблицаОснований КАК ТаблицаОснований
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.БольничныйЛист КАК БольничныйЛист
	|		ПО ТаблицаОснований.СсылкаБольничного = БольничныйЛист.Ссылка";
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц,
		"ВТБольничные");
	
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, "ИНН,СтраховойНомерПФР,ВидЗанятости");
	
	Больничные = ТаблицаОснований.ВыгрузитьКолонку("Больничный");
	Запрос.УстановитьПараметр("БазыДляРасчетаСреднегоЗаработка", БазыДляРасчетаСреднегоЗаработка(Больничные));
	
	Запрос.УстановитьПараметр("СсылкаРеестра", СсылкаРеестра);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ГоловнаяОрганизация);
	Запрос.УстановитьПараметр("КатегорииПособийЗаСчетФСС", Перечисления.КатегорииНачисленийИНеоплаченногоВремени.КатегорииПрямыхВыплатФСС());
	Запрос.УстановитьПараметр("ДатаВключенияРКПриРасчетеБольничного", УчетПособийСоциальногоСтрахования.ДатаВключенияРКПриРасчетеБольничного());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БазыДляРасчетаСреднегоЗаработка.Ссылка КАК Ссылка,
	|	БазыДляРасчетаСреднегоЗаработка.УчитываемыхДнейВКалендарныхГодах КАК УчитываемыхДнейВКалендарныхГодах,
	|	БазыДляРасчетаСреднегоЗаработка.БазаДляРасчетаСреднегоЗаработка КАК БазаДляРасчетаСреднегоЗаработка
	|ПОМЕСТИТЬ ВТБазыДляРасчетаСреднегоЗаработка
	|ИЗ
	|	&БазыДляРасчетаСреднегоЗаработка КАК БазыДляРасчетаСреднегоЗаработка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Больничные.Ссылка КАК Больничный,
	|	МИНИМУМ(БольничныйЛистНачисления.ДатаНачала) КАК ДатаНачалаОплатыФСС,
	|	МАКСИМУМ(БольничныйЛистНачисления.ДатаОкончания) КАК ДатаОкончанияОплатыФСС,
	|	СУММА(БольничныйЛистНачисления.Результат) КАК СуммаОплатыЗаСчетФСС
	|ПОМЕСТИТЬ ВТПериодыОплатыЗаСчетФСС
	|ИЗ
	|	ВТБольничные КАК Больничные
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.БольничныйЛист.Начисления КАК БольничныйЛистНачисления
	|			ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.Начисления КАК Начисления
	|			ПО БольничныйЛистНачисления.Начисление = Начисления.Ссылка
	|		ПО Больничные.Ссылка = БольничныйЛистНачисления.Ссылка
	|ГДЕ
	|	Начисления.КатегорияНачисленияИлиНеоплаченногоВремени В(&КатегорииПособийЗаСчетФСС)
	|
	|СГРУППИРОВАТЬ ПО
	|	Больничные.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Больничные.Ссылка КАК Больничный,
	|	СУММА(БольничныйЛистНачисления.Результат) КАК СуммаОплатыЗаСчетРаботодателя
	|ПОМЕСТИТЬ ВТОплатаЗаСчетРаботодателя
	|ИЗ
	|	ВТБольничные КАК Больничные
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.БольничныйЛист.Начисления КАК БольничныйЛистНачисления
	|			ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.Начисления КАК Начисления
	|			ПО БольничныйЛистНачисления.Начисление = Начисления.Ссылка
	|		ПО Больничные.Ссылка = БольничныйЛистНачисления.Ссылка
	|ГДЕ
	|	Начисления.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛистаЗаСчетРаботодателя)
	|
	|СГРУППИРОВАТЬ ПО
	|	Больничные.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БольничныйЛист.Ссылка КАК Больничный,
	|	БольничныйЛист.Сотрудник КАК Сотрудник,
	|	БольничныйЛист.НомерЛисткаНетрудоспособности КАК НомерЛисткаНетрудоспособности,
	|	БольничныйЛист.ОсновноеМестоРаботы КАК ОсновноеМестоРаботы,
	|	БольничныйЛист.ПриступитьКРаботеС КАК ПриступитьКРаботеС,
	|	БольничныйЛист.УсловияИсчисленияКод1 КАК УсловияИсчисленияКод1,
	|	БольничныйЛист.УсловияИсчисленияКод2 КАК УсловияИсчисленияКод2,
	|	БольничныйЛист.УсловияИсчисленияКод3 КАК УсловияИсчисленияКод3,
	|	БольничныйЛист.ДатаАктаН1 КАК ДатаАктаН1,
	|	БольничныйЛист.ДатаНачалаРаботы КАК ДатаНачалаРаботы,
	|	БольничныйЛист.СтажЛет КАК СтажЛет,
	|	БольничныйЛист.СтажМесяцев КАК СтажМесяцев,
	|	БольничныйЛист.СтажДней КАК СтажДней,
	|	БольничныйЛист.СтажРасширенныйЛет КАК СтажРасширенныйЛет,
	|	БольничныйЛист.СтажРасширенныйМесяцев КАК СтажРасширенныйМесяцев,
	|	БольничныйЛист.СтажРасширенныйДней КАК СтажРасширенныйДней,
	|	БольничныйЛист.ДатаНачалаОплаты КАК ДатаНачалаОплаты,
	|	БольничныйЛист.ДатаОкончанияОплаты КАК ДатаОкончанияОплаты,
	|	БольничныйЛист.ФинансированиеФедеральнымБюджетом КАК ФинансированиеФедеральнымБюджетом,
	|	ВЫБОР
	|		КОГДА БольничныйЛист.ДатаНачалаСобытия >= &ДатаВключенияРКПриРасчетеБольничного
	|			ТОГДА ВЫБОР
	|					КОГДА БольничныйЛист.СреднийДневнойЗаработок > БольничныйЛист.МинимальныйСреднедневнойЗаработок * БольничныйЛист.РайонныйКоэффициентРФНаНачалоСобытия
	|						ТОГДА БольничныйЛист.СреднийДневнойЗаработок
	|					ИНАЧЕ БольничныйЛист.МинимальныйСреднедневнойЗаработок * БольничныйЛист.РайонныйКоэффициентРФНаНачалоСобытия
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА БольничныйЛист.СреднийДневнойЗаработок > БольничныйЛист.МинимальныйСреднедневнойЗаработок
	|					ТОГДА БольничныйЛист.СреднийДневнойЗаработок
	|				ИНАЧЕ БольничныйЛист.МинимальныйСреднедневнойЗаработок
	|			КОНЕЦ
	|	КОНЕЦ КАК СреднийДневнойЗаработок,
	|	ВЫБОР
	|		КОГДА БольничныйЛист.ДатаНачалаСобытия >= &ДатаВключенияРКПриРасчетеБольничного
	|			ТОГДА ВЫБОР
	|					КОГДА БольничныйЛист.СреднийДневнойЗаработок <= БольничныйЛист.МинимальныйСреднедневнойЗаработок * БольничныйЛист.РайонныйКоэффициентРФНаНачалоСобытия
	|							И НЕ ВТБазыДляРасчетаСреднегоЗаработка.УчитываемыхДнейВКалендарныхГодах ЕСТЬ NULL
	|							И НЕ БольничныйЛист.СреднийДневнойЗаработок = 0
	|						ТОГДА БольничныйЛист.МинимальныйСреднедневнойЗаработок * ВТБазыДляРасчетаСреднегоЗаработка.УчитываемыхДнейВКалендарныхГодах
	|					ИНАЧЕ ЕСТЬNULL(ВТБазыДляРасчетаСреднегоЗаработка.БазаДляРасчетаСреднегоЗаработка, 0)
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА БольничныйЛист.СреднийДневнойЗаработок <= БольничныйЛист.МинимальныйСреднедневнойЗаработок
	|						И НЕ ВТБазыДляРасчетаСреднегоЗаработка.УчитываемыхДнейВКалендарныхГодах ЕСТЬ NULL
	|						И НЕ БольничныйЛист.СреднийДневнойЗаработок = 0
	|					ТОГДА БольничныйЛист.МинимальныйСреднедневнойЗаработок * ВТБазыДляРасчетаСреднегоЗаработка.УчитываемыхДнейВКалендарныхГодах
	|				ИНАЧЕ ЕСТЬNULL(ВТБазыДляРасчетаСреднегоЗаработка.БазаДляРасчетаСреднегоЗаработка, 0)
	|			КОНЕЦ
	|	КОНЕЦ КАК БазаДляРасчетаСреднегоЗаработка,
	|	ВТПериодыОплатыЗаСчетФСС.ДатаНачалаОплатыФСС КАК ДатаНачалаОплатыФСС,
	|	ВТПериодыОплатыЗаСчетФСС.ДатаОкончанияОплатыФСС КАК ДатаОкончанияОплатыФСС,
	|	ВТПериодыОплатыЗаСчетФСС.СуммаОплатыЗаСчетФСС КАК СуммаОплатыЗаСчетФСС,
	|	ВТОплатаЗаСчетРаботодателя.СуммаОплатыЗаСчетРаботодателя КАК СуммаОплатыЗаСчетРаботодателя,
	|	КадровыеДанныеСотрудников.ИНН КАК ИНН,
	|	КадровыеДанныеСотрудников.СтраховойНомерПФР КАК СНИЛС,
	|	КадровыеДанныеСотрудников.ВидЗанятости КАК ВидЗанятости,
	|	СведенияОбЭЛН.Исправление КАК Исправление,
	|	СведенияОбЭЛН.КодПричиныИсправления КАК КодПричиныИсправления,
	|	СведенияОбЭЛН.ОписаниеПричиныИсправления КАК ОписаниеПричиныИсправления,
	|	СведенияОбЭЛН.Хеш КАК Хеш
	|ИЗ
	|	ВТБольничные КАК ВТБольничные
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.БольничныйЛист КАК БольничныйЛист
	|		ПО ВТБольничные.Ссылка = БольничныйЛист.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОбЭЛН КАК СведенияОбЭЛН
	|		ПО (БольничныйЛист.НомерЛисткаНетрудоспособности = СведенияОбЭЛН.НомерЛисткаНетрудоспособности)
	|			И (СведенияОбЭЛН.ГоловнаяОрганизация = &ГоловнаяОрганизация)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|		ПО ВТБольничные.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
	|			И ВТБольничные.Период = КадровыеДанныеСотрудников.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОплатаЗаСчетРаботодателя КАК ВТОплатаЗаСчетРаботодателя
	|		ПО ВТБольничные.Ссылка = ВТОплатаЗаСчетРаботодателя.Больничный
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТБазыДляРасчетаСреднегоЗаработка КАК ВТБазыДляРасчетаСреднегоЗаработка
	|		ПО ВТБольничные.Ссылка = ВТБазыДляРасчетаСреднегоЗаработка.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПериодыОплатыЗаСчетФСС КАК ВТПериодыОплатыЗаСчетФСС
	|		ПО ВТБольничные.Ссылка = ВТПериодыОплатыЗаСчетФСС.Больничный";
	
	Если ИмяВТ <> Неопределено Тогда
		СхемаЗапроса = Новый СхемаЗапроса;
		СхемаЗапроса.УстановитьТекстЗапроса(Запрос.Текст);
		ПоследнийЗапрос = СхемаЗапроса.ПакетЗапросов[СхемаЗапроса.ПакетЗапросов.Количество() - 1];
		ПоследнийЗапрос.ТаблицаДляПомещения = ИмяВТ;
		Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
	КонецЕсли;
	
	Возврат Запрос;
КонецФункции

Функция БазыДляРасчетаСреднегоЗаработка(Больничные)
	
	ДанныеДляРасчетаСреднегоЗаработкаПоВсемБольничным = Документы.БольничныйЛист.ДанныеДокументовДляРасчетаСреднегоЗаработкаФСС(Больничные);
	
	ВсеРасчетныеГоды = Новый Массив;
	
	СреднийЗаработокЗа2Года = Новый ТаблицаЗначений;
	СреднийЗаработокЗа2Года.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("ДокументСсылка.БольничныйЛист"));
	СреднийЗаработокЗа2Года.Колонки.Добавить("ПервыйРасчетныйГод", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(4, 0)));
	СреднийЗаработокЗа2Года.Колонки.Добавить("ВторойРасчетныйГод", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(4, 0)));
	СреднийЗаработокЗа2Года.Колонки.Добавить("ЗаработокПервыйГод", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2)));
	СреднийЗаработокЗа2Года.Колонки.Добавить("ЗаработокВторойГод", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2)));
	
	Для Каждого КлючИЗначение Из ДанныеДляРасчетаСреднегоЗаработкаПоВсемБольничным Цикл
		ДанныеДляРасчетаСреднегоЗаработка = КлючИЗначение.Значение;
		ПараметрыРасчета = ДанныеДляРасчетаСреднегоЗаработка.ПараметрыРасчета;
		ДанныеРасчетаСреднего = ДанныеДляРасчетаСреднегоЗаработка.ДанныеРасчетаСреднего;
		
		СтрокаЗаработок = СреднийЗаработокЗа2Года.Добавить();
		СтрокаЗаработок.Ссылка             = КлючИЗначение.Ключ;
		СтрокаЗаработок.ПервыйРасчетныйГод = ПараметрыРасчета.РасчетныеГоды[0];
		СтрокаЗаработок.ВторойРасчетныйГод = ПараметрыРасчета.РасчетныеГоды[1];
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВсеРасчетныеГоды, ПараметрыРасчета.РасчетныеГоды, Истина);
		
		Фильтр = Новый Структура("РасчетныйГод", СтрокаЗаработок.ПервыйРасчетныйГод);
		СтрокаПоГоду = УчетПособийСоциальногоСтрахованияКлиентСервер.ЭлементКоллекцииПоОтбору(ДанныеРасчетаСреднего, Фильтр);
		Если СтрокаПоГоду <> Неопределено Тогда
			СтрокаЗаработок.ЗаработокПервыйГод = УчетПособийСоциальногоСтрахованияКлиентСервер.УчитываемыйЗаработокФССПоГоду(ПараметрыРасчета, СтрокаПоГоду);
		КонецЕсли;
		
		Фильтр = Новый Структура("РасчетныйГод", СтрокаЗаработок.ВторойРасчетныйГод);
		СтрокаПоГоду = УчетПособийСоциальногоСтрахованияКлиентСервер.ЭлементКоллекцииПоОтбору(ДанныеРасчетаСреднего, Фильтр);
		Если СтрокаПоГоду <> Неопределено Тогда
			СтрокаЗаработок.ЗаработокВторойГод = УчетПособийСоциальногоСтрахованияКлиентСервер.УчитываемыйЗаработокФССПоГоду(ПараметрыРасчета, СтрокаПоГоду);
		КонецЕсли;
	КонецЦикла;
	
	ПредельныеВеличиныБаз = УчетПособийСоциальногоСтрахования.ПредельнаяВеличинаБазыСтраховыхВзносов(ВсеРасчетныеГоды);
	
	БазыДляРасчетаСреднегоЗаработка = Новый ТаблицаЗначений;
	БазыДляРасчетаСреднегоЗаработка.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("ДокументСсылка.БольничныйЛист"));
	БазыДляРасчетаСреднегоЗаработка.Колонки.Добавить("БазаДляРасчетаСреднегоЗаработка", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2)));
	БазыДляРасчетаСреднегоЗаработка.Колонки.Добавить("УчитываемыхДнейВКалендарныхГодах", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(3, 0)));
	
	Для Каждого СтрокаЗаработок Из СреднийЗаработокЗа2Года Цикл
		// Применение предельных величин.
		ПредельнаяВеличинаБазыПоГоду = ПредельныеВеличиныБаз[СтрокаЗаработок.ПервыйРасчетныйГод];
		Если ПредельнаяВеличинаБазыПоГоду <> Неопределено И ПредельнаяВеличинаБазыПоГоду < СтрокаЗаработок.ЗаработокПервыйГод Тогда
			СтрокаЗаработок.ЗаработокПервыйГод = ПредельнаяВеличинаБазыПоГоду;
		КонецЕсли;
		ПредельнаяВеличинаБазыПоГоду = ПредельныеВеличиныБаз[СтрокаЗаработок.ВторойРасчетныйГод];
		Если ПредельнаяВеличинаБазыПоГоду <> Неопределено И ПредельнаяВеличинаБазыПоГоду < СтрокаЗаработок.ЗаработокВторойГод Тогда
			СтрокаЗаработок.ЗаработокВторойГод = ПредельнаяВеличинаБазыПоГоду;
		КонецЕсли;
		// Суммирование.
		СтрокаБаза = БазыДляРасчетаСреднегоЗаработка.Добавить();
		СтрокаБаза.Ссылка = СтрокаЗаработок.Ссылка;
		СтрокаБаза.БазаДляРасчетаСреднегоЗаработка = СтрокаЗаработок.ЗаработокПервыйГод + СтрокаЗаработок.ЗаработокВторойГод;
		// Вычисление количества учитываемых дней.
		ДанныеДляРасчетаСреднегоЗаработка = ДанныеДляРасчетаСреднегоЗаработкаПоВсемБольничным[СтрокаБаза.Ссылка];
		СтрокаБаза.УчитываемыхДнейВКалендарныхГодах = УчетПособийСоциальногоСтрахованияКлиентСервер.УчитываемыхДнейВКалендарныхГодахФСС(
			ДанныеДляРасчетаСреднегоЗаработка.ПараметрыРасчета,
			ДанныеДляРасчетаСреднегоЗаработка.ДанныеРасчетаСреднего);
		Если СтрокаБаза.БазаДляРасчетаСреднегоЗаработка = 0 Тогда
			СтрокаБаза.БазаДляРасчетаСреднегоЗаработка = ДанныеДляРасчетаСреднегоЗаработка.ПараметрыРасчета.МинимальныйРазмерОплатыТрудаРФ * 24;
		КонецЕсли;
	КонецЦикла;
	
	Возврат БазыДляРасчетаСреднегоЗаработка;
КонецФункции

Функция БазаДляРасчетаСреднегоЗаработка(БольничныйОбъект) Экспорт
	
	ДанныеСреднегоФСС = Документы.БольничныйЛист.ДанныеДокументаДляРасчетаСреднегоЗаработкаФСС(БольничныйОбъект);
	
	ПараметрыРасчета      = ДанныеСреднегоФСС.ПараметрыРасчета;
	ДанныеРасчетаСреднего = ДанныеСреднегоФСС.ДанныеРасчетаСреднего;
	
	ПервыйРасчетныйГод = ПараметрыРасчета.РасчетныеГоды[0];
	ВторойРасчетныйГод = ПараметрыРасчета.РасчетныеГоды[1];
	ЗаработокПервыйГод = 0;
	ЗаработокВторойГод = 0;
	
	Фильтр = Новый Структура("РасчетныйГод", ПервыйРасчетныйГод);
	СтрокаПоГоду = УчетПособийСоциальногоСтрахованияКлиентСервер.ЭлементКоллекцииПоОтбору(ДанныеРасчетаСреднего, Фильтр);
	Если СтрокаПоГоду <> Неопределено Тогда
		ЗаработокПервыйГод = УчетПособийСоциальногоСтрахованияКлиентСервер.УчитываемыйЗаработокФССПоГоду(ПараметрыРасчета, СтрокаПоГоду);
	КонецЕсли;
	
	Фильтр = Новый Структура("РасчетныйГод", ВторойРасчетныйГод);
	СтрокаПоГоду = УчетПособийСоциальногоСтрахованияКлиентСервер.ЭлементКоллекцииПоОтбору(ДанныеРасчетаСреднего, Фильтр);
	Если СтрокаПоГоду <> Неопределено Тогда
		ЗаработокВторойГод = УчетПособийСоциальногоСтрахованияКлиентСервер.УчитываемыйЗаработокФССПоГоду(ПараметрыРасчета, СтрокаПоГоду);
	КонецЕсли;
	
	ПредельныеВеличиныБаз = УчетПособийСоциальногоСтрахования.ПредельнаяВеличинаБазыСтраховыхВзносов(ПараметрыРасчета.РасчетныеГоды);
	
	// Применение предельных величин.
	ПредельнаяВеличинаБазыПоГоду = ПредельныеВеличиныБаз[ПервыйРасчетныйГод];
	Если ПредельнаяВеличинаБазыПоГоду <> Неопределено И ПредельнаяВеличинаБазыПоГоду < ЗаработокПервыйГод Тогда
		ЗаработокПервыйГод = ПредельнаяВеличинаБазыПоГоду;
	КонецЕсли;
	ПредельнаяВеличинаБазыПоГоду = ПредельныеВеличиныБаз[ВторойРасчетныйГод];
	Если ПредельнаяВеличинаБазыПоГоду <> Неопределено И ПредельнаяВеличинаБазыПоГоду < ЗаработокВторойГод Тогда
		ЗаработокВторойГод = ПредельнаяВеличинаБазыПоГоду;
	КонецЕсли;
	
	Результат = Новый Структура("Ссылка, БазаДляРасчетаСреднегоЗаработка, УчитываемыхДнейВКалендарныхГодах");
	Результат.Ссылка = БольничныйОбъект.Ссылка;
	
	// Суммирование.
	Результат.БазаДляРасчетаСреднегоЗаработка = ЗаработокПервыйГод + ЗаработокВторойГод;
	Если Результат.БазаДляРасчетаСреднегоЗаработка = 0 Тогда
		Результат.БазаДляРасчетаСреднегоЗаработка = ДанныеСреднегоФСС.ПараметрыРасчета.МинимальныйРазмерОплатыТрудаРФ * 24;
	КонецЕсли;
	
	// Вычисление количества учитываемых дней.
	Результат.УчитываемыхДнейВКалендарныхГодах = УчетПособийСоциальногоСтрахованияКлиентСервер.УчитываемыхДнейВКалендарныхГодахФСС(
		ДанныеСреднегоФСС.ПараметрыРасчета,
		ДанныеСреднегоФСС.ДанныеРасчетаСреднего);
	
	Возврат Результат;
КонецФункции

#КонецОбласти


#КонецОбласти



#КонецЕсли