﻿#Область СлужебныйПрограммныйИнтерфейс

// Инициализирует структуру передачи данных
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * Ссылка - ОпределяемыйТип.ДокументыИСМП, СправочникСсылка.СтанцииУправленияЗаказамиИСМП - Передаваемый документ
// * Организация - ОпределяемыйТип.Организация - Организация
// * ДальнейшееДействие - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие
Функция ПараметрыОбработкиДокументов() Экспорт
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("Ссылка");
	ПараметрыОбработки.Вставить("Организация");
	ПараметрыОбработки.Вставить("ДальнейшееДействие");
	ПараметрыОбработки.Вставить("ДополнительныеПараметры");
	
	Возврат ПараметрыОбработки;
	
КонецФункции

// Возвращает структуру параметров обновления статуса.
Функция ПараметрыОбновленияСтатуса(ПараметрыОбновленияСтатуса = Неопределено) Экспорт
	
	Если ПараметрыОбновленияСтатуса = Неопределено Тогда
		ПараметрыОбновленияСтатуса = Новый Структура;
	КонецЕсли;
	
	ПараметрыОбновленияСтатуса.Вставить("Статус");
	ПараметрыОбновленияСтатуса.Вставить("СтатусОбработки");
	ПараметрыОбновленияСтатуса.Вставить("ОперацияКвитанции");
	ПараметрыОбновленияСтатуса.Вставить("ПротоколОбмена");
	ПараметрыОбновленияСтатуса.Вставить("ПараметрыЗапроса");
	
	Возврат ПараметрыОбновленияСтатуса;
	
КонецФункции

// Получает значение свойства переданного констекста
// 
// Параметры:
// 	Контекст - ФормаКлиентскогоПриложения - Передаваемый контекст.
// 	ИмяСвойства - Строка - Имя свойства контекста
// Возвращаемое значение:
// 	Произвольный, Неопределено - Значение свойства контекста.
Функция ЗначениеСвойстваКонтекста(Контекст, ИмяСвойства) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	ИсточникДанных = Контекст;
	Если ТипЗнч(Контекст) = Тип("ФормаКлиентскогоПриложения") Тогда
		ИсточникДанных = Контекст.Объект;
	КонецЕсли;
		
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ИсточникДанных, ИмяСвойства) Тогда
		ВозвращаемоеЗначение = ИсточникДанных[ИмяСвойства];
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Начало GTIN для маркировки остатков.
//
// Возвращаемое значение:
// 	Строка - Определеное в ИСМП значение.
Функция НачалоGTINМаркировкиОстатков() Экспорт

	Возврат "029";

КонецФункции

// Преобразовывает шаблона кода маркировки в вид упаковки
// 
// Параметры:
// 	Шаблон - ПеречислениеСсылка.ШаблоныКодовМаркировкиСУЗ - Шаблон кода маркировки.
// Возвращаемое значение:
// 	ПеречислениеСсылка.ВидыУпаковокИС - Вид упаковки.
Функция ВидУпаковкиПоШаблонуКодаМаркировки(Шаблон) Экспорт
	
	Если ЗначениеЗаполнено(Шаблон) Тогда
		Если ИнтеграцияИСМПКлиентСервер.ШаблоныГрупповыхУпаковок().Найти(Шаблон) <> Неопределено Тогда
			Возврат ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Групповая");
		ИначеЕсли ИнтеграцияИСМПКлиентСервер.ШаблоныНаборов().Найти(Шаблон) <> Неопределено Тогда
			Возврат ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Набор");
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Потребительская");
	
КонецФункции

// Преобразовывает вид упаковки в шаблон кода маркировки по виду продукции
// 
// Параметры:
// 	ВидУпаковки  - ПеречислениеСсылка.ВидыУпаковокИС  - Вид упаковки.
// 	ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции.
// Возвращаемое значение:
// 	ПеречислениеСсылка.ШаблоныКодовМаркировкиСУЗ - Шаблон кода маркировки.
Функция ШаблонКодаМаркировкиПоВидуУпаковки(ВидУпаковки, ВидПродукции) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	Если ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Групповая") Тогда
		ВозвращаемоеЗначение = ИнтеграцияИСМПКлиентСервер.ШаблонКодаМаркировкиПоВидуПродукции(ВидПродукции, 4);
	ИначеЕсли ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Набор") Тогда
		ВозвращаемоеЗначение = ИнтеграцияИСМПКлиентСервер.ШаблонКодаМаркировкиПоВидуПродукции(ВидПродукции, 5);
	ИначеЕсли ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Потребительская") Тогда
		ВозвращаемоеЗначение = ИнтеграцияИСМПКлиентСервер.ШаблонКодаМаркировкиПоВидуПродукции(ВидПродукции);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВозвращаемоеЗначение) Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Внутренняя ошибка. Не определен шаблон кода маркировки по виду упаковки %1 для вида продукции %2'"),
			ВидУпаковки,
			ВидПродукции);
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Формирует список возможных операций вывода из оборота по виду продукции
// 
// Параметры:
// 	ВидПродукции        - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции.
// 	ОбъемноСортовойУчет - Булево                             - Признак объемно-сортового учета.
// 	ВключатьУстаревшие  - Булево                             - Признак включения устаревших причин для поддержки синонимов ранее созданных документов.
// Возвращаемое значение:
// 	СписокЗначений Из ПеречислениеСсылка.ВидыОперацийИСМП - Список операций с представлениями.
Функция ОперацииВыводаИзОборотаПоВидуПродукции(ВидПродукции, ОбъемноСортовойУчет = Неопределено, ВключатьУстаревшие = Ложь) Экспорт
	
	ВозвращаемоеЗначение = Новый СписокЗначений();
	
	Если ОбщегоНазначенияИСКлиентСервер.ЭтоМолочнаяПродукцияИСМП(ВидПродукции) Тогда
		
		Если Не ОбъемноСортовойУчет Тогда
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа"),
				НСтр("ru = 'Розничная продажа'"));
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаЧерезВендинговыйАппарат"),
				НСтр("ru = 'Продажа через вендинговый аппарат'"));
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЛиквидацияПредприятия"),
				НСтр("ru = 'Банкротство, ликвидация'"));
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаФасовка"),
				НСтр("ru = 'Фасовка'"));
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоОбразцам"),
				НСтр("ru = 'Продажа по образцам'"));
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДистанционнаяПродажа"),
				НСтр("ru = 'Дистанционная продажа'"));
		КонецЕсли;
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортВСтраныЕАЭС"),
			НСтр("ru = 'Экспорт в страны ЕАЭС'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортЗаПределыСтранЕАЭС"),
			НСтр("ru = 'Экспорт за пределы стран ЕАЭС'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИстечениеСрокаГодности"),
			НСтр("ru = 'Истечение срока годности'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтратаПовреждениеТовара"),
			НСтр("ru = 'Порча, утеря товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУничтожениеТовара"),
			НСтр("ru = 'Уничтожение товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтилизацияТовара"),
			НСтр("ru = 'Утилизация товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаКонфискацияТовара"),
			НСтр("ru = 'Конфискация товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляСобственныхНуждПредприятия"),
			НСтр("ru = 'Для собственных нужд предприятия'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаБезвозмезднаяПередача"),
			НСтр("ru = 'Безвозмездная передача'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДругое"),
			НСтр("ru = 'Другое'"));
		ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляПроизводственныхЦелей"),
				НСтр("ru = 'Для производственных целей'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоСделкеСоставляющейГосударственнуюТайну"),
			НСтр("ru = 'Продажа по сделке, составляющей гос.тайну'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоГосударственномуКонтракту"),
			НСтр("ru = 'Продажа по государственному (муниципальному) контракту'"));
		
		Если ВключатьУстаревшие Тогда
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.УдалитьВыводИзОборотаПродажаПоОбразцамДистанционнаяПродажа"),
				НСтр("ru = '(не используется) Продажа по образцам, дистанционная продажа'"));
		КонецЕсли;
		
	Иначе
		
		Если ОбъемноСортовойУчет Тогда
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДругое"),
				НСтр("ru = 'Другое'"));
			Если ВидПродукции <> ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.СоковаяПродукция") Тогда
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтратаПовреждениеТовара"),
					НСтр("ru = 'Порча, утеря товара'"));
			КонецЕсли;
		Иначе
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа"),
				НСтр("ru = 'Розничная продажа'"));
			Если ОбщегоНазначенияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаОтзывСРынка"),
					НСтр("ru = 'Отзыв с рынка'"));
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДругое"),
					НСтр("ru = 'Другие причины'"));
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтратаПовреждениеТовара"),
					НСтр("ru = 'Утеря, недостача товара'"));
			Иначе
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДистанционнаяПродажа"),
					НСтр("ru = 'Дистанционная продажа'"));
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоОбразцам"),
					НСтр("ru = 'Продажа по образцам'"));
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЛиквидацияПредприятия"),
					НСтр("ru = 'Банкротство, ликвидация'"));
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаБезвозмезднаяПередача"),
					НСтр("ru = 'Безвозмездная передача'"));
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДругое"),
					НСтр("ru = 'Другое'"));
				Если ВидПродукции <> ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.СоковаяПродукция") Тогда
					ВозвращаемоеЗначение.Добавить(
						ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтратаПовреждениеТовара"),
						НСтр("ru = 'Порча, утеря товара'"));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортВСтраныЕАЭС"),
			НСтр("ru = 'Экспорт в страны ЕАЭС'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортЗаПределыСтранЕАЭС"),
			НСтр("ru = 'Экспорт за пределы стран ЕАЭС'"));
		Если ВидПродукции <> ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.УпакованнаяВода")
			И Не ОбъемноСортовойУчет
			И Не ОбщегоНазначенияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаВозвратФизическомуЛицу"),
				НСтр("ru = 'Возврат физическому лицу'"));
		КонецЕсли;
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУничтожениеТовара"),
			НСтр("ru = 'Уничтожение товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтилизацияТовара"),
			НСтр("ru = 'Утилизация товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаКонфискацияТовара"),
			НСтр("ru = 'Конфискация товара'"));
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляСобственныхНуждПредприятия"),
			НСтр("ru = 'Для собственных нужд предприятия'"));
		Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Духи")
			Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Обувь")
			Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ЛегкаяПромышленность")
			Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.УпакованнаяВода")
			Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.СоковаяПродукция")
			Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Фотоаппараты")
			Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Шины")
			Или ОбщегоНазначенияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоСделкеСоставляющейГосударственнуюТайну"),
				НСтр("ru = 'Продажа по сделке, составляющей гос.тайну'"));
		КонецЕсли;
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоГосударственномуКонтракту"),
			НСтр("ru = 'Продажа по государственному (муниципальному) контракту'"));
		Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.УпакованнаяВода")
			Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.СоковаяПродукция")
			Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.БезалкогольноеПиво") Тогда
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляПроизводственныхЦелей"),
				НСтр("ru = 'Для производственных целей'"));
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИстечениеСрокаГодности"),
				НСтр("ru = 'Истечение срока годности'"));
			Если Не ОбъемноСортовойУчет Тогда
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаЧерезВендинговыйАппарат"),
					НСтр("ru = 'Продажа через вендинговый аппарат'"));
			КонецЕсли;
		КонецЕсли;
		
		Если ВключатьУстаревшие Тогда
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.УдалитьВыводИзОборотаПродажаПоОбразцамДистанционнаяПродажа"),
				НСтр("ru = '(не используется) Продажа по образцам, дистанционная продажа'"));
			Если ОбщегоНазначенияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЛиквидацияПредприятия"),
					НСтр("ru = '(не используется) Банкротство, ликвидация'"));
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаБрак"),
					НСтр("ru = '(не используется) Брак, порча товара'"));
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИстечениеСрокаГодности"),
					НСтр("ru = '(не используется) Истечение срока годности'"));
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЛабораторныеОбразцы"),
					НСтр("ru = '(не используется) Лабораторные образцы'"));
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРекламации"),
					НСтр("ru = '(не используется) Рекламации'"));
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаТестированиеПродукта"),
					НСтр("ru = '(не используется) Тестирование продукта'"));
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДругиеПричины"),
					НСтр("ru = '(не используется) Другие причины'"));
				ВозвращаемоеЗначение.Добавить(
					ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.УдалитьВыводИзОборотаПродажаПоОбразцамДистанционнаяПродажа"),
					НСтр("ru = '(не используется) Продажа по образцам'"));
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ВозвращаемоеЗначение.СортироватьПоПредставлению();
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Формирует список возможных операций возврата в оборот по виду продукции
// 
// Параметры:
// 	ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - ВидПродукции
// Возвращаемое значение:
// 	СписокЗначений Из ПеречислениеСсылка.ВидыОперацийИСМП - Список операций с представлениями.
Функция ОперацииВозвратаВОборотПоВидуПродукции(ВидПродукции) Экспорт
	
	ВозвращаемоеЗначение = Новый СписокЗначений();
	
	ВозвращаемоеЗначение.Добавить(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборотПриДистанционномСпособеПродажи"));
	
	ЭтоМолочнаяПродукция = ОбщегоНазначенияИСКлиентСервер.ЭтоМолочнаяПродукцияИСМП(ВидПродукции);
	
	Если Не ЭтоМолочнаяПродукция
		И Не ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.СоковаяПродукция")
		И Не ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.БезалкогольноеПиво") Тогда
		
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборотПриРозничнойРеализации"));
		
		Если ОбщегоНазначенияИСКлиентСервер.ЭтоПродукцияИСМП(ВидПродукции)
			И Не ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПродукцияИзНатуральногоМеха") Тогда
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборотТовараВыведенногоДляСобственныхНужд"));
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборотТовараПриобретавшегосяНеДляПродажи"));
		КонецЕсли;
		
		Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.УпакованнаяВода") Тогда
			ВозвращаемоеЗначение.Добавить(
				ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборотТовараВыведенногоДляПроизводственныхЦелей"));
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоМолочнаяПродукция
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.СоковаяПродукция")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.УпакованнаяВода")
		Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.БезалкогольноеПиво") Тогда
		ВозвращаемоеЗначение.Добавить(
			ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВозвратВОборотПриПродажеЧерезВендинговыйАппарат"));
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ОперацииМаркировки(Операция) Экспорт
	
	ОперацииМаркировки = Новый Структура;
	ОперацииМаркировки.Вставить("ЭтоПроизводствоРФ", Ложь);
	ОперацииМаркировки.Вставить("ЭтоПроизводствоПоДоговору", Ложь);
	ОперацииМаркировки.Вставить("ЭтоПроизводствоПоДоговоруНаСторонеЗаказчика", Ложь);
	ОперацииМаркировки.Вставить("ЭтоПроизводствоВнеЕАЭС", Ложь);
	ОперацииМаркировки.Вставить("ЭтоИмпортСФТС", Ложь);
	ОперацииМаркировки.Вставить("ЭтоПолучениеПродукцииОтФизическихЛиц", Ложь);
	ОперацииМаркировки.Вставить("ЭтоМаркировкаОстатков", Ложь);
	ОперацииМаркировки.Вставить("ЭтоТрансграничнаяТорговля", Ложь);
	ОперацииМаркировки.Вставить("ЭтоАгрегация", Ложь);
	ОперацииМаркировки.Вставить("ЭтоВводВОборот", Ложь);
	ОперацииМаркировки.Вставить("ЭтоКонтрактноеПроизводство", Ложь);
	ОперацииМаркировки.Вставить("ЭтоОперацияНанесения", Ложь);
	ОперацииМаркировки.Вставить("ТребуетсяЗаполнениеИдентификаторовПримененияВЕТИС", Ложь);
	ОперацииМаркировки.Вставить("ЭтоИмпорт", Ложь);
	ОперацииМаркировки.Вставить("ЭтоПриемкаКИЗ", Ложь);
	ОперацииМаркировки.Вставить("ЭтоИндивидуализацияКИЗ", Ложь);
	
	Если Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоРФ") Тогда
		ОперацииМаркировки.ЭтоПроизводствоРФ = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоРФПоДоговору") Тогда
		ОперацииМаркировки.ЭтоПроизводствоПоДоговору = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоРФПоДоговоруНаСторонеЗаказчика") Тогда
		ОперацииМаркировки.ЭтоПроизводствоПоДоговоруНаСторонеЗаказчика = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоВнеЕАЭС") Тогда
		ОперацииМаркировки.ЭтоПроизводствоВнеЕАЭС = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотИмпортСФТС")
		Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотИмпортСФТСМех") Тогда
		ОперацииМаркировки.ЭтоИмпортСФТС = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПолучениеПродукцииОтФизическихЛиц") Тогда
		ОперацииМаркировки.ЭтоПолучениеПродукцииОтФизическихЛиц = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотМаркировкаОстатков") Тогда
		ОперацииМаркировки.ЭтоМаркировкаОстатков = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотТрансграничнаяТорговля") Тогда
		ОперацииМаркировки.ЭтоТрансграничнаяТорговля = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.Агрегация") Тогда
		ОперацииМаркировки.ЭтоАгрегация = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПодтверждениеПоступленияКИЗ") Тогда
		ОперацииМаркировки.ЭтоПриемкаКИЗ = Истина;
	ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ИндивидуализацияКИЗ") Тогда
		ОперацииМаркировки.ЭтоИндивидуализацияКИЗ = Истина;
	КонецЕсли;
	
	ОперацииМаркировки.ЭтоОперацияНанесения = ИнтеграцияИСМПКлиентСервер.ОперацииНанесенияКодовМаркировки().Найти(Операция) <> Неопределено;
	
	ОперацииМаркировки.ЭтоВводВОборот =
		  Не ОперацииМаркировки.ЭтоОперацияНанесения
		И Не ОперацииМаркировки.ЭтоАгрегация
		И Не ОперацииМаркировки.ЭтоМаркировкаОстатков
		И Не ОперацииМаркировки.ЭтоПолучениеПродукцииОтФизическихЛиц;
	
	ОперацииМаркировки.ЭтоКонтрактноеПроизводство =
		ОперацииМаркировки.ЭтоПроизводствоПоДоговору
		Или ОперацииМаркировки.ЭтоПроизводствоПоДоговоруНаСторонеЗаказчика;
	
	ОперацииМаркировки.ТребуетсяЗаполнениеИдентификаторовПримененияВЕТИС =
		Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоРФ")
		Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотПроизводствоВнеЕАЭС")
		Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотТрансграничнаяТорговля")
		Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВводВОборотИмпортСФТС")
		Или ОперацииМаркировки.ЭтоКонтрактноеПроизводство
		Или ОперацииМаркировки.ЭтоИмпортСФТС;

	ОперацииМаркировки.ЭтоИмпорт =
		ОперацииМаркировки.ЭтоТрансграничнаяТорговля 
		Или ОперацииМаркировки.ЭтоПроизводствоВнеЕАЭС
		Или ОперацииМаркировки.ЭтоИмпортСФТС;
	
	Возврат ОперацииМаркировки;
	
КонецФункции

Функция МаксимальноеКоличествоЗаписейВТабличнойЧасти() Экспорт
	Возврат 99999;
КонецФункции

Функция ЭтоПриемкаИзСтранЕАЭС(Операция) Экспорт
	
	Если Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаТрансграничнаяТорговля")
		Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаИзЕАЭССПризнаниемКМ")
		Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ПриемкаИзЕАЭСПриОСУ") Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыводИзОборотаИСМП

Функция ИспользованиеКонтрагентаПриВыводеИзОборота(Операция, ТолькоОбязательное = Ложь, ОбъемноСортовойУчет = Ложь) Экспорт
	
	Использование = Ложь;
	
	Если ТолькоОбязательное Тогда
		
		Использование = (Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаБезвозмезднаяПередача")
			Или ОбъемноСортовойУчет И Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРеализацияНезарегистрированномуУчастнику"));
		
	Иначе
		
		Использование = (
			    Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаБезвозмезднаяПередача")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляСобственныхНуждПредприятия")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляПроизводственныхЦелей")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортВСтраныЕАЭС")
			Или ОбъемноСортовойУчет И Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРеализацияНезарегистрированномуУчастнику"));
		
	КонецЕсли;
	
	Возврат Использование;
	
КонецФункции

Функция ИспользованиеПервичногоДокументаПриВыводеИзОборота(Операция, ТолькоОбязательное = Ложь) Экспорт
	
	Если (Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоСделкеСоставляющейГосударственнуюТайну")
		Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортВСтраныЕАЭС")
		Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоГосударственномуКонтракту")) Тогда
		
		Использование = Ложь;
		
	ИначеЕсли ТолькоОбязательное Тогда
		
		Использование = Не (
			    Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.УдалитьВыводИзОборотаПродажаПоОбразцамДистанционнаяПродажа")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоОбразцам")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДистанционнаяПродажа")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаЧерезВендинговыйАппарат"));
		
	Иначе
		
		Использование = Истина;
		
	КонецЕсли;
	
	Возврат Использование;
	
КонецФункции

Функция ИспользованиеЦеныПриВыводеИзОборота(Операция, ТолькоОбязательное = Ложь, ОбъемноСортовойУчет = Ложь) Экспорт
	
	Использование = Ложь;
	
	ОбязательныеОперации         = ОперацииОбязательногоИспользованиеЦеныПриВыводеИзОборота();
	ЭтоОбязательноеИспользование = (ОбязательныеОперации.НайтиПоЗначению(Операция) <> Неопределено);
	
	Если ЭтоОбязательноеИспользование Тогда
		Использование = Истина;
	ИначеЕсли ТолькоОбязательное Тогда
		Использование = Ложь;
	Иначе
		
		Использование = (
			(Не ОбъемноСортовойУчет И Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаБезвозмезднаяПередача"))
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляПроизводственныхЦелей")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляСобственныхНуждПредприятия")
			Или ОбъемноСортовойУчет И Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРеализацияНезарегистрированномуУчастнику"));
		
	КонецЕсли;
	
	Возврат Использование;
	
КонецФункции

Функция ИспользованиеАдресаПриВыводеИзОборота(Операция, ВидПродукции, ТолькоОбязательное = Ложь, ОбъемноСортовойУчет = Ложь) Экспорт
	
	Использование = Ложь;
	
	Если ОбщегоНазначенияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
		
		Если ТолькоОбязательное Тогда
			Использование = (
				Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУничтожениеТовара")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаКонфискацияТовара")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДругиеПричины")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДругое")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтилизацияТовара")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаОтзывСРынка")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтратаПовреждениеТовара"));
		Иначе
			Использование = Не (
				Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляСобственныхНуждПредприятия")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоГосударственномуКонтракту")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоСделкеСоставляющейГосударственнуюТайну")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортВСтраныЕАЭС")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортЗаПределыСтранЕАЭС"));
		КонецЕсли;
	
	ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПродукцияИзНатуральногоМеха") Тогда
		
		Если ТолькоОбязательное Тогда
			Использование = Ложь;
		Иначе
			Использование = Не (
				Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаБезвозмезднаяПередача")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИспользованиеДляСобственныхНуждПредприятия")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоГосударственномуКонтракту")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоСделкеСоставляющейГосударственнуюТайну")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортВСтраныЕАЭС")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаЭкспортЗаПределыСтранЕАЭС"));
		КонецЕсли;
		
	Иначе
		
		Если ТолькоОбязательное Тогда
			Использование = Ложь;
		Иначе
			Использование = (
				Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаКонфискацияТовара")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтилизацияТовара")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУничтожениеТовара")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаИстечениеСрокаГодности")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДругое")
				Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаУтратаПовреждениеТовара"));
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат Использование;
	
КонецФункции

Функция ОперацииОбязательногоИспользованиеЦеныПриВыводеИзОборота() Экспорт
	
	ВозвращаемоеЗначение = Новый СписокЗначений();
	
	ВозвращаемоеЗначение.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.УдалитьВыводИзОборотаПродажаПоОбразцамДистанционнаяПродажа"));
	ВозвращаемоеЗначение.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаПоОбразцам"));
	ВозвращаемоеЗначение.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаДистанционнаяПродажа"));
	ВозвращаемоеЗначение.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРозничнаяПродажа"));
	ВозвращаемоеЗначение.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаПродажаЧерезВендинговыйАппарат"));
	ВозвращаемоеЗначение.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаФасовка"));
	ВозвращаемоеЗначение.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ВыводИзОборотаРеализацияНезарегистрированномуУчастнику"));
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#Область ОтгрузкаТоваровИСМП

Функция ИспользованиеGLNКонтрагентаПриОтгрузкеТоваров(Операция, ТолькоОбязательное = Ложь) Экспорт
	
	ОбязательныеОперации         = ОперацииОбязательногоИспользованияGLNПриОтгрузкеТоваров();
	ЭтоОбязательноеИспользование = (ОбязательныеОперации.НайтиПоЗначению(Операция) <> Неопределено);
	Если ЭтоОбязательноеИспользование Тогда
		Использование = Истина;
	ИначеЕсли ТолькоОбязательное Тогда
		Использование = Ложь;
	Иначе
		Использование = (Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаЕАЭССПризнаниемКИ"));
	КонецЕсли;
	
	Возврат Использование;
	
КонецФункции

Функция ОперацииОбязательногоИспользованияGLNПриОтгрузкеТоваров() Экспорт
	
	ВозвращаемоеЗначение = Новый СписокЗначений();
	ВозвращаемоеЗначение.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийИСМП.ОтгрузкаВЕАЭСПриОСУ"));
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#КонецОбласти