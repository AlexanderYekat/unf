﻿#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура обработчик события ПриСозданииНаСервере.
// Осуществляет первоначальное заполнение реквизитов формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Номенклатура") Тогда
		
		Элементы.СтраницаДляОбщегоСписка.Видимость = Ложь;
		Элементы.ФормаГруппаДействия.Доступность = Истина;
		
		Номенклатура = Параметры.Отбор.Номенклатура;
		
		АвтоЗаголовок = Ложь;
		
		Если НЕ Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас Тогда
			
			Заголовок = НСтр("ru = 'Аналоги используется только для запасов'");
			Элементы.Список.ТолькоПросмотр = Истина;
			
		// Наборы
		ИначеЕсли Номенклатура.ЭтоНабор Тогда
			
			Заголовок = НСтр("ru = 'Аналоги недоступны для наборов'");
			Элементы.Список.ТолькоПросмотр = Истина;
			
		Иначе
			
			Заголовок = НСтр("ru = 'Аналоги номенклатуры: '") + Номенклатура.Наименование;
		
		КонецЕсли;
		
		ОбновитьДанныеСписка();
		
	Иначе
		Элементы.СтраницаДляНоменклатуры.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура СоздатьАналог(Команда)
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		ЭлементыОтбора = Новый Структура("Номенклатура", Номенклатура);
		ПараметрыОткрытия = Новый Структура("ЗначенияЗаполнения", ЭлементыОтбора);
		ОткрытьФорму("РегистрСведений.АналогиНоменклатуры.ФормаЗаписи", ПараметрыОткрытия, ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьАналог(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	
	ЭлементыОтбора = Новый Структура("Номенклатура, Аналог, Приоритет, Комментарий"
	, ТекущиеДанные.НоменклатураОригинал, ТекущиеДанные.АналогОригинал, ТекущиеДанные.Приоритет, ТекущиеДанные.Комментарий);
	
	ПараметрыОткрытия = Новый Структура("ЗначенияЗаполнения", ЭлементыОтбора);
	ОткрытьФорму("РегистрСведений.АналогиНоменклатуры.ФормаЗаписи", ПараметрыОткрытия, ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьАналог(Команда)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	
	КлючЗаписи = ПолучитьКлючЗаписи(ТекущиеДанные.НоменклатураОригинал, ТекущиеДанные.АналогОригинал);
	ОткрытьФорму("РегистрСведений.АналогиНоменклатуры.ФормаЗаписи",Новый Структура("Ключ", КлючЗаписи));
КонецПроцедуры

&НаКлиенте
Процедура УдалитьАналог(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	
	УдалитьЗаписьРегистраСведений(ТекущиеДанные.НоменклатураОригинал, ТекущиеДанные.АналогОригинал);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	
	КлючЗаписи = ПолучитьКлючЗаписи(ТекущиеДанные.НоменклатураОригинал, ТекущиеДанные.АналогОригинал);
	ОткрытьФорму("РегистрСведений.АналогиНоменклатуры.ФормаЗаписи",Новый Структура("Ключ", КлючЗаписи));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьАналога" И Источник = "ФормаЗаписи" Тогда
		
		Если ЗначениеЗаполнено(Номенклатура) Тогда
			Если ТипЗнч(Параметр) = Тип("Структура") Тогда
				
				Если Номенклатура = Параметр.Номенклатура 
					Или Номенклатура = Параметр.Аналог Тогда
					ОбновитьДанныеСписка();
					УстановитьТекущуюСтрокуСписка(Параметр.Номенклатура, Параметр.Аналог);
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте 
Процедура УстановитьТекущуюСтрокуСписка(НоменклатураСтроки, АналогСтроки)
	
	ТекущаяСтрока = Неопределено;
	СчетчикСтроки = 0;
	Пока Истина Цикл
		СчетчикСтроки = СчетчикСтроки + 1;
		ДанныеСтрокиСписка=Элементы.Список.ДанныеСтроки(СчетчикСтроки);
		Если ДанныеСтрокиСписка=Неопределено Тогда
			Прервать;
		КонецЕсли;
		
		Если ДанныеСтрокиСписка.НоменклатураОригинал = НоменклатураСтроки И ДанныеСтрокиСписка.АналогОригинал = АналогСтроки Тогда
			ТекущаяСтрока = СчетчикСтроки;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ТекущаяСтрока = Неопределено Тогда
		Элементы.Список.ТекущаяСтрока = ТекущаяСтрока;
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеСписка()
	
	ПрямыеАналоги = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Номенклатура);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АналогиНоменклатуры.Аналог КАК Номенклатура
	|ИЗ
	|	РегистрСведений.АналогиНоменклатуры КАК АналогиНоменклатуры
	|ГДЕ
	|	АналогиНоменклатуры.Номенклатура = &Ссылка";
	
	ВыборкаПрямыхАналогов = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаПрямыхАналогов.Следующий() Цикл
		ПрямыеАналоги.Добавить(ВыборкаПрямыхАналогов.Номенклатура);
	КонецЦикла;
	
	ИмяПараметра = "Ссылка";
	
	Если Список.Параметры.Элементы.Найти(ИмяПараметра)<>Неопределено Тогда
		Список.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, Номенклатура);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКлючЗаписи(Номенклатура, Аналог)
	
	СтруктураКлючаЗаписи = Новый Структура("Номенклатура, Аналог", Номенклатура, Аналог);
	
	Возврат РегистрыСведений.АналогиНоменклатуры.СоздатьКлючЗаписи(СтруктураКлючаЗаписи);
	
КонецФункции

&НаСервере
Процедура УдалитьЗаписьРегистраСведений(Номенклатура, Аналог)
	
	НаборЗаписей = РегистрыСведений.АналогиНоменклатуры.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Номенклатура.Установить(Номенклатура);
	НаборЗаписей.Отбор.Аналог.Установить(Аналог);
	НаборЗаписей.Записать();
	
	ОбновитьДанныеСписка();
КонецПроцедуры

#КонецОбласти
