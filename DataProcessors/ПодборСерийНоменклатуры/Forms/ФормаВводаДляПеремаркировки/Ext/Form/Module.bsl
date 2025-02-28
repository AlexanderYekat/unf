﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	GTIN = Параметры.GTIN;
	Номенклатура = Параметры.Запасы.Номенклатура;
	Характеристика = Параметры.Запасы.Характеристика;
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ВидМаркировки") <> Перечисления.ВидыМаркировки.МаркируемаяПродукция Тогда
		ТекстИсключения = НСтр("ru = 'Номенклатура %Номенклатуры% не является продукцией, которую нужно маркировать для ГИСМ.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%Номенклатуры%",Параметры.Номенклатура);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Серия = Параметры.Серия;
	ЭтоПеремаркировкаТоваровГИСМ = Параметры.ЭтоПеремаркировкаТоваровГИСМ;
	ЭтоМаркировкаТоваровГИСМ = Параметры.ЭтоМаркировкаГИСМ;
	GTINИзКиЗ = ИнтеграцияГИСМУНФ.GTINКиЗ(Параметры.НоменклатураКиЗ, Параметры.ХарактеристикаКиЗ);
	
	ЭтоМаркировкаПерсонифицированнымиКиЗ = ЗначениеЗаполнено(GTINИзКиЗ);
	
	Если ЭтоМаркировкаПерсонифицированнымиКиЗ
		И GTINИзКиЗ <> GTIN Тогда
		
		ТекстСообщения = НСтр("ru = 'Выбранный КиЗ предназначен для маркировки товаров с GTIN %GTINИзКиЗ%, его нельзя использовать для маркировки товара с GTIN %GTIN%.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%GTINИзКиЗ%", GTINИзКиЗ);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%GTIN%", GTIN);
		
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если Параметры.Свойство("НастройкиИспользованияСерий") Тогда
		НастройкиИспользованияСерий = Новый ФиксированнаяСтруктура(Параметры.НастройкиИспользованияСерий);
	Иначе
		НастройкиИспользованияСерий = Новый ФиксированнаяСтруктура(Новый Структура);
	КонецЕсли;

	
	СерияСписываемая = Параметры.СписываемаяСерия;
	СерияНовая       = Параметры.Серия;
	СерияВрем = РеквизитыВводаСерии();
	ЗаполнитьРеквизитыПоСерии(СерияВрем, СерияНовая);
	СерияНоваяКешВвода       = Новый ФиксированнаяСтруктура(СерияВрем);
	ЗаполнитьРеквизитыПоСерии(СерияВрем, СерияСписываемая);
	СерияСписываемаяКешВвода = Новый ФиксированнаяСтруктура(СерияВрем);
	
	Элементы.ОК.Заголовок = НСтр("ru = 'Готово'");
	
	Элементы.Номер.АвтоОтметкаНезаполненного = Ложь;
	
	#Область RFID
	Считыватели = МенеджерОборудованияВызовСервера.ОборудованиеПоПараметрам("СчитывательRFID");
	Если Считыватели.Количество() = 0 Тогда
		ПодключатьСчитывательRFID = Ложь;
	ИначеЕсли Считыватели.Количество() = 1 Тогда
		ПодключатьСчитывательRFID = Истина;
		СчитывательRFID = Считыватели[0].Ссылка;
	Иначе
		ТекстСообщения = НСтр("ru = 'К рабочему месту подключено несколько считывателей RFID. Работа одновременно с несколькими считывателями не поддерживается. Оставьте только один считыватель.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		ПодключатьСчитывательRFID = Ложь;
	КонецЕсли;
	
	
	#КонецОбласти
	
	УстановитьВидимостьКомандыЗаписиRFID();
	
	ЗакрыватьПриВыборе = Ложь;
	
	ЗаполнитьРеквизитыПоСерии(ЭтаФорма,Серия);
	
	СообщениеОбОшибке = "";
	ЗаполнитьФлагиРаботыСМеткой(ЭтаФорма, СообщениеОбОшибке);
	Если СообщениеОбОшибке <> "" Тогда
		ОбщегоНазначения.СообщитьПользователю(СообщениеОбОшибке);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		//+ГИСМ
	ПоддерживаемыеТипыОборудования = Новый Массив();
	Если ПодключатьСчитывательRFID Тогда
		ПоддерживаемыеТипыОборудования.Добавить("СчитывательRFID");
	КонецЕсли;
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоТипу(Неопределено, УникальныйИдентификатор, ПоддерживаемыеТипыОборудования);
	//-ГИСМ

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() И НЕ ТолькоПросмотр Тогда
		ЗавершитьПодбор = Ложь;
		
		Если ИмяСобытия = "ScanData" Тогда
			
			Если ОбработатьШтрихкоды(МенеджерОборудованияУНФКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр)) Тогда
				ЗавершитьПодбор = Истина;
			КонецЕсли;
			
		ИначеЕсли ИмяСобытия = "RFID"
			И Не ИдетЗаписьМетки
			И RFIDКлиент.ДляОбработкиRFIDНуженСерверныйВызов(Параметр, ЭтаФорма) Тогда
			ОбработатьСчитываниеRFID(Параметр);
		КонецЕсли;
		
		Если ЗавершитьПодбор
			И Не ЭтоПеремаркировкаТоваровГИСМ
			И ОбязательныеРеквизитыЗаполнены(Ложь) Тогда
			ПодключитьОбработчикОжидания("ПодобратьСериюЗавершитьВвод",0.1, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = "ЗаписьRFID_Серии" Тогда
		RFIDEPC = Параметр.RFIDEPC;
		СообщениеОбОшибке = "";
		ЗаполнитьФлагиРаботыСМеткой(ЭтаФорма, СообщениеОбОшибке);
		Если СообщениеОбОшибке <> "" Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке);
		КонецЕсли;
		НайтиСоздатьСерию();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_СерииНоменклатуры" Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма,Параметр);
	КонецЕсли;
	
	// Вставить содержимое обработчика
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаСервереБезКонтекста
Процедура ЗаполнитьРеквизитыПоСерии(Приемник, Знач СерияДляЗаполнения)
	
	Если ЗначениеЗаполнено(СерияДляЗаполнения) Тогда
		Если ТипЗнч(СерияДляЗаполнения) = Тип("СправочникСсылка.СерииНоменклатуры") Тогда
			Приемник.Серия = СерияДляЗаполнения;
			СерияСсылка = СерияДляЗаполнения;
		Иначе
			ЗаполнитьЗначенияСвойств(Приемник, СерияДляЗаполнения);
			СерияСсылка = СерияДляЗаполнения.Серия;
		КонецЕсли;
		Если ЗначениеЗаполнено(СерияСсылка) Тогда
			РеквизитыСерии = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СерияСсылка,
				"Наименование,Номер,ГоденДо,НомерКИЗГИСМ,RFIDUser,RFIDEPC,EPCGTIN,RFIDTID");
			ЗаполнитьЗначенияСвойств(Приемник, РеквизитыСерии);
		КонецЕсли;
	Иначе
		ЗаполнитьЗначенияСвойств(Приемник, РеквизитыВводаСерии());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	ПодобратьСериюЗавершитьВвод();
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Если Не ОбязательныеРеквизитыЗаполнены() Тогда
		Возврат;
	КонецЕсли;
	ПерейтиНаСледующийШаг();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ВернутьсяНаПредыдущийШаг();
	
КонецПроцедуры

&НаКлиенте
Процедура СчитатьМетку(Команда)
	
	ОчиститьСообщения();
	RFIDКлиент.ОткрытьСессиюСчитывателяRFID(ЭтаФорма);
	ПодключитьОбработчикОжидания("ОтработатьТаймаутОжиданияСчитыванияМетки", 5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВRFID(Команда)
	ИдетЗаписьМетки = Истина;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ДанныеСерии",ДанныеСерии(ЭтаФорма));
	ПараметрыЗаписи.Вставить("Форма", ЭтаФорма);
	
	RFIDКлиент.ЗаписатьДанныеВRFID(Неопределено, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область СервисныеФункции
Функция ОбязательныеРеквизитыЗаполнены(ВыводитьСообщения = Истина)
	
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(НомерКиЗГИСМ) Тогда
		Отказ = Истина;
		Если ВыводитьСообщения Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Номер КиЗ"" не заполнено'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"НомерКиЗГИСМ");
		КонецЕсли;
	ИначеЕсли Не ИнтеграцияГИСМКлиентСервер.ЭтоНомерКиЗ(НомерКиЗГИСМ) Тогда
		Отказ = Истина;
		Если ВыводитьСообщения Тогда
			ТекстСообщения = НСтр("ru = 'Значение в поле ""Номер КиЗ"" не является номером контрольного (идентификационного) знака ГИСМ'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"НомерКиЗГИСМ");
		КонецЕсли;
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

&НаКлиенте
Процедура ОтработатьТаймаутОжиданияСчитыванияМетки()
	
	Если ОткрытаСессияСчитывателяRFID Тогда
		RFIDКлиент.ОтработатьТаймаутОжиданияСчитыванияМетки(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВернутьсяНаПредыдущийШаг()
	
	СерияНовая = Серия;
	
	СерияНоваяКешВвода = Новый ФиксированнаяСтруктура(ДанныеСерии(ЭтаФорма));
	
	НастроитьФормуПоШагу("Шаг1");
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиНаСледующийШаг()
	
	Если НЕ НайтиСоздатьСерию() Тогда
		Возврат;
	КонецЕсли;
	СерияСписываемая = Серия;
	
	СерияСписываемаяКешВвода = Новый ФиксированнаяСтруктура(ДанныеСерии(ЭтаФорма));
	
	НастроитьФормуПоШагу("Шаг2");
	
КонецПроцедуры


&НаКлиентеНаСервереБезКонтекста
Функция РеквизитыВводаСерии()
	РеквизитыВводаСерии = Новый Структура("Серия,
		|EPCGTIN,
		|RFIDEPC,
		|RFIDTID,
		|RFIDUser,
		|ГоденДо,
		|ЗаполненRFIDTID,
		|НомерГИСМ,
		|НомерКиЗГИСМ,
		|НужноЗаписатьМетку,
		|СтатусРаботыRFID");
	Возврат РеквизитыВводаСерии;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДанныеСерии(ДанныеДляЗаполнения)
	
	ДанныеСерии = РеквизитыВводаСерии();
	ЗаполнитьЗначенияСвойств(ДанныеСерии, ДанныеДляЗаполнения);
	
	Возврат ДанныеСерии;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьФлагиРаботыСМеткой(Форма, СообщениеОбОшибке)
	
	GTIN = Форма.GTIN;
	НастройкиИспользованияСерий = Форма.НастройкиИспользованияСерий;
	ЭтоМаркировкаПерсонифицированнымиКиЗ = Форма.ЭтоМаркировкаПерсонифицированнымиКиЗ;
	ДанныеСерии = ДанныеСерии(Форма);
	
	RFIDКлиентСервер.ЗаполнитьФлагиРаботыСМеткой(ДанныеСерии, GTIN, Неопределено, НастройкиИспользованияСерий, ЭтоМаркировкаПерсонифицированнымиКиЗ, СообщениеОбОшибке);
	
	ЗаполнитьЗначенияСвойств(Форма,ДанныеСерии);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСериюЗавершитьВвод()
	
	ОчиститьСообщения();
	
	ВозвращаемоеЗначение = ВыбраннаяСерия();
	
	Если ЛОжь Тогда
		
		Серия = Элементы.ОстаткиСерий.ТекущиеДанные.Серия;
		
	ИначеЕсли НЕ ОбязательныеРеквизитыЗаполнены()
		Или НЕ НайтиСоздатьСерию() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ВозвращаемоеЗначение.Значение = Серия;
	Если ЭтоПеремаркировкаТоваровГИСМ Тогда
		ВозвращаемоеЗначение.ЗначениеСписываемойСерии = СерияСписываемая;
	КонецЕсли;
	ОповеститьОВыборе(ВозвращаемоеЗначение);
	Закрыть();
	
КонецПроцедуры

&НаСервере
Функция НайтиСоздатьСерию()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Серия = НайтиСерию();
	
	Если Не ЗначениеЗаполнено(Серия) Тогда
		
		СоздатьСерию();
		
	Иначе
	
		СерияОбъект = Серия.ПолучитьОбъект();
		
		СерияОбъект.RFIDTID  = RFIDTID;
		СерияОбъект.RFIDUser = RFIDUser;
		СерияОбъект.RFIDEPC  = RFIDEPC;
		СерияОбъект.EPCGTIN  = EPCGTIN;
		СерияОбъект.НомерГИСМ    = НомерГИСМ;
		СерияОбъект.Наименование = НомерКиЗГИСМ;
		СерияОбъект.Записать();
		
		Серия = СерияОбъект.Ссылка;
		
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(Серия);
	
КонецФункции

&НаСервере
Функция СоздатьСерию()
	
	СерияОбъект = Справочники.СерииНоменклатуры.СоздатьЭлемент();
	СерияОбъект.Владелец = Номенклатура;
	СерияОбъект.НомерКИЗГИСМ    = НомерКИЗГИСМ;
	
	СерияОбъект.RFIDTID        = RFIDTID;
	СерияОбъект.RFIDUser       = RFIDUser;
	СерияОбъект.RFIDEPC        = RFIDEPC;
	СерияОбъект.EPCGTIN        = EPCGTIN;
	СерияОбъект.НомерГИСМ      = НомерГИСМ;
	СерияОбъект.Наименование      = НомерКиЗГИСМ;
	
	СерияОбъект.Записать();
	
	Серия = СерияОбъект.Ссылка;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция НайтиСерию()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СерииНоменклатуры.Ссылка КАК Серия
	|ИЗ
	|	Справочник.СерииНоменклатуры КАК СерииНоменклатуры
	|ГДЕ
	|	СерииНоменклатуры.Владелец = &Владелец
	|	И СерииНоменклатуры.НомерКиЗГИСМ = &НомерКиЗГИСМ";
	
	Запрос.УстановитьПараметр("Владелец", Номенклатура);
	
	Запрос.УстановитьПараметр("НомерКиЗГИСМ", НомерКиЗГИСМ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Серия;
	КонецЕсли;
	
	Возврат Справочники.СерииНоменклатуры.ПустаяСсылка();
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВыбраннаяСерия()
	
	Возврат Новый Структура("Значение,ЗначениеСписываемойСерии,ИдентификаторТекущейСтроки");
	
КонецФункции

&НаСервере
Процедура НастроитьФормуПоШагу(Шаг)
	
	Если Шаг = "Шаг1" Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтаФорма, СерияСписываемаяКешВвода);
		
		Элементы.ПанельНавигации.ТекущаяСтраница = Элементы.СтраницаНавигацииНачало;
		Элементы.Далее.КнопкаПоУмолчанию = Истина;
		
		Элементы.Номер.ПодсказкаВвода = "";
		Элементы.Номер.Подсказка = "";
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Укажите списываемую серию'");
		ИскомаяСерия = СерияСписываемая;
	Иначе
		
		ЗаполнитьЗначенияСвойств(ЭтаФорма, СерияНоваяКешВвода);
		
		Элементы.ПанельНавигации.ТекущаяСтраница = Элементы.СтраницаНавигацииОкончание;
		Элементы.ОК.КнопкаПоУмолчанию = Истина;
		
		Если Не ЭтоМаркировкаПерсонифицированнымиКиЗ Тогда
			Элементы.Номер.ПодсказкаВвода = НСтр("ru = '<генерируются по данным RFID-метки>'");
			Элементы.Номер.Подсказка = НСтр("ru = 'генерируются по данным RFID-метки'");
		Иначе
			Элементы.Номер.ПодсказкаВвода = НСтр("ru = '<заполняется по данным КиЗ>'");
			Элементы.Номер.Подсказка = НСтр("ru = 'заполняется по данным КиЗ'");
		КонецЕсли;
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Укажите новую серию'");
		ИскомаяСерия = СерияНовая;
	КонецЕсли;
	
	СообщениеОбОшибке = "";
	ЗаполнитьФлагиРаботыСМеткой(ЭтаФорма, СообщениеОбОшибке);
	Если СообщениеОбОшибке <> "" Тогда
		ОбщегоНазначения.СообщитьПользователю(СообщениеОбОшибке);
	КонецЕсли;
	
	УстановитьВидимостьКомандыЗаписиRFID();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКомандыЗаписиRFID()
	
	ВидимостьКомандыЗаписиRFID = ПодключатьСчитывательRFID;
	
	ВидМаркировки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ВидМаркировки");
	
	Если ВидМаркировки = Перечисления.ВидыМаркировки.МаркируемаяПродукция Тогда
		
		Элементы.ЗаписатьВRFID.Видимость =
			ВидимостьКомандыЗаписиRFID
			И ЭтоПеремаркировкаТоваровГИСМ
			И Элементы.ПанельНавигации.ТекущаяСтраница = Элементы.СтраницаНавигацииОкончание
			И Не ЭтоМаркировкаПерсонифицированнымиКиЗ;
		
		
	ИначеЕсли ВидМаркировки = Перечисления.ВидыМаркировки.МаркируемаяПродукция Тогда 
		Элементы.ЗаписатьВRFID.Видимость= Ложь;
	Иначе
		Элементы.ЗаписатьВRFID.Видимость =
			ВидимостьКомандыЗаписиRFID
			И НастройкиИспользованияСерий.ИспользоватьRFIDМеткиСерии
			И (Не ЭтоПеремаркировкаТоваровГИСМ
				Или Элементы.ПанельНавигации.ТекущаяСтраница = Элементы.СтраницаНавигацииОкончание);
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Функция ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Если ДанныеШтрихкодов.Количество() <> 1 Тогда
		
		ТекстСообщения = НСтр("ru = 'Не поддерживается одновременное распознавание нескольких штрих-кодов серий. Сканируйте серии по одной.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Возврат Ложь;
		
	КонецЕсли;
	
	ОбработатьШтрихкодыСервер(ДанныеШтрихкодов);
	
	Возврат Истина;
	
КонецФункции


&НаСервере
Процедура ОбработатьШтрихкодыСервер(ДанныеШтрихкодов)
	
КонецПроцедуры


&НаСервере
Процедура ОбработатьСчитываниеRFID(ДанныеМеток)
	
	ПараметрыОбработки = RFIDСервер.ПараметрыОбработкиСчитанныхRFIDИКиЗ();
	ЗаполнитьЗначенияСвойств(ПараметрыОбработки,ЭтаФорма);
	
	РезультатОбработки = RFIDСервер.ОбработатьСчитываниеRFID(ДанныеМеток, ПараметрыОбработки);
	
	Если ЗначениеЗаполнено(РезультатОбработки.ДанныеСерии) Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, РезультатОбработки.ДанныеСерии);
		Элементы.ЗаписатьВRFID.Доступность = НужноЗаписатьМетку;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомерКиЗГИСМПриИзменении(Элемент)
	
	ЗаполнитьНомерГисм();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНомерГИСМ()
	
	тСерия = НайтиСерию();
	
	Если НЕ тСерия.Пустая() Тогда
		
		НомерГИСМ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(тСерия, "НомерГИСМ");
		
	КонецЕсли;
	
	
КонецПроцедуры



#КонецОбласти