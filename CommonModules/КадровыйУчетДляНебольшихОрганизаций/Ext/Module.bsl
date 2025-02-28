﻿////////////////////////////////////////////////////////////////////////////////
// Кадровый учет для небольших организаций
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	Списки.Вставить(Метаданные.Документы.КадровыйПеревод, Истина);
	Списки.Вставить(Метаданные.Справочники.КадровыйПереводПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Документы.ПриемНаРаботу, Истина);
	Списки.Вставить(Метаданные.Справочники.ПриемНаРаботуПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Документы.Увольнение, Истина);
	Списки.Вставить(Метаданные.Справочники.УвольнениеПрисоединенныеФайлы, Истина);
	
КонецПроцедуры

#КонецОбласти

Функция СведенияОСреднемЗаработкеДляСправкиПоБезработице(КадровыеДанныеСотрудников) Экспорт
	
	КадровыеДанныеСотрудниковДо2023Года = КадровыеДанныеСотрудников.СкопироватьКолонки();
	КадровыеДанныеСотрудниковС2023Года = КадровыеДанныеСотрудников.СкопироватьКолонки();
	
	Для Каждого КадровыеДанныеСотрудника Из КадровыеДанныеСотрудников Цикл
		Если КадровыеДанныеСотрудника.ДатаУвольнения < '20230801' Тогда
			ЗаполнитьЗначенияСвойств(КадровыеДанныеСотрудниковДо2023Года.Добавить(), КадровыеДанныеСотрудника);
		Иначе
			ЗаполнитьЗначенияСвойств(КадровыеДанныеСотрудниковС2023Года.Добавить(), КадровыеДанныеСотрудника);
		КонецЕсли;
	КонецЦикла;
	
	СведенияОСреднемЗаработке = Новый Соответствие;
	Если ЗначениеЗаполнено(КадровыеДанныеСотрудниковДо2023Года) Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(СведенияОСреднемЗаработке,
			СведенияОСреднемЗаработкеДляСправкиПоБезработицеДо2023(КадровыеДанныеСотрудниковДо2023Года));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КадровыеДанныеСотрудниковС2023Года) Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(СведенияОСреднемЗаработке,
			СведенияОСреднемЗаработкеДляСправкиПоБезработицеС2023(КадровыеДанныеСотрудниковС2023Года));
	КонецЕсли;
	
	Возврат СведенияОСреднемЗаработке;
	
КонецФункции
	
Функция СведенияОСреднемЗаработкеДляСправкиПоБезработицеДо2023(КадровыеДанныеСотрудников) Экспорт
	
	СведенияОСреднемЗаработке = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("КадровыеДанныеСотрудников", КадровыеДанныеСотрудников);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КадровыеДанныеСотрудников.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	КадровыеДанныеСотрудников.Сотрудник,
		|	КадровыеДанныеСотрудников.ДатаПриема,
		|	КадровыеДанныеСотрудников.ДатаУвольнения,
		|	КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(КадровыеДанныеСотрудников.ДатаУвольнения, МЕСЯЦ, -1), МЕСЯЦ) КАК ОкончаниеПериода
		|ПОМЕСТИТЬ ВТПериодыРаботыФизическихЛицПредварительно
		|ИЗ
		|	&КадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПериодыРаботы.ГоловнаяОрганизация,
		|	ПериодыРаботы.Сотрудник,
		|	ПериодыРаботы.ДатаПриема,
		|	ПериодыРаботы.ДатаУвольнения,
		|	НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПериодыРаботы.ОкончаниеПериода, МЕСЯЦ, -2), МЕСЯЦ) КАК НачалоТрехмесячногоПериода,
		|	ВЫБОР
		|		КОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПериодыРаботы.ОкончаниеПериода, МЕСЯЦ, -2), МЕСЯЦ) > ПериодыРаботы.ДатаПриема
		|			ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПериодыРаботы.ОкончаниеПериода, МЕСЯЦ, -2), МЕСЯЦ)
		|		ИНАЧЕ ПериодыРаботы.ДатаПриема
		|	КОНЕЦ КАК НачалоПериода,
		|	ПериодыРаботы.ОкончаниеПериода
		|ПОМЕСТИТЬ ВТПериодыРаботыФизическихЛиц
		|ИЗ
		|	ВТПериодыРаботыФизическихЛицПредварительно КАК ПериодыРаботы";
	
	Запрос.Выполнить();
	
	РасчетЗарплатыДляНебольшихОрганизаций.СоздатьВТНачисленияЗарплаты(Запрос.МенеджерВременныхТаблиц);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник КАК Сотрудник,
		|	ПериодыРаботыФизическихЛиц.НачалоТрехмесячногоПериода КАК НачалоТрехмесячногоПериода,
		|	ПериодыРаботыФизическихЛиц.НачалоПериода КАК НачалоПериода,
		|	ПериодыРаботыФизическихЛиц.ОкончаниеПериода КАК ОкончаниеПериода,
		|	СУММА(НачисленияЗарплаты.Сумма) КАК Сумма,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ НАЧАЛОПЕРИОДА(НачисленияЗарплаты.ДатаНачала, МЕСЯЦ)) КАК Месяцев
		|ПОМЕСТИТЬ ВТПериодыРаботыФизическихЛицССуммой
		|ИЗ
		|	ВТПериодыРаботыФизическихЛиц КАК ПериодыРаботыФизическихЛиц
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНачисленияЗарплаты КАК НачисленияЗарплаты
		|		ПО ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация = НачисленияЗарплаты.ГоловнаяОрганизация
		|			И ПериодыРаботыФизическихЛиц.Сотрудник = НачисленияЗарплаты.Сотрудник
		|
		|СГРУППИРОВАТЬ ПО
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник,
		|	ПериодыРаботыФизическихЛиц.НачалоТрехмесячногоПериода,
		|	ПериодыРаботыФизическихЛиц.НачалоПериода,
		|	ПериодыРаботыФизическихЛиц.ОкончаниеПериода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник КАК Сотрудник,
		|	ПериодыРаботыФизическихЛиц.НачалоТрехмесячногоПериода КАК НачалоТрехмесячногоПериода,
		|	ПериодыРаботыФизическихЛиц.ОкончаниеПериода КАК ОкончаниеПериода,
		|	ПериодыРаботыФизическихЛиц.Сумма КАК Сумма,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеПроизводственногоКалендаря.Дата) КАК ОтработаноДней,
		|	ПериодыРаботыФизическихЛиц.Месяцев КАК Месяцев
		|ПОМЕСТИТЬ ВТПериодыРаботыФизическихЛицССуммойИКоличествомОтработанныхДней
		|ИЗ
		|	ВТПериодыРаботыФизическихЛицССуммой КАК ПериодыРаботыФизическихЛиц
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНачисленияЗарплаты КАК НачисленияЗарплаты
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|			ПО (ДанныеПроизводственногоКалендаря.Дата МЕЖДУ НачисленияЗарплаты.ДатаНачала И НачисленияЗарплаты.ДатаОкончания)
		|				И (ДанныеПроизводственногоКалендаря.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)))
		|		ПО ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация = НачисленияЗарплаты.ГоловнаяОрганизация
		|			И ПериодыРаботыФизическихЛиц.Сотрудник = НачисленияЗарплаты.Сотрудник
		|
		|СГРУППИРОВАТЬ ПО
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник,
		|	ПериодыРаботыФизическихЛиц.НачалоТрехмесячногоПериода,
		|	ПериодыРаботыФизическихЛиц.ОкончаниеПериода,
		|	ПериодыРаботыФизическихЛиц.Сумма,
		|	ПериодыРаботыФизическихЛиц.Месяцев
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеПроизводственногоКалендаря.Дата) > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник КАК Сотрудник,
		|	ПериодыРаботыФизическихЛиц.Сумма КАК Сумма,
		|	ПериодыРаботыФизическихЛиц.ОтработаноДней КАК ОтработаноДней,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеПроизводственногоКалендаряЗаТриМесяца.Дата) КАК РабочихДнейВТрехМесяцах,
		|	ЕСТЬNULL(КОЛИЧЕСТВО(РАЗЛИЧНЫЕ НАЧАЛОПЕРИОДА(ДанныеПроизводственногоКалендаряЗаТриМесяца.Дата, МЕСЯЦ)), 3) КАК Месяцев
		|ИЗ
		|	ВТПериодыРаботыФизическихЛицССуммойИКоличествомОтработанныхДней КАК ПериодыРаботыФизическихЛиц
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаряЗаТриМесяца
		|		ПО ПериодыРаботыФизическихЛиц.НачалоТрехмесячногоПериода <= ДанныеПроизводственногоКалендаряЗаТриМесяца.Дата
		|			И ПериодыРаботыФизическихЛиц.ОкончаниеПериода >= ДанныеПроизводственногоКалендаряЗаТриМесяца.Дата
		|			И (ДанныеПроизводственногоКалендаряЗаТриМесяца.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)))
		|
		|СГРУППИРОВАТЬ ПО
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник,
		|	ПериодыРаботыФизическихЛиц.Сумма,
		|	ПериодыРаботыФизическихЛиц.ОтработаноДней";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("ГоловнаяОрганизация", Выборка.ГоловнаяОрганизация);
		СтруктураПоиска.Вставить("Сотрудник", Выборка.Сотрудник);
		
		СтрокиСотрудников = КадровыеДанныеСотрудников.НайтиСтроки(СтруктураПоиска);
		Если СтрокиСотрудников.Количество() > 0 Тогда
			
			СреднедневнойЗаработок = Выборка.Сумма / Выборка.ОтработаноДней;
			СреднийЗаработок = СреднедневнойЗаработок * Выборка.РабочихДнейВТрехМесяцах / Выборка.Месяцев;
			
			Для Каждого СтрокаСотрудника Из СтрокиСотрудников Цикл
				СведенияОСреднемЗаработке.Вставить(СтрокаСотрудника.Сотрудник, Окр(СреднийЗаработок, 2, РежимОкругления.Окр15как20));
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Возврат СведенияОСреднемЗаработке;
	
КонецФункции

Функция СведенияОСреднемЗаработкеДляСправкиПоБезработицеС2023(КадровыеДанныеСотрудников) Экспорт
	
	СведенияОСреднемЗаработке = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("КадровыеДанныеСотрудников", КадровыеДанныеСотрудников);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КадровыеДанныеСотрудников.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	КадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
		|	КадровыеДанныеСотрудников.ДатаПриема КАК ДатаПриема,
		|	КадровыеДанныеСотрудников.ДатаУвольнения КАК ДатаУвольнения,
//		|	ВЫБОР
//		|		КОГДА КОНЕЦПЕРИОДА(КадровыеДанныеСотрудников.ДатаУвольнения, МЕСЯЦ) = КОНЕЦПЕРИОДА(КадровыеДанныеСотрудников.ДатаУвольнения, ДЕНЬ)
//		|			ТОГДА КОНЕЦПЕРИОДА(КадровыеДанныеСотрудников.ДатаУвольнения, ДЕНЬ)
//		|		ИНАЧЕ КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(КадровыеДанныеСотрудников.ДатаУвольнения, МЕСЯЦ, -1), МЕСЯЦ)
//		|	КОНЕЦ КАК ОкончаниеПериода
		|	 КОНЕЦПЕРИОДА(КадровыеДанныеСотрудников.ДатаУвольнения, ДЕНЬ) КАК ОкончаниеПериода
		|ПОМЕСТИТЬ ВТПериодыРаботыФизическихЛицПредварительно
		|ИЗ
		|	&КадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПериодыРаботы.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ПериодыРаботы.Сотрудник КАК Сотрудник,
		|	ПериодыРаботы.ДатаПриема КАК ДатаПриема,
		|	ПериодыРаботы.ДатаУвольнения КАК ДатаУвольнения,
		|	НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПериодыРаботы.ОкончаниеПериода, МЕСЯЦ, -11), МЕСЯЦ) КАК НачалоПериода,
		|	ПериодыРаботы.ОкончаниеПериода КАК ОкончаниеПериода
		|ПОМЕСТИТЬ ВТПериодыРаботыФизическихЛиц
		|ИЗ
		|	ВТПериодыРаботыФизическихЛицПредварительно КАК ПериодыРаботы";
	
	Запрос.Выполнить();
	
	РасчетЗарплатыДляНебольшихОрганизаций.СоздатьВТНачисленияЗарплаты(Запрос.МенеджерВременныхТаблиц);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник КАК Сотрудник,
		|	ПериодыРаботыФизическихЛиц.ДатаУвольнения КАК ДатаУвольнения,
		|	ПериодыРаботыФизическихЛиц.НачалоПериода КАК НачалоПериода,
		|	ПериодыРаботыФизическихЛиц.ОкончаниеПериода КАК ОкончаниеПериода,
		|	НАЧАЛОПЕРИОДА(НачисленияЗарплаты.Период, МЕСЯЦ) КАК Месяц,
		|	СУММА(ЕСТЬNULL(НачисленияЗарплаты.Сумма, 0)) КАК Сумма
		|ИЗ
		|	ВТПериодыРаботыФизическихЛиц КАК ПериодыРаботыФизическихЛиц
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНачисленияЗарплаты КАК НачисленияЗарплаты
		|		ПО ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация = НачисленияЗарплаты.ГоловнаяОрганизация
		|			И ПериодыРаботыФизическихЛиц.Сотрудник = НачисленияЗарплаты.Сотрудник
		|
		|СГРУППИРОВАТЬ ПО
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник,
		|	ПериодыРаботыФизическихЛиц.ДатаУвольнения,
		|	ПериодыРаботыФизическихЛиц.НачалоПериода,
		|	ПериодыРаботыФизическихЛиц.ОкончаниеПериода,
		|	НАЧАЛОПЕРИОДА(НачисленияЗарплаты.Период, МЕСЯЦ)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сотрудник,
		|	Месяц";
	
	ТаблицаПериодов = Новый ТаблицаЗначений;
	ТаблицаПериодов.Колонки.Добавить("ГоловнаяОрганизация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаПериодов.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаПериодов.Колонки.Добавить("Начало", Новый ОписаниеТипов("Дата"));
	ТаблицаПериодов.Колонки.Добавить("Окончание", Новый ОписаниеТипов("Дата"));
	ТаблицаПериодов.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число"));
	ТаблицаПериодов.Колонки.Добавить("Месяцев", Новый ОписаниеТипов("Число"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Сотрудник") Цикл
		МесяцыДоходов = Новый Массив;
		Месяц = Выборка.Месяц;
		Пока Выборка.Следующий() Цикл
			Если Выборка.Месяц = КонецМесяца(Выборка.ДатаУвольнения)
				И КонецДня(Выборка.ДатаУвольнения) <> КонецМесяца(Выборка.ДатаУвольнения)
				И МесяцыДоходов.Количество() > 0 Тогда
				
				Продолжить;
			КонецЕсли;
			Если Выборка.Сумма > 0 Тогда
				Пока ДобавитьМесяц(Месяц, 1) < Выборка.Месяц Цикл
					МесяцыДоходов.Добавить(Новый Структура("Месяц,Сумма", Месяц, 0));
					Месяц = ДобавитьМесяц(Месяц, 1);
				КонецЦикла;
				МесяцыДоходов.Добавить(Новый Структура("Месяц,Сумма", Выборка.Месяц, Выборка.Сумма));
				Месяц = Выборка.Месяц;
			КонецЕсли;
		КонецЦикла;
		НоваяСтрока = ТаблицаПериодов.Добавить();
		НоваяСтрока.ГоловнаяОрганизация = Выборка.ГоловнаяОрганизация;
		НоваяСтрока.Сотрудник = Выборка.Сотрудник;
		Для Индекс = 0 По МесяцыДоходов.Количество() - 1 Цикл
			Сумма = МесяцыДоходов[Индекс].Сумма;
			Окончание = КонецМесяца(МесяцыДоходов[Индекс].Месяц);
			Месяцев = 1;
			Если Индекс + 1 < МесяцыДоходов.Количество() Тогда
				Сумма = Сумма + МесяцыДоходов[Индекс + 1].Сумма;
				Окончание = КонецМесяца(МесяцыДоходов[Индекс + 1].Месяц);
				Месяцев = 2;
			КонецЕсли;
			Если Индекс + 2 < МесяцыДоходов.Количество() Тогда
				Сумма = Сумма + МесяцыДоходов[Индекс + 2].Сумма;
				Окончание = КонецМесяца(МесяцыДоходов[Индекс + 2].Месяц);
				Месяцев = 3;
			КонецЕсли;
			Если Сумма >= НоваяСтрока.Сумма Тогда
				НоваяСтрока.Сумма = Сумма;
				НоваяСтрока.Начало = МесяцыДоходов[Индекс].Месяц;
				НоваяСтрока.Окончание = Окончание;
				НоваяСтрока.Месяцев = Месяцев;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТаблицаПериодов", ТаблицаПериодов);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаПериодов.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ТаблицаПериодов.Сотрудник КАК Сотрудник,
		|	ТаблицаПериодов.Начало КАК НачалоПериода,
		|	ТаблицаПериодов.Окончание КАК ОкончаниеПериода,
		|	ТаблицаПериодов.Месяцев КАК Месяцев,
		|	ТаблицаПериодов.Сумма КАК Сумма
		|ПОМЕСТИТЬ ВТПериодыРаботыФизическихЛицССуммой
		|ИЗ
		|	&ТаблицаПериодов КАК ТаблицаПериодов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник КАК Сотрудник,
		|	ПериодыРаботыФизическихЛиц.НачалоПериода КАК НачалоПериода,
		|	ПериодыРаботыФизическихЛиц.ОкончаниеПериода КАК ОкончаниеПериода,
		|	ПериодыРаботыФизическихЛиц.Сумма КАК Сумма,
		|	СУММА(ОтработанноеВремяПоСотрудникам.ОтработаноДней) КАК ОтработаноДней,
		|	ПериодыРаботыФизическихЛиц.Месяцев КАК Месяцев
		|ПОМЕСТИТЬ ВТПериодыРаботыФизическихЛицССуммойИКоличествомОтработанныхДней
		|ИЗ
		|	ВТПериодыРаботыФизическихЛицССуммой КАК ПериодыРаботыФизическихЛиц
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОтработанноеВремяПоСотрудникам КАК ОтработанноеВремяПоСотрудникам
		|		ПО ПериодыРаботыФизическихЛиц.Сотрудник = ОтработанноеВремяПоСотрудникам.Сотрудник
		|			И (ОтработанноеВремяПоСотрудникам.Период МЕЖДУ ПериодыРаботыФизическихЛиц.НачалоПериода И ПериодыРаботыФизическихЛиц.ОкончаниеПериода)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник,
		|	ПериодыРаботыФизическихЛиц.НачалоПериода,
		|	ПериодыРаботыФизическихЛиц.ОкончаниеПериода,
		|	ПериодыРаботыФизическихЛиц.Сумма,
		|	ПериодыРаботыФизическихЛиц.Месяцев
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник КАК Сотрудник,
		|	ПериодыРаботыФизическихЛиц.Сумма КАК Сумма,
		|	ЕСТЬNULL(ПериодыРаботыФизическихЛиц.ОтработаноДней, 0) КАК ОтработаноДней,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеПроизводственногоКалендаряЗаТриМесяца.Дата) КАК РабочихДнейВТрехМесяцах,
		|	ЕСТЬNULL(КОЛИЧЕСТВО(РАЗЛИЧНЫЕ НАЧАЛОПЕРИОДА(ДанныеПроизводственногоКалендаряЗаТриМесяца.Дата, МЕСЯЦ)), 3) КАК Месяцев
		|ИЗ
		|	ВТПериодыРаботыФизическихЛицССуммойИКоличествомОтработанныхДней КАК ПериодыРаботыФизическихЛиц
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаряЗаТриМесяца
		|		ПО ПериодыРаботыФизическихЛиц.НачалоПериода <= ДанныеПроизводственногоКалендаряЗаТриМесяца.Дата
		|			И ПериодыРаботыФизическихЛиц.ОкончаниеПериода >= ДанныеПроизводственногоКалендаряЗаТриМесяца.Дата
		|			И (ДанныеПроизводственногоКалендаряЗаТриМесяца.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)))
		|
		|СГРУППИРОВАТЬ ПО
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник,
		|	ПериодыРаботыФизическихЛиц.Сумма,
		|	ПериодыРаботыФизическихЛиц.ОтработаноДней";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("ГоловнаяОрганизация", Выборка.ГоловнаяОрганизация);
		СтруктураПоиска.Вставить("Сотрудник", Выборка.Сотрудник);
		
		СтрокиСотрудников = КадровыеДанныеСотрудников.НайтиСтроки(СтруктураПоиска);
		Если СтрокиСотрудников.Количество() > 0 Тогда
			
			Если ЗначениеЗаполнено(Выборка.ОтработаноДней) Тогда
				СреднедневнойЗаработок = Выборка.Сумма / Выборка.ОтработаноДней;
				СреднийЗаработок = СреднедневнойЗаработок * Выборка.РабочихДнейВТрехМесяцах / Выборка.Месяцев;
			Иначе
				СреднийЗаработок = 0;
			КонецЕсли;
			
			Для Каждого СтрокаСотрудника Из СтрокиСотрудников Цикл
				СведенияОСреднемЗаработке.Вставить(СтрокаСотрудника.Сотрудник, Окр(СреднийЗаработок, 2, РежимОкругления.Окр15как20));
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Возврат СведенияОСреднемЗаработке;
	
КонецФункции

Функция СведенияОПериодахНеРаботыДляСправкиПоБезработице(КадровыеДанныеСотрудников) Экспорт
	
	СведенияОПериодахНеРаботы = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("КадровыеДанныеСотрудников", КадровыеДанныеСотрудников);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КадровыеДанныеСотрудников.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	КадровыеДанныеСотрудников.Сотрудник,
		|	ВЫБОР
		|		КОГДА ДОБАВИТЬКДАТЕ(КадровыеДанныеСотрудников.ДатаУвольнения, ГОД, -1) > КадровыеДанныеСотрудников.ДатаПриема
		|			ТОГДА ДОБАВИТЬКДАТЕ(КадровыеДанныеСотрудников.ДатаУвольнения, ГОД, -1)
		|		ИНАЧЕ КадровыеДанныеСотрудников.ДатаПриема
		|	КОНЕЦ КАК НачалоПериода,
		|	КадровыеДанныеСотрудников.ДатаУвольнения КАК ОкончаниеПериода
		|ПОМЕСТИТЬ ВТПериодыРаботыФизическихЛиц
		|ИЗ
		|	&КадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников";
	
	Запрос.Выполнить();
	
	РасчетЗарплатыДляНебольшихОрганизаций.СоздатьВТПериодыОтсутствий(Запрос.МенеджерВременныхТаблиц);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПериодыОтсутствий.Сотрудник КАК Сотрудник,
		|	МИНИМУМ(ПериодыОтсутствий.ДатаНачала) КАК ДатаНачала,
		|	МАКСИМУМ(ПериодыОтсутствий.ДатаОкончания) КАК ДатаОкончания,
		|	ПериодыОтсутствий.СсылкаНаДокумент КАК СсылкаНаДокумент,
		|	ПериодыОтсутствий.ПричинаНеРаботы КАК ПричинаНеРаботы,
		|	ПериодыОтсутствий.КатегорияНачисленияИлиНеоплаченногоВремени КАК КатегорияНачисленияИлиНеоплаченногоВремени
		|ИЗ
		|	ВТПериодыОтсутствий КАК ПериодыОтсутствий
		|
		|СГРУППИРОВАТЬ ПО
		|	ПериодыОтсутствий.Сотрудник,
		|	ПериодыОтсутствий.СсылкаНаДокумент,
		|	ПериодыОтсутствий.ПричинаНеРаботы,
		|	ПериодыОтсутствий.КатегорияНачисленияИлиНеоплаченногоВремени
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сотрудник,
		|	ДатаНачала";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Сотрудник") Цикл
		
		СтрокиСотрудников = КадровыеДанныеСотрудников.НайтиСтроки(Новый Структура("Сотрудник", Выборка.Сотрудник));
		ПериодыНеРаботы = Новый Массив;
		
		Пока Выборка.Следующий() Цикл
			
			ПериодНеРаботы = Новый Структура;
			ПериодНеРаботы.Вставить("НачалоПериода", Выборка.ДатаНачала);
			ПериодНеРаботы.Вставить("ОкончаниеПериода", Выборка.ДатаОкончания);
			ПериодНеРаботы.Вставить("КатегорияНачисленияИлиНеоплаченногоВремени", Выборка.КатегорияНачисленияИлиНеоплаченногоВремени);
			Если ТипЗнч(Выборка.СсылкаНаДокумент) = Тип("ДокументСсылка.Отпуск") Тогда
				
				ПериодНеРаботы.Вставить("ПричинаОтсутствия",
					НСтр("ru='Период, когда заработная плата не выплачивалась'"));
				
			Иначе
				
				ПериодНеРаботы.Вставить("ПричинаОтсутствия",
					НСтр("ru='Временная нетрудоспособность, в том числе отпуск по беременности и родам'"));
				
				
			КонецЕсли;
			
			ПериодыНеРаботы.Добавить(ПериодНеРаботы);
			
		КонецЦикла;
		
		Если ПериодыНеРаботы.Количество() > 0 Тогда
			
			Для Каждого СтрокаДанныхСотрудника Из СтрокиСотрудников Цикл
				СведенияОПериодахНеРаботы.Вставить(СтрокаДанныхСотрудника.Сотрудник, ПериодыНеРаботы);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Возврат СведенияОПериодахНеРаботы;
	
КонецФункции

Функция ДанныеОтсутствийСотрудникаДляПособияПоБезработице(КадровыеДанныеСотрудников) Экспорт
	
	ДанныеОтсутствий = Новый Соответствие;
	
	СведенияСотрудников = СведенияОПериодахНеРаботыДляСправкиПоБезработице(КадровыеДанныеСотрудников);
	Для Каждого СведенияСотрудника Из СведенияСотрудников Цикл
		ДанныеНеОплачиваемыхОтпусков = Новый Массив;
		Для Каждого ДанныеОтсутствия Из СведенияСотрудника.Значение Цикл
			Если ДанныеОтсутствия.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОтпускПоБеременностиИРодам
				Или ДанныеОтсутствия.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОтпускБезОплаты Тогда
				
				ОтсутствияСотрудника = ДанныеОтсутствий.Получить(СведенияСотрудника.Ключ);
				Если ОтсутствияСотрудника = Неопределено Тогда
					ОтсутствияСотрудника = Новый Соответствие;
					ДанныеОтсутствий.Вставить(СведенияСотрудника.Ключ, ОтсутствияСотрудника);
				КонецЕсли;
				
				Если ДанныеОтсутствия.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОтпускПоБеременностиИРодам Тогда
					ДатыОтсутствия = ОтсутствияСотрудника.Получить("ОтпускПоБеременностиИРодам");
					Если ДатыОтсутствия <> Неопределено
						И КонецДня(ДанныеОтсутствия.ОкончаниеПериода) + 1 = ДатыОтсутствия.Начало Тогда
						
						ДатыОтсутствия.Начало = ДанныеОтсутствия.НачалоПериода;
					Иначе
						ОтсутствияСотрудника.Вставить("ОтпускПоБеременностиИРодам",
							Новый Структура("Начало,Окончание", ДанныеОтсутствия.НачалоПериода, ДанныеОтсутствия.ОкончаниеПериода));
					КонецЕсли;
				КонецЕсли;
				
				Если ДанныеОтсутствия.КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОтпускБезОплаты Тогда
					Если ДанныеНеОплачиваемыхОтпусков.Количество() > 0
						И КонецДня(ДанныеОтсутствия.ОкончаниеПериода) + 1 = ДанныеНеОплачиваемыхОтпусков[ДанныеНеОплачиваемыхОтпусков.Количество() - 1].Начало Тогда
						
						ДанныеНеОплачиваемыхОтпусков[ДанныеНеОплачиваемыхОтпусков.Количество() - 1].Начало = ДанныеОтсутствия.НачалоПериода;
					Иначе
						ТекущиеДанные = Новый Структура("Начало,Окончание", ДанныеОтсутствия.НачалоПериода, ДанныеОтсутствия.ОкончаниеПериода);
						ДанныеНеОплачиваемыхОтпусков.Добавить(ТекущиеДанные);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			Если ДанныеНеОплачиваемыхОтпусков.Количество() > 0 Тогда
				НужныйПериод = Неопределено;
				Для Каждого ПериодОтпуска Из ДанныеНеОплачиваемыхОтпусков Цикл
					Если Год(ПериодОтпуска.Окончание) - Год(ПериодОтпуска.Начало) > 1 Тогда
						НужныйПериод = ПериодОтпуска;
					ИначеЕсли Год(ПериодОтпуска.Окончание) - Год(ПериодОтпуска.Начало) = 1 Тогда
						Если Месяц(ПериодОтпуска.Окончание) > Месяц(ПериодОтпуска.Начало) Тогда
							НужныйПериод = ПериодОтпуска;
						ИначеЕсли Месяц(ПериодОтпуска.Окончание) + 12 - Месяц(ПериодОтпуска.Начало) >= 9 Тогда
							НужныйПериод = ПериодОтпуска;
						КонецЕсли;
					ИначеЕсли Месяц(ПериодОтпуска.Окончание) - Месяц(ПериодОтпуска.Начало) >= 9 Тогда
						НужныйПериод = ПериодОтпуска;
					КонецЕсли;
				КонецЦикла;
				Если НужныйПериод <> Неопределено Тогда
					ОтсутствияСотрудника.Вставить("ОтпускНеоплачиваемый", НужныйПериод);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ДанныеОтсутствий;
	
КонецФункции

Процедура ПолученияФормыТекущихДанныхСотрудников(Источник, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если ВидФормы = "ФормаСписка" Тогда
		
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ФормаСписка";
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УточнитьПериодКадровойИсторииСотрудников(Источник, Отказ, Замещение) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Запись Из Источник Цикл
		Запись.Период = НачалоДня(Запись.Период);
	КонецЦикла;
	
КонецПроцедуры

Функция ПриСозданииФормыСпискаСотрудников(УправляемаяФорма) Экспорт
	
	Список = УправляемаяФорма.Список;
	Список.ТекстЗапроса = ТекстЗапросаСпискаСотрудников();
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "МаксимальнаяДатаНачалоДня", НачалоДня(ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата()), Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "МаксимальнаяДатаКонецДня", ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата(), Истина);
	
КонецФункции

Процедура ПроверитьДанныеСотрудников(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("ПолноеПереформирование") Тогда
		Возврат;
	КонецЕсли;
	
	Если (Источник.Отбор.Найти("Сотрудник") = Неопределено
		Или Не Источник.Отбор.Сотрудник.Использование)
			И (Источник.Отбор.Найти("ФизическоеЛицо") = Неопределено
				Или Не Источник.Отбор.ФизическоеЛицо.Использование) Тогда
		
		Возврат;
	КонецЕсли;
	
	Если Источник.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		ТекстЗапросаСпискаСотрудников();
		
	Если Источник.Отбор.Найти("Сотрудник") <> Неопределено
		И Не Источник.Отбор.Сотрудник.Использование Тогда
		
		Запрос.УстановитьПараметр("Сотрудник", Источник.Отбор.Сотрудник.Значение);
		Запрос.Текст = Запрос.Текст
			+ "
				|ГДЕ
				|	СправочникСотрудники.Ссылка = &Сотрудник";
	Иначе
		
		Запрос.УстановитьПараметр("ФизическоеЛицо", Источник.Отбор.ФизическоеЛицо.Значение);
		Запрос.Текст = Запрос.Текст
			+ "
				|ГДЕ
				|	СправочникСотрудники.ФизическоеЛицо = &ФизическоеЛицо";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("МаксимальнаяДатаНачалоДня", НачалоДня(ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата()));
	Запрос.УстановитьПараметр("МаксимальнаяДатаКонецДня", ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата());
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"ИЗ
			|	Справочник.Сотрудники КАК СправочникСотрудники",
		"ПОМЕСТИТЬ ВТСписок
			|ИЗ
			|	Справочник.Сотрудники КАК СправочникСотрудники");
	
	Запрос.Текст =
		Запрос.Текст
		+ ЗарплатаКадрыОбщиеНаборыДанных.РазделительЗапросов()
		+	"ВЫБРАТЬ
		 	|	Список.Ссылка КАК Ссылка
		 	|ИЗ
		 	|	ВТСписок КАК Список
		 	|
		 	|СГРУППИРОВАТЬ ПО
		 	|	Список.Ссылка
		 	|
		 	|ИМЕЮЩИЕ
		 	|	КОЛИЧЕСТВО(Список.Ссылка) > 1";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	Пока Выборка.Следующий() Цикл
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru = '%1: Нарушена уникальность списка справочника Сотрудники (%2).'"),
			Источник.Метаданные().ПолноеИмя(),
			Выборка.Ссылка);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТекстЗапросаСпискаСотрудников()
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКадровыйУчет") Тогда
		
		Возврат
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	0 КАК ИндикаторПроблем,
			|	СправочникСотрудники.Ссылка КАК Ссылка,
			|	СправочникСотрудники.ВерсияДанных КАК ВерсияДанных,
			|	СправочникСотрудники.ПометкаУдаления КАК ПометкаУдаления,
			|	СправочникСотрудники.Предопределенный КАК Предопределенный,
			|	СправочникСотрудники.Код КАК Код,
			|	СправочникСотрудники.Наименование КАК Наименование,
			|	СправочникСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
			|	СправочникСотрудники.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
			|	СправочникСотрудники.ТекущийПроцентСевернойНадбавки КАК ТекущийПроцентСевернойНадбавки,
			|	СправочникСотрудники.ВАрхиве КАК ВАрхиве,
			|	СправочникСотрудники.УточнениеНаименования КАК УточнениеНаименования,
			|	СправочникСотрудники.ГоловнойСотрудник КАК ГоловнойСотрудник,
			|	ЕСТЬNULL(ВидыЗанятостиСотрудниковИнтервальный.ВидЗанятости, ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ПустаяСсылка)) КАК ВидЗанятости,
			|	ВЫБОР
			|		КОГДА ОсновныеСотрудникиФизическихЛиц.Сотрудник ЕСТЬ NULL
			|			ТОГДА ЛОЖЬ
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ КАК ОсновноеРабочееМестоВОрганизации,
			|	ЕСТЬNULL(КадроваяИсторияСотрудниковИнтервальный.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК ТекущаяОрганизация,
			|	ЕСТЬNULL(КадроваяИсторияСотрудниковИнтервальный.Подразделение, ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)) КАК ТекущееПодразделение,
			|	ЕСТЬNULL(КадроваяИсторияСотрудниковИнтервальный.Должность, ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)) КАК ТекущаяДолжность,
			|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ДатаПриема, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПриема,
			|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаУвольнения,
			|	ЕСТЬNULL(ТекущаяТарифнаяСтавкаСотрудников.ТекущаяТарифнаяСтавка, 0) КАК ТекущаяТарифнаяСтавка,
			|	ЕСТЬNULL(ТекущаяТарифнаяСтавкаСотрудников.ТекущийСпособРасчетаАванса, ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаАванса.ПустаяСсылка)) КАК ТекущийСпособРасчетаАванса,
			|	ЕСТЬNULL(ТекущаяТарифнаяСтавкаСотрудников.ТекущийАванс, 0) КАК ТекущийАванс,
			|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ОформленПоТрудовомуДоговору, ЛОЖЬ) КАК ОформленПоТрудовомуДоговору
			|ИЗ
			|	Справочник.Сотрудники КАК СправочникСотрудники
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
			|		ПО (ТекущиеКадровыеДанныеСотрудников.Сотрудник = СправочникСотрудники.Ссылка)
			|			И (ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо = СправочникСотрудники.ФизическоеЛицо)
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСотрудникиФизическихЛиц КАК ОсновныеСотрудникиФизическихЛиц
			|		ПО СправочникСотрудники.Ссылка = ОсновныеСотрудникиФизическихЛиц.Сотрудник
			|			И (&МаксимальнаяДатаНачалоДня = ОсновныеСотрудникиФизическихЛиц.ДатаОкончания)
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК КадроваяИсторияСотрудниковИнтервальный
			|		ПО СправочникСотрудники.Ссылка = КадроваяИсторияСотрудниковИнтервальный.Сотрудник
			|			И (&МаксимальнаяДатаКонецДня = КадроваяИсторияСотрудниковИнтервальный.ДатаОкончания)
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВидыЗанятостиСотрудниковИнтервальный КАК ВидыЗанятостиСотрудниковИнтервальный
			|		ПО СправочникСотрудники.Ссылка = ВидыЗанятостиСотрудниковИнтервальный.Сотрудник
			|			И (&МаксимальнаяДатаКонецДня = ВидыЗанятостиСотрудниковИнтервальный.ДатаОкончания)
			|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущаяТарифнаяСтавкаСотрудников КАК ТекущаяТарифнаяСтавкаСотрудников
			|		ПО (ТекущаяТарифнаяСтавкаСотрудников.Сотрудник = СправочникСотрудники.Ссылка)
			|			И (ТекущаяТарифнаяСтавкаСотрудников.ФизическоеЛицо = СправочникСотрудники.ФизическоеЛицо)}";
	Иначе
		
		Возврат
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	0 КАК ИндикаторПроблем,
			|	СправочникСотрудники.Ссылка КАК Ссылка,
			|	СправочникСотрудники.ВерсияДанных КАК ВерсияДанных,
			|	СправочникСотрудники.ПометкаУдаления КАК ПометкаУдаления,
			|	СправочникСотрудники.Предопределенный КАК Предопределенный,
			|	СправочникСотрудники.Код КАК Код,
			|	СправочникСотрудники.Наименование КАК Наименование,
			|	СправочникСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
			|	СправочникСотрудники.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
			|	СправочникСотрудники.ТекущийПроцентСевернойНадбавки КАК ТекущийПроцентСевернойНадбавки,
			|	СправочникСотрудники.ВАрхиве КАК ВАрхиве,
			|	СправочникСотрудники.УточнениеНаименования КАК УточнениеНаименования,
			|	СправочникСотрудники.ГоловнойСотрудник КАК ГоловнойСотрудник,
			|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ТекущийВидЗанятости, ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ПустаяСсылка)) КАК ВидЗанятости,
			|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ОсновноеРабочееМестоВОрганизации, ЛОЖЬ) КАК ОсновноеРабочееМестоВОрганизации,
			|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК ТекущаяОрганизация,
			|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ТекущееПодразделение, ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)) КАК ТекущееПодразделение,
			|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ТекущаяДолжность, ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)) КАК ТекущаяДолжность,
			|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ДатаПриема, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПриема,
			|	ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаУвольнения,
			|	ЕСТЬNULL(ТекущаяТарифнаяСтавкаСотрудников.ТекущаяТарифнаяСтавка, 0) КАК ТекущаяТарифнаяСтавка,
			|	ЕСТЬNULL(ТекущаяТарифнаяСтавкаСотрудников.ТекущийСпособРасчетаАванса, ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаАванса.ПустаяСсылка)) КАК ТекущийСпособРасчетаАванса,
			|	ЕСТЬNULL(ТекущаяТарифнаяСтавкаСотрудников.ТекущийАванс, 0) КАК ТекущийАванс,
			|	ВЫБОР
			|		КОГДА ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ДатаПриема, ДАТАВРЕМЯ(1, 1, 1)) = ДАТАВРЕМЯ(1, 1, 1)
			|				ИЛИ ЕСТЬNULL(ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
			|			ТОГДА ЛОЖЬ
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ КАК ОформленПоТрудовомуДоговору
			|ИЗ
			|	Справочник.Сотрудники КАК СправочникСотрудники
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
			|		ПО (ТекущиеКадровыеДанныеСотрудников.Сотрудник = СправочникСотрудники.Ссылка)
			|			И (ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо = СправочникСотрудники.ФизическоеЛицо)
			|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущаяТарифнаяСтавкаСотрудников КАК ТекущаяТарифнаяСтавкаСотрудников
			|		ПО (ТекущаяТарифнаяСтавкаСотрудников.Сотрудник = СправочникСотрудники.Ссылка)
			|			И (ТекущаяТарифнаяСтавкаСотрудников.ФизическоеЛицо = СправочникСотрудники.ФизическоеЛицо)}";
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти
