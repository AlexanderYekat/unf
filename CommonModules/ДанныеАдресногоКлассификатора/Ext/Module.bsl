﻿#Область ПрограммныйИнтерфейс

// Возвращается информация о налоговом органе, который относится к адресу
//
// Параметры:
//  ЗначенияПолейАдреса  - Строка - значение полей адреса в формате XML
//
// Возвращаемое значение:
//   Структура   - реквизиты налоговой инспекции. 
//                 Содержание структуры описано в функции НовыйСведенияОНалоговомОргане()
//
Функция НалоговыйОрганПоАдресу(Знач ЗначенияПолейАдреса) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ЗначенияПолейАдреса) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СведенияОНалоговомОрганеПоАдресу = КодыАдреса(ЗначенияПолейАдреса, "Сервис1С");
	КодИФНСФЛ = Формат(СведенияОНалоговомОрганеПоАдресу.КодИФНСФЛ, "ЧЦ=4; ЧДЦ=; ЧВН=; ЧГ=0");
	КодИФНСЮЛ = Формат(СведенияОНалоговомОрганеПоАдресу.КодИФНСЮЛ, "ЧЦ=4; ЧДЦ=; ЧВН=; ЧГ=0");
	
	Если ЗначениеЗаполнено(КодИФНСФЛ) Или ЗначениеЗаполнено(КодИФНСЮЛ)Тогда
		Сведения = Новый Структура();
		Сведения.Вставить("КодНалоговойДляЮридическихЛиц", КодИФНСЮЛ);
		Сведения.Вставить("КодНалоговойДляФизическихЛиц",  КодИФНСФЛ);
		Сведения.Вставить("КодПоОКТМО", Формат(СведенияОНалоговомОрганеПоАдресу.ОКТМО, "ЧДЦ=; ЧГ=0"));
		Сведения.Вставить("КодПоОКАТО", Формат(СведенияОНалоговомОрганеПоАдресу.OKATO, "ЧДЦ=; ЧГ=0"));
		
		Возврат Сведения;
		
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции


// Определение кодов ОКАТО, ОКТМО, налоговых инспекций ФНС и др. адреса
//
// Параметры:
//  Адрес    - Строка - Адрес в формате XML
//  Источник - Строка - Необязательный. Источник получения кодов адреса:
//             "Сервис1С" - коды будут получены через веб-сервис 1С;
//             "ЗагруженныеДанные" - коды будут определены по загруженным данным адресного классификатора;
//             если параметрам не указан, то источник данных определяется автоматически.
// Возвращаемое значение:
//  Структура - Коды адреса, если адрес не найден, то все поля структуры содержат пустые значения.
//
Функция КодыАдреса(Адрес, Источник = Неопределено) Экспорт
	
	Если Источник = "Сервис1С" Тогда
		
		Если НЕ (ЭтоКонтактнаяИнформацияВXML(Адрес) ИЛИ ТипЗнч(Адрес) = Тип("Структура")) Тогда
			Возврат СтруктураКодовАдреса();
		КонецЕсли;
		
		Возврат КодыАдресаИзСервиса(Адрес).КодыАдреса;
		
	Иначе
		Возврат АдресныйКлассификатор.КодыАдреса(Адрес, Источник);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоКонтактнаяИнформацияВXML(Знач Текст) 
	
	Возврат ТипЗнч(Текст) = Тип("Строка") И СтрНачинаетсяС(СокрЛ(Текст), "<");
	
КонецФункции

Функция СтруктураКодовАдреса()
	Коды = Новый Структура();
	Коды.Вставить("КодКЛАДР");
	Коды.Вставить("Идентификатор");
	Коды.Вставить("OKATO");
	Коды.Вставить("ОКТМО");
	Коды.Вставить("КодИФНСФЛ");
	Коды.Вставить("КодИФНСЮЛ");
	Коды.Вставить("КодУчасткаИФНСФЛ");
	Коды.Вставить("КодУчасткаИФНСЮЛ");
	
	Возврат Коды;
КонецФункции

Функция КодыАдресаИзСервиса(Знач Адрес)
	
	// См. АдресныйКлассификаторСлужебный.КодыАдресаИКодыКЛАДР
	
	Результат = Новый Структура();
	Результат.Вставить("КодыАдреса", СтруктураКодовАдреса());
	
	Если НЕ (ЭтоКонтактнаяИнформацияВXML(Адрес) ИЛИ ТипЗнч(Адрес) = Тип("Структура")) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ЭтоКонтактнаяИнформацияВXML(Адрес) Тогда
		АдресXDTO = ДесериализацияАдресаXDTO(Адрес);
		Адрес = АдресXDTO.Состав.Состав;
	КонецЕсли;
	
	Результат.КодыАдреса = КодыАдресаСервис(Адрес);
	
	ОпределитьФорматКодов(Результат.КодыАдреса);
	
	Возврат Результат;
	
КонецФункции

Процедура ОпределитьФорматКодов(КодыАдреса)
	
	Если ЗначениеЗаполнено(КодыАдреса.ОКТМО) Тогда
		
		ОКТМОЧисло = КодыАдреса.ОКТМО;
		ОКТМОСтрока = Формат(ОКТМОЧисло, "ЧГ=0");
		
		Если СтрДлина(ОКТМОСтрока) < 8 Тогда
			КодыАдреса.ОКТМО = Формат(ОКТМОЧисло, "ЧЦ=8; ЧВН=; ЧГ=0");
		ИначеЕсли СтрДлина(ОКТМОСтрока) = 10 Тогда
			КодыАдреса.ОКТМО = Формат(ОКТМОЧисло, "ЧЦ=11; ЧВН=; ЧГ=0");
		Иначе
			КодыАдреса.ОКТМО = ОКТМОСтрока;
		КонецЕсли
		
	КонецЕсли;
	Если ЗначениеЗаполнено(КодыАдреса.OKATO) Тогда
		КодыАдреса.OKATO = Формат(КодыАдреса.OKATO, "ЧГ=0");
	КонецЕсли;
	
КонецПроцедуры

Функция ПередЧтениемXDTOКонтактнаяИнформация(ТекстXML)
	
	Если СтрНайти(ТекстXML, "Адрес") = 0 Тогда
		Возврат ТекстXML;
	КонецЕсли;
	
	Если СтрНайти(ТекстXML, "http://www.v8.1c.ru/ssl/contactinfo_ru") > 0 Тогда
		Возврат ТекстXML;
	КонецЕсли;
	
	ТекстXML = СтрЗаменить(ТекстXML, "xsi:type=""АдресРФ""", "xmlns:rf=""http://www.v8.1c.ru/ssl/contactinfo_ru"" xsi:type=""rf:АдресРФ""");
	ТекстXML = СтрЗаменить(ТекстXML, "СубъектРФ", "rf:СубъектРФ");
	ТекстXML = СтрЗаменить(ТекстXML, "Округ", "rf:Округ");
	ТекстXML = СтрЗаменить(ТекстXML, "СвРайМО", "rf:СвРайМО");
	ТекстXML = СтрЗаменить(ТекстXML, "<Район>", "<rf:Район>");
	ТекстXML = СтрЗаменить(ТекстXML, "</Район>", "</rf:Район>");
	ТекстXML = СтрЗаменить(ТекстXML, "<Район/>", "<rf:Район/>");
	ТекстXML = СтрЗаменить(ТекстXML, "Город>", "rf:Город>");
	ТекстXML = СтрЗаменить(ТекстXML, "<Город/>", "<rf:Город/>");
	ТекстXML = СтрЗаменить(ТекстXML, "ВнутригРайон", "rf:ВнутригРайон");
	ТекстXML = СтрЗаменить(ТекстXML, "НаселПункт", "rf:НаселПункт");
	
	ТекстXML = СтрЗаменить(ТекстXML, "Улица>", "rf:Улица>");
	ТекстXML = СтрЗаменить(ТекстXML, "<Улица/>", "<rf:Улица/>");
	ТекстXML = СтрЗаменить(ТекстXML, "ОКТМО", "rf:ОКТМО");
	ТекстXML = СтрЗаменить(ТекстXML, "ОКАТО", "rf:ОКАТО");
	ТекстXML = СтрЗаменить(ТекстXML, "ДопАдрЭл", "rf:ДопАдрЭл");
	ТекстXML = СтрЗаменить(ТекстXML, "<Номер", "<rf:Номер");
	ТекстXML = СтрЗаменить(ТекстXML, "Местоположение>", "rf:Местоположение>");
	
	Возврат ТекстXML;
	
КонецФункции

Функция ПространствоИменДляАдресаРФ()
	Возврат "http://www.v8.1c.ru/ssl/contactinfo_ru";
КонецФункции

Функция КодыАдресаСервис(АдресРФ)
	
	Результат = СтруктураКодовАдреса();
	
	АдресаДляПроверки = Новый Массив;
	РезультатВебСервис = Новый Структура("Данные", Новый Массив);
	СтруктураОписанияОшибкиПоставщика(РезультатВебСервис);
	Уровни = УровниКлассификатораФИАС();
	АдресаДляПроверки.Добавить(Новый Структура("Адрес, Уровни", АдресРФ , Уровни));
	Попытка
		ЗаполнитьРезультатПроверкиАдресаПоКлассификаторуСервис1С(РезультатВебСервис, АдресаДляПроверки);
	Исключение
		СтруктураОписанияОшибкиПоставщика(РезультатВебСервис, ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации( СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка, , , РезультатВебСервис.ПодробноеПредставлениеОшибки);
	КонецПопытки;
	
	Если НЕ РезультатВебСервис.Отказ Тогда
		Если РезультатВебСервис.Данные[0].Варианты.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(Результат, РезультатВебСервис.Данные[0].Варианты[0]);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция УровниКлассификатораФИАС()
	
	Уровни = Новый Массив;
	Уровни.Добавить(1);
	Уровни.Добавить(2);
	Уровни.Добавить(3);
	Уровни.Добавить(5);
	Уровни.Добавить(4);
	Уровни.Добавить(6);
	Уровни.Добавить(7);
	Уровни.Добавить(90);
	Уровни.Добавить(91);
	
	Возврат Новый ФиксированныйМассив(Уровни);
КонецФункции

//  Имя событие для записи в журнал регистрации.
//
Функция СобытиеЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Адресный классификатор'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции


Функция СтруктураОписанияОшибкиПоставщика(Описание = Неопределено, ИнформацияОбОшибке = Неопределено)
	
	Если Описание = Неопределено Тогда
		Описание = Новый Структура;
	КонецЕсли;
		
	Описание.Вставить("Отказ", ИнформацияОбОшибке <> Неопределено);
	Описание.Вставить("ПодробноеПредставлениеОшибки");
	Описание.Вставить("КраткоеПредставлениеОшибки");
	
	Если ИнформацияОбОшибке = Неопределено Тогда
		Описание.ПодробноеПредставлениеОшибки = НСтр("ru = 'Информация об ошибке отсутствует'");
		Возврат Описание;
	КонецЕсли;
	
	Описание.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	Текст = СокрЛП(КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	
	Если ТипЗнч(ИнформацияОбОшибке.Причина) = Тип("ИнформацияОбОшибке") Тогда
		Если ИнформацияОбОшибке.Причина.Причина <> Неопределено Тогда
			ОписаниеОшибкиДляПоиска = ВРег(ИнформацияОбОшибке.Причина.Причина.Описание);
			ПозицияНачало = СтрНайти(ОписаниеОшибкиДляПоиска , "<FAULTSTRING>");
			Если ПозицияНачало > 0 Тогда
				ПозицияОкончание = СтрНайти(ОписаниеОшибкиДляПоиска , "</FAULTSTRING>");
				Текст = Сред(ИнформацияОбОшибке.Причина.Причина.Описание, ПозицияНачало + 13,
					ПозицияОкончание - ПозицияНачало - 13);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Отрезаем клиентский текст
	Позиция = СтрНайти(Текст, ": ");
	Если Позиция > 0 Тогда
		Текст = СокрЛ(Сред(СтрЗаменить(Текст, Символы.ПС, ""), Позиция + 1));
	КонецЕсли;
	
	// Отрезаем серверный текст
	Пока Истина Цикл
		Позиция = СтрНайти(Текст, "}:");
		Если Позиция = 0 Тогда
			Прервать;
		КонецЕсли;
		Текст = СокрЛ(Сред(Текст, Позиция + 2));
	КонецЦикла;
	
	Описание.КраткоеПредставлениеОшибки = Текст;
	Возврат Описание;
КонецФункции

Процедура ЗаполнитьРезультатПроверкиАдресаПоКлассификаторуСервис1С(Результат, АдресаДляПроверки)
	
	// См. АдресныйКлассификаторСлужебный.ЗаполнитьРезультатПроверкиАдресаПоКлассификаторуСервис1С
	
	Сервис = СервисКлассификатора1С();
	
	СписокДляПроверки = Сервис.ФабрикаXDTO.Создать(Сервис.ФабрикаXDTO.Тип(ПространствоИмен(), "AddressList"));
	ТипАдреса = Сервис.ФабрикаXDTO.Тип(ПространствоИменАдресаРФ(), "АдресРФ");
	ТипЭлементаСписка = СписокДляПроверки.Свойства().Получить("Item").Тип;
	
	Для Каждого ЭлементПроверки Из АдресаДляПроверки Цикл
		ПроверяемыйАдрес =  СписокДляПроверки.Item.Добавить(Сервис.ФабрикаXDTO.Создать(ТипЭлементаСписка));
		АдресВXML = ОбщегоНазначения.ОбъектXDTOВСтрокуXML(ЭлементПроверки.Адрес);
		АдресВXML = СтрЗаменить(АдресВXML, "http://www.v8.1c.ru/ssl/contactinfo_ru", "http://www.v8.1c.ru/ssl/contactinfo"); // Локализация
		ПроверяемыйАдрес.Address = ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(АдресВXML, Сервис.ФабрикаXDTO);
		ПроверяемыйАдрес.Levels  = ЭлементПроверки.Уровни;
	КонецЦикла;
	
	КодЯзыка = ТекущийКодЛокализации();
	
	РезультатПроверки = Сервис.Analyze(СписокДляПроверки, КодЯзыка, Ложь, Метаданные.Имя);
	
	// Формируем структуру результата.
	Данные = Результат.Данные;
	Для Каждого ЭлементПроверки Из РезультатПроверки.Item Цикл
		ДанныеДляАдреса = Новый Структура("Ошибки, Варианты, АдресПроверен", Новый Массив, Новый Массив, Истина);
		ОшибкиПроверки = ДанныеДляАдреса.Ошибки;
		ВариантыАдреса = ДанныеДляАдреса.Варианты;
		
		Для Каждого Ошибка Из ЭлементПроверки.Error Цикл
			ОшибкаАдреса = Новый Структура("Ключ, Текст, Подсказка", Ошибка.Key, Ошибка.Text, Ошибка.Suggestion);
			ОшибкиПроверки.Добавить(ОшибкаАдреса);
		КонецЦикла;
		
		Для Каждого Вариант Из ЭлементПроверки.Variant Цикл
			ВариантАдреса = Новый Структура("Идентификатор, Индекс, КодКЛАДР", Вариант.ID, Вариант.PostalCode, Вариант.KLADRCode);
			ВариантАдреса.Вставить("OKATO",            Вариант.OKATO);
			ВариантАдреса.Вставить("ОКТМО",            Вариант.OKTMO);
			ВариантАдреса.Вставить("КодИФНСФЛ",        Вариант.IFNSFL);
			ВариантАдреса.Вставить("КодИФНСЮЛ",        Вариант.IFNSUL);
			ВариантАдреса.Вставить("КодУчасткаИФНСФЛ", Вариант.TERRIFNSFL);
			ВариантАдреса.Вставить("КодУчасткаИФНСЮЛ", Вариант.TERRIFNSUL);
			ВариантыАдреса.Добавить(ВариантАдреса);
		КонецЦикла;
		
		Данные.Добавить(ДанныеДляАдреса);
	КонецЦикла;
	
КонецПроцедуры

Функция СервисКлассификатора1С() Экспорт
	
	// См. АдресныйКлассификаторПовтИсп.СервисКлассификатора1С
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Логин =  "fresh";
		Пароль = "fresh";
	Иначе
		Авторизация = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		Если Авторизация = Неопределено Тогда
			Логин  = Неопределено;
			Пароль = Неопределено;
		Иначе
			Логин  = Авторизация.Логин;
			Пароль = Авторизация.Пароль;
		КонецЕсли;
	КонецЕсли;
	
	ТекущийURLВебСервиса = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("АдресныйКлассификатор", "URLСервисаКлассификатора1С");
	Если ТекущийURLВебСервиса = Неопределено Тогда
		ТекущийURLВебСервиса = "https://api.orgaddress.1c.ru/orgaddress/v1?wsdl";
	КонецЕсли;
	
	ПараметрыПодключения = ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
	ПараметрыПодключения.АдресWSDL = ТекущийURLВебСервиса;
	ПараметрыПодключения.URIПространстваИмен = "http://www.v8.1c.ru/ssl/AddressSystem";
	ПараметрыПодключения.ИмяСервиса = "AddressSystem";
	ПараметрыПодключения.ИмяТочкиПодключения = "AddressSystemSoap12";
	ПараметрыПодключения.ИмяПользователя = Логин;
	ПараметрыПодключения.Пароль = Пароль;
	ПараметрыПодключения.Таймаут = 10;
	
	Возврат ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
	
КонецФункции

Функция ДесериализацияАдресаXDTO(Строка)
	ПередЧтениемXDTOКонтактнаяИнформация(Строка);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(Строка);
	
	Тип = ФабрикаXDTO.Тип(ПространствоИменДляАдресаРФ(), "АдресРФ");
	Результат = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	Возврат Результат
КонецФункции

Функция ПространствоИмен()
	Возврат "http://www.v8.1c.ru/ssl/AddressSystem";
КонецФункции

Функция ПространствоИменАдресаРФ()
	Возврат "http://www.v8.1c.ru/ssl/AddressSystem";
КонецФункции


#КонецОбласти
