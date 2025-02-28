﻿
#Область ПрограммныйИнтерфейс

// Добавляет серию в строку
//
// Параметры:
//  НоваяСтрока - Добавляемая строка табличной части
//  Серия - Ссылка на серию номенклатуры
//  ДокОбъект - Объект документа
//  ИмяТЧСерииНоменклатуры - Имя табличной части содержащей серии номенклатуры
//  ИмяТЧЗапасы - Имя табличной части Запасы
//  ИмяПоляКлючСвязи - Имя поля ключа связи
//
Процедура ДобавитьСерияВСтроку(НоваяСтрока, Серия, ДокОбъект, ИмяТЧСерииНоменклатуры = "СерииНоменклатуры", ИмяТЧЗапасы = "Запасы", ИмяПоляКлючСвязи = "КлючСвязи") Экспорт
	
	ОтборСерия = Новый Структура("Серия", Серия);
	
	Если НЕ ДокОбъект.Свойство(ИмяТЧСерииНоменклатуры) Тогда 
		Возврат
	КонецЕсли;
	
	Если ДокОбъект[ИмяТЧСерииНоменклатуры].НайтиСтроки(ОтборСерия).Количество()>0 Тогда
		// Серийный номер уже есть, пропускаем
		Возврат;
	КонецЕсли;
	
	Если НоваяСтрока[ИмяПоляКлючСвязи]=0 Тогда
		ЗаполнитьКлючиСвязиВТабличнойЧастиТовары(ДокОбъект, ИмяТЧЗапасы, ,ИмяПоляКлючСвязи);
	КонецЕсли;
	
	СтрСерииНоменклатуры = ДокОбъект[ИмяТЧСерииНоменклатуры].Добавить();
	СтрСерииНоменклатуры.Серия = Серия;
	СтрСерииНоменклатуры.КлючСвязи = НоваяСтрока[ИмяПоляКлючСвязи];
	
	Если ДокОбъект.СерииНоменклатуры.Количество()>1 Тогда
		ОбновитьСтроковоеПредставлениеСерийНоменклатурыСтроки(НоваяСтрока, ДокОбъект, ИмяПоляКлючСвязи);
	ИначеЕсли НЕ НоваяСтрока = Неопределено И НоваяСтрока.Свойство("СерииНоменклатуры") Тогда
		НоваяСтрока.СерииНоменклатуры = Строка(Серия);
	КонецЕсли;
	
КонецПроцедуры

// Обновляет строковое представление серии номенклатуры
//
// Параметры:
//  СтрокаЗапасы - Строка табличной части
//  ДокОбъект - Объект документа
//  ИмяПоляКлючСвязи - Имя поля ключа связи
//  ИмяТабличнойЧастиСерииНоменклатуры - Имя табличной части содержащей серии номенклатуры
//
Процедура ОбновитьСтроковоеПредставлениеСерийНоменклатурыСтроки(СтрокаЗапасы, ДокОбъект, ИмяПоляКлючСвязи, ИмяТабличнойЧастиСерииНоменклатуры="СерииНоменклатуры") Экспорт
	
	ОтборСерииНоменклатурыТекущейСтроки = Новый Структура("КлючСвязи", СтрокаЗапасы[ИмяПоляКлючСвязи]);
	СтроковоеПредставлениеСерийНоменклатуры = "";
	
	Для Каждого СтрокаЗагрузки Из ДокОбъект[ИмяТабличнойЧастиСерииНоменклатуры].НайтиСтроки(ОтборСерииНоменклатурыТекущейСтроки) Цикл
		СтроковоеПредставлениеСерийНоменклатуры = СтроковоеПредставлениеСерийНоменклатуры + СтрокаЗагрузки.Серия+"; ";
	КонецЦикла;
	
	СтроковоеПредставлениеСерийНоменклатуры = Лев(СтроковоеПредставлениеСерийНоменклатуры, Мин(СтрДлина(СтроковоеПредставлениеСерийНоменклатуры)-2,150));
	Если СтрНайти(ИмяТабличнойЧастиСерииНоменклатуры, "Оприходование") = 0 Тогда
		СтрокаЗапасы.СерииНоменклатуры = СтроковоеПредставлениеСерийНоменклатуры;
	Иначе
		СтрокаЗапасы.СерииНоменклатурыОприходование = СтроковоеПредставлениеСерийНоменклатуры;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает строковое представление серии номенклатуры
//
// Параметры:
//  СерииНоменклатуры - Список серий номенклатуры
//  КлючСвязи - Значение ключа связи
//
Функция СтроковоеПредставлениеСерийНоменклатурыСтроки(СерииНоменклатуры, КлючСвязи) Экспорт
	
	ОтборКлючСвязи = Новый Структура("КлючСвязи", КлючСвязи);
	
	СтроковоеПредставлениеСерийНоменклатуры = "";
	Для Каждого СтрокаОтбора Из СерииНоменклатуры.НайтиСтроки(ОтборКлючСвязи) Цикл
		СтроковоеПредставлениеСерийНоменклатуры = СтроковоеПредставлениеСерийНоменклатуры + СтрокаОтбора.Серия+"; ";
	КонецЦикла;
	
	СтроковоеПредставлениеСерийНоменклатуры = Лев(СтроковоеПредставлениеСерийНоменклатуры, Мин(СтрДлина(СтроковоеПредставлениеСерийНоменклатуры)-2,150));
	Возврат СтроковоеПредставлениеСерийНоменклатуры;
	
КонецФункции

// Заполняет ключи связи в табличной части "Товары" документа.
//
// Параметры:
//  Объект - Объект документа
//  ИмяТЧ - Имя первой таблицы заполнения ключа связи
//  ИмяТЧ2 - Имя второй таблицы заполнения ключа связи
//  ИмяПоляКлючСвязи - Имя поля ключа связи
//
Процедура ЗаполнитьКлючиСвязиВТабличнойЧастиТовары(Объект, ИмяТЧ, ИмяТЧ2 = Неопределено, ИмяПоляКлючСвязи = "КлючСвязи") Экспорт
	
	Для Каждого СтрокаТЧ Из Объект[ИмяТЧ] Цикл
		Если Не ЗначениеЗаполнено(СтрокаТЧ[ИмяПоляКлючСвязи]) Тогда
			ТабличныеЧастиУНФКлиентСервер.ЗаполнитьКлючСвязи(Объект[ИмяТЧ], СтрокаТЧ, ИмяПоляКлючСвязи);
		КонецЕсли;
	КонецЦикла;
	
	Индекс = 0;
	Если Не ИмяТЧ2 = Неопределено Тогда
		Для Каждого СтрокаТЧ Из Объект[ИмяТЧ2] Цикл
			Индекс = Индекс + 1;
			СтрокаТЧ.КлючСвязиДляСкидокНаценок = Индекс;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьКлючиСвязиВТабличнойЧастиТовары()

// Обновляет количество серий номенклатуры
//
// Параметры:
//  Объект - Объект документа
//  СтрокаТабличнойЧасти - Строка табличной части для обновления
//  ИмяТабличнойЧастиСерииНоменклатуры - Имя табличной части с сериями
//  ИмяПоляКлючСвязи - Имя поля ключа связи
//
Процедура ОбновитьСерииНоменклатурыКоличество(Объект, СтрокаТабличнойЧасти, ИмяТабличнойЧастиСерииНоменклатуры="СерииНоменклатуры", ИмяПоляКлючСвязи = "КлючСвязи") Экспорт

	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти[ИмяПоляКлючСвязи]) Тогда
		Возврат;
	КонецЕсли; 
	
	СтруктураПоиска = Новый Структура("КлючСвязи", СтрокаТабличнойЧасти[ИмяПоляКлючСвязи]);
	МассивСНСтроки = Новый ФиксированныйМассив(Объект[ИмяТабличнойЧастиСерииНоменклатуры].НайтиСтроки(СтруктураПоиска));
	
	Если ТипЗнч(СтрокаТабличнойЧасти.ЕдиницаИзмерения)=Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
		Коэффициент = СерииНоменклатурыУНФВызовСервера.КоэффициентЕдиницы(СтрокаТабличнойЧасти.ЕдиницаИзмерения);
	Иначе
		Коэффициент = 1;
	КонецЕсли;
	
	СтрокаЗапасыКоличество = СтрокаТабличнойЧасти.Количество * Коэффициент;
	
	КоличествоСерий = 0;
	Для Каждого СтрокаМассива Из МассивСНСтроки Цикл
		КоличествоСерий = КоличествоСерий + СтрокаМассива.Количество;
	КонецЦикла;
	
	Если СтрокаЗапасыКоличество < КоличествоСерий И СтрокаЗапасыКоличество > 0 Тогда
		
		УдалитьСтроки = Ложь;
		КоличествоСерийПоСтрокамМассива = 0;
		Для Каждого СтрокаМассива Из МассивСНСтроки Цикл
			
			КоличествоСерийПоСтрокамМассива = КоличествоСерийПоСтрокамМассива + СтрокаМассива.Количество;
			
			Если УдалитьСтроки Тогда
				Объект[ИмяТабличнойЧастиСерииНоменклатуры].Удалить(СтрокаМассива);
			ИначеЕсли СтрокаЗапасыКоличество < КоличествоСерийПоСтрокамМассива Тогда
				
				Если СтрокаМассива.Количество = КоличествоСерийПоСтрокамМассива - СтрокаЗапасыКоличество Тогда
					Объект[ИмяТабличнойЧастиСерииНоменклатуры].Удалить(СтрокаМассива);
				Иначе
					СтрокаМассива.Количество = СтрокаМассива.Количество - (КоличествоСерийПоСтрокамМассива - СтрокаЗапасыКоличество);
					
					Если СтрокаМассива.Количество = 0 Тогда
						Объект[ИмяТабличнойЧастиСерииНоменклатуры].Удалить(СтрокаМассива);
					КонецЕсли;
					
				КонецЕсли;
				
				УдалитьСтроки = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

	ОбновитьСтроковоеПредставлениеСерийНоменклатурыСтроки(СтрокаТабличнойЧасти, Объект, ИмяПоляКлючСвязи, ИмяТабличнойЧастиСерииНоменклатуры);
	
КонецПроцедуры

// Возвращает символ числа
//
Функция СимволЧисла() Экспорт
	Возврат "#";
КонецФункции

// Возвращает строку маски по шаблону
//
// Параметры:
//  ШаблонСерииНоменклатуры - Шаблон
Функция СтрокаМаскиПоШаблону(ШаблонСерииНоменклатуры) Экспорт
	
	// Экранируем спец.символы
	спСпецСимволов = Новый Соответствие;
	спСпецСимволов.Вставить("9","\9");
	спСпецСимволов.Вставить("N","\N");
	спСпецСимволов.Вставить("U","\U");
	спСпецСимволов.Вставить("X","\X");
	спСпецСимволов.Вставить("h","\h");
	спСпецСимволов.Вставить("@","\@");
	
	СтрокаМаски = "";
	Для н=1 По СтрДлина(ШаблонСерииНоменклатуры) Цикл
		Символ = Сред(ШаблонСерииНоменклатуры, н, 1);
		
		Если спСпецСимволов.Получить(Символ)<>Неопределено Тогда
			СтрокаМаски = СтрокаМаски + спСпецСимволов.Получить(Символ);
		ИначеЕсли Символ=СимволЧисла() Тогда
			СтрокаМаски = СтрокаМаски + "9";
		Иначе
			СтрокаМаски = СтрокаМаски + Символ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокаМаски;
	
КонецФункции

// Удаляет строки по ключу связи в табличной части СерииНоменклатуры, очистка строки представления серий номенклатуры
//
// Параметры:
//  ТабличнаяЧастьСН - Табличная часть с сериями номенклатуры
//  СтрокаТабличнойЧасти - Строка с удаляемой серией
//  ИспользоватьСерииНоменклатурыОстатки - Признак использования серий
//  ИмяПоляКлючСвязи - Имя поля ключа связи
//  ИмяТабличнойЧастиСерииНоменклатуры - Имя табличной части содержащей серии номенклатуры
//
Процедура УдалитьСерииНоменклатурыПоКлючуСвязи(ТабличнаяЧастьСН, СтрокаТабличнойЧасти, ИспользоватьСерииНоменклатурыОстатки,
	ИмяПоляКлючСвязи = "КлючСвязи", ИмяТабличнойЧастиСерииНоменклатуры = "СерииНоменклатуры") Экспорт
	
	Если ИспользоватьСерииНоменклатурыОстатки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти[ИмяПоляКлючСвязи]) Тогда
		Возврат;
	КонецЕсли; 
	
	СтруктураПоиска = Новый Структура("КлючСвязи", СтрокаТабличнойЧасти[ИмяПоляКлючСвязи]);
	УдаляемыеСтроки = ТабличнаяЧастьСН.НайтиСтроки(СтруктураПоиска);
	Для каждого СтрокаТаблицы Из УдаляемыеСтроки Цикл
		
		ТабличнаяЧастьСН.Удалить(СтрокаТаблицы);
		
	КонецЦикла;
	
	Если СтрНайти(ИмяТабличнойЧастиСерииНоменклатуры, "Оприходование") = 0 Тогда
		СтрокаТабличнойЧасти.СерииНоменклатуры = "";
	Иначе
		СтрокаТабличнойЧасти.СерииНоменклатурыОприходование = "";
	КонецЕсли;
	
КонецПроцедуры

// Обновляет статусы серий номенклатуры в строке
//
// Параметры:
//  Объект - ДанныеФормы - Документ объект
//  СтрокаТабличнойЧасти - ДанныеФормыСтруктура - Строка табличной части в которой необходимо обновить статус серий
//  ИмяТабличнойЧастиСерии - Строка - Имя табличной части где хранятся значения серий номенклатуры
//  ПоРезерву - Булево - Признак сравнения с количеством резерва
//
Процедура ОбновитьСтатусСерииВСтроке(Объект, СтрокаТабличнойЧасти, ИмяТабличнойЧастиСерии = "СерииНоменклатуры", 
	ПоРезерву = Ложь) Экспорт
	
	Если ИмяТабличнойЧастиСерии = "СерииНоменклатурыОприходование" 
		И СтрокаТабличнойЧасти.СтатусыСерийНоменклатурыОприходование = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти.СтатусыСерийНоменклатуры = 0 Тогда
		Возврат
	КонецЕсли;
	
	ЭтоЗаказПокупателя = ?(ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ЗаказПокупателя"), Истина, Ложь);
	ЭтоОтчетКомиссионера = ?(ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ОтчетКомиссионера"), Истина, Ложь);
	ЭтоЗаказНарядТабличнаяЧастьМатериалы = ЭтоЗаказПокупателя 
		И Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаряд")
		И ИмяТабличнойЧастиСерии = "СерииНоменклатурыМатериалы";
	
	ИмяПоляКлючСвязи = "КлючСвязи";
	
	Если ЭтоОтчетКомиссионера Или ЭтоЗаказНарядТабличнаяЧастьМатериалы Тогда
		ИмяПоляКлючСвязи = "КлючСвязиСерииНоменклатуры";
	КонецЕсли;
	
	ПараметрыПоиска = Новый Структура("КлючСвязи", СтрокаТабличнойЧасти[ИмяПоляКлючСвязи]);
	НайденныеСерииПоКлючуСвязи = Объект[ИмяТабличнойЧастиСерии].НайтиСтроки(ПараметрыПоиска);
	
	КоэффициентЕдиницыИзмерения = 1;
	Если ТипЗнч(СтрокаТабличнойЧасти.ЕдиницаИзмерения) = Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
		КоэффициентЕдиницыИзмерения = СерииНоменклатурыУНФВызовСервера.КоэффициентЕдиницы(СтрокаТабличнойЧасти.ЕдиницаИзмерения);
	КонецЕсли;
	
	Если ИмяТабличнойЧастиСерии = "СерииНоменклатурыДоКорректировки" Тогда
		КоличествоПоЗапасам = СтрокаТабличнойЧасти.КоличествоДоКорректировки*КоэффициентЕдиницыИзмерения;
	ИначеЕсли ПоРезерву И СтрокаТабличнойЧасти.Резерв <> 0 Тогда
		КоличествоПоЗапасам = СтрокаТабличнойЧасти.Резерв * КоэффициентЕдиницыИзмерения;
	Иначе
		КоличествоПоЗапасам = СтрокаТабличнойЧасти.Количество*КоэффициентЕдиницыИзмерения;
	КонецЕсли;
	Если КоличествоПоЗапасам < 0 Тогда
		КоличествоПоЗапасам = -КоличествоПоЗапасам;
	КонецЕсли;
	КоличествоПоСериям = 0;
	
	Для Каждого СтрокаСерий Из НайденныеСерииПоКлючуСвязи Цикл
		КоличествоВСтроке = ?(СтрокаСерий.Количество = 0, 1, СтрокаСерий.Количество);
		КоличествоПоСериям = КоличествоПоСериям + КоличествоВСтроке;
	КонецЦикла;
	
	Если ИмяТабличнойЧастиСерии = "СерииНоменклатурыОприходование" Тогда
		СтрокаТабличнойЧасти.СтатусыСерийНоменклатурыОприходование = ?(КоличествоПоЗапасам = КоличествоПоСериям, 2, 1);
	ИначеЕсли ИмяТабличнойЧастиСерии = "СерииНоменклатурыДоКорректировки" Тогда
		СтрокаТабличнойЧасти.СтатусыСерийНоменклатурыДоКорректировки = ?(КоличествоПоЗапасам = КоличествоПоСериям, 2, 1);
	Иначе
		СтрокаТабличнойЧасти.СтатусыСерийНоменклатуры = ?(КоличествоПоЗапасам = КоличествоПоСериям, 2, 1);
	КонецЕсли;
	
КонецПроцедуры

// Обновляет статусы серий номенклатуры в строке представления
//
// Параметры:
//  Объект - Документ объект
//  СтрокаТабличнойЧасти - Строка табличной части в которой необходимо обновить статус серий
//  ИмяТабличнойЧастиСерии - Имя табличной части где хранятся значения серий номенклатуры
//
Процедура ОбновитьСтатусСерииВСтрокеПредставления(Объект, СтатусыСерийНоменклатуры, ИмяТабличнойЧастиСерии = "СерииНоменклатуры") Экспорт
	
	ЕдиницаИзмерения = Объект.ЕдиницаИзмерения;
	Количество = Объект.Количество;
	
	Если СтатусыСерийНоменклатуры = 0 Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыПоиска = Новый Структура("КлючСвязи", 0);
	НайденныеСерииПоКлючуСвязи = Объект[ИмяТабличнойЧастиСерии].НайтиСтроки(ПараметрыПоиска);
	
	КоэффициентЕдиницыИзмерения = 1;
	Если ТипЗнч(ЕдиницаИзмерения) = Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
		КоэффициентЕдиницыИзмерения = СерииНоменклатурыУНФВызовСервера.КоэффициентЕдиницы(ЕдиницаИзмерения);
	КонецЕсли;
	
	КоличествоПоЗапасам = Количество*КоэффициентЕдиницыИзмерения;
	КоличествоПоЗапасам = ?(КоличествоПоЗапасам < 0, КоличествоПоЗапасам * -1, КоличествоПоЗапасам);
	КоличествоПоСериям = 0;
	
	Для Каждого СтрокаСерий Из НайденныеСерииПоКлючуСвязи Цикл
		КоличествоВСтроке = ?(СтрокаСерий.Количество = 0, 1, СтрокаСерий.Количество);
		КоличествоПоСериям = КоличествоПоСериям + КоличествоВСтроке;
	КонецЦикла;
	
	СтатусыСерийНоменклатуры = ?(КоличествоПоЗапасам = КоличествоПоСериям, 2, 1);
	
КонецПроцедуры

// Возвращает общее количество серий номенклатуры по ключу связи
//
// Параметры:
//  СерииНоменклатуры - Табличная часть с сериями номенклатуры
//  КлючСвязи - Ключ связи строки запасы и строки серии
//
// Возвращаемое значение:
//  Число - количество серий по ключу связи.
//
Функция КоличествоСерийНоменклатурыПоКлючуСвязи(СерииНоменклатуры, КлючСвязи) Экспорт
	
	ПараметрыПоиска = Новый Структура("КлючСвязи", КлючСвязи);
	НайденныеСерииПоКлючуСвязи = СерииНоменклатуры.НайтиСтроки(ПараметрыПоиска);
	
	КоличествоПоСериям = 0;
	
	Для Каждого СтрокаСерий Из НайденныеСерииПоКлючуСвязи Цикл
		КоличествоВСтроке = ?(СтрокаСерий.Количество = 0, 1, СтрокаСерий.Количество);
		КоличествоПоСериям = КоличествоПоСериям + КоличествоВСтроке;
	КонецЦикла;
	
	Возврат КоличествоПоСериям;
	
КонецФункции

// Дополняет структуру данных номенклатуры при изменении необходимыми данными для получения информации по сериям
//
// Параметры:
//  Объект - Документ объект
//  СтруктураДанных - Структура которую необходимо дополнить
//
Процедура ДополнитьСтруктуруДаннымиДляПолученияСерийНоменклатуры(Объект, СтруктураДанных) Экспорт
	
	ПараметрыПодбораСтатуса = Новый Структура;
	
	ПараметрыПодбораСтатуса.Вставить("Организация", Объект.Организация);
	ПараметрыПодбораСтатуса.Вставить("Номенклатура", СтруктураДанных.Номенклатура);
	
	ЭтоЗаказПокупателя = (ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ЗаказПокупателя"));
	ЭтоКомплектацияЗапасов = (ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.КомплектацияЗапасов"));
	ЭтоПеремещениеЗапасов = (ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ПеремещениеЗапасов"));
	ЭтоПеремещениеЗапасовПоЯчейкам = (ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ПеремещениеПоЯчейкам"));
	
	Если ЭтоЗаказПокупателя И Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаряд") Тогда
		ПараметрыПодбораСтатуса.Вставить("ВидОперации", Неопределено);
		ПараметрыПодбораСтатуса.Вставить("ТипДокумента", "Заказ-наряд");
	Иначе
		Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ВидОперации") Тогда
			ПараметрыПодбораСтатуса.Вставить("ВидОперации", Неопределено);
		Иначе
			ПараметрыПодбораСтатуса.Вставить("ВидОперации", Объект.ВидОперации);
		КонецЕсли;
		
		ПараметрыПодбораСтатуса.Вставить("ТипДокумента", ТипЗнч(Объект.Ссылка));
		
	КонецЕсли;
	
	ЕстьРеквизитПоложениеСклада = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ПоложениеСклада");
	ПоложениеСклада = ?(ЕстьРеквизитПоложениеСклада, Объект.ПоложениеСклада, ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти"));
	
	Если ЭтоКомплектацияЗапасов Тогда
		ПараметрыПодбораСтатуса.Вставить("СтруктурнаяЕдиница", Объект.СтруктурнаяЕдиница);
	ИначеЕсли ПоложениеСклада = ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти") Тогда
		ПараметрыПодбораСтатуса.Вставить("СтруктурнаяЕдиница", Неопределено);
	Иначе
		
		Если ЭтоЗаказПокупателя Тогда
			ПараметрыПодбораСтатуса.Вставить("СтруктурнаяЕдиница", Объект.СтруктурнаяЕдиницаРезерв);
		Иначе
			ПараметрыПодбораСтатуса.Вставить("СтруктурнаяЕдиница", Объект.СтруктурнаяЕдиница);
		КонецЕсли;
		
	КонецЕсли;
	
	БратьСкладИзШапки = ЭтоПеремещениеЗапасов Или ЭтоПеремещениеЗапасовПоЯчейкам;
	
	Если БратьСкладИзШапки Тогда
		ПараметрыПодбораСтатуса.СтруктурнаяЕдиница = Объект.СтруктурнаяЕдиница;
	КонецЕсли;
	
	Если ЭтоПеремещениеЗапасов Тогда
		ПараметрыПодбораСтатуса.Вставить("СтруктурнаяЕдиницаПолучатель", Объект.СтруктурнаяЕдиницаПолучатель);
	Иначе
		ПараметрыПодбораСтатуса.Вставить("СтруктурнаяЕдиницаПолучатель", Неопределено);
	КонецЕсли;
		
	СтруктураДанных.Вставить("ПараметрыПодбораСтатуса", ПараметрыПодбораСтатуса);
	
КонецПроцедуры

// Дополняет структуру данных номенклатуры при изменении необходимыми данными для получения информации по сериям в
// обработке ввода остатков
//
// Параметры:
//  Объект - Документ объект
//  СтруктураДанных - Структура которую необходимо дополнить
//
Процедура ДополнитьСтруктуруДаннымиДляПолученияСерийНоменклатурыОбработкаВводаОстатков(Объект, СтруктураДанных) Экспорт
	
	ПараметрыПодбораСтатуса = Новый Структура;
	
	ПараметрыПодбораСтатуса.Вставить("Организация", Объект.Организация);
	ПараметрыПодбораСтатуса.Вставить("Номенклатура", СтруктураДанных.Номенклатура);
	ПараметрыПодбораСтатуса.Вставить("ТипДокумента", Тип("ДокументСсылка.ВводНачальныхОстатков"));
	ПараметрыПодбораСтатуса.Вставить("ВидОперации", Неопределено);
	ПараметрыПодбораСтатуса.Вставить("СтруктурнаяЕдиница", Неопределено);

		
	СтруктураДанных.Вставить("ПараметрыПодбораСтатуса", ПараметрыПодбораСтатуса);
	
КонецПроцедуры

// Функция - Годен до по дате производства
//
// Параметры:
//  ДатаПроизводства				 - Дата 
//  СрокГодности					 - Число 
//  ЕдиницаИзмеренияСрокаГодности	 - ПеречислениеСсылка.ЕдиницыИзмеренияВремени 
// 
// Возвращаемое значение:
//  Дата 
//
Функция ГоденДоПоДатеПроизводства(ДатаПроизводства, СрокГодности, ЕдиницаИзмеренияСрокаГодности) Экспорт
	
	ГоденДо = '00010101';
	
	Если Не ЗначениеЗаполнено(ДатаПроизводства)
		Или Не ЗначениеЗаполнено(СрокГодности) Тогда
		Возврат ГоденДо;
	КонецЕсли;
	
	Если ЕдиницаИзмеренияСрокаГодности = ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Год") Тогда
		ГоденДо = ДатаПроизводства + СрокГодности * 31536000;
	ИначеЕсли ЕдиницаИзмеренияСрокаГодности = ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Месяц") Тогда
		ГоденДо = ДобавитьМесяц(ДатаПроизводства, СрокГодности);
	ИначеЕсли ЕдиницаИзмеренияСрокаГодности = ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Сутки") Тогда
		ГоденДо = ДатаПроизводства + СрокГодности * 86400;
	ИначеЕсли ЕдиницаИзмеренияСрокаГодности =  ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Час") Тогда
		ГоденДо = ДатаПроизводства + СрокГодности * 3600;
	КонецЕсли;
	
	Возврат ГоденДо;
	
КонецФункции

// Функция - Дата производства по годен до
//
// Параметры:
//  ГоденДо				 - Дата 
//  СрокГодности					 - Число 
//  ЕдиницаИзмеренияСрокаГодности	 - ПеречислениеСсылка.ЕдиницыИзмеренияВремени 
// 
// Возвращаемое значение:
//  Дата 
//
Функция ДатаПроизводстваПоГоденДо(ГоденДо, СрокГодности, ЕдиницаИзмеренияСрокаГодности) Экспорт
	
	ДатаПроизводства = '00010101';
	
	Если Не ЗначениеЗаполнено(ГоденДо)
		Или Не ЗначениеЗаполнено(СрокГодности) Тогда
		Возврат ДатаПроизводства;
	КонецЕсли;
	
	Если ЕдиницаИзмеренияСрокаГодности = ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Год") Тогда
		ДатаПроизводства = ГоденДо - СрокГодности * 31536000;
	ИначеЕсли ЕдиницаИзмеренияСрокаГодности = ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Месяц") Тогда
		ДатаПроизводства = ДобавитьМесяц(ГоденДо, - СрокГодности);
	ИначеЕсли ЕдиницаИзмеренияСрокаГодности = ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Сутки") Тогда
		ДатаПроизводства = ГоденДо - СрокГодности * 86400;
	ИначеЕсли ЕдиницаИзмеренияСрокаГодности =  ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Час") Тогда
		ДатаПроизводства = ГоденДо - СрокГодности * 3600;
	КонецЕсли;
	
	Возврат ДатаПроизводства;
	
КонецФункции

#КонецОбласти