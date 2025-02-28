﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НачалоДня(Дата) <> НачалоДня(ТекущаяДатаСеанса()) Тогда
		ТекстОшибки = НСтр("ru = 'Не допускается коррекция датой, отличной от текущей'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,, "Дата",, Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КассаККМ)  Тогда
		
		СтруктураСостояниеКассовойСмены = РозничныеПродажиСервер.ПолучитьСостояниеКассовойСмены(КассаККМ);
		
		ОтчетОРозничныхПродажах = СтруктураСостояниеКассовойСмены.ОтчетОРозничныхПродажах;
		
		Если НЕ ЗначениеЗаполнено(ОтчетОРозничныхПродажах) ИЛИ НЕ РозничныеПродажиСервер.СменаОткрыта(ОтчетОРозничныхПродажах, Дата, ТекстОшибки) Тогда
			ТекстОшибки = НСтр("ru = 'Кассовая смена не открыта'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,, "КассаККМ",, Отказ);
		КонецЕсли;
		
		ТипОборудования = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КассаККМ, "ПодключаемоеОборудование.ТипОборудования");
		Если ТипОборудования <> Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
			ТекстОшибки = НСтр("ru = 'Коррекция допускается только при использовании ККТ'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,, "КассаККМ",, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Оплата.Итог("Сумма") <> ПозицииЧека.Итог("СуммаСоСкидками") Тогда
		ТекстОшибки = НСтр("ru = 'Сумма оплат не совпадает с итоговой суммой по позициям чека'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,, "Оплата",, Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПробитЧекПоСсылке = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПробитЧек");
	
	Если ПробитЧекПоСсылке = Истина Тогда
		Текст = НСтр("ru = 'Чек коррекции пробит. Операции над этим документом запрещены'");
		ОбщегоНазначения.СообщитьПользователю(Текст,,,,Отказ);
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Если чек пробит, тогда в любом случае вносим данные в РС СкорректированныеФискальныеОперации
	// независомо от проведения. Данные после пробития не редактируются.
	Если ПробитЧек И НЕ НеприменениеККТ Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СкорректированныеФискальныеОперации.СкорректированныеДокумент КАК СкорректированныеДокумент
		|ИЗ
		|	РегистрСведений.СкорректированныеФискальныеОперации КАК СкорректированныеФискальныеОперации
		|ГДЕ
		|	СкорректированныеФискальныеОперации.СкорректированныеДокумент = &СкорректированныеДокумент";
		
		Запрос.УстановитьПараметр("СкорректированныеДокумент", ДокументОснование);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			
			Менеджер = РегистрыСведений.СкорректированныеФискальныеОперации.СоздатьМенеджерЗаписи();
			
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурнаяЕдиница", ДокументОснование.Метаданные()) Тогда
				Менеджер.СтруктурнаяЕдиница = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "СтруктурнаяЕдиница");
			ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("Подразделение", ДокументОснование.Метаданные()) Тогда
				Менеджер.СтруктурнаяЕдиница = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "Подразделение");
			ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("КассаККМ", ДокументОснование.Метаданные()) Тогда
				Менеджер.СтруктурнаяЕдиница = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "КассаККМ.СтруктурнаяЕдиница");
			КонецЕсли;
			
			Менеджер.СкорректированныеДокумент 				= ДокументОснование;
			Менеджер.ПредставлениеКорректирующегоДокумента 	= Строка(ЭтотОбъект);
			
			Менеджер.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если НЕ ОбъектКопирования.НеприменениеККТ Тогда
		
		Текст = НСтр("ru = 'Можно копировать документы только с признаком ""Неприменение ККТ""'");
		
		ВызватьИсключение(Текст);
		
	КонецЕсли;
	
	НомерСмены = 0;
	НомерЧека  = 0;
	ПробитЧек = Ложь;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ЗначениеЗаполнено(Ответственный.ФизическоеЛицо) Тогда
		СтруктураРеквизитов = Новый Структура;
		СтруктураРеквизитов.Вставить("КассирНаименование", "ФизическоеЛицо.Наименование");
		СтруктураРеквизитов.Вставить("КассирИНН", "ФизическоеЛицо.ИНН");
		РеквизитыКассира = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ответственный, СтруктураРеквизитов);
		
		Кассир 		= РеквизитыКассира.КассирНаименование;
		КассирИНН 	= РеквизитыКассира.КассирИНН;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Если ДанныеЗаполнения.Свойство("КассаККМ") Тогда
			КассаККМ      = ДанныеЗаполнения.КассаККМ;
			СтруктурнаяЕдиница       = КассаККМ.СтруктурнаяЕдиница;
			Организация   = КассаККМ.Владелец;
		КонецЕсли;
		
	КонецЕсли;
	
	НеприменениеККТ = Истина;
	ОписаниеКоррекции = НСтр("ru = 'Неприменение ККТ'");
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли