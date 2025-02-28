﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция - Шаблон процедуры подключаемого вида цен
//
// Параметры:
//  ИдентификаторВидаЦен - Строка - реквизит ИдентификаторДляРасчетаВРасширении справочника вида цен
// 
// Возвращаемое значение:
//  Строка - многострочная строка для формы помощника добавления расширения
//
Функция ШаблонПроцедурыПодключаемогоВидаЦен(ИдентификаторВидаЦен) Экспорт
	
	// АПК:1299-выкл проектное решение
	ШаблонПроцедуры = 
		НСтр("ru = '
		|// Процедура заполняет цены в переданной таблице. Не рекомендуется менять состав таблицы.
		|// Не рекомендуется менять значение полей кроме Цена и ЦенаСтарая
		|//
		|// Параметры:
		|//  ТаблицаРезультата				 - ТаблицаЗначений	 - таблица для расчета результата
		|//   * Номенклатура				 - СправочникСсылка.Номенклатура - номенклатура расчета
		|//   * Характеристика				 - СправочникСсылка.ХарактеристикиНоменклатуры - характеристика расчета
		|//   * ХарактеристикаНедействителен - Булево - признак недействительной характеристики, служебное поле, изменять не рекомендуется
		|//   * ВидЦены						 - СправочникСсылка.ВидыЦен - рассчитываемый вид цены
		|//   * ВалютаЦены					 - СправочникСсылка.Валюта - валюта цены
		|//   * ЕдиницаИзмерения			 - СправочникСсылка.КлассификаторЕдиницИзмерения, СправочникСсылка.ЕдиницыИзмерения - единица измерения номенклатуры
		|//   * КлючСвязи					 - Число - служебное поле, изменять не рекомендуется
		|//   * Цена						 - Число - результат расчета цены
		|//   * ЦенаСтарая					 - Число - предыдущая цена
		|//
		|Процедура РассчитатьЦены_%1(ТаблицаРезультата) Экспорт
		|	// Вставить содержимое процедуры.
		|КонецПроцедуры'");
	// АПК:1299-вкл
	
	АдаптированныйИдентификатор = СтрЗаменить(ИдентификаторВидаЦен, "-", "_");
	ШаблонПроцедуры = СтрШаблон(ШаблонПроцедуры, АдаптированныйИдентификатор);
	
	Возврат ШаблонПроцедуры;
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

// Процедура получает основной вид цен продажи из пользовательский настроек.
//
Функция ПолучитьОсновнойВидЦенПродажи() Экспорт

	ВидЦенПродажи = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.АвторизованныйПользователь(), "ОсновнойВидЦенПродажи"); 
	
	Если НЕ ЗначениеЗаполнено(ВидЦенПродажи) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		               |	ВидыЦен.Ссылка КАК Ссылка
		               |ИЗ
		               |	Справочник.ВидыЦен КАК ВидыЦен
		               |ГДЕ
		               |	НЕ ВидыЦен.ПометкаУдаления
		               |	И НЕ ВидыЦен.Недействителен";
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			ВидЦенПродажи = ПустаяСсылка();
		Иначе
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			ВидЦенПродажи = Выборка.Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ВидЦенПродажи;

	
КонецФункции// ЗаполнитьВидЦен()

// Функция - Получить сортированную таблицу видов цен
// 
// Возвращаемое значение:
//  ТаблицаЗначений:
//		* ИдентификаторФормул - Строка - идентификатор формул для вида цены
//		* ВидЦены - СправочникСсылка.ВидыЦен - ссылка на вид цены
//		* ИндексКартинки - Число - индекс картинки для поля списка
//		* ПорядокСортировки - Число - поле сортировки
//
Функция ПолучитьСортированнуюТаблицуВидовЦен() Экспорт
	
	МаксимальныйПорядок = ПолучитьМаксимальныйПорядокКолонок();
	
	Если МаксимальныйПорядок = 0 Тогда
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ДеревоРезультата", Новый ДеревоЗначений);
		СтруктураПараметров.Вставить("МассивВидовЦен", Новый Массив);
		СтруктураПараметров.Вставить("ВключаяЦеныНоменклатуры", Истина);
		СтруктураПараметров.Вставить("ВключаяЦеныКонтрагентов", Ложь);
		СтруктураПараметров.Вставить("ВидыЦенВыбраныПриЗаполнении", Новый Массив);
		СтруктураПараметров.Вставить("УникальныйИдентификаторФормы", Неопределено);
		
		Документы.УстановкаЦенНоменклатуры.ПолучитьДеревоВидовЦен(СтруктураПараметров);
		СоответствиеВидовЦен = Новый Соответствие;
		Для каждого ГруппаВидовЦен Из СтруктураПараметров.ДеревоРезультата.Строки Цикл
			
			ЗаполнитьСоответствиеВидовЦен(СоответствиеВидовЦен, ГруппаВидовЦен);
			
		КонецЦикла;
		
		Результат = Новый Массив;
		СортироватьСоответствиеВидовЦенПоУмолчанию(СоответствиеВидовЦен, Результат);
		
		Таблица = Новый ТаблицаЗначений;
		Таблица.Колонки.Добавить("ВидЦены");
		Таблица.Колонки.Добавить("ТипВидаЦен");
		Таблица.Колонки.Добавить("ПорядокКолонок");
		Таблица.Колонки.Добавить("ИдентификаторФормул");
		Таблица.Колонки.Добавить("ИндексКартинки");
		
		Для каждого ВидЦены Из Результат Цикл
			
			НоваяЗапись = Таблица.Добавить();
			НоваяЗапись.ВидЦены = ВидЦены;
			НоваяЗапись.ТипВидаЦен = ВидЦены.ТипВидаЦен;
			НоваяЗапись.ПорядокКолонок = ВидЦены.ПорядокКолонок;
			НоваяЗапись.ИдентификаторФормул = ВидЦены.ИдентификаторФормул;
			НоваяЗапись.ИндексКартинки = ПолучитьИндексКартинки(ВидЦены);
			
		КонецЦикла;
		
		Возврат Таблица;
		
	Иначе
		
		Возврат ПолучитьСортированнуюТаблицуВидовЦенПоПорядкуКолонок();
		
	КонецЕсли;
	
КонецФункции

// Функция - Получить максимальный порядок колонок
// 
// Возвращаемое значение:
//  Число - максимальной порядок колонок
//
Функция ПолучитьМаксимальныйПорядокКолонок() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	МАКСИМУМ(ВидыЦен.ПорядокКолонок) КАК ПорядокКолонок
	               |ИЗ
	               |	Справочник.ВидыЦен КАК ВидыЦен";
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ПорядокКолонок;
	КонецЕсли;
	
КонецФункции

// Процедура - Сортировать соответствие видов цен по умолчанию
//
// Параметры:
//  СоответствиеВидовЦен - Соответствие - коллекция видов цен
//  Результат			 - Массив - массив результата
//
Процедура СортироватьСоответствиеВидовЦенПоУмолчанию(СоответствиеВидовЦен, Результат) Экспорт
	
	СписокЗначений = Новый СписокЗначений;
	Для каждого ВидЦены Из СоответствиеВидовЦен Цикл
		
		СписокЗначений.Добавить(ВидЦены.Ключ, ВидЦены.Ключ.Наименование);
		
	КонецЦикла;
	
	СписокЗначений.СортироватьПоПредставлению(НаправлениеСортировки.Возр);
	
	Для каждого ЭлементСписка Из СписокЗначений Цикл
	
		ТекущийЭлементСоответствия = СоответствиеВидовЦен.Получить(ЭлементСписка.Значение);
		Результат.Добавить(ЭлементСписка.Значение);
		СортироватьСоответствиеВидовЦенПоУмолчанию(ТекущийЭлементСоответствия, Результат);
		
	КонецЦикла;
	
КонецПроцедуры

// Пересчитать цены в валюту.
// 
// Параметры:
//  СтруктураПараметров - Структура - структура параметров
// 
// Возвращаемое значение:
//  Булево - Пересчитать цены в валюту
Функция ПересчитатьЦеныВВалюту(СтруктураПараметров) Экспорт

	НачатьТранзакцию();
	Попытка

		ВидЦен = СтруктураПараметров.ВидЦен;
		ВалютаРезультат = СтруктураПараметров.ВалютаРезультат;
		
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.ЦеныНоменклатуры");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("ВидЦен", ВидЦен);
		БлокировкаДанных.Заблокировать();

		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
					   |	ЦеныНоменклатуры.Период,
					   |	ЦеныНоменклатуры.ВидЦен,
					   |	ЦеныНоменклатуры.Номенклатура,
					   |	ЦеныНоменклатуры.Характеристика,
					   |	ЦеныНоменклатуры.Цена,
					   |	ЦеныНоменклатуры.ВалютаЦены
					   |ИЗ
					   |	РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
					   |ГДЕ
					   |	ЦеныНоменклатуры.ВидЦен = &ВидЦен
					   |	И ЦеныНоменклатуры.ВалютаЦены <> &ВалютаРезультат
					   |	И ЦеныНоменклатуры.ВалютаЦены <> ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)";
		Запрос.УстановитьПараметр("ВидЦен", ВидЦен);
		Запрос.УстановитьПараметр("ВалютаРезультат", ВалютаРезультат);

		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда

			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				Набор = РегистрыСведений.ЦеныНоменклатуры.СоздатьНаборЗаписей();
				Набор.Отбор.ВидЦен.Установить(Выборка.ВидЦен);
				Набор.Отбор.Период.Установить(Выборка.Период);
				Набор.Отбор.Номенклатура.Установить(Выборка.Номенклатура);
				Набор.Отбор.Характеристика.Установить(Выборка.Характеристика);
				Набор.Прочитать();
				
				Если Набор.Количество() > 0 Тогда
					
					Набор.ОбменДанными.Загрузка = Истина;
					Запись = Набор[0];
					ЗаполнитьЗначенияСвойств(Запись, Выборка);
					Запись.Цена = РаботаСКурсамиВалют.ПересчитатьВВалюту(Запись.Цена, Выборка.ВалютаЦены,
						ВалютаРезультат, Выборка.Период);
					Запись.ВалютаЦены = ВалютаРезультат;
					Набор.Записать(Истина);
					
				КонецЕсли;

			КонецЦикла;

		КонецЕсли;

		ЗафиксироватьТранзакцию();

	Исключение

		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка пересчета валютных цен'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;

	КонецПопытки;

	Возврат Истина;
	
КонецФункции

// Удалить цены в валюте.
// 
// Параметры:
//  СтруктураПараметров - Структура - структура параметров
// 
// Возвращаемое значение:
//  Булево - Удалить цены в валюте
Функция УдалитьЦеныВВалюте(СтруктураПараметров) Экспорт

	НачатьТранзакцию();
	Попытка

		ВидЦен = СтруктураПараметров.ВидЦен;
		ВалютаЦены = СтруктураПараметров.ВалютаЦены;
		
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.ЦеныНоменклатуры");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("ВидЦен", ВидЦен);
		БлокировкаДанных.Заблокировать();

		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
					   |	ЦеныНоменклатуры.Период,
					   |	ЦеныНоменклатуры.ВидЦен,
					   |	ЦеныНоменклатуры.Номенклатура,
					   |	ЦеныНоменклатуры.Характеристика,
					   |	ЦеныНоменклатуры.Цена,
					   |	ЦеныНоменклатуры.ВалютаЦены
					   |ИЗ
					   |	РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
					   |ГДЕ
					   |	ЦеныНоменклатуры.ВидЦен = &ВидЦен
					   |	И ЦеныНоменклатуры.ВалютаЦены <> &ВалютаЦены
					   |	И ЦеныНоменклатуры.ВалютаЦены <> ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)";
		Запрос.УстановитьПараметр("ВидЦен", ВидЦен);
		Запрос.УстановитьПараметр("ВалютаЦены", ВалютаЦены);

		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда

			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				Набор = РегистрыСведений.ЦеныНоменклатуры.СоздатьНаборЗаписей();
				Набор.Отбор.ВидЦен.Установить(Выборка.ВидЦен);
				Набор.Отбор.Период.Установить(Выборка.Период);
				Набор.Отбор.Номенклатура.Установить(Выборка.Номенклатура);
				Набор.Отбор.Характеристика.Установить(Выборка.Характеристика);
				Набор.Прочитать();
				
				Если Набор.Количество() > 0 Тогда
					
					Набор.Очистить();				
					Набор.Записать(Истина);
					
				КонецЕсли;

			КонецЦикла;

		КонецЕсли;

		ЗафиксироватьТранзакцию();

	Исключение

		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка удаления валютных цен'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;

	КонецПопытки;

	Возврат Истина;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Ссылка)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#Область ОбновлениеВерсииИБ

// Определяет настройки начального заполнения элементов.
//
// Параметры:
//  Настройки - Структура - настройки заполнения
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт

	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;

КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Оптовая";
	Элемент.Наименование = НСтр("ru='Розничная цена'");
	Элемент.ИдентификаторФормул = НСтр("ru ='Розничная'");
	Элемент.ВалютаЦены = Справочники.Валюты.ОсновнаяВалютаНачальногоЗаполнения();
	Элемент.ЦеныАктуальны = Истина;
	Элемент.ЦенаВключаетНДС = Истина;
	Элемент.ПорядокОкругления = Перечисления.ПорядкиОкругления.Окр1;
	Элемент.ОкруглятьВБольшуюСторону = Ложь;
	Элемент.ФорматЦены = "ЧЦ=15; ЧДЦ=2";
	Элемент.ТипВидаЦен = Перечисления.ТипыВидовЦен.Статический;
	ЦенообразованиеФормулыСервер.СформироватьНовыйИдентификаторВидаЦен(Элемент.ИдентификаторФормул, Элемент.Наименование);
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Учетная";
	Элемент.Наименование = НСтр("ru='Учетная цена'");
	Элемент.ИдентификаторФормул = НСтр("ru ='Учетная'");
	Элемент.ВалютаЦены = Справочники.Валюты.ОсновнаяВалютаНачальногоЗаполнения();
	Элемент.ЦеныАктуальны = Истина;
	Элемент.ЦенаВключаетНДС = Истина;
	Элемент.ПорядокОкругления = Перечисления.ПорядкиОкругления.Окр1;
	Элемент.ОкруглятьВБольшуюСторону = Ложь;
	Элемент.ФорматЦены = "ЧЦ=15; ЧДЦ=2";
	Элемент.ТипВидаЦен = Перечисления.ТипыВидовЦен.Статический;
	ЦенообразованиеФормулыСервер.СформироватьНовыйИдентификаторВидаЦен(Элемент.ИдентификаторФормул, Элемент.Наименование);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ИнициализироватьДанные(Ссылка, ДополнительныеСвойства, ЭтотОбъект) Экспорт
	Перем СвязиВидовЦен, ОчередьРасчетаЦен, ПропуститьРегистрациюОчередиЦен;
	
	ПодготовитьТаблицуРегистраЗависимыеВидыЦен(СвязиВидовЦен, ЭтотОбъект);
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("СвязиВидовЦенСлужебный", СвязиВидовЦен);
	
	ДополнительныеСвойства.Свойство("ПропуститьРегистрациюОчередиЦен", ПропуститьРегистрациюОчередиЦен);
	Если НЕ ПропуститьРегистрациюОчередиЦен = Истина Тогда
		
		ПодготовитьТаблицуРегистраОчередьРасчетаЦен(ОчередьРасчетаЦен, СвязиВидовЦен, ЭтотОбъект);
		ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ОчередьРасчетаЦен", ОчередьРасчетаЦен);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ИспользуютсяЦеновыеГруппыВДинамическихВидахЦен() Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	                      |	ВидыЦенЦеновыеГруппы.ЦеноваяГруппа КАК ЦеноваяГруппа
	                      |ИЗ
	                      |	Справочник.ВидыЦен.ЦеновыеГруппы КАК ВидыЦенЦеновыеГруппы");
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

Процедура ПроверитьДублированиеЦеновыхГрупп(Ошибки, ТаблицаСтрок) Экспорт
	
	Если ТаблицаСтрок.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТаблицаЦеновыхГрупп = Новый ТаблицаЗначений;
	ТаблицаЦеновыхГрупп.Колонки.Добавить("НомерСтроки",		Новый ОписаниеТипов("Число"));
	ТаблицаЦеновыхГрупп.Колонки.Добавить("ЦеноваяГруппа",	Новый ОписаниеТипов("СправочникСсылка.ЦеновыеГруппы"));
	
	Для Каждого СтрокаТЧ Из ТаблицаСтрок Цикл
		
		ЗаполнитьЗначенияСвойств(ТаблицаЦеновыхГрупп.Добавить(), СтрокаТЧ);
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаЦеновыхГрупп", ТаблицаЦеновыхГрупп);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВременнаяТаблицаЦеновыеГруппы.НомерСтроки КАК НомерСтроки,
	|	ВременнаяТаблицаЦеновыеГруппы.ЦеноваяГруппа КАК ЦеноваяГруппа
	|ПОМЕСТИТЬ ВременнаяТаблицаЦеновыеГруппы
	|ИЗ
	|	&ТаблицаЦеновыхГрупп КАК ВременнаяТаблицаЦеновыеГруппы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВременнаяТаблицаЦеновыеГруппы.НомерСтроки) КАК НомерСтрокиМаксимум,
	|	МИНИМУМ(ВременнаяТаблицаЦеновыеГруппы.НомерСтроки) КАК НомерСтрокиМинимум,
	|	ВременнаяТаблицаЦеновыеГруппы.ЦеноваяГруппа КАК ЦеноваяГруппа
	|ИЗ
	|	ВременнаяТаблицаЦеновыеГруппы КАК ВременнаяТаблицаЦеновыеГруппы
	|ГДЕ
	|	ВременнаяТаблицаЦеновыеГруппы.ЦеноваяГруппа <> ЗНАЧЕНИЕ(Справочник.ЦеновыеГруппы.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблицаЦеновыеГруппы.ЦеноваяГруппа
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(*) > 1
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтрокиМинимум";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстОшибки = НСтр("ru='Дублирование ценовых групп не допускается: строки %1 и %2 по элементу %3'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, Выборка.НомерСтрокиМинимум, Выборка.НомерСтрокиМаксимум, Выборка.ЦеноваяГруппа);
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "УточнитьРасчетПоЦеновымГруппам", ТекстОшибки, "");
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьВсеЦеныПоВидуЦен(ВидЦен) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВидЦен) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЦеныНоменклатуры = РегистрыСведений.ЦеныНоменклатуры.СоздатьНаборЗаписей();
	ЦеныНоменклатуры.Отбор.ВидЦен.Установить(ВидЦен, Истина);
	ЦеныНоменклатуры.Очистить();
	ЦеныНоменклатуры.Записать();
	
КонецПроцедуры

Процедура ОчиститьСвязиВидовЦен(ВидЦен) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	                      |	СвязиВидовЦен.ВидЦенРасчетный КАК ВидЦенРасчетный
	                      |ИЗ
	                      |	РегистрСведений.СвязиВидовЦенСлужебный КАК СвязиВидовЦен
	                      |ГДЕ
	                      |	СвязиВидовЦен.ВидЦенРасчетный = &ВидЦенРасчетный");
	Запрос.УстановитьПараметр("ВидЦенРасчетный", ВидЦен);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		НаборЗаписей = РегистрыСведений.СвязиВидовЦенСлужебный.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ВидЦенРасчетный.Установить(Выборка.ВидЦенРасчетный, Истина);
		НаборЗаписей.Записать(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

Функция СсылкаНовогоКаталогаЛогированияУдаленияУстаревшихЦен() Экспорт
	
	Идентификатор = "afc86d63-90e8-4449-93e7-f6b72db6606d";
	
	ОписаниеКаталога = Новый Структура;
	ОписаниеКаталога.Вставить("Имя",				НСтр("ru ='Удаленные цены'"));
	ОписаниеКаталога.Вставить("Описание", 			НСтр("ru ='Используется для хранения истории удаленных цен номенклатуры'"));
	ОписаниеКаталога.Вставить("Идентификатор",		Идентификатор);
	ОписаниеКаталога.Вставить("УИД",				Новый УникальныйИдентификатор(Идентификатор));
	
	Возврат ОписаниеКаталога;
	
КонецФункции

Процедура ДобавитьКаталогЛогированияУдаленияСтарыхЦен() Экспорт
	
	ОписаниеКаталога = СсылкаНовогоКаталогаЛогированияУдаленияУстаревшихЦен();
	
	ГруппаЛогирования = Справочники.ПапкиФайлов.ПолучитьСсылку(ОписаниеКаталога.УИД);
	Если ГруппаЛогирования.ПолучитьОбъект() = Неопределено Тогда
		
		НоваяГруппаЛогирования = Справочники.ПапкиФайлов.СоздатьЭлемент();
		НоваяГруппаЛогирования.УстановитьСсылкуНового(ГруппаЛогирования);
		НоваяГруппаЛогирования.Наименование				= ОписаниеКаталога.Имя;
		НоваяГруппаЛогирования.Описание					= ОписаниеКаталога.Описание;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НоваяГруппаЛогирования, Ложь, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает список имен «ключевых» реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Наименование");
	Результат.Добавить("ИдентификаторФормул");
	
	Возврат Результат;
	
КонецФункции // ПолучитьБлокируемыеРеквизитыОбъекта()

// Возвращает структуру с синонимом и схемой компоновки
// данных по имени макета.
//
// Параметры:
//	Ссылка - СправочникСсылка.ВидыЦены - ссылка на вид цены
//	ИмяМакета - Строка - имя макета, из которого необходимо получить описание и схему.
//
// Возвращаемое значение:
//	Структура - описание и схема компоновки данных.
//
Функция ПолучитьОписаниеИСхемуКомпоновкиДанныхПоИмениМакета(Ссылка, ИмяМакета = Неопределено) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Описание",                  "");
	ВозвращаемоеЗначение.Вставить("СхемаКомпоновкиДанных",     Неопределено);
	ВозвращаемоеЗначение.Вставить("НастройкиКомпоновкиДанных", Неопределено);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыЦен.ХранилищеСхемыКомпоновкиДанных КАК ХранилищеСхемыКомпоновкиДанных,
	|	ВидыЦен.ХранилищеНастроекКомпоновкиДанных КАК ХранилищеНастроекКомпоновкиДанных
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|ГДЕ
	|	ВидыЦен.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Не ЗначениеЗаполнено(ИмяМакета) Тогда
		
		ВозвращаемоеЗначение.Описание = ИмяМакета;
		Если Выборка.Следующий() Тогда
			
			СхемаКомпоновкиДанных = Выборка.ХранилищеСхемыКомпоновкиДанных.Получить();
			Если СхемаКомпоновкиДанных = Неопределено Тогда
				ВозвращаемоеЗначение.СхемаКомпоновкиДанных = СформироватьНовуюСхемуКомпоновкиДанных();
				ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Неопределено;
			Иначе
				ВозвращаемоеЗначение.СхемаКомпоновкиДанных = СхемаКомпоновкиДанных;
				ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ВозвращаемоеЗначение.Описание = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Макеты.Найти(ИмяМакета).Синоним;
		ВозвращаемоеЗначение.СхемаКомпоновкиДанных = Справочники.ВидыЦен.ПолучитьМакет(ИмяМакета);
		Если Выборка.Следующий() Тогда
			ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Осуществляет формирование новой СКД.
//
// Возвращаемое значение:
//  СхемаКомпоновкиДанных - Схема компоновки данных.
//
Функция СформироватьНовуюСхемуКомпоновкиДанных() Экспорт
	
	СКД                         = Новый СхемаКомпоновкиДанных;
	Источник                    = СКД.ИсточникиДанных.Добавить();
	Источник.Имя                = "ИсточникДанныхЦеныНоменклатуры";
	Источник.ТипИсточникаДанных = "Local";
	НаборДанных                 = СКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя             = "ЦеныНоменклатуры";
	НаборДанных.Запрос          =
		"ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК Номенклатура,
		|	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0) КАК Период,
		|	ЗНАЧЕНИЕ(Справочник.ЕдиницыИзмерения.ПустаяСсылка) КАК ЕдиницаИзмерения,";
		
	Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") Тогда
		НаборДанных.Запрос = НаборДанных.Запрос + "
		|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК Характеристика,";
	КонецЕсли;
	
	НаборДанных.Запрос = НаборДанных.Запрос + "
		|	0 КАК Цена,
		|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта
		|{ВЫБРАТЬ
		|	Номенклатура.*,";
		
	Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики") Тогда
		НаборДанных.Запрос = НаборДанных.Запрос + "
			|	Характеристика.*,";
	КонецЕсли;
	
	НаборДанных.Запрос = НаборДанных.Запрос + "
		|	Цена,
		|	ЕдиницаИзмерения,
		|	Период,
		|	Валюта.*}";
		
	НаборДанных.ИсточникДанных = "ИсточникДанныхЦеныНоменклатуры";
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Ложь;
	
	ОбязательныеПоля = ЦенообразованиеСервер.ПолучитьОбязательныеПоляСхемыКомпоновкиДанных();
	
	Для Каждого ОбязательноеПоле Из ОбязательныеПоля Цикл
		
		НовоеПоле             = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		НовоеПоле.Поле        = ОбязательноеПоле.Ключ;
		НовоеПоле.ПутьКДанным = ОбязательноеПоле.Ключ;
		НовоеПоле.ТипЗначения = ОбязательноеПоле.Значение;
		
	КонецЦикла;
	
	Возврат СКД;

КонецФункции

// Функция - Получить представление способа расчета вида цены
//
// Параметры:
//  ВидЦен	 - СправочникСсылка.ВидыЦен - создает представление расчета для списков видов цен
// 
// Возвращаемое значение:
//  Строка - представление расчета для списков видов цен
//
Функция ПолучитьПредставлениеСпособаРасчетаВидаЦены(ВидЦен) Экспорт
	
	МаксимальнаяДлинаСтрокиПредставления = 30;
	
	Если ВидЦен.ТипВидаЦен = Перечисления.ТипыВидовЦен.ДинамическийПроцент Тогда
		
		Возврат СтрШаблон(НСтр("ru = 'Наценка %1%% на %2'"), ВидЦен.Процент, ВидЦен.БазовыйВидЦен);
		
	ИначеЕсли ВидЦен.ТипВидаЦен = Перечисления.ТипыВидовЦен.ДинамическийФормула Тогда
		
		ПервыйПараметрДинамическийФормула = Лев(ВидЦен.Формула, МаксимальнаяДлинаСтрокиПредставления);
		ВторойПараметрДинамическийФормула = ?(СтрДлина(ВидЦен.Формула) > МаксимальнаяДлинаСтрокиПредставления, 
			"...", 
			"");
		Возврат СтрШаблон(НСтр("ru = '%1%2'"), ПервыйПараметрДинамическийФормула, ВторойПараметрДинамическийФормула); 
		
	ИначеЕсли ВидЦен.ТипВидаЦен = Перечисления.ТипыВидовЦен.ПроизвольныйЗапрос Тогда
		
		Если ЗначениеЗаполнено(ВидЦен.СхемаКомпоновкиДанных) Тогда
			
			СхемаМетаданные = ВидЦен.Метаданные().Макеты.Найти(ВидЦен.СхемаКомпоновкиДанных);
			Возврат ?(СхемаМетаданные <> Неопределено, СхемаМетаданные.Синоним, НСтр("ru = 'Произвольный запрос'"));
			
		Иначе
			
			Возврат НСтр("ru = 'Произвольный запрос'");
			
		КонецЕсли;
		
	ИначеЕсли ВидЦен.ТипВидаЦен = Перечисления.ТипыВидовЦен.Расширение Тогда
		
		Возврат НСтр("ru = 'Расширение'");
		
	КонецЕсли;
	
КонецФункции

Функция ЕстьВидыЦенСАвтовыборомВводаНаОсновании() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ВидыЦен.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ВидыЦен КАК ВидыЦен
	               |ГДЕ
	               |	ВидыЦен.ЗаполнятьИзОснования
	               |	И НЕ ВидыЦен.Недействителен";
	РезультатЗапроса = Запрос.Выполнить();
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьИндексКартинки(ВидЦены)
	
	Если ВидЦены.РассчитыватьАвтоматически Тогда
		Возврат 2;
	КонецЕсли;
	
	Если ВидЦены.ТипВидаЦен = Перечисления.ТипыВидовЦен.Статический Тогда
		Возврат 0;
	КонецЕсли;
	
	Если ВидЦены.ТипВидаЦен = Перечисления.ТипыВидовЦен.ДинамическийПроцент
		ИЛИ ВидЦены.ТипВидаЦен = Перечисления.ТипыВидовЦен.ДинамическийФормула Тогда
		Возврат 1;
	КонецЕсли;
	
	Если ВидЦены.ТипВидаЦен = Перечисления.ТипыВидовЦен.ПроизвольныйЗапрос Тогда
		Возврат 3;
	КонецЕсли;
	
	Если ВидЦены.ТипВидаЦен = Перечисления.ТипыВидовЦен.Расширение Тогда
		Возврат 4;
	КонецЕсли;
	
КонецФункции

Процедура ЗаполнитьСоответствиеВидовЦен(СоответствиеВидовЦен, ДеревоВидовЦен)
	
	Для каждого СтрокаВидовЦен Из ДеревоВидовЦен.Строки Цикл
		
		ПодчиненныеВидыЦен = Новый Соответствие;
		СоответствиеВидовЦен.Вставить(СтрокаВидовЦен.ВидЦен, ПодчиненныеВидыЦен);
		ЗаполнитьСоответствиеВидовЦен(ПодчиненныеВидыЦен, СтрокаВидовЦен);
	
	КонецЦикла;
	
КонецПроцедуры

Процедура ПодготовитьТаблицуРегистраЗависимыеВидыЦен(ТаблицаЗависимыхЦен, ВидЦен)
	
	Если ТаблицаЗависимыхЦен = Неопределено Тогда
		
		ТаблицаЗависимыхЦен = Новый ТаблицаЗначений;
		ТаблицаЗависимыхЦен.Колонки.Добавить("ВидЦенРасчетный");
		ТаблицаЗависимыхЦен.Колонки.Добавить("ВидЦенБазовый");
		ТаблицаЗависимыхЦен.Колонки.Добавить("ЦеноваяГруппа");
		ТаблицаЗависимыхЦен.Колонки.Добавить("ВидЦенБазовыйЦеновойГруппы");
		
	КонецЕсли;
	
	Если ВидЦен.ТипВидаЦен = Перечисления.ТипыВидовЦен.ДинамическийФормула Тогда
		
		ОтборСтрок = Новый Структура("ВидЦенРасчетный, ВидЦенБазовый, ЦеноваяГруппа");
		
		Операнды = ЦенообразованиеФормулыСервер.ПолучитьТаблицуОперандовФормулы(ТекущаяДатаСеанса(), ВидЦен.Формула);
		Для каждого Операнд Из Операнды Цикл
			
			Если НЕ ЗначениеЗаполнено(Операнд.ВидЦен)
				ИЛИ ТаблицаЗависимыхЦен.Найти(Операнд.ВидЦен, "ВидЦенБазовый") <> Неопределено Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			НоваяСтрока								= ТаблицаЗависимыхЦен.Добавить();
			НоваяСтрока.ВидЦенРасчетный				= ВидЦен.Ссылка;
			НоваяСтрока.ВидЦенБазовый				= Операнд.ВидЦен;
			НоваяСтрока.ЦеноваяГруппа				= Неопределено;
			НоваяСтрока.ВидЦенБазовыйЦеновойГруппы	= Неопределено;
			
		КонецЦикла;
		
		Для каждого СтрокаТаблицы Из ВидЦен.ЦеновыеГруппы Цикл
			
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ЦеноваяГруппа) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			Операнды = ЦенообразованиеФормулыСервер.ПолучитьТаблицуОперандовФормулы(ТекущаяДатаСеанса(), СтрокаТаблицы.Формула);
			Для каждого Операнд Из Операнды Цикл
				
				Если НЕ ЗначениеЗаполнено(Операнд.ВидЦен) Тогда
					
					Продолжить;
					
				КонецЕсли;
				
				ОтборСтрок.ВидЦенБазовый = Операнд.ВидЦен;
				ОтборСтрок.ЦеноваяГруппа = СтрокаТаблицы.ЦеноваяГруппа;
				
				МассивСтрок = ТаблицаЗависимыхЦен.НайтиСтроки(ОтборСтрок);
				Если МассивСтрок.Количество() > 0 Тогда
					
					Продолжить;
					
				КонецЕсли;
				
				НоваяСтрока								= ТаблицаЗависимыхЦен.Добавить();
				НоваяСтрока.ВидЦенРасчетный				= ВидЦен.Ссылка;
				НоваяСтрока.ВидЦенБазовый				= Неопределено;
				НоваяСтрока.ЦеноваяГруппа				= СтрокаТаблицы.ЦеноваяГруппа;
				НоваяСтрока.ВидЦенБазовыйЦеновойГруппы	= Операнд.ВидЦен;
				
			КонецЦикла;
			
		КонецЦикла;
		
	ИначеЕсли ВидЦен.ТипВидаЦен = Перечисления.ТипыВидовЦен.ДинамическийПроцент Тогда
		
		НоваяСтрока					= ТаблицаЗависимыхЦен.Добавить();
		НоваяСтрока.ВидЦенРасчетный = ВидЦен.Ссылка;
		НоваяСтрока.ВидЦенБазовый	= ВидЦен.БазовыйВидЦен;
		
		Для каждого СтрокаТаблицы Из ВидЦен.ЦеновыеГруппы Цикл
			
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ЦеноваяГруппа) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			НоваяСтрока								= ТаблицаЗависимыхЦен.Добавить();
			НоваяСтрока.ВидЦенРасчетный				= ВидЦен.Ссылка;
			НоваяСтрока.ВидЦенБазовый				= ВидЦен.БазовыйВидЦен;
			НоваяСтрока.ЦеноваяГруппа				= СтрокаТаблицы.ЦеноваяГруппа;
			НоваяСтрока.ВидЦенБазовыйЦеновойГруппы	= СтрокаТаблицы.БазовыйВидЦен;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодготовитьТаблицуРегистраОчередьРасчетаЦен(ОчередьРасчетаЦен, СвязиВидовЦен, ВидЦен)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	&ВидЦенРасчетный КАК ВидЦенРасчетный,
	|	ЗаписиЦен.Номенклатура КАК Номенклатура,
	|	ЗаписиЦен.Характеристика КАК Характеристика,
	|	ЛОЖЬ КАК ПересчетВыполнен,
	|	&Период КАК ПериодЗаписи,
	|	ВЫРАЗИТЬ(0 КАК ЧИСЛО(10, 0)) КАК НомерОчередиЦен
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			,
	|			Актуальность
	|				И ВидЦен В (&МассивВидовЦен)) КАК ЗаписиЦен
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&ВидЦенРасчетный,
	|	ЗаписиЦенКонтрагентов.Номенклатура,
	|	ЗаписиЦенКонтрагентов.Характеристика,
	|	ЛОЖЬ,
	|	&Период,
	|	ВЫРАЗИТЬ(0 КАК ЧИСЛО(10, 0))
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатурыКонтрагентов.СрезПоследних(
	|			,
	|			Актуальность
	|				И ВидЦенКонтрагента В (&МассивВидовЦен)) КАК ЗаписиЦенКонтрагентов
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидЦенРасчетный,
	|	ЗаписиЦен.Номенклатура,
	|	ЗаписиЦен.Характеристика";
	
	Запрос.УстановитьПараметр("Период", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ВидЦенРасчетный", ВидЦен.Ссылка);
	Запрос.УстановитьПараметр("МассивВидовЦен", СвязиВидовЦен.ВыгрузитьКолонку("ВидЦенБазовый"));
	
	ОчередьРасчетаЦен = Запрос.Выполнить().Выгрузить();
	ОчередьРасчетаЦен.ЗаполнитьЗначения(ЦенообразованиеСервер.УстановитьРабочийНомерОчередиЦен(), "НомерОчередиЦен");
	
КонецПроцедуры

// Функция - Получить сортированную таблицу видов цен
// 
// Возвращаемое значение:
//  ТаблицаЗначений:
//		* ИдентификаторФормул - Строка - идентификатор формул для вида цены
//		* ВидЦены - СправочникСсылка.ВидыЦен - ссылка на вид цены
//		* ИндексКартинки - Число - индекс картинки для поля списка
//		* ПорядокСортировки - Число - поле сортировки
//
Функция ПолучитьСортированнуюТаблицуВидовЦенПоПорядкуКолонок()
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыЦен.ИдентификаторФормул КАК ИдентификаторФормул,
	|	ВидыЦен.Наименование КАК Наименование,
	|	ВидыЦен.Ссылка КАК Ссылка,
	|	ВидыЦен.ТипВидаЦен КАК ТипВидаЦен,
	|	ВидыЦен.ПорядокКолонок КАК ПорядокКолонок,
	|	ВЫБОР
	|		КОГДА ВидыЦен.ТипВидаЦен = ЗНАЧЕНИЕ(Перечисление.ТипыВидовЦен.Статический)
	|			ТОГДА 0
	|		КОГДА (ВидыЦен.ТипВидаЦен = ЗНАЧЕНИЕ(Перечисление.ТипыВидовЦен.ДинамическийПроцент)
	|				ИЛИ ВидыЦен.ТипВидаЦен = ЗНАЧЕНИЕ(Перечисление.ТипыВидовЦен.ДинамическийФормула))
	|				И НЕ ВидыЦен.РассчитыватьАвтоматически
	|			ТОГДА 1
	|		КОГДА ВидыЦен.РассчитыватьАвтоматически
	|			ТОГДА 2
	|		КОГДА ВидыЦен.ТипВидаЦен = ЗНАЧЕНИЕ(Перечисление.ТипыВидовЦен.ПроизвольныйЗапрос)
	|			ТОГДА 3
	|		КОГДА ВидыЦен.ТипВидаЦен = ЗНАЧЕНИЕ(Перечисление.ТипыВидовЦен.Расширение)
	|			ТОГДА 4
	|	КОНЕЦ КАК ИндексКартинки
	|ПОМЕСТИТЬ ВидыЦен
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВидыЦен.ПорядокКолонок) КАК ПорядокУказан
	|ПОМЕСТИТЬ Порядки
	|ИЗ
	|	ВидыЦен КАК ВидыЦен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыЦен.ИдентификаторФормул КАК ИдентификаторФормул,
	|	ВидыЦен.Ссылка КАК ВидЦены,
	|	ВидыЦен.ТипВидаЦен КАК ТипВидаЦен,
	|	ВидыЦен.ИндексКартинки КАК ИндексКартинки,
	|	ВидыЦен.ПорядокКолонок КАК ПорядокКолонок
	|ИЗ
	|	ВидыЦен КАК ВидыЦен,
	|	Порядки КАК Порядки
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВЫБОР
	|		КОГДА Порядки.ПорядокУказан = 0
	|			ТОГДА ВидыЦен.Наименование
	|		ИНАЧЕ ВидыЦен.ПорядокКолонок
	|	КОНЕЦ";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли