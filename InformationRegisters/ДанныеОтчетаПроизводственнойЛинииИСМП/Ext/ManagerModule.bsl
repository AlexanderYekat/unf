﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьДанныеПоДокументу(Документ, ВключаяПредставлениеОшибки = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ДанныеОтчетаПроизводственнойЛинииИСМП.ЗначениеШтрихкода         КАК ЗначениеШтрихкода,
	|	ДанныеОтчетаПроизводственнойЛинииИСМП.ЗначениеШтрихкодаУпаковки КАК ЗначениеШтрихкодаУпаковки,
	|	ДанныеОтчетаПроизводственнойЛинииИСМП.ФорматBase64              КАК Форматbase64,
	|	ДанныеОтчетаПроизводственнойЛинииИСМП.КлючЗаписи                КАК КлючЗаписи,
	|
	|	ДанныеОтчетаПроизводственнойЛинииИСМП.НормализованноеЗначениеШтрихкода         КАК НормализованноеЗначениеШтрихкода,
	|	ДанныеОтчетаПроизводственнойЛинииИСМП.НормализованноеЗначениеШтрихкодаУпаковки КАК НормализованноеЗначениеШтрихкодаУпаковки,
	|
	|	ДанныеОтчетаПроизводственнойЛинииИСМП.ТекстОшибкиЗначениеШтрихкода         КАК ТекстОшибкиЗначениеШтрихкода,
	|	ДанныеОтчетаПроизводственнойЛинииИСМП.ТекстОшибкиЗначениеШтрихкодаУпаковки КАК ТекстОшибкиЗначениеШтрихкодаУпаковки
	|  //ДополнительныеПоляПредставлениеОшибки
	|ИЗ
	|	РегистрСведений.ДанныеОтчетаПроизводственнойЛинииИСМП КАК ДанныеОтчетаПроизводственнойЛинииИСМП
	|ГДЕ
	|	ДанныеОтчетаПроизводственнойЛинииИСМП.Документ = &Документ";
	
	Запрос.УстановитьПараметр("Документ",    Документ);
	
	Если ВключаяПредставлениеОшибки Тогда

		ДополнительныеПоляПредставлениеОшибки = ",
		|	ДанныеОтчетаПроизводственнойЛинииИСМП.ТекстОшибкиЗначениеШтрихкода
		|		+ &Разделитель
		|		+ ДанныеОтчетаПроизводственнойЛинииИСМП.ТекстОшибкиЗначениеШтрихкодаУпаковки КАК ПредставлениеОшибки,
		|	ВЫБОР
		|		КОГДА ПОДСТРОКА(ДанныеОтчетаПроизводственнойЛинииИСМП.ТекстОшибкиЗначениеШтрихкода, 1, 1) = """"
		|		И ПОДСТРОКА(ДанныеОтчетаПроизводственнойЛинииИСМП.ТекстОшибкиЗначениеШтрихкодаУпаковки, 1, 1) = """"
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЕстьОшибки";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "//ДополнительныеПоляПредставлениеОшибки", ДополнительныеПоляПредставлениеОшибки);
		
		Запрос.УстановитьПараметр("Разделитель", Символы.ПС);
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура СохранитьДанныеОтчетаПроизводственнойЛинииПоДокументу(ДокументСсылка, ДанныеОтчета, ПолныеДанныеОтчета) Экспорт
	
	НаборЗаписей = РегистрыСведений.ДанныеОтчетаПроизводственнойЛинииИСМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(ДокументСсылка);
		
	Если ПолныеДанныеОтчета Тогда
		
		НаборЗаписей.Загрузить(ДанныеОтчета);
		НаборЗаписей.Записать(Истина);
		
	Иначе
		
		НаборЗаписей.Прочитать();
		
		Если ДанныеОтчета.Количество() > 5000 Тогда
			
			ДанныеРегистра = НаборЗаписей.Выгрузить();
			ДанныеРегистра.Индексы.Добавить("ЗначениеШтрихкода, ЗначениеШтрихкодаУпаковки");
			
			СтруктураПоиска = Новый Структура("ЗначениеШтрихкода, ЗначениеШтрихкодаУпаковки");
			Для Каждого СтрокаДанных Из ДанныеОтчета Цикл
				
				Если ЗначениеЗаполнено(СтрокаДанных.ТекстОшибкиЗначениеШтрихкода)
					Или ЗначениеЗаполнено(СтрокаДанных.ТекстОшибкиЗначениеШтрихкодаУпаковки) Тогда
					
					ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаДанных);
					НайденныеСтрокиДокумента = ДанныеРегистра.НайтиСтроки(СтруктураПоиска);
					Если НайденныеСтрокиДокумента <> Неопределено Тогда
						Для Каждого СтрокаДокумента Из НайденныеСтрокиДокумента Цикл
							ЗаполнитьЗначенияСвойств(СтрокаДокумента, СтрокаДанных);
						КонецЦикла;
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла;
			
			НаборЗаписей.Загрузить(ДанныеРегистра);
			НаборЗаписей.Записать(Истина);
			
		Иначе
			
			Запрос = Новый Запрос;
			Запрос.Текст =   "ВЫБРАТЬ
			                  |	&Документ                              КАК Документ,
			                  |	ДанныеОтчета.КлючЗаписи                КАК КлючЗаписи,
			                  |	ДанныеОтчета.ЗначениеШтрихкода         КАК ЗначениеШтрихкода,
			                  |	ДанныеОтчета.ЗначениеШтрихкодаУпаковки КАК ЗначениеШтрихкодаУпаковки,
			                  |
			                  |	ДанныеОтчета.ТекстОшибкиЗначениеШтрихкода         КАК ТекстОшибкиЗначениеШтрихкода,
			                  |	ДанныеОтчета.ТекстОшибкиЗначениеШтрихкодаУпаковки КАК ТекстОшибкиЗначениеШтрихкодаУпаковки
			                  |ПОМЕСТИТЬ ДанныеОтчета
			                  |ИЗ
			                  |	&ДанныеОтчета КАК ДанныеОтчета
			                  |
			                  |ИНДЕКСИРОВАТЬ ПО
			                  |	Документ,
			                  |	ЗначениеШтрихкода,
			                  |	ЗначениеШтрихкодаУпаковки
			                  |;
			                  |
			                  |////////////////////////////////////////////////////////////////////////////////
			                  |ВЫБРАТЬ
			                  |	ДанныеОтчетаПроизводственнойЛинииИСМП.Документ   КАК Документ,
			                  |	ДанныеОтчетаПроизводственнойЛинииИСМП.КлючЗаписи КАК КлючЗаписи,
			                  |	ДанныеОтчетаПроизводственнойЛинииИСМП.ЗначениеШтрихкода         КАК ЗначениеШтрихкода,
			                  |	ДанныеОтчетаПроизводственнойЛинииИСМП.ЗначениеШтрихкодаУпаковки КАК ЗначениеШтрихкодаУпаковки,
			                  |	ДанныеОтчетаПроизводственнойЛинииИСМП.НормализованноеЗначениеШтрихкода         КАК НормализованноеЗначениеШтрихкода,
			                  |	ДанныеОтчетаПроизводственнойЛинииИСМП.НормализованноеЗначениеШтрихкодаУпаковки КАК НормализованноеЗначениеШтрихкодаУпаковки,
			                  |	ДанныеОтчетаПроизводственнойЛинииИСМП.ФорматBase64 КАК ФорматBase64,
			                  |	ДанныеОтчета.ТекстОшибкиЗначениеШтрихкода         КАК ТекстОшибкиЗначениеШтрихкода,
			                  |	ДанныеОтчета.ТекстОшибкиЗначениеШтрихкодаУпаковки КАК ТекстОшибкиЗначениеШтрихкодаУпаковки
			                  |ИЗ
			                  |	РегистрСведений.ДанныеОтчетаПроизводственнойЛинииИСМП КАК ДанныеОтчетаПроизводственнойЛинииИСМП
			                  |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеОтчета КАК ДанныеОтчета
			                  |		ПО ДанныеОтчетаПроизводственнойЛинииИСМП.Документ = ДанныеОтчета.Документ
			                  |			И ДанныеОтчетаПроизводственнойЛинииИСМП.ЗначениеШтрихкода = ДанныеОтчета.ЗначениеШтрихкода
			                  |			И ДанныеОтчетаПроизводственнойЛинииИСМП.ЗначениеШтрихкодаУпаковки = ДанныеОтчета.ЗначениеШтрихкодаУпаковки";
			
			Запрос.УстановитьПараметр("ДанныеОтчета", ДанныеОтчета);
			Запрос.УстановитьПараметр("Документ",     ДокументСсылка);
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				НаборЗаписей = РегистрыСведений.ДанныеОтчетаПроизводственнойЛинииИСМП.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Документ.Установить(Выборка.Документ, Истина);
				НаборЗаписей.Отбор.КлючЗаписи.Установить(Выборка.КлючЗаписи, Истина);
				
				НаборЗаписей.Прочитать();
				ОбновляемаяЗапись = НаборЗаписей[0];
				ЗаполнитьЗначенияСвойств(ОбновляемаяЗапись, Выборка);
				
				НаборЗаписей.Записать(Истина);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли