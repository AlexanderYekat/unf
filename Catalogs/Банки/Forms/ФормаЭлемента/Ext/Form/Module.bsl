﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтранаРФ = Справочники.СтраныМира.Россия;
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Параметры.Код <> "" Тогда
			Объект.Код = Параметры.Код;
		КонецЕсли;
		
		Если Параметры.КоррСчет <> "" Тогда
			Объект.КоррСчет = Параметры.КоррСчет;
		КонецЕсли;
		
		ЗаполнитьФормуПоОбъекту();
	КонецЕсли;
	
	ИзменитьРеквизитыЗависимыеОтСтраны(ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	УстановитьВидимостьБИКТОФК(ЭтотОбъект);
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьФормуПоОбъекту();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.РучноеИзменение = ?(РучноеИзменение = Неопределено, 2, РучноеИзменение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	
	// Оповестим форму банковского счета об изменении реквизитов банка
	Оповестить("ЗаписанЭлементБанк", Объект.Ссылка, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СВИФТБИКПриИзменении(Элемент)
	
	Объект.СВИФТБИК = ВРег(СокрЛП(Объект.СВИФТБИК));
	
	Если БанковскиеПравилаКлиентСервер.СтрокаСоответствуетФорматуSWIFT(Объект.СВИФТБИК) Тогда
		
		СтранаБанка = СтранаПоSWIFT(Объект.СВИФТБИК);
		
		Если ЗначениеЗаполнено(СтранаБанка) Тогда
			Объект.Страна = СтранаБанка;
		КонецЕсли;
		
		ИзменитьРеквизитыЗависимыеОтСтраны(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаПриИзменении(Элемент)
	
	ИзменитьРеквизитыЗависимыеОтСтраны(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.СтранаМираОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	УстановитьВидимостьБИКТОФК(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Изменить(Команда)
	
	Текст = НСтр("ru = 'Поставляемые данные обновляются автоматически.
		|После ручного изменения автоматическое обновление этого элемента производиться не будет.
		|Продолжить с изменением?'");

	ПоказатьВопрос(Новый ОписаниеОповещения("ИзменитьЗавершение", ЭтотОбъект), Текст, РежимДиалогаВопрос.ДаНет, ,
		КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзКлассификатора(Команда)
	
	ВыполнитьОбновление = Ложь;
	БанкиУНФКлиент.ОбновитьЭлементИзКлассификатора(ЭтотОбъект, ВыполнитьОбновление);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	// Код банка.
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Код");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Страна", ВидСравненияКомпоновкиДанных.НеРавно, Справочники.СтраныМира.Россия);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь)
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьРеквизитыЗависимыеОтСтраны(Форма)
	
	ЯвляетсяБанкомРФ = (Форма.Объект.Страна = Форма.СтранаРФ);
	
	Форма.Элементы.ТекстРучногоИзменения.Видимость = ЯвляетсяБанкомРФ;
	Форма.Элементы.ОбновитьИзКлассификатора.Видимость = ЯвляетсяБанкомРФ;
	Форма.Элементы.Изменить.Видимость = ЯвляетсяБанкомРФ;
	
	Если ЯвляетсяБанкомРФ Тогда
		Форма.Элементы.Код.Заголовок = НСтр("ru = 'БИК'");
	Иначе
		Форма.Элементы.Код.Заголовок = НСтр("ru = 'Национальный код'"); 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуПоОбъекту()
	
	БанкиУНФ.ПрочитатьФлагРучногоИзменения(ЭтотОбъект);
	
	Элементы.НадписьДеятельностьБанкаПрекращена.Видимость = ДеятельностьПрекращена;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ЗаблокироватьДанныеФормыДляРедактирования();
		Модифицированность = Истина;
		РучноеИзменение    = Истина;
		
		БанкиУНФКлиент.ОбработатьФлагРучногоИзменения(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере()
	
	БанкиУНФ.ВосстановитьЭлементИзОбщихДанных(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтранаПоSWIFT(СВИФТБИК)
	
	Возврат Справочники.Банки.СтранаПоSWIFT(СВИФТБИК);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьБИКТОФК(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если ЗначениеЗаполнено(Объект.Код) Тогда
		ПервыеЦифрыБИК = Лев(Объект.Код, 2);
		ЭтоБИКТОФК = (ПервыеЦифрыБИК = "00" Или ПервыеЦифрыБИК = "01" Или ПервыеЦифрыБИК = "02");
		Элементы.ДекорацияБИКТОФК.Видимость = ЭтоБИКТОФК;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

// Процедура-обработчик ответа на вопрос о обновлении данных из классификатора
//
&НаКлиенте
Процедура ОпределитьНеобходимостьОбновленияДанныхИзКлассификатора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = КодВозвратаДиалога.Да Тогда
		
		ЗаблокироватьДанныеФормыДляРедактирования();
		Модифицированность = Истина;
		ОбновитьНаСервере();
		ОповеститьОбИзменении(Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры // ОпределитьНеобходимостьОбновленияДанныхИзКлассификатора()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

