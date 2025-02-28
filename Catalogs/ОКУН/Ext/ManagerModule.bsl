﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
	
Процедура ЗагрузитьКлассификатор() Экспорт
	
	// Получим список уже загруженных кодов
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОКУН.Ссылка
	|ИЗ
	|	Справочник.ОКУН КАК ОКУН";
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Макет = Справочники.ОКУН.ПолучитьМакет("ОКУН");
	ТабЗн = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет.ПолучитьТекст()).Данные;
	СоответствиеСозданных = Новый Соответствие;
	
	НачатьТранзакцию();
	
	Для Каждого строка Из ТабЗн Цикл
		
		Родитель = Справочники.ОКУН.ПустаяСсылка();
		
		Если строка.Service = "00" 
			И строка.Type = "0" 
			И строка.SubGroup = "0" Тогда
			
			Родитель = Справочники.ОКУН.ПустаяСсылка();
			
		ИначеЕсли строка.Service = "00" 
			И строка.Type = "0" Тогда
			
			Родитель = СоответствиеСозданных[строка.Group + "0000"];
			
		ИначеЕсли строка.Service = "00" Тогда
			Родитель = СоответствиеСозданных[строка.Group + строка.SubGroup+"000"];
		Иначе
			Родитель = СоответствиеСозданных[строка.Group + строка.SubGroup+строка.Type+ "00"];
		КонецЕсли;
		
		Эл = Справочники.ОКУН.СоздатьЭлемент();
		эл.Код = строка.Group + строка.SubGroup + строка.Type + строка.Service;
		эл.КЧ = строка.CN;
		эл.НаименованиеУслуги = строка.Description;
		эл.ПолноеОписание = строка.FullDescription;
		эл.Родитель = Родитель;
		эл.ОбменДанными.Загрузка = Истина;
		эл.Записать();
		
		Если строка.Service = "00" Тогда
			СоответствиеСозданных.Вставить(эл.Код, эл.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура ПроставитьВидДеятельностиОКУН() Экспорт
	
	Макет = Справочники.ОКУН.ПолучитьМакет("ОКУНПоВидамДеятельности");
	ТабЗн = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет.ПолучитьТекст()).Данные;
	
	ТабДляЗагрузки = Новый ТаблицаЗначений;
	ТабДляЗагрузки.Колонки.Добавить("Code", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(6)));
	ТабДляЗагрузки.Колонки.Добавить("EntrType", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(2)));
	
	Для Каждого Строка  Из ТабЗн Цикл
		ЗаполнитьЗначенияСвойств(ТабДляЗагрузки.Добавить(), Строка);
	КонецЦикла;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТабЗН.Code КАК ОКУН,
	|	ТабЗН.EntrType КАК КодВидаДеятельности
	|ПОМЕСТИТЬ втТабЗн
	|ИЗ
	|	&ТабЗН КАК ТабЗН
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СправочникОКУН.Ссылка КАК Ссылка,
	|	втТабЗн.КодВидаДеятельности КАК КодВидаДеятельности
	|ИЗ
	|	Справочник.ОКУН КАК СправочникОКУН
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втТабЗн КАК втТабЗн
	|		ПО СправочникОКУН.Код = втТабЗн.ОКУН");
	
	Запрос.УстановитьПараметр("ТабЗН", ТабДляЗагрузки);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НачатьТранзакцию();
	
	Пока Выборка.Следующий() Цикл
		
		мОбъект = Выборка.Ссылка.ПолучитьОбъект();
		мОбъект.КодВидаДеятельности = Выборка.КодВидаДеятельности;
		мОбъект.Записать();
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура ОбновитьОКУН() Экспорт
	
	// Помечаем на удаление неактуальные
	МассивУдаляемыхЭлементов = Новый Массив;
	МассивУдаляемыхЭлементов.Добавить("019201");
	МассивУдаляемыхЭлементов.Добавить("019202");
	МассивУдаляемыхЭлементов.Добавить("019324");
	МассивУдаляемыхЭлементов.Добавить("019325");
	МассивУдаляемыхЭлементов.Добавить("019326");
	МассивУдаляемыхЭлементов.Добавить("019327");
	МассивУдаляемыхЭлементов.Добавить("019329");
	МассивУдаляемыхЭлементов.Добавить("019331");
	МассивУдаляемыхЭлементов.Добавить("019332");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОКУН.Ссылка
	|ИЗ
	|	Справочник.ОКУН КАК ОКУН
	|ГДЕ
	|	ОКУН.Код В(&МассивКодов)";
	Запрос.УстановитьПараметр("МассивКодов",МассивУдаляемыхЭлементов);
	ВыборкаУдаляемых = Запрос.Выполнить().Выбрать();
	Пока ВыборкаУдаляемых.Следующий() Цикл
		ЭлементОКУН = ВыборкаУдаляемых.Ссылка.ПолучитьОбъект();
		ЭлементОКУН.УстановитьПометкуУдаления(Истина);
		ЭлементОКУН.КодВидаДеятельности = "";
		ЭлементОКУН.Записать();
	КонецЦикла;
	
	// Изменяем изменяемые
	МассивИзменяемых = Новый Массив;
	СоответствиеИзменяемых = Новый Соответствие;
	МассивИзменяемых.Добавить("019322");
	СоответствиеИзменяемых.Вставить("019322", "Простой и сложный грим лица, макияж");
	
	МассивИзменяемых.Добавить("019323");
	СоответствиеИзменяемых.Вставить("019323", "Окраска бровей и ресниц, коррекция формы бровей, наращивание ресниц, завивка ресниц");
	
	МассивИзменяемых.Добавить("019328");
	СоответствиеИзменяемых.Вставить("019328", "Гигиенический маникюр с покрытием и без покрытия ногтей лаком. Комплексный уход за кожей кистей рук. Наращивание ногтей");
	
	МассивИзменяемых.Добавить("019330");
	СоответствиеИзменяемых.Вставить("019330", "Гигиенический педикюр с покрытием и без покрытия ногтей лаком. Комплексный уход за кожей стоп, включая удаление огрубелостей и омозолелостей. Наращивание ногтей");
	
	МассивИзменяемых.Добавить("019338");
	СоответствиеИзменяемых.Вставить("019338", "Косметический татуаж (художественная татуировка, перманентный макияж), бодиарт, пирсинг мочки уха, косметический комплексный уход за кожей тела, удаление волос с помощью косметических средств");
	
	Запрос.УстановитьПараметр("МассивКодов",МассивИзменяемых);
	
	ВыборкаИзменяемых = Запрос.Выполнить().Выбрать();
	Пока ВыборкаИзменяемых.Следующий() Цикл
		ЭлементОКУН = ВыборкаИзменяемых.Ссылка.ПолучитьОбъект();
		НовоеНаименование = СоответствиеИзменяемых.Получить(ЭлементОКУН.Код);
		
		Если НовоеНаименование = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементОКУН.НаименованиеУслуги = НовоеНаименование;
		ЭлементОКУН.ПолноеОписание = НовоеНаименование;
		ЭлементОКУН.Записать();
	КонецЦикла;
	
	// Добавляем новые
	Родитель = Справочники.ОКУН.НайтиПоКоду("019300");
	
	Эл = Справочники.ОКУН.НайтиПоКоду("019324");
	Если ЗначениеЗаполнено(Эл) Тогда
		Эл = Эл.ПолучитьОбъект();
		Эл.УстановитьПометкуУдаления(Ложь);
	Иначе
		Эл = Справочники.ОКУН.СоздатьЭлемент();
	КонецЕсли;
	эл.Код = "019324";
	эл.КЧ = 3;
	эл.НаименованиеУслуги = "СПА-уход по телу, включая гигиенические, релаксирующие, эстетические методы с использованием косметических средств, природных и преформированных факторов воздействия";
	эл.ПолноеОписание = "СПА-уход по телу, включая гигиенические, релаксирующие, эстетические методы с использованием косметических средств, природных и преформированных факторов воздействия";
	эл.Родитель = Родитель;
	эл.КодВидаДеятельности = "01";
	эл.Записать();

	Эл = Справочники.ОКУН.НайтиПоКоду("019325");
	Если ЗначениеЗаполнено(Эл) Тогда
		Эл = Эл.ПолучитьОбъект();
		Эл.УстановитьПометкуУдаления(Ложь);
	Иначе
		Эл = Справочники.ОКУН.СоздатьЭлемент();
	КонецЕсли;
	эл.Код = "019325";
	эл.КЧ = 4;
	эл.НаименованиеУслуги = "Косметические маски по уходу за кожей лица и шеи с применением косметических средств";
	эл.ПолноеОписание = "Косметические маски по уходу за кожей лица и шеи с применением косметических средств";
	эл.Родитель = Родитель;
	эл.КодВидаДеятельности = "01";
	эл.Записать();

	Эл = Справочники.ОКУН.НайтиПоКоду("019326");
	Если ЗначениеЗаполнено(Эл) Тогда
		Эл = Эл.ПолучитьОбъект();
		Эл.УстановитьПометкуУдаления(Ложь);
	Иначе
		Эл = Справочники.ОКУН.СоздатьЭлемент();
	КонецЕсли;
	эл.Код = "019326";
	эл.КЧ = 8;
	эл.НаименованиеУслуги = "Гигиенический массаж лица и шеи, включая эстетический, стимулирующий, дренажный, аппаратный массаж, СПА-массаж";
	эл.ПолноеОписание = "Гигиенический массаж лица и шеи, включая эстетический, стимулирующий, дренажный, аппаратный массаж, СПА-массаж";
	эл.Родитель = Родитель;
	эл.КодВидаДеятельности = "01";
	эл.Записать();
	
	Эл = Справочники.ОКУН.НайтиПоКоду("019327");
	Если ЗначениеЗаполнено(Эл) Тогда
		Эл = Эл.ПолучитьОбъект();
		Эл.УстановитьПометкуУдаления(Ложь);
	Иначе
		Эл = Справочники.ОКУН.СоздатьЭлемент();
	КонецЕсли;
	эл.Код = "019327";
	эл.КЧ = 5;
	эл.НаименованиеУслуги = "Косметический комплексный уход за кожей лица и шеи, включая тестирование кожи, чистку, косметическое очищение, глубокое очищение, тонизирование, гигиенический массаж, маску, защиту, макияж, подбор средств для домашнего ухода";
	эл.ПолноеОписание = "Косметический комплексный уход за кожей лица и шеи, включая тестирование кожи, чистку, косметическое очищение, глубокое очищение, тонизирование, гигиенический массаж, маску, защиту, макияж, подбор средств для домашнего ухода";
	эл.Родитель = Родитель;
	эл.КодВидаДеятельности = "01";
	эл.Записать();
	
КонецПроцедуры

// Возвращает реквизиты справочника, которые образуют естественный ключ
//  для элементов справочника.
//
// Возвращаемое значение: Массив(Строка) - массив имен реквизитов, образующих
//  естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив();
	
	Результат.Добавить("Код");
	Результат.Добавить("ПометкаУдаления");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли