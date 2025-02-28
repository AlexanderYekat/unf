﻿&НаСервере
Перем КонтекстЭДОСервер;

&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ДекорацияРетроконверсия.Заголовок = ДокументооборотСКОКлиентСервер.ЗаменитьПФРиФССнаСФР(
		Элементы.ДекорацияРетроконверсия.Заголовок, Истина);
	Элементы.ДекорацияПодтверждение.Заголовок = ДокументооборотСКОКлиентСервер.ЗаменитьПФРиФССнаСФР(
		Элементы.ДекорацияПодтверждение.Заголовок, Истина);
	
	Основание = Параметры.Основание;
	Если НЕ ЗначениеЗаполнено(Основание) Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	// инициализируем контекст ЭДО - модуль обработки
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();

	//инициализируем таблицы файлов сведений
	Вложения = КонтекстЭДОСервер.ПолучитьВложенияНеформализованногоДокумента(Основание);
	Для Каждого Стр Из Вложения Цикл
		НовСтр = ФайлыСведений.Добавить();
		НовСтр.Файл = Стр.ИмяФайла;
	КонецЦикла;
	ПереключательСогласен = 1;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПереключательСогласенПриИзменении(Элемент)
	
	УстановитьФлажки(ПереключательСогласен = 1);
	УправлениеЭУ();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ФайлыСведенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьФайлСведений();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыгрузить(Команда)
	ВыгрузитьВложенияКоманда();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОткрыть(Команда)
	ОткрытьФайлСведений();
КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьФлажкиУВсех(Команда)
	УстановитьФлажки(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьФлажкиУВсех(Команда)
	УстановитьФлажки(Истина);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если _ПроверитьЗаполнение() Тогда
		Закрыть(ПолучитьНастройки());
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	УправлениеЭУ();
	УстановитьФлажки(ПереключательСогласен = 1);
	
КонецПроцедуры
	
&НаКлиенте
Процедура УправлениеЭУ()
	
	ПризнакДоступности = (ПереключательСогласен = 3);
	
	Элементы.УстановитьФлажкиУВсех.Доступность = ПризнакДоступности;
	Элементы.СнятьФлажкиУВсех.Доступность = ПризнакДоступности;
	Элементы.ФайлыСведений.ПодчиненныеЭлементы.ФайлыСведенийПометка.Доступность = ПризнакДоступности;
	
КонецПроцедуры

&НаКлиенте
Функция _ПроверитьЗаполнение()
	
	Если ПереключательСогласен = 0 Тогда
		ПоказатьПредупреждение(, "Выберите один из вариантов подтверждения сведений.");
		Возврат Ложь;
	КонецЕсли;
	
	Если ПереключательСогласен = 3 Тогда
		Сведения = ВыбранныеСведения();
		Если Сведения.Количество() = 0 Тогда
			ПоказатьПредупреждение(, "При частичном подтверждении сведений должен быть выбран хотя бы один из файлов сведений.");
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Функция ПолучитьНастройки()
	
	Возврат Новый Структура("ФайлыСведений, ВариантПодтверждения", ВыбранныеСведения(), ПереключательСогласен);
	
КонецФункции

&НаКлиенте
Функция ВыбранныеСведения()
	
	Если ПереключательСогласен = 1 Тогда
		Сведения = Новый Массив;
		Для Каждого Стр Из ФайлыСведений Цикл
				Сведения.Добавить(Стр.Файл);
		КонецЦикла;
		Возврат Сведения;
	ИначеЕсли ПереключательСогласен = 2 Тогда
		Возврат Новый Массив;
	ИначеЕсли ПереключательСогласен = 3 Тогда
		Сведения = Новый Массив;
		Для Каждого Стр Из ФайлыСведений Цикл
			Если Стр.Пометка Тогда
				Сведения.Добавить(Стр.Файл);
			КонецЕсли;
		КонецЦикла;
		Возврат Сведения;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура УстановитьФлажки(Значение)
	Для Каждого ФайлСведений Из ФайлыСведений Цикл 
		ФайлСведений.Пометка = Значение;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлСведений()
	
	ТекСтрока = Элементы.ФайлыСведений.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		ПоказатьПредупреждение(, "Выберите файл.");
		Возврат;
	КонецЕсли;
	
	// считываем из ИБ и сохраняем во временный файл
	
	Вложение = ПолучитьСтрокуВложенияНаСервере(Основание);
	
	Если Вложение.Свойство("Предупреждение") Тогда 
		ПоказатьПредупреждение(, Вложение.Предупреждение);
		Возврат;
	КонецЕсли;
	
	// определяем тип файла выгрузки
	Если НРег(Вложение.РасширениеФайла) = "txt" ИЛИ КонтекстЭДОКлиент.ЭтоВебКлиент() Тогда
		КонтекстЭДОКлиент.ПоказатьТекстИзСтроки(Вложение.ДанныеФайлаВложения, Вложение.ИмяФайлаВложения);
	Иначе
		КонтекстЭДОКлиент.ПоказатьXMLИзСтроки(Вложение.ДанныеФайлаВложения, Вложение.ИмяФайлаВложения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтрокуВложенияНаСервере(Основание)
	
	Если КонтекстЭДОСервер = Неопределено Тогда 
		// инициализируем контекст ЭДО - модуль обработки
		КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонецЕсли;
	
	ИмяФайлаВложения = Неопределено;
	ДанныеФайлаВложения = Неопределено;
	
	Результат = Новый Структура;
	Если НЕ КонтекстЭДОСервер.ПолучитьВложениеНеформализованногоДокумента(Основание, ИмяФайлаВложения, ДанныеФайлаВложения) Тогда 
		Результат.Вставить("Предупреждение", "Файл сведений не найден.");
		Возврат Результат;
	КонецЕсли;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ДанныеФайлаВложения.Получить().Записать(ИмяВременногоФайла);
	ЧтениеФайла = КонтекстЭДОСервер.НовыйЧтениеТекстаНаСервере(ИмяВременногоФайла);
	ТекстФайлаВложения = ЧтениеФайла.Прочитать();
	
	Результат.Вставить("ИмяФайлаВложения", ИмяФайлаВложения);
	Результат.Вставить("ДанныеФайлаВложения", ТекстФайлаВложения);
	
	Результат.Вставить("РасширениеФайла", КонтекстЭДОСервер.РасширениеФайла(ИмяФайлаВложения));
	
	ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ИмяВременногоФайла);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьВложениеНаСервере(ИмяФайла)
	
	Результат = Новый Структура("ТекстПредупреждения, АдресДанных");
	Если КонтекстЭДОСервер = Неопределено Тогда 
		// инициализируем контекст ЭДО - модуль обработки
		КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонецЕсли;
	
	// получаем вложение
	СтрВложения = КонтекстЭДОСервер.ПолучитьВложения(Основание, ИмяФайла);
	Если СтрВложения.Количество() = 0 Тогда
		Результат.ТекстПредупреждения = "Вложение с именем """ + ИмяФайла + """ не обнаружено.";
		Возврат Результат;
	КонецЕсли;
	
	Вложение = СтрВложения[0];
	
	ГУИД = Новый УникальныйИдентификатор;
	Адрес = ПоместитьВоВременноеХранилище(Вложение.Данные.Получить(), ГУИД);
	Результат.АдресДанных = Адрес;
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьМассивОписанийФайловВложений(МассивИменВложений)
	МассивОписаний = Новый Массив;
	
	Для Каждого ИмяВложения Из МассивИменВложений Цикл 
		Результат = ПолучитьВложениеНаСервере(ИмяВложения);
		Если ЗначениеЗаполнено(Результат.АдресДанных) Тогда 
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ИмяВложения, Результат.АдресДанных); 
			МассивОписаний.Добавить(ОписаниеФайла);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат МассивОписаний;
КонецФункции

&НаКлиенте
Процедура ВыгрузитьВложенияКоманда()
	
	// получаем массив с именами выгружаемых вложений
	МассивИменВложений = ВыбранныеВложения();
	Если МассивИменВложений.Количество() = 0 Тогда
		ПоказатьПредупреждение(, "Выберите файлы сведений.");
		Возврат;
	КонецЕсли;
	
	МассивОписанийПолучаемыеФайлы = ПолучитьМассивОписанийФайловВложений(МассивИменВложений);
	ОперацииСФайламиЭДКОКлиент.СохранитьФайлы(МассивОписанийПолучаемыеФайлы);
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранныеВложения()
	
	Результат = Новый Массив;
	
	Для Каждого Стр Из ФайлыСведений Цикл
		Если Стр.Пометка Тогда
			Результат.Добавить(Стр.Файл);
		КонецЕсли;
	КонецЦикла;
	
	Если Результат.Количество() = 0 Тогда
		ТекСтрока = Элементы.ФайлыСведений.ТекущиеДанные;
		Если ТекСтрока <> Неопределено Тогда
			Результат.Добавить(ТекСтрока.Файл);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
