﻿
#Область ПрограммныйИнтерфейс

// Рассчитать суммы в строке ТЧ
//
// Параметры:
//  СтрокаТабличнойЧасти - ДанныеФормыСтруктура	 - Данные текущей строки таблицы формы
//  ПараметрыРасчета	 - Структура			 - Содержит данные данные документа, необходимые для пересчета
//
Процедура РассчитатьСуммыВСтрокеТЧ(СтрокаТабличнойЧасти, ПараметрыРасчета) Экспорт

	Если ПараметрыРасчета.Свойство("РассчитатьСуммуСкидки") = Неопределено 
		И ПараметрыРасчета.Свойство("РассчитатьПроцентСкидки")=Неопределено Тогда 
		
		ПараметрыРасчета.Вставить("РассчитатьСуммуСкидки", Истина);
		
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТабличнойЧасти, "Кратность")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТабличнойЧасти, "Коэффициент") Тогда
		
		КоличествоСтроки = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Кратность * СтрокаТабличнойЧасти.Коэффициент;
		
	Иначе
		
		КоличествоСтроки = СтрокаТабличнойЧасти.Количество;
		
	КонецЕсли; 
	
	СтрокаТабличнойЧасти.Сумма = КоличествоСтроки * СтрокаТабличнойЧасти.Цена;
	
	Если ПараметрыРасчета.Свойство("СброситьФлагСкидкиРассчитаны") 
		И ПараметрыРасчета.СброситьФлагСкидкиРассчитаны
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТабличнойЧасти, "ПроцентАвтоматическойСкидки") Тогда
		
		СтрокаТабличнойЧасти.ПроцентАвтоматическойСкидки = 0;
		СтрокаТабличнойЧасти.СуммаАвтоматическойСкидки = 0;
		
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТабличнойЧасти, "ПроцентСкидкиНаценки") Тогда
		
		Если ПараметрыРасчета.Свойство("РассчитатьПроцентСкидки") 
			И ПараметрыРасчета.РассчитатьПроцентСкидки 
			И СтрокаТабличнойЧасти.Сумма > 0 Тогда //Если ввел сумму скидки 
			
			Если СтрокаТабличнойЧасти.СуммаСкидкиНаценки >= СтрокаТабличнойЧасти.Сумма Тогда
				
				СтрокаТабличнойЧасти.СуммаСкидкиНаценки = СтрокаТабличнойЧасти.Сумма;
				СтрокаТабличнойЧасти.Сумма = 0;
				СтрокаТабличнойЧасти.ПроцентСкидкиНаценки = 100;
				
			Иначе 
				
				СтрокаТабличнойЧасти.ПроцентСкидкиНаценки = Окр(100*СтрокаТабличнойЧасти.СуммаСкидкиНаценки / (КоличествоСтроки * СтрокаТабличнойЧасти.Цена), 2);
				
			КонецЕсли;
		Иначе  //Если ввел процент скидки или по-умолчанию, если указан процент и сумма, пересчитываем сумму скидки из процента 
			
			СтрокаТабличнойЧасти.СуммаСкидкиНаценки = Окр(КоличествоСтроки * СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.ПроцентСкидкиНаценки / 100, 2);
			
		КонецЕсли;
		
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Сумма - СтрокаТабличнойЧасти.СуммаСкидкиНаценки;
		
		ЦенообразованиеКлиентСервер.ПересчитатьСтрокуТЧПоМинимальнымЦенам(СтрокаТабличнойЧасти, КоличествоСтроки, ПараметрыРасчета);

	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТабличнойЧасти, "СуммаСкидки") Тогда
		
		СтрокаТабличнойЧасти.СуммаСкидки = СтрокаТабличнойЧасти.СуммаСкидкиНаценки;
		
	КонецЕсли; 
	
	РассчитатьСуммуНДСИВсего(СтрокаТабличнойЧасти, ПараметрыРасчета);
	
КонецПроцедуры

// Рассчитать сумму НДС и Всего
//
// Параметры:
//  СтрокаТабличнойЧасти - ДанныеФормыСтруктура	 - Данные текущей строки таблицы формы
//  ПараметрыРасчета	 - Структура			 - Содержит данные данные документа, необходимые для пересчета
//
Процедура РассчитатьСуммуНДСИВсего(СтрокаТабличнойЧасти, ПараметрыРасчета) Экспорт
	
	СтавкаНДС = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(СтрокаТабличнойЧасти.СтавкаНДС);
	
	СтрокаТабличнойЧасти.СуммаНДС = ?(ПараметрыРасчета.СуммаВключаетНДС, 
									  СтрокаТабличнойЧасти.Сумма - (СтрокаТабличнойЧасти.Сумма) / ((СтавкаНДС + 100) / 100),
									  СтрокаТабличнойЧасти.Сумма * СтавкаНДС / 100);
									  
	СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(ПараметрыРасчета.СуммаВключаетНДС, 0, СтрокаТабличнойЧасти.СуммаНДС);
	
КонецПроцедуры

// Заполняет ключ связи таблиц документа или обработки
//
// Параметры:
//  ТабличнаяЧасть		 - ДанныеФормыКоллекция	 - Таблица формы, в которой следует заполнить ключ связи
//  СтрокаТабличнойЧасти - ДанныеФормыСтруктура	 - Данные текущей строки таблицы формы
//  ИмяРеквизитаСвязи	 - Строка				 - Имя реквизита ключа связи в ТЧ
//  ВремКлючСвязи		 - Число				 - Текущее максимальное значение ключа связи
//
Процедура ЗаполнитьКлючСвязи(ТабличнаяЧасть, СтрокаТабличнойЧасти, ИмяРеквизитаСвязи, ВремКлючСвязи = 0) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти[ИмяРеквизитаСвязи]) Тогда
		Если ВремКлючСвязи = 0 Тогда
			Для Каждого СтрокаТЧ Из ТабличнаяЧасть Цикл
				Если ВремКлючСвязи < СтрокаТЧ[ИмяРеквизитаСвязи] Тогда
					ВремКлючСвязи = СтрокаТЧ[ИмяРеквизитаСвязи];
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		СтрокаТабличнойЧасти[ИмяРеквизитаСвязи] = ВремКлючСвязи + 1;
	КонецЕсли;
	
КонецПроцедуры

// Удаляет строки по ключу связи в таблице документа или обработки
//
// Параметры:
//  ТабличнаяЧасть		 - ДанныеФормыКоллекция	 - Таблица формы, в которой следует заполнить ключ связи
//  СтрокаТабличнойЧасти - ДанныеФормыСтруктура	 - Данные текущей строки таблицы формы
//  ИмяРеквизитаСвязи	 - Строка				 - Имя реквизита ключа связи в ТЧ
//
Процедура УдалитьСтрокиПоКлючуСвязи(ТабличнаяЧасть, СтрокаТабличнойЧасти, ИмяРеквизитаСвязи = "КлючСвязи") Экспорт
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить(ИмяРеквизитаСвязи, СтрокаТабличнойЧасти[ИмяРеквизитаСвязи]);
	
	УдаляемыеСтроки = ТабличнаяЧасть.НайтиСтроки(СтруктураПоиска);
	Для каждого СтрокаТаблицы Из УдаляемыеСтроки Цикл
		
		ТабличнаяЧасть.Удалить(СтрокаТаблицы);
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает массив найденных строк по заданному ключу связи
//
// Параметры:
//  ТабличнаяЧасть		 - ДанныеФормыКоллекция	 - Таблица формы, в которой следует заполнить ключ связи
//  КлючСвязи			 - Число				 - Искомое значение ключа связи
//  ИмяРеквизитаСвязи	 - Строка				 - Имя реквизита ключа связи в ТЧ
// 
// Возвращаемое значение:
//  Массив - Коллекция найденных строк табличной части
//
Функция СтрокиПоКлючуСвязи(ТабличнаяЧасть, КлючСвязи, ИмяРеквизитаСвязи = "КлючСвязи") Экспорт
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить(ИмяРеквизитаСвязи, КлючСвязи);
	Возврат ТабличнаяЧасть.НайтиСтроки(СтруктураОтбора);
	
КонецФункции

// Создает новый ключ связи для таблиц.
//
// Параметры:
//  ФормаДокумента - ФормаКлиентскогоПриложения - Форма документа, реквизиты которой обрабатываются процедурой.
//
// Возвращаемое значение:
//  Число - Следующий ключ связи для таблицы
//
Функция СоздатьНовыйКлючСвязи(ФормаДокумента) Экспорт

	СписокЗначений = Новый СписокЗначений;
	
	ТабличнаяЧасть = ФормаДокумента.Объект[ФормаДокумента.ИмяТабличнойЧасти];
	Для каждого СтрокаТЧ Из ТабличнаяЧасть Цикл
        СписокЗначений.Добавить(СтрокаТЧ.КлючСвязи);
	КонецЦикла;

    Если СписокЗначений.Количество() = 0 Тогда
		КлючСвязи = 1;
	Иначе
		СписокЗначений.СортироватьПоЗначению();
		КлючСвязи = СписокЗначений.Получить(СписокЗначений.Количество() - 1).Значение + 1;
	КонецЕсли;

	Возврат КлючСвязи;

КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// ++( 00-00365291
// Создает новый ключ связи для таблицы
//
// Параметры:
//  Таблица - ТаблицаЗначений - Таблица, для которой создается новый ключ связи
//
// Возвращаемое значение:
//  Число - Следующий ключ связи для таблицы
//
Функция СоздатьНовыйКлючСвязиДляТаблицы(Таблица) Экспорт
	
	СписокЗначений = Новый СписокЗначений;
	
	ТабличнаяЧасть = Таблица;
	Для каждого СтрокаТЧ Из ТабличнаяЧасть Цикл
        СписокЗначений.Добавить(СтрокаТЧ.КлючСвязи);
	КонецЦикла;

    Если СписокЗначений.Количество() = 0 Тогда
		КлючСвязи = 1;
	Иначе
		СписокЗначений.СортироватьПоЗначению();
		КлючСвязи = СписокЗначений.Получить(СписокЗначений.Количество() - 1).Значение + 1;
	КонецЕсли;

	Возврат КлючСвязи;	
	
КонецФункции
// )++ 00-00365291
#КонецОбласти


 