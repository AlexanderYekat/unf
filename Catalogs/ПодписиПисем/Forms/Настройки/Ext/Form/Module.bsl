﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнениеРеквизитов();
	
	УстановитьИзначальныйВидФормы();
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОсновнаяПодписьПоУмолчаниюДляНовыхПриИзменении(Элемент)
	
	ОсновнаяПодписьПоУмолчаниюПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяПодписьПоУмолчаниюДляНовыхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьВыборОсновнойПодписи(ПредназначениеДляНового(), "ВыборОсновнойПодписиПоУмолчаниюЗавершение");
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяПодписьПоУмолчаниюДляНовыхАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ДанныеВыбораПодписейИнтерактивно(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяПодписьПоУмолчаниюПриОтветеПриИзменении(Элемент)
	
	ОсновнаяПодписьПоУмолчаниюПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяПодписьПоУмолчаниюПриОтветеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьВыборОсновнойПодписи(ПредназначениеПриОтвете(), "ВыборОсновнойПодписиПоУмолчаниюЗавершение");
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяПодписьПоУмолчаниюПриОтветеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ДанныеВыбораПодписейИнтерактивно(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОсновныхПодписейЗакрытьНажатие(Элемент)
	
	Элементы.ГруппаДекорацияОсновныхПодписей.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОсновныеПодписи

&НаКлиенте
Процедура ОсновныеПодписиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеПодписиПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеПодписиПодписьДляНовогоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьВыборОсновнойПодписи(ПредназначениеДляНового(), "ВыборОсновнойПодписиЗавершение");
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеПодписиПодписьДляНовогоПриИзменении(Элемент)
	
	ОсновнаяПодписьПриИзменении(ПредназначениеДляНового());
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеПодписиПодписьДляНовогоАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ДанныеВыбораПодписейИнтерактивно(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеПодписиПодписьПриОтветеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьВыборОсновнойПодписи(ПредназначениеПриОтвете(), "ВыборОсновнойПодписиЗавершение");
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеПодписиПодписьПриОтветеПриИзменении(Элемент)
	
	ОсновнаяПодписьПриИзменении(ПредназначениеПриОтвете());
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеПодписиПодписьПриОтветеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ДанныеВыбораПодписейИнтерактивно(Текст);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОкНаСервере();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВыборПодписи(Команда)
	
	Если ТекущийЭлемент <> Элементы.ОсновныеПодписи  Тогда
		Возврат;
	КонецЕсли;
	
	ПолеТаблицы = ТекущийЭлемент.ТекущийЭлемент;
	Если ПолеТаблицы <> Элементы.ОсновныеПодписиПодписьДляНового
		И ПолеТаблицы <> Элементы.ОсновныеПодписиПодписьПриОтвете Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ОсновныеПодписи.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолеТаблицы = Элементы.ОсновныеПодписиПодписьДляНового Тогда
		
		ТекущиеДанные.ПодписьДляНового = ОсновнаяПодписьПоУмолчаниюДляНовых;
		ТекущиеДанные.ЭтоПодписьПоУмолчаниюДляНового = Истина;
		
	Иначе
		
		ТекущиеДанные.ПодписьПриОтвете = ОсновнаяПодписьПоУмолчаниюПриОтвете;
		ТекущиеДанные.ЭтоПодписьПоУмолчаниюПриОтвете = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаСобытийФормы

&НаСервере
Процедура ЗаполнениеРеквизитов()
	
	ЗаполнитьОсновныеПодписи();
	
	ДанныеВыбораПодписей = ПолучитьДанныеВыбора(Тип("СправочникСсылка.ПодписиПисем"), Новый Структура);
	
	ИспользоватьПодписиСШаблонами = ИспользоватьПодписиСШаблонами();
	ДекорацияДляОсновныхПодписейБылаПоказана = ПоказыватьПодсказкуИспользованияПодписей();
	
КонецПроцедуры

#КонецОбласти

#Область ВидФормы

&НаСервере
Процедура УстановитьИзначальныйВидФормы()
	
	ВернутьФормуКИзначальнымНастройкам();
	
	Если Не ДекорацияДляОсновныхПодписейБылаПоказана Тогда
		Элементы.ГруппаДекорацияОсновныхПодписей.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВернутьФормуКИзначальнымНастройкам()
	
	КлючОбъекта = "Справочник.ПодписиПисем.Форма.ФормаСписка/НастройкиОкна";
	ХранилищеСистемныхНастроек.Удалить(КлючОбъекта, "", ИмяПользователя());
	КлючСохраненияПоложенияОкна = Новый УникальныйИдентификатор;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	УстановитьУсловноеОформлениеДляОсновныхПодписей();
	
КонецПроцедуры

#КонецОбласти

#Область ОсновныеПодписи

#Область ОсновныеПодписиПоУмолчанию

&НаКлиенте
Процедура ВыборОсновнойПодписиПоУмолчаниюЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Или ВыбранноеЗначение = ПустаяПодпись() Тогда
		Возврат;
	КонецЕсли;
	
	ПредназначениеПодписи = ДополнительныеПараметры.ПредназначениеПодписи;
	Если ПредназначениеПодписи = ПредназначениеДляНового() Тогда
		ОсновнаяПодписьПоУмолчаниюДляНовых = ВыбранноеЗначение;
	Иначе
		ОсновнаяПодписьПоУмолчаниюПриОтвете = ВыбранноеЗначение;
	КонецЕсли;
	
	ОсновнаяПодписьПоУмолчаниюПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяПодписьПоУмолчаниюПриИзменении()
	
	ОчиститьТаблицуОсновныхПодписейПоПодписямПоУмолчанию();
	ЗаполнитьТаблицуОсновныхПодписейПоПодписямПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТаблицуОсновныхПодписейПоПодписямПоУмолчанию()
	
	Для Каждого Строка Из ОсновныеПодписи Цикл
		
		Если Строка.ЭтоПодписьПоУмолчаниюДляНового Тогда
			Строка.ПодписьДляНового = ПустаяПодпись();
		КонецЕсли;
		
		Если Строка.ЭтоПодписьПоУмолчаниюПриОтвете Тогда
			Строка.ПодписьПриОтвете = ПустаяПодпись();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьОсновныеПодписи()
	
	ОсновныеПодписиПоУчетнымЗаписям = РегистрыСведений.ОсновныеПодписиПисем.ОсновныеПодписиПоУчетнымЗаписям();
	
	ЗаполнитьОсновныеПодписиПоУмолчанию(ОсновныеПодписиПоУчетнымЗаписям);
	ЗаполнитьТаблицуОсновныхПодписей(ОсновныеПодписиПоУчетнымЗаписям);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОсновныеПодписиПоУмолчанию(ОсновныеПодписиПоУчетнымЗаписям)
	
	Для Каждого ОсновныеПодписиПоУчетнойЗаписи Из ОсновныеПодписиПоУчетнымЗаписям Цикл
		
		Если ОсновныеПодписиПоУчетнойЗаписи.Ключ <> Справочники.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка() Тогда
			Продолжить;
		КонецЕсли;
		
		Подписи = ОсновныеПодписиПоУчетнойЗаписи.Значение;
		
		Если Подписи = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Подписи[Перечисления.ПредназначенияПодписейПисем.ДляНового] <> Неопределено Тогда
			ОсновнаяПодписьПоУмолчаниюДляНовых = Подписи[Перечисления.ПредназначенияПодписейПисем.ДляНового];
		КонецЕсли;
		
		Если Подписи[Перечисления.ПредназначенияПодписейПисем.ПриОтвете] <> Неопределено Тогда
			ОсновнаяПодписьПоУмолчаниюПриОтвете = Подписи[Перечисления.ПредназначенияПодписейПисем.ПриОтвете];
		КонецЕсли;
		
		Прервать;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуОсновныхПодписей(ОсновныеПодписиПоУчетнымЗаписям)
	
	ОсновныеПодписи.Очистить();
	
	ЗаполнитьТаблицуОсновныхПодписейПоДаннымПодписей(ОсновныеПодписиПоУчетнымЗаписям);
	ЗаполнитьТаблицуОсновныхПодписейПоПодписямПоУмолчаниюНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуОсновныхПодписейПоДаннымПодписей(ОсновныеПодписиПоУчетнымЗаписям)
	
	УчетныеЗаписи = Новый Массив;
	Для Каждого ОсновныеПодписиПоУчетнойЗаписи Из ОсновныеПодписиПоУчетнымЗаписям Цикл
		Если ОсновныеПодписиПоУчетнойЗаписи.Ключ <> Справочники.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка() Тогда
			УчетныеЗаписи.Добавить(ОсновныеПодписиПоУчетнойЗаписи.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Представления = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(УчетныеЗаписи, "Представление");
	
	Для Каждого ОсновныеПодписиПоУчетнойЗаписи Из ОсновныеПодписиПоУчетнымЗаписям Цикл
		
		УчетнаяЗапись = ОсновныеПодписиПоУчетнойЗаписи.Ключ;
		Подписи = ОсновныеПодписиПоУчетнойЗаписи.Значение;
		
		Если УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка() Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТЗ = ОсновныеПодписи.Добавить();
		СтрокаТЗ.УчетнаяЗапись = УчетнаяЗапись;
		СтрокаТЗ.ПредставлениеУчетнойЗаписи = Представления[УчетнаяЗапись];
		
		Если Подписи = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Подписи[Перечисления.ПредназначенияПодписейПисем.ДляНового] <> Неопределено Тогда
			СтрокаТЗ.ПодписьДляНового = Подписи[Перечисления.ПредназначенияПодписейПисем.ДляНового];
		КонецЕсли;
		
		Если Подписи[Перечисления.ПредназначенияПодписейПисем.ПриОтвете] <> Неопределено Тогда
			СтрокаТЗ.ПодписьПриОтвете = Подписи[Перечисления.ПредназначенияПодписейПисем.ПриОтвете];
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуОсновныхПодписейПоПодписямПоУмолчанию()
	
	Для Каждого Строка Из ОсновныеПодписи Цикл
		
		Если Строка.ПодписьДляНового = ПустаяПодпись()
			И ОсновнаяПодписьПоУмолчаниюДляНовых <> ПустаяПодпись() Тогда
			
			Строка.ПодписьДляНового = ОсновнаяПодписьПоУмолчаниюДляНовых;
			Строка.ЭтоПодписьПоУмолчаниюДляНового = Истина;
			
		КонецЕсли;
		
		Если Строка.ПодписьПриОтвете = ПустаяПодпись()
			И ОсновнаяПодписьПоУмолчаниюПриОтвете <> ПустаяПодпись() Тогда
			
			Строка.ПодписьПриОтвете = ОсновнаяПодписьПоУмолчаниюПриОтвете;
			Строка.ЭтоПодписьПоУмолчаниюПриОтвете = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуОсновныхПодписейПоПодписямПоУмолчаниюНаСервере()
	
	Для Каждого Строка Из ОсновныеПодписи Цикл
		
		Если Строка.ПодписьДляНового = ПустаяПодпись()
			И ОсновнаяПодписьПоУмолчаниюДляНовых <> ПустаяПодпись() Тогда
			
			Строка.ПодписьДляНового = ОсновнаяПодписьПоУмолчаниюДляНовых;
			Строка.ЭтоПодписьПоУмолчаниюДляНового = Истина;
			
		КонецЕсли;
		
		Если Строка.ПодписьПриОтвете = ПустаяПодпись()
			И ОсновнаяПодписьПоУмолчаниюПриОтвете <> ПустаяПодпись() Тогда
			
			Строка.ПодписьПриОтвете = ОсновнаяПодписьПоУмолчаниюПриОтвете;
			Строка.ЭтоПодписьПоУмолчаниюПриОтвете = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВыборОсновнойПодписи(ПредназначениеПодписи, НазваниеПроцедурыЗавершения)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ТолькоСписок", Истина);
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ПредназначениеПодписи", ПредназначениеПодписи);
	ОписаниеОповещения = Новый ОписаниеОповещения(
	НазваниеПроцедурыЗавершения,
	ЭтотОбъект,
	ПараметрыОповещения);
	
	ОткрытьФорму("Справочник.ПодписиПисем.Форма.ФормаСписка",
	ПараметрыОткрытияФормы,
	ЭтотОбъект, , , ,
	ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборОсновнойПодписиЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Или ВыбранноеЗначение = ПустаяПодпись() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ОсновныеПодписи.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ПредназначениеПодписи = ПредназначениеДляНового() Тогда
		
		ТекущиеДанные.ПодписьДляНового = ВыбранноеЗначение;
		ТекущиеДанные.ЭтоПодписьПоУмолчаниюДляНового = Ложь;
		
	Иначе
		
		ТекущиеДанные.ПодписьПриОтвете = ВыбранноеЗначение;
		ТекущиеДанные.ЭтоПодписьПоУмолчаниюПриОтвете = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяПодписьПриИзменении(ПредназначениеПодписи)
	
	ТекущиеДанные = Элементы.ОсновныеПодписи.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПредназначениеПодписи = ПредназначениеДляНового() Тогда
		
		Если ТекущиеДанные.ПодписьДляНового = ПустаяПодпись() Тогда
			ТекущиеДанные.ПодписьДляНового = ОсновнаяПодписьПоУмолчаниюДляНовых;
			ТекущиеДанные.ЭтоПодписьПоУмолчаниюДляНового = Истина;
		Иначе
			ТекущиеДанные.ЭтоПодписьПоУмолчаниюДляНового = Ложь;
		КонецЕсли;
		
	Иначе
		
		Если ТекущиеДанные.ПодписьПриОтвете = ПустаяПодпись() Тогда
			ТекущиеДанные.ПодписьПриОтвете = ОсновнаяПодписьПоУмолчаниюПриОтвете;
			ТекущиеДанные.ЭтоПодписьПоУмолчаниюПриОтвете = Истина;
		Иначе
			ТекущиеДанные.ЭтоПодписьПоУмолчаниюПриОтвете = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеВыбораПодписейИнтерактивно(Знач ВведенныйТекст)
	
	ПараметрыДанныхВыбора = Новый Структура;
	ПараметрыДанныхВыбора.Вставить("СтрокаПоиска", ВведенныйТекст);
	Возврат ПолучитьДанныеВыбора(Тип("СправочникСсылка.ПодписиПисем"), ПараметрыДанныхВыбора);
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеДляОсновныхПодписей()
	
	НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(
	НовоеУсловноеОформление.Отбор,
	"ОсновныеПодписи.ЭтоПодписьПоУмолчаниюПриОтвете",
	Истина,
	ВидСравненияКомпоновкиДанных.Равно);
	
	РаботаСФормой.ДобавитьОформляемоеПоле(НовоеУсловноеОформление, Элементы.ОсновныеПодписиПодписьПриОтвете.Имя);
	
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(
	НовоеУсловноеОформление, "ЦветТекста", WebЦвета.Серебряный);
	
	НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(
	НовоеУсловноеОформление.Отбор,
	"ОсновныеПодписи.ЭтоПодписьПоУмолчаниюДляНового",
	Истина,
	ВидСравненияКомпоновкиДанных.Равно);
	
	РаботаСФормой.ДобавитьОформляемоеПоле(НовоеУсловноеОформление, Элементы.ОсновныеПодписиПодписьДляНового.Имя);
	
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(
	НовоеУсловноеОформление, "ЦветТекста", WebЦвета.Серебряный);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеОсновныхПодписейСФормы()
	
	Данные = Новый Массив;
	
	Если ОсновнаяПодписьПоУмолчаниюДляНовых <> ПустаяПодпись()  Тогда
		
		ДанныеПодписи = Новый Структура;
		ДанныеПодписи.Вставить("УчетнаяЗапись", ПустаяУчетнаяЗапись());
		ДанныеПодписи.Вставить("ПредназначениеПодписи", ПредназначениеДляНового());
		ДанныеПодписи.Вставить("Подпись", ОсновнаяПодписьПоУмолчаниюДляНовых);
		Данные.Добавить(ДанныеПодписи);
		
	КонецЕсли;
	
	Если ОсновнаяПодписьПоУмолчаниюПриОтвете <> ПустаяПодпись()  Тогда
		
		ДанныеПодписи = Новый Структура;
		ДанныеПодписи.Вставить("УчетнаяЗапись", ПустаяУчетнаяЗапись());
		ДанныеПодписи.Вставить("ПредназначениеПодписи", ПредназначениеПриОтвете());
		ДанныеПодписи.Вставить("Подпись", ОсновнаяПодписьПоУмолчаниюПриОтвете);
		Данные.Добавить(ДанныеПодписи);
		
	КонецЕсли;
	
	Для Каждого Строка Из ОсновныеПодписи Цикл
		
		Если Не Строка.ЭтоПодписьПоУмолчаниюДляНового И Строка.ПодписьДляНового <> ПустаяПодпись() Тогда
			
			ДанныеПодписи = Новый Структура;
			ДанныеПодписи.Вставить("УчетнаяЗапись", Строка.УчетнаяЗапись);
			ДанныеПодписи.Вставить("ПредназначениеПодписи", ПредназначениеДляНового());
			ДанныеПодписи.Вставить("Подпись", Строка.ПодписьДляНового);
			Данные.Добавить(ДанныеПодписи);
			
		КонецЕсли;
		
		Если Не Строка.ЭтоПодписьПоУмолчаниюПриОтвете И Строка.ПодписьПриОтвете <> ПустаяПодпись() Тогда
			
			ДанныеПодписи = Новый Структура;
			ДанныеПодписи.Вставить("УчетнаяЗапись", Строка.УчетнаяЗапись);
			ДанныеПодписи.Вставить("ПредназначениеПодписи", ПредназначениеПриОтвете());
			ДанныеПодписи.Вставить("Подпись", Строка.ПодписьПриОтвете);
			Данные.Добавить(ДанныеПодписи);
			
		КонецЕсли;
		
	КонецЦикла;
	
	РегистрыСведений.ОсновныеПодписиПисем.СохранитьОсновныеПодписи(Данные);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредназначениеДляНового()
	Возврат ПредопределенноеЗначение("Перечисление.ПредназначенияПодписейПисем.ДляНового");
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредназначениеПриОтвете()
	Возврат ПредопределенноеЗначение("Перечисление.ПредназначенияПодписейПисем.ПриОтвете");
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПустаяУчетнаяЗапись()
	Возврат ПредопределенноеЗначение("Справочник.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка");
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПустаяПодпись()
	Возврат ПредопределенноеЗначение("Справочник.ПодписиПисем.ПустаяСсылка");
КонецФункции

#КонецОбласти

#Область НастройкиПользователя

&НаСервереБезКонтекста
Функция ПоказыватьПодсказкуИспользованияПодписей()
	Возврат ЭлектроннаяПочтаУНФ.ПоказыватьПодсказкуИспользованияПодписей();
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьНастройкуПоказыватьПодсказкуИспользованияПодписей(Значение)
	ЭлектроннаяПочтаУНФ.СохранитьНастройкуПоказыватьПодсказкуИспользованияПодписей(Значение);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИспользоватьПодписиСШаблонами()
	Возврат ЭлектроннаяПочтаУНФ.ИспользоватьПодписиСШаблонами();
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьНастройкуИспользоватьПодписиСШаблонами(Значение)
	ЭлектроннаяПочтаУНФ.СохранитьНастройкуИспользоватьПодписиСШаблонами(Значение);
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ОкНаСервере()
	
	СохранитьДанныеОсновныхПодписейСФормы();
	СохранитьНастройкуИспользоватьПодписиСШаблонами(ИспользоватьПодписиСШаблонами);
	
	Если ДекорацияДляОсновныхПодписейБылаПоказана И Не Элементы.ГруппаДекорацияОсновныхПодписей.Видимость Тогда
		СохранитьНастройкуПоказыватьПодсказкуИспользованияПодписей(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
