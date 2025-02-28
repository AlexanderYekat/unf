﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьСтрокиСПустымДокументом();
	СФормироватьТаблицуДокументов();
	УстановитьБлокировкиДанныхДляРасчетаОплаты();
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ПриЗаписи набора записей.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьОплатыДокументов();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура рассчитывает и записывает оплаты заказа.
// Дата оплаты указывается в "Периоде". При фактической оплате
// по заказу происходит закрытие графика по ФИФО.
//
Процедура РассчитатьОплатыДокументов()
	
	ТаблицаДокументов = ДополнительныеСвойства.ТаблицаДокументов;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивДокументов", ТаблицаДокументов.ВыгрузитьКолонку("Документ"));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОплатаДокументовОбороты.Документ КАК Документ,
	|	ОплатаДокументовОбороты.СуммаОборот КАК Сумма,
	|	ОплатаДокументовОбороты.СуммаАвансаОборот КАК СуммаАванса,
	|	ОплатаДокументовОбороты.СуммаОплатыОборот КАК СуммаОплаты,
	|	ОплатаДокументовОбороты.СуммаАвансаАвтоОборот КАК СуммаАвансаАвто,
	|	ОплатаДокументовОбороты.СуммаОплатыАвтоОборот КАК СуммаОплатыАвто
	|ИЗ
	|	РегистрНакопления.ОплатаДокументов.Обороты(, , , Документ В (&МассивДокументов)) КАК ОплатаДокументовОбороты";
	
	НаборЗаписей = РегистрыСведений.ФактОплатыДокументов.СоздатьНаборЗаписей();
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекДокумент = Выборка.Документ;
		
		НаборЗаписей.Отбор.Документ.Установить(ТекДокумент);
		
		// Из таблицы удаляем отработанный счет на оплату.
		ТаблицаДокументов.Удалить(ТаблицаДокументов.Найти(ТекДокумент, "Документ"));
		
		Запись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
		
		НаборЗаписей.Записать(Истина);
		НаборЗаписей.Очистить();
		
	КонецЦикла;
	
	// По неотработанным заказам нужно очистить движения.
	Если ТаблицаДокументов.Количество() > 0 Тогда
		Для Каждого СтрокаТаб Из ТаблицаДокументов Цикл
			
			НаборЗаписей.Отбор.Документ.Установить(СтрокаТаб.Документ);
			НаборЗаписей.Записать(Истина);
			НаборЗаписей.Очистить();
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // РассчитатьОплатыЗаказов()

// Процедура удаляет из набора записей строки с пустым измерением Документ.
//
Процедура УдалитьСтрокиСПустымДокументом()
	
	СтрокиКУдалению = Новый Массив;
	
	Для Каждого СтрокаНабора Из ЭтотОбъект Цикл
		Если Не ЗначениеЗаполнено(СтрокаНабора.Документ) Тогда
			СтрокиКУдалению.Добавить(СтрокаНабора);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
		Удалить(СтрокаКУдалению);
	КонецЦикла;

КонецПроцедуры // УдалитьСтрокиСПустымДокументом()

// Процедура формирует таблицу счетов (заказов), которые были раньше в движениях
// и которые сейчас будут записаны.
//
Процедура СФормироватьТаблицуДокументов()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаОплатаДокументов.Документ КАК Документ
	|ИЗ
	|	РегистрНакопления.ОплатаДокументов КАК ТаблицаОплатаДокументов
	|ГДЕ
	|	ТаблицаОплатаДокументов.Регистратор = &Регистратор
	|	И ТаблицаОплатаДокументов.Документ <> НЕОПРЕДЕЛЕНО";
	
	ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
	ТаблицаНовыхДокументов = Выгрузить(, "Документ");
	ТаблицаНовыхДокументов.Свернуть("Документ");
	Для Каждого Запись Из ТаблицаНовыхДокументов Цикл
		
		Если ТаблицаДокументов.Найти(Запись.Документ, "Документ") = Неопределено Тогда
			ТаблицаДокументов.Добавить().Документ = Запись.Документ;
		КонецЕсли;
		
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("ТаблицаДокументов", ТаблицаДокументов);
	
КонецПроцедуры // СФормироватьТаблицуСчетовНаОплату()

// Процедура устанавливает блокировку данных для расчета оплаты.
//
Процедура УстановитьБлокировкиДанныхДляРасчетаОплаты()
	
	Блокировка = Новый БлокировкаДанных;
	
	// Блокировка регистра для подсчета остатков по календарю.
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ОплатаДокументов");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки.ИсточникДанных = ДополнительныеСвойства.ТаблицаДокументов;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Документ", "Документ");
	
	// Блокировка набора для записи.
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ФактОплатыДокументов");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ДополнительныеСвойства.ТаблицаДокументов;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Документ", "Документ");
	
	Блокировка.Заблокировать();
	
КонецПроцедуры // УстановитьБлокировкиДанныхДляРасчетаОплаты()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли