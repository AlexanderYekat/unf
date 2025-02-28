﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбщегоНазначения

Процедура ЗаполнитьОплату()
	
	Если ЗначениеЗаполнено(Основание) Тогда
		Возврат; // Формирование оплаты возможно только по документу без заказа.
	КонецЕсли;
	
	Если СуммаОплаты = 0 Тогда
		ОбщегоНазначенияМПСервер.УдалитьСвязанныеДокументы("ПриходДенегМП", Ссылка);
		Возврат;
	КонецЕсли;
	
	НайденнаяСсылка = Документы.ПриходДенегМП.НайтиПоРеквизиту("Основание", Ссылка);
	Если НайденнаяСсылка.Пустая() Тогда
		ОплатаОбъект = Документы.ПриходДенегМП.СоздатьДокумент();
		ОплатаОбъект.Дата = ТекущаяДата();
		ОплатаОбъект.УстановитьНовыйНомер();
	Иначе
		ОплатаОбъект = НайденнаяСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	Если ОбщегоНазначенияМПСервер.ЕстьПредопределенныйВДанных("СтатьиМП", "ОплатаОтПокупателя") Тогда
		ОплатаОбъект.Статья = Справочники.СтатьиМП.ОплатаОтПокупателя;
	КонецЕсли;
	
	ОплатаОбъект.Сумма = СуммаОплаты;
	ОплатаОбъект.Контрагент = Покупатель;
	ОплатаОбъект.Основание = Ссылка;
	
	Если ОбменДанными.Загрузка Тогда
		ОплатаОбъект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	КонецЕсли;
	
	Если ОплатаОбъект.ПометкаУдаления <> ПометкаУдаления Тогда
		ОплатаОбъект.Записать();
		ОплатаОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
	КонецЕсли;
	
	Если Проведен Тогда
		ОплатаОбъект.Записать(РежимЗаписиДокумента.Проведение);
	ИначеЕсли ОплатаОбъект.Проведен Тогда
		ОплатаОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	Иначе
		ОплатаОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.ОстаткиТоваровМП.Записывать = Истина;
	Движения.ПродажиМП.Записывать = Истина;
	
	КонтролироватьОстатки = НЕ Константы.НеКонтролироватьОстаткиМП.Получить()
		И НЕ ДополнительныеСвойства.Свойство("НеКонтролироватьОстатки");
	
	Остатки = РегистрыНакопления.ОстаткиТоваровМП.Остатки();
	
	ВсегоСкидкиРаспределено = 0;
	КоличествоСтрок = Товары.Количество();
	ТекущаяСтрока = 0;
	
	// Движения по регистру ОстаткиТоваров Расход.
	Для каждого ТекСтрокаТовары Из Товары Цикл
		
		Если ТекСтрокаТовары.Товар.Вид = Перечисления.ВидыТоваровМП.Товар Тогда
			
			Движение = Движения.ОстаткиТоваровМП.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;
			Движение.Товар = ТекСтрокаТовары.Товар;
			Движение.Количество = ТекСтрокаТовары.Количество;
			
			НайденнаяСтрокаОстатков = Остатки.Найти(Движение.Товар, "Товар");
			Если НайденнаяСтрокаОстатков = Неопределено Тогда
				КоличествоНаСкладе = 0;
				СебестоимостьНаЕдиницу = 0;
			Иначе
				КоличествоНаСкладе = НайденнаяСтрокаОстатков.Количество;
				СебестоимостьНаЕдиницу = ?(КоличествоНаСкладе = 0, 0, НайденнаяСтрокаОстатков.Сумма / КоличествоНаСкладе);
			КонецЕсли;
			
			Если КонтролироватьОстатки
				И КоличествоНаСкладе < Движение.Количество Тогда
				СтрокаОшибки = НСтр("ru='На складе нет достаточного количества остатков товара:"
				"%Товар%. Не хватает %Количество%';en='In stock do not have enough residual item:"
				"%Товар%. Not enough %Количество%'");
				СтрокаОшибки = СтрЗаменить(СтрокаОшибки, "%Товар%", СокрЛП(Движение.Товар));
				СтрокаОшибки = СтрЗаменить(СтрокаОшибки, "%Количество%", СокрЛП(Движение.Количество - КоличествоНаСкладе));
				ОбщегоНазначенияМПКлиентСервер.СообщитьПользователю(СтрокаОшибки, , Отказ);
				Продолжить;
			КонецЕсли;
			
			Движение.Сумма = СебестоимостьНаЕдиницу * Движение.Количество;
			Движение.Операция = Перечисления.ТоварныеОперацииМП.Продажа;
			
		КонецЕсли;
		
		ТекущаяСтрока = ТекущаяСтрока + 1;
		
		Если ТекущаяСтрока = КоличествоСтрок Тогда // Для последней строки распределяется весь остаток.
			СкидкаНаТовар = СуммаСкидки - ВсегоСкидкиРаспределено;
			ВсегоСкидкиРаспределено = СуммаСкидки;
		Иначе
			ДоляСуммыТовараВОбщей = ТекСтрокаТовары.Сумма / ?(СуммаДокумента = 0, 1, СуммаДокумента);
			СкидкаНаТовар = СуммаСкидки * ДоляСуммыТовараВОбщей;
			ВсегоСкидкиРаспределено = ВсегоСкидкиРаспределено + СкидкаНаТовар;
		КонецЕсли;
		
		Движение = Движения.ПродажиМП.Добавить();
		Движение.Период = Дата;
		Движение.Товар = ТекСтрокаТовары.Товар;
		Движение.Количество = ТекСтрокаТовары.Количество;
		Движение.Сумма = ТекСтрокаТовары.Сумма - СкидкаНаТовар;
		
	КонецЦикла;
	
	// Движения по регистру ВзаиморасчетыСКонтрагентамиМП.
	Если ЗначениеЗаполнено(Покупатель) Тогда
		Движения.ВзаиморасчетыСКонтрагентамиМП.Записывать = Истина;
		Движение = Движения.ВзаиморасчетыСКонтрагентамиМП.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Контрагент = Покупатель;
		Движение.Сумма = Товары.Итог("Сумма") - СуммаСкидки;
	КонецЕсли;
	
	Движения.Записать();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПометкаУдаления Тогда
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
	КонецЕсли;
	
	Если ОбменДаннымиСобытияУНФ.ПропуститьДозаполнениеДокумента(ЭтотОбъект, РежимЗаписи) Тогда
		Возврат;
	КонецЕсли;
	
	Если НалогВСумме Тогда
		СуммаДокумента = Товары.Итог("Сумма") - СуммаСкидки;
	Иначе
		СуммаДокумента = Товары.Итог("Сумма") - СуммаСкидки + СуммаНалога;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Основание = Неопределено;
	Комментарий = "";
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ЗапретитьОперацииСоСвязаннымиДокументами")
		И ДополнительныеСвойства.ЗапретитьОперацииСоСвязаннымиДокументами Тогда
	Иначе
		ЗаполнитьОплату();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли