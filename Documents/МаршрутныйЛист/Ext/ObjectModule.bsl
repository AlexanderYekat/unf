﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(СлужбаДоставки) И НЕ ЗначениеЗаполнено(Курьер)  Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ЭтоДоставкаСобственнымиСилами() Тогда
		ИсключитьРеквизитИзПроверки("СпособОтгрузки", ПроверяемыеРеквизиты);
		ИсключитьРеквизитИзПроверки("Склад", ПроверяемыеРеквизиты);
		ИсключитьРеквизитИзПроверки("АдресОтправки", ПроверяемыеРеквизиты);
	ИначеЕсли ЭтоЗаборКурьеромСлужбыДоставки() Тогда 
		ИсключитьРеквизитИзПроверки("Курьер", ПроверяемыеРеквизиты);
	ИначеЕсли ЭтоСамоПривозНаСкладСлужбыДоставки() Тогда 
		ИсключитьРеквизитИзПроверки("Склад", ПроверяемыеРеквизиты);
		ИсключитьРеквизитИзПроверки("АдресОтправки", ПроверяемыеРеквизиты);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если Заказы.Количество()=0 Тогда
		ОбщегоНазначения.СообщитьПользователю(
		НСтр("ru = 'Укажите отгружаемые заказы'"),
		Ссылка,
		"Заказы",,
		Отказ);
	КонецЕсли; 
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	ОбновитьДанныеЗаказов(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
КонецПроцедуры
 
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОбновитьДанныеЗаказов(Отказ, Ложь);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДаннымиСобытияУНФ.ПропуститьДозаполнениеДокумента(ЭтотОбъект, РежимЗаписи) Тогда
		Возврат;
	КонецЕсли;
	
	Если Заказы.Количество()>0 
		И НЕ Документы.МаршрутныйЛист.ПроверитьДоступностьЗаказов(ЭтотОбъект) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Недостаточно прав для изменения документа'"),,,, Отказ);
		Возврат;
	КонецЕсли; 	
	
	Если НЕ ЭтоНовый() Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	МаршрутныйЛистЗаказы.Заказ КАК Заказ
		|ИЗ
		|	Документ.МаршрутныйЛист.Заказы КАК МаршрутныйЛистЗаказы
		|ГДЕ
		|	МаршрутныйЛистЗаказы.Ссылка = &Ссылка";
		ЗаказыДоИзменения = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Заказ");
	Иначе
		ЗаказыДоИзменения = Новый Массив;
	КонецЕсли; 
	
	ДополнительныеСвойства.Вставить("ЗаказыДоИзменения", ЗаказыДоИзменения);
	
	// Изменение состояния заказов при отмене отгрузки
	Для каждого Заказ Из ЗаказыДоИзменения Цикл
		Если Заказы.Найти(Заказ, "Заказ") <> Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		НовоеСостояние = СостояниеОжидаетОтгрузки(Заказ, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли; 
		УстановитьСостояниеЗаказа(Заказ, НовоеСостояние);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	Если ДополнительныеСвойства.Свойство("ЗаказыДоИзменения") Тогда
		ЗаказыДоИзменения = ДополнительныеСвойства.ЗаказыДоИзменения;
		Если НЕ ТипЗнч(ЗаказыДоИзменения)=Тип("Массив") Тогда
			ЗаказыДоИзменения = Новый Массив;
		КонецЕсли; 
	Иначе
		ЗаказыДоИзменения = Новый Массив;
	КонецЕсли;
	
	ОбсужденияЗаказов = Новый Соответствие;
	Для каждого СтрокаТабличнойЧасти Из Заказы Цикл
		Если ЗаказыДоИзменения.Найти(СтрокаТабличнойЧасти.Заказ) = Неопределено Тогда
			Сообщение = "";
			Префикс = НСтр("ru = 'Использован в: '") + ПолучитьНавигационнуюСсылку(Ссылка);
			ОбсужденияУНФ.ДобавитьСообщениеОбИзмененииРеквизита(Сообщение, Префикс);
			ОбсужденияЗаказов.Вставить(СтрокаТабличнойЧасти.Заказ, Сообщение);
		КонецЕсли; 
	КонецЦикла;
	ДополнительныеСвойства.Вставить("ОбсужденияЗаказов", ОбсужденияЗаказов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоДоставкаСобственнымиСилами()
	
	Возврат СлужбаДоставки = Справочники.СлужбыДоставки.ДоставкаСобственнымиСилами;
	
КонецФункции

Функция ЭтоЗаборКурьеромСлужбыДоставки()
	
	Возврат СпособОтгрузки = Перечисления.СпособыОтгрузки.ПередатьКурьеруЕдиногоСклада
	Или СпособОтгрузки = Перечисления.СпособыОтгрузки.ПередатьКурьеруСлужбыДоставки;
	
КонецФункции

Функция ЭтоСамоПривозНаСкладСлужбыДоставки()
	
	Возврат СпособОтгрузки = Перечисления.СпособыОтгрузки.СамостоятельноПривезтиНаЕдиныйСклад
	Или СпособОтгрузки = Перечисления.СпособыОтгрузки.СамостоятельноПривезтиНаСкладСлужбыДоставки;
	
КонецФункции

Процедура ОбновитьДанныеЗаказов(Отказ, Проведение = Истина)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ОбсужденияЗаказов = Неопределено;
	ДополнительныеСвойства.Свойство("ОбсужденияЗаказов", ОбсужденияЗаказов);
	Если ТипЗнч(ОбсужденияЗаказов)<>Тип("Соответствие") Тогда
		ОбсужденияЗаказов = Новый Соответствие;
	КонецЕсли; 
	
	НесколькоВидовЗаказов = ПолучитьФункциональнуюОпцию("ИспользоватьВидыЗаказовПокупателей");

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаЗаказов", Заказы.Выгрузить());
	Запрос.УстановитьПараметр("СлужбаДоставки", СлужбаДоставки);
	Запрос.УстановитьПараметр("Курьер", Курьер);
	Запрос.УстановитьПараметр("Проведен", Проведение);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫРАЗИТЬ(ТаблицаЗаказов.Заказ КАК Документ.ЗаказПокупателя) КАК Заказ,
	|	ВЫРАЗИТЬ(ТаблицаЗаказов.РасходнаяНакладная КАК Документ.РасходнаяНакладная) КАК РасходнаяНакладная,
	|	ТаблицаЗаказов.Доставлен КАК Доставлен
	|ПОМЕСТИТЬ ТаблицаЗаказов
	|ИЗ
	|	&ТаблицаЗаказов КАК ТаблицаЗаказов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗаказов.Заказ КАК Заказ,
	|	ЗаказПокупателя.ВидЗаказа КАК ВидЗаказа,
	|	ЗаказПокупателя.СостояниеЗаказа КАК СостояниеЗаказа,
	|	ЗаказПокупателя.СлужбаДоставки КАК СлужбаДоставки,
	|	ЗаказПокупателя.Курьер КАК Курьер,
	|	МАКСИМУМ(ТаблицаЗаказов.Доставлен) КАК Доставлен
	|ПОМЕСТИТЬ ЗаказыСвернуто
	|ИЗ
	|	ТаблицаЗаказов КАК ТаблицаЗаказов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя КАК ЗаказПокупателя
	|		ПО ТаблицаЗаказов.Заказ = ЗаказПокупателя.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаЗаказов.Заказ,
	|	ЗаказПокупателя.ВидЗаказа,
	|	ЗаказПокупателя.СостояниеЗаказа,
	|	ЗаказПокупателя.СлужбаДоставки,
	|	ЗаказПокупателя.Курьер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказыСвернуто.Заказ КАК Заказ,
	|	ВЫБОР
	|		КОГДА &Проведен
	|				И ЕСТЬNULL(ЗаказыПокупателейОстатки.КоличествоОстаток, 0) = 0
	|				И ЗаказыСвернуто.Доставлен
	|			ТОГДА ЗаказыСвернуто.ВидЗаказа.СостояниеДоставлен
	|		КОГДА &Проведен
	|				И ЕСТЬNULL(ЗаказыПокупателейОстатки.КоличествоОстаток, 0) = 0
	|				И НЕ ЗаказыСвернуто.Доставлен
	|			ТОГДА ЗаказыСвернуто.ВидЗаказа.СостояниеОтгружен
	|		КОГДА НЕ &Проведен
	|				ИЛИ ЕСТЬNULL(ЗаказыПокупателейОстатки.КоличествоОстаток, 0) > 0
	|			ТОГДА ЗаказыСвернуто.ВидЗаказа.СостояниеОжидаетОтгрузки
	|	КОНЕЦ КАК НовоеСостояние,
	|	ЗаказыСвернуто.СостояниеЗаказа <> ЕСТЬNULL(ВЫБОР
	|			КОГДА &Проведен
	|					И ЕСТЬNULL(ЗаказыПокупателейОстатки.КоличествоОстаток, 0) = 0
	|					И ЗаказыСвернуто.Доставлен
	|				ТОГДА ЗаказыСвернуто.ВидЗаказа.СостояниеДоставлен
	|			КОГДА &Проведен
	|					И ЕСТЬNULL(ЗаказыПокупателейОстатки.КоличествоОстаток, 0) = 0
	|					И НЕ ЗаказыСвернуто.Доставлен
	|				ТОГДА ЗаказыСвернуто.ВидЗаказа.СостояниеОтгружен
	|			КОГДА НЕ &Проведен
	|					ИЛИ ЕСТЬNULL(ЗаказыПокупателейОстатки.КоличествоОстаток, 0) > 0
	|				ТОГДА ЗаказыСвернуто.ВидЗаказа.СостояниеОжидаетОтгрузки
	|			ИНАЧЕ ЗаказыСвернуто.СостояниеЗаказа
	|		КОНЕЦ, ЗаказыСвернуто.СостояниеЗаказа) КАК ОбновитьСостояние,
	|	ВЫБОР
	|		КОГДА ЗаказыСвернуто.СлужбаДоставки <> &СлужбаДоставки
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОбновитьСлужбуДоставки,
	|	ВЫБОР
	|		КОГДА ЗаказыСвернуто.Курьер <> &Курьер
	|				И &Курьер <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОбновитьКурьера
	|ПОМЕСТИТЬ Действия
	|ИЗ
	|	ЗаказыСвернуто КАК ЗаказыСвернуто
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПокупателей.Остатки(
	|				,
	|				ЗаказПокупателя В
	|					(ВЫБРАТЬ
	|						ТаблицаЗаказов.Заказ
	|					ИЗ
	|						ТаблицаЗаказов)) КАК ЗаказыПокупателейОстатки
	|		ПО ЗаказыСвернуто.Заказ = ЗаказыПокупателейОстатки.ЗаказПокупателя
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаЗаказов.Заказ КАК Заказ,
	|	ТаблицаЗаказов.РасходнаяНакладная КАК РасходнаяНакладная,
	|	МаршрутныйЛистЗаказы.Ссылка КАК МаршрутныйЛист
	|ИЗ
	|	ТаблицаЗаказов КАК ТаблицаЗаказов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛист.Заказы КАК МаршрутныйЛистЗаказы
	|		ПО ТаблицаЗаказов.Заказ = МаршрутныйЛистЗаказы.Заказ
	|			И ТаблицаЗаказов.РасходнаяНакладная = МаршрутныйЛистЗаказы.РасходнаяНакладная
	|			И (МаршрутныйЛистЗаказы.Ссылка <> &Ссылка)
	|			И (МаршрутныйЛистЗаказы.Ссылка.Проведен)
	|ГДЕ
	|	НЕ МаршрутныйЛистЗаказы.Ссылка ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Действия.Заказ КАК Заказ,
	|	Действия.НовоеСостояние КАК НовоеСостояние,
	|	Действия.ОбновитьСостояние КАК ОбновитьСостояние,
	|	Действия.ОбновитьСлужбуДоставки КАК ОбновитьСлужбуДоставки,
	|	Действия.ОбновитьКурьера КАК ОбновитьКурьера
	|ИЗ
	|	Действия КАК Действия
	|ГДЕ
	|	(Действия.ОбновитьСлужбуДоставки
	|			ИЛИ Действия.ОбновитьКурьера
	|			ИЛИ Действия.ОбновитьСостояние)";
	Результат = Запрос.ВыполнитьПакет();
	Ошибки = Результат[3].Выбрать();
	Если НЕ Ошибки.Количество()=0 Тогда
		Пока Ошибки.Следующий() Цикл
			ОбщегоНазначения.СообщитьПользователю(
			СтрШаблон(НСтр("ru = '%1 уже отгружен документом %2'"), Ошибки.Заказ, Ошибки.МаршрутныйЛист),
			Ошибки.МаршрутныйЛист,
			"Заказы", ,
			Отказ);
		КонецЦикла; 
		Возврат;
	КонецЕсли; 
	Выборка = Результат[4].Выбрать();
	ВыведенныеВидыЗаказов = Новый Массив;
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();
		Попытка
			ЗаказОбъект = Выборка.Заказ.ПолучитьОбъект();
			ЗаказОбъект.Заблокировать();
			Сообщение = ОбсужденияЗаказов.Получить(Выборка.Заказ);
			// Состояние заказа
			Если Выборка.ОбновитьСостояние Тогда
				Если НЕ ЗначениеЗаполнено(Выборка.НовоеСостояние) Тогда
					// Не настроены состояния заказов
					Если НесколькоВидовЗаказов Тогда
						Если ВыведенныеВидыЗаказов.Найти(ЗаказОбъект.ВидЗаказа)=Неопределено Тогда
							ОбщегоНазначения.СообщитьПользователю(
							СтрШаблон(НСтр("ru = 'Не задано состояние %1 заказа для вида %2'"),
							?(Проведение, НСтр("ru = 'отгрузки'"), НСтр("ru = 'ожидания отгрузки'")),
							ЗаказОбъект.ВидЗаказа),
							ЗаказОбъект.ВидЗаказа,
							?(Проведение, "СостояниеОтгружен", "СостояниеОжидаетОтгрузки"),,
							Отказ);
							ВыведенныеВидыЗаказов.Добавить(ЗаказОбъект.ВидЗаказа);
						КонецЕсли; 
					Иначе
						Если ВыведенныеВидыЗаказов.Найти(Справочники.ВидыЗаказовПокупателей.Основной)=Неопределено Тогда
							ОбщегоНазначения.СообщитьПользователю(
							СтрШаблон(НСтр("ru = 'Не задано состояние %1 заказа'"),
							?(Проведение, НСтр("ru = 'отгрузки'"), НСтр("ru = 'ожидания отгрузки'"))),
							Справочники.ВидыЗаказовПокупателей.Основной,
							?(Проведение, "СостояниеОтгружен", "СостояниеОжидаетОтгрузки"),,
							Отказ);
							ВыведенныеВидыЗаказов.Добавить(Справочники.ВидыЗаказовПокупателей.Основной);
						КонецЕсли; 
					КонецЕсли; 
				Иначе
					Префикс = НСтр("ru = 'Состояние: '");
					ТекстИзменений = ОбсужденияУНФ.ДобавитьСообщениеОбИзмененииРеквизита(ЗаказОбъект.СостояниеЗаказа, Выборка.НовоеСостояние);
					ОбсужденияУНФ.ДобавитьОписаниеИзменений(Сообщение, ТекстИзменений, Префикс+": ");
					ЗаказОбъект.СостояниеЗаказа = Выборка.НовоеСостояние;
					Если Выборка.НовоеСостояние = Справочники.СостоянияЗаказовПокупателей.Завершен Тогда
						ЗаказОбъект.ВариантЗавершения = Перечисления.ВариантыЗавершенияЗаказа.Успешно;
					КонецЕсли; 
				КонецЕсли;
			КонецЕсли;
			// Служба доставки
			Если Выборка.ОбновитьСлужбуДоставки Тогда
				Префикс = НСтр("ru = 'Служба доставки: '");
				ТекстИзменений = ОбсужденияУНФ.ДобавитьСообщениеОбИзмененииРеквизита(ЗаказОбъект.СлужбаДоставки, СлужбаДоставки);
				ОбсужденияУНФ.ДобавитьОписаниеИзменений(Сообщение, ТекстИзменений, Префикс+": ");
				ЗаказОбъект.СлужбаДоставки = СлужбаДоставки;
			КонецЕсли;
			// Курьер
			Если Выборка.ОбновитьКурьера Тогда
				Префикс = НСтр("ru = 'Курьер: '");
				ТекстИзменений = ОбсужденияУНФ.ДобавитьСообщениеОбИзмененииРеквизита(ЗаказОбъект.Курьер, Курьер);
				ОбсужденияУНФ.ДобавитьОписаниеИзменений(Сообщение, ТекстИзменений, Префикс+": ");
				ЗаказОбъект.Курьер = Курьер;
			КонецЕсли;
			Если ЗначениеЗаполнено(Сообщение) Тогда
				ОбсужденияУНФ.ДобавитьСистемноеСообщение(Сообщение, Выборка.Заказ);
				ЗаказОбъект.ДополнительныеСвойства.Вставить("ОбсуждениеЗаписано", Истина);
			КонецЕсли; 
			ЗаказОбъект.Записать(?(ЗаказОбъект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
			ЗафиксироватьТранзакцию();
		Исключение
		    ОтменитьТранзакцию();
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Не удалось изменить состояние заказа %1'"), Выборка.Заказ);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Выборка.Заказ, , , Отказ); 
		КонецПопытки; 
	КонецЦикла; 
	
КонецПроцедуры

Процедура ИсключитьРеквизитИзПроверки(ИмяРеквизита, ПроверяемыеРеквизиты)
	
	Индекс = ПроверяемыеРеквизиты.Найти(ИмяРеквизита);
	Если Индекс<>Неопределено Тогда
		ПроверяемыеРеквизиты.Удалить(Индекс)
	КонецЕсли; 
	
КонецПроцедуры

Процедура УстановитьСостояниеЗаказа(Заказ, НовоеСостояние)
	
	ТекстОшибки = НСтр("ru = 'Не удалось изменить состояние заказа заказа %1: %2'", ОбщегоНазначения.КодОсновногоЯзыка());
	Если Заказ.СостояниеЗаказа = НовоеСостояние Тогда
		Возврат;
	КонецЕсли; 
	ЗаказОбъект = Заказ.ПолучитьОбъект();
	ЗаказОбъект.СостояниеЗаказа = НовоеСостояние;
	Если НовоеСостояние = Справочники.СостоянияЗаказовПокупателей.Завершен Тогда
		ЗаказОбъект.ВариантЗавершения = Перечисления.ВариантыЗавершенияЗаказа.Успешно;
	КонецЕсли; 
	НачатьТранзакцию();
	Попытка
		ЗаказОбъект.Записать();
		ЗафиксироватьТранзакцию();
	Исключение
	    ОтменитьТранзакцию();
		Информация = ИнформацияОбОшибке();
		ТекстОшибки = СтрШаблон(ТекстОшибки, ЗаказОбъект.Ссылка, ПодробноеПредставлениеОшибки(Информация));
		ИмяСобытия = НСтр("ru = 'Продажи'", ОбщегоНазначения.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, ЗаказОбъект.Метаданные(), ЗаказОбъект.Ссылка, ТекстОшибки);
	КонецПопытки; 
	
КонецПроцедуры

Функция СостояниеОжидаетОтгрузки(Заказ, Отказ)
	
	НесколькоВидовЗаказов = ПолучитьФункциональнуюОпцию("ИспользоватьВидыЗаказовПокупателей");
	Если НесколькоВидовЗаказов Тогда
		ВидЗаказа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Заказ, "ВидЗаказа", Истина);
	Иначе
		ВидЗаказа = Справочники.ВидыЗаказовПокупателей.Основной;
	КонецЕсли;
	Если ВидЗаказа=Неопределено Тогда
		ОбщегоНазначения.СообщитьПользователю(
		НСтр("ru = 'Нарушение права доступа.'"), Заказ,,,
		Отказ);
		Возврат Неопределено;
	КонецЕсли; 
	СостояниеЗаказа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидЗаказа, "СостояниеОжидаетОтгрузки", Истина);
	
	Если НЕ ЗначениеЗаполнено(СостояниеЗаказа) Тогда
		Если НесколькоВидовЗаказов Тогда
			ОбщегоНазначения.СообщитьПользователю(
			СтрШаблон(НСтр("ru = 'Не задано состояние готовых к отгрузке заказов для вида %1'"),
			ВидЗаказа),
			ВидЗаказа,
			"СостояниеОжидаетОтгрузки",,
			Отказ);
		Иначе
			ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Не задано состояние готовых к отгрузке заказов'"),
			ВидЗаказа,
			"СостояниеОжидаетОтгрузки",,
			Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СостояниеЗаказа;
	
КонецФункции

#КонецОбласти 

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли