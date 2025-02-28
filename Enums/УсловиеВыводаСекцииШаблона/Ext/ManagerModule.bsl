﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьОписаниеУсловия(Условие) Экспорт
	Результат = Новый Структура("ДопустимыеВидыСравнения, ТипПравогоЗначения", Неопределено, Неопределено);
	ДопустимыеВидыСравнения = Новый Массив;
	ТипЗначения = Неопределено;
	Если Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.ВидДисконтнойКарты") Тогда
		ДопустимыеВидыСравнения.Добавить(ПредопределенноеЗначение("Перечисление.ВидСравненияЗначений.Равно"));
		ДопустимыеВидыСравнения.Добавить(ПредопределенноеЗначение("Перечисление.ВидСравненияЗначений.НеРавно"));
		ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ВидыДисконтныхКарт");
	ИначеЕсли Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.Сумма") 
		ИЛИ Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаДоСкидок") 
		ИЛИ Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаАвтоматическойСкидки") 
		ИЛИ Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаРучнойСкидки") 
		ИЛИ Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаВсехСкидок") 
		ИЛИ Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаОплатыБонусами") 
		ИЛИ Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.НачисленоБонусов") Тогда
		ДопустимыеВидыСравнения.Добавить(ПредопределенноеЗначение("Перечисление.ВидСравненияЗначений.Больше"));
		ДопустимыеВидыСравнения.Добавить(ПредопределенноеЗначение("Перечисление.ВидСравненияЗначений.БольшеИлиРавно"));
		ДопустимыеВидыСравнения.Добавить(ПредопределенноеЗначение("Перечисление.ВидСравненияЗначений.Меньше"));
		ДопустимыеВидыСравнения.Добавить(ПредопределенноеЗначение("Перечисление.ВидСравненияЗначений.МеньшеИлиРавно"));
		ДопустимыеВидыСравнения.Добавить(ПредопределенноеЗначение("Перечисление.ВидСравненияЗначений.Равно"));
		ДопустимыеВидыСравнения.Добавить(ПредопределенноеЗначение("Перечисление.ВидСравненияЗначений.НеРавно"));
		ТипЗначения = Новый ОписаниеТипов("Число");
	ИначеЕсли Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.ПокупательИдентифицирован") Тогда
		ДопустимыеВидыСравнения.Добавить(ПредопределенноеЗначение("Перечисление.ВидСравненияЗначений.Равно"));
		ДопустимыеВидыСравнения.Добавить(ПредопределенноеЗначение("Перечисление.ВидСравненияЗначений.НеРавно"));
		ТипЗначения = Новый ОписаниеТипов("Булево");
	ИначеЕсли Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.ВыдаетсяПромокодНаСкидку") Тогда
		ДопустимыеВидыСравнения.Добавить(ПредопределенноеЗначение("Перечисление.ВидСравненияЗначений.Равно"));
		ДопустимыеВидыСравнения.Добавить(ПредопределенноеЗначение("Перечисление.ВидСравненияЗначений.НеРавно"));
		ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.АвтоматическиеСкидки");
	Иначе
		ВызватьИсключение(НСтр("ru = 'Неизвестный тип условия вывода секции шаблона чека.'"));
	КонецЕсли;
	Результат.Вставить("ДопустимыеВидыСравнения", ДопустимыеВидыСравнения);
	Результат.Вставить("ТипЗначения", ТипЗначения);
	Возврат Результат;
КонецФункции

Функция ПолучитьСписокДоступныхУсловий(СекцияПромокода = Ложь) Экспорт
	Результат = Новый Массив;
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.Сумма"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаДоСкидок"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаАвтоматическойСкидки"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаРучнойСкидки"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаОплатыБонусами"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаВсехСкидок"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.НачисленоБонусов"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.ВидДисконтнойКарты"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.ПокупательИдентифицирован"));
	Если СекцияПромокода Тогда 
		Результат.Добавить(ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.ВыдаетсяПромокодНаСкидку"));
    КонецЕсли;
	Возврат Результат;
КонецФункции

Функция ВычислитьЛевоеЗначение(Условие, ДанныеЧека) Экспорт
	Результат = Неопределено;

	Шапка = ДанныеЧека.Шапка;       
	ИсточникДанных = Шапка;
	ТекущаяСтрокаТЧ = Неопределено;
	ТекущаяСтрокаВыдачиПромокода = Неопределено;
	Если ДанныеЧека.Свойство("ТекущаяСтрокаТЧ", ТекущаяСтрокаТЧ) Тогда
		ИсточникДанных = ТекущаяСтрокаТЧ;
	ИначеЕсли ДанныеЧека.Свойство("ТекущаяСтрокаВыдачиПромокода", ТекущаяСтрокаВыдачиПромокода) Тогда
		ИсточникДанных =ТекущаяСтрокаВыдачиПромокода;
	КонецЕсли;
	Если Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.ВидДисконтнойКарты") Тогда
		// Не рассчитывается по строке, только по шапке
		Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Шапка.ДисконтнаяКарта, "Владелец");
	ИначеЕсли Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.ПокупательИдентифицирован") Тогда
		// Не рассчитывается по строке, только по шапке
		Результат = ЗначениеЗаполнено(Шапка.Контрагент);
	ИначеЕсли Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.Сумма") Тогда
		Результат = ИсточникДанных.Сумма;
	ИначеЕсли Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаДоСкидок") Тогда
		Результат = ИсточникДанных.СуммаБезСкидки;
	ИначеЕсли Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаАвтоматическойСкидки") Тогда
		Результат = ИсточникДанных.СуммаАвтоматическойСкидки;
	ИначеЕсли Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаРучнойСкидки") Тогда
		Результат = ИсточникДанных.СуммаСкидкиНаценки;
	ИначеЕсли Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаОплатыБонусами") Тогда
		Результат = ИсточникДанных.БонусыСписано;
	ИначеЕсли Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.СуммаВсехСкидок") Тогда
		Результат = ИсточникДанных.СуммаАвтоматическойСкидки + ДанныеЧека.СуммаСкидкиНаценки + ДанныеЧека.СписаноБонусов;
	ИначеЕсли Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.НачисленоБонусов") Тогда
		Результат = ИсточникДанных.БонусыНачислено;
	ИначеЕсли Условие = ПредопределенноеЗначение("Перечисление.УсловиеВыводаСекцииШаблона.ВыдаетсяПромокодНаСкидку") Тогда
		// Рассчитывается только для секции с выдачей промокода 
		Если ЗначениеЗаполнено(ТекущаяСтрокаВыдачиПромокода)
			И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрокаВыдачиПромокода, "ПромокодСкидкаПоПромокоду") Тогда
			Результат = ТекущаяСтрокаВыдачиПромокода.ПромокодСкидкаПоПромокоду;
		Иначе
			Результат = Неопределено;
		КонецЕсли;
	Иначе
		ВызватьИсключение(НСтр("ru = 'Неизвестный тип условия вывода секции шаблона чека.'"));
	КонецЕсли;
	
	ОписаниеУсловия = ПолучитьОписаниеУсловия(Условие);
	Возврат ОписаниеУсловия.ТипЗначения.ПривестиЗначение(Результат);
	
КонецФункции

#КонецЕсли