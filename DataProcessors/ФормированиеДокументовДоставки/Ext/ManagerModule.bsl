﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ФоновоеЗадание

Процедура СформироватьДокументы(Параметры, ВременноеХранилищеРезультата) Экспорт
	
	Результат = Новый Структура;
	Ошибки = Новый СписокЗначений;
	
	Если НЕ Параметры.Свойство("ПланДоставки") ИЛИ ТипЗнч(Параметры.ПланДоставки)<>Тип("ДеревоЗначений") Тогда
		Ошибка = НСтр("ru = 'Не задан план доставки'");
		Ошибки.Добавить(, Ошибка);
		Результат.Вставить("Ошибки", Ошибки);
		ПоместитьВоВременноеХранилище(Результат, ВременноеХранилищеРезультата);
		Возврат;
	КонецЕсли;
	
	ПланДоставки = Параметры.ПланДоставки;
	
	КоличествоСтрок = 0;
	Для каждого Стр Из ПланДоставки.Строки Цикл
	    Если Стр.СостояниеОтгрузкиИзменено ИЛИ Стр.СостояниеОплатыИзменено Тогда
			КоличествоСтрок = КоличествоСтрок + 1;
		КонецЕсли; 
	КонецЦикла;
	
	ОбновляемыеРеквизиты = Новый Соответствие;
	
	ИзмененныеМаршрутныеЛисты = Новый Соответствие;
	
	НомерСтроки = 0;
	Для каждого Стр Из ПланДоставки.Строки Цикл
		
		Если НЕ Стр.СостояниеОтгрузкиИзменено И НЕ Стр.СостояниеОплатыИзменено Тогда
			Продолжить;
		КонецЕсли; 
		
		СтруктураРеквизитов = Новый Структура;
		
		Если Стр.СостояниеОтгрузкиИзменено Тогда
			СоздатьОбновитьДокументыОтгрузки(Стр, ИзмененныеМаршрутныеЛисты, Ошибки);
			СтруктураРеквизитов.Вставить("СостояниеОтгрузкиИзменено", Ложь);
			СтруктураРеквизитов.Вставить("РасходнаяНакладная", Стр.РасходнаяНакладная);
			СтруктураРеквизитов.Вставить("РасходнаяНакладная", Стр.РасходнаяНакладная);
			Если Стр.СостояниеОтгрузки = Перечисления.СостоянияДоставкиЗаказа.Доставлен Тогда
				СтруктураРеквизитов.Вставить("МожноМенятьСостояниеОтгрузки", Ложь);
			КонецЕсли; 
		КонецЕсли; 
		
		Если Стр.СостояниеОплатыИзменено Тогда
			СоздатьОбновитьДокументыОплаты(Стр, Ошибки);
			СтруктураРеквизитов.Вставить("СостояниеОплатыИзменено", Ложь);
			Если Стр.СостояниеОплаты <> Перечисления.СостоянияОплатыЗаказа.НеОплачен Тогда
				СтруктураРеквизитов.Вставить("МожноМенятьСостояниеОплаты", Ложь);
			КонецЕсли; 
		КонецЕсли;
		
		ОбновляемыеРеквизиты.Вставить(Стр.Заказ, СтруктураРеквизитов);
		
		НомерСтроки = НомерСтроки + 1;
		ДлительныеОперации.СообщитьПрогресс(Окр(НомерСтроки / КоличествоСтрок * 100), Стр.ЗаказПредставление, ОбновляемыеРеквизиты);
		
	КонецЦикла;
	
	Для каждого КлючИЗначение Из ИзмененныеМаршрутныеЛисты Цикл
		ДокМаршрутныйЛист = КлючИЗначение.Значение;
		Попытка
			Если ДокМаршрутныйЛист.ПометкаУдаления Тогда
				ДокМаршрутныйЛист.УстановитьПометкуУдаления(Ложь);
			КонецЕсли;
			ДокМаршрутныйЛист.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Информация = ИнформацияОбОшибке();
			СообщенияПользователю = ПолучитьСообщенияПользователю();
			Ошибка = СтрШаблон(
			НСтр("ru = 'Не удалось обновить данные маршрутного листа %1: %2'"), 
			Стр.МаршрутныйЛист, 
			РекурсивноеОписаниеОшибки(Информация, СообщенияПользователю));
			Ошибки.Добавить(Стр.Заказ, Ошибка);
		КонецПопытки; 
	КонецЦикла; 
	
	Если Ошибки.Количество() > 0 Тогда
		Результат.Вставить("Ошибки", Ошибки);
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, ВременноеХранилищеРезультата);
	
КонецПроцедуры

Процедура СоздатьОбновитьДокументыОтгрузки(Стр, ИзмененныеМаршрутныеЛисты, Ошибки)
	
	Если НЕ ЗначениеЗаполнено(Стр.Заказ) Тогда
		Возврат;
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Стр.МаршрутныйЛист) Тогда
		ДокМаршрутныйЛист = ИзмененныеМаршрутныеЛисты.Получить(Стр.МаршрутныйЛист);
		Если ДокМаршрутныйЛист = Неопределено Тогда
			ДокМаршрутныйЛист = Стр.МаршрутныйЛист.ПолучитьОбъект();
			ИзмененныеМаршрутныеЛисты.Вставить(Стр.МаршрутныйЛист, ДокМаршрутныйЛист);
		КонецЕсли; 
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Заказ", Стр.Заказ);
		СтруктураОтбора.Вставить("РасходнаяНакладная", Стр.РасходнаяНакладная);
		Строки = ДокМаршрутныйЛист.Заказы.НайтиСтроки(СтруктураОтбора);
		Для каждого СтрокаМаршрутногоЛиста Из Строки Цикл
			СтрокаМаршрутногоЛиста.Доставлен = (Стр.СостояниеОтгрузки = Перечисления.СостоянияДоставкиЗаказа.Доставлен 
			ИЛИ Стр.СостояниеОтгрузки = Перечисления.СостоянияДоставкиЗаказа.ДоставленЧастично);
		КонецЦикла;
	КонецЕсли; 
	
	Если Стр.СостояниеОтгрузки = Перечисления.СостоянияДоставкиЗаказа.Доставлен
		И ЗначениеЗаполнено(Стр.РасходнаяНакладная) Тогда
		
		ИзменяемыйДокумент = ИзменяемыйДокумент(Стр.Возвраты);
		Если НЕ ЗначениеЗаполнено(ИзменяемыйДокумент) Тогда
			Возврат;
		КонецЕсли;
		
		ДокВозврат = ИзменяемыйДокумент.ПолучитьОбъект();
		Попытка
			ДокВозврат.УстановитьПометкуУдаления(Истина);
		Исключение
			Информация = ИнформацияОбОшибке();
			СообщенияПользователю = ПолучитьСообщенияПользователю();
			Ошибка = СтрШаблон(
			НСтр("ru = 'Не удалось отменить возврат по заказу %1: %2'"), 
			Стр.ЗаказПредставление, 
			РекурсивноеОписаниеОшибки(Информация, СообщенияПользователю));
			Ошибки.Добавить(Стр.Заказ, Ошибка);
		КонецПопытки;
		
	ИначеЕсли Стр.СостояниеОтгрузки = Перечисления.СостоянияДоставкиЗаказа.НеДоставлен
		И ЗначениеЗаполнено(Стр.РасходнаяНакладная) Тогда
		
		ИзменяемыйДокумент = ИзменяемыйДокумент(Стр.Возвраты);
		Если ЗначениеЗаполнено(ИзменяемыйДокумент) Тогда
			ДокВозврат = ИзменяемыйДокумент.ПолучитьОбъект();
		Иначе
			ДокВозврат = Документы.ПриходнаяНакладная.СоздатьДокумент();
			ДокВозврат.Дата = ТекущаяДатаСеанса();
			ДокВозврат.Комментарий = "#" + НСтр("ru = 'Формирование документов доставки'");
		КонецЕсли; 
		ДокВозврат.Заполнить(Стр.РасходнаяНакладная);
		Попытка
			ДокВозврат.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Информация = ИнформацияОбОшибке();
			СообщенияПользователю = ПолучитьСообщенияПользователю();
			Ошибка = СтрШаблон(
			НСтр("ru = 'Не удалось сформировать возврат по заказу %1: %2'"), 
			Стр.ЗаказПредставление, 
			РекурсивноеОписаниеОшибки(Информация, СообщенияПользователю));
			Ошибки.Добавить(Стр.Заказ, Ошибка);
		КонецПопытки;
		
		
	ИначеЕсли Стр.СостояниеОтгрузки = Перечисления.СостоянияДоставкиЗаказа.ДоставленЧастично
		И ЗначениеЗаполнено(Стр.РасходнаяНакладная) Тогда
		
		ИзменяемыйДокумент = ИзменяемыйДокумент(Стр.Возвраты);
		Если ЗначениеЗаполнено(ИзменяемыйДокумент) Тогда
			ДокВозврат = ИзменяемыйДокумент.ПолучитьОбъект();
		Иначе
			ДокВозврат = Документы.ПриходнаяНакладная.СоздатьДокумент();
			ДокВозврат.Дата = ТекущаяДатаСеанса();
			ДокВозврат.Комментарий = "#" + НСтр("ru = 'Формирование документов доставки'");
			ДокВозврат.Заполнить(Стр.РасходнаяНакладная);
		КонецЕсли; 
		ДокВозврат.Запасы.Очистить();
		
		ДоставленныеТовары = Новый ТаблицаЗначений;
		ДоставленныеТовары.Колонки.Добавить("Номенклатура");
		ДоставленныеТовары.Колонки.Добавить("Характеристика");
		Для каждого СтрНоменклатура Из Стр.Строки Цикл
			Если ТипЗнч(СтрНоменклатура.Группировка) <> Тип("СправочникСсылка.Номенклатура") Тогда
				Продолжить;
			КонецЕсли; 
			Если СтрНоменклатура.СостояниеОтгрузки = Перечисления.СостоянияДоставкиЗаказа.Доставлен Тогда
				НоваяСтрока = ДоставленныеТовары.Добавить();
				НоваяСтрока.Номенклатура = СтрНоменклатура.Группировка;
				НоваяСтрока.Характеристика = СтрНоменклатура.Характеристика;
			КонецЕсли; 
		КонецЦикла;
		
		СтруктураОтбора.Очистить();
		Для каждого СтрокаРасход Из Стр.РасходнаяНакладная.Запасы Цикл
			СтруктураОтбора.Вставить("Номенклатура", СтрокаРасход.Номенклатура);
			СтруктураОтбора.Вставить("Характеристика", СтрокаРасход.Характеристика);
			Если ДоставленныеТовары.НайтиСтроки(СтруктураОтбора).Количество() > 0 Тогда
				Продолжить;
			КонецЕсли; 
			НоваяСтрока = ДокВозврат.Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРасход);
		КонецЦикла;
		
		Если ДокВозврат.Запасы.Количество() = 0 И ДокВозврат.ЭтоНовый() Тогда
			Возврат;
		КонецЕсли; 
		Попытка
			Если ДокВозврат.Запасы.Количество() = 0 Тогда
				ДокВозврат.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			Иначе
				ДокВозврат.Записать(РежимЗаписиДокумента.Проведение);
			КонецЕсли; 
		Исключение
			Информация = ИнформацияОбОшибке();
			СообщенияПользователю = ПолучитьСообщенияПользователю();
			Ошибка = СтрШаблон(
			НСтр("ru = 'Не удалось сформировать возврат по заказу %1: %2'"), 
			Стр.ЗаказПредставление, 
			РекурсивноеОписаниеОшибки(Информация, СообщенияПользователю));
			Ошибки.Добавить(Стр.Заказ, Ошибка);
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьОбновитьДокументыОплаты(Стр, Ошибки)
	
	Если НЕ ЗначениеЗаполнено(Стр.Заказ) Тогда
		Возврат;
	КонецЕсли; 
	
	Если Стр.СостояниеОплаты = Перечисления.СостоянияОплатыЗаказа.НеОплачен Тогда
		
		// Удаление оплат
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Заказ", Стр.Заказ);
		Запрос.УстановитьПараметр("Документ", Стр.РасходнаяНакладная);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПоступлениеВКассуРасшифровкаПлатежа.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ПоступлениеВКассу.РасшифровкаПлатежа КАК ПоступлениеВКассуРасшифровкаПлатежа
		|ГДЕ
		|	ПоступлениеВКассуРасшифровкаПлатежа.Заказ = &Заказ
		|	И ПоступлениеВКассуРасшифровкаПлатежа.Документ = &Документ
		|	И ПоступлениеВКассуРасшифровкаПлатежа.Ссылка.Проведен
		|	И ПоступлениеВКассуРасшифровкаПлатежа.Ссылка.Комментарий ПОДОБНО ""#%""
		|
		|СГРУППИРОВАТЬ ПО
		|	ПоступлениеВКассуРасшифровкаПлатежа.Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПоступлениеНаСчетРасшифровкаПлатежа.Ссылка
		|ИЗ
		|	Документ.ПоступлениеНаСчет.РасшифровкаПлатежа КАК ПоступлениеНаСчетРасшифровкаПлатежа
		|ГДЕ
		|	ПоступлениеНаСчетРасшифровкаПлатежа.Заказ = &Заказ
		|	И ПоступлениеНаСчетРасшифровкаПлатежа.Документ = &Документ
		|	И ПоступлениеНаСчетРасшифровкаПлатежа.Ссылка.Проведен
		|	И ПоступлениеНаСчетРасшифровкаПлатежа.Ссылка.Комментарий ПОДОБНО ""#%""
		|
		|СГРУППИРОВАТЬ ПО
		|	ПоступлениеНаСчетРасшифровкаПлатежа.Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОперацияПоПлатежнымКартамРасшифровкаПлатежа.Ссылка
		|ИЗ
		|	Документ.ОперацияПоПлатежнымКартам.РасшифровкаПлатежа КАК ОперацияПоПлатежнымКартамРасшифровкаПлатежа
		|ГДЕ
		|	ОперацияПоПлатежнымКартамРасшифровкаПлатежа.Заказ = &Заказ
		|	И ОперацияПоПлатежнымКартамРасшифровкаПлатежа.Документ = &Документ
		|	И ОперацияПоПлатежнымКартамРасшифровкаПлатежа.Ссылка.Проведен
		|	И ОперацияПоПлатежнымКартамРасшифровкаПлатежа.Ссылка.Комментарий ПОДОБНО ""#%""
		|
		|СГРУППИРОВАТЬ ПО
		|	ОперацияПоПлатежнымКартамРасшифровкаПлатежа.Ссылка";
		Выборка = Запрос.Выполнить().Выбрать();
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Заказ", Стр.Заказ);
		СтруктураОтбора.Вставить("Документ", Стр.РасходнаяНакладная);
		Пока Выборка.Следующий() Цикл
			Док = Выборка.Ссылка.ПолучитьОбъект();
			СтрокиКУдалению = Док.РасшифровкаПлатежа.НайтиСтроки(СтруктураОтбора);
			Для каждого СтрРасшифровки Из СтрокиКУдалению Цикл
				Док.РасшифровкаПлатежа.Удалить(СтрРасшифровки);
			КонецЦикла;
			Попытка
				Если Док.РасшифровкаПлатежа.Количество() = 0 Тогда
					Док.УстановитьПометкуУдаления(Истина);
				Иначе
					Док.Записать(РежимЗаписиДокумента.Проведение);
				КонецЕсли; 
			Исключение
				Информация = ИнформацияОбОшибке();
				СообщенияПользователю = ПолучитьСообщенияПользователю();
				Ошибка = СтрШаблон(
				НСтр("ru = 'Не отменить оплату заказа %1: %2'"), 
				Стр.ЗаказПредставление, 
				РекурсивноеОписаниеОшибки(Информация, СообщенияПользователю));
				Ошибки.Добавить(Выборка.Ссылка, Ошибка);
			КонецПопытки; 
		КонецЦикла;
		
	ИначеЕсли Стр.СостояниеОплаты = Перечисления.СостоянияОплатыЗаказа.ОплаченНаличными И Стр.Оплачено > 0 Тогда
		
		Док = Документы.ПоступлениеВКассу.СоздатьДокумент();
		Док.Дата = ТекущаяДатаСеанса();
		Док.Комментарий = "#" + НСтр("ru = 'Формирование документов доставки'");
		Попытка
			Если ЗначениеЗаполнено(Стр.РасходнаяНакладная) Тогда
				Док.Заполнить(Стр.РасходнаяНакладная);
			Иначе
				Док.Заполнить(Стр.Заказ);
			КонецЕсли;
			СуммаПлатежа = Стр.Оплачено;
			ВалютаУчета = Константы.ВалютаУчета.Получить();
			Если Док.ВалютаДенежныхСредств <> ВалютаУчета Тогда
				СуммаПлатежа = РаботаСКурсамиВалют.ПересчитатьВВалюту(СуммаПлатежа, ВалютаУчета, Док.ВалютаДенежныхСредств, Док.Дата);
			КонецЕсли; 
			Для каждого СтрокаТабличнойЧасти Из Док.РасшифровкаПлатежа Цикл
				Если СтрокаТабличнойЧасти.Заказ = Стр.Заказ И СтрокаТабличнойЧасти.Документ = Стр.РасходнаяНакладная Тогда
					СтрокаТабличнойЧасти.СуммаПлатежа = СуммаПлатежа;
					СтрокаТабличнойЧасти.СуммаРасчетов = ЦенообразованиеСервер.ПересчитатьИзВалютыВВалюту(
						СтрокаТабличнойЧасти.СуммаПлатежа,
						Док.Курс,
						СтрокаТабличнойЧасти.Курс,
						Док.Кратность,
						СтрокаТабличнойЧасти.Кратность);
					Док.СуммаДокумента = Док.РасшифровкаПлатежа.Итог("СуммаПлатежа");
					Прервать;
				КонецЕсли; 
			КонецЦикла; 
			Док.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Информация = ИнформацияОбОшибке();
			СообщенияПользователю = ПолучитьСообщенияПользователю();
			Ошибка = СтрШаблон(
			НСтр("ru = 'Не удалось зафиксировать оплату заказа %1: %2'"), 
			Стр.ЗаказПредставление, 
			РекурсивноеОписаниеОшибки(Информация, СообщенияПользователю));
			Если Док.ЭтоНовый() Тогда
				Ошибки.Добавить(Стр.Заказ, Ошибка);
			Иначе
				Ошибки.Добавить(Док.Ссылка, Ошибка);
			КонецЕсли; 
		КонецПопытки; 
		
	ИначеЕсли Стр.СостояниеОплаты=Перечисления.СостоянияОплатыЗаказа.ОплаченКартой И Стр.Оплачено > 0 Тогда
		
		Док = Документы.ОперацияПоПлатежнымКартам.СоздатьДокумент();
		Док.Дата = ТекущаяДатаСеанса();
		Док.Комментарий = "#" + НСтр("ru = 'Формирование документов доставки'");
		Попытка
			Если ЗначениеЗаполнено(Стр.РасходнаяНакладная) Тогда
				Док.Заполнить(Стр.РасходнаяНакладная);
			Иначе
				Док.Заполнить(Стр.Заказ);
			КонецЕсли;
			СуммаПлатежа = Стр.Оплачено;
			ВалютаУчета = Константы.ВалютаУчета.Получить();
			Если Док.ВалютаДенежныхСредств <> ВалютаУчета Тогда
				СуммаПлатежа = РаботаСКурсамиВалют.ПересчитатьВВалюту(СуммаПлатежа, ВалютаУчета, Док.ВалютаДенежныхСредств, Док.Дата);
			КонецЕсли; 
			Для каждого СтрокаТабличнойЧасти Из Док.РасшифровкаПлатежа Цикл
				Если СтрокаТабличнойЧасти.Заказ = Стр.Заказ И СтрокаТабличнойЧасти.Документ = Стр.РасходнаяНакладная Тогда
					СтрокаТабличнойЧасти.СуммаПлатежа = СуммаПлатежа;
					СтрокаТабличнойЧасти.СуммаРасчетов = ЦенообразованиеСервер.ПересчитатьИзВалютыВВалюту(
						СтрокаТабличнойЧасти.СуммаПлатежа,
						Док.Курс,
						СтрокаТабличнойЧасти.Курс,
						Док.Кратность,
						СтрокаТабличнойЧасти.Кратность);
					Док.СуммаДокумента = Док.РасшифровкаПлатежа.Итог("СуммаПлатежа");
					Прервать;
				КонецЕсли; 
			КонецЦикла; 
			Док.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Информация = ИнформацияОбОшибке();
			СообщенияПользователю = ПолучитьСообщенияПользователю();
			Ошибка = СтрШаблон(
			НСтр("ru = 'Не удалось зафиксировать оплату заказа %1: %2'"), 
			Стр.ЗаказПредставление, 
			РекурсивноеОписаниеОшибки(Информация, СообщенияПользователю));
			Если Док.ЭтоНовый() Тогда
				Ошибки.Добавить(Стр.Заказ, Ошибка);
			Иначе
				Ошибки.Добавить(Док.Ссылка, Ошибка);
			КонецЕсли;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ИзменяемыйДокумент(Источник)
	
	Если ТипЗнч(Источник) <> Тип("СписокЗначений") Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	МассивОбъектов = Источник.ВыгрузитьЗначения();
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивОбъектов, "Комментарий");
	ПодходящиеОбъекты = Новый Массив;
	Для каждого КлючИЗначение Из ЗначенияРеквизитов Цикл
		Если Лев(КлючИЗначение.Значение, 1) = "#" Тогда
			ПодходящиеОбъекты.Добавить(КлючИЗначение.Ключ);
		КонецЕсли; 
	КонецЦикла;
	Если ПодходящиеОбъекты.Количество() = 1 Тогда
		Возврат ПодходящиеОбъекты[0];
	Иначе
		Возврат Неопределено;
	КонецЕсли; 
	
КонецФункции

Функция РекурсивноеОписаниеОшибки(Информация, СообщенияПользователю = Неопределено)
	
	Ошибка = КраткоеПредставлениеОшибки(Информация)+?(Информация.Причина=Неопределено, "", Символы.ПС+РекурсивноеОписаниеОшибки(Информация.Причина));
	Если СообщенияПользователю<>Неопределено Тогда
		Для каждого Сообщение Из СообщенияПользователю Цикл
			Ошибка = Ошибка + Символы.ПС + Сообщение.Текст;
		КонецЦикла; 
	КонецЕсли; 
	Возврат Ошибка	
	
КонецФункции

#КонецОбласти

#КонецЕсли