﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Серии номенклатуры
	Если СерииНоменклатурыУНФ.ИспользоватьСерииНоменклатурыОстатки() = Истина Тогда
		
		Если Номенклатура.ИспользоватьСерииНоменклатуры Тогда
			
			КонтрольКоличестваСерий = СерииНоменклатурыУНФ.КонтролироватьЗаполнениеСерии(Номенклатура, Организация, СтруктурнаяЕдиница);
			
			Если КонтрольКоличестваСерий Тогда
				Если Не ЗначениеЗаполнено(Серия) Тогда
					ТекстОшибки = НСтр("ru = 'Не выбрана серия номенклатуры.'");
					ПолеОшибки = "Объект.Серия";
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , ПолеОшибки, , Отказ);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли;
	
	Если НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимНаправлениямДеятельности.Получить() Тогда
		Если РемонтВыполнен Тогда
			
			ПроверяемыеРеквизиты.Добавить("НаправлениеДеятельности");
			
		КонецЕсли;
	КонецЕсли;
	
	Если ПередачаВСервисныйЦентр И ВариантРемонта = Перечисления.ВариантыРемонта.СервисЦентр Тогда
	
		ПроверяемыеРеквизиты.Добавить("СервисЦентр");
	
	КонецЕсли;
	
	
	Если ВыдачаИзРемонта И (НЕ РемонтВыполнен) Тогда
		Если ВариантРемонта = Перечисления.ВариантыРемонта.СервисЦентр Тогда
		    ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не установлен ""Принят из сервисного центра""'"));
		Иначе	
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не установлен ""Ремонт выполнен""'"));
		КонецЕсли;
		Отказ = Истина;
	КонецЕсли;
	Если РемонтВыполнен И ВариантРемонта = Перечисления.ВариантыРемонта.СервисЦентр И (НЕ ПередачаВСервисныйЦентр) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не установлен ""Передан в сервисный центр""'"));
		Отказ = Истина;
	КонецЕсли;
	
	Если ПередачаВСервисныйЦентр И РемонтВыполнен И ДатаПередачаВСервисныйЦентр > ДатаРемонтВыполнен Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Дата передачи в сервисный центр не может быть больше даты приема из сервисного центра'"));
		Отказ = Истина;
	КонецЕсли;
	
	Если РемонтВыполнен И ВыдачаИзРемонта И ДатаРемонтВыполнен > ДатаВыдачаИзРемонта Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Дата выполнения ремонта не может быть больше даты выдачи из ремонта'"));
		Отказ = Истина;
	КонецЕсли;
	
	Если ПередачаВСервисныйЦентр И Дата > ДатаПередачаВСервисныйЦентр Тогда
		Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
			// Если пользователь установил ДатаПередачаВСервисныйЦентр в новом документе до записи, она будет меньше даты и
			// времени записи документа
			Дата = ДатаПередачаВСервисныйЦентр;
		Иначе
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Дата передачи в сервисный центр не может быть меньше даты приема в ремонт (даты документа)'"));
			Отказ = Истина;
		КонецЕсли; 
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Номенклатура) И Номенклатура.ПроверятьЗаполнениеХарактеристики И Не ЗначениеЗаполнено(Характеристика)
		Тогда  		
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Для данной номенклатуры, заполнение поля характеристики является обязательным'"));
		Отказ = Истина;		
	КонецЕсли;
	
	РасчетыРаботаСФормамиВызовСервера.ПроверитьЗаполнениеДокументаПредоплаты(Контрагент, ПроверяемыеРеквизиты);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.ПриемИПередачаВРемонт.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыВРемонте", ТаблицыДляДвижений, Движения, Отказ);
	// СерииНоменклатуры
	ПроведениеДокументовУНФ.ОтразитьДвижения("СерииНоменклатурыГарантии", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДвиженияСерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
	
	Если (ДополнительныеСвойства.ВариантРемонта = Перечисления.ВариантыРемонта.НашаМастерскаяПростойРемонт
		ИЛИ ДополнительныеСвойства.ВариантРемонта = Перечисления.ВариантыРемонта.СервисЦентр) Тогда
		
		Если ДополнительныеСвойства.РемонтВыполнен Тогда
			
			ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыВРемонте", ТаблицыДляДвижений, Движения, Отказ);
			// СерииНоменклатуры
			ПроведениеДокументовУНФ.ОтразитьДвижения("СерииНоменклатурыГарантии", ТаблицыДляДвижений, Движения, Отказ);
			ПроведениеДокументовУНФ.ОтразитьДвижения("ДвиженияСерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
			
			ПроведениеДокументовУНФ.ОтразитьДвижения("РасчетыСПокупателями", ТаблицыДляДвижений, Движения, Отказ);
			
			ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходы", ТаблицыДляДвижений, Движения, Отказ);
			ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходыОтложенные", ТаблицыДляДвижений, Движения, Отказ);
			ПроведениеДокументовУНФ.ОтразитьДвижения("РасчетыПоНалогам", ТаблицыДляДвижений, Движения, Отказ);
			ПроведениеДокументовУНФ.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
			
		КонецЕсли;
	
		ПроведениеДокументовУНФ.ОтразитьДвижения("ОплатаСчетовИЗаказов", ТаблицыДляДвижений, Движения, Отказ);
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.ВариантРемонта = Перечисления.ВариантыРемонта.СервисЦентр Тогда
		
		ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыПереданныеВРемонте", ТаблицыДляДвижений, Движения, Отказ);
		
	КонецЕсли;
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль
	Документы.ПриемИПередачаВРемонт.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
	ПроведениеДокументовУНФ.ЗакрытьМенеджерВременныхТаблиц(ЭтотОбъект);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль
	Документы.ПриемИПередачаВРемонт.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

// Обработчик заполнения документа по структуре
//
// Параметры:
//
Процедура ЗаполнитьПоСтруктуре(ДанныеЗаполнения) Экспорт
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("Структура")] = "ЗаполнитьПоСтруктуре";
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	ЗаполнитьРеквизитыПечати();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Или РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ДополнительныеСвойства.Вставить("ВариантРемонта", ВариантРемонта);
		ДополнительныеСвойства.Вставить("ПередачаВСервисныйЦентр", ПередачаВСервисныйЦентр);
		ДополнительныеСвойства.Вставить("ДатаПередачаВСервисныйЦентр", ДатаПередачаВСервисныйЦентр);
		ДополнительныеСвойства.Вставить("РемонтВыполнен", РемонтВыполнен);
		ДополнительныеСвойства.Вставить("ДатаРемонтВыполнен", ДатаРемонтВыполнен);
		ДополнительныеСвойства.Вставить("ВыдачаИзРемонта", ВыдачаИзРемонта);
		ДополнительныеСвойства.Вставить("ДатаВыдачаИзРемонта", ДатаВыдачаИзРемонта);
		ДополнительныеСвойства.Вставить("СуммаДокумента", СуммаДокумента);
	КонецЕсли;
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ОбменДаннымиСобытияУНФ.ПропуститьДозаполнениеДокумента(ЭтотОбъект, РежимЗаписи) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("СебестоимостьБезНДС") Тогда
		НДСВключатьВСтоимость = Истина;
	КонецЕсли;
	
	СчетаФактурыУНФ.ПриЗаписиДокументаОснованияСчетаФактуры(Ссылка, ДополнительныеСвойства, Ложь);
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(Номер) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ИдентификаторПлатежа) Тогда
		ИдентификаторПлатежа = РасчетыСлужебный.ПолучитьУникальныйИдентификаторПлатежа(ЭтотОбъект);
	КонецЕсли; 
	
	РасчетыПроведениеДокументов.ВыполнитьКонтрольСуммыОплаты(Предоплата.Итог("СуммаРасчетов"), СуммаДокумента, Отказ);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ПередачаВСервисныйЦентр	= Ложь;
	РемонтВыполнен			= Ложь;
	ВыдачаИзРемонта			= Ложь;
	ДатаПередачаВСервисныйЦентр	= Дата("00010101");
	ДатаРемонтВыполнен			= Дата("00010101");
	ДатаВыдачаИзРемонта			= Дата("00010101");
	
	Предоплата.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьРеквизитыПечати()
	
	Если НЕ ЗначениеЗаполнено(УсловияГарантии) Тогда
		УсловияГарантии = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("УсловияГарантии", Организация);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(УсловияПриемки) Тогда
		УсловияПриемки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("УсловияПриемки", Организация);
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли