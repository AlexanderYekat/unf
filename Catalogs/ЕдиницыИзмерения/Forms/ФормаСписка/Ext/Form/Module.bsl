﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИсключитьНаборИзОтображенияВСписке = Ложь;
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда
		СсылкаВладелец = Параметры.Отбор.Владелец;
		
		Если ТипЗнч(Параметры.Отбор.Владелец)=Тип("СправочникСсылка.Номенклатура") Тогда
			
			Номенклатура = СсылкаВладелец;
			Если ЗначениеЗаполнено(Номенклатура) Тогда
				ЭтоНабор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ЭтоНабор");
				КатегорияНоменклатуры = Номенклатура.КатегорияНоменклатуры;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СсылкаВладелец) Тогда 
			Если ТипЗнч(СсылкаВладелец) = Тип("СправочникСсылка.Номенклатура") Тогда
				ИспользоватьНаборыЕдиницИзмерения = СсылкаВладелец.ИспользоватьНаборыЕдиницИзмерения;
				НаборЕдиницИзмерения = СсылкаВладелец.НаборЕдиницИзмерения;
			КонецЕсли;
			
			ЕдиницаХранения = СсылкаВладелец.ЕдиницаИзмерения;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СсылкаВладелец) Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	СправочникЕдиницыИзмеренияПереопределяемый.Ссылка КАК Ссылка,
		|	СправочникЕдиницыИзмеренияПереопределяемый.ПометкаУдаления КАК ПометкаУдаления,
		|	СправочникЕдиницыИзмеренияПереопределяемый.Владелец КАК Владелец,
		|	СправочникЕдиницыИзмеренияПереопределяемый.Код КАК Код,
		|	СправочникЕдиницыИзмеренияПереопределяемый.Наименование КАК Наименование,
		|	СправочникЕдиницыИзмеренияПереопределяемый.Коэффициент КАК Коэффициент,
		|	СправочникЕдиницыИзмеренияПереопределяемый.ЕдиницаИзмеренияПоКлассификатору КАК ЕдиницаИзмеренияПоКлассификатору,
		|	СправочникЕдиницыИзмеренияПереопределяемый.Предопределенный КАК Предопределенный,
		|	СправочникЕдиницыИзмеренияПереопределяемый.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(СправочникЕдиницыИзмеренияПереопределяемый.Владелец) = ТИП(Справочник.КатегорииНоменклатуры)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЭтоКатегория
		|ИЗ
		|	Справочник.ЕдиницыИзмерения КАК СправочникЕдиницыИзмеренияПереопределяемый";
		
		СтруктураПараметровСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		СтруктураПараметровСписка.Вставить("ТекстЗапроса", ТекстЗапроса);
		
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СтруктураПараметровСписка);
		
	Иначе
		
		Если Список.Параметры.Элементы.Найти("ЕдиницаХранения")<>Неопределено Тогда
			Список.Параметры.УстановитьЗначениеПараметра("ЕдиницаХранения", ЕдиницаХранения);
		КонецЕсли;
		
	КонецЕсли;
	
	ПравоДоступаДобавление = ПравоДоступа("Добавление", Метаданные.Справочники.ЕдиницыИзмерения);
	
	Если ЭтоНабор Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru = 'Единицы измерения недоступны для наборов'");
	ИначеЕсли Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ПодарочныйСертификат Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru = 'Единицы измерения недоступны для подарочных сертификатов'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеФормой();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КопированиеЕдиницИзмерения" И ЗначениеЗаполнено(Номенклатура) И Параметр=Номенклатура Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНовыйЭлемент(Команда)
	
	ПараметрыОткрытия = Новый Структура("СсылкаВладелец", СсылкаВладелец);
	ОткрытьФорму("Справочник.ЕдиницыИзмерения.Форма.ФормаЭлемента", ПараметрыОткрытия, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьОт(Команда)
	
	СтруктураОткрытия = Новый Структура;
	СтруктураОткрытия.Вставить("Номенклатура", Номенклатура);
	СтруктураОткрытия.Вставить("КопироватьЕдиницыИзмерения", Истина);
	СтруктураОткрытия.Вставить("КопироватьИзВыбранных", Истина);
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаКопированияСвязаннойИнформации", СтруктураОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьДругим(Команда)
	
	СтруктураОткрытия = Новый Структура;
	СтруктураОткрытия.Вставить("Номенклатура", Номенклатура);
	СтруктураОткрытия.Вставить("КопироватьЕдиницыИзмерения", Истина);
	СтруктураОткрытия.Вставить("КопироватьИзВыбранных", Ложь);
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаКопированияСвязаннойИнформации", СтруктураОткрытия, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НаборЕдиницИзмеренияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЕдиницаХранения", ЕдиницаХранения);
	
	ОткрытьФорму("Справочник.НаборыЕдиницИзмерения.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЕдиницИзмеренияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		ФормаВладельца = ЭтаФорма.ВладелецФормы;
		Если ФормаВладельца = Неопределено Тогда
			Возврат
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		НаборЕдиницИзмерения = ВыбранноеЗначение.Ссылка;
		
		ФормаВладельца.Модифицированность = Истина;
		ЕдиницаХранения = ВыбранноеЗначение.ЕдиницаИзмерения;
		ФормаВладельца.Объект.ЕдиницаИзмерения = ЕдиницаХранения;
		ФормаВладельца.Объект.НаборЕдиницИзмерения = НаборЕдиницИзмерения;
		
		Если Список.Параметры.Элементы.Найти("ЕдиницаХранения")<>Неопределено Тогда
			Список.Параметры.УстановитьЗначениеПараметра("ЕдиницаХранения", ЕдиницаХранения);
		КонецЕсли;
		
		УправлениеФормой();
		
		КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура НаборЕдиницИзмеренияПриИзменении(Элемент)
	
	ФормаВладельца = ЭтаФорма.ВладелецФормы;
	Если ФормаВладельца = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ФормаВладельца.Объект.НаборЕдиницИзмерения = НаборЕдиницИзмерения;
	ФормаВладельца.Модифицированность = Истина;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНаборыЕдиницИзмеренияПриИзменении(Элемент)

	Если ИспользоватьНаборыЕдиницИзмерения = 0 Тогда
		НаборЕдиницИзмерения = Неопределено;
	КонецЕсли;
	
	ФормаВладельца = ЭтаФорма.ВладелецФормы;
	Если ФормаВладельца = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ФормаВладельца.Объект.ИспользоватьНаборыЕдиницИзмерения = ИспользоватьНаборыЕдиницИзмерения;
	ФормаВладельца.Объект.НаборЕдиницИзмерения = НаборЕдиницИзмерения;
	ФормаВладельца.Модифицированность = Истина;
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеФормой()
	
	Элементы.Список.ТолькоПросмотр = ЭтоНабор;
	Элементы.ГруппаКопирование.Видимость = ЗначениеЗаполнено(Номенклатура);
	Элементы.ГруппаКопирование.Доступность = НЕ ЭтоНабор И ПравоДоступаДобавление;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокСоздатьНовыйЭлемент", "Доступность", НЕ ИспользоватьНаборыЕдиницИзмерения = 1);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокСкопировать", "Доступность", НЕ ИспользоватьНаборыЕдиницИзмерения = 1);
	
	Если ТипЗнч(СсылкаВладелец) = Тип("СправочникСсылка.КатегорииНоменклатуры") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЭтоКатегория", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НаборыЕдиницИзмерения", "Видимость", Ложь);
	КонецЕсли;
	
	СписокОтбора = Новый СписокЗначений;
	
	Если ЗначениеЗаполнено(КатегорияНоменклатуры) Тогда
		СписокОтбора.Добавить(КатегорияНоменклатуры);
	КонецЕсли;
	
	Если ИспользоватьНаборыЕдиницИзмерения = 1 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаКопирование", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Список", "ТолькоПросмотр", Истина);
		
		Если ЗначениеЗаполнено(НаборЕдиницИзмерения) Тогда
			СписокОтбора.Добавить(НаборЕдиницИзмерения);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец", СписокОтбора, ВидСравненияКомпоновкиДанных.ВСписке);
		Иначе
			СписокОтбора.Добавить(СсылкаВладелец);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец", СписокОтбора, ВидСравненияКомпоновкиДанных.ВСписке);
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(СсылкаВладелец) Тогда
		
		Если ИспользоватьНаборыЕдиницИзмерения = 1 Тогда
			СписокОтбора.Добавить("");
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец", СписокОтбора, ВидСравненияКомпоновкиДанных.ВСписке);
		Иначе
			СписокОтбора.Добавить(СсылкаВладелец);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец", СписокОтбора, ВидСравненияКомпоновкиДанных.ВСписке);
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НаборыЕдиницИзмерения", "Доступность", ЗначениеЗаполнено(СсылкаВладелец));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НаборЕдиницИзмерения", "Доступность", ИспользоватьНаборыЕдиницИзмерения = 1);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НаборЕдиницИзмерения", "ОтметкаНезаполненного", ИспользоватьНаборыЕдиницИзмерения = 1 И Не ЗначениеЗаполнено(НаборЕдиницИзмерения));
	
	
КонецПроцедуры

#КонецОбласти
 
