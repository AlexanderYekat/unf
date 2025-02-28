﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ОбластьДоступа", ОбластьДоступа);
	
	ВыполнитьСинхронизацию = Истина;
	Если Параметры.Свойство("ВыполнитьСинхронизацию") Тогда
 		ВыполнитьСинхронизацию = Параметры.ВыполнитьСинхронизацию;
	КонецЕсли;
	
	Элементы.ДекорацияВыполняетсяОбменGoogle.Заголовок = ЗаголовокВыполняетсяОбменGoogle();
	
	ОбменСGoogle.ИнициализироватьСеансовыеДанные(
	СеансовыеДанные,
	Пользователи.ТекущийПользователь(),
	ОбластьДоступа);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбменСGoogleКлиентСервер.НеЗаполненТокенДоступа(СеансовыеДанные) Тогда
		ПодключитьОбработчикОжидания("НачатьАвторизацию", 0.1, Истина);
	Иначе
		СинхронизироватьНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НачатьАвторизацию()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьРезультатЗапросаТокена", ЭтотОбъект);
	ОткрытьФорму("РегистрСведений.СеансовыеДанныеGoogle.Форма.ЗапросТокена", ОписаниеОбластейДоступа(), ЭтаФорма, , , ,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатЗапросаТокена(Результат, Параметры) Экспорт
	
	СеансовыеДанные = Результат;
	
	Если ОбменСGoogleКлиентСервер.НеЗаполненТокенДоступа(СеансовыеДанные) Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	СинхронизироватьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьНаКлиенте()

	Задание = ЗаданиеСинхронизироватьНаСервере();
	Если Задание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьЗавершениеСинхронизации", ЭтотОбъект);
	Оповестить("ОбновитьСтатусСеансовыхДанныхGoogle");
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ЗаданиеСинхронизироватьНаСервере()
	
	// Здесь у функции есть побочный эффект - инициализация сеансовых данных.
	// Так сделано для экономии серверного вызова.
	Если ОбластьДоступа = Перечисления.ОбластиДоступаGoogle.Календарь Тогда
		ОбменСGoogle.ИнициализироватьУзелПланаОбменаДляКалендаряGoogle();
	КонецЕсли;
	ОбменСGoogle.ИнициализироватьСеансовыеДанные(
	СеансовыеДанные,
	Пользователи.ТекущийПользователь(),
	ОбластьДоступа);
	
	Если ОбменСGoogleКлиентСервер.НеЗаполненТокенДоступа(СеансовыеДанные) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Результат = ДлительныеОперации.ВыполнитьВФоне(
	ИмяЗаданияНаСинхронизацию(),
	СеансовыеДанные,
	ПараметрыВыполнения);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьЗавершениеСинхронизации(Результат, Параметры) Экспорт
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Функция ЗаголовокВыполняетсяОбменGoogle()
	
	Возврат НСтр("ru = 'Выполняется синхронизация календаря с Google...'");
	
КонецФункции

&НаСервере
Функция ИмяЗаданияНаСинхронизацию()
	
	Возврат "ОбменСGoogle.СинхронизироватьGoogleCalendar";
	
КонецФункции

&НаКлиенте
Функция ОписаниеОбластейДоступа()
	
	Результат = Новый Структура("ОписанияОбластейДоступа");
	Результат.ОписанияОбластейДоступа = ОбменСGoogleКлиентСервер.ОписанияОбластейДоступаКалендарь();
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти