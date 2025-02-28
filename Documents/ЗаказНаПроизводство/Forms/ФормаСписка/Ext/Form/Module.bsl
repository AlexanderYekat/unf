﻿#Область ОписаниеПеременных

#Область ПеременныеФормы

&НаКлиенте
Перем ДанныеВыбораСостояния;

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеОтмененногоЗаказа(
		Список.КомпоновщикНастроек.Настройки.УсловноеОформление);
	
	УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	
	ИспользоватьРезервированиеЗапасов = ПолучитьФункциональнуюОпцию("РезервированиеЗапасов");
	
	Если НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимПодразделениям.Получить()
		И НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимСкладам.Получить() Тогда
		
		Элементы.ОтборПодразделение.РежимВыбораИзСписка = Истина;
		Элементы.ОтборПодразделение.СписокВыбора.Добавить(Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение);
		Элементы.ОтборПодразделение.СписокВыбора.Добавить(Справочники.СтруктурныеЕдиницы.ОсновнойСклад);
		
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("АктуальнаяДатаСеанса", ТекущаяДатаСеанса());
	
	Если ПолучитьФункциональнуюОпцию("РезервированиеЗапасов") Тогда
		Элементы.ДокументОснование.Видимость= Ложь;
		Элементы.ЗаказПокупателя.Видимость	= Истина;
	Иначе
		Элементы.ДокументОснование.Видимость= Истина;
		Элементы.ЗаказПокупателя.Видимость	= Ложь;
	КонецЕсли;
	
	СостоянияЗаказов.ЗаполнитьСписокВыбораЗавершенияЗаказа(Элементы.ОтборЗавершениеЗаказа.СписокВыбора);
	ЭтотОбъект.ТребуетсяОбновитьДанныеВыбораСостояния = Истина;
	
	ОбновитьКомандыИзмененияСостояний();
	
	УстановитьОтборТекущиеДела();
	КонтекстноеОткрытие = Параметры.Свойство("ТекущиеДела");
	
	//УНФ.ОтборыСписка
	УстановитьВидимостьОтборов();
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект);
	Если Не КонтекстноеОткрытие Тогда
		РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
		ВыполнитьЗагрузкуНестандартныхОтборов();
	Иначе
		РаботаСОтборамиКлиентСервер.УстановитьОтображениеКомандыСброситьВсеОтборы(ЭтотОбъект);
	КонецЕсли;
	//Конец УНФ.ОтборыСписка
	
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(Список);
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(СписокЗаказыПокупателей);
	
	// ИнтернетПоддержкаПользователей.Новости
	ОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"УНФ.Документ.ЗаказНаПроизводство",
		"ФормаСписка",
		Неопределено,
		НСтр("ru='Новости: Заказы на производство'"),
		Ложь,
		Новый Структура("ПолучатьНовостиНаСервере, ХранитьМассивНовостейТолькоНаСервере", Истина, Истина),
		"ПриОткрытии");
	// Конец ИнтернетПоддержкаПользователей.Новости
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ПодменюПечать);
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	Если ИспользоватьПодключаемоеОборудование Тогда
		ТипыОборудования = МенеджерОборудованияКлиентСервер.ПараметрыТипыОборудования();
		ТипыОборудования.СканерШтрихкода = Истина;
		МенеджерОборудования.ПриСозданииНаСервере(ЭтотОбъект, ТипыОборудования);
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.Новости
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не КонтекстноеОткрытие И НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли;
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ЗаказНаПроизводство"
		И Элементы.Страницы.ТекущаяСтраница=Элементы.СтраницыЗаказыПокупателей Тогда
		Элементы.СписокЗаказыПокупателей.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_СостоянияЗаказовНаПроизводство" Тогда
		УстановитьУсловноеОформлениеИОбновитьКомандыИзмененияСостояний();
		ЭтотОбъект.ТребуетсяОбновитьДанныеВыбораСостояния = Истина;
	КонецЕсли;
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУНФКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУНФКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборПодразделениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СтруктурнаяЕдиница", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СостояниеЗаказа", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЭтотОбъект.ТребуетсяОбновитьДанныеВыбораСостояния Тогда
		ДанныеВыбораСостояния = ПолучитьДанныеВыбора(Тип("СправочникСсылка.СостоянияЗаказовНаПроизводство"), ПараметрыПолученияДанных);
		ЭтотОбъект.ТребуетсяОбновитьДанныеВыбораСостояния = Ложь;
	КонецЕсли;
	
	ДанныеВыбора = ДанныеВыбораСостояния;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборЗавершениеЗаказаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ВариантЗавершения", Элемент.Родитель.Имя,
		ПредопределенноеЗначение("Перечисление.ВариантыЗавершенияЗаказа." + ВыбранноеЗначение),
		Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение).Представление);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборЗаказНаПроизводствоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеДокумента = СтрЗаменить(ВыбранноеЗначение, "Заказ на производство", "Заказ");
	Если ИспользоватьРезервированиеЗапасов Тогда
		УстановитьМеткуИОтборСписка("ЗаказНаПроизводствоОснование", Элемент.Родитель.Имя, ВыбранноеЗначение, ПредставлениеДокумента);
	Иначе
		УстановитьМеткуИОтборСписка("ДокументОснование", Элемент.Родитель.Имя, ВыбранноеЗначение, ПредставлениеДокумента);
	КонецЕсли; 
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборЗаказПокупателяОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьНестандартныеОтборы("ЗаказПокупателя", ВыбранноеЗначение, Элемент.Родитель.Имя);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОперацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ВидОперации", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Ответственный", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСкладОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьНестандартныеОтборы("СтруктурнаяЕдиницаРезерв", ВыбранноеЗначение, Элемент.Родитель.Имя);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	ЗаполнениеОбъектовУНФКлиент.ПоказатьВыборШаблонаДляСозданияДокументаИзСписка(
	"Документ.ЗаказНаПроизводство", Список.КомпоновщикНастроек.Настройки.Отбор.Элементы, Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаказНаПроизводство(Команда)
	
	МассивЗаказов = Элементы.СписокЗаказыПокупателей.ВыделенныеСтроки;
	
	Если МассивЗаказов.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = ПроверитьКлючевыеРеквизитыЗаказов(МассивЗаказов);
	Если СтруктураДанных.СформироватьНесколькоЗаказов Тогда

		ТекстСообщения = НСтр(
			"ru = 'Заказы отличаются данными (%ПредставлениеДанных%) шапки документов. Сформировать несколько заказов на производство?'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредставлениеДанных%", СтруктураДанных.ПредставлениеДанных);

		ПоказатьВопрос(Новый ОписаниеОповещения("СоздатьЗаказНаПроизводствоЗавершение", ЭтотОбъект,
			Новый Структура("МассивЗаказов", МассивЗаказов)), ТекстСообщения, РежимДиалогаВопрос.ДаНет, 0);

	Иначе
		
		СтруктураЗаполнения = Новый Структура();
		СтруктураЗаполнения.Вставить("МассивЗаказовПокупателей", МассивЗаказов);
		ОткрытьФорму("Документ.ЗаказНаПроизводство.ФормаОбъекта", Новый Структура("Основание", СтруктураЗаполнения));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаказНаПроизводствоЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	МассивЗаказов = ДополнительныеПараметры.МассивЗаказов;
	
	Ответ = Результат;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		МассивЗаказовНаПроизводство = СформироватьЗаказыНаПроизводствоИЗаписать(МассивЗаказов);
		Текст = НСтр("ru='Создание:'");
		Для каждого СтрокаЗаказНаПроизводство Из МассивЗаказовНаПроизводство Цикл
			
			ПоказатьОповещениеПользователя(Текст, ПолучитьНавигационнуюСсылку(СтрокаЗаказНаПроизводство),
				СтрокаЗаказНаПроизводство, БиблиотекаКартинок.Информация32);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ТекШтрихкод = "";
	
	ОбработкаЗавершения = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект,
		Новый Структура("ТекШтрихкод", ТекШтрихкод));
	
	#Если МобильныйКлиент Тогда
	ОткрытьФорму("ОбщаяФорма.ФормаПоискаПоШтрихкоду", , , , , , ОбработкаЗавершения);
	#Иначе
	ПоказатьВводЗначения(ОбработкаЗавершения, ТекШтрихкод, НСтр("ru = 'Введите штрихкод'"));
	#КонецЕсли

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеПоЦветамСостоянийСервер()
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеПоЦветамСостояний(
		Список.КомпоновщикНастроек.Настройки.УсловноеОформление,
		Метаданные.Справочники.СостоянияЗаказовНаПроизводство.ПолноеИмя());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеИОбновитьКомандыИзмененияСостояний()
	
	УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	ОбновитьКомандыИзмененияСостояний();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборТекущиеДела()
	
	Если НЕ Параметры.Свойство("ТекущиеДела") Тогда
		Возврат;
	КонецЕсли;
	
	АвтоЗаголовок = Ложь;
	Заголовок = НСтр("ru='Заказы на производство'");
	
	СотрудникиПользователя = РегистрыСведений.СотрудникиПользователя.ПолучитьСотрудниковПользователя();
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Проведен", Истина);
	
	УстановитьМеткуИОтборСписка(
		"ВариантЗавершения",
		Элементы.ОтборЗавершениеЗаказа.Родитель.Имя,
		ПредопределенноеЗначение("Перечисление.ВариантыЗавершенияЗаказа.ПустаяСсылка"), // В текущих делах все заказы Не завершенные
		Элементы.ОтборЗавершениеЗаказа.СписокВыбора.НайтиПоЗначению("ПустаяСсылка").Представление);
	
	РаботаСОтборами.ПрикрепитьМеткиОтбораИзМассива(ЭтотОбъект, "Ответственный", "ГруппаОтборОтветственный", СотрудникиПользователя);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, "Ответственный");
	
	Если Параметры.Свойство("ПросроченоВыполнение") Тогда
		
		Заголовок = Заголовок + ": " + НСтр("ru='просрочено выполнение'");
		Список.УстановитьОбязательноеИспользование("ПросроченоВыполнение", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПросроченоВыполнение", Истина);
		
	ИначеЕсли Параметры.Свойство("НаСегодня") Тогда
		
		Заголовок = Заголовок + ": " + НСтр("ru='на сегодня'");
		Список.УстановитьОбязательноеИспользование("НаСегодня", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "НаСегодня", Истина);
		
	ИначеЕсли Параметры.Свойство("НеЗавершенные") Тогда
		
		Заголовок = Заголовок + ": " + НСтр("ru='не завершенные'");
		
	КонецЕсли;
	
	ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(ОтборПериод);
	РаботаСОтборами.ОбновитьЭлементыМеток(ЭтотОбъект);
	
КонецПроцедуры

// Функция проверяет отличие ключевых реквизитов.
//
&НаСервере
Функция ПроверитьКлючевыеРеквизитыЗаказов(МассивЗаказов)
	
	СтруктураДанных = Новый Структура();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Организация) КАК КоличествоОрганизация,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.ВидОперации) КАК КоличествоВидОперации
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателяШапка
	|ГДЕ
	|	ЗаказПокупателяШапка.Ссылка В(&МассивЗаказов)
	|
	|ИМЕЮЩИЕ
	|	(КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Организация) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.ВидОперации) > 1)";
	
	Запрос.УстановитьПараметр("МассивЗаказов", МассивЗаказов);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		СтруктураДанных.Вставить("СформироватьНесколькоЗаказов", Ложь);
		СтруктураДанных.Вставить("ПредставлениеДанных", "");
	Иначе
		СтруктураДанных.Вставить("СформироватьНесколькоЗаказов", Истина);
		ПредставлениеДанных = "";
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.КоличествоОрганизация > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "", ", ") + "Организация";
			КонецЕсли;
			
			Если Выборка.КоличествоВидОперации > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "", ", ") + "Вид операции";
			КонецЕсли;
			
		КонецЦикла;
		
		СтруктураДанных.Вставить("ПредставлениеДанных", ПредставлениеДанных);
		
	КонецЕсли;
	
	Возврат СтруктураДанных;
	
КонецФункции // ПроверитьКлючевыеРеквизитыЗаказов()

// Функция вызывает обработку заполнения документа по основанию.
//
&НаСервере
Функция СформироватьЗаказыНаПроизводствоИЗаписать(МассивЗаказов)
	
	МассивЗНП = Новый Массив();
	Для каждого СтрокаЗаказПокупателя Из МассивЗаказов Цикл
		
		НовыйДокументЗНП = Документы.ЗаказНаПроизводство.СоздатьДокумент();
		НовыйДокументЗНП.Дата = ТекущаяДатаСеанса();
		НовыйДокументЗНП.Заполнить(СтрокаЗаказПокупателя);
		НовыйДокументЗНП.Записать();
		МассивЗНП.Добавить(НовыйДокументЗНП.Ссылка);
		
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
	Возврат МассивЗНП;
	
КонецФункции // СформироватьДокументыПродажИЗаписать()

#Область Отборы

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗагрузкуНестандартныхОтборов()
	
	ИменаНестандартныхПолей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("ЗаказПокупателя, СтруктурнаяЕдиницаРезерв");
	Для каждого ИмяПоляКД Из ИменаНестандартныхПолей Цикл
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.КомпоновщикНастроек.Настройки.Отбор, СокрЛП(ИмяПоляКД));
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, СокрЛП(ИмяПоляКД));
		ОбновитьНестандартныеОтборы(СокрЛП(ИмяПоляКД));
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНестандартныеОтборы(ИмяПоляОтбора, ВыбранноеЗначение = Неопределено, ИмяГруппы = "")
	
	Если ВыбранноеЗначение<>Неопределено Тогда
		ПредставлениеЗначения = Строка(ВыбранноеЗначение);
		Если ИмяПоляОтбора="ЗаказПокупателя" Тогда
			ПредставлениеЗначения = СтрЗаменить(ПредставлениеЗначения, "Заказ покупателя", "Заказ");
		КонецЕсли; 
		РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбора, ИмяГруппы, ВыбранноеЗначение, ПредставлениеЗначения);
	КонецЕсли; 
	
	Значения = Новый СписокЗначений;
	Для каждого стр Из ДанныеМеток Цикл
		Если стр.ИмяПоляОтбора = ИмяПоляОтбора Тогда
			Если ТипЗнч(стр.Метка)=Тип("СписокЗначений") Тогда
				Для каждого значениеСписка Из стр.Метка Цикл
				    Значения.Добавить(значениеСписка.Значение);
				КонецЦикла; 
			Иначе	
				Значения.Добавить(стр.Метка);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ИспользованиеОтбора = Значения.Количество()>0;
	
	ГруппаОтборов = Неопределено; 
	Для каждого ЭлементОтбора Из Список.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если ТипЗнч(ЭлементОтбора)=Тип("ГруппаЭлементовОтбораКомпоновкиДанных") И ЭлементОтбора.Представление=ИмяПоляОтбора Тогда
			ГруппаОтборов = ЭлементОтбора;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	Если ГруппаОтборов=Неопределено Тогда
		ГруппаОтборов = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтборов.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		ГруппаОтборов.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ГруппаОтборов.Представление = ИмяПоляОтбора;
		Если ИмяПоляОтбора="ЗаказПокупателя" Тогда
			ИменаПолей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("ЗаказПокупателя,Продукция.ЗаказПокупателя,Запасы.ЗаказПокупателя");
			Для каждого ИмяПоля Из ИменаПолей Цикл
				ЭлементОтбора = ГруппаОтборов.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
				ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
				ЭлементОтбора.Использование = Истина;
			КонецЦикла; 
		ИначеЕсли ИмяПоляОтбора="СтруктурнаяЕдиницаРезерв" Тогда
			// Отсекаются дополнительно документы с незаполненным заказом покупателя
			// В таких случаях склад не отображается на форме
			ГруппаОтборов.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
			ИменаПолей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("СтруктурнаяЕдиницаРезерв,Продукция.СтруктурнаяЕдиница,Запасы.СтруктурнаяЕдиница");
			ВложеннаяГруппа = ГруппаОтборов.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ВложеннаяГруппа.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
			ВложеннаяГруппа.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			Для каждого ИмяПоля Из ИменаПолей Цикл
				ЭлементОтбора = ВложеннаяГруппа.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
				ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
				ЭлементОтбора.Использование = Истина;
			КонецЦикла;
			ЭлементОтбора = ГруппаОтборов.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗаказПокупателя");
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
			ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			ЭлементОтбора.Использование = Истина;
			ЭлементОтбора.ПравоеЗначение = Документы.ЗаказПокупателя.ПустаяСсылка();
		Иначе
			Возврат;
		КонецЕсли; 
	КонецЕсли;
	ГруппаОтборов.Использование = ИспользованиеОтбора;
	Для каждого ЭлементОтбора Из ГруппаОтборов.Элементы Цикл
		Если ТипЗнч(ЭлементОтбора)=Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Для каждого ВложенныйЭлемент Из ЭлементОтбора.Элементы Цикл
				ВложенныйЭлемент.ПравоеЗначение = Значения;
			КонецЦикла;
		ИначеЕсли ИмяПоляОтбора<>"СтруктурнаяЕдиницаРезерв" Тогда 
			ЭлементОтбора.ПравоеЗначение = Значения;
		КонецЕсли; 
	КонецЦикла; 
	
	// МобильныйКлиент
	Если ВыбранноеЗначение=Неопределено Тогда
		РаботаСОтборами.УстановитьЗаголовокПравойПанелиМобильныйКлиент(ЭтотОбъект);
	КонецЕсли; 
	// Конец МобильныйКлиент
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	СтрокаМеток = ДанныеМеток[Число(МеткаИД)];
	ИмяПоляОтбора = СтрокаМеток.ИмяПоляОтбора;
	Если ИмяПоляОтбора="ЗаказПокупателя" ИЛИ ИмяПоляОтбора="СтруктурнаяЕдиницаРезерв" Тогда
		СписокГруппФормыДляУдаленияДобавленныхЭлементов = РаботаСОтборами.ПолучитьСписокИмяГруппыРодителя(ДанныеМеток);
		ДанныеМеток.Удалить(СтрокаМеток);
		РаботаСОтборами.ОбновитьЭлементыМеток(ЭтотОбъект, СписокГруппФормыДляУдаленияДобавленныхЭлементов);
		ОбновитьНестандартныеОтборы(ИмяПоляОтбора);
	Иначе
		РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтборы(Команда)
	
	ИмяРеквизитаСписка = "Список";
	ИмяТЧДанныеМеток = "ДанныеМеток";
	ИмяТЧДанныеОтборов = "ДанныеОтборов";
	ИмяГруппыОтборов = "ГруппаОтборы";
	ИмяПредопределенныеОтборыПоУмолчанию = "ПредопределенныеОтборыПоУмолчанию";
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяРеквизитаСписка", ИмяРеквизитаСписка);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеМеток", ИмяТЧДанныеМеток);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеОтборов", ИмяТЧДанныеОтборов);
	ДополнительныеПараметры.Вставить("ИмяГруппыОтборов", ИмяГруппыОтборов);
	ДополнительныеПараметры.Вставить("ИмяПредопределенныеОтборыПоУмолчанию", ИмяПредопределенныеОтборыПоУмолчанию);
	
	РаботаСОтборамиКлиент.НастроитьОтборыНажатие(ЭтотОбъект, ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры), ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры)
	
	Возврат РаботаСОтборами.ПараметрыДляОткрытияФормыСНастройкамиОтборов(ЭтотОбъект, ДополнительныеПараметры);
	
КонецФункции

&НаКлиенте
Процедура НастройкаОтборовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаОтборовЗавершениеНаСервере(Результат.АдресВыбранныеОтборы, Результат.АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура НастройкаОтборовЗавершениеНаСервере(АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры)
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ИмяРеквизитаСписка = "Список";
		ИмяТЧДанныеМеток = "ДанныеМеток";
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	Иначе
		ИмяРеквизитаСписка = ДополнительныеПараметры.ИмяРеквизитаСписка;
		ИмяТЧДанныеМеток = ДополнительныеПараметры.ИмяТЧДанныеМеток;
		ИмяТЧДанныеОтборов = ДополнительныеПараметры.ИмяТЧДанныеОтборов;
	КонецЕсли;
	
	РаботаСОтборами.НастройкаОтборовЗавершение(ЭтотОбъект, АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОтборПриИзменении(Элемент)
	
	Подключаемый_ОтборПриИзмененииНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборПриИзмененииНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборПриИзменении(ЭтотОбъект, ЭлементИмя, ЭлементРодительИмя);
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОтборОчистка(Элемент)
	
	Подключаемый_ОтборОчисткаНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборОчисткаНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборОчистка(ЭтотОбъект, ЭлементИмя);

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьОтборов()
	
	Элементы.ОтборЗаказПокупателя.Видимость = ИспользоватьРезервированиеЗапасов;
	Элементы.ГруппаОтборЗаказПокупателя.Видимость = ИспользоватьРезервированиеЗапасов;
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьВсеОтборы(Команда)
	РаботаСОтборамиКлиент.СброситьОтборПоПериоду(ЭтотОбъект, "Список", "Дата");
	СброситьВсеМеткиОтбораНаСервере();
КонецПроцедуры

&НаСервере
Процедура СброситьВсеМеткиОтбораНаСервере()
	РаботаСОтборами.УдалитьМеткиОтбораСервер(ЭтотОбъект, Список);
КонецПроцедуры

#КонецОбласти

#Область ИзменениеСостоянийЗаказов

&НаСервере
Процедура ОбновитьКомандыИзмененияСостояний()
	
	УдаляемыеЭлементы = Новый Массив;
	
	Если Элементы.СписокКонтекстноеМенюУстановитьСостояние.ПодчиненныеЭлементы.Количество() <> 0 Тогда
		Для ИндексГруппы = 0 По Элементы.СписокКонтекстноеМенюУстановитьСостояние.ПодчиненныеЭлементы.Количество() - 1 Цикл

			Если Элементы.СписокКонтекстноеМенюУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы].Имя = "УстановитьСостояниеЗавершенУспешно"
				 Или Элементы.СписокКонтекстноеМенюУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы].Имя = "УстановитьСостояниеОтменен"
				 Или Элементы.СписокКонтекстноеМенюУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы].Имя = "УстановитьСостояниеЗавершен" Тогда
				Продолжить;
			КонецЕсли;
			УдаляемыеЭлементы.Добавить(
				Элементы.СписокКонтекстноеМенюУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы]);

		КонецЦикла;

		Если Элементы.ФормаУстановитьСостояние.ПодчиненныеЭлементы.Количество() <> 0 Тогда
			Для ИндексГруппы = 0 По Элементы.ФормаУстановитьСостояние.ПодчиненныеЭлементы.Количество() - 1 Цикл
				Если Элементы.ФормаУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы].Имя = "УстановитьСостояниеЗавершенФорма"
					 Или Элементы.ФормаУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы].Имя = "УстановитьСостояниеЗавершенУспешноФорма"
					 Или Элементы.ФормаУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы].Имя = "УстановитьСостояниеОтмененФорма" Тогда
					Продолжить;
				КонецЕсли;
				УдаляемыеЭлементы.Добавить(Элементы.ФормаУстановитьСостояние.ПодчиненныеЭлементы[ИндексГруппы]);
			КонецЦикла;
		КонецЕсли;

		Для Каждого УдаляемыйЭлемент Из УдаляемыеЭлементы Цикл
			Элементы.Удалить(УдаляемыйЭлемент);
		КонецЦикла;

	КонецЕсли;
	
	СостоянияЗаказовНаПроизводство.Очистить();
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияЗаказовНаПроизводство.Ссылка КАК Ссылка,
	|	СостоянияЗаказовНаПроизводство.Наименование КАК Наименование
	|ИЗ
	|	Справочник.СостоянияЗаказовНаПроизводство КАК СостоянияЗаказовНаПроизводство
	|ГДЕ
	|	СостоянияЗаказовНаПроизводство.ПометкаУдаления = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	СостоянияЗаказовНаПроизводство.РеквизитДопУпорядочивания";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	НомерСостояния = 1;
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Ссылка = Справочники.СостоянияЗаказовНаПроизводство.Завершен Тогда
			Продолжить;
		КонецЕсли;
		
		СостояниеВТаблице = СостоянияЗаказовНаПроизводство.НайтиСтроки(Новый Структура("Состояние", Выборка.Ссылка));
		
		Если СостояниеВТаблице.Количество() = 0 Тогда
			НовоеСостояние = СостоянияЗаказовНаПроизводство.Добавить();
			НовоеСостояние.Состояние = Выборка.Ссылка;
		Иначе 
			НовоеСостояние = СостояниеВТаблице[0];
		КонецЕсли;
		
		КнопкаУстановитьСостояниеЗаказаФорма = Элементы.Добавить("Состояние_" + Строка(
			СостоянияЗаказовНаПроизводство.Индекс(НовоеСостояние)) + "Форма", Тип("КнопкаФормы"),
			Элементы.ФормаУстановитьСостояние);
		КнопкаУстановитьСостояниеЗаказаФорма.Заголовок = Строка(НомерСостояния) + ". " + Строка(Выборка.Ссылка);
		КнопкаУстановитьСостояниеЗаказаФорма.ТолькоВоВсехДействиях = Истина;

		КнопкаУстановитьСостояниеЗаказаСписок = Элементы.Добавить("Состояние_" + Строка(
			СостоянияЗаказовНаПроизводство.Индекс(НовоеСостояние)), Тип("КнопкаФормы"),
			Элементы.СписокКонтекстноеМенюУстановитьСостояние);
		КнопкаУстановитьСостояниеЗаказаСписок.Заголовок = Строка(НомерСостояния) + ". " + Строка(Выборка.Ссылка);
		
		НазваниеКоманды = "Состояние_" +  Строка(СостоянияЗаказовНаПроизводство.Индекс(НовоеСостояние));
		
		Если Команды.Найти(НазваниеКоманды) <> Неопределено Тогда
			КомандаУстановитьСостояниеЗаказа = Команды[НазваниеКоманды];
		Иначе
			КомандаУстановитьСостояниеЗаказа = Команды.Добавить(НазваниеКоманды);
		КонецЕсли;
		
		КомандаУстановитьСостояниеЗаказа.Действие = "УстановитьСостояниеЗаказа";
		КомандаУстановитьСостояниеЗаказа.Заголовок = Выборка.Наименование;
		
		// МобильныйКлиент
		КомандаУстановитьСостояниеЗаказа.ИспользованиеТекущейСтроки = ИспользованиеТекущейСтроки.Использует;
		// Конец МобильныйКлиент
		
		КнопкаУстановитьСостояниеЗаказаСписок.ИмяКоманды = КомандаУстановитьСостояниеЗаказа.Имя;
		КнопкаУстановитьСостояниеЗаказаФорма.ИмяКоманды = КомандаУстановитьСостояниеЗаказа.Имя;
		
		НомерСостояния = НомерСостояния + 1;
		
	КонецЦикла;
	
	Элементы.Переместить(Элементы["УстановитьСостояниеЗавершен"],Элементы["СписокКонтекстноеМенюУстановитьСостояние"]);
	Элементы.Переместить(Элементы["УстановитьСостояниеЗавершенФорма"],Элементы["ФормаУстановитьСостояние"]);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСостояниеЗаказа(Команда)
	
	Заказы = Элементы.Список.ВыделенныеСтроки;
	
	Если ТипЗнч(Заказы) <> Тип("Массив") Или Заказы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКоманды = Команда.Имя;
		
	Если Заказы.Количество() = 1 Тогда
		УстановитьСостояниеЗаказаСервер(ИмяКоманды, Заказы);
		
		Если Заказы.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(НСтр("ru='Изменение:'"),
			ПолучитьНавигационнуюСсылку(Заказы[0]),
			СтрШаблон(НСтр("ru='%1'"),Строка(Заказы[0])),
			БиблиотекаКартинок.Информация32);
		Элементы.Список.Обновить();
		Оповестить("ИзменениеСостояния_ЗаказНаПроизводство", Заказы);
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru='Изменение состояния'"), 49);	
	УстановитьСостояниеЗаказаСервер(ИмяКоманды, Заказы);
	Состояние(НСтр("ru='Изменение состояния'"), 100);
	
	Элементы.Список.Обновить();
	Оповестить("ИзменениеСостояния_ЗаказНаПроизводство", Заказы);
	
	ПоказатьОповещениеПользователя(СтрШаблон(НСтр("ru='Изменение (%1)'"),
		КоличествоИзмененныхЗаказов),,
		НСтр("ru='Заказы на производство'"),БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеЗаказаСервер(ИмяКоманды, Заказы, ВариантЗавершения = Неопределено)
	
	Если ИмяКоманды = "СостояниеЗавершенУспешно" Тогда
		СсылкаНаСостояние = Справочники.СостоянияЗаказовНаПроизводство.Завершен;
		ВариантЗавершения = Перечисления.ВариантыЗавершенияЗаказа.Успешно;
	ИначеЕсли ИмяКоманды = "СостояниеОтменен" Тогда
		СсылкаНаСостояние = Справочники.СостоянияЗаказовНаПроизводство.Завершен;
		ВариантЗавершения = Перечисления.ВариантыЗавершенияЗаказа.Отменен;
	Иначе
		ИндексСостояния = Число(Сред(ИмяКоманды,11,СтрДлина(ИмяКоманды)));
		СсылкаНаСостояние = СостоянияЗаказовНаПроизводство[ИндексСостояния].Состояние;
	КонецЕсли;
		
	КоличествоИзмененныхЗаказов = 0;
	ИзмененныеЗаказы = Новый Массив;
	НеизмененныеЗаказы = Новый Массив;
	
	Для Каждого Заказ Из Заказы Цикл
		
		Если Заказ.СостояниеЗаказа = СсылкаНаСостояние И СсылкаНаСостояние <> Справочники.СостоянияЗаказовНаПроизводство.Завершен Тогда
			НеизмененныеЗаказы.Добавить(Заказ);
			Продолжить;
		КонецЕсли;
		
		Если Заказ.СостояниеЗаказа = СсылкаНаСостояние И СсылкаНаСостояние = Справочники.СостоянияЗаказовНаПроизводство.Завершен
			И (ЗначениеЗаполнено(Заказ.ВариантЗавершения) И Заказ.ВариантЗавершения = ВариантЗавершения) Тогда
			НеизмененныеЗаказы.Добавить(Заказ);
			Продолжить;
		КонецЕсли;
		
		Попытка
			Документы.ЗаказНаПроизводство.ИзменитьСостояниеЗаказа(Заказ, СсылкаНаСостояние, ВариантЗавершения);
			ИзмененныеЗаказы.Добавить(Заказ);
		Исключение
			
			ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), Заказ);
			НеизмененныеЗаказы.Добавить(Заказ);
			Продолжить;
			
		КонецПопытки;
		
		КоличествоИзмененныхЗаказов = КоличествоИзмененныхЗаказов + 1;
		
	КонецЦикла;
	
	Для Каждого НеизмененныйЗаказ Из НеизмененныеЗаказы Цикл
		ИндексЗаказа = Заказы.Найти(НеизмененныйЗаказ);
		Если ИндексЗаказа = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Заказы.Удалить(ИндексЗаказа);
		
	КонецЦикла;
	
	АссистентУправления.ВыполнитьТекущиеЗадачиСейчасВФоне(ИзмененныеЗаказы);
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(Результат, Параметры) Экспорт

	Если Результат = Неопределено Тогда
		ТекШтрихкод = СокрЛП(Параметры.ТекШтрихкод);
	Иначе
		ТекШтрихкод = СокрЛП(Результат);
	КонецЕсли;
		
	Если ПустаяСтрока(ТекШтрихкод) Тогда
		Возврат;
	КонецЕсли;
	
	Данные = Новый Структура;
	Данные.Вставить("Штрихкод", ТекШтрихкод);
	Данные.Вставить("Количество", 1);
	
	ОбработатьШтрихкоды(Данные);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	Данные.Штрихкод = ШтрихкодированиеУНФКлиент.ПредставлениеШтрихкодаБезРазделителяGS1(Данные.Штрихкод);
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если ЗначениеЗаполнено(МассивСсылок)  Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив;
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаказНаПроизводство.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

#КонецОбласти

#Область ЗамерыПроизводительности

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеФормы"
		+ РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеФормы"
		+ РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// ИнтернетПоддержкаПользователей.Новости
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, "ПриОткрытии");
	
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.Новости

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти
