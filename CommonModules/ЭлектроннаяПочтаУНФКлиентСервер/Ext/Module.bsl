﻿
#Область ПрограммныйИнтерфейс

Функция НастройкиПоУмолчанию(АдресЭлектроннойПочты, Пароль) Экспорт
	
	Позиция = СтрНайти(АдресЭлектроннойПочты, "@");
	ИмяСервераВУчетнойЗаписи = Сред(АдресЭлектроннойПочты, Позиция + 1);
	
	Настройки = Новый Структура;
	
	Настройки.Вставить("ИмяПользователяДляПолученияПисем", АдресЭлектроннойПочты);
	Настройки.Вставить("ИмяПользователяДляОтправкиПисем", АдресЭлектроннойПочты);
	
	Настройки.Вставить("ПарольДляОтправкиПисем", Пароль);
	Настройки.Вставить("ПарольДляПолученияПисем", Пароль);
	
	Настройки.Вставить("Протокол", "IMAP");
	Настройки.Вставить("СерверВходящейПочты", "imap." + ИмяСервераВУчетнойЗаписи);
	Настройки.Вставить("ПортСервераВходящейПочты", 993);
	Настройки.Вставить("ИспользоватьЗащищенноеСоединениеДляВходящейПочты", Истина);
	
	Настройки.Вставить("СерверИсходящейПочты", "smtp." + ИмяСервераВУчетнойЗаписи);
	Настройки.Вставить("ПортСервераИсходящейПочты", 465);
	Настройки.Вставить("ИспользоватьЗащищенноеСоединениеДляИсходящейПочты", Истина);
	Настройки.Вставить("ТребуетсяВходНаСерверПередОтправкой", Ложь);
	
	Настройки.Вставить("ДлительностьОжиданияСервера", 30);
	Настройки.Вставить("ОставлятьКопииПисемНаСервере", Истина);
	Настройки.Вставить("УдалятьПисьмаССервераЧерез", 0);
	
	Возврат Настройки;
	
КонецФункции

Функция РежимЗагрузкиНовыеСообщения() Экспорт
	
	Возврат "РежимЗагрузкиНовыеСообщения";
	
КонецФункции

Функция РежимЗагрузкиПредыдущиеСообщения() Экспорт
	
	Возврат "РежимЗагрузкиПредыдущиеСообщения";
	
КонецФункции

Функция КомандаОтветить() Экспорт
	
	Возврат "КомандаОтветить";
	
КонецФункции

Функция КомандаПереслать() Экспорт
	
	Возврат "КомандаПереслать";
	
КонецФункции

Функция КомандаОтветитьВсем() Экспорт
	
	Возврат "КомандаОтветитьВсем";
	
КонецФункции

Функция ИмяСобытияУчетнаяЗаписьОбновлена() Экспорт
	
	Возврат "УчетнаяЗаписьОбновлена";
	
КонецФункции

Функция ИмяСобытияИзмененСоставПодключенныхУчетныхЗаписей() Экспорт
	
	Возврат "ИзмененСоставПодключенныхУчетныхЗаписей";
	
КонецФункции

Функция ИмяСобытияУчетнаяЗаписьЗаписана() Экспорт
	
	Возврат "Запись_УчетнаяЗаписьЭлектроннойПочты"
	
КонецФункции

// Удаляет угловые скобки (<>) с начала и конца строки, если они есть.
//
// Параметры:
//  Строка - входная строка;
//
// Возвращаемое значение:
//  Строка - строка без угловых скобок (<>).
// 
Функция СократитьУгловыеСкобки(Знач Строка) Экспорт
	
	Пока СтрНачинаетсяС(Строка, "<") Цикл
		Строка = Сред(Строка, 2);
	КонецЦикла; 
	
	Пока СтрЗаканчиваетсяНа(Строка, ">") Цикл
		Строка = Лев(Строка, СтрДлина(Строка) - 1);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Строка) И СтрДлина(Строка) > 1 Тогда
		Строка = ОбщегоНазначенияКлиентСервер.УдалитьНедопустимыеСимволыXML(Строка);
	КонецЕсли;
	
	Возврат Строка;
	
КонецФункции

Функция МаксимальноеКоличествоПакетноСопоставляемыхАдресов() Экспорт
	
	Возврат 1000;
	
КонецФункции

// Возвращает блок для подписи с необходимым CSS-классом
//
// Параметры:
//  СодержаниеПодписи - верстка содержания подписи
// 
// Возвращаемое значение:
//  Строка - верстка подписи с её содержанием
//
Функция ВерсткаПодписи(СодержаниеПодписи) Экспорт
	
	Если ПустаяСтрока(СодержаниеПодписи) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат СтрШаблон("<div><br></div><div class='signature'>%1</div><div><br></div>", СодержаниеПодписи);
	
КонецФункции

Функция СсылкаБезопасна(Знач Ссылка, Знач ПредставлениеСсылки = "") Экспорт
	
	Ссылка = НРег(Ссылка);
	
	Если СтрНачинаетсяС(Ссылка, ПолучитьНавигационнуюСсылкуИнформационнойБазы()) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если СтрНачинаетсяС(Ссылка, "e1cib/")
		Или СтрНачинаетсяС(Ссылка, "e1ccs/")
		Или СтрНачинаетсяС(Ссылка, "e1c:")
		Или СтрНачинаетсяС(Ссылка, "tel:")
		Или СтрНачинаетсяС(Ссылка, "mailto:")
		Или СтрНачинаетсяС(Ссылка, "v8doc:")
		Или СтрНачинаетсяС(Ссылка, "v8help:")
		Или СтрНачинаетсяС(Ссылка, "skype:")Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если СтрНачинаетсяС(Ссылка, "javascript:") Или СтрНачинаетсяС(Ссылка, "data:") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СтруктураСсылки = ОбщегоНазначенияКлиентСервер.СтруктураURI(Ссылка);
	
	Если Не ПустаяСтрока(СтруктураСсылки.Схема) Тогда
		
		СхемыНаПроверку = Новый Массив;
		СхемыНаПроверку.Добавить("http");
		СхемыНаПроверку.Добавить("https");
		СхемыНаПроверку.Добавить("ftp");
		СхемыНаПроверку.Добавить("sftp");
		СхемыНаПроверку.Добавить("file");
		СхемыНаПроверку.Добавить("telnet");
		Если СхемыНаПроверку.Найти(СтруктураСсылки.Схема) = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Хост = СтруктураСсылки.Хост;
	
	Если ПустаяСтрока(Хост) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ПустаяСтрока(СтруктураСсылки.Логин)
		Или Не ПустаяСтрока(СтруктураСсылки.Пароль)
		Или Не ПустаяСтрока(СтруктураСсылки.Порт) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если СтрНайти(Ссылка, "@") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если СтрНайти(СтруктураСсылки.ПутьНаСервере, "://") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если СтрНачинаетсяС(Хост, "www") И Не Сред(Хост, 4, 1) = "." Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ЕстьЛатинскиеБуквыВСтроке(СтруктураСсылки.Хост) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПустаяСтрока(ПредставлениеСсылки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат СсылкаБезопаснаСПредставлением(СтруктураСсылки, ПредставлениеСсылки);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ЭтоЯщикВходящие(ИмяЯщика) Экспорт
	
	ШаблоныИменПочтовыхЯщиков = Новый Массив;
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("Inbox"));
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("Входящие"));
	Возврат ИмяТекущегоЯщикаПодходитПодШаблоны(ИмяЯщика, ШаблоныИменПочтовыхЯщиков);
	
КонецФункции

Функция ЭтоЯщикОтправленные(ИмяЯщика) Экспорт
	
	ШаблоныИменПочтовыхЯщиков = Новый Массив;
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("Sent"));
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("SentBox"));
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("inbox.sent"));
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("Отправленные"));
	Возврат ИмяТекущегоЯщикаПодходитПодШаблоны(ИмяЯщика, ШаблоныИменПочтовыхЯщиков);
	
КонецФункции

Функция ЭтоЯщикСПАМ(ИмяЯщика) Экспорт
	
	ШаблоныИменПочтовыхЯщиков = Новый Массив;
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("SPAM"));
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("Спам"));
	Возврат ИмяТекущегоЯщикаПодходитПодШаблоны(ИмяЯщика, ШаблоныИменПочтовыхЯщиков);
	
КонецФункции

Функция ЭтоЯщикЧерновики(ИмяЯщика) Экспорт
	
	ШаблоныИменПочтовыхЯщиков = Новый Массив;
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("Drafts"));
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("Черновики"));
	Возврат ИмяТекущегоЯщикаПодходитПодШаблоны(ИмяЯщика, ШаблоныИменПочтовыхЯщиков);
	
КонецФункции

Функция ЭтоЯщикУдаленные(ИмяЯщика) Экспорт
	
	ШаблоныИменПочтовыхЯщиков = Новый Массив;
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("Trash"));
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("Удаленные"));
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("Корзина"));
	Возврат ИмяТекущегоЯщикаПодходитПодШаблоны(ИмяЯщика, ШаблоныИменПочтовыхЯщиков);
	
КонецФункции

Функция ЭтоЯщикИсходящие(ИмяЯщика) Экспорт
	
	ШаблоныИменПочтовыхЯщиков = Новый Массив;
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("Outbox"));
	ШаблоныИменПочтовыхЯщиков.Добавить(НРег("Исходящие"));
	Возврат ИмяТекущегоЯщикаПодходитПодШаблоны(ИмяЯщика, ШаблоныИменПочтовыхЯщиков);
	
КонецФункции

Функция ИмяСерверногоОповещения() Экспорт
	
	Возврат "CRM.ЭлектроннаяПочта";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИфункции

#Область ПроверкаСсылкиНаБезопасность

Функция ЕстьЛатинскиеБуквыВСтроке(СтрокаНаПроверку)
	
	Буквы = "abcdefghijklmnopqrstuvwxyz";
	
	Для Индекс = 1 По 26 Цикл
		
		Буква = Сред(Буквы, Индекс, 1);
		
		Если СтрНайти(СтрокаНаПроверку, Буква) Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция СсылкаБезопаснаСПредставлением(СтруктураСсылки, Знач Представление)
	
	Представление = НРег(Представление);
	
	Если СтрНачинаетсяС(Представление, "e1cib/")
		Или СтрНачинаетсяС(Представление, "e1ccs/")
		Или СтрНачинаетсяС(Представление, "e1c:")
		Или СтрНачинаетсяС(Представление, "tel:")
		Или СтрНачинаетсяС(Представление, "mailto:")
		Или СтрНачинаетсяС(Представление, "v8doc:")
		Или СтрНачинаетсяС(Представление, "v8help:")
		Или СтрНачинаетсяС(Представление, "skype:") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СтруктураПредставления = ОбщегоНазначенияКлиентСервер.СтруктураURI(Представление);
	
	Если ПустаяСтрока(СтруктураПредставления.Схема) Тогда
		
		Если ПустаяСтрока(СтруктураПредставления.ПутьНаСервере) Тогда
			Возврат Истина;
		КонецЕсли;
		
	Иначе
		
		Если СтруктураСсылки.Схема <> СтруктураПредставления.Схема Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	ПутьНаСервереСсылки = СтруктураСсылки.ПутьНаСервере;
	ПутьНаСервереПредставления = СтруктураПредставления.ПутьНаСервере;
	
	ДлинаСтроки = СтрДлина(ПутьНаСервереСсылки);
	Если СтрЗаканчиваетсяНа(ПутьНаСервереСсылки, "/") Тогда
		ПутьНаСервереСсылки = Лев(ПутьНаСервереСсылки, ДлинаСтроки - 1);
	КонецЕсли;
	Если СтрЗаканчиваетсяНа(ПутьНаСервереСсылки, "\") Тогда
		ПутьНаСервереСсылки = Лев(ПутьНаСервереСсылки, ДлинаСтроки - 1);
	КонецЕсли;
	
	ДлинаСтроки = СтрДлина(ПутьНаСервереПредставления);
	Если СтрЗаканчиваетсяНа(ПутьНаСервереПредставления, "/") Тогда
		ПутьНаСервереПредставления = Лев(ПутьНаСервереПредставления, ДлинаСтроки - 1);
	КонецЕсли;
	Если СтрЗаканчиваетсяНа(ПутьНаСервереПредставления, "\") Тогда
		ПутьНаСервереПредставления = Лев(ПутьНаСервереПредставления, ДлинаСтроки - 1);
	КонецЕсли;
	
	Если СтруктураСсылки.Хост <> СтруктураПредставления.Хост
		Или ПутьНаСервереСсылки <> ПутьНаСервереПредставления Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

Функция ИмяТекущегоЯщикаПодходитПодШаблоны(Знач ИмяТекущегоЯщика, ШаблоныИмен)
	
	ИмяТекущегоЯщика = НРег(ИмяТекущегоЯщика);
	Для каждого ИмяЯщика Из ШаблоныИмен Цикл
		Если СтрНайти(ИмяТекущегоЯщика, НРег(ИмяЯщика)) <> 0 Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
	
КонецФункции

#КонецОбласти
