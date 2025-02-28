﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтборОрганизация	= Параметры.Компания;
	Организация			= Параметры.Организация;
	ОтборКонтрагент 	= Параметры.Контрагент;
	ОтборДоговор 		= Параметры.Договор;
	ОтборПериод.ДатаОкончания 	= Параметры.ДатаДокумента;
	КлючСвязи = Параметры.КлючСвязи;
	
	ЗаполнитьДобавленнуюНоменклатуру(Параметры.ТекущийДокумент);
	
	ЗаполнитьПериодПродаж(Параметры.ТекущийДокумент);
	
	ЗаполнитьОтчетыКомиссионера();
	
	ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(ОтборПериод);
	
	Элементы.СоставХарактеристика.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики");
	Элементы.СоставПартия.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьПартии");
	
	// МобильныйКлиент
	РаботаСОтборами.НастроитьПанельОтборовМобильныйКлиент(ЭтаФорма,,,,,Истина); 
	// Конец МобильныйКлиент
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ДекорацияРазвернутьОтборыНажатие(Элемент)
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПредставлениеПериодаВыбратьПериод();
КонецПроцедуры

&НаКлиенте
Процедура СвернутьОтборыНажатие(Элемент)
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
КонецПроцедуры

&НаКлиенте
Процедура ОтчетыКомиссионераПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбновитьДанныеПоНоменклатуреКлиент", 0.5, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОтчетыКомиссионераВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ОтчетыКомиссионера.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;

	ОповеститьОВыборе(ТекущиеДанные.ОтчетКомиссионера);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьОтчетыКомиссионера()
	
	ПараметрыОтбора = Новый Структура("ИмяПоляОтбора",);
	
	ПараметрыОтбора.ИмяПоляОтбора = "Номенклатура";
	НайденныеСтроки = ДанныеМеток.НайтиСтроки(ПараметрыОтбора);
	СписокНоменклатуры = ДанныеМеток.Выгрузить(НайденныеСтроки, "Метка");
	
	ПараметрыОтбора.ИмяПоляОтбора = "ЗаказПокупателя";
	НайденныеСтроки = ДанныеМеток.НайтиСтроки(ПараметрыОтбора);
	СписокЗаказов = ДанныеМеток.Выгрузить(НайденныеСтроки, "Метка");
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Организация",		ОтборОрганизация);
	Запрос.УстановитьПараметр("Контрагент",			ОтборКонтрагент);
	Запрос.УстановитьПараметр("Договор",			ОтборДоговор);
	Запрос.УстановитьПараметр("СписокНоменклатуры",		СписокНоменклатуры);
	Запрос.УстановитьПараметр("СписокЗаказов",	СписокЗаказов);
	
	Запрос.УстановитьПараметр("ЕстьОтборПоНоменклатуре",	СписокНоменклатуры.Количество());
	Запрос.УстановитьПараметр("ЕстьОтборПоЗаказам",			СписокЗаказов.Количество());
	
	Запрос.УстановитьПараметр("НачалоПериода",		НачалоДня(ОтборПериод.ДатаНачала));
	Запрос.УстановитьПараметр("КонецПериода",		КонецДня(ОтборПериод.ДатаОкончания));
	
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПродажиОбороты.Документ КАК ОтчетКомиссионера,
	|	ПродажиОбороты.Документ.Дата КАК Дата,
	|	ПродажиОбороты.Документ.Номер КАК Номер,
	|	ПродажиОбороты.Документ.СуммаДокумента КАК Сумма,
	|	ПродажиОбороты.Документ.Комментарий КАК Комментарий
	|ИЗ
	|	РегистрНакопления.Продажи.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Организация = &Организация
	|				И Контрагент = &Контрагент
	|				И ТИПЗНАЧЕНИЯ(Документ) = ТИП(Документ.ОтчетКомиссионера)
	|				И ВЫБОР
	|					КОГДА &ЕстьОтборПоНоменклатуре
	|						ТОГДА Номенклатура В (&СписокНоменклатуры)
	|					ИНАЧЕ ИСТИНА
	|				КОНЕЦ
	|				И ВЫБОР
	|					КОГДА &ЕстьОтборПоЗаказам
	|						ТОГДА ЗаказПокупателя В (&СписокЗаказов)
	|					ИНАЧЕ ИСТИНА
	|				КОНЕЦ) КАК ПродажиОбороты
	|ГДЕ
	|	ПродажиОбороты.КоличествоОборот > 0";
	
	ОтчетыКомиссионера.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры // ЗаполнитьОтчетыКомиссионера()

&НаКлиенте
Процедура ОбновитьДанныеПоНоменклатуреКлиент()
	
	Состав.Очистить();
	
	ТекущиеДанные = Элементы.ОтчетыКомиссионера.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат
	КонецЕсли;
	
	ОбновитьДанныеПоНоменклатуреСервер(ТекущиеДанные.ОтчетКомиссионера);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеПоНоменклатуреСервер(Документ)
	
	ПараметрыОтбора = Новый Структура("ИмяПоляОтбора",);
	
	ПараметрыОтбора.ИмяПоляОтбора = "Номенклатура";
	НайденныеСтроки = ДанныеМеток.НайтиСтроки(ПараметрыОтбора);
	СписокНоменклатуры = ДанныеМеток.Выгрузить(НайденныеСтроки, "Метка");
	
	ПараметрыОтбора.ИмяПоляОтбора = "ЗаказПокупателя";
	НайденныеСтроки = ДанныеМеток.НайтиСтроки(ПараметрыОтбора);
	СписокЗаказов = ДанныеМеток.Выгрузить(НайденныеСтроки, "Метка");
	
	Запрос = Новый Запрос();

	Запрос.УстановитьПараметр("Документ",		Документ);
	Запрос.УстановитьПараметр("СписокНоменклатуры",		СписокНоменклатуры);
	Запрос.УстановитьПараметр("СписокЗаказов",	СписокЗаказов);
	
	Запрос.УстановитьПараметр("ДобавленнаяНоменклатура",	ДобавленнаяНоменклатура.Выгрузить());
	
	Запрос.УстановитьПараметр("ЕстьОтборПоНоменклатуре",	СписокНоменклатуры.Количество());
	Запрос.УстановитьПараметр("ЕстьОтборПоЗаказам",			СписокЗаказов.Количество());
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДобавленнаяНоменклатура.Номенклатура КАК Номенклатура,
	|	ДобавленнаяНоменклатура.Характеристика КАК Характеристика,
	|	ДобавленнаяНоменклатура.Партия КАК Партия,
	|	ДобавленнаяНоменклатура.Количество КАК Количество
	|ПОМЕСТИТЬ НоменклатураВозврата
	|ИЗ
	|	&ДобавленнаяНоменклатура КАК ДобавленнаяНоменклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПродажиОбороты.Номенклатура КАК Номенклатура,
	|	ПродажиОбороты.Характеристика КАК Характеристика,
	|	ПродажиОбороты.Партия КАК Партия,
	|	ПродажиОбороты.КоличествоОборот КАК Остаток,
	|	ПродажиОбороты.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ВЫБОР
	|		КОГДА НоменклатураВозврата.Номенклатура ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Выбран,
	|	ЕСТЬNULL(НоменклатураВозврата.Количество, 0) КАК Количество
	|ИЗ
	|	РегистрНакопления.Продажи.Обороты(
	|			,
	|			,
	|			,
	|			Документ = &Документ
	|				И ВЫБОР
	|					КОГДА &ЕстьОтборПоНоменклатуре
	|						ТОГДА Номенклатура В (&СписокНоменклатуры)
	|					ИНАЧЕ ИСТИНА
	|				КОНЕЦ
	|				И ВЫБОР
	|					КОГДА &ЕстьОтборПоЗаказам
	|						ТОГДА ЗаказПокупателя В (&СписокЗаказов)
	|					ИНАЧЕ ИСТИНА
	|				КОНЕЦ) КАК ПродажиОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ НоменклатураВозврата КАК НоменклатураВозврата
	|		ПО ПродажиОбороты.Номенклатура = НоменклатураВозврата.Номенклатура
	|			И ПродажиОбороты.Характеристика = НоменклатураВозврата.Характеристика
	|			И ПродажиОбороты.Партия = НоменклатураВозврата.Партия
	|ГДЕ
	|	ПродажиОбороты.КоличествоОборот > 0";
	
	Состав.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ЗаполнитьПериодПродаж(ТекущийДокумент)
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОтчетКомиссионера.Дата КАК Дата
	|ИЗ
	|	Документ.ОтчетКомиссионера КАК ОтчетКомиссионера
	|ГДЕ
	|	ОтчетКомиссионера.Проведен
	|	И ОтчетКомиссионера.Организация = &Организация
	|	И ОтчетКомиссионера.Контрагент = &Контрагент
	|	И ОтчетКомиссионера.Договор = &Договор
	|	И ОтчетКомиссионера.Дата < &ДатаДокумента
	|	И ОтчетКомиссионера.Ссылка <> &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата ВОЗР";
	
	Запрос.УстановитьПараметр("Организация",	Организация);
	Запрос.УстановитьПараметр("Контрагент",		ОтборКонтрагент);
	Запрос.УстановитьПараметр("Договор",		ОтборДоговор);
	Запрос.УстановитьПараметр("Ссылка",			ТекущийДокумент.Ссылка);
	Запрос.УстановитьПараметр("ДатаДокумента",	КонецДня(ОтборПериод.ДатаОкончания));
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		ОтборПериод.ДатаНачала = Дата('00010101');
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ОтборПериод.ДатаНачала = НачалоДня(Выборка.Дата);
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПериодПродаж()

&НаСервере
Процедура ЗаполнитьДобавленнуюНоменклатуру(ТекущийДокумент)
	
	ПараметрыПоиска = Новый Структура("КлючСвязи", КлючСвязи);
	МассивДобавленныхСтрок = ТекущийДокумент.ЗапасыВозвраты.НайтиСтроки(ПараметрыПоиска);
	
	Для Каждого ДобавленнаяСтрока Из МассивДобавленныхСтрок Цикл
		НоваяСтрока = ДобавленнаяНоменклатура.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ДобавленнаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()
	
	ТекущиеДанные = Элементы.ОтчетыКомиссионера.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;

	ОповеститьОВыборе(ТекущиеДанные.ОтчетКомиссионера);

КонецПроцедуры // ПеренестиВДокументВыполнить()

#КонецОбласти

#Область МеткиОтборов

&НаКлиенте
Процедура ПредставлениеПериодаВыбратьПериод()
	
	Оповещение = Новый ОписаниеОповещения("ПредставлениеПериодаНажатиеЗавершение", ЭтотОбъект);
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода;
	Диалог.Период = ОтборПериод;
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатиеЗавершение(НовыйПериод, Параметры) Экспорт
	
	Если НовыйПериод = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(НовыйПериод)=Тип("СтандартныйПериод") Тогда
		ОтборПериод = НовыйПериод;
	ИначеЕсли ТипЗнч(НовыйПериод)=Тип("Дата") Тогда
		ОтборПериод.ДатаОкончания = НовыйПериод;
	КонецЕсли;
	
	ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(ОтборПериод);
	ЗаполнитьОтчетыКомиссионера();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	ЗаполнитьОтчетыКомиссионера();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	УдалитьМеткуОтбораСервер(МеткаИД);

КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбораСервер(МеткаИД) Экспорт
	
	СтрокаМеток = ДанныеМеток[Число(МеткаИД)];
	ИмяПоляОтбора = СтрокаМеток.ИмяПоляОтбора;
	
	СписокГруппФормыДляУдаленияДобавленныхЭлементов = РаботаСОтборами.ПолучитьСписокИмяГруппыРодителя(ДанныеМеток);
	
	ДанныеМеток.Удалить(СтрокаМеток);
	
	РаботаСОтборами.ОбновитьЭлементыМеток(ЭтотОбъект, СписокГруппФормыДляУдаленияДобавленныхЭлементов, "ДанныеМеток");

	ЗаполнитьОтчетыКомиссионера();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Номенклатура", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаказПокупателяОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ЗаказПокупателя", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

#КонецОбласти