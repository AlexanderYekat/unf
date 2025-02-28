﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НесколькоВидовЗаказов = ПолучитьФункциональнуюОпцию("ИспользоватьВидыЗаказовПокупателей");
	
	Если Параметры.Свойство("Заголовок") И НЕ ПустаяСтрока(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли; 
	Параметры.Свойство("Подсказка", Подсказка);
	Элементы.Подсказка.Видимость = НЕ ПустаяСтрока(Подсказка);
	Параметры.Свойство("ИмяРеквизита", ИмяРеквизита);
	
	ЗаполнитьТаблицуИСоздатьЭлементы();
	
	КлючСохраненияПоложенияОкна = "ОбщаяФорма.ФормаНастройкиФиксированныхСостоянийЗаказов."+Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия="Добавление_СостоянияЗаказовПокупателей" Тогда
		//ОбновитьСпискиВыбора(Параметр, ТекущийЭлемент.Имя);
	ИначеЕсли ИмяСобытия="Запись_ВидыЗаказовПокупателей" Тогда
		//ОбновитьСпискиВыбора(Параметр, , Ложь);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗакрытиеССохранением И ПустаяСтрока(ИмяРеквизита) Тогда
		Оповестить("ИзмененыФиксированныеСостоянияЗаказов", "НеНастроено");
	КонецЕсли; 	
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Подключаемый_НеИспользоватьДоставкуПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если НЕ РезультатПроверкиЗаполнения() Тогда
		Возврат;
	КонецЕсли;
	СохранитьИзменения();
	Оповестить("ИзмененыФиксированныеСостоянияЗаказов", ИмяРеквизита);
	ЗакрытиеССохранением = Истина;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	ВОднуКолонку = НЕ (ПустаяСтрока(Форма.ИмяРеквизита));
	КоличествоИтераций = ?(ВОднуКолонку, 1, 3);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Отмена", "Доступность", ВОднуКолонку);
	
	Для каждого СтрокаТабличнойЧасти Из Форма.ТаблицаСостояний Цикл
		Индекс = Форма.ТаблицаСостояний.Индекс(СтрокаТабличнойЧасти);
		Для ии = 1 По КоличествоИтераций Цикл
			ИмяЭлемента = "Состояние"+Формат(Индекс, "ЧН=0; ЧГ=0")+"_"+ии;
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, ИмяЭлемента, "Доступность", НЕ СтрокаТабличнойЧасти.НеИспользоватьДоставку);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, ИмяЭлемента, "АвтоОтметкаНезаполненного", НЕ СтрокаТабличнойЧасти.НеИспользоватьДоставку);
			Если СтрокаТабличнойЧасти.НеИспользоватьДоставку Тогда
				СтрокаТабличнойЧасти.СостояниеОжидаетОтгрузки = ПредопределенноеЗначение("Справочник.СостоянияЗаказовПокупателей.ПустаяСсылка");
				СтрокаТабличнойЧасти.СостояниеОтгружен = ПредопределенноеЗначение("Справочник.СостоянияЗаказовПокупателей.ПустаяСсылка");
				СтрокаТабличнойЧасти.СостояниеДоставлен = ПредопределенноеЗначение("Справочник.СостоянияЗаказовПокупателей.ПустаяСсылка");
			КонецЕсли; 
		КонецЦикла; 
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Подсказка", "Ширина", ?(ВОднуКолонку ИЛИ НЕ Форма.НесколькоВидовЗаказов, 45, 80));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Подсказка", "МаксимальнаяШирина", ?(ВОднуКолонку ИЛИ НЕ Форма.НесколькоВидовЗаказов, 45, 80));
	Если ВОднуКолонку ИЛИ НЕ Форма.НесколькоВидовЗаказов Тогда
		ВысотаПодсказки = Цел(СтрДлина(Форма.Подсказка)/65)+?(СтрДлина(Форма.Подсказка)%65=0, 0, 1);
	Иначе
		ВысотаПодсказки = Цел(СтрДлина(Форма.Подсказка)/120)+?(СтрДлина(Форма.Подсказка)%120=0, 0, 1);
	КонецЕсли; 
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Подсказка", "Высота", ВысотаПодсказки);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуИСоздатьЭлементы()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыЗаказовПокупателей.Ссылка КАК ВидЗаказа,
	|	ВидыЗаказовПокупателей.СостояниеДоставлен,
	|	ВидыЗаказовПокупателей.СостояниеОтгружен,
	|	ВидыЗаказовПокупателей.СостояниеОжидаетОтгрузки,
	|	ВидыЗаказовПокупателей.НеИспользоватьДоставку,
	|	ВидыЗаказовПокупателей.ПорядокСостояний.(
	|		Состояние
	|	)
	|ИЗ
	|	Справочник.ВидыЗаказовПокупателей КАК ВидыЗаказовПокупателей
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидыЗаказовПокупателей.Наименование";
	Выборка = Запрос.Выполнить().Выбрать();
	
	ВОднуКолонку = НЕ (ПустаяСтрока(ИмяРеквизита));
	КоличествоИтераций = ?(ВОднуКолонку, 1, 3);
	
	Если НесколькоВидовЗаказов Тогда
		// Шапка
		Если НЕ ВОднуКолонку Тогда
			Для ии = 1 По КоличествоИтераций Цикл
				ПодГруппа = Элементы[СтрШаблон("Колонка%1", ии)];
				ИмяСостояния = ИмяРеквизитаПоИндексу(ии);
				ПредставлениеСостояния = Метаданные.Справочники.ВидыЗаказовПокупателей.Реквизиты[ИмяСостояния].Синоним;
				Если ии = 1 Тогда
					Элемент = Элементы.Добавить("СостояниеЗаголовок", Тип("ПолеФормы"), ПодГруппа);
					Элемент.ПутьКДанным = "ЗаголовокПервыйЭлемент";
					Элемент.Вид = ВидПоляФормы.ПолеНадписи;
					Элемент.АвтоМаксимальнаяШирина = Ложь;
					Элемент.МаксимальнаяШирина = 15;     
					Элемент.Заголовок = НСтр("ru = 'Вид заказа'");
					ЗаголовокПервыйЭлемент = ПредставлениеСостояния;
				Иначе
					Элемент = Элементы.Добавить(СтрШаблон("Заголовок%1", ИмяСостояния), Тип("ДекорацияФормы"), ПодГруппа);
					Элемент.Вид = ВидДекорацииФормы.Надпись;
					Элемент.Заголовок = ПредставлениеСостояния;
					Элемент.АвтоМаксимальнаяШирина = Ложь;
					Элемент.МаксимальнаяШирина = 15;
				КонецЕсли;
				Элемент.Шрифт = Новый Шрифт(Элемент.Шрифт, , , Истина);
			КонецЦикла; 
		КонецЕсли;
		// Виды заказов
		Пока Выборка.Следующий() Цикл
			СтрокаТабличнойЧасти = ТаблицаСостояний.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
			Индекс = ТаблицаСостояний.Индекс(СтрокаТабличнойЧасти);
			Для ии = 1 По КоличествоИтераций Цикл
				Если НесколькоВидовЗаказов И ии=КоличествоИтераций Тогда
					ПодГруппа = Элементы.Добавить(СтрШаблон("ГруппаСостояние%1", Формат(Индекс, "ЧН=0; ЧГ=0")), Тип("ГруппаФормы"), 
						Элементы[СтрШаблон("Колонка%1", ии)]);
					ПодГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
					ПодГруппа.ОтображатьЗаголовок = Ложь;
					ПодГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
					ПодГруппа.РастягиватьПоГоризонтали = Истина;
					ПодГруппа.СквозноеВыравнивание = СквозноеВыравнивание.Использовать;
				Иначе
					ПодГруппа = Элементы["Колонка"+ии];
				КонецЕсли; 
				Элемент = Элементы.Добавить(СтрШаблон("Состояние%1_%2", Формат(Индекс, "ЧН=0; ЧГ=0"), ии), Тип("ПолеФормы"), 
					ПодГруппа);
				Элемент.ПутьКДанным = СтрШаблон("ТаблицаСостояний[%1].%2", Индекс, 
					?(ВОднуКолонку, ИмяРеквизита, ИмяРеквизитаПоИндексу(ии)));
				Элемент.Вид = ВидПоляФормы.ПолеВвода;
				Если ии=1 Тогда
					Элемент.Заголовок = Строка(Выборка.ВидЗаказа);
				Иначе
					Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
				КонецЕсли; 
				Элемент.КнопкаОткрытия = Ложь;
				Элемент.КнопкаСоздания = Ложь;
				Элемент.КнопкаВыбора = Истина;
				Элемент.ОтображениеКнопкиВыбора = ОтображениеКнопкиВыбора.ОтображатьВВыпадающемСписке;
				Элемент.ИсторияВыбораПриВводе = ИсторияВыбораПриВводе.НеИспользовать;
				Элемент.АвтоМаксимальнаяШирина = Ложь;
				Элемент.МаксимальнаяШирина = ?(ВОднуКолонку, 35, 15);
				ВыборкаСостояния = Выборка.ПорядокСостояний.Выбрать();
				Пока ВыборкаСостояния.Следующий() Цикл
					Элемент.СписокВыбора.Добавить(ВыборкаСостояния.Состояние);	
				КонецЦикла;
				Если НесколькоВидовЗаказов И ии=КоличествоИтераций Тогда
					Элемент = Элементы.Добавить(СтрШаблон("Отключение%1", Формат(Индекс, "ЧН=0; ЧГ=0")), Тип("ПолеФормы"), ПодГруппа);
					Элемент.ПутьКДанным = СтрШаблон("ТаблицаСостояний[%1].НеИспользоватьДоставку", Индекс);
					Элемент.Вид = ВидПоляФормы.ПолеФлажка;
					Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
					Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_НеИспользоватьДоставкуПриИзменении");
					Элемент.Заголовок = НСтр("ru = 'Не использовать доставку'");
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	Иначе
		// Виды заказов не используются
		Пока Выборка.Следующий() Цикл
			Если Выборка.ВидЗаказа <> Справочники.ВидыЗаказовПокупателей.Основной Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаТабличнойЧасти = ТаблицаСостояний.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
			Индекс = ТаблицаСостояний.Индекс(СтрокаТабличнойЧасти);
			Для ии = 1 По КоличествоИтераций Цикл
				ИмяСостояния = ИмяРеквизитаПоИндексу(ии);
				Если ВОднуКолонку Тогда
					ПредставлениеСостояния = Метаданные.Справочники.ВидыЗаказовПокупателей.Реквизиты[ИмяРеквизита].Синоним;
				Иначе
					ПредставлениеСостояния = Метаданные.Справочники.ВидыЗаказовПокупателей.Реквизиты[ИмяСостояния].Синоним;
				КонецЕсли;
				Элемент = Элементы.Добавить(СтрШаблон("Состояние%1_%2", Формат(Индекс, "ЧН=0; ЧГ=0"), ии), Тип("ПолеФормы"), 
					Элементы.Колонка1);
				Элемент.ПутьКДанным = СтрШаблон("ТаблицаСостояний[%1].%2", Индекс, ?(ВОднуКолонку, ИмяРеквизита, ИмяСостояния));
				Элемент.Вид = ВидПоляФормы.ПолеВвода;
				Элемент.Заголовок = ПредставлениеСостояния;
				Элемент.КнопкаОткрытия = Ложь;
				Элемент.КнопкаСоздания = Истина;
				Элемент.КнопкаВыбора = Истина;
				Элемент.ОтображениеКнопкиВыбора = ОтображениеКнопкиВыбора.ОтображатьВВыпадающемСписке;
				Элемент.ИсторияВыбораПриВводе = ИсторияВыбораПриВводе.НеИспользовать;
				Элемент.АвтоМаксимальнаяШирина = Ложь;
				Элемент.МаксимальнаяШирина = 35;
				ВыборкаСостояния = Выборка.ПорядокСостояний.Выбрать();
				Пока ВыборкаСостояния.Следующий() Цикл
					Элемент.СписокВыбора.Добавить(ВыборкаСостояния.Состояние);	
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли; 
	
	НастроитьТекстПодсказки();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяРеквизитаПоИндексу(Индекс)
	
	Если Индекс=1 Тогда
		Возврат "СостояниеОжидаетОтгрузки";
	ИначеЕсли Индекс=2 Тогда
		Возврат "СостояниеОтгружен";
	ИначеЕсли Индекс=3 Тогда
		Возврат "СостояниеДоставлен";
	КонецЕсли; 	
	
КонецФункции 

&НаКлиенте
Функция РезультатПроверкиЗаполнения()
	
	Отказ = Ложь;
	ВОднуКолонку = НЕ (ПустаяСтрока(ИмяРеквизита));
	КоличествоИтераций = ?(ВОднуКолонку, 1, 3);
	
	Для каждого СтрокаТабличнойЧасти Из ТаблицаСостояний Цикл
		Если СтрокаТабличнойЧасти.НеИспользоватьДоставку Тогда
			Продолжить;
		КонецЕсли;
		Индекс = ТаблицаСостояний.Индекс(СтрокаТабличнойЧасти);
		Для ии = 1 По КоличествоИтераций Цикл
			Имя = ?(ВОднуКолонку, ИмяРеквизита, ИмяРеквизитаПоИндексу(ии));
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти[Имя]) Тогда
				ИмяЭлемента = "Состояние"+Формат(Индекс, "ЧН=0; ЧГ=0")+"_"+ии;
				ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Укажите состояние заказа'"), , 
				ИмяЭлемента, ,
				Отказ);
			КонецЕсли;
		КонецЦикла; 
	КонецЦикла;
	
	Возврат НЕ Отказ;
	
КонецФункции

&НаСервере
Процедура СохранитьИзменения()
	
	Если НесколькоВидовЗаказов Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("СостоянияДоставки", ТаблицаСостояний.Выгрузить());
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СостоянияДоставки.ВидЗаказа,
		|	СостоянияДоставки.СостояниеДоставлен,
		|	СостоянияДоставки.СостояниеОтгружен,
		|	СостоянияДоставки.СостояниеОжидаетОтгрузки,
		|	СостоянияДоставки.НеИспользоватьДоставку
		|ПОМЕСТИТЬ СостоянияДоставки
		|ИЗ
		|	&СостоянияДоставки КАК СостоянияДоставки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СостоянияДоставки.ВидЗаказа,
		|	СостоянияДоставки.СостояниеОжидаетОтгрузки КАК Состояние
		|ПОМЕСТИТЬ ВидыЗаказыИСостояния
		|ИЗ
		|	СостоянияДоставки КАК СостоянияДоставки
		|ГДЕ
		|	НЕ СостоянияДоставки.НеИспользоватьДоставку
		|	И СостоянияДоставки.СостояниеОжидаетОтгрузки <> ЗНАЧЕНИЕ(Справочник.СостоянияЗаказовПокупателей.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СостоянияДоставки.ВидЗаказа,
		|	СостоянияДоставки.СостояниеОтгружен
		|ИЗ
		|	СостоянияДоставки КАК СостоянияДоставки
		|ГДЕ
		|	НЕ СостоянияДоставки.НеИспользоватьДоставку
		|	И СостоянияДоставки.СостояниеОтгружен <> ЗНАЧЕНИЕ(Справочник.СостоянияЗаказовПокупателей.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СостоянияДоставки.ВидЗаказа,
		|	СостоянияДоставки.СостояниеДоставлен
		|ИЗ
		|	СостоянияДоставки КАК СостоянияДоставки
		|ГДЕ
		|	НЕ СостоянияДоставки.НеИспользоватьДоставку
		|	И СостоянияДоставки.СостояниеДоставлен <> ЗНАЧЕНИЕ(Справочник.СостоянияЗаказовПокупателей.ПустаяСсылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВидыЗаказыИСостояния.ВидЗаказа КАК ВидЗаказа,
		|	ВидыЗаказыИСостояния.Состояние
		|ИЗ
		|	ВидыЗаказыИСостояния КАК ВидыЗаказыИСостояния
		|ГДЕ
		|	НЕ (ВидыЗаказыИСостояния.ВидЗаказа, ВидыЗаказыИСостояния.Состояние) В
		|				(ВЫБРАТЬ
		|					Справочник.ВидыЗаказовПокупателей.ПорядокСостояний.Ссылка,
		|					Справочник.ВидыЗаказовПокупателей.ПорядокСостояний.Состояние
		|				ИЗ
		|					Справочник.ВидыЗаказовПокупателей.ПорядокСостояний)
		|ИТОГИ ПО
		|	ВидЗаказа";
		ВыборкаВидыЗаказа = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаВидыЗаказа.Следующий() Цикл
			ВидЗаказаОбъект = ВыборкаВидыЗаказа.ВидЗаказа.ПолучитьОбъект();
			ВыборкаСостояния = ВыборкаВидыЗаказа.Выбрать();
			Пока ВыборкаСостояния.Следующий() Цикл
				НоваяСтрока = ВидЗаказаОбъект.ПорядокСостояний.Добавить();
				НоваяСтрока.Состояние = ВыборкаСостояния.Состояние;
			КонецЦикла; 
			ВидЗаказаОбъект.Записать();
		КонецЦикла; 
	КонецЕсли; 
	                                                                                                         
	Для каждого СтрокаТабличнойЧасти Из ТаблицаСостояний Цикл
		ВидЗаказа = СтрокаТабличнойЧасти.ВидЗаказа.ПолучитьОбъект();
		Изменен = Ложь;
		Если ПустаяСтрока(ИмяРеквизита) Тогда
			Для ии = 1 По 3 Цикл
				Имя = ИмяРеквизитаПоИндексу(ии);
				Если ВидЗаказа[Имя]=СтрокаТабличнойЧасти[Имя] Тогда
					Продолжить;
				КонецЕсли;
				Изменен = Истина;
				ВидЗаказа[Имя] = СтрокаТабличнойЧасти[Имя];
			КонецЦикла; 
		Иначе
			Если ВидЗаказа[ИмяРеквизита]<>СтрокаТабличнойЧасти[ИмяРеквизита] Тогда
				Изменен = Истина;
				ВидЗаказа[ИмяРеквизита] = СтрокаТабличнойЧасти[ИмяРеквизита];
			КонецЕсли; 
		КонецЕсли;
		Если НесколькоВидовЗаказов И ВидЗаказа.НеИспользоватьДоставку<>СтрокаТабличнойЧасти.НеИспользоватьДоставку Тогда
			Изменен = Истина;
			ВидЗаказа.НеИспользоватьДоставку = СтрокаТабличнойЧасти.НеИспользоватьДоставку;
			Если ВидЗаказа.НеИспользоватьДоставку Тогда
				ВидЗаказа.СостояниеДоставлен = Справочники.СостоянияЗаказовПокупателей.ПустаяСсылка();
				ВидЗаказа.СостояниеОтгружен = Справочники.СостоянияЗаказовПокупателей.ПустаяСсылка();
				ВидЗаказа.СостояниеОжидаетОтгрузки = Справочники.СостоянияЗаказовПокупателей.ПустаяСсылка();
			КонецЕсли; 
		КонецЕсли; 
		Если Изменен Тогда
			ВидЗаказа.Записать();
		КонецЕсли; 
	КонецЦикла; 	
	
КонецПроцедуры

&НаСервере
Процедура НастроитьТекстПодсказки()
	
	Если ИмяРеквизита = "СостояниеОжидаетОтгрузки" Тогда
		Элементы.ДекорацияПодсказкаОжидаетОтгрузки.Видимость = Истина;
		Элементы.ДекорацияПодсказкаОтгружен.Видимость = Ложь;
		Элементы.ДекорацияПодсказкаОбщая.Видимость = Ложь;
		Элементы.ДекорацияПодсказкаДоставлен.Видимость = Ложь;
	ИначеЕсли ИмяРеквизита = "СостояниеОтгружен" Тогда        
		Элементы.ДекорацияПодсказкаОжидаетОтгрузки.Видимость = Ложь;
		Элементы.ДекорацияПодсказкаОтгружен.Видимость = Истина;
		Элементы.ДекорацияПодсказкаОбщая.Видимость = Ложь;
		Элементы.ДекорацияПодсказкаДоставлен.Видимость = Ложь;
	ИначеЕсли ИмяРеквизита = "СостояниеДоставлен" Тогда        
		Элементы.ДекорацияПодсказкаОжидаетОтгрузки.Видимость = Ложь;
		Элементы.ДекорацияПодсказкаОтгружен.Видимость = Ложь;
		Элементы.ДекорацияПодсказкаОбщая.Видимость = Ложь;
		Элементы.ДекорацияПодсказкаДоставлен.Видимость = Истина;
	Иначе
		Элементы.ДекорацияПодсказкаОжидаетОтгрузки.Видимость = Ложь;
		Элементы.ДекорацияПодсказкаОтгружен.Видимость = Ложь;
		Элементы.ДекорацияПодсказкаОбщая.Видимость = Истина;
		Элементы.ДекорацияПодсказкаДоставлен.Видимость = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти
 
 