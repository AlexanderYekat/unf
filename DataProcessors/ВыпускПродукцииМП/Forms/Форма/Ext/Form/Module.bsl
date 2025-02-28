﻿#Область ПроцедурыИФункцииОбщегоНазначения

&НаСервере
Процедура СформироватьНаСервере(ТабДокумент, ДляОтправки = Ложь, НаПечать = Ложь)
	
	ИмяМакета = "Макет";
	Макет = Обработки.ВыпускПродукцииМП.ПолучитьМакет(ИмяМакета);
	ТабДокумент.Очистить();
	
	НачалоОтбора = ?(ЗначениеЗаполнено(НачалоПериода), НачалоДня(НачалоПериода), НачалоПериода);
	КонецОтбора = ?(ЗначениеЗаполнено(КонецПериода), КонецДня(КонецПериода), КонецДня(ТекущаяДата()));
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПроизводствоМП.Ссылка
	|ИЗ
	|	Документ.ПроизводствоМП КАК ПроизводствоМП
	|ГДЕ
	|	ПроизводствоМП.Проведен
	|	И НЕ ПроизводствоМП.ПометкаУдаления
	|	И ПроизводствоМП.Дата >= &НачалоОтбора
	|	И ПроизводствоМП.Дата <= &КонецОтбора";
	
	Запрос.УстановитьПараметр("НачалоОтбора", НачалоОтбора);
	Запрос.УстановитьПараметр("КонецОтбора", КонецОтбора);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Колонки = "ВсеКолонки";
	ВидЗаголовка = "";
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок" + ВидЗаголовка + "|" + Колонки);
	ТабДокумент.Вывести(ОбластьМакета);
	
	СераяСтрока = Ложь;
	Пока Выборка.Следующий() Цикл
		Документ = Выборка.Ссылка;
		Для каждого ТекСтрока Из Документ.Продукция Цикл
			Если СераяСтрока Тогда
				ОбластьМакета = Макет.ПолучитьОбласть("СтрокаСерая" + "|" + Колонки);
			Иначе
				ОбластьМакета = Макет.ПолучитьОбласть("Строка" + "|" + Колонки);
			КонецЕсли;
			ОбластьМакета.Параметры.Дата = Документ.Дата;
			ОбластьМакета.Параметры.Продукция = ТекСтрока.Товар;
			ОбластьМакета.Параметры.Количество = ТекСтрока.Количество;
			ОбластьМакета.Параметры.Сумма = ТекСтрока.Сумма;
			ТабДокумент.Вывести(ОбластьМакета);
			СераяСтрока = НЕ СераяСтрока;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор(ВыбранноеЗначение)
	
	ЭтаФорма.ЭлементОтбора = ВыбранноеЗначение;
	СформироватьНаСервере(Содержимое);
	Элементы.ГруппаФильтр.Видимость = Истина;
	Элементы.ДекорацияФильтр.Заголовок = Строка(ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьОтбор()
	
	ЭтаФорма.ЭлементОтбора = Неопределено;
	СформироватьНаСервере(Содержимое);
	Элементы.ГруппаФильтр.Видимость = Ложь;
	Элементы.ДекорацияФильтр.Заголовок = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОткрытиеЭкранаВGA(ЭтаФорма.ИмяФормы);
	// Конец Сбор статистики

	Если Параметры.Свойство("ЭлементОтбора") Тогда
		УстановитьОтбор(Параметры.ЭлементОтбора);
	КонецЕсли;
	СформироватьНаСервере(Содержимое);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбщегоНазначенияМПКлиент.СформироватьТекстПериодОтчета(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтчетаНажатие(Элемент, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Период", Период);
	СтруктураПараметры.Вставить("НачалоПериода", НачалоПериода);
	СтруктураПараметры.Вставить("КонецПериода", КонецПериода);
	
	ОткрытьФорму("ОбщаяФорма.ВыборПериодаМП", СтруктураПараметры,,,,, Новый ОписаниеОповещения("ПериодОтчетаНажатиеЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтчетаНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	СтруктураДанных = Результат;
	
	ПериодОтчетаНажатиеФрагмент(СтруктураДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтчетаНажатиеФрагмент(Знач СтруктураДанных)
	
	Если СтруктураДанных <> Неопределено 
		И ТипЗнч(СтруктураДанных) = Тип("Структура") Тогда
		НачалоПериода = СтруктураДанных.НачалоПериода;
		КонецПериода = СтруктураДанных.КонецПериода;
		Период = СтруктураДанных.Период;
		ОбщегоНазначенияМПКлиент.СформироватьТекстПериодОтчета(ЭтаФорма);
		СформироватьНаСервере(Содержимое);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ДействияКомандныхПанелейФормы

&НаКлиенте
Процедура ОчиститьПериод(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	НачалоПериода = Неопределено;
	КонецПериода = Неопределено;
	Период = Неопределено;
	ОбщегоНазначенияМПКлиент.СформироватьТекстПериодОтчета(ЭтаФорма);
	СформироватьНаСервере(Содержимое);
	
КонецПроцедуры

&НаКлиенте
Процедура Меню(Команда)

	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	ОчиститьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппироватьПоДате(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	СформироватьНаСервере(Содержимое);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровЭкрана()
	
	Если ОбщегоНазначенияМПВызовСервера.ЭтоСмартфон() Тогда
		ОтключитьОбработчикОжидания("СформироватьПриИзмененииПараметровЭкрана");
		ПодключитьОбработчикОжидания("СформироватьПриИзмененииПараметровЭкрана", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПриИзмененииПараметровЭкрана()
	
	СформироватьНаСервере(Содержимое);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппироватьПоПокупателю(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	СформироватьНаСервере(Содержимое);
	
КонецПроцедуры

&НаКлиенте
Процедура Справка(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВPDF(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	СтруктураВозврата = ЗаписатьВPDF(КаталогДокументов());
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	НачатьЗапускПриложения(Новый ОписаниеОповещения("ПослеЗапускаПриложения", ЭтотОбъект), СтруктураВозврата.ПолноеИмяФайла);
	// АПК:534-вкл

КонецПроцедуры

Процедура ПослеЗапускаПриложения(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	Возврат; // Процедура заглушка, т.к. НачатьЗапускПриложения требуется наличие обработчика оповещения.
КонецПроцедуры

&НаСервере
Функция ЗаписатьВPDF(КаталогДокументов)
	
	ПечатнаяФорма = Новый ТабличныйДокумент;
	СформироватьНаСервере(ПечатнаяФорма, Ложь, Истина);
	
	ИмяФайла = НСтр("ru='Выпуск продукции от ';en='Output of '")
		+ ОбщегоНазначенияМПКлиентСервер.ПолучитьФорматированнуюСтрокуДатыДляФайла(ТекущаяДата()) + ".pdf";
	ПолноеИмяФайла = ОбщегоНазначенияМПКлиентСервер.ПолучитьПолноеИмяФайла(КаталогДокументов, ИмяФайла);     
	ПечатнаяФорма.Записать(ПолноеИмяФайла, ТипФайлаТабличногоДокумента.PDF);             
	
	Возврат Новый Структура("ИмяФайла, ПолноеИмяФайла", ИмяФайла, ПолноеИмяФайла);

КонецФункции

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Закрытие",,,ЗавершениеРаботы);
	// Конец Сбор статистики
	
КонецПроцедуры

#КонецОбласти


