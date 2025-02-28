﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.ОбъектыПечати) <> Тип("Массив") ИЛИ Параметры.ОбъектыПечати.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДействиеСФайлом = "СохранитьЛокально";
	ОбъектПечати = Параметры.ОбъектыПечати[0];
	
	ДанныеФайла = ШаблоныПечатиОфисныхДокументов.СФормироватьДокумент(ОбъектПечати, Параметры.ШаблонПечати, УникальныйИдентификатор);
	
	Если ДанныеФайла = Неопределено Тогда
		СообщенияПользователю = ПолучитьСообщенияПользователю(Ложь);
		Отказ = Истина;
		Возврат;
	Иначе
		СообщенияПользователю = ПолучитьСообщенияПользователю(Истина);
	КонецЕсли;
	
	ИмяФайла = ДанныеФайла.ИмяФайла;
	
	Элементы.ФорматФайлаDOCX.Видимость = (ДанныеФайла.Расширение = "docx");
	Элементы.ФорматФайлаODT.Видимость = (ДанныеФайла.Расширение = "odt");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СохранитьФайл(Команда)
	
	ВыполнитьСохранениеФайла();
	
	Если СообщенияПользователю <> Неопределено И СообщенияПользователю.Количество() > 0 Тогда
		Для каждого СообщениеПользователю Из СообщенияПользователю Цикл
			ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеПользователю.Текст,
				СообщениеПользователю.КлючДанных, СообщениеПользователю.Поле, СообщениеПользователю.ПутьКДанным);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьСохранениеФайла()
	
	Если ДействиеСФайлом = "СохранитьЛокально" Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершитьСохранениеФайла", ЭтотОбъект);
		ПараметрыСохраненияФайла = ПараметрыСохраненияФайла(ДанныеФайла.Расширение);
		ФайловаяСистемаКлиент.СохранитьФайл(ОписаниеОповещения, ДанныеФайла.СсылкаНаДвоичныеДанныеФайла,
			ДанныеФайла.ИмяФайла, ПараметрыСохраненияФайла);
		
	ИначеЕсли ДействиеСФайлом = "СохранитьВПрисоединенныеФайлы" Тогда
		
		ПрисоединенныйФайл = ПрикрепитьГотовыйФайлКОбъектуПечати();
		
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("Файл", ПрисоединенныйФайл);
		ПараметрыОповещения.Вставить("ЭтоНовый", Истина);
		Оповестить("Запись_Файл", ПараметрыОповещения, ПрисоединенныйФайл);
		
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьСохранениеФайла(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПолученныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолученныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПолноеИмяФайла = ПолученныеФайлы[0].ПолноеИмя;
	
	Если НЕ ЗначениеЗаполнено(ПолноеИмяФайла) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбработкаНажатияНаОповещение",
		ЭтотОбъект,
		Новый Структура("ПолноеИмяФайла", ПолноеИмяФайла));
	
	ПоказатьОповещениеПользователя(
		НСтр("ru='Сохранение файла'"),
		ОписаниеОповещения,
		НСтр("ru='Открыть каталог'"));
		
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНажатияНаОповещение(ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПолноеИмяФайла = Неопределено;
	ДополнительныеПараметры.Свойство("ПолноеИмяФайла", ПолноеИмяФайла);
	
	Если НЕ ЗначениеЗаполнено(ПолноеИмяФайла) Тогда
		Возврат;
	КонецЕсли;
	
	ФайловаяСистемаКлиент.ОткрытьПроводник(ПолноеИмяФайла);
	
КонецПроцедуры

&НаСервере
Функция ПрикрепитьГотовыйФайлКОбъектуПечати()
	
	ПараметрыФайла = Новый Структура("Автор, ВладелецФайлов, ИмяБезРасширения, РасширениеБезТочки, ВремяИзмененияУниверсальное");
	ПараметрыФайла.Автор = Пользователи.ТекущийПользователь();
	ПараметрыФайла.ВладелецФайлов = ОбъектПечати;
	ПараметрыФайла.ИмяБезРасширения = ДанныеФайла.Наименование;
	ПараметрыФайла.РасширениеБезТочки = ДанныеФайла.Расширение;
	ПараметрыФайла.ВремяИзмененияУниверсальное = ДанныеФайла.ДатаМодификацииУниверсальная;
	
	ПрисоединенныйФайл = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
	
	ДополнительныеПараметры = РаботаСФайламиКлиентСервер.ПараметрыДанныхФайла();
	ДополнительныеПараметры.ИдентификаторФормы = УникальныйИдентификатор;
	ДополнительныеПараметры.ПолучатьСсылкуНаДвоичныеДанные = Истина;
	
	ДанныеФайла = РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайл, ДополнительныеПараметры);
	
	Возврат ПрисоединенныйФайл;
	
КонецФункции

&НаКлиенте
Функция ПараметрыСохраненияФайла(РасширениеФайла)
	
	Если РасширениеФайла = "docx" Тогда
		ТекстФильтра = НСтр("ru='Документ Word|*.docx;'");
	ИначеЕсли РасширениеФайла = "odt" Тогда
		ТекстФильтра = НСтр("ru='Текстовый документ ODF (.odt)|*.odt;'");
	Иначе
		ТекстФильтра = "";
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстФильтра) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыСохраненияФайла = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохраненияФайла.Диалог.Расширение = РасширениеФайла;
	ПараметрыСохраненияФайла.Диалог.Фильтр = ТекстФильтра;
	Возврат ПараметрыСохраненияФайла;
	
КонецФункции

#КонецОбласти
