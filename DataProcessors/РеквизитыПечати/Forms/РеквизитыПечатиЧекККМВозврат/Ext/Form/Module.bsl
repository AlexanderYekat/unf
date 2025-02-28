﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем МассивИзмененныхРеквизитов;

&НаКлиенте
Перем ПодтвержденоЗакрытиеФормы; // Для подтверждения закрытия формы пользователем

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивОбъектовМетаданных = Новый Массив(1);
	МассивОбъектовМетаданных[0] = Параметры.КонтекстПечати.Ссылка.Метаданные();
	
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = МассивОбъектовМетаданных;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ПодменюПечать);
	
	ЗаполнитьЗначенияСвойств(КонтекстПечати, Параметры.КонтекстПечати, "Организация, ПодписьРуководителя,
		|ПодписьЗаведующегоОтделом, ПодписьСтаршегоКассира, ПодписьКассира, Контрагент, КонтактноеЛицоПодписант");
	
	ЗаголовокФормы();
	ЗаполнитьПодсказкиПодписей();
	УстановитьКартинкиКнопок();
	ДоступностьКомандФормы();
	
	// Для отражения информации по новой схеме реквизитов печати
	РаботаСФормойДокумента.НастроитьВидимостьГруппыИнформации(ЭтотОбъект, "ГруппаИнформацияПоНовымРеквизитам",
							"ПоказыватьИнформациюПоНовойСхемеРеквизитовПечати", "ФормыОбработкиРеквизитыПечати");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МассивИзмененныхРеквизитов = Новый Массив;
	ПодтвержденоЗакрытиеФормы = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если Модифицированность И НЕ ЗавершениеРаботы И НЕ ПодтвержденоЗакрытиеФормы Тогда
		
		Отказ = Истина;
        ОписаниеОповещенияОЗавершении    = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);                
        ТекстВопроса        = НСтр("ru = 'Выполненные изменения будут отменены. Продолжить?'");                
        ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет); 		
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
    
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
    
    ПодтвержденоЗакрытиеФормы = Истина;
               
    Закрыть();
    
КонецПроцедуры // ПередЗакрытиемЗавершение()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтекстПечатиПодписьРуководителяПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита("ПодписьРуководителя");
	ЗаполнитьПодсказкиПодписей();

КонецПроцедуры

&НаКлиенте
Процедура КонтекстПечатиПодписьЗаведующегоОтделомПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита("ПодписьЗаведующегоОтделом");
	
КонецПроцедуры

&НаКлиенте
Процедура КонтекстПечатиПодписьСтаршегоКассираПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита("ПодписьСтаршегоКассира");
	ЗаполнитьПодсказкиПодписей();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтекстПечатиПодписьКассираПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита("ПодписьКассира");
	ЗаполнитьПодсказкиПодписей();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтекстПечатиКонтактноеЛицоПодписантПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита("КонтактноеЛицоПодписант");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнформацияПоНовойСхемеЗакрытьНажатие(Элемент)

	Элементы.ГруппаИнформацияПоНовымРеквизитам.Видимость = Ложь;	
	СохранитьНастройкуПоказыватьИнформациюПоНовойСхеме();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьПодписиПоУмолчанию(Команда)
	
	ПредыдущиеЗначения = Новый Структура("ПодписьРуководителя, ПодписьЗаведующегоОтделом, ПодписьСтаршегоКассира, ПодписьКассира, КонтактноеЛицоПодписант");
	ЗаполнитьЗначенияСвойств(ПредыдущиеЗначения, КонтекстПечати);
	
	ПолучитьПодписиПоУмолчаниюНаСервере();
	
	Для каждого ЭлементСтруктуры Из ПредыдущиеЗначения Цикл
		
		Если ЭлементСтруктуры.Значение <> КонтекстПечати[ЭлементСтруктуры.Ключ] Тогда
			
			ЗафиксироватьИзменениеЗначенияРеквизита(ЭлементСтруктуры.Ключ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПодписьКассира(Команда)
	
	ЗаписатьНастройкуПользователя("ПодписьКассира", КонтекстПечати.ПодписьКассира);
	ЗаполнитьПодсказкиПодписей();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПодписьРуководителя(Команда)
	
	ЗаписатьНастройкуПользователя("ПодписьРуководителя", КонтекстПечати.ПодписьРуководителя);
	ЗаполнитьПодсказкиПодписей();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПодписьСтаршегоКассира(Команда)

	ЗаписатьНастройкуПользователя("ПодписьСтаршегоКассира", КонтекстПечати.ПодписьСтаршегоКассира);
	ЗаполнитьПодсказкиПодписей();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗафиксироватьИзменениеЗначенияРеквизита(ИмяРеквизита)
	
	Если МассивИзмененныхРеквизитов.Найти(ИмяРеквизита) = Неопределено Тогда
		
		МассивИзмененныхРеквизитов.Добавить(ИмяРеквизита);
		
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзмененияИЗакрытьФорму(Команда = Неопределено)
	
	ПараметрыЗакрытия = Новый Структура;
	Если Команда <> Неопределено Тогда
		
		ПараметрыЗакрытия.Вставить("Команда", Команда);
		
	КонецЕсли;
	
	ИзмененныеРеквизиты = Новый Структура;
	Для каждого ЭлементМассива Из МассивИзмененныхРеквизитов Цикл
		
		ИзмененныеРеквизиты.Вставить(ЭлементМассива, КонтекстПечати[ЭлементМассива]);
		
	КонецЦикла;
	ПараметрыЗакрытия.Вставить("ИзмененныеРеквизиты", ИзмененныеРеквизиты);
	ПодтвержденоЗакрытиеФормы = Истина;	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура ЗаголовокФормы()
	
	Заголовок = Обработки.РеквизитыПечати.ЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПодписиПоУмолчаниюНаСервере()
	
	ДокументОбъект = ДанныеФормыВЗначение(КонтекстПечати, Тип("ДокументОбъект.ЧекККМВозврат"));
	Обработки.РеквизитыПечати.ПодписиПоУмолчанию(ДокументОбъект);
	ЗначениеВДанныеФормы(ДокументОбъект, КонтекстПечати);
	
КонецПроцедуры

&НаСервере
Процедура ДоступностьКомандФормы()
	
	Если НЕ ПравоДоступа("Изменение", КонтекстПечати.Ссылка.Метаданные()) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаВосстановитьПодписиПоУмолчанию", "Доступность", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодсказкиПодписей() 

	Если КонтекстПечати.ПодписьРуководителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтекстПечати.Организация, 
		"ПодписьРуководителя") Тогда
		Элементы.ПодписьРуководителя.Подсказка = НСтр("ru='Подпись из реквизитов организации'");		
	Иначе
		Элементы.ПодписьРуководителя.Подсказка = НСтр("ru='Подпись из настроек пользователя'");
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКартинкиКнопок()
	
	КартинкаСохранения = ОбщегоНазначенияУНФКлиентСервер.КартинкаСохраненияНастроек();
	Элементы.СохранитьПодписьРуководителя.Картинка = КартинкаСохранения;
	Элементы.СохранитьПодписьСтаршегоКассира.Картинка = КартинкаСохранения;
	Элементы.СохранитьПодписьКассира.Картинка = КартинкаСохранения;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНастройкуПользователя(НазваниеНастройки, ЗначениеНастройки)
	
	ЗаписатьНастройкуПользователяСервер(НазваниеНастройки, ЗначениеНастройки);	
	
	СтрокаЗаголовка = НСтр("ru='Сохранение настроек пользователя'");
	ШаблонСообщения = НСтр("ru='Значение сохранено для использования в новых документах %1 %2'");
	
	ПараметрОрганизация = "";
	
	Если ИспользоватьНесколькоОрганизаций Тогда
		
		НаименованиеОрганизации = УправлениеНебольшойФирмойВызовСервера.ЗначениеРеквизитаОбъекта(
			КонтекстПечати.Организация, "Наименование");
		ПараметрОрганизация = СтрШаблон(НСтр("ru='по организации %1'"), НаименованиеОрганизации);
		
	КонецЕсли;
	
	ПараметрПользователь = СтрШаблон(НСтр("ru='пользователем %1'"), ПользователиКлиент.АвторизованныйПользователь());

	СтрокаТекста = СтрШаблон(ШаблонСообщения, ПараметрОрганизация, ПараметрПользователь);
	КартинкаСохранения = ОбщегоНазначенияУНФКлиентСервер.КартинкаСохраненияНастроек();
	
	ПоказатьОповещениеПользователя(СтрокаЗаголовка, , СтрокаТекста, КартинкаСохранения,
		СтатусОповещенияПользователя.Важное);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкуПользователяСервер(НазваниеНастройки, ЗначениеНастройки)

	РегистрыСведений.НастройкиПользователей.Установить(ЗначениеНастройки, НазваниеНастройки, ,
		КонтекстПечати.Организация);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкуПоказыватьИнформациюПоНовойСхеме()

	РаботаСФормойДокумента.СохранитьВидимостьГруппыИнформации(ИмяФормы,
			"ПоказыватьИнформациюПоНовойСхемеРеквизитовПечати", Ложь, "ФормыОбработкиРеквизитыПечати");
	
КонецПроцедуры

#КонецОбласти

#Область Библиотеки

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму(Команда);
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, КонтекстПечати);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, КонтекстПечати, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, КонтекстПечати);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
