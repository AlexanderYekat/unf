﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ДанныеВыбораПериодаИзВыпадающегоСписка;

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		Организация = Параметры.Организация;
	Иначе
		Организация = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
		Если Не ЗначениеЗаполнено(Организация) Тогда
			Организация = Справочники.Организации.ПредопределеннаяОрганизация();
		КонецЕсли;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	Заголовок = Заголовок + ?(ПустаяСтрока(Заголовок),"",": ") + НСтр("ru='Записи Книги учета доходов и расходов'");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(КУДиР, "Организация", Организация, , ,
		ЗначениеЗаполнено(Организация));
	ЗапуститьОбновлениеДанныхНаСервере();
	
	ВидПериода  = Перечисления.ДоступныеПериодыОтчета.Год;
	ОтборПериодЗначение.ДатаНачала = НачалоГода(ТекущаяДатаСеанса());
	ОтборПериодЗначение.ДатаОкончания  = КонецГода(ОтборПериодЗначение.ДатаНачала);
	
	ОтборПериодИспользование = Истина;
	ОтборПериод = ОтчетыУНФКлиентСервер.ПредставлениеСтандартногоПериода(ОтборПериодЗначение, ВидПериода);
	УстановитьОтборПоПериоду(ЭтаФорма, ОтборПериодЗначение.ДатаНачала, ОтборПериодЗначение.ДатаОкончания, ОтборПериодИспользование);
	НастроитьВидимостьИДоступность();
	
КонецПроцедуры
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьКнопкиУдалить();
	ЖдатьЗавершенияФоновогоЗадания();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДобавитьРучнуюЗаписьУСН(Команда)
	ОткрытьФорму("Документ.ЗаписиУСН.Форма.ФормаЗаписиКУДИР",Новый Структура("ДокументыЗаПериод, Организация", ДокументыЗаПериод, Организация),Элементы.КУДиР);
КонецПроцедуры


&НаКлиенте
Процедура КУДиРВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ Тип("ДокументСсылка.ЗакрытиеМесяца") = ТипЗнч(Элементы.КУДиР.ТекущиеДанные.Регистратор) Тогда
		ПараметрыФормы = Новый Структура(
		"Ключ, НомерСтроки",
		Элементы.КУДиР.ТекущиеДанные.Регистратор,
		Элементы.КУДиР.ТекущиеДанные.НомерСтрокиДокумента);
		
		ОткрытьФорму("Документ.ЗаписиУСН.Форма.ФормаЗаписиКУДИР",ПараметрыФормы,Элементы.КУДиР);
	Иначе  
		СтруктураОткрытия = Новый Структура;
		СтруктураОткрытия.Вставить("Месяц", Элементы.КУДиР.ТекущиеДанные.ДатаПервичногоДокумента);
		СтруктураОткрытия.Вставить("Организация", Организация);
		ОткрытьФорму("Обработка.ЗакрытиеМесяца.Форма", СтруктураОткрытия);
    КонецЕсли;
	
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "УдаленаЗаписьКУДИР" Тогда
		ОповеститьОбИзменении(Тип("РегистрНакопленияКлючЗаписи.КнигаУчетаДоходовИРасходов"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗапись(Команда)
	
	ТекущиеДанные = Элементы.КУДиР.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;  

	УдалитьЗаписьСервер(ТекущиеДанные.Регистратор,
		ТекущиеДанные.НомерСтрокиДокумента);
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура КУДиРПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКнопкиУдалить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКУДИР(Команда)
	
	СписокЗаписейАктуален = Ложь;
	
	Если ЗапуститьОбновлениеДанныхНаСервере() Тогда
		
		ЖдатьЗавершенияФоновогоЗадания();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(КУДиР, "Организация", Организация, , ,
		ЗначениеЗаполнено(Организация));
	НастроитьВидимостьИДоступность();
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Если ОтборПериодИспользование Тогда
		ДатаФормирования = ОтборПериодЗначение.ДатаОкончания;
	Иначе
		ДатаФормирования = ТекущаяДата();
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура("Организация, НачалоПериода, КонецПериода",
		Организация,
		НачалоГода(ДатаФормирования),
		КонецГода(ДатаФормирования));
	
	ОткрытьФорму("Отчет.КнигаУчетаДоходовИРасходов.Форма", ПараметрыОтчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НачалоПериода = ОтборПериодЗначение.ДатаНачала;
	Если НачалоПериода = '00010101' Тогда
		НачалоПериода = ОтчетыУНФКлиентСервер.НачалоПериодаОтчета(ВидПериода, ОбщегоНазначенияКлиент.ДатаСеанса());
	КонецЕсли;
	
	// Параметры для чтения из обработчиков:
	ПараметрыВыбора = Новый Структура;
	// Для выбора значения:
	ПараметрыВыбора.Вставить("Значение",               ОтборПериодЗначение);
	ПараметрыВыбора.Вставить("Элемент",                Элемент);
	// Для загрузки значения:
	ПараметрыВыбора.Вставить("ВидПериода",             ВидПериода);
	
	ВыборПериодаИзВыпадающегоСписка(-1, ПараметрыВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УстановитьОтборПоПериоду(ЭтаФорма, ОтборПериодЗначение.ДатаНачала, ОтборПериодЗначение.ДатаОкончания, ОтборПериодИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодИспользованиеПриИзменении(Элемент)
	УстановитьОтборПоПериоду(ЭтаФорма, ОтборПериодЗначение.ДатаНачала, ОтборПериодЗначение.ДатаОкончания, ОтборПериодИспользование);
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСДаты(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПересчитатьСДатыЗавершение", ЭтаФорма);
	ПоказатьВводДаты(Оповещение, ТекущаяДата(), НСтр("ru = 'Пересчитать с даты'"), ЧастиДаты.Дата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСДатыЗавершение(Период, ДополнительныеДанные) Экспорт
	Если Период = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьДатуГраницыФормирования(Период);
	
	СписокЗаписейАктуален = Ложь;
	
	Если ЗапуститьОбновлениеДанныхНаСервере(Период) Тогда
		
		ЖдатьЗавершенияФоновогоЗадания();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияУстановитьСдаватьОтчетностьНажатие(Элемент)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", Организация);
	ПараметрыОткрытия.Вставить("УстановитьТекущийЭлемент", "ИспользуетсяОтчетность");
	
	ОткрытьФорму("Справочник.Организации.ФормаОбъекта", ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьВидимостьИДоступность()
	
	ВидимостьГруппыИспользуетсяОтчетность = Ложь;
	ВидимостьЭтоЮридическоеЛицо = Ложь;
	
	Если Не Организация.Пустая() Тогда
		ЗначенияРеквизитовСтруктура = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "ИспользуетсяОтчетность, ЮридическоеФизическоеЛицо");
		Если ЗначенияРеквизитовСтруктура.ЮридическоеФизическоеЛицо = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо") Тогда
			ВидимостьЭтоЮридическоеЛицо = Истина;
		ИначеЕсли Не ЗначенияРеквизитовСтруктура.ИспользуетсяОтчетность Тогда
			ВидимостьГруппыИспользуетсяОтчетность = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ДекорацияЭтоЮридическоеЛицо.Видимость = ВидимостьЭтоЮридическоеЛицо;
	Элементы.ГруппаИспользуетсяОтчетность.Видимость = ВидимостьГруппыИспользуетсяОтчетность;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЗаписьСервер(Документ, НомерСтроки)
	
	Если Документ <> Неопределено Тогда
		Объект = Документ.ПолучитьОбъект();
		РабочаяСтрока = Объект.ЗаписиКУДиР[НомерСтроки-1];
		Объект.ЗаписиКУДиР.Удалить(РабочаяСтрока);
		Объект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКнопкиУдалить()
	
	Элементы.ФормаУдалитьЗапись.Доступность = (Элементы.КУДиР.ТекущиеДанные <> Неопределено)
	И НЕ Тип("ДокументСсылка.ЗакрытиеМесяца") = ТипЗнч(Элементы.КУДиР.ТекущиеДанные.Регистратор);
	
КонецПроцедуры


&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	// СписокЗадачОрганизация
	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента 		= ЭлементУО.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных("КУДиРОрганизация");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Организация", ВидСравненияКомпоновкиДанных.НеРавно, Справочники.Организации.ПустаяСсылка());

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ЖдатьЗавершенияФоновогоЗадания()
	
	Если ФоновоеЗаданиеЗадачЗапущено Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьЗавершениеДлительнойОперации",
			1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Запускает фоновое задание обновления Задач отчетности.
//
Функция ЗапуститьОбновлениеДанныхНаСервере(Период = Неопределено)
	
	
	Если МонопольныйРежим() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ФоновоеЗаданиеЗадачЗапущено Тогда
		// Надо ждать
		Возврат Истина;
	КонецЕсли;
	
	ПараметрыФункции = Новый Структура(); 
	
	// заданный период перерасчета больше конца текущего квартала
	Если Период <> Неопределено И Период > КонецКвартала(ТекущаяДатаСеанса())Тогда
		ПараметрыФункции.Вставить("ДатаФормирования", КонецКвартала(Период));
	// выбран будущий период в шапке	
	ИначеЕсли КонецКвартала(ТекущаяДатаСеанса())< ОтборПериодЗначение.ДатаНачала Тогда
		ПараметрыФункции.Вставить("ДатаФормирования", КонецКвартала(ОтборПериодЗначение.ДатаНачала));
	Иначе	
		ПараметрыФункции.Вставить("ДатаФормирования", КонецКвартала(ТекущаяДатаСеанса()));
	КонецЕсли;
	
	НаименованиеЗадания = НСтр("ru = 'Обновление списка записей КУДиР'");
	ИмяПроцедуры = "РегламентированнаяОтчетностьУСН.ВыполнитьФормированияВсехЗаписейКУДИР_ФоновоеЗадание";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	Результат = ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыФункции, ПараметрыВыполнения);
	
	ФоновоеЗаданиеЗадачИдентификатор   = Результат.ИдентификаторЗадания;
	
	Если Результат.Статус = "Выполнено" Тогда
		СписокЗаписейАктуален = Истина;
		УправлениеФормой(ЭтаФорма);
	Иначе
		// Начнем ждать
		ФоновоеЗаданиеЗадачЗапущено = Истина;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьЗавершениеДлительнойОперации()
	
	Если ФоновоеЗаданиеЗадачЗапущено Тогда
		
		Если ЗаданиеВыполнено(ФоновоеЗаданиеЗадачИдентификатор) Тогда
			
			ФоновоеЗаданиеЗадачЗапущено = Ложь;
			ОповеститьОбИзменении(Тип("РегистрНакопленияКлючЗаписи.КнигаУчетаДоходовИРасходов"));
			СписокЗаписейАктуален = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	
	Если ФоновоеЗаданиеЗадачЗапущено  Тогда
		// Продолжим ожидание
		ПодключитьОбработчикОжидания(
			"Подключаемый_ПроверитьЗавершениеДлительнойОперации",
			1,
			Истина);
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Если Форма.СписокЗаписейАктуален Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаКУДиР;
	Иначе
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаОжидание;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПериоду(Форма, НачалоПериода, КонецПериода, Использование)
	
	ОтборКомпоновкиДанных = Форма.КУДиР.КомпоновщикНастроек.Настройки.Отбор;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		ОтборКомпоновкиДанных, "ГодДокумента");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ОтборКомпоновкиДанных, "ГодДокумента", Год(НачалоПериода), ВидСравненияКомпоновкиДанных.Равно, "ДатаПервичногоДокументаНачало", Использование);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПериодаИзВыпадающегоСписка(Результат, ПараметрыВыбора) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат; // Отмена выбора.
	КонецЕсли;
	
	Если Результат = -1 Тогда // Начало выбора.
		// Чтение параметров для формирования списка из сохраненного значения периода.
		ПараметрыВыбора.Вставить("НачалоПериода", ПараметрыВыбора.Значение.ДатаНачала);
		ПараметрыВыбора.Вставить("Вариант",       ПараметрыВыбора.Значение.Вариант);
		ИндексНачальногоЗначения = Неопределено;
	ИначеЕсли ТипЗнч(Результат.Значение) = Тип("Структура") Тогда
		// Чтение параметров для формирования списка из выбранного значения.
		ПараметрыВыбора.Вставить("НачалоПериода", Результат.Значение.НачалоПериода);
		ПараметрыВыбора.Вставить("Вариант",       Результат.Значение.Вариант);
		ИндексНачальногоЗначения = Результат.Значение.ИндексНачальногоЗначения;
	Иначе
		// Загрузка результата выбора.
		ЗагрузитьРезультатВыбораПериодаИзВыпадающегоСписка(Результат, ПараметрыВыбора);
		Возврат;
	КонецЕсли;
	
	// Формирование списка выбора.
	Если ПараметрыВыбора.Вариант = Неопределено Или ПараметрыВыбора.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод Тогда
		
		СписокПериодов = ОтчетыУНФКлиентСервер.СписокФиксированныхПериодов(ПараметрыВыбора.НачалоПериода, ПараметрыВыбора.ВидПериода);
		
		Если ИндексНачальногоЗначения = Неопределено Тогда
			ИндексНачальногоЗначения = СписокПериодов.НайтиПоЗначению(ПараметрыВыбора.НачалоПериода);
		КонецЕсли;
		
		ОписаниеНавигационногоЭлемента = Новый Структура;
		ОписаниеНавигационногоЭлемента.Вставить("НачалоПериода",            СписокПериодов[0].Значение);
		ОписаниеНавигационногоЭлемента.Вставить("Вариант",                  Неопределено);
		ОписаниеНавигационногоЭлемента.Вставить("ИндексНачальногоЗначения", 0);
		СписокПериодов[0].Значение = ОписаниеНавигационногоЭлемента;
		
		ОписаниеНавигационногоЭлемента = Новый Структура;
		ОписаниеНавигационногоЭлемента.Вставить("НачалоПериода",            СписокПериодов[8].Значение);
		ОписаниеНавигационногоЭлемента.Вставить("Вариант",                  Неопределено);
		ОписаниеНавигационногоЭлемента.Вставить("ИндексНачальногоЗначения", 8);
		СписокПериодов[8].Значение = ОписаниеНавигационногоЭлемента;
		
		Если Не ПараметрыВыбора.Свойство("ВариантСтандартногоПериодаПоВиду") Тогда
			ПараметрыВыбора.Вставить("ВариантСтандартногоПериодаПоВиду", ОтчетыУНФКлиентСервер.ПривестиВидПериодаКСтандартному(ПараметрыВыбора.ВидПериода));
		КонецЕсли;
		
		
	Иначе
		
		СписокПериодов = ОтчетыУНФКлиентСервер.СписокВычисляемыхПериодов(ПараметрыВыбора.ВидПериода);
		
		Если ИндексНачальногоЗначения = Неопределено Тогда
			ИндексНачальногоЗначения = СписокПериодов.НайтиПоЗначению(ПараметрыВыбора.Вариант);
		КонецЕсли;
		
		ОписаниеНавигационногоЭлемента = Новый Структура;
		ОписаниеНавигационногоЭлемента.Вставить("НачалоПериода",            ПараметрыВыбора.НачалоПериода);
		ОписаниеНавигационногоЭлемента.Вставить("Вариант",                  Неопределено);
		ОписаниеНавигационногоЭлемента.Вставить("ИндексНачальногоЗначения", Неопределено);
		СписокПериодов.Добавить(ОписаниеНавигационногоЭлемента, НСтр("ru = 'Фиксированный...'"));
		
	КонецЕсли;
	
	Если ИндексНачальногоЗначения = Неопределено Тогда
		ИндексНачальногоЗначения = СписокПериодов.Количество() - 1;
	КонецЕсли;
	
	ДанныеВыбораПериодаИзВыпадающегоСписка = Новый Структура;
	ДанныеВыбораПериодаИзВыпадающегоСписка.Вставить("ПараметрыВыбора", ПараметрыВыбора);
	ДанныеВыбораПериодаИзВыпадающегоСписка.Вставить("СписокПериодов", СписокПериодов);
	ДанныеВыбораПериодаИзВыпадающегоСписка.Вставить("ИндексНачальногоЗначения", ИндексНачальногоЗначения);
	Если Результат = -1 Тогда
		НачатьВыборПериодаИзВыпадающегоСписка();
	Иначе
		ПодключитьОбработчикОжидания("НачатьВыборПериодаИзВыпадающегоСписка", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьВыборПериодаИзВыпадающегоСписка()
	
	Если ДанныеВыбораПериодаИзВыпадающегоСписка.Свойство("ПараметрыВыбора") Тогда
		Контекст = ДанныеВыбораПериодаИзВыпадающегоСписка;
		ДанныеВыбораПериодаИзВыпадающегоСписка = Новый Структура;
		Обработчик = Новый ОписаниеОповещения("ВыборПериодаИзВыпадающегоСписка", ЭтотОбъект, Контекст.ПараметрыВыбора);
		ПоказатьВыборИзСписка(Обработчик, Контекст.СписокПериодов, Контекст.ПараметрыВыбора.Элемент, Контекст.ИндексНачальногоЗначения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРезультатВыбораПериодаИзВыпадающегоСписка(Результат, ПараметрыВыбора)
	
	Значение = ПараметрыВыбора.Значение;
	
	// Запись результата выбора в данные формы и пользовательские настройки КД.
	Если ТипЗнч(Результат.Значение) = Тип("ВариантСтандартногоПериода") Тогда
		ОтборПериод = ?(ПустаяСтрока(Результат.Представление), Строка(Результат.Значение), Результат.Представление);
		Значение.Вариант = Результат.Значение;
	Иначе
		ОтборПериодЗначение.ДатаНачала = ОтчетыУНФКлиентСервер.НачалоПериодаОтчета(ПараметрыВыбора.ВидПериода, Результат.Значение);
		ОтборПериодЗначение.ДатаОкончания  = ОтчетыУНФКлиентСервер.КонецПериодаОтчета(ПараметрыВыбора.ВидПериода, Результат.Значение);
		
		ОтборПериод = Результат.Представление;
		
		Значение.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод;
		Значение.ДатаНачала    = ОтборПериодЗначение.ДатаНачала;
		Значение.ДатаОкончания = ОтборПериодЗначение.ДатаОкончания;
	КонецЕсли;
	
	ОтборПериодЗначение = Значение;
	УстановитьОтборПоПериоду(ЭтаФорма, ОтборПериодЗначение.ДатаНачала, ОтборПериодЗначение.ДатаОкончания, ОтборПериодИспользование);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьДатуГраницыФормирования(Период)
	ДатаГраницыФормирования = РегламентированнаяОтчетностьУСН.ПолучитьДатуНачалаФормированияЗаписейКУДиР();
	Если Период < ДатаГраницыФормирования Тогда
		РегламентированнаяОтчетностьУСН.УстановитьДатуНачалаФормированияЗаписейКУДиР(Период);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
