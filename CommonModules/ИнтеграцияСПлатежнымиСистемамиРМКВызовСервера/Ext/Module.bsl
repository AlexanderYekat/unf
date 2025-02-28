﻿
#Область ПрограммныйИнтерфейс

// Функция получает данные для работы формы помощника печати кассовых ссылок
// Параметры:
//  ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектРМК - подразделение кассы ккм;
//  Организация - ОпределяемыйТип.ОрганизацияРМК - организация кассы ккм;
//  КассаККМ - ОпределяемыйТип.КассаККМРМК - настраиваемая касса
//  Интеграция - ОпределяемыйТип.НастройкиИнтеграцииСПлатежнымиСистемамиРМК - настройки подключения к платежной системе
// Возвращаемое значение:
//  Структура - данные настроек кассы ккм
//
Функция ИнициализироватьНастройкиКассовыхСсылок(ТорговыйОбъект, Организация, КассаККМ = Неопределено, Интеграция = Неопределено) Экспорт

	НастройкиКассовыхСсылокСБП = Новый Структура;
    РеквизитыКассы			   = Новый Структура;
	
	РеквизитыКассы.Вставить("ТорговыйОбъект", 	ТорговыйОбъект);
	РеквизитыКассы.Вставить("Организация", 		Организация);
	РеквизитыКассы.Вставить("КассаККМ", 		КассаККМ);
	
	НастройкиПодключения       = РегистрыСведений.СоответствиеНастроекИнтеграцииРМК.НастройкиИнтеграции(
			РеквизитыКассы.Организация,
			РеквизитыКассы.ТорговыйОбъект);

	СписокСпособовОплаты		= Новый СписокЗначений;
	
	Если НастройкиПодключения <> Неопределено Тогда
		
		Если ЗначениеЗаполнено(Интеграция) Тогда
			НастройкиПодключения = НастройкиПодключения.Скопировать(Новый Структура("Интеграция", Интеграция));
		КонецЕсли;
		
		НастройкиПодключения.Колонки.Добавить("НастройкиТорговойТочки");
		
		Для Каждого НастройкаПодключения Из НастройкиПодключения Цикл   

			Если НастройкаПодключения.ПлатежнаяСистема = Перечисления.ТипыПлатежнойСистемыККТ.СистемаБыстрыхПлатежей Тогда
				
				НастройкиТорговойТочки = ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НовыйНастройкиТорговойТочки();
				ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.ЗаполнитьНастройкиТорговойТочки(
					НастройкиТорговойТочки, 
					НастройкаПодключения.Интеграция);

				Если НастройкиТорговойТочки.ВыборПлатежнойСистемыВозврата
					И НастройкиТорговойТочки.ПлатежныеСистемыВозврата = Неопределено Тогда
					НастройкиТорговойТочки.ПлатежныеСистемыВозврата = ПереводыСБПc2b.УчастникиСБПДляВозврата();
				КонецЕсли;
					
				НастройкаПодключения.НастройкиТорговойТочки = НастройкиТорговойТочки;
			
				Если НастройкиТорговойТочки.КассовыеСсылки Тогда
					СписокСпособовОплаты.Добавить(НастройкаПодключения.СпособОплаты);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;

		НастройкиПодключенияМассив = ОбщегоНазначения.ТаблицаЗначенийВМассив(НастройкиПодключения);
		
	КонецЕсли;			
	
	Если ЗначениеЗаполнено(КассаККМ) Тогда
		
		КассовыеСсылкиСБП = ПолучитьНастройкиКассовойСсылкиСБП(КассаККМ);
		
		Если СписокСпособовОплаты.НайтиПоЗначению(КассовыеСсылкиСБП.СпособОплатыДляПечати) = Неопределено Тогда
			КассовыеСсылкиСБП.СпособОплатыДляПечати = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	НастройкиКассовыхСсылокСБП.Вставить("РеквизитыКассы", 		РеквизитыКассы);      
	НастройкиКассовыхСсылокСБП.Вставить("НастройкиПодключения",	НастройкиПодключенияМассив);
	НастройкиКассовыхСсылокСБП.Вставить("СписокСпособовОплаты", СписокСпособовОплаты);
	НастройкиКассовыхСсылокСБП.Вставить("КассовыеСсылки", 		КассовыеСсылкиСБП);

	Возврат НастройкиКассовыхСсылокСБП;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьНастройкиКассовойСсылкиСБП(КассаККМ) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	КассовыеСсылкиСБП 				= Новый Структура;
	ИспользоватьКассовыйQRКодСБП	= Ложь;	
	СпособыОплаты					= Новый Соответствие;	
	СпособОплатыДляПечати			= Неопределено;
	
	Если ЗначениеЗаполнено(КассаККМ) Тогда
		
		ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.ПолучитьНастройкиКассовогоQRКода(
			КассаККМ,
			ИспользоватьКассовыйQRКодСБП,
			СпособыОплаты);
			
		Если СпособыОплаты.Количество() Тогда
			
			Для Каждого СпособОплатыПараметры Из СпособыОплаты Цикл
				СпособОплатыДляПечати = СпособОплатыПараметры.Ключ;
			КонецЦикла;
			
		КонецЕсли;
			
	КонецЕсли;
	
	КассовыеСсылкиСБП.Вставить("ИспользоватьКассовыйQRКодСБП", 	ИспользоватьКассовыйQRКодСБП);
	КассовыеСсылкиСБП.Вставить("СпособыОплаты", 				СпособыОплаты);
	КассовыеСсылкиСБП.Вставить("СпособОплатыДляПечати", 		СпособОплатыДляПечати);

	Возврат КассовыеСсылкиСБП;
	
КонецФункции

Функция ПолучитьПараметрыДокументаОплаты(ЧекККМПродажа) Экспорт
	
	ПараметрыВозврата = Новый Структура("ВидОплатыВозврата");
	
	ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.ЗаполнитьПараметрыДокументаОплаты(ПараметрыВозврата, ЧекККМПродажа);
	
	Возврат ПараметрыВозврата;
	
КонецФункции

Функция ТорговыеТочкиОперации(ДокументОперации) Экспорт
	
	ТорговыеТочки = ОбщегоНазначения.ОбщийМодуль("ПереводыСБПc2b").ТорговыеТочкиОперации(ДокументОперации);
	
	Возврат ТорговыеТочки;
	
КонецФункции

Функция НастройкиТорговойТочки(Интеграция, КассаККМ = Неопределено
	) Экспорт
	
	НастройкиИнтеграции = ИнтеграцияСПлатежнымиСистемамиРМККлиентСервер.НовыйНастройкиТорговойТочки();
	
	ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.ЗаполнитьНастройкиТорговойТочки(НастройкиИнтеграции, Интеграция);

	Если НастройкиИнтеграции.ВыборПлатежнойСистемыВозврата
		И НастройкиИнтеграции.ПлатежныеСистемыВозврата = Неопределено Тогда
		НастройкиИнтеграции.ПлатежныеСистемыВозврата = ПереводыСБПc2b.УчастникиСБПДляВозврата();
	КонецЕсли;
	
	Если НастройкиИнтеграции.КассовыеСсылки
		И ЗначениеЗаполнено(КассаККМ) Тогда
		НастройкиКассовойСсылки = ПолучитьНастройкиКассовойСсылкиСБП(КассаККМ);
	КонецЕсли;
	
	НастройкиИнтеграции.Вставить("НастройкиКассовойСсылки", НастройкиКассовойСсылки);
	
	Возврат НастройкиИнтеграции;	
	
КонецФункции

Процедура СформироватьДанныеQRКода(СтруктураКода, Интеграция, Идентификатор, УникальныйИдентификатор) Экспорт 
	
	СтруктураКода = Новый Структура;
	СтруктураКода.Вставить("ИдентификаторQRКода", 	Идентификатор);
	СтруктураКода.Вставить("КартинкаQRКода",		Неопределено);
	СтруктураКода.Вставить("ДанныеQRКода",			ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор));

	ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.СформироватьДанныеQRКода(
		СтруктураКода, 
		Интеграция, 
		Идентификатор, 
		УникальныйИдентификатор);
	
КонецПроцедуры

Функция ИдентификаторыОперацииОплаты(Интеграция, ДокументОплаты) Экспорт

	ИдентификаторОплаты = "";
	
	ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.ЗаполнитьИдентификаторыОперацииОплаты(
		ИдентификаторОплаты,
		Интеграция, 
		ДокументОплаты);
	
	Возврат ИдентификаторОплаты;
	
КонецФункции

Функция ПолучитьИдентификаторОплаты(ЗаявкаНаОплату, УникальныйИдентификатор) Экспорт
	
	Перем ИспользоватьКассовуюСсылку;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Формирование идентификатора оплаты.'");
	
	Если Не ЗначениеЗаполнено(ЗаявкаНаОплату.ДокументОплаты) Тогда
		
		СтруктураНовойСсылки= Новый Структура("ЧекККМВОбработке");
		ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.ЗаполнитьСсылкуНовогоЧекаККМ(СтруктураНовойСсылки);
		
		ЗаявкаНаОплату.ДокументОплаты = СтруктураНовойСсылки.ЧекККМВОбработке;
		
	КонецЕсли;

	// проверка на кассовую ссылку
	Если ЗаявкаНаОплату.Свойство("ИспользоватьКассовуюСсылку", ИспользоватьКассовуюСсылку)
		И ИспользоватьКассовуюСсылку Тогда
		
		НастройкиКассовойСсылки = ПолучитьНастройкиКассовойСсылкиСБП(ЗаявкаНаОплату.КассаККМ);
		КассоваяСсылка			= ?(НастройкиКассовойСсылки.ИспользоватьКассовыйQRКодСБП,
			НастройкиКассовойСсылки.СпособыОплаты.Получить(ЗаявкаНаОплату.СпособОплаты),
			Неопределено);
		
	КонецЕсли;

	Если КассоваяСсылка <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ЗаявкаНаОплату, КассоваяСсылка);
	КонецЕсли;
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.ИдентификаторОплатыВПлатежнойСистеме",
		ЗаявкаНаОплату,
		ПараметрыВыполнения);
		
	Возврат РезультатВыполнения;
	
КонецФункции
	
Функция ОпределитьСтатусОплатыОплаты(ДокументОплаты, Интеграция, УникальныйИдентификатор) Экспорт
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДокументОплаты", 	ДокументОплаты);
	ПараметрыПроцедуры.Вставить("Интеграция", 		Интеграция);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Проверка статуса оплаты.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.СтатусОплатыВПлатежнойСистеме",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

Функция ВозвратОплаты(ЗаявкаНаВозврат, УникальныйИдентификатор) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Возврат оплаты в платежной системе.'");
	
	Если Не ЗначениеЗаполнено(ЗаявкаНаВозврат.ДокументВозврата) Тогда
		
		СтруктураНовойСсылки			 = Новый Структура("ЧекККМВОбработке");
		ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.ЗаполнитьСсылкуНовогоЧекаККМ(СтруктураНовойСсылки, Истина);
		
		ЗаявкаНаВозврат.ДокументВозврата = СтруктураНовойСсылки.ЧекККМВОбработке;
		
	КонецЕсли;
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.ВозвратОплаты",
		ЗаявкаНаВозврат,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

Функция ПодтвердитьВозврат(ДокументВозврата, Интеграция) Экспорт

	РезультатОперации = Новый Структура;
	РезультатОперации.Вставить("СтатусОперации");  
	РезультатОперации.Вставить("КодОшибки", "МетодНеОпределен");
	РезультатОперации.Вставить("СообщениеОбОшибке", НСтр("ru = 'Метод не определен'"));
	
	ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.ПодтвердитьВозврат(РезультатОперации, ДокументВозврата, Интеграция);

	Возврат РезультатОперации;
	
КонецФункции

Функция ОпределитьСтатусВозврата(ДокументВозврата, Интеграция, УникальныйИдентификатор) Экспорт
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДокументВозврата", ДокументВозврата);
	ПараметрыПроцедуры.Вставить("Интеграция",  		Интеграция);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Проверка статуса возврата.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.СтатусВозвратОплаты",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

Функция ОтменитьОперацию(ДокументОплаты, 
							ОтменаЗаказа, 
							Интеграция, 
							ИдентификаторЗаданияФормированияQRКода, 
							ИдентификаторЗаданияПроверкиСтатуса, 
							ИдентификаторЗаданияВозврата,
							УникальныйИдентификатор) Экспорт

	ОтменитьФоновыеЗадания(ИдентификаторЗаданияФормированияQRКода, 
							ИдентификаторЗаданияПроверкиСтатуса, 
							ИдентификаторЗаданияВозврата);
							
	РезультатОперации = Новый Структура;
	РезультатОперации.Вставить("СтатусОперации");  
	РезультатОперации.Вставить("КодОшибки", "МетодНеОпределен");
	РезультатОперации.Вставить("СообщениеОбОшибке", НСтр("ru = 'Метод не определен'"));

	НастройкиИнтеграции = НастройкиТорговойТочки(Интеграция);

	НастройкиИнтеграции.ОтменаЗаказаДанные 	= ОтменаЗаказа;
	НастройкиИнтеграции.ОтменаЗаказа 		= ОтменаЗаказа <> Неопределено;
	
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Отмена заказа.'");

	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДокументОплаты", 							ДокументОплаты);
	ПараметрыПроцедуры.Вставить("Интеграция", 								Интеграция);
	ПараметрыПроцедуры.Вставить("НастройкиИнтеграции", 						НастройкиИнтеграции);
	ПараметрыПроцедуры.Вставить("ИдентификаторЗаданияФормированияQRКода", 	ИдентификаторЗаданияФормированияQRКода);
	ПараметрыПроцедуры.Вставить("ИдентификаторЗаданияПроверкиСтатуса", 		ИдентификаторЗаданияПроверкиСтатуса);
	ПараметрыПроцедуры.Вставить("ИдентификаторЗаданияВозврата", 			ИдентификаторЗаданияВозврата);
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"ИнтеграцияСПлатежнымиСистемамиРМКПереопределяемый.ОтменитьОперациюВФоне",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
		
	Возврат РезультатВыполнения;
	
КонецФункции

Процедура ОтменитьФоновыеЗадания(ИдентификаторЗаданияФормированияQRКода, 
							ИдентификаторЗаданияПроверкиСтатуса, 
							ИдентификаторЗаданияВозврата) Экспорт
	
	Если ЗначениеЗаполнено(ИдентификаторЗаданияФормированияQRКода) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(
			ИдентификаторЗаданияФормированияQRКода);
		ИдентификаторЗаданияФормированияQRКода = Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторЗаданияВозврата) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(
			ИдентификаторЗаданияВозврата);
		ИдентификаторЗаданияВозврата = Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторЗаданияПроверкиСтатуса) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(
			ИдентификаторЗаданияПроверкиСтатуса);
		ИдентификаторЗаданияПроверкиСтатуса = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
