﻿#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// МОДУЛЬ СОДЕРЖИТ РЕАЛИЗАЦИЮ МЕХАНИКИ НУМЕРАЦИИ ДОКУМЕНТОВ
// 

// Возвращает сформированный числовой номер
Процедура СформироватьЧисловойНомерДокумента(СтруктураПараметров, СформированныйНомер) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиНумерации = СтруктураПараметров.НастройкиНумерации;
	
	// измерения нумерации
	ПериодНумерации = НачалоПериодаНумерации(?(ЗначениеЗаполнено(СтруктураПараметров.ДатаДоговора), СтруктураПараметров.ДатаДоговора, ТекущаяДатаСеанса()));
	
	СтруктураИзмерений = Новый Структура;
	СтруктураИзмерений.Вставить("ПериодНумерации", 	  ?(НастройкиНумерации.Периодичный, ПериодНумерации, Дата('00010101')));
	СтруктураИзмерений.Вставить("НастройкиНумерации", НастройкиНумерации);
	
	// перерегистрация
	Если СформированныйНомер > 0 Тогда 
		
		ТекущийНомер = РегистрыСведений.АвтоНумерацияДоговоровКонтрагента.Получить(СтруктураИзмерений).ТекущийНомер; 
		Если ТекущийНомер = СформированныйНомер Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	// автоматическая нумерация
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.АвтоНумерацияДоговоровКонтрагента");
		ЭлементБлокировки.УстановитьЗначение("ПериодНумерации",   	ПериодНумерации);
		ЭлементБлокировки.УстановитьЗначение("НастройкиНумерации", 	НастройкиНумерации);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		ТекущийНомер = РегистрыСведений.АвтоНумерацияДоговоровКонтрагента.Получить(СтруктураИзмерений).ТекущийНомер;
		Если Не ЗначениеЗаполнено(ТекущийНомер) Тогда
			ТекущийНомер = 0;
		КонецЕсли;
		
		СформированныйНомер = ТекущийНомер + 1;
		
		МенеджерЗаписи = РегистрыСведений.АвтоНумерацияДоговоровКонтрагента.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтруктураИзмерений);
		МенеджерЗаписи.ТекущийНомер = СформированныйНомер;
		МенеджерЗаписи.Записать();
		
		ЗафиксироватьТранзакцию();	
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Возвращает сформированный строковый номер
Процедура СформироватьСтроковыйНомерДокумента(СтруктураПараметров, СформированныйНомер, ОписанияОшибок) Экспорт 
	
	Перем СтруктураФорматаНомера, ОписаниеОшибки;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НастройкиНумерации = СтруктураПараметров.НастройкиНумерации;
	
	// вручную изменен номер
	Если СтруктураПараметров.ЧисловойНомер = -1 Тогда
		Возврат;
	КонецЕсли;
	
	ФорматНомера = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкиНумерации, "ФорматНомера");
	Если Не ЗначениеЗаполнено(ФорматНомера) Тогда
		СформированныйНомер = "";
		ОписанияОшибок.Добавить("", НСтр("ru = 'Не указан формат номера для автонумерации договора.'"));
		Возврат;
	КонецЕсли;	
	
	// автоматическая нумерация
	Если Не РазобратьФорматНомера(ФорматНомера, ОписаниеОшибки, СтруктураФорматаНомера) Тогда 
		СформированныйНомер = "";
		ОписанияОшибок.Добавить("", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка в формате номера: %1.'"), ОписаниеОшибки));
		Возврат;
	КонецЕсли;	
	
	ЗначенияПараметровНомера = ПолучитьЗначенияПараметровНомера(СтруктураПараметров, СтруктураФорматаНомера, ОписанияОшибок);
	Если ОписанияОшибок.Количество() > 0 Тогда
		СформированныйНомер = "";
		Возврат;
	КонецЕсли;	
	
	СформированныйНомер = СформироватьНомерДокументаПоФормату(СтруктураФорматаНомера, ЗначенияПараметровНомера);
	
КонецПроцедуры

// Разбирает текстовый формат номера в структуру 
Функция РазобратьФорматНомера(ФорматНомера, ОписаниеОшибки, СтруктураФорматаНомера = Неопределено) Экспорт 
	
	СтруктураФорматаНомера = Новый ТаблицаЗначений;
	СтруктураФорматаНомера.Колонки.Добавить("Ключ", Новый ОписаниеТипов("Строка")); // разделитель или служебное поле
	СтруктураФорматаНомера.Колонки.Добавить("Значение", Новый ОписаниеТипов("Строка")); // значение разделителя или служебного поля
	СтруктураФорматаНомера.Колонки.Добавить("ВходитВСлужебное", Новый ОписаниеТипов("Число")); // разделитель входит в служебное поле
	
	ОписаниеОшибки = "";
	СписокПолей = ПолучитьСписокСлужебныхПолей();
	
	// проверка соответствия скобок
	ПозицияСкобки = 0;
	ПоказательСкобки = 0;
	
	врФорматНомера = СокрЛП(ФорматНомера);
	Для Инд = 1 По СтрДлина(врФорматНомера) Цикл
		
		ТекСимвол = Сред(врФорматНомера, Инд, 1);
		Если (ТекСимвол <> "[") И (ТекСимвол <> "]") Тогда
			Продолжить;
		КонецЕсли;	
		
		Если (ТекСимвол = "[") Тогда
			ПоказательСкобки = ПоказательСкобки + 1;
			Если ПоказательСкобки > 1 Тогда 
				ФрагментОшибки = Сред(врФорматНомера, ПозицияСкобки + 1, Инд - ПозицияСкобки);
				
				Если ФрагментОшибки = "" Тогда 
					ОписаниеОшибки = НСтр("ru = 'Отсутствует символ ""]""'");
				Иначе
					ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Отсутствует символ ""]"" в фрагменте ""%1""'"), ФрагментОшибки);
				КонецЕсли;

				Возврат Ложь;
			КонецЕсли;	
		КонецЕсли;	
		
		Если (ТекСимвол = "]") Тогда
			ПоказательСкобки = ПоказательСкобки - 1;
			Если ПоказательСкобки < 0 Тогда 
				ФрагментОшибки = Сред(врФорматНомера, ПозицияСкобки + 1, Инд - ПозицияСкобки);
				
				Если ФрагментОшибки = "" Тогда 
					ОписаниеОшибки = НСтр("ru = 'Отсутствует символ ""[""'");
				Иначе
					ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Отсутствует символ ""["" в фрагменте ""%1""'"), ФрагментОшибки);
				КонецЕсли;

				Возврат Ложь;
			КонецЕсли;	
		КонецЕсли;	
		
		ПозицияСкобки = Инд;
	КонецЦикла;
	
	Если ПоказательСкобки > 0 Тогда 
		ФрагментОшибки = Сред(врФорматНомера, ПозицияСкобки + 1);
		
		Если ФрагментОшибки = "" Тогда 
			ОписаниеОшибки = НСтр("ru = 'Отсутствует символ ""]""'");
		Иначе
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Отсутствует символ ""]"" в фрагменте ""%1""'"), ФрагментОшибки);
		КонецЕсли;

		Возврат Ложь;
	КонецЕсли;
	
	
	врФорматНомера = СокрЛП(ФорматНомера);
	Пока врФорматНомера <> "" Цикл
		
		Поз1 = Найти(врФорматНомера, "["); // начало служебного поля
		Если Поз1 > 0 Тогда
			
			Разделитель = Лев(врФорматНомера, Поз1-1);
			Если Разделитель <> "" Тогда
				НоваяСтрока = СтруктураФорматаНомера.Добавить();
				НоваяСтрока.Ключ = "Разделитель";
				НоваяСтрока.Значение = Разделитель;
			КонецЕсли;	
			
			врФорматНомера = Сред(врФорматНомера, Поз1+1);
		    Поз2 = Найти(врФорматНомера, "]"); // окончание служебного поля
			
			Если Поз2 > 0 Тогда
				КодСлужебногоПоля = Лев(врФорматНомера, Поз2-1);
				
				НайденоСлужебноеПоле = Ложь;
				Для Каждого СлужебноеПоле Из СписокПолей Цикл
					
					Поз3 = Найти(КодСлужебногоПоля, СлужебноеПоле.Значение);
					Если Поз3 = 0 Тогда 
						Продолжить;
					КонецЕсли;	
					
					Если Поз3 > 1 Тогда 
						Разделитель = Лев(КодСлужебногоПоля, Поз3 - 1);
						
						НоваяСтрока = СтруктураФорматаНомера.Добавить();
						НоваяСтрока.Ключ = "Разделитель";
						НоваяСтрока.Значение = Разделитель;
						НоваяСтрока.ВходитВСлужебное = СтруктураФорматаНомера.Индекс(НоваяСтрока) + 2;
					КонецЕсли;	
					
					НоваяСтрока = СтруктураФорматаНомера.Добавить();
					НоваяСтрока.Ключ = "СлужебноеПоле";
					НоваяСтрока.Значение = СлужебноеПоле.Представление;
					
					Если Поз3 + СтрДлина(СлужебноеПоле.Значение) - 1 < СтрДлина(КодСлужебногоПоля) Тогда 
						Разделитель = Сред(КодСлужебногоПоля, Поз3 + СтрДлина(СлужебноеПоле.Значение));
						
						НоваяСтрока = СтруктураФорматаНомера.Добавить();
						НоваяСтрока.Ключ = "Разделитель";
						НоваяСтрока.Значение = Разделитель;
						НоваяСтрока.ВходитВСлужебное = СтруктураФорматаНомера.Индекс(НоваяСтрока);
					КонецЕсли;	
					
					НайденоСлужебноеПоле = Истина;
					Прервать;
				КонецЦикла;	
				
				Если Не НайденоСлужебноеПоле Тогда 
					ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Неверное служебное поле ""%1""'"),
						КодСлужебногоПоля);
					Возврат Ложь;
				КонецЕсли;	
				
				врФорматНомера = Сред(врФорматНомера, Поз2+1);
			Иначе
				ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не обнаружено окончание служебного поля ""%1""'"),
					врФорматНомера);
				Возврат Ложь;
			КонецЕсли;	
			
		Иначе	
			
			Разделитель = врФорматНомера;
			Если Разделитель <> "" Тогда
				НоваяСтрока = СтруктураФорматаНомера.Добавить();
				НоваяСтрока.Ключ = "Разделитель";
				НоваяСтрока.Значение = Разделитель;
			КонецЕсли;
			врФорматНомера = "";
			
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат Истина;
	
КонецФункции

// Проверят смену периода при изменении даты регистрации
Функция ПроверитьСменуПериодаНумерации(НоваяДата, СтараяДата) Экспорт
	
	НовыйПериодНумерации = НачалоПериодаНумерации(НоваяДата);
	СтарыйПериодНумерации = НачалоПериодаНумерации(СтараяДата);
	
	Возврат (НовыйПериодНумерации <> СтарыйПериодНумерации);
	
КонецФункции	

// Формирует пример номера
Функция СформироватьПримерНомера(ФорматНомера, Пример, ОписаниеОшибки) Экспорт
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	День  = День(ТекущаяДата);
	Месяц = Месяц(ТекущаяДата);
	Год4  = Год(ТекущаяДата);
	Год2  = Прав(Строка(Год4), 2);
	
	Если Месяц <= 3 Тогда Квартал = 1;
	ИначеЕсли Месяц <= 6 Тогда Квартал = 2;
	ИначеЕсли Месяц <= 9 Тогда Квартал = 3;
	Иначе Квартал = 4; КонецЕсли;
	
	ЗначенияПараметровНомера = Новый Структура;
	ЗначенияПараметровНомера.Вставить("Номер", 		12345);
	ЗначенияПараметровНомера.Вставить("День", 		Формат(День,"ЧЦ=2; ЧВН="));
	ЗначенияПараметровНомера.Вставить("Месяц", 		Формат(Месяц,"ЧЦ=2; ЧВН="));
	ЗначенияПараметровНомера.Вставить("Год4", 		Год4);
	ЗначенияПараметровНомера.Вставить("Год2", 		Год2);
	ЗначенияПараметровНомера.Вставить("Квартал", 	Квартал);
	ЗначенияПараметровНомера.Вставить("ВидКонтрагента", 	"ЮЛ");
	ЗначенияПараметровНомера.Вставить("ПрефиксИБ", 	ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы"));
	ЗначенияПараметровНомера.Вставить("ПрефиксКатегории", 	"КА");
	
	ОписаниеОшибки = "";
	СтруктураФорматаНомера = ""; 
	
	Если Не РазобратьФорматНомера(ФорматНомера, ОписаниеОшибки, СтруктураФорматаНомера) Тогда
		Пример = "";
		Возврат Ложь;
	КонецЕсли;
	
	Пример = СформироватьНомерДокументаПоФормату(СтруктураФорматаНомера, ЗначенияПараметровНомера);
	Возврат Истина;
	
КонецФункции

// Вычисляет начало периода нумерации
Функция НачалоПериодаНумерации(Дата) Экспорт
	
	ПериодНумерации = НачалоГода(Дата);
	Возврат ПериодНумерации;
	
КонецФункции	

// Вычисляет начало периода нумерации
Функция КонецПериодаНумерации(Периодичность, Дата) Экспорт
	
	ПериодНумерации = КонецГода(Дата);
	Возврат ПериодНумерации;
	
КонецФункции	

// Для параметров, указанных в формате номера, вычисляет их значения
Функция ПолучитьЗначенияПараметровНомера(Объект, СтруктураФорматаНомера, ОписанияОшибок) 
	
	ПараметрыНомера = Новый Структура;
	
	Для Каждого ЭлементФормата Из СтруктураФорматаНомера Цикл
		Если ЭлементФормата.Ключ <> "СлужебноеПоле" Тогда
			Продолжить;
		КонецЕсли;	
		
		СлужебноеПоле = ЭлементФормата.Значение;
		ЗначениеПоля = "";
		
		Если СлужебноеПоле = "Номер" Тогда
			ЗначениеПоля = Объект.ЧисловойНомер;
			
		ИначеЕсли СлужебноеПоле = "День" Тогда
			Если Не ЗначениеЗаполнено(Объект.ДатаДоговора) Тогда 
				ОписанияОшибок.Добавить("ДатаДоговора", НСтр("ru = 'Не заполнено поле ""Дата договора""'"));
			Иначе
				ЗначениеПоля = Формат(День(Объект.ДатаДоговора), "ЧЦ=2; ЧВН=");
			КонецЕсли;	
			
		ИначеЕсли СлужебноеПоле = "Месяц" Тогда
			Если Не ЗначениеЗаполнено(Объект.ДатаДоговора) Тогда 
				ОписанияОшибок.Добавить("ДатаДоговора", НСтр("ru = 'Не заполнено поле ""Дата договора""'"));
			Иначе
				ЗначениеПоля = Формат(Месяц(Объект.ДатаДоговора), "ЧЦ=2; ЧВН=");
			КонецЕсли;
			
		ИначеЕсли СлужебноеПоле = "Квартал" Тогда
			Если Не ЗначениеЗаполнено(Объект.ДатаДоговора) Тогда 
				ОписанияОшибок.Добавить("ДатаДоговора", НСтр("ru = 'Не заполнено поле ""Дата договора""'"));
			Иначе
				Месяц = Месяц(Объект.ДатаДоговора);
				Если 	  Месяц <= 3 Тогда ЗначениеПоля = 1;
				ИначеЕсли Месяц <= 6 Тогда ЗначениеПоля = 2;
				ИначеЕсли Месяц <= 9 Тогда ЗначениеПоля = 3;
				Иначе ЗначениеПоля = 4; КонецЕсли;
			КонецЕсли;	
			
		ИначеЕсли СлужебноеПоле = "Год4" Тогда
			Если Не ЗначениеЗаполнено(Объект.ДатаДоговора) Тогда 
				ОписанияОшибок.Добавить("ДатаДоговора", НСтр("ru = 'Не заполнено поле ""Дата договора""'"));
			Иначе
				ЗначениеПоля = Год(Объект.ДатаДоговора);
			КонецЕсли;
			
		ИначеЕсли СлужебноеПоле = "Год2" Тогда
			Если Не ЗначениеЗаполнено(Объект.ДатаДоговора) Тогда 
				ОписанияОшибок.Добавить("ДатаДоговора", НСтр("ru = 'Не заполнено поле ""Дата договора""'"));
			Иначе
				ЗначениеПоля = Прав(Строка(Год(Объект.ДатаДоговора)), 2);
			КонецЕсли;	
			
		ИначеЕсли СлужебноеПоле = "ВидКонтрагента" Тогда
			Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
				ЗначениеПоля = "";
			ИначеЕсли ТипЗнч(Объект.Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
				ВидКонтрагента = Объект.Контрагент.ВидКонтрагента;
				Если ВидКонтрагента = Перечисления.ВидыКонтрагентов.ЮридическоеЛицо Тогда
					ЗначениеПоля = "ЮЛ";
				ИначеЕсли ВидКонтрагента = Перечисления.ВидыКонтрагентов.ИндивидуальныйПредприниматель Тогда
					ЗначениеПоля = "ИП";
				ИначеЕсли ВидКонтрагента = Перечисления.ВидыКонтрагентов.ФизическоеЛицо Тогда
					ЗначениеПоля = "ФЛ";
				ИначеЕсли ВидКонтрагента = Перечисления.ВидыКонтрагентов.ГосударственныйОрган Тогда
					ЗначениеПоля = "ГО";
				КонецЕсли;
			ИначеЕсли ТипЗнч(Объект.Контрагент) = Тип("СправочникСсылка.Организации") Тогда
				// Интеркампани: договор передачи товаров
				ЗначениеПоля = "ПТ";
			Иначе
				ЗначениеПоля = "";
			КонецЕсли;
		ИначеЕсли СлужебноеПоле = "ПрефиксИБ" Тогда
			ЗначениеПоля = ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы");
		ИначеЕсли СлужебноеПоле = "ПрефиксКатегории" Тогда
			Если ЗначениеЗаполнено(Объект.КатегорияДоговора) Тогда
				ЗначениеПоля = Объект.КатегорияДоговора.Префикс;
			Иначе
				ЗначениеПоля = "";
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыНомера.Вставить(СлужебноеПоле, ЗначениеПоля);
		
	КонецЦикла;	
	
	Возврат ПараметрыНомера;
	
КонецФункции	

// Формирует номер из структуры формата и значений параметров
Функция СформироватьНомерДокументаПоФормату(СтруктураФорматаНомера, ЗначенияПараметровНомера) 
	
	СформированныйНомер = "";
	
	Для Каждого ЭлементФормата Из СтруктураФорматаНомера Цикл
		
		Если ЭлементФормата.Ключ = "Разделитель" Тогда
			
			Если ЭлементФормата.ВходитВСлужебное = 0 Тогда
				СформированныйНомер = СформированныйНомер + ЭлементФормата.Значение;
			Иначе
				ЗначениеПараметра = "";
				СлужебноеПоле = СтруктураФорматаНомера.Получить(ЭлементФормата.ВходитВСлужебное - 1).Значение;
				ЗначенияПараметровНомера.Свойство(СлужебноеПоле, ЗначениеПараметра);
				Если ЗначениеЗаполнено(ЗначениеПараметра) Тогда 
					СформированныйНомер = СформированныйНомер + ЭлементФормата.Значение;
				КонецЕсли;	
			КонецЕсли;	
			
		ИначеЕсли ЭлементФормата.Ключ = "СлужебноеПоле" Тогда
			
			ЗначениеПараметра = "";
			ЗначенияПараметровНомера.Свойство(ЭлементФормата.Значение, ЗначениеПараметра);
			
			Если ТипЗнч(ЗначениеПараметра) = Тип("Число") Тогда
				ЗначениеПараметра = Формат(ЗначениеПараметра, "ЧГ=");
			Иначе	
				ЗначениеПараметра = Строка(ЗначениеПараметра);
			КонецЕсли;	
			
			СформированныйНомер = СформированныйНомер + ЗначениеПараметра;
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат СформированныйНомер;
	
КонецФункции

Функция ПолучитьСписокСлужебныхПолей()
	
	СписокПолей = Новый СписокЗначений; // значение - служебное поле в строке формата
										// представление - представление служебного поля
	
	СписокПолей.Добавить(НСтр("ru = 'День'"), 				"День");  	// день месяца
	СписокПолей.Добавить(НСтр("ru = 'Месяц'"),   			"Месяц"); 	// номер месяца
	СписокПолей.Добавить(НСтр("ru = 'Квартал'"), 			"Квартал"); // номер квартала
	СписокПолей.Добавить(НСтр("ru = 'Год4'"), 				"Год4");  	// год 4 знака
	СписокПолей.Добавить(НСтр("ru = 'Год2'"), 				"Год2");  	// год 2 знака
	СписокПолей.Добавить(НСтр("ru = 'Номер'"),  			"Номер"); 	// числовой номер
	СписокПолей.Добавить(НСтр("ru = 'ВидКонтрагента'"), 	"ВидКонтрагента"); 	// вид контрагента
	СписокПолей.Добавить(НСтр("ru = 'ПрефиксИБ'"), 			"ПрефиксИБ"); 	// вид контрагента
	СписокПолей.Добавить(НСтр("ru = 'ПрефиксКатегории'"), 	"ПрефиксКатегории"); 	// вид контрагента
	
	Возврат СписокПолей;
	
КонецФункции	

// Получает нумератор документа
Функция ПолучитьНумераторДокумента(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Объект) = Тип("Структура") Тогда 
		ПараметрыНумерации = Объект;
	Иначе
		ПараметрыНумерации = НумерацияКлиентСервер.ПолучитьПараметрыНумерации(Объект);
	КонецЕсли;	
	
	Возврат ПараметрыНумерации.ВидДокумента;
	
КонецФункции	

// Освобождает номер в регистре
Процедура ОсвободитьНомер(СтруктураПараметров) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	НастройкиНумерации = СтруктураПараметров.НастройкиНумерации;
	
	ЧисловойНомер = СтруктураПараметров.ЧисловойНомер;
	Если ЧисловойНомер = 0 Или ЧисловойНомер = -1 Тогда 
		Возврат;
	КонецЕсли;
	
	ПериодНумерации = НачалоПериодаНумерации(?(ЗначениеЗаполнено(СтруктураПараметров.ДатаДоговора), СтруктураПараметров.ДатаДоговора, ТекущаяДатаСеанса()));
	
	ПериодНумерации = НачалоПериодаНумерации(?(НастройкиНумерации.Периодичный, ПериодНумерации, Дата('00010101')));
	
	СтруктураИзмерений = Новый Структура;
	СтруктураИзмерений.Вставить("ПериодНумерации", 	  ПериодНумерации);
	СтруктураИзмерений.Вставить("НастройкиНумерации", 	  НастройкиНумерации);
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.АвтоНумерацияДоговоровКонтрагента");
		ЭлементБлокировки.УстановитьЗначение("НастройкиНумерации", НастройкиНумерации);
		ЭлементБлокировки.УстановитьЗначение("ПериодНумерации", ПериодНумерации);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		ТекущийНомер = РегистрыСведений.АвтоНумерацияДоговоровКонтрагента.Получить(СтруктураИзмерений).ТекущийНомер;
		
		Если ТекущийНомер = ЧисловойНомер Тогда // уменьшить номер в регистре
			МенеджерЗаписи = РегистрыСведений.АвтоНумерацияДоговоровКонтрагента.СоздатьМенеджерЗаписи();
			
			МенеджерЗаписи.ПериодНумерации 	  = ПериодНумерации;
			МенеджерЗаписи.НастройкиНумерации  = НастройкиНумерации;
			МенеджерЗаписи.ТекущийНомер 	  = ТекущийНомер - 1;
			МенеджерЗаписи.Записать();
		КонецЕсли;	
		
		ЗафиксироватьТранзакцию();	
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры	

Функция АктуальнаяНастройкаНумерации(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА НастройкиНумерацииДоговоровКонтрагентов.РучнаяНумерация
	|			ТОГДА ВЫБОР
	|					КОГДА НастройкиНумерацииДоговоровКонтрагентов.КатегорияДоговора = ЗНАЧЕНИЕ(Справочник.КатегорииДоговоров.ПустаяСсылка)
	|						ТОГДА 7
	|					ИНАЧЕ 1
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА НастройкиНумерацииДоговоровКонтрагентов.КатегорияДоговора = ЗНАЧЕНИЕ(Справочник.КатегорииДоговоров.ПустаяСсылка)
	|					ТОГДА 8
	|				ИНАЧЕ 2
	|			КОНЕЦ
	|	КОНЕЦ КАК Приоритет,
	|	НастройкиНумерацииДоговоровКонтрагентов.Ссылка КАК Ссылка,
	|	НастройкиНумерацииДоговоровКонтрагентов.РучнаяНумерация КАК РучнаяНумерация,
	|	ВЫБОР
	|		КОГДА НастройкиНумерацииДоговоровКонтрагентов.КатегорияДоговора = ЗНАЧЕНИЕ(Справочник.КатегорииДоговоров.ПустаяСсылка)
	|			ТОГДА ""по организации""
	|		ИНАЧЕ ""по категории""
	|	КОНЕЦ КАК Наименование
	|ИЗ
	|	Справочник.НастройкиНумерацииДоговоровКонтрагентов КАК НастройкиНумерацииДоговоровКонтрагентов
	|ГДЕ
	|	НастройкиНумерацииДоговоровКонтрагентов.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|	И НастройкиНумерацииДоговоровКонтрагентов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоров.ПустаяСсылка)
	|	И НастройкиНумерацииДоговоровКонтрагентов.КатегорияДоговора = &КатегорияДоговора
	|	И НастройкиНумерацииДоговоровКонтрагентов.Организация = &Организация
	|	И НЕ НастройкиНумерацииДоговоровКонтрагентов.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА НастройкиНумерацииДоговоровКонтрагентов.РучнаяНумерация
	|			ТОГДА 3
	|		ИНАЧЕ 4
	|	КОНЕЦ,
	|	НастройкиНумерацииДоговоровКонтрагентов.Ссылка,
	|	НастройкиНумерацииДоговоровКонтрагентов.РучнаяНумерация,
	|	""по договору""
	|ИЗ
	|	Справочник.НастройкиНумерацииДоговоровКонтрагентов КАК НастройкиНумерацииДоговоровКонтрагентов
	|ГДЕ
	|	НастройкиНумерацииДоговоровКонтрагентов.Договор = &Договор
	|	И НастройкиНумерацииДоговоровКонтрагентов.Договор <> ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|	И НастройкиНумерацииДоговоровКонтрагентов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоров.ПустаяСсылка)
	|	И НастройкиНумерацииДоговоровКонтрагентов.КатегорияДоговора = ЗНАЧЕНИЕ(Справочник.КатегорииДоговоров.ПустаяСсылка)
	|	И НастройкиНумерацииДоговоровКонтрагентов.Организация = &Организация
	|	И НЕ НастройкиНумерацииДоговоровКонтрагентов.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА НастройкиНумерацииДоговоровКонтрагентов.РучнаяНумерация
	|			ТОГДА 5
	|		ИНАЧЕ 6
	|	КОНЕЦ,
	|	НастройкиНумерацииДоговоровКонтрагентов.Ссылка,
	|	НастройкиНумерацииДоговоровКонтрагентов.РучнаяНумерация,
	|	""по виду договора""
	|ИЗ
	|	Справочник.НастройкиНумерацииДоговоровКонтрагентов КАК НастройкиНумерацииДоговоровКонтрагентов
	|ГДЕ
	|	НастройкиНумерацииДоговоровКонтрагентов.Организация = &Организация
	|	И НастройкиНумерацииДоговоровКонтрагентов.ВидДоговора = &ВидДоговора
	|	И НастройкиНумерацииДоговоровКонтрагентов.ВидДоговора <> ЗНАЧЕНИЕ(Перечисление.ВидыДоговоров.ПустаяСсылка)
	|	И НастройкиНумерацииДоговоровКонтрагентов.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|	И НастройкиНумерацииДоговоровКонтрагентов.КатегорияДоговора = ЗНАЧЕНИЕ(Справочник.КатегорииДоговоров.ПустаяСсылка)
	|	И НЕ НастройкиНумерацииДоговоровКонтрагентов.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА НастройкиНумерацииДоговоровКонтрагентов.РучнаяНумерация
	|			ТОГДА 7
	|		ИНАЧЕ 8
	|	КОНЕЦ,
	|	НастройкиНумерацииДоговоровКонтрагентов.Ссылка,
	|	НастройкиНумерацииДоговоровКонтрагентов.РучнаяНумерация,
	|	""по организации""
	|ИЗ
	|	Справочник.НастройкиНумерацииДоговоровКонтрагентов КАК НастройкиНумерацииДоговоровКонтрагентов
	|ГДЕ
	|	НастройкиНумерацииДоговоровКонтрагентов.Организация = &Организация
	|	И НастройкиНумерацииДоговоровКонтрагентов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоров.ПустаяСсылка)
	|	И НастройкиНумерацииДоговоровКонтрагентов.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|	И НастройкиНумерацииДоговоровКонтрагентов.КатегорияДоговора = ЗНАЧЕНИЕ(Справочник.КатегорииДоговоров.ПустаяСсылка)
	|	И НЕ НастройкиНумерацииДоговоровКонтрагентов.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	
	Запрос.УстановитьПараметр("Договор", Объект.Родитель);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ВидДоговора", Объект.ВидДоговора);
	Запрос.УстановитьПараметр("КатегорияДоговора", Объект.КатегорияДоговора);
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Выборка.Следующий() Тогда
		Возврат Новый Структура("Ссылка, Наименование, РучнаяНумерация", Выборка.Ссылка, Выборка.Наименование, Выборка.РучнаяНумерация);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
