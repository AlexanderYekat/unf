﻿
&НаКлиенте
Процедура РассчитатьСдачу()
	
	Сдача = СуммаКартой + СуммаНаличными - КОплате;
	
	Если СуммаКартой = 0 И СуммаНаличными = 0 Тогда
		Элементы.ПробитьЧек1.Видимость = Ложь;
		Элементы.ПробитьЧек2.Видимость = Истина;
	Иначе
		Элементы.ПробитьЧек1.Видимость = Истина;
		Элементы.ПробитьЧек2.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОткрытиеЭкранаВGA(ЭтаФорма.ИмяФормы);
	// Конец Сбор статистики

	#Если МобильноеПриложениеСервер Тогда
		
		ОборудованиеПечати = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ОборудованиеПечати");
		ОборудованиеПлатежнойСистемы = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ОборудованиеПлатежнойСистемы");
		
	#КонецЕсли

	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЧекККМ.СлипЧек,
	|	ЧекККМ.ДатаОперацииЭТ
	|ИЗ
	|	Документ.ЧекККММП КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Параметры.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		РезультатОперацииПоПлатежнойСистеме = Новый Структура("СлипЧек, ДатаОперации", Выборка.СлипЧек.Получить(), Выборка.ДатаОперацииЭТ);
	КонецЕсли;
	
	ПолучитьЗначенияПараметровФормы();
	Элементы.СтраницыПечатьЧека.Видимость = Ложь;
	Элементы.Клавиатура.Видимость = Истина;
	
	Если ЭтоВозврат Тогда
		Элементы.Сдача.Видимость = Ложь;
		Элементы.ДекорацияНиз.Видимость = Ложь;
		Элементы.Клавиатура.Видимость = Ложь;
		Если СуммаКартой > 0 И СуммаНаличными = 0 Тогда
			Элементы.КОплате.Заголовок = НСтр("ru='ИТОГО на карту'");
			Элементы.ГруппаСуммы.Видимость = Ложь;
		ИначеЕсли СуммаКартой = 0 И СуммаНаличными > 0 Тогда
			Элементы.КОплате.Заголовок = НСтр("ru='ИТОГО наличными'");
			Элементы.ГруппаСуммы.Видимость = Ложь;
		Иначе
			Элементы.ГруппаСуммы.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьЗначенияПараметровФормы()
	
	КОплате = Параметры.СуммаДокумента;
	СуммаНаличными = Параметры.СуммаОплаты;
	СуммаКартой = Параметры.СуммаКартой;
	АдресЭП = Параметры.АдресЭП;
	Телефон = Параметры.Телефон;
	ЭтоВозврат = Параметры.ЭтоВозврат;
	
	СтруктураПараметровДляПечати = Новый Структура;
	СтруктураПараметровДляПечати.Вставить("ОбщиеПараметры", Параметры.ОбщиеПараметры);
	СтруктураПараметровДляПечати.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	СтруктураПараметровДляПечати.Вставить("ЭтоВозврат", ЭтоВозврат);
	
	Если ЭтоВозврат Тогда
		ЭтаФорма.Заголовок = НСтр("ru='Возврат оплаты'");
		ДанныеОплатыПоПлатежнойКартеЧекаПродажи = Параметры.ДанныеОплатыПоПлатежнойКартеЧекаПродажи;
	Иначе
		ЭтаФорма.Заголовок = НСтр("ru='Прием оплаты'");
	КонецЕсли;
	
КонецПроцедуры // ПолучитьЗначенияПараметровФормы()

&НаКлиенте
Процедура ПробитьЧек(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	Если Элементы.ПробитьЧек1.Заголовок = НСтр("ru='  Закрыть  '")
		И ЭтоВозврат Тогда
		Закрыть();
	Иначе
		ПробитьЧекНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПробитьЧекНаКлиенте()
	
	ВладелецФормы.ЗакрыватьПоЗавершенииОплаты = Ложь;
	
	Если Элементы.СтраницыПечатьЧека.ТекущаяСтраница = Элементы.СтраницаПечатьЧекаПечатьУспешно Тогда
		ПараметрыЗакрытия.Вставить("ВвестиНовуюПродажу", Истина);
		Закрыть(ПараметрыЗакрытия);
		Возврат;
	КонецЕсли;
	
	Если СуммаНаличными + СуммаКартой = 0 Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Укажите сумму принятых денег!'"),,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
		Возврат;
	КонецЕсли;
	
	Если СуммаНаличными + СуммаКартой < КОплате Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Сумма наличных и картой меньше суммы к оплате!'"),,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
		Возврат;
	КонецЕсли;
	
	ЗаблокироватьФорму();
	
	#Если МобильноеПриложениеКлиент Тогда
		ОборудованиеПлатежнойСистемы = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ОборудованиеПлатежнойСистемы");
	#Иначе
		ОборудованиеПлатежнойСистемы = Неопределено;
	#КонецЕсли
	
	ОплатаПоПлатежнойСистемеПроведена = ЗначениеЗаполнено(ВладелецФормы.ПолучитьСсылочныйНомер());
	
	Если СуммаКартой > 0 Тогда
		Если ЗначениеЗаполнено(ОборудованиеПлатежнойСистемы) Тогда
			Если ОплатаПоПлатежнойСистемеПроведена Тогда
				ПоказатьРаспечататьСлипЧек();
			Иначе
				ОтобразитьСтраницуПроцесса();
				Если ЭтоВозврат Тогда
					ПодключитьОбработчикОжидания("Подключаемый_ВозвратитьОплатуПоПлатежнойСистеме", 0.1, Истина);
				Иначе
					ПодключитьОбработчикОжидания("Подключаемый_ОплатитьПоПлатежнойСистеме", 0.1, Истина);
				КонецЕсли;
			КонецЕсли;
		Иначе
			ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПробитьЧекВопрос", ЭтотОбъект);
			ТекстВопроса = НСтр("ru = 'Операция оплаты на эквайринговом терминале прошла успешно?'");
			ПоказатьВопрос(
				ОписаниеОповещения,
				ТекстВопроса,
				РежимДиалогаВопрос.ДаНет,
				,
				,
				НСтр("ru = 'Подтверждение'"));
		КонецЕсли;
	Иначе
		ОтобразитьПечатьЧека();
		ПодключитьОбработчикОжидания("Подключаемый_ПробитьЧек", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РассчитатьСдачу();
	
	Если ЭтоВозврат Тогда
		ПробитьЧекНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаблокироватьФорму()
	
	ДоступноЗакрытиеФормы = Ложь;
	
	ОбщегоНазначенияМПКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма,
		"ПробитьЧек2", "Видимость",
		Истина);
	
	ОбщегоНазначенияМПКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма,
		"ПробитьЧек1", "Видимость",
		Ложь);
	
	ОбщегоНазначенияМПКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма,
		"Клавиатура", "Видимость",
		Ложь);

КонецПроцедуры

&НаКлиенте
Процедура РазблокироватьФорму(ПоказатьКлавиатуру = Ложь)
	
	ДоступноЗакрытиеФормы = Истина;
	
	ОбщегоНазначенияМПКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма,
		"ПробитьЧек2", "Видимость",
		Ложь);
	
	ОбщегоНазначенияМПКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма,
		"ПробитьЧек1", "Видимость",
		Истина);
	
	Если ПоказатьКлавиатуру Тогда
		ОбщегоНазначенияМПКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма,
			"Клавиатура", "Видимость",
			Истина);
	КонецЕсли;
	
КонецПроцедуры

#Область ОтображениеСтраниц

&НаКлиенте
Процедура ОтобразитьПечатьСлипЧека()
	
	Если ЗначениеЗаполнено(ОборудованиеПечати) Тогда
		Элементы.СтраницыПечатьЧека.Видимость = Истина;
		Элементы.СтраницыПечатьЧека.ТекущаяСтраница = Элементы.СтраницаПечатьЧекаПечатьСлип;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьОшибкуПечатиСлипЧека(ОписаниеОшибки)
	
	Элементы.НадписьОшибкаПечатиСлипЧека.Заголовок = СтрШаблон(НСтр("ru = 'Ошибка печати слип чека - %1'"),
		ОписаниеОшибки);
	Если ЗначениеЗаполнено(ОборудованиеПечати) Тогда
		Элементы.СтраницыПечатьЧека.Видимость = Истина;
		Элементы.СтраницыПечатьЧека.ТекущаяСтраница = Элементы.СтраницаПечатьЧекаОшибкаСлип;
	КонецЕсли;
	
	РазблокироватьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьПечатьЧека()
	
	Элементы.СтраницыПечатьЧека.Видимость = Истина;
	Элементы.СтраницыПечатьЧека.ТекущаяСтраница = Элементы.СтраницаПечатьЧекаПечать;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьОшибкуПечатиЧека(ОписаниеОшибки)
	
	Элементы.НадписьОшибкаПечатиЧека.Заголовок = СтрШаблон(НСтр("ru = 'Ошибка печати чека - %1'"), ОписаниеОшибки);
	Если ЗначениеЗаполнено(ОборудованиеПечати) Тогда
		Элементы.СтраницыПечатьЧека.Видимость = Истина;
		Элементы.СтраницыПечатьЧека.ТекущаяСтраница = Элементы.СтраницаПечатьЧекаОшибка;
	КонецЕсли;
	
	РазблокироватьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСтраницуПроцесса()
	
	Элементы.СтраницыПечатьЧека.Видимость = Истина;
	Элементы.СтраницыПечатьЧека.ТекущаяСтраница = Элементы.СтраницаОплатаПроцесс;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРаспечататьСлипЧек()
	
	ОтобразитьПечатьСлипЧека();
	ПодключитьОбработчикОжидания("Подключаемый_ПоказатьРаспечататьСлипЧек", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьОплатаЗавершенаУспешно()
	
	Элементы.СтраницыПечатьЧека.Видимость = Истина;
	Элементы.СтраницыПечатьЧека.ТекущаяСтраница = Элементы.СтраницаОплатаУспешно;
	Элементы.ГруппаСуммы.ТолькоПросмотр = Истина;
	ПолученоПлатежнаяКартаЗаблокировано = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьОшибкаОперации()
	
	Элементы.СтраницыПечатьЧека.Видимость = Истина;
	Элементы.СтраницыПечатьЧека.ТекущаяСтраница = Элементы.СтраницаОперацияОшибка;
	
	РазблокироватьФорму();
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Подключаемый_ПробитьЧек()
	
	#Если МобильноеПриложениеКлиент Тогда
		ОборудованиеПечати = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ОборудованиеПечати");
	#Иначе
		ОборудованиеПечати = Неопределено;
	#КонецЕсли
	
	РезультатПечатиЧека = РозничныеПродажиМПКлиент.РезультатПечатиЧека();
	
	Если ЗначениеЗаполнено(ОборудованиеПечати) Тогда
		
		СтруктураПараметровДляПечати.ОбщиеПараметры.ТаблицаОплат.Очистить();
		
		Если ЗначениеЗаполнено(СуммаНаличными) Тогда
			//ТипНаличные = 0;
			СтрокаОплаты = Новый Структура("ТипОплаты, Сумма", ПредопределенноеЗначение("Перечисление.ТипыОплатыККТ.Наличные"), СуммаНаличными);
			СтруктураПараметровДляПечати.ОбщиеПараметры.ТаблицаОплат.Добавить(СтрокаОплаты);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СуммаКартой) Тогда
			//ТипПлатежнаяКарта = 1;
			СтрокаОплаты = Новый Структура("ТипОплаты, Сумма", ПредопределенноеЗначение("Перечисление.ТипыОплатыККТ.Электронно"), СуммаКартой);
			СтруктураПараметровДляПечати.ОбщиеПараметры.ТаблицаОплат.Добавить(СтрокаОплаты);
		КонецЕсли;
		
		СтруктураПараметровДляПечати.ОбщиеПараметры.Вставить("ПокупательEmail", АдресЭП);
		СтруктураПараметровДляПечати.ОбщиеПараметры.Вставить("ПокупательНомер", Телефон);
		СтруктураПараметровДляПечати.ОбщиеПараметры.Вставить("ЭтоВозврат", ЭтоВозврат);
		
		СтруктураПараметровДляПечати.Вставить("ОборудованиеПечати", ОборудованиеПечати);
		РозничныеПродажиМПКлиент.ПечатьЧекаПродажи(СтруктураПараметровДляПечати, РезультатПечатиЧека);
		
	Иначе
		
		РезультатПечатиЧека.Успешно = Истина;
		РезультатПечатиЧека.НомерЧека = "1";
		
	КонецЕсли;
	
	Если РезультатПечатиЧека.Успешно Тогда
		ПараметрыЗакрытия = Новый Структура;
		ПараметрыЗакрытия.Вставить("Успешно", Истина);
		ПараметрыЗакрытия.Вставить("НомерЧека", РезультатПечатиЧека.НомерЧека);
		ПараметрыЗакрытия.Вставить("НомерСмены", РезультатПечатиЧека.НомерСмены);
		ПараметрыЗакрытия.Вставить("АдресEmailПокупателя", АдресЭП);
		ПараметрыЗакрытия.Вставить("НомерТелефонаПокупателя", Телефон);
		ПараметрыЗакрытия.Вставить("СуммаОплаты", СуммаНаличными - Сдача);
		ПараметрыЗакрытия.Вставить("СуммаКартой", СуммаКартой);
		
		Оплата = Новый Массив;
		
		Если ЗначениеЗаполнено(СуммаНаличными) Тогда
			СтруктураОплаты = Новый Структура();
			СтруктураОплаты.Вставить("ТипОплаты", ПредопределенноеЗначение("Перечисление.ТипыОплатыМП.Наличные"));
			СтруктураОплаты.Вставить("Сумма", СуммаНаличными - Сдача);
			Оплата.Добавить(СтруктураОплаты);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СуммаКартой) Тогда
			СтруктураОплаты = Новый Структура();
			СтруктураОплаты.Вставить("ТипОплаты", ПредопределенноеЗначение("Перечисление.ТипыОплатыМП.ПлатежнаяКарта"));
			СтруктураОплаты.Вставить("Сумма", СуммаКартой);
			//СтруктураОплаты.Вставить("ВидОплаты", ВидОплаты);
			СтруктураОплаты.Вставить("РезультатОперацииПоПлатежнойСистеме", РезультатОперацииПоПлатежнойСистеме);
			Оплата.Добавить(СтруктураОплаты);
		КонецЕсли;
		
		ПараметрыЗакрытия.Вставить("Оплата", Оплата);
		
		ВладелецФормы.Объект.СуммаОплаты = ПараметрыЗакрытия.СуммаОплаты;
		ВладелецФормы.Объект.СуммаКартой = ПараметрыЗакрытия.СуммаКартой;
		ВладелецФормы.Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусЧекаККММП.Пробит");
		Если ЗначениеЗаполнено(ПараметрыЗакрытия.НомерЧека) Тогда
			ВладелецФормы.Объект.НомерЧекаККМ = Строка(ПараметрыЗакрытия.НомерЧека - 1);
		Иначе
			ВладелецФормы.Объект.НомерЧекаККМ = "1";
		КонецЕсли;
		Если ЗначениеЗаполнено(ПараметрыЗакрытия.НомерСмены) Тогда
			ВладелецФормы.Объект.НомерСменыККМ = Число(ПараметрыЗакрытия.НомерСмены);
		КонецЕсли;
		ВладелецФормы.Объект.АдресЭП = ПараметрыЗакрытия.АдресEmailПокупателя;
		ВладелецФормы.Объект.Телефон = ПараметрыЗакрытия.НомерТелефонаПокупателя;
		ВладелецФормы.ЗаписатьЧек();
		РазблокироватьФорму();
		ОтобразитьПечатьЧекаУспешно();
		
		ОтправитьПушУведомление();
	Иначе
		ОтобразитьОшибкуПечатиЧека(РезультатПечатиЧека.ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьПушУведомление()
	
	#Если НЕ МобильноеПриложениеСервер Тогда
		Если ВРег(Метаданные.Имя) = ВРег("УправлениеНебольшойФирмойНаМобильном") Тогда
			Возврат;
		КонецЕсли;
		// АПК:488-выкл методы безопасного запуска обеспечиваются этой функцией
		МодульСинхронизацияПушУведомленияМПУНФ = Вычислить("СинхронизацияПушУведомленияМПУНФ");
		// АПК:488-вкл
		Если ТипЗнч(МодульСинхронизацияПушУведомленияМПУНФ) = Тип("ОбщийМодуль") Тогда
			МодульСинхронизацияПушУведомленияМПУНФ.ОтправитьПушУведомление("001");
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПоказатьРаспечататьСлипЧек()
	
	Если ЗначениеЗаполнено(ОборудованиеПечати) Тогда
		
		// функция разреза [cut] будет перенесена в мБПО, временное решение.
		
		МассивРазрезанныхСлипЧеков = ОбщегоНазначенияМПКлиентСервер.РазложитьСтрокуВМассивПодстрок(РезультатОперацииПоПлатежнойСистеме.СлипЧек, "[cut]", Ложь, Ложь);
		
		Для каждого РазрезанныйСлипЧек Из МассивРазрезанныхСлипЧеков Цикл
			
			ОчиститьСообщения();
			ВыходныеПараметры = Неопределено;
			ВходныеПараметры = Новый Структура("СтрокиТекста", РазрезанныйСлипЧек);
			
			#Если МобильноеПриложениеКлиент Тогда
				// АПК:488-выкл методы безопасного запуска обеспечиваются этой функцией
				МодульМенеджерОборудованияКлиент = Вычислить("МенеджерОборудованияКлиент");
				// АПК:488-вкл
				Если ТипЗнч(МодульМенеджерОборудованияКлиент) = Тип("ОбщийМодуль") Тогда
					
					Если МодульМенеджерОборудованияКлиент.ВыполнитьПечатьТекста(
						УникальныйИдентификатор,
						ОборудованиеПечати,
						ВходныеПараметры,
						ВыходныеПараметры) Тогда
					Иначе
						ОтобразитьОшибкуПечатиСлипЧека(ВыходныеПараметры.ТекстОшибки);
						Возврат;
					КонецЕсли;
				КонецЕсли;
			#КонецЕсли
			
		КонецЦикла;
		
		ПоказатьРаспечататьСлипЧекЗавершение(Неопределено, Неопределено);
		
	Иначе
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТекстСлипЧека", РезультатОперацииПоПлатежнойСистеме.СлипЧек);
		ПараметрыФормы.Вставить("ДатаОперации", РезультатОперацииПоПлатежнойСистеме.ДатаОперации);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПоказатьРаспечататьСлипЧекЗавершение", ЭтотОбъект);
		ОткрытьФорму("ОбщаяФорма.СлипЧекПлатежнойСистемыМП", ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРаспечататьСлипЧекЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ВыполняемаяОперацияПлатежнойСистемы <> "ОтменаОплаты" Тогда
		ОтобразитьПечатьЧека();
		ПодключитьОбработчикОжидания("Подключаемый_ПробитьЧек", 0.1, Истина);
	Иначе
		РазблокироватьФорму();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПробитьЧекВопрос(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		РазблокироватьФорму(Истина);
		Возврат;
	КонецЕсли;
	
	ОтобразитьПечатьЧека();
	ПодключитьОбработчикОжидания("Подключаемый_ПробитьЧек", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОплатитьПоПлатежнойСистеме()
	
	ВыполняемаяОперацияПлатежнойСистемы = "Оплата";
	
	ПараметрыОплаты = РозничныеПродажиМПКлиент.ПараметрыОплатыПоПлатежнойСистеме();
	ПараметрыОплаты.Сумма = СуммаКартой;
	ПараметрыОплаты.УникальныйИдентификатор = УникальныйИдентификатор;
	ПараметрыОплаты.Оборудование = ОборудованиеПлатежнойСистемы;
	
	РезультатОперацииПоПлатежнойСистеме = РозничныеПродажиМПКлиент.ОплатитьПоПлатежнойСистеме(ПараметрыОплаты);
	
	ВладелецФормы.ПослеПолучениеРезультатаПоПлатежнойСистеме(СуммаКартой, РезультатОперацииПоПлатежнойСистеме);
	
	Если РезультатОперацииПоПлатежнойСистеме.Успешно Тогда
		ПоказатьРаспечататьСлипЧек();
		ОтобразитьОплатаЗавершенаУспешно();
	Иначе
		Элементы.НадписьОшибкаЭТ.Заголовок = РезультатОперацииПоПлатежнойСистеме.ТекстОшибки;
		ОтобразитьОшибкаОперации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВозвратитьОплатуПоПлатежнойСистеме()
	
	ВыполняемаяОперацияПлатежнойСистемы = "ВозвратОплаты";
	
	ПараметрыВозвратаОплаты                     = РозничныеПродажиМПКлиент.ПараметрыВозвратаОплатыПоПлатежнойСистеме();
	ПараметрыВозвратаОплаты.Сумма               = СуммаКартой;
	ПараметрыВозвратаОплаты.УникальныйИдентификатор = УникальныйИдентификатор;
	ПараметрыВозвратаОплаты.Оборудование        = ОборудованиеПлатежнойСистемы;
	ПараметрыВозвратаОплаты.НомерКарты          = ДанныеОплатыПоПлатежнойКартеЧекаПродажи.НомерКарты;
	ПараметрыВозвратаОплаты.НомерСсылкиОперации = ДанныеОплатыПоПлатежнойКартеЧекаПродажи.НомерСсылкиОперации;
	ПараметрыВозвратаОплаты.КодАвторизации      = ДанныеОплатыПоПлатежнойКартеЧекаПродажи.КодАвторизации;
	ПараметрыВозвратаОплаты.НомерЧека           = СтруктураПараметровДляПечати.ОбщиеПараметры.НомерЧека;
	
	РезультатОперацииПоПлатежнойСистеме = РозничныеПродажиМПКлиент.ВозвратитьОплатуПоПлатежнойСистеме(ПараметрыВозвратаОплаты);
	
	ВладелецФормы.ПослеПолучениеРезультатаПоПлатежнойСистеме(СуммаКартой, РезультатОперацииПоПлатежнойСистеме);
	
	Если РезультатОперацииПоПлатежнойСистеме.Успешно Тогда
		ПоказатьРаспечататьСлипЧек();
		ОтобразитьВозвратОплатыУспешно();
	Иначе
		Элементы.НадписьОшибкаЭТ.Заголовок = РезультатОперацииПоПлатежнойСистеме.ТекстОшибки;
		ОтобразитьОшибкаОперации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьВозвратОплатыУспешно()
	
	Элементы.СтраницыПечатьЧека.Видимость = Истина;
	Элементы.СтраницыПечатьЧека.ТекущаяСтраница = Элементы.СтраницаВозвратОплатыУспешно;
	Элементы.Картой.ТолькоПросмотр = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьПечатьЧекаУспешно()
	
	Элементы.СтраницыПечатьЧека.Видимость = Истина;
	Элементы.СтраницыПечатьЧека.ТекущаяСтраница = Элементы.СтраницаПечатьЧекаПечатьУспешно;
	Элементы.СуммаКартой.ТолькоПросмотр = Истина;
	Элементы.СуммаНаличными.ТолькоПросмотр = Истина;
	Элементы.Телефон.ТолькоПросмотр = Истина;
	Элементы.АдресЭП.ТолькоПросмотр = Истина;
	Если ЭтоВозврат Тогда
		Элементы.ПробитьЧек1.Заголовок = НСтр("ru='  Закрыть  '");
	Иначе
		Элементы.ПробитьЧек1.Заголовок = НСтр("ru='  Новый чек  '");
	КонецЕсли;
	ВладелецФормы.ЗакрыватьПоЗавершенииОплаты = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаНаличнымиПриИзменении(Элемент)
	
	РассчитатьСдачу();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаКартойПриИзменении(Элемент)
	
		РассчитатьСдачу();

КонецПроцедуры

&НаКлиенте
Процедура Кнопка4Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики
	
	СуммаНаличными = КОплате - СуммаКартой;
	РассчитатьСдачу();
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка8Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики

	СуммаКартой = КОплате - СуммаНаличными;
	РассчитатьСдачу();
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка2Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики

	СуммаНаличными = СуммаНаличными + 10;
	РассчитатьСдачу();
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка1Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики

	СуммаНаличными = СуммаНаличными + 50;
	РассчитатьСдачу();
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка3Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики

	СуммаНаличными = СуммаНаличными + 100;
	РассчитатьСдачу();
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка5Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики

	СуммаНаличными = СуммаНаличными + 500;
	РассчитатьСдачу();
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка6Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики
	
	СуммаНаличными = СуммаНаличными + 1000;
	РассчитатьСдачу();
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка7Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики
	
	СуммаНаличными = СуммаНаличными + 5000;
	РассчитатьСдачу();
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация12Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики

	Элементы.ОтправкаЧека.Видимость = Истина;
	Элементы.ДекорацияНиз.Видимость = Ложь;
	Элементы.ДекорацияВерх.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация13Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики

	Элементы.ОтправкаЧека.Видимость = Ложь;
	Элементы.ДекорацияНиз.Видимость = Истина;
	Элементы.ДекорацияВерх.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация2Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики

	Если ЭтоВозврат Тогда
		Возврат;
	КонецЕсли;
	Элементы.СтраницыПечатьЧека.Видимость = Ложь;
	Элементы.Клавиатура.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация18Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики

	Если ЭтоВозврат Тогда
		Возврат;
	КонецЕсли;
	Элементы.СтраницыПечатьЧека.Видимость = Ложь;
	Элементы.Клавиатура.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация7Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики

	Если ЭтоВозврат Тогда
		Возврат;
	КонецЕсли;
	Элементы.СтраницыПечатьЧека.Видимость = Ложь;
	Элементы.Клавиатура.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Закрытие",,,ЗавершениеРаботы);
	// Конец Сбор статистики
	
КонецПроцедуры
