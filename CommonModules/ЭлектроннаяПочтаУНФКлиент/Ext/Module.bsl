﻿
#Область ПрограммныйИнтерфейс

Функция АдресЭлектроннойПочтыЗаполнен(Форма, КакСвязаться) Экспорт
	
	Если ЗначениеЗаполнено(КакСвязаться) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ИндексСтроки = Форма.Объект.Участники.Индекс(Форма.Элементы.Получатели.ТекущиеДанные);
	ОбщегоНазначенияКлиент.СообщитьПользователю(
		НСтр("ru='Не заполнен адрес электронной почты.'"), , СтрШаблон("Объект.Участники[%1].КакСвязаться", Формат(
		ИндексСтроки, "ЧГ=")));
	
	Возврат Ложь;
	
КонецФункции

Функция КонтактУжеСоздан(Контакт, ТекстСообщения, Форма) Экспорт
	
	Если ТипЗнч(Контакт) <> Тип("СправочникСсылка.КонтактныеЛица") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИндексСтроки = Форма.Объект.Участники.Индекс(Форма.Элементы.Получатели.ТекущиеДанные);
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , СтрШаблон("Объект.Участники[%1].Контакт", Формат(
		ИндексСтроки, "ЧГ=")));
	
	Возврат Истина;
	
КонецФункции

Функция КонтрагентУжеСоздан(Контакт, ТекстСообщения, Форма) Экспорт
	
	Если ТипЗнч(Контакт) <> Тип("СправочникСсылка.Контрагенты") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИндексСтроки = Форма.Объект.Участники.Индекс(Форма.Элементы.Получатели.ТекущиеДанные);
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , СтрШаблон("Объект.Участники[%1].Контакт", Формат(
		ИндексСтроки, "ЧГ=")));
	
	Возврат Истина;
	
КонецФункции

// См. СтандартныеПодсистемыКлиент.ПриПолученииСерверногоОповещения.
//
Процедура ПриПолученииСерверногоОповещения(ИмяОповещения, Результат) Экспорт
	
	Если ИмяОповещения <> ЭлектроннаяПочтаУНФКлиентСервер.ИмяСерверногоОповещения() Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("События_ЗагрузитьПочту", Результат);
	
КонецПроцедуры

// Позволяет открывать форму ответа/пересылки на основе какого-то письма
//
// Параметры:
//  ПараметрКоманды - Строка - см ЭлектроннаяПочтаУНФКлиентСервер.КомандаПереслать
//  Ссылка - ДокументСсылка.Событие - письмо, нужно передавать, если не переданы ДанныеДляЗаполнения
//  УникальныйИдентификатор - УникальныйИдентификатор - идентификатор формы
//  ДанныеДляЗаполнения - Структура:
//   * Объект - ДанныеФормыСтруктура:
//     ** Ссылка - ДокументСсылка.Событие
//     ** НачалоСобытия - Дата
//     ** СписокУчастников - Строка
//     ** Тема - Строка
//     ** Содержание - Строка
//     ** СодержаниеHTML - Строка
//     ** ИсточникПривлечения - СправочникСсылка.ИсточникиПривлеченияПокупателей
//     ** ЗагрузитьПриОткрытии - Булево
//   * ОтКого - Строка - представление контакта
//   * КартинкиHTML - ХранилищеЗначения
//   * Вложения - ТаблицаЗначений, ДанныеФормыКоллекция:
//     ** АдресВоВременномХранилище - Строка
//     ** Представление - Строка
//
Процедура ОтветитьПереслать(
	ПараметрКоманды,
	Ссылка = Неопределено,
	УникальныйИдентификатор = Неопределено,
	ДанныеДляЗаполнения = Неопределено) Экспорт
	
	Если ДанныеДляЗаполнения = Неопределено Тогда
		
		Если Ссылка = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ДанныеДляЗаполнения = ЭлектроннаяПочтаУНФВызовСервера.ЗначениеРеквизитовСобытияДляОтвета(
			Ссылка, УникальныйИдентификатор);
		
	Иначе
		
		Объект = ДанныеДляЗаполнения.Объект;
		ДанныеДляЗаполнения.Вставить("Ссылка", Объект.Ссылка);
		ДанныеДляЗаполнения.Вставить("НачалоСобытия", Объект.НачалоСобытия);
		ДанныеДляЗаполнения.Вставить("СписокУчастников", Объект.СписокУчастников);
		ДанныеДляЗаполнения.Вставить("Тема", Объект.Тема);
		ДанныеДляЗаполнения.Вставить("Содержание", Объект.Содержание);
		ДанныеДляЗаполнения.Вставить("СодержаниеHTML", Объект.СодержаниеHTML);
		ДанныеДляЗаполнения.Вставить("ИсточникПривлечения", Объект.ИсточникПривлечения);
		ДанныеДляЗаполнения.Вставить("ЗагрузитьПриОткрытии", Объект.ЗагрузитьПриОткрытии);
		
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", Новый Структура);
	ПараметрыОткрытия.ЗначенияЗаполнения.Вставить("Команда", ПараметрКоманды);
	ПараметрыОткрытия.ЗначенияЗаполнения.Вставить("ТипСобытия", ПредопределенноеЗначение("Перечисление.ТипыСобытий.ЭлектронноеПисьмо"));
	ПараметрыОткрытия.ЗначенияЗаполнения.Вставить("ОснованиеЗаполнения", ДанныеДляЗаполнения.Ссылка);
	ПараметрыОткрытия.ЗначенияЗаполнения.Вставить("ПараметрыОснования", Новый Структура);
	ПараметрыОткрытия.ЗначенияЗаполнения.ПараметрыОснования.Вставить("Ссылка", ДанныеДляЗаполнения.Ссылка);
	ПараметрыОткрытия.ЗначенияЗаполнения.ПараметрыОснования.Вставить("НачалоСобытия", ДанныеДляЗаполнения.НачалоСобытия);
	ПараметрыОткрытия.ЗначенияЗаполнения.ПараметрыОснования.Вставить("СписокУчастников", ДанныеДляЗаполнения.СписокУчастников);
	ПараметрыОткрытия.ЗначенияЗаполнения.ПараметрыОснования.Вставить("ОтКого", ДанныеДляЗаполнения.ОтКого);
	ПараметрыОткрытия.ЗначенияЗаполнения.ПараметрыОснования.Вставить("Тема", ДанныеДляЗаполнения.Тема);
	ПараметрыОткрытия.ЗначенияЗаполнения.ПараметрыОснования.Вставить("Содержание", ДанныеДляЗаполнения.Содержание);
	ПараметрыОткрытия.ЗначенияЗаполнения.ПараметрыОснования.Вставить("СодержаниеHTML", ДанныеДляЗаполнения.СодержаниеHTML);
	ПараметрыОткрытия.ЗначенияЗаполнения.ПараметрыОснования.Вставить("КартинкиHTML", ДанныеДляЗаполнения.КартинкиHTML);
	ПараметрыОткрытия.ЗначенияЗаполнения.ПараметрыОснования.Вставить("ИсточникПривлечения", ДанныеДляЗаполнения.ИсточникПривлечения);
	ПараметрыОткрытия.ЗначенияЗаполнения.ПараметрыОснования.Вставить("ЗагрузитьПриОткрытии", ДанныеДляЗаполнения.ЗагрузитьПриОткрытии);
	
	Если ПараметрКоманды = ЭлектроннаяПочтаУНФКлиентСервер.КомандаПереслать()
		И ДанныеДляЗаполнения.Вложения.Количество() > 0 Тогда
		
		ПараметрыОткрытия.Вставить("Вложения", Новый СписокЗначений);
		Для Каждого ТекВложение Из ДанныеДляЗаполнения.Вложения Цикл
			ПараметрыОткрытия.Вложения.Добавить(ТекВложение.АдресВоВременномХранилище, ТекВложение.Представление);
		КонецЦикла;
		
	КонецЕсли;
	
	ОткрытьФорму("Документ.Событие.ФормаОбъекта", ПараметрыОткрытия);
	
КонецПроцедуры

#Область Предпросмотр

// Показывает меню для создания контакта
//
// Параметры:
//  Параметры - Структура:
//   * Элемент - ГруппаФормы, ТаблицаФормы, ПолеФормы, КнопкаФормы
//   * КонтактнаяИнформация - Структура:
//     ** Контакт - Произвольный - передается в форму для нового контакта
//     ** КакСвязаться - Строка
//     ** КонтактCRM - Произвольный - нужен для проверки на наличие контакта
//   * СвойстваОбъекта - Структура:
//     ** Ссылка - ДокументСобытие.Ссылка
//     ** ИсточникПривлечения - СправочникСсылка.ИсточникиПривлеченияПокупателей
//   * Форма - ФормаКлиентскогоПриложения - форма
//   * ПутьДоПоля - Строка - поле, рядом с которым должно появиться меню
//   * ДелатьПроверкуНаЗапись - Булево - проверка на запись формы
//   * ДелатьПроверкуНаЭП - Булево - проверка на электронную почту
//
Процедура ПоказатьМенюСозданияКонтакта(Параметры) Экспорт
	
	ПараметрыДляСозданияКонтакта = ПараметрыДляСозданияКонтакта(Параметры);
	Если ПараметрыДляСозданияКонтакта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокВыбораКонтактов = СписокВыбораКонтактов();
	
	ОповещениеСоздатьКонтакт = Новый ОписаниеОповещения(
		"СоздатьКонтактCRMНаОсновании",
		ЭтотОбъект,
		ПараметрыДляСозданияКонтакта);
	
	ПараметрыДляСозданияКонтакта.Форма.ПоказатьВыборИзСписка(
		ОповещениеСоздатьКонтакт, СписокВыбораКонтактов, ПараметрыДляСозданияКонтакта.Элемент);
	
КонецПроцедуры

// Обработка нажатия на предпросмотр
//
// Параметры:
//  Элемент - ПолеФормы - поле с предпросмотром
//  ДанныеСобытия - ФиксированнаяСтруктура - данные события нажатия
//  СтандартнаяОбработка - Булево - флаг события
//  Форма - ФормаКлиентскогоПриложения - форма
//  ЭтоСпам - Булево - если спам, при нажатии на навигационные ссылки задается вопрос о переходе
//
Процедура ПредпросмотрПриНажатии(
	Элемент, ДанныеСобытия, СтандартнаяОбработка, Форма, ЭтоСпам = Ложь) Экспорт
	
	АктивныйЭлемент = ДанныеСобытия.Element;
	Если АктивныйЭлемент.nodeName = "#document" Или АктивныйЭлемент.nodeName = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоСпам Тогда
		НужноПоказыватьВопросДляПереходаПоСсылке = (АктивныйЭлемент.getAttribute("header-link") = Неопределено);
	Иначе
		НужноПоказыватьВопросДляПереходаПоСсылке = Ложь;
	КонецЕсли;
	
	НажатиеЗавершено = ГипертекстКлиент.ДокументHTMLПриНажатии(
	ДанныеСобытия, СтандартнаяОбработка, НужноПоказыватьВопросДляПереходаПоСсылке);
	Если НажатиеЗавершено Тогда
		Возврат;
	КонецЕсли;
	
	ДокументHTML = Элемент.Документ;
	Если ДокументHTML = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Пожалуйста, подождите полной загрузки письма'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	СозданиеКонтактаПриНажатии(ДанныеСобытия.Event, АктивныйЭлемент, ДокументHTML, Форма);
	
	ОткрытиеИстории(АктивныйЭлемент);
	ОткрытиеФормыВложений(АктивныйЭлемент);
	
КонецПроцедуры

// Заменяет текст письма на верстку с загрузкой письма
//
// Параметры:
//  РеквизитТекстаПисьма - Строка - реквизит формы
//
Процедура ДобавитьКомандуЗагрузкиПисьма(РеквизитТекстаПисьма) Экспорт
	
	РеквизитТекстаПисьма = СтрШаблон("
	|<html>
	|<body
	|	style=""
	|		display: flex;
	|		justify-content: center;
	|		align-items: center;
	|		flex-direction: column;
	|		font-size: 24px;
	|		font-family: 'Microsoft Sans Serif', 'Arial', 'Calibri', 'Times New Roman';
	|		height: 100vh;
	|		padding: 8px;""
	|>
	|	<div>%1</div>
	|	<div class=""preview-download"" style=""color: blue; text-decoration: underline; cursor: pointer;"">%2</div>
	|</body>
	|</html>
	|",
	НСтр("ru = 'Содержание письма еще не загружено'"),
	НСтр("ru = 'Загрузить'"));
	
КонецПроцедуры

// Нажатие на небезопасное содержимое с последующей записью
//
// Параметры:
//  Событие - ДокументСсылка.Событие - событие с содержимым
//  ЭлементТекстаПисьма - ПолеФормы - элемент с текстом письма
//  ЭлементНебезопасногоСодержимого - ГруппаФормы, ТаблицаФормы, ПолеФормы, КнопкаФормы - должно быть свойство Видимость
//  ПоказыватьВопросОЗаписи - Булево - нужно ли показывать вопрос о записи объекта перед записью
//
Процедура НебезопасноеСодержимоеНажатие(
	Событие,
	ЭлементТекстаПисьма,
	ЭлементНебезопасногоСодержимого,
	ПоказыватьВопросОЗаписи = Ложь) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Событие", Событие);
	Параметры.Вставить("ЭлементТекстаПисьма", ЭлементТекстаПисьма);
	Параметры.Вставить("ЭлементНебезопасногоСодержимого", ЭлементНебезопасногоСодержимого);
	
	Если Не ПоказыватьВопросОЗаписи Тогда
		ПоказатьНебезопасноеСодержимое(Параметры);
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаОповещенияНебезопасноеСодержимое", ЭтотОбъект, Параметры);
	ПоказатьВопрос(
		ОписаниеОповещения,
		НСтр("ru = 'Для отображения всех картинок данные будут записаны. Продолжить?'"),
		РежимДиалогаВопрос.ОКОтмена);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОтправитьПечатныеФормыПоПочте(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	Если ПараметрКоманды.Количество() = 1
		И ЭтоПредметШаблона(ПараметрКоманды[0])
		И ЭлектроннаяПочтаУНФВызовСервера.ЕстьДоступныеШаблоны(Истина, ПараметрКоманды[0]) Тогда
		ШаблоныСообщенийКлиент.СформироватьСообщение(ПараметрКоманды[0], "Письмо",,, Новый Структура("ИмяФормыИсточникаСообщения", ПараметрыВыполненияКоманды.Форма.ИмяФормы));
	Иначе
		ДополнительныеПараметрыПечати = Неопределено;
		
		ФормаИсточник = ПараметрыВыполненияКоманды.Форма;
		
		Если ФормаИсточник.ИмяФормы = "ЖурналДокументов.КомиссионнаяТорговля.Форма.ФормаСписка" Тогда
			
			ИмяФормыОбъектаКоманды = Неопределено;
			
			ПолучитьФормуЭлементаЖурнала(ПараметрКоманды, ФормаИсточник, ИмяФормыОбъектаКоманды);
			
			Если ИмяФормыОбъектаКоманды = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
		ИначеЕсли ФормаИсточник.ИмяФормы = "ЖурналДокументов.СкладскиеОрдера.Форма.ФормаСписка" Тогда
			
			ИмяФормыОбъектаКоманды = Неопределено;
			
			ПолучитьФормуЭлементаЖурнала(ПараметрКоманды, ФормаИсточник, ИмяФормыОбъектаКоманды);
			
			Если ИмяФормыОбъектаКоманды = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
		ИначеЕсли ФормаИсточник.ИмяФормы = "ЖурналДокументов.ДокументыПереработки.Форма.ФормаСписка"  Тогда
			ИмяФормыОбъектаКоманды = Неопределено;
			
			ПолучитьФормуЭлементаЖурнала(ПараметрКоманды, ФормаИсточник, ИмяФормыОбъектаКоманды);
			
			Если ИмяФормыОбъектаКоманды = Неопределено Тогда
				Возврат;
			КонецЕсли;
		ИначеЕсли ФормаИсточник.ИмяФормы = "ЖурналДокументов.ДокументыПереработчиков.Форма.ФормаСписка"  Тогда
			ИмяФормыОбъектаКоманды = Неопределено;
			
			ПолучитьФормуЭлементаЖурнала(ПараметрКоманды, ФормаИсточник, ИмяФормыОбъектаКоманды);
			
			Если ИмяФормыОбъектаКоманды = Неопределено Тогда
				Возврат;
			КонецЕсли;
		Иначе
			ИмяФормыОбъектаКоманды = ФормаИсточник.ИмяФормы;
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ИмяФормыОбъектаПечати",	ИмяФормыОбъектаКоманды);
		ПараметрыФормы.Вставить("ОбъектыОтправки",			ПараметрКоманды);
		Если ДополнительныеПараметрыПечати <> Неопределено Тогда
			ПараметрыФормы.Вставить("ДополнительныеПараметрыПечати", ДополнительныеПараметрыПечати);
		КонецЕсли;
		ОткрытьФорму("ОбщаяФорма.ВыборПечатныхФормДляОтправки", ПараметрыФормы, ФормаИсточник);
	КонецЕсли;
	
	СтатистикаИспользованияФормКлиент.ПроверитьЗаписатьСтатистикуКоманды(
		"ОтправитьПоЭлектроннойПочте",
		ПараметрыВыполненияКоманды.Форма);

КонецПроцедуры
	
Процедура ПоказатьВыборИзКлассификатораКонтактов(Форма, ИмяЭлементаКонтрагент = "Контрагент") Экспорт
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Элемент", Форма.Элементы[ИмяЭлементаКонтрагент]);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
	"ОбработатьВыборИзКлассификатораКонтактов",
	ЭтотОбъект,
	ПараметрыОбработчика);
	
	Форма.ПоказатьВыборИзМеню(
	ОписаниеОповещения,
	Форма.СписокАвтоПодбораКонтрагента,
	ПараметрыОбработчика.Элемент);
	
КонецПроцедуры

Процедура ОбработатьВыборИзКлассификатораКонтактов(ВыбранноеЗначение, Параметры) Экспорт
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("ЭлементСпискаЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("КлассификаторДляЗаполненияКИ", ВыбранноеЗначение.Значение);
	ПараметрыФормы.Вставить("СопоставитьКонтактИАдресЭПВСобытияхПослеЗаписиОбъекта", Истина);
	АвтоподборКонтактовКлиент.ДополнитьПараметрыФормыИзПараметровВыбораЭлемента(ПараметрыФормы, Параметры.Элемент);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", ПараметрыФормы, Параметры.Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Предпросмотр

#Область СписокКонтактов

Процедура СозданиеКонтактаПриНажатии(Событие, Знач Элемент, ДокументHTML, Форма)
	
	ОкноВыбораКонтакта = ДокументHTML.querySelector(".preview__contact-modal");
	Если ОкноВыбораКонтакта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗакрытиеОткрытиеОкнаВыбораКонтакта(Элемент, ОкноВыбораКонтакта, Событие, ДокументHTML);
	
	ДопФормаОткрыта = ОбработкаНажатияНаКоличествоКонтактов(Элемент);
	Если ДопФормаОткрыта Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаНажатияНаКонтакт(Элемент, ОкноВыбораКонтакта, Форма);
	
КонецПроцедуры

Процедура ЗакрытиеОткрытиеОкнаВыбораКонтакта(Знач Элемент, ОкноВыбораКонтакта, Событие, ДокументHTML)
	
	ЭтоЭлементКонтакта = Истина;
	Если Не Элемент.classList.contains("preview__contact_null") Тогда
		
		Если ЗначениеПустое(Элемент.parentNode) Тогда
			ЭтоЭлементКонтакта = Ложь;
		Иначе
			
			Элемент = Элемент.parentNode;
			Если Не Элемент.classList.contains("preview__contact_null") Тогда
				ЭтоЭлементКонтакта = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоЭлементКонтакта Тогда
		
		ОткрытиеОкнаВыбораКонтакта(Элемент, ОкноВыбораКонтакта, Событие, ДокументHTML);
		
	Иначе
		
		Если Не ОкноВыбораКонтакта.classList.contains("hide") Тогда
			ОкноВыбораКонтакта.classList.add("hide");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытиеОкнаВыбораКонтакта(Знач Элемент, ОкноВыбораКонтакта, Событие, ДокументHTML)
	
	ОкноВыбораКонтакта.classList.remove("hide");
	
	ОтступСверхуОтМестаНажатия = 15;
	Верх = Событие.clientY + ОтступСверхуОтМестаНажатия;
	ОкноВыбораКонтакта.style.top = СтрШаблон("%1px", Верх);
	
	ОтступОтГраниц = 8;
	ШиринаОкнаВыбора = ОкноВыбораКонтакта.offsetWidth;
	ОтступСлева = Событие.clientX;
	МаксимальныйОтступ = ДокументHTML.body.offsetWidth - ШиринаОкнаВыбора - ОтступОтГраниц;
	
	Лево = ОтступСлева - Окр(ШиринаОкнаВыбора / 2) + 5;
	Если Лево < МаксимальныйОтступ Тогда
		
		Если Лево < ОтступОтГраниц Тогда
			Лево = ОтступОтГраниц;
		КонецЕсли;
		
	Иначе
		
		Лево = МаксимальныйОтступ;
		
	КонецЕсли;
	
	ОкноВыбораКонтакта.style.left = СтрШаблон("%1px", Лево);
	
	ОкноВыбораКонтакта.setAttribute("data-href", Элемент.getAttribute("data-href"));
	ОкноВыбораКонтакта.setAttribute("data-how-to-connect", Элемент.getAttribute("data-how-to-connect"));
	
КонецПроцедуры

Функция ОбработкаНажатияНаКоличествоКонтактов(Знач Элемент)
	
	Если Не Элемент.classList.contains("preview__other-contacts") Тогда
		
		Если ЗначениеПустое(Элемент.parentNode) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Элемент = Элемент.parentNode;
		Если Не Элемент.classList.contains("preview__other-contacts") Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Адрес = Элемент.getAttribute("data-href");
	Если Не ЭтоАдресВременногоХранилища(Адрес) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("АдресТаблицыУчастников", Адрес);
	ОткрытьФорму("Документ.Событие.Форма.СписокПолучателей", ПараметрыФормы, ЭтотОбъект);
	
	Возврат Истина;
	
КонецФункции

Процедура ОбработкаНажатияНаКонтакт(Знач Элемент, ОкноВыбораКонтакта, Форма)
	
	Если Не Элемент.classList.contains("preview__contact-modal__item")
		И Не ЗначениеПустое(Элемент.parentNode) Тогда
		Элемент = Элемент.parentNode;
	КонецЕсли;
	
	Если Элемент.nodeName = "#document" Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.classList.contains("preview__contact-modal__item") Тогда
		
		АдресНавигационнойСсылки = ОкноВыбораКонтакта.getAttribute("data-href");
		КакСвязаться = ОкноВыбораКонтакта.getAttribute("data-how-to-connect");
		
		СвойстваКонтакта = Новый Структура;
		Ссылка = ЭлектроннаяПочтаУНФВызовСервера.СсылкаИзНавигационной(АдресНавигационнойСсылки);
		СвойстваКонтакта.Вставить("Ссылка", Ссылка);
		СвойстваКонтакта.Вставить("КакСвязаться", КакСвязаться);
		
		НазваниеКонтакта = Элемент.getAttribute("data-name");
		
		СоздатьКонтактCRMНаОснованииСРезультатом(НазваниеКонтакта, СвойстваКонтакта, Форма);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьКонтактCRMНаОснованииСРезультатом(НазваниеКонтакта, СвойстваКонтакта, Форма)
	
	РезультатДляПередачи = Новый Структура("Значение", НазваниеКонтакта);
	
	ПараметрыДляПередачи = Новый Структура;
	ПараметрыДляПередачи.Вставить("Форма", Форма);
	
	СвойстваОбъекта = Новый Структура;
	СвойстваОбъекта.Свойство("Ссылка", Форма.Предпросмотр_СсылкаНаСобытие);
	СвойстваОбъекта.Свойство("ИсточникПривлечения", Форма.Предпросмотр_ИсточникПривлечения);
	ПараметрыДляПередачи.Вставить("СвойстваОбъекта", СвойстваОбъекта);
	
	КонтактнаяИнформация = Новый Структура;
	КонтактнаяИнформация.Вставить("Контакт", СвойстваКонтакта.Ссылка);
	КонтактнаяИнформация.Вставить("КакСвязаться", СвойстваКонтакта.КакСвязаться);
	ПараметрыДляПередачи.Вставить("КонтактнаяИнформация", КонтактнаяИнформация);
	
	ПараметрыДляСоздания = ПараметрыДляСозданияКонтакта(ПараметрыДляПередачи);
	СоздатьКонтактCRMНаОсновании(РезультатДляПередачи, ПараметрыДляСоздания);
	
КонецПроцедуры

Процедура СоздатьКонтактCRMНаОсновании(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если КонтактCRMУжеСоздан(Результат.Значение, Параметры) Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Значение = "АдреснаяКнига" Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.ДелатьПроверкуНаЗапись = Истина И Параметры.Форма.Модифицированность Тогда
		
		Параметры.Вставить("Результат", Результат);
		Оповещение = Новый ОписаниеОповещения("ОбработатьВопросСозданиеКонтактаНаОсновании", ЭтотОбъект, Параметры);
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
		|Сохранение контакта возможно только после записи данных.
		|Данные будут записаны'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
		
	КонецЕсли;
	
	КИКонтактнойФормы = Неопределено;
	Если Параметры.Ссылка <> Неопределено И Параметры.КакСвязаться <> Неопределено Тогда
		КИКонтактнойФормы = ЭлектроннаяПочтаУНФВызовСервера.ПодготовитьКонтактнуюИнформациюПоДаннымКФ(
			Параметры.Ссылка, Параметры.КакСвязаться);
	КонецЕсли;
	
	Если КИКонтактнойФормы <> Неопределено Тогда
		ПараметрыФормы = ПараметрыФормыПоКФ(КИКонтактнойФормы, Параметры);
		ОткрытьФорму(ФормаОбъектаКонтактаCRM(Результат.Значение), ПараметрыФормы);
		Возврат;
	КонецЕсли;
	
	Если Параметры.ДелатьПроверкуНаЭП
		И Не АдресЭлектроннойПочтыЗаполнен(Параметры.Форма, Параметры.КакСвязаться) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = ПараметрыФормыСозданияКонтакта(Результат.Значение, Параметры);
	
	ОткрытьФорму(ФормаОбъектаКонтактаCRM(Результат.Значение),
		ПараметрыФормы);

КонецПроцедуры

Функция СписокВыбораКонтактов()
	
	СписокВыбораКонтактов = Новый СписокЗначений;
	СписокВыбораКонтактов.Добавить(
		"Контрагент",
		НСтр("ru = 'Создать контрагента'"), ,
		БиблиотекаКартинок.КоллекцияКонтрагентыКомпания);
	
	СписокВыбораКонтактов.Добавить(
		"Контакт",
		НСтр("ru = 'Создать контакт'"), ,
		БиблиотекаКартинок.ИконкаКонтактногоЛица);
	
	СписокВыбораКонтактов.Добавить(
		"Лид",
		НСтр("ru = 'Создать лид'"), ,
		БиблиотекаКартинок.КонтактнаяИнформацияЭлПочта);
	
	Возврат СписокВыбораКонтактов;
	
КонецФункции

Процедура ОбработатьВопросСозданиеКонтактаНаОсновании(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Форма.Записать();
	Параметры.ДелатьПроверкуНаЗапись = Ложь;
	СоздатьКонтактCRMНаОсновании(Параметры.Результат, Параметры);
	
КонецПроцедуры

Функция ПараметрыФормыПоКФ(КИКонтактнойФормы, Параметры)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Контакт", Параметры.Контакт);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура);
	ПараметрыФормы.ЗначенияЗаполнения.Вставить("Покупатель", Истина);
	
	ПараметрыФормы.ЗначенияЗаполнения.Вставить(
		"ИсточникПривлечения", Параметры.ИсточникПривлечения);
	
	ПараметрыФормы.Вставить("ДанныеИзКонтактнойФормы", КИКонтактнойФормы);
	Возврат ПараметрыФормы;
	
КонецФункции

Функция КонтактCRMУжеСоздан(ТипКонтакта, Параметры)
	
	Если ТипКонтакта = "АдреснаяКнига" Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипКонтакта = "Контрагент" Или ТипКонтакта = "Контакт" Тогда
		
		Возврат КонтрагентУжеСоздан(
			Параметры.КонтактCRM,
			НСтр("ru = 'Контрагент уже создан.'"),
			ЭтотОбъект);
		
	КонецЕсли;
	
	Если ТипКонтакта = "Лид" Тогда
		
		Возврат НЕ МожноСоздатьЛид(Параметры);
		
	КонецЕсли;
		
КонецФункции

Функция МожноСоздатьЛид(Параметры)
	
	МожноСоздатьЛид = Истина;
	
	КонтактCRM = Параметры.КонтактCRM;
	
	Если ТипЗнч(КонтактCRM) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		МожноСоздатьЛид = Ложь;
		ТекстСообщения = НСтр("ru='Контакт уже создан.'");
	КонецЕсли;
	
	Если ТипЗнч(КонтактCRM) = Тип("СправочникСсылка.Контрагенты") Тогда
		МожноСоздатьЛид = Ложь;
		ТекстСообщения = НСтр("ru='Контрагент уже создан.'");
	КонецЕсли;
	
	Если ТипЗнч(КонтактCRM) = Тип("СправочникСсылка.Лиды") Тогда
		МожноСоздатьЛид = Ложь;
		ТекстСообщения = НСтр("ru='Лид уже создан.'");
	КонецЕсли;
	
	Если НЕ МожноСоздатьЛид Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Параметры.ПутьДоПоля);
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ФормаОбъектаКонтактаCRM(ВидКонтакта)
	
	Если ВидКонтакта = "Контрагент" Тогда
		Возврат "Справочник.Контрагенты.ФормаОбъекта";
	ИначеЕсли ВидКонтакта = "Контакт" Тогда
		Возврат "Справочник.КонтактныеЛица.ФормаОбъекта";
	Иначе
		Возврат "Справочник.Лиды.ФормаОбъекта";
	КонецЕсли;
	
КонецФункции

Функция ПараметрыФормыСозданияКонтакта(ВидКонтакта, Параметры)
	
	Результат = Новый Структура;
	Результат.Вставить("ЗначенияЗаполнения", Новый Структура);
	
	Если ВидКонтакта = "Контрагент" Тогда
		Результат.ЗначенияЗаполнения.Вставить("Покупатель", Истина);
	КонецЕсли;
	
	Результат.ЗначенияЗаполнения.Вставить(
		"ИсточникПривлечения", Параметры.ИсточникПривлечения);
	
	КонтактCRM = Параметры.КонтактCRM;
	
	Если ВидКонтакта = "Контрагент" И ТипЗнч(КонтактCRM) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		Результат.Вставить("Контакт", КонтактCRM);
		Возврат Результат;
	КонецЕсли;
	
	Если ВидКонтакта = "Контакт" И ТипЗнч(КонтактCRM) = Тип("СправочникСсылка.Контрагенты") Тогда
		Результат.Вставить("Контакт", КонтактCRM);
		Возврат Результат;
	КонецЕсли;
	
	Результат.Вставить("КонтактКакСвязаться", Новый Структура);
	Результат.КонтактКакСвязаться.Вставить("ВидКонтакта", ВидКонтакта);
	Результат.КонтактКакСвязаться.Вставить("Контакт", Параметры.Контакт);
	Результат.КонтактКакСвязаться.Вставить("КакСвязаться", Параметры.КакСвязаться);
	Результат.КонтактКакСвязаться.Вставить("ТипКИ",
		ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты"));
	
	Возврат Результат;
	
КонецФункции

Функция ПараметрыДляСозданияКонтакта(Параметры)
	
	Элемент = Неопределено;
	Параметры.Свойство("Элемент", Элемент);
	
	КонтактнаяИнформация = Неопределено;
	Параметры.Свойство("КонтактнаяИнформация", КонтактнаяИнформация);
	Если ТипЗнч(КонтактнаяИнформация) <> Тип("Структура") Тогда
		
		Попытка
			КонтактнаяИнформация = Элемент.ТекущиеДанные;
		Исключение
			
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
				НСтр("ru = 'Отсутствие контактной информации'"),
				"Ошибка",
				ТекстОшибки);
			Возврат Неопределено;
			
		КонецПопытки;
		
	КонецЕсли;
	
	Контакт = Неопределено;
	КонтактнаяИнформация.Свойство("Контакт", Контакт);
	
	КакСвязаться = Неопределено;
	КонтактнаяИнформация.Свойство("КакСвязаться", КакСвязаться);
	
	КонтактCRM = Неопределено;
	КонтактнаяИнформация.Свойство("КонтактCRM", КонтактCRM);
	
	Ссылка = Неопределено;
	ИсточникПривлечения = Неопределено;
	
	СвойстваОбъекта = Неопределено;
	Параметры.Свойство("СвойстваОбъекта", СвойстваОбъекта);
	Если ТипЗнч(СвойстваОбъекта) = Тип("Структура")
		Или ТипЗнч(СвойстваОбъекта) = Тип("ДанныеФормыСтруктура") Тогда
		
		СвойстваОбъекта.Свойство("Ссылка", Ссылка);
		СвойстваОбъекта.Свойство("ИсточникПривлечения", ИсточникПривлечения);
		
	КонецЕсли;
	
	Форма = Неопределено;
	Параметры.Свойство("Форма", Форма);
	Если Форма = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПутьДоПоля = Неопределено;
	Параметры.Свойство("ПутьДоПоля", ПутьДоПоля);
	ПутьДоПоля = ?(ПутьДоПоля = Неопределено, "", ПутьДоПоля);
	
	ДелатьПроверкуНаЗапись = Неопределено;
	ДелатьПроверкуНаЭП = Неопределено;
	
	Параметры.Свойство("ДелатьПроверкуНаЗапись", ДелатьПроверкуНаЗапись);
	Параметры.Свойство("ДелатьПроверкуНаЭП", ДелатьПроверкуНаЭП);
	
	ДелатьПроверкуНаЗапись = ?(ДелатьПроверкуНаЗапись = Неопределено, Ложь, Истина);
	ДелатьПроверкуНаЭП = ?(ДелатьПроверкуНаЭП = Неопределено, Ложь, Истина);
	
	ОбъединенныеПараметры = Новый Структура;
	ОбъединенныеПараметры.Вставить("Элемент", Элемент);
	ОбъединенныеПараметры.Вставить("Контакт", Контакт);
	ОбъединенныеПараметры.Вставить("КакСвязаться", КакСвязаться);
	ОбъединенныеПараметры.Вставить("КонтактCRM", КонтактCRM);
	
	ОбъединенныеПараметры.Вставить("Ссылка", Ссылка);
	ОбъединенныеПараметры.Вставить("ИсточникПривлечения", ИсточникПривлечения);
	
	ОбъединенныеПараметры.Вставить("Форма", Форма);
	ОбъединенныеПараметры.Вставить("ПутьДоПоля", ПутьДоПоля);
	
	ОбъединенныеПараметры.Вставить("ДелатьПроверкуНаЗапись", ДелатьПроверкуНаЗапись);
	ОбъединенныеПараметры.Вставить("ДелатьПроверкуНаЭП", ДелатьПроверкуНаЭП);
	
	Возврат ОбъединенныеПараметры;
	
КонецФункции

#КонецОбласти

Процедура ОткрытиеИстории(Знач Элемент)
	
	Если Не Элемент.classList.contains("preview__history") Тогда
		
		Если ЗначениеПустое(Элемент.parentNode) Тогда
			Возврат;
		КонецЕсли;
		
		Элемент = Элемент.parentNode;
		Если Не Элемент.classList.contains("preview__history") Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Ссылка = ЭлектроннаяПочтаУНФВызовСервера.СсылкаИзНавигационной(Элемент.getAttribute("data-href"));
	
	ПараметрыДляПередачи = Новый Структура;
	ПараметрыДляПередачи.Вставить("ДокументСсылка", Ссылка);
	ОткрытьФорму("Документ.Событие.Форма.ФормаИсторииПереписки", ПараметрыДляПередачи, , Ссылка);
	
КонецПроцедуры

Процедура ОткрытиеФормыВложений(Знач Элемент)
	
	Если Не Элемент.classList.contains("preview__files") Тогда
		
		Если ЗначениеПустое(Элемент.parentNode) Тогда
			Возврат;
		КонецЕсли;
		
		Элемент = Элемент.parentNode;
		Если Не Элемент.classList.contains("preview__files") Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Ссылка = ЭлектроннаяПочтаУНФВызовСервера.СсылкаИзНавигационной(Элемент.getAttribute("data-href"));
	
	ПараметрыДляПередачи = Новый Структура;
	ПараметрыДляПередачи.Вставить("Ссылка", Ссылка);
	
	ОткрытьФорму("Документ.Событие.Форма.ФормаЕдиногоПросмотраВложений", ПараметрыДляПередачи, , Истина);
	
КонецПроцедуры

Процедура ОбработкаОповещенияНебезопасноеСодержимое(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьНебезопасноеСодержимое(ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ПоказатьНебезопасноеСодержимое(Параметры)
	
	ДокументHTML = Параметры.ЭлементТекстаПисьма.Документ;
	Результат = ГипертекстКлиент.ПереопределитьHTTPИзАтрибута(ДокументHTML);
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.ЭлементНебезопасногоСодержимого.Видимость = Ложь;
	
	СодержаниеПисьма = СтрШаблон("<html><body>%1</body></html>", ДокументHTML.body.innerHTML);
	ЭлектроннаяПочтаУНФВызовСервера.ЗаписатьСобытиеССодержаниемИзПредпросмотра(Параметры.Событие, СодержаниеПисьма);
	
КонецПроцедуры

#КонецОбласти

Функция ЗначениеПустое(Значение)
	Возврат ТипЗнч(Значение) = Тип("Null") Или Значение = Неопределено;
КонецФункции

Процедура ПолучитьФормуЭлементаЖурнала(ПараметрКоманды, ФормаИсточник, ИмяФормыОбъектаПечати)
	Если ПараметрКоманды.Количество() Тогда
		Если ТипЗнч(ПараметрКоманды[0]) = Тип("ДокументСсылка.ПереоценкаТоваровНаКомиссии") Тогда
			ИмяФормыОбъектаПечати = "Документ.ПереоценкаТоваровНаКомиссии.Форма.ФормаДокумента";
			ФормаИсточник = ПолучитьФорму("Документ.ПереоценкаТоваровНаКомиссии.Форма.ФормаДокумента")
		ИначеЕсли ТипЗнч(ПараметрКоманды[0]) = Тип("ДокументСсылка.РасходнаяНакладная") Тогда
			ИмяФормыОбъектаПечати = "Документ.РасходнаяНакладная.Форма.ФормаДокумента";
			ФормаИсточник = ПолучитьФорму("Документ.РасходнаяНакладная.Форма.ФормаДокумента")
		ИначеЕсли ТипЗнч(ПараметрКоманды[0]) = Тип("ДокументСсылка.ПриходнаяНакладная") Тогда
			ИмяФормыОбъектаПечати = "Документ.ПриходнаяНакладная.Форма.ФормаДокумента";
			ФормаИсточник = ПолучитьФорму("Документ.ПриходнаяНакладная.Форма.ФормаДокумента")
		ИначеЕсли ТипЗнч(ПараметрКоманды[0]) = Тип("ДокументСсылка.ОтчетКомиссионераОСписании") Тогда
			ИмяФормыОбъектаПечати = "Документ.ОтчетКомиссионераОСписании.Форма.ФормаДокумента";
			ФормаИсточник = ПолучитьФорму("Документ.ОтчетКомиссионераОСписании.Форма.ФормаДокумента")
		ИначеЕсли ТипЗнч(ПараметрКоманды[0]) = Тип("ДокументСсылка.ОтчетКомиссионера") Тогда
			ИмяФормыОбъектаПечати = "Документ.ОтчетКомиссионера.Форма.ФормаДокумента";
			ФормаИсточник = ПолучитьФорму("Документ.ОтчетКомиссионера.Форма.ФормаДокумента")
		ИначеЕсли ТипЗнч(ПараметрКоманды[0]) = Тип("ДокументСсылка.ОтчетОПереработке") Тогда
			ИмяФормыОбъектаПечати = "Документ.ОтчетОПереработке.Форма.ФормаДокумента";
			ФормаИсточник = ПолучитьФорму("Документ.ОтчетОПереработке.Форма.ФормаДокумента") 
		ИначеЕсли ТипЗнч(ПараметрКоманды[0]) = Тип("ДокументСсылка.ОтчетПереработчика") Тогда
			ИмяФормыОбъектаПечати = "Документ.ОтчетПереработчика.Форма.ФормаДокумента";
			ФормаИсточник = ПолучитьФорму("Документ.ОтчетПереработчика.Форма.ФормаДокумента")
		ИначеЕсли ТипЗнч(ПараметрКоманды[0]) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
			ИмяФормыОбъектаПечати = "Документ.ЗаказПоставщику.Форма.ФормаДокумента";
			ФормаИсточник = ПолучитьФорму("Документ.ЗаказПоставщику.Форма.ФормаДокумента")
		ИначеЕсли ТипЗнч(ПараметрКоманды[0]) = Тип("ДокументСсылка.ПриходныйОрдер") Тогда
			ИмяФормыОбъектаПечати = "Документ.ПриходныйОрдер.Форма.ФормаДокумента";
			ФормаИсточник = ПолучитьФорму("Документ.ПриходныйОрдер.Форма.ФормаДокумента");
		ИначеЕсли ТипЗнч(ПараметрКоманды[0]) = Тип("ДокументСсылка.РасходныйОрдер") Тогда
			ИмяФормыОбъектаПечати = "Документ.РасходныйОрдер.Форма.ФормаДокумента";
			ФормаИсточник = ПолучитьФорму("Документ.РасходныйОрдер.Форма.ФормаДокумента");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция ЭтоПредметШаблона(ПараметрКоманды)
	
	ТипыПредметовШаблонов = Новый Массив;
	ТипыПредметовШаблонов.Добавить(Тип("СправочникСсылка.Контрагенты"));
	ТипыПредметовШаблонов.Добавить(Тип("СправочникСсылка.КонтактныеЛица"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.АктВыполненныхРабот"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.ЗаданиеНаРаботу"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.ЗаказНаПроизводство"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.ЗаказПокупателя"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.ПриемИПередачаВРемонт"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.Событие"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.СчетНаОплату"));
	ТипыПредметовШаблонов.Добавить(Тип("ДокументСсылка.РасходнаяНакладная"));
	
	Возврат ТипыПредметовШаблонов.Найти(ТипЗнч(ПараметрКоманды)) <> Неопределено;
	
КонецФункции

#КонецОбласти