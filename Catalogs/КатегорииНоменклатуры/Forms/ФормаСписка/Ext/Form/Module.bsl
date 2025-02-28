﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("РежимВыбора") И Параметры.РежимВыбора Тогда
		РежимВыбора = Истина;
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
	
	ОбъектМетаданных = Справочники.Номенклатура.ПустаяСсылка().Метаданные();
	РазрешеноРедактированиеНоменклатуры = ПравоДоступа("Добавление", ОбъектМетаданных) Или ПравоДоступа("Изменение",
		ОбъектМетаданных);
	
	ОпределитьПраваРаботыСНоменклатурой();
	
	УстановитьВидимостьОпросаРаботаСНоменклатурой();
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НастройкаПорядкаЭлементов", "Отображение", ОтображениеГруппыКнопок.Компактное);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	РаботаСНоменклатурой.ПриСозданииНаСервереФормаСпискаВидаНоменклатуры(ЭтотОбъект, ЭтотОбъект.КоманднаяПанель);
	ПереместитьКнопкиСервиса1СНоменклатура();
	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		// Т.к. платформа не позволяет выборочно управлять видимостью элементов в мобильном клиенте, здесь мы это делаем программно
		Элементы.ПраваяКолонка.ОтображатьЗаголовок = Истина;
		Элементы.СвернутьПанель.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроверитьСостояниеСервиса();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	Если ИмяСобытия = РаботаСНоменклатуройКлиент.ОписаниеОповещенийПодсистемы().ЗагрузкаКатегорий Тогда
		Если Параметр.Количество() > 0 Тогда
			Элементы.Список.ТекущаяСтрока = Параметр[0];
		КонецЕсли;
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой
	
	Если ИмяСобытия = "ИнтернетПоддержкаПодключена"
		ИЛИ ИмяСобытия = "ИнтернетПоддержкаОтключена" Тогда
		ПроверитьСостояниеСервиса();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьПанельНажатие(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	
	СтруктураИменЭлементов = Новый Структура("ФильтрыНастройкиИДопИнфо, ДекорацияРазвернутьОтборы, ПраваяПанель",
		"ФильтрыНастройкиИДопИнфо","РазвернутьПанель","ПраваяКолонка");
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость, СтруктураИменЭлементов);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьПанельНажатие(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	
	СтруктураИменЭлементов = Новый Структура("ФильтрыНастройкиИДопИнфо, ДекорацияРазвернутьОтборы, ПраваяПанель",
		"ФильтрыНастройкиИДопИнфо","РазвернутьПанель","ПраваяКолонка");
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость, СтруктураИменЭлементов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодключитьСервис1СНоменклатура(Команда)
	
	ПодключитьСервис1СНоменклатураСервер();
	ПроверитьСостояниеСервиса();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКатегориюИзСервиса1СНоменклатура(Команда)
	
	Подключаемый_ПодобратьКатегорииИзСервиса(Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОпрос(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ФормаОпроса1СНоменклатура",,,,,,
		Новый ОписаниеОповещения("ОткрытьОпросЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОпросЗавершение(ОпросЗавершен, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ОпросЗавершен) <> Тип("Булево") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаОпросРаботаСНоменклатурой.Видимость = НЕ ОпросЗавершен;
	
КонецПроцедуры

#Область ОбработкаКомандУведомлений

&НаКлиенте
Процедура ГруппаУведомленияСервисаКонтекстКомандаНажатие(Элемент)
	
	Если Не ПодключенаИнтернетПоддержка Тогда 
		
		ПодключитьИнтернетПоддержкуПользователейНажатие();
		
	ИначеЕсли Не ЕстьДоступныеОпции И ДоступенСтартовыйПакет Тогда 
		
		ПодключитьСтартовыйПакет();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПодключениеИнтернетПоддержки

&НаКлиенте
Процедура ПодключитьИнтернетПоддержкуПользователейНажатие()
	
	ПодключитьИнтернетПоддержкуПользователейНажатиеПродолжение = Новый ОписаниеОповещения(
		"ПодключитьИнтернетПоддержкуПользователейНажатиеПродолжение", ЭтотОбъект);
	
	ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
			ПодключитьИнтернетПоддержкуПользователейНажатиеПродолжение,
			ЭтотОбъект);

КонецПроцедуры
	
&НаКлиенте
Процедура ПодключитьИнтернетПоддержкуПользователейНажатиеПродолжение(Результат, ДополнительныеПараметры) Экспорт 
	
	ПроверитьСостояниеСервиса();
	
КонецПроцедуры

#КонецОбласти

#Область ПодключениеСтартовогоПакета

&НаКлиенте
Процедура ПодключитьСтартовыйПакет()
	
	ОбработчикЗавершения = Новый ОписаниеОповещения(
		"ПодключитьСтартовыйПакетЗавершение",
		ЭтотОбъект);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОбработчикЗавершения", ОбработчикЗавершения);
	
	РаботаСНоменклатуройКлиент.ПодключитьТестовыйПериод(ЭтотОбъект, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьСтартовыйПакетЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПроверитьСостояниеСервиса();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ПроверкаСостоянияСервисИОтображениеУведомлений

&НаСервере
Процедура ОпределитьПраваРаботыСНоменклатурой()
	
	ИспользоватьСервисРаботаСНоменклатурой = ПолучитьФункциональнуюОпцию("ИспользоватьСервисРаботаСНоменклатурой");
	РазрешеноПодключениеПодсистемыРаботаСНоменклатурой = Пользователи.ЭтоПолноправныйПользователь();
	Если ИспользоватьСервисРаботаСНоменклатурой Тогда
		РазрешенаРаботаСПодсистемойРаботаСНоменклатурой = ПравоДоступа("Использование",
			Метаданные.Обработки.РаботаСНоменклатурой);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСостояниеСервиса()
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ИдентификаторЗадания", ИдентификаторЗадания);
	
	ПроверитьСостояниеСервисаЗавершение = Новый ОписаниеОповещения("ПроверитьСостояниеСервисаЗавершение",
		ЭтотОбъект, ПараметрыЗавершения);
		
	Если ИспользоватьСервисРаботаСНоменклатурой Тогда
		РаботаСНоменклатуройКлиент.ПроверитьСостояниеСервиса(ПроверитьСостояниеСервисаЗавершение, ЭтотОбъект, ИдентификаторЗадания);
	Иначе
		ВыполнитьОбработкуОповещения(ПроверитьСостояниеСервисаЗавершение, РаботаСНоменклатуройСлужебныйКлиентСервер.ОписаниеСостоянияСервиса());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСостояниеСервисаЗавершение(Результат, ДополнительныеПараметры = Неопределено) Экспорт 
	
	Если ИдентификаторЗадания <> ДополнительныеПараметры.ИдентификаторЗадания Тогда 
		Возврат;
	КонецЕсли;
	ИдентификаторЗадания = Неопределено;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Результат);
	ПоказатьСкрытьУведомленияСервисаРаботаСНоменклатурой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьСкрытьУведомленияСервисаРаботаСНоменклатурой(Форма)
	
	Элементы = Форма.Элементы;
	ОтобразитьУведомление = Ложь;
	
	Если Не Форма.ПодключенаИнтернетПоддержка Тогда 
		
		Элементы.ГруппаУведомленияСервисаИзображение.Картинка = БиблиотекаКартинок.Предупреждение32;
		Элементы.ГруппаУведомленияСервисаКонтекстЗаголовок.Заголовок = НСтр("ru = 'Не подключена Интернет-поддержка пользователей'");
		Элементы.ГруппаУведомленияСервисаКонтекстИнформация.Заголовок = НСтр("ru = 'Для работы с сервисом 1С:Номенклатура нужно подключить Интернет-поддержку пользователей.'");
		Элементы.ГруппаУведомленияСервисаКонтекстКоманда.Видимость = Истина;
		Элементы.ГруппаУведомленияСервисаКонтекстКоманда.Заголовок = НСтр("ru = 'Подключить Интернет-поддержку пользователей'");
		Элементы.ГруппаУведомленияСервисаКонтекстКоманда.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		Элементы.ГруппаУведомленияСервисаУсловияИспользованияСервиса.Видимость = Ложь;
		
		ОтобразитьУведомление = Истина;
		
	ИначеЕсли Не Форма.ЕстьДоступныеОпции И Форма.ДоступенСтартовыйПакет Тогда 
		
		Элементы.ГруппаУведомленияСервисаИзображение.Картинка = БиблиотекаКартинок.ИнформацияРаботаСНоменклатурой32;
		Элементы.ГруппаУведомленияСервисаКонтекстЗаголовок.Заголовок = НСтр("ru = 'Доступен бесплатный пакет'");
		
		Информация = Новый Массив;
		Информация.Добавить(НСтр("ru = 'Для начала работы с сервисом можно подключить бесплатный стартовый пакет карточек 1С:Номенклатуры.'"));
		
		Если Форма.РазделениеВключено Тогда 
			Информация.Добавить(Символы.ПС);
			Информация.Добавить(Символы.ПС);
			Информация.Добавить(НСтр("ru = 'Для подключения'") + " ");
			Информация.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'стартового пакета в 10000 карточек на срок 1 год'"),, Форма.ЦветНадписи));
			Информация.Добавить(" " + НСтр("ru = 'обратитесь к обслуживающему Вас партнеру фирмы ""1С"".'"));
			Элементы.ГруппаУведомленияСервисаКонтекстКоманда.Видимость = Ложь;
			Элементы.ГруппаУведомленияСервисаУсловияИспользованияСервиса.Видимость = Ложь;
		Иначе
			Элементы.ГруппаУведомленияСервисаКонтекстКоманда.Видимость = Истина;
			Элементы.ГруппаУведомленияСервисаКонтекстКоманда.Заголовок = НСтр("ru = 'Подключить бесплатный стартовый пакет'");
			Элементы.ГруппаУведомленияСервисаКонтекстКоманда.РасширеннаяПодсказка.Заголовок = НСтр("ru = 'Когда пакет закончится, нужно будет приобрести платный пакет у обслуживающего Вас партнера фирмы ""1С"".'");
			Элементы.ГруппаУведомленияСервисаКонтекстКоманда.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
			
			Элементы.ГруппаУведомленияСервисаУсловияИспользованияСервиса.Видимость = Истина;
			АдресУсловийИспользованияСервиса = "https://catalog-api.1c.ru/agreement/";
			ЗаголовокУсловияИспользования = Новый Массив;
			ЗаголовокУсловияИспользования.Добавить(НСтр("ru = 'Нажатие ""Подключить бесплатный стартовый пакет"" означает согласие с'") + " ");
			ЗаголовокУсловияИспользования.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Условиями использования сервиса'"),,,,АдресУсловийИспользованияСервиса));
			Элементы.ГруппаУведомленияСервисаУсловияИспользованияСервиса.Заголовок = Новый ФорматированнаяСтрока(ЗаголовокУсловияИспользования);
		КонецЕсли;
		
		Элементы.ГруппаУведомленияСервисаКонтекстИнформация.Заголовок = Новый ФорматированнаяСтрока(Информация);
		
		ОтобразитьУведомление = Истина;
		
	ИначеЕсли Не Форма.ЕстьДоступныеОпции Тогда 
		
		Элементы.ГруппаУведомленияСервисаИзображение.Картинка = БиблиотекаКартинок.Предупреждение32;
		Элементы.ГруппаУведомленияСервисаКонтекстЗаголовок.Заголовок = НСтр("ru = 'Отсутствуют подключенные пакеты'");
		Элементы.ГруппаУведомленияСервисаКонтекстКоманда.Видимость = Ложь;
		Элементы.ГруппаУведомленияСервисаУсловияИспользованияСервиса.Видимость = Ложь;
		
		Информация = Новый Массив;
		Информация.Добавить(НСтр("ru = 'Лимит карточек исчерпан или срок активных пакетов истек, необходимо приобрести платный пакет у обслуживающего Вас партнера фирмы ""1С"".'"));
		Информация.Добавить(Символы.ПС);
		Информация.Добавить(Символы.ПС);
		Информация.Добавить(НСтр("ru = 'Если у Вас нет обслуживающего партнера, Вы можете выбрать его из'") + " ");
		Адрес = "http://its.1c.ru/news/redirect?utm_medium=prog&url=http://its.1c.ru/partners/";
		Информация.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'списка партнеров в Вашем регионе'"),,,,Адрес));
		Информация.Добавить(".");
		Элементы.ГруппаУведомленияСервисаКонтекстИнформация.Заголовок = Новый ФорматированнаяСтрока(Информация);
		
		
		ОтобразитьУведомление = Истина;
		
	КонецЕсли;
	
	Элементы.ГруппаУведомленияСервиса.Видимость = 
		(ОтобразитьУведомление И Форма.ИспользоватьСервисРаботаСНоменклатурой И Не Форма.ОшибкаОпределенияСостояния);
		
	Элементы.ПодключитьСервис1СНоменклатура.Видимость = НЕ Форма.ИспользоватьСервисРаботаСНоменклатурой;
	Элементы.ПодключитьСервис1СНоменклатура.Доступность = Форма.РазрешеноПодключениеПодсистемыРаботаСНоменклатурой;
	Элементы.ДобавитьКатегориюИзСервиса1СНоменклатура.Видимость = 
		Форма.ИспользоватьСервисРаботаСНоменклатурой
		И Форма.РазрешеноРедактированиеНоменклатуры
		И Форма.РазрешенаРаботаСПодсистемойРаботаСНоменклатурой;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПереместитьКнопкиСервиса1СНоменклатура()
	
	КнопкаПодобратьКатегорииИзСервиса = Элементы.Найти("ПодобратьКатегорииИзСервиса");
	КнопкаСкопировать = Элементы.Найти("ФормаСкопировать");
	Если КнопкаПодобратьКатегорииИзСервиса = Неопределено ИЛИ КнопкаСкопировать = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Переместить(КнопкаПодобратьКатегорииИзСервиса, Элементы.ФормаКоманднаяПанель, КнопкаСкопировать);
	
КонецПроцедуры

&НаСервере
Процедура ПодключитьСервис1СНоменклатураСервер()
	
	Константы.ИспользоватьСервисРаботаСНоменклатурой.Установить(Истина);
	ОпределитьПраваРаботыСНоменклатурой();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьОпросаРаботаСНоменклатурой()
	
	Если НЕ РазрешенаРаботаСПодсистемойРаботаСНоменклатурой Тогда
		Элементы.ГруппаОпросРаботаСНоменклатурой.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОпросРаботаСНоменклатуройПройден.Значение
	|ИЗ
	|	Константа.ОпросРаботаСНоменклатуройПройден КАК ОпросРаботаСНоменклатуройПройден";
	
	ОпросРаботаСНоменклатуройПройден = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОпросРаботаСНоменклатуройПройден = Выборка.Значение;
	КонецЦикла;
	УстановитьПривилегированныйРежим(Ложь);
	
	Элементы.ГруппаОпросРаботаСНоменклатурой.Видимость = НЕ ОпросРаботаСНоменклатуройПройден;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ЭлектронноеВзаимодействие.РаботаСНоменклатурой

&НаКлиенте
Процедура Подключаемый_ПодобратьКатегорииИзСервиса(Команда)
	
	РаботаСНоменклатуройКлиент.ПодобратьКатегорииИзСервиса(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.РаботаСНоменклатурой

#КонецОбласти

