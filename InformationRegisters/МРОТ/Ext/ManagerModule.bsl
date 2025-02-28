﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает значение МРОт на переданную дату
//
Функция МРОТНаДату(Дата = Неопределено) Экспорт
	
	// МРОТ
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МРОТСрезПоследних.Значение
	|ИЗ
	|	РегистрСведений.МРОТ.СрезПоследних(&ДатаСреза, ) КАК МРОТСрезПоследних");
	Запрос.УстановитьПараметр("ДатаСреза", НачалоГода(Дата));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Значение;
	Иначе
		ВызватьИсключение НСтр("ru='Регистр сведений МРОТ не заполнен'");
	КонецЕсли;
	
КонецФункции

// Обновляет данные МРОТ в регистре
//
// Параметры:
//  Идентификатор           - Строка - идентификатор классификатора в сервисе классификаторов.
//                            Определяется в процедуре ПриДобавленииКлассификаторов.
//  Версия                  - Число - номер загруженной версии;
//  Адрес                   - Строка - адрес двоичных данных файла обновления во
//                            временном хранилище;
//  Обработан               - Булево - если Ложь, при обработке файла обновления были ошибки
//                            и его необходимо загрузить повторно;
//  ДополнительныеПараметры - Структура - содержит дополнительные параметры обработки.
//                            Необходимо использовать для передачи значений в переопределяемый
//                            метод РаботаСКлассификаторамиВМоделиСервисаПереопределяемый.ПриОбработкеОбластиДанных
//                            и метод ИнтеграцияПодсистемБИП.ПриОбработкеОбластиДанных..
Процедура ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан, ДополнительныеПараметры) Экспорт
	
	Если Идентификатор <> "MinMonthlyWage" Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ПравоДоступа("Изменение", Метаданные.РегистрыСведений.МРОТ) Тогда
		Возврат;
	КонецЕсли;
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	ТекстXML = НалогиУНФ.ДвоичныеДанныеВСтроку(ДвоичныеДанные, КодировкаТекста.UTF8);
	
	ЗагружаемыеСведения = ОбщегоНазначения.ЗначениеИзСтрокиXML(ТекстXML);
	
	МодульРаботаСКлассификаторами = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаСКлассификаторами") Тогда
		МодульРаботаСКлассификаторами = ОбщегоНазначения.ОбщийМодуль("РаботаСКлассификаторами");
		ТекущаяВерсия = МодульРаботаСКлассификаторами.ВерсияКлассификатора(ЗагружаемыеСведения.Идентификатор, Истина);
		Если ЗагружаемыеСведения.Версия < ТекущаяВерсия Тогда

			// В данную ветку процесс попадает когда пользователь хочет сбросить данные регистра до значений по умолчанию,
			// но версия загруженных данных классификатора выше версии из макета в метаданных.
			// Проверка возможности загрузки обновления из веб-сервиса.
			СведенияИзВебСервиса = НалогиУНФ.ПолучитьДанныеКлассификатораИзСервиса(ЗагружаемыеСведения.Идентификатор);
			Если СведенияИзВебСервиса = Неопределено
				Или СведенияИзВебСервиса.Версия < ТекущаяВерсия
				Или ВРег(СведенияИзВебСервиса.ПолноеИмя) <> ВРег(ЗагружаемыеСведения.ПолноеИмя) Тогда
				Возврат; // Пользователь загружал обновление из файла.
			КонецЕсли;
			// Загрузка обновления из веб-сервиса.
			ЗагружаемыеСведения = СведенияИзВебСервиса;
		КонецЕсли;
	КонецЕсли;
	
	// Поиск ссылок.
	ТаблицаЗагрузки = ЗагружаемыеСведения.Данные;
	
	НаборЗаписей = РегистрыСведений.МРОТ.СоздатьНаборЗаписей();
	
	Для Каждого СтрокаТаблицыЗагрузки Из ТаблицаЗагрузки Цикл
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Активность = Истина;
		НоваяЗапись.Период = СтрокаТаблицыЗагрузки.Период;
		НоваяЗапись.Значение = СтрокаТаблицыЗагрузки.Размер;
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
	Если МодульРаботаСКлассификаторами <> Неопределено Тогда
		МодульРаботаСКлассификаторами.УстановитьВерсиюКлассификатора(ЗагружаемыеСведения.Идентификатор, ЗагружаемыеСведения.Версия);
	КонецЕсли;
	
	Обработан = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли