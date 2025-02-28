﻿#Область ПрограммныйИнтерфейс

// Заполняет список значений Приемник из списка значений Источник
//
// Параметры:
// 	Источник - СписокЗначений - источник.
// 	Приемник - СписокЗначений - приемник.
Процедура ЗаполнитьСписокИзСписка(Источник, Приемник) Экспорт

	Приемник.Очистить();
	Для Каждого ЭлСписка Из Источник Цикл
		Приемник.Добавить(ЭлСписка.Значение, ЭлСписка.Представление);
	КонецЦикла;

КонецПроцедуры

// Функция получает элементы, присутствующие в каждом массиве
//
// Параметры:
//  Массив1	 - массив	 - первый массив
//  Массив2	 - массив	 - второй массив
// Возвращаемое значение:
//  массив - массив значений, содержащихся в двух массивах
Функция ПолучитьСовпадающиеЭлементыМассивов(Массив1, Массив2) Экспорт

	Результат = Новый Массив;

	Для Каждого Значение Из Массив1 Цикл
		Если Массив2.Найти(Значение) <> Неопределено Тогда
			Результат.Добавить(Значение);
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Проверяет соответствие реквизитов объекта параметрам отбора.
//
// Параметры:
//  Объект			 - Произвольный - объект, у которого нужно проверить наличие реквизита или свойства;
//  ПараметрыОтбора	 - Соответствие - Условия отбора.
// 
// Возвращаемое значение:
//   - Булево
//
Функция ОбъектСоответствуетПараметрамОтбора(Объект, ПараметрыОтбора) Экспорт

	СоответствуетОтбору = Истина;

	Для Каждого ПараметрОтбора Из ПараметрыОтбора Цикл
		СоответствуетОтбору = (Объект[ПараметрОтбора.Ключ] = ПараметрОтбора.Значение);
		Если Не СоответствуетОтбору Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат СоответствуетОтбору;

КонецФункции

// Возвращает номер квартала, которому принадлежит переданная дата.
//
// Параметры:
//   Дата - Дата - дата, для которой необходимо вычислить номер квартала
//
// Возвращаемое значение:
//   Число - номер квартала
//
Функция НомерКвартала(Дата) Экспорт
	
	Возврат Месяц(КонецКвартала(Дата)) / 3;
	
КонецФункции

#Область РаботаСМассивами

// Удаление из массива пустых элементов
//
// Параметры:
//   МассивЭлементов - Массив
//
Процедура УдалитьНеЗаполненныеЭлементыМассива(МассивЭлементов) Экспорт

	КоличествоЭлементов = МассивЭлементов.Количество();
	Для Итератор = 1 По КоличествоЭлементов Цикл
		Если Не ЗначениеЗаполнено(МассивЭлементов[КоличествоЭлементов - Итератор]) Тогда
			МассивЭлементов.Удалить(КоличествоЭлементов - Итератор);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Функция ТекстРазделителяЗапросовПакета() Экспорт

	ТекстРазделителя =
	"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";

	Возврат ТекстРазделителя;

КонецФункции

#КонецОбласти

// Возвращает картинку, используемую для сохранения настроек
// Возвращаемое значение:
//   Картинка
//
Функция КартинкаСохраненияНастроек() Экспорт
	
	Возврат БиблиотекаКартинок.СохранитьЗначениеНастройки;
	
КонецФункции

// Склоняет представление месяца.
//
// Параметры:
// 	Период 	     - Дата - дата в месяце, который нужно просклонять.
// 	Падеж        - Число - падеж, в который необходимо просклонять представление объекта.
//                  			1 - Именительный.
//                  			2 - Родительный.
//                  			3 - Дательный.
//                  			4 - Винительный.
//                  			5 - Творительный.
//                  			6 - Предложный.
//  ДобавлятьГод - Булево - признак, что к представлению месяца нужно добавлять 4 цифры года.
//
// Возвращаемое значение:
//   Строка      - представление месяца в нужном падеже.
//
Функция ФормаПадежаМесяца(Период, Падеж, ДобавлятьГод = Истина) Экспорт
	
	Если Падеж = 1 Или Падеж = 4 Тогда
		
		ПредставлениеМесяца = Формат(Период, ?(ДобавлятьГод, "Л=ru; ДФ='ММММ гггг'", "Л=ru; ДФ=ММММ"));
		Возврат ПредставлениеМесяца;
		
	КонецЕсли;
	
	ПредставлениеМесяца = Формат(Период, "Л=ru; ДФ=ММММ");
	НомерМесяца = Месяц(Период);
	
	Если НомерМесяца = 3 Или НомерМесяца = 8 Тогда
		
		СменитьОкончание = Ложь;
		Если Падеж = 3 Тогда
			ОкончаниеПадежа = НСтр("ru = 'у'");
		ИначеЕсли Падеж = 5 Тогда	
			ОкончаниеПадежа = НСтр("ru = 'ом'");
		ИначеЕсли Падеж = 6 Тогда
			ОкончаниеПадежа = НСтр("ru = 'е'");
		Иначе // Падеж = 2
			ОкончаниеПадежа = НСтр("ru = 'а'");
		КонецЕсли;
		
	Иначе
	 
		СменитьОкончание = Истина;
		Если Падеж = 3 Тогда
			ОкончаниеПадежа = НСтр("ru = 'ю'");
		ИначеЕсли Падеж = 5 Тогда	
			ОкончаниеПадежа = НСтр("ru = 'ем'");
		ИначеЕсли Падеж = 6 Тогда
			ОкончаниеПадежа = НСтр("ru = 'е'");
		Иначе // Падеж = 2
			ОкончаниеПадежа = НСтр("ru = 'я'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если СменитьОкончание Тогда
		ПредставлениеМесяца = Лев(ПредставлениеМесяца, СтрДлина(ПредставлениеМесяца) - 1);
	КонецЕсли;
	
	ПредставлениеМесяца = ПредставлениеМесяца + ОкончаниеПадежа
		+ ?(ДобавлятьГод, Символы.НПП + Формат(Период, "Л=ru; ДФ=гггг"), "");
	
	Возврат ПредставлениеМесяца;
	
КонецФункции

#КонецОбласти