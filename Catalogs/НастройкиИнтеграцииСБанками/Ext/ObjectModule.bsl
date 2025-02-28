﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДубльНастроек = ДубльНастроек();
	Если ЗначениеЗаполнено(ДубльНастроек) Тогда
		ЗаписьЖурналаРегистрации(ИнтеграцияСБанкамиКлиентСервер.ИмяСобытияЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка, Метаданные(), Ссылка,
			НСтр("ru = 'Есть другие настройки интеграции с таким же набором банков'"));
		ВызватьИсключение НСтр("ru = 'Есть другие настройки интеграции с таким же набором банков'")
	КонецЕсли;
	
	Если ПустаяСтрока(Префикс) Тогда
		Для Каждого СтрокаБанка Из Банки Цикл
			Если Не ЗначениеЗаполнено(СтрокаБанка.Банк) Тогда
				Продолжить;
			КонецЕсли;
			
			Префикс = Справочники.НастройкиИнтеграцииСБанками.НовыйПрефикс();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

Функция ДубльНастроек()
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Настройка", Ссылка);
	Запрос.Параметры.Вставить("Банки", Банки.ВыгрузитьКолонку("Банк"));
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	НастройкиИнтеграцииСБанкамиБанки.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НастройкиИнтеграцииСБанками.Банки КАК НастройкиИнтеграцииСБанкамиБанки
	|ГДЕ
	|	НастройкиИнтеграцииСБанкамиБанки.Банк В(&Банки)
	|	И НастройкиИнтеграцииСБанкамиБанки.Ссылка <> &Настройка";
	ДублиНастроек = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	Возврат ДублиНастроек;
	
КонецФункции

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли