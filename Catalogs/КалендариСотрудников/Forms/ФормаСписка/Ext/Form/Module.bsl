﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПоказыватьТолькоСвоиКалендари = Параметры.ТолькоСвои;
	ПоказыватьКалендариДругихСотрудниковДляВыбора = Параметры.ПоказатьЧужие;
	УстановитьДоступныеКалендари();
	
	Список.Параметры.УстановитьЗначениеПараметра("ОсновнойКалендарь",
		УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ОсновнойКалендарь"));
		
	УстановитьУсловноеОформление();
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Недействителен",
		Ложь,,,
		Не Элементы.ПоказыватьНедействительных.Пометка);

	// Установим настройки формы для случая открытия в режиме выбора
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	Элементы.Список.МножественныйВыбор = ?(Параметры.ЗакрыватьПриВыборе = Неопределено, Ложь, Не Параметры.ЗакрыватьПриВыборе);
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = КлючНазначенияИспользования + "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе
		КлючНазначенияИспользования = КлючНазначенияИспользования + "Список";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_КалендарьСотрудника" Тогда
		УстановитьДоступныеКалендари();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка")
		И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		Элементы.ФормаИспользоватьКакОсновной.Доступность = Не Элементы.Список.ТекущиеДанные.ЭтоОсновной;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьНедействительных(Команда)
	
	Элементы.ПоказыватьНедействительных.Пометка = Не Элементы.ПоказыватьНедействительных.Пометка;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	Список,
	"Недействителен",
	Ложь,
	,
	,
	Не Элементы.ПоказыватьНедействительных.Пометка);
	УстановитьДоступныеКалендари();
	
КонецПроцедуры
	
&НаКлиенте
Процедура ИспользоватьКакОсновной(Команда)
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка")
		Или Элементы.Список.ТекущиеДанные = Неопределено
		Или Элементы.Список.ТекущиеДанные.ЭтоОсновной Тогда
		
		Возврат;
	КонецЕсли;
	
	УстановитьОсновнойКалендарь(Элементы.Список.ТекущиеДанные.Ссылка);
	Элементы.ФормаИспользоватьКакОсновной.Доступность = Не Элементы.Список.ТекущиеДанные.ЭтоОсновной;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	НовоеУсловноеОформление = Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	
	Оформление = НовоеУсловноеОформление.Оформление.Элементы.Найти("ЦветТекста");
	Оформление.Значение 		= ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет;
	Оформление.Использование 	= Истина;
	
	Отбор = НовоеУсловноеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	Отбор.Использование 	= Истина;
	Отбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Недействителен");
	Отбор.ПравоеЗначение 	= Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОсновнойКалендарь(знач НовыйОсновнойКалендарь)
	
	РегистрыСведений.НастройкиПользователей.Установить(НовыйОсновнойКалендарь, "ОсновнойКалендарь");
	Список.Параметры.УстановитьЗначениеПараметра("ОсновнойКалендарь", НовыйОсновнойКалендарь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступныеКалендари()
	
	ПоказатьВсеКалендари = Пользователи.ЭтоПолноправныйПользователь() И НЕ ПоказыватьТолькоСвоиКалендари;
	
	Если ПоказатьВсеКалендари Тогда
		Возврат;
	КонецЕсли;
	
	ДоступныеКалендари = Справочники.КалендариСотрудников.ДоступныеСотрудникуКалендари(,НЕ Элементы.ПоказыватьНедействительных.Пометка).ВыгрузитьКолонку("Календарь");
	
	Если ПоказыватьКалендариДругихСотрудниковДляВыбора Тогда
		ОсновныеКалендариСотрудников = Справочники.КалендариСотрудников.ОсновныеКалендариСотрудников();
		Для каждого КалендарьСотрудника Из ОсновныеКалендариСотрудников Цикл
			ДоступныеКалендари.Добавить(КалендарьСотрудника.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ДоступныеКалендари = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ДоступныеКалендари);
	Список.Параметры.УстановитьЗначениеПараметра("ДоступныеКалендари", ДоступныеКалендари);
	
КонецПроцедуры

#КонецОбласти
