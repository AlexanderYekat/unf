﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИдентификаторОбъекта = Параметры.ИдентификаторОбъекта;
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОжидание;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ПолучитьДанныеПоОбъекту", 1, Истина);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПечатьСчетНаОплату(Команда)
	
	ИдентификаторПечатнойФормы = "ПечатнаяФорма";
	НазваниеПечатнойФормы = НСтр("ru = 'Счет на оплату'");
	
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(ИдентификаторПечатнойФормы);
	ПечатнаяФорма = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, ИдентификаторПечатнойФормы);
	ПечатнаяФорма.СинонимМакета = НазваниеПечатнойФормы;
	ПечатнаяФорма.ТабличныйДокумент = ТабличныйДокументПечатнойФормыПолученногоСчета();
	ПечатнаяФорма.ИмяФайлаПечатнойФормы = НазваниеПечатнойФормы;
	
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеФормой()
	
	Если ПовторитьЗапрос Тогда
		Заголовок = НСтр("ru = 'Пожалуйста, подождите...'");
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОжидание;
	ИначеЕсли ЗначениеЗаполнено(Предупреждение) Тогда
		Заголовок = НСтр("ru = 'Ошибка'");
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОшибка;
	Иначе
		Если ЗначениеЗаполнено(СуммаОплаты) Тогда
			Заголовок = СтрШаблон(НСтр("ru = 'Оплатите %1 %2'"), СуммаОплаты, ВалютаОплатыПредставление);
		Иначе
			Заголовок = НСтр("ru='Оплата сервиса'");
		КонецЕсли;
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультат;
	КонецЕсли;
	Элементы.ПечатьСчетНаОплату.Видимость = ЕстьФайлПечатнаяФормаСчета;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеПоОбъекту()
	
	ПовторитьЗапрос = ПолучитьДанныеПоОбъектуНаСервере();
	Если ПовторитьЗапрос Тогда
		ПодключитьОбработчикОжидания("ПолучитьДанныеПоОбъекту", 1, Истина);
	КонецЕсли;
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеПоОбъектуНаСервере()
	
	ПолученоОповещение = УниверсальнаяИнтеграция.ПолученоОповещениеОбИзмененииОбъекта("bill", Строка(ИдентификаторОбъекта));
	Если Не ПолученоОповещение Тогда
		Возврат Истина;
	КонецЕсли;
	
	СвойстваОтвета = Неопределено;
	Данные = ПрограммныйИнтерфейсСервиса.ДанныеСчетаНаОплату(ИдентификаторОбъекта, , Ложь, СвойстваОтвета);
	
	Комментарий = СтрШаблон(НСтр("ru='Данные.Состояние.Имя = ""%1""'"), Данные.Состояние.Имя);
	ЗаписьЖурналаРегистрации(ОплатаСервисаУНФ.ИмяСобытияЖР(), УровеньЖурналаРегистрации.Информация,,, Комментарий);
	
	Если ЗначениеЗаполнено(СвойстваОтвета.Сообщение) Тогда
		Предупреждение = СвойстваОтвета.Сообщение;
	ИначеЕсли Данные.Состояние.Ошибка Тогда
		Предупреждение = Данные.Состояние.Описание;
	ИначеЕсли Данные.Состояние.Имя = "wait_payment" И Данные.Файлы.Количество() > 0 Тогда
		Результат = ОбработатьПолученныеДанныеСчета(Данные);
		Если Результат.Ошибка Тогда
			Предупреждение = Результат.Сообщение;
		КонецЕсли;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Предупреждение) Тогда
		ЗаписьЖурналаРегистрации(ОплатаСервисаУНФ.ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,, Предупреждение);
	КонецЕсли;
	
	УниверсальнаяИнтеграция.ОтписатьсяОтОповещенияОбИзмененииОбъекта("bill", Строка(ИдентификаторОбъекта));
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьФайлыПоДаннымХранилища(ДанныеХранилища, РезультатОбработки)
	
	Файлы.Очистить();
	Для Каждого Файл Из ДанныеХранилища.Файлы Цикл
		УстановитьПривилегированныйРежим(Истина);
		ИмяФайла = РаботаВМоделиСервиса.ПолучитьФайлИзХранилищаМенеджераСервиса(Файл.Идентификатор);
		УстановитьПривилегированныйРежим(Ложь);
		ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяФайла);
		АдресФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла, УникальныйИдентификатор);
		Попытка
			УдалитьФайлы(ИмяФайла);
		Исключение
			Комментарий = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ОплатаСервисаУНФ.ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,, Комментарий);
		КонецПопытки;
		СтрокаФайла = Файлы.Добавить();
		СтрокаФайла.Адрес = АдресФайла;
		СтрокаФайла.Имя = Файл.Описание;
	КонецЦикла;
	
	ПроверитьНаличиеОжидаемыхФайлов(РезультатОбработки);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНаличиеОжидаемыхФайлов(РезультатОбработки)
	
	ЕстьФайлПечатнаяФормаСчета = Ложь;
	ЕстьФайлДанныеСчета = Ложь;
	
	ВсеПолученныеФайлы = Новый Массив;
	
	Для каждого Файл Из Файлы Цикл
		Если Файл.Имя = ИмяФайлаПечатнаяФормаСчета() Тогда
			ЕстьФайлПечатнаяФормаСчета = Истина;
		КонецЕсли;
		Если Файл.Имя = ИмяФайлаДанныеСчета() Тогда
			ЕстьФайлДанныеСчета = Истина;
		КонецЕсли;
		
		ВсеПолученныеФайлы.Добавить(Файл.Имя);
	КонецЦикла;
	ВсеПолученныеФайлыСтрокой = СтрСоединить(ВсеПолученныеФайлы, ", ");
	
	Если Не ЕстьФайлДанныеСчета И Не ЕстьФайлПечатнаяФормаСчета Тогда
		РезультатОбработки.Ошибка = Истина;
		РезультатОбработки.Сообщение = НСтр("ru='Не удалось получить данные обмена электронными счетами на оплату.
		|
		|Свяжитесь с обслуживающей организацией.'");
		
		Комментарий = СтрШаблон(НСтр("ru='Не все ожидаемые файлы получены. Список полученных файлов: %1'"), ВсеПолученныеФайлыСтрокой);
		ЗаписьЖурналаРегистрации(ОплатаСервисаУНФ.ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,, Комментарий);
		Возврат;
	КонецЕсли;
	
	Если Не ЕстьФайлДанныеСчета Или Не ЕстьФайлПечатнаяФормаСчета Тогда
		Комментарий = СтрШаблон(НСтр("ru='Не все ожидаемые файлы получены. Список полученных файлов: %1'"), ВсеПолученныеФайлыСтрокой);
		ЗаписьЖурналаРегистрации(ОплатаСервисаУНФ.ИмяСобытияЖР(), УровеньЖурналаРегистрации.Предупреждение,,, Комментарий);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработатьПолученныеДанныеСчета(Данные)
	
	РезультатОбработки = Новый Структура;
	РезультатОбработки.Вставить("Ошибка", Ложь);
	РезультатОбработки.Вставить("Сообщение", "");
	
	ЗаполнитьФайлыПоДаннымХранилища(Данные, РезультатОбработки);
	
	Если РезультатОбработки.Ошибка Тогда
		Возврат РезультатОбработки;
	КонецЕсли;
	
	ДанныеСчета = АдресДанныхСчетаНаОплату();
	Если ДанныеСчета = Неопределено Тогда
		Возврат РезультатОбработки;
	КонецЕсли;
	
	СчетНаОплатуПоставщика = ОплатаСервисаУНФ.СоздатьСчетНаОплатуПоставщика(ДанныеСчета, РезультатОбработки);
	ПрочитатьДанныеСчетаНаОплатуПоставщика();
	ДобавитьПечатнуюФормуСчетаНаОплатуВПрисоединенныеФайлы();
	
	Возврат РезультатОбработки;
	
КонецФункции

&НаСервере
Процедура ПрочитатьДанныеСчетаНаОплатуПоставщика()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СчетНаОплатуПоставщика.СуммаДокумента КАК СуммаДокумента,
	|	СчетНаОплатуПоставщика.ВалютаДокумента.Представление КАК ВалютаДокументаПредставление,
	|	СчетНаОплатуПоставщика.ВалютаДокумента.СимвольноеПредставление КАК ВалютаДокументаСимвольноеПредставление
	|ИЗ
	|	Документ.СчетНаОплатуПоставщика КАК СчетНаОплатуПоставщика
	|ГДЕ
	|	СчетНаОплатуПоставщика.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", СчетНаОплатуПоставщика);
	ДанныеСчетаНаОплатуПоставщика = Запрос.Выполнить().Выбрать();
	Если Не ДанныеСчетаНаОплатуПоставщика.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	СуммаОплаты = ДанныеСчетаНаОплатуПоставщика.СуммаДокумента;
	Если ЗначениеЗаполнено(ДанныеСчетаНаОплатуПоставщика.ВалютаДокументаСимвольноеПредставление) Тогда
		ВалютаОплатыПредставление = ДанныеСчетаНаОплатуПоставщика.ВалютаДокументаСимвольноеПредставление;
	Иначе
		ВалютаОплатыПредставление = ДанныеСчетаНаОплатуПоставщика.ВалютаДокументаПредставление;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПечатнуюФормуСчетаНаОплатуВПрисоединенныеФайлы()
	
	Если Не ЗначениеЗаполнено(СчетНаОплатуПоставщика) Или Не ЕстьФайлПечатнаяФормаСчета Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		ПараметрыФайла = Новый Структура;
		ПараметрыФайла.Вставить("Автор", Пользователи.АвторизованныйПользователь());
		ПараметрыФайла.Вставить("ВладелецФайлов", СчетНаОплатуПоставщика);
		ПараметрыФайла.Вставить("ИмяБезРасширения", НСтр("ru='Счет на оплату'"));
		ПараметрыФайла.Вставить("РасширениеБезТочки", "mxl");
		ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", ТекущаяДатаСеанса());
		ПрисоединенныйФайл = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресПечатнойФормыПолученногоСчета());
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ОплатаСервисаУНФ.ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция АдресДанныхСчетаНаОплату()
	
	АдресДанных = Неопределено;
	Для каждого Файл Из Файлы Цикл
		Если Файл.Имя = ИмяФайлаДанныеСчета() Тогда
			АдресДанных = Файл.Адрес;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат АдресДанных;
	
КонецФункции

&НаСервере
Функция АдресПечатнойФормыПолученногоСчета()
	
	АдресДанных = Неопределено;
	Для каждого Файл Из Файлы Цикл
		Если Файл.Имя = ИмяФайлаПечатнаяФормаСчета() Тогда
			АдресДанных = Файл.Адрес;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат АдресДанных;
	
КонецФункции

&НаСервере
Функция ТабличныйДокументПечатнойФормыПолученногоСчета()
	
	ПечатнаяФормаАдрес = АдресПечатнойФормыПолученногоСчета();
	ПечатнаяФорма = ПолучитьИзВременногоХранилища(ПечатнаяФормаАдрес);
	Поток = ПечатнаяФорма.ОткрытьПотокДляЧтения();
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Прочитать(Поток);
	Поток.Закрыть();
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяФайлаПечатнаяФормаСчета()
	
	Возврат "bill.mxl";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяФайлаДанныеСчета()
	
	Возврат "bill.zip";
	
КонецФункции

#КонецОбласти
