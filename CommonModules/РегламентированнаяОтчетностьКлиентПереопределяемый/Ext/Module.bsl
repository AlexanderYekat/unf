﻿
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ МЕХАНИЗМА РАСШИФРОВКИ
//

// Процедура выводит форму расшифровки.
//
// Параметры:
//	ИДОтчета - Строка - идентификатор отчета (совпадает с именем объекта метаданных).
// 	ИДРедакцииОтчета - Строка - идентификатор редакции формы отчета (совпадает с именем формы объекта метаданных).
//  ИДИменПоказателей - Массив - массив идентификаторов имен показателей, по которым формируется расшифровка.
//  ПараметрыОтчета - Структура - структура параметров отчета, необходимых для формирования расшифровки.
// 
// Пример:
// 	Если ИДОтчета = "РегламентированныйОтчетБухОтчетность" Тогда
//		Если ИДРедакцииОтчета = "ФормаОтчета2011Кв1" Тогда
//			ОткрытьРасшифровкуБухОтчетностьФормаОтчета2011Кв1(ИДИменПоказателей, ПараметрыОтчета);
//		КонецЕсли;
// 	КонецЕсли;
//
Процедура ОткрытьРасшифровкуОтчета(ИДОтчета, ИДРедакцииОтчета, ИДИменПоказателей, ПараметрыОтчета) Экспорт
	
	ФормаРасшифровки = Неопределено;  
	
	Если ИДОтчета = "РегламентированныйОтчет6_НДФЛ" Тогда
		ФормаРасшифровки = РегламентированнаяОтчетностьУСНКлиент.ФормаРасшифровкиРегламентированногоОтчета(ИДОтчета, ИДРедакцииОтчета, ИДИменПоказателей, ПараметрыОтчета)
	КонецЕсли;
	
	Если ФормаРасшифровки = Неопределено Тогда
		ПоказатьПредупреждение(, 
		НСтр("ru='Для выбранной ячейки расшифровка не существует.'"),,
		НСтр("ru = 'Расшифровка регламентированных отчетов'"));
	Иначе
		ФормаРасшифровки.Открыть();
	КонецЕсли;

КонецПроцедуры

Процедура ОткрытьФормуПомощникаПоУчетуНДС(ПараметрыОткрытияПомощника) Экспорт
	
КонецПроцедуры

// Выполняет действия по интерактивному заполнению лиц, ответственных за подписание статистических
// (и, возможно, других) отчетов. Вызывается из контекста формы отчета.
//
// Параметры:
//	 Параметры - Структура - структура со свойствами:
//     * Организация - Справочник.Организации - организация рег. отчета.
//	   * ОбособленноеПодразделение - Справочник.Подразделение - подразделение (если есть на форме).
//	   * ДатаПодписи - Дата - дата подписи отчета.
//	   * ИмяОбъектаМетаданных - Строка - имя метаданных отчета.
//	   * ТекущееПоле - Строка - текущее поле для настройки
//							    (ФИОПодписантСтатистика, ДолжностьПодписантСтатистика,
//								 ТелефонПодписантСтатистика, ЕмейлПодписантСтатистика).
//								Состав полей может быть расширен при необходимости.
//	  ОповещениеОбОкончании - ОписаниеОповещения - вызывается после настройки подписантов (с новыми данными).
//												   В качестве параметров передается структура,
//												   в которой могут быть свойства (состав свойств может быть
//												   расширен при необходимости):
//	    * ФИОПодписантСтатистика - Строка - ФИО подписанта.
//		* ДолжностьПодписантСтатистика - Строка - должность подписанта.
//		* ТелефонПодписантСтатистика - Строка - телефон подписанта.
//		* ЕмейлПодписантСтатистика - Строка - эл. почта подписанта.
//							
// Пример реализации:
//	 ПараметрыВыбранного = Новый Структура;
//	 ... // действия по открытию форм (например, регистра ответственных лиц)
//	 ... // получение актуальных данных (например, пользователь изменил телефон ответственного) подписантов и т.п.
//	 ... // заполнение ПараметрыВыбранного актуальными данными
//	 ВыполнитьОбработкуОповещения(ОповещениеОбОкончании, ПараметрыВыбранного);
//
Процедура ОткрытьФормуНастройкиПодписантов(Параметры, ОповещениеОбОкончании) Экспорт
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ КАЛЕНДАРЯ БУХГАЛТЕРА
//

// Функция возвращает имя формы, используемой для уплаты налога.
// 
// Пример:
//  Возврат "Документ.ПлатежноеПоручение.ФормаОбъекта";
//
Функция ИмяФормыДляУплатыНалога() Экспорт
	
КонецФункции

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ СПИСКА ЗАДАЧ БУХГАЛТЕРА
//

// Процедура открывает форму списка задач бухгалтера.
//
Процедура ОткрытьКалендарь(Владелец, Организация, СтандартнаяОбработка) Экспорт
			
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ИНТЕРФЕЙСА ВЗАИМОДЕЙСТВИЯ С КОНФИГУРАЦИЯМИ (БИБЛИОТЕКАМИ) - ПОТРЕБИТЕЛЯМИ
//

// Процедура переопределяет создание формы РСВ-1 из списка регламентированных отчетов.
//
// Параметры:
//  ОписаниеРСВ_1            - структура с полями:
//   Организация             - организация;
//   ДатаНачалаПериодаОтчета - дата;
//   ДатаКонцаПериодаОтчета  - дата;
//   КорректирующаяФорма     - булево;
//  СтандартнаяОбработка     - булево.
//
Процедура ПриСозданииРСВ_1ИзСпискаРеглОтчетов(ОписаниеРСВ_1, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// Процедура переопределяет открытие формы РСВ-1 из журнала регламентированных отчетов.
//
// Параметры:
//  Ссылка                   - ссылка на регламентированный отчет;
//  ОписаниеРСВ_1            - структура с полями:
//   Организация             - организация;
//   ДатаНачалаПериодаОтчета - дата;
//   ДатаКонцаПериодаОтчета  - дата;
//   КорректирующаяФорма     - булево;
//  СтандартнаяОбработка     - булево.
//
Процедура ПриОткрытииРСВ_1ИзЖурналаРеглОтчетов(Ссылка, ОписаниеРСВ_1, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// Процедура переопределяет поведение при печати формы РСВ-1 из журнала регламентированных отчетов.
//
// Параметры:
//  Ссылка                   - ссылка на регламентированный отчет;
//  ОписаниеРСВ_1            - структура с полями:
//   Организация             - организация;
//   ДатаНачалаПериодаОтчета - дата;
//   ДатаКонцаПериодаОтчета  - дата;
//   КорректирующаяФорма     - булево;
//  СтандартнаяОбработка     - булево.
//
Процедура ПриПечатиРСВ_1ИзЖурналаРеглОтчетов(Ссылка, ОписаниеРСВ_1, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// Процедура переопределяет поведение при выгрузке формы РСВ-1 из журнала регламентированных отчетов.
//
// Параметры:
//  Ссылка                   - ссылка на регламентированный отчет;
//  ОписаниеРСВ_1            - структура с полями:
//   Организация             - организация;
//   ДатаНачалаПериодаОтчета - дата;
//   ДатаКонцаПериодаОтчета  - дата;
//   КорректирующаяФорма     - булево;
//  СтандартнаяОбработка     - булево.
//
Процедура ПриВыгрузкеРСВ_1ИзЖурналаРеглОтчетов(Ссылка, ОписаниеРСВ_1, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// Процедура переопределяет поведение при проверке выгрузки формы РСВ-1 из журнала регламентированных отчетов.
//
// Параметры:
//  Ссылка                   - ссылка на регламентированный отчет;
//  ОписаниеРСВ_1            - структура с полями:
//   Организация             - организация;
//   ДатаНачалаПериодаОтчета - дата;
//   ДатаКонцаПериодаОтчета  - дата;
//   КорректирующаяФорма     - булево;
//  СтандартнаяОбработка     - булево.
//
Процедура ПриПроверкеВыгрузкиРСВ_1ИзЖурналаРеглОтчетов(Ссылка, ОписаниеРСВ_1, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// Процедура открывает форму с информацией об изменениях.
//
// Параметры:
//  ИмяОтчета - Строка - имя отчета в дереве объектов метаданных;
//  ИмяФормы  - Строка - имя формы отчета;
//  Форма     - УправляемаФорма - форма, из которой вызывается процедура.
//
Процедура ПредупредитьОбИзменениях(ИмяОтчета, ИмяФормы, Форма) Экспорт
	
КонецПроцедуры

// Процедура изменяет признак вывода предупреждения об изменениях.
//
// Параметры:
//  ИмяОтчета - Строка - имя отчета в дереве объектов метаданных;
//  ИмяФормы  - Строка - имя формы отчета;
//  ТребуетсяПредупредитьОбИзменениях - Булево - признак вывода предупреждения об изменениях;
//  Форма     - УправляемаФорма - форма, из которой вызывается процедура.
//
Процедура ИзменитьПризнакВыводаПредупрежденияОбИзменениях(ИмяОтчета, ИмяФормы, ТребуетсяПредупредитьОбИзменениях, Форма) Экспорт
	
КонецПроцедуры

// Если требуются какие-то особые действия при открытии уведомления надо выставить СтандартнаяОбработка = Ложь
// В этом случае уведомление не создается, а требуемые действия можно проделать в процеакгыедуре ОбработчикСозданияУведомления(...)
//
// Параметры:
//   Организация          - СправочникСсылка.Организации - ссылка на элемент справочника организаций.
//   ВидУведомления       - Перечисление.ВидыУведомленийОСпецрежимахНалогообложения - вид уведомления.
//   СтандартнаяОбработка - Булево - признак стандартной обработки.
//
Процедура ПередОткрытиемФормыУведомления(Организация, ВидУведомления, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// При переопределенном действии при создании уведомления здесь прописывается что именно надо сделать
//
// Параметры:
//   Форма - Форма - форма 1с-отчетности.
//   Параметр - Структура - "Организация", "ВидУведомления".
//
Процедура ОбработчикСозданияУведомления(Форма, Параметр) Экспорт
	
КонецПроцедуры

// Процедура уточняет данные для автозаполнения уведомления.
//
// Параметры:
//  ИДОтчета                 - Строка - имя отчета в дереве объектов метаданных
//  ПараметрыОтчета          - Структура обязательных параметров
//  ФормаОтчета              - УправляемаФорма - ссылка на заполняемую форму уведомления
//  ОписаниеОповещения       - процедура для продолжения процедуры автозаполнения
//  СтандартнаяОбработка     - Булево, если Истина то никакой новой информации не 
//                           добавляется для автозаполнения, необходимо продолжить автозаполнение в самой форме
//
Процедура ПередЗаполнениемОтчета(ИДОтчета, ПараметрыОтчета, ФормаОтчета, ОписаниеОповещения, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Процедура переопределяет вывод дополнительной информации о регламентированном отчете
//
// Параметры:
//  Ссылка                    - ссылка на регламентированный отчет.
//  ИмяФормыПодробнееОбОтчете - Строка, имя формы, которая будет открыта с параметром "Ссылка" для предоставления
//                              дополнительной информации об отчете.
//  СтандартнаяОбработка      - Булево, если Истина - будет открыта форма по имени:
//                                                    "Обработка.ОбщиеОбъектыРеглОтчетности.Форма." + ИмяФормыПодробнееОбОтчете;
//                                                    иначе - можно выполнить свой алгоритм обработки ПодробнееОбОчете()
//
Процедура ПодробнееОбОчете(Ссылка, ИмяФормыПодробнееОбОтчете, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции
//

// Процедура открывает форму выбора кода по ОКВЭД.
//
// Параметры:
//  ВыполняемоеОповещение - ОписаниеОповещения - описание оповещения, которое будет вызвано после выполнения
//  						 данной операции.
//  						 Дополнительные параметры передаются в свойстве ДополнительныеПараметры описания оповещения -
//  						 Структура - структура с полями:
//  						   * ВариантОКВЭД (обязателен)   - Строка - вариант классификатора ("ОКВЭД" или "ОКВЭД2");
//  						   * ТекущийКод   (необязателен) - Строка - код по ОКВЭД (для позиционирования в списке выбора).
//  						 Возвращаемый результат выбора - Структура - структура с полями (обязательными):
//  						   * КодОКВЭД          - Строка - код по ОКВЭД;
//  						   * НаименованиеОКВЭД - Строка - наименование по ОКВЭД.
//  СтандартнаяОбработка  - Булево - признак выполнения ВыполняемоеОповещение.
//  						 Если выполняется - необходимо установить Ложь. Значение по умолчанию - Истина.
//
// Пример:
//  СтандартнаяОбработка = Ложь;
//  ПараметрыФормы = Новый Структура;
//  ПараметрыФормы.Вставить("ТипОбъекта",      "Справочник");
//  ПараметрыФормы.Вставить("НазваниеОбъекта", "Организации");
//  ПараметрыФормы.Вставить("НазваниеМакета",  ВыполняемоеОповещение.ДополнительныеПараметры.ВариантОКВЭД);
//  Если ВыполняемоеОповещение.ДополнительныеПараметры.Свойство("ТекущийКод") Тогда
//  	ПараметрыФормы.Вставить("ТекущийКод", ВыполняемоеОповещение.ДополнительныеПараметры.ТекущийКод);
//  КонецЕсли;
//  ПараметрыФормы.Вставить("ТекущийПериод", ТекущаяДата());
//  ПараметрыФормы.Вставить("Комментарий",   "");
//  ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораКодаПоОКВЭДЗавершение",
//  ОбщегоНазначенияКлиент.ОбщийМодуль("РегламентированнаяОтчетностьКлиентПереопределяемый"),
//  ВыполняемоеОповещение);
//  ОткрытьФорму("ОбщаяФорма.ФормаВыбораКода", ПараметрыФормы,,,,, ОписаниеОповещения);
//
// Пример процедуры "ОткрытьФормуВыбораКодаПоОКВЭДЗавершение" (служебного интерфейса):
//  Процедура ОткрытьФормуВыбораКодаПоОКВЭДЗавершение(РезультатВыбора, ВыполняемоеОповещение) Экспорт
//  	Если ТипЗнч(РезультатВыбора) = Тип("Строка") Тогда
//  		ОКВЭД = ОбщегоНазначенияБПВызовСервера.ПолучитьКлассификатор(
//  		ВыполняемоеОповещение.ДополнительныеПараметры.ВариантОКВЭД);
//  		ВозвращаемыйРезультат = Новый Структура(
//  		"КодОКВЭД, НаименованиеОКВЭД", РезультатВыбора, ОКВЭД.Получить(РезультатВыбора));
//  		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, ВозвращаемыйРезультат);
//  	КонецЕсли;
//  КонецПроцедуры
//
Процедура ОткрытьФормуВыбораКодаПоОКВЭД(ВыполняемоеОповещение, СтандартнаяОбработка = Истина) Экспорт
	
КонецПроцедуры

// Процедура вызывается в формах отчета "РегламентированныйОтчетРСВ1"
// при нажатии кнопки перехода в специализированное рабочее место подготовки
// отчетности в ПФР.
//
Процедура ПерейтиВРабочееМестоПФР(Организация, ДатаНачалаПериодаОтчета, ДатаКонцаПериодаОтчета) Экспорт
			
КонецПроцедуры

// Процедура выполняет назначаемую команду формы.
//
// Параметры:
//   Форма - форма, из которой вызвана команда.
//
Процедура ВыполнитьНазначаемуюКомандуНаКлиенте(Форма) Экспорт
	
КонецПроцедуры

// Процедура выполняет назначаемую команду формы "РегламентированнаяОтчетность".
//
// Параметры:
//   Форма   - Форма, из которой вызвана команда.
//   Команда - КомандаФормы, назначенная команда формы.
//
// Пример:
//   Если Команда.Имя = "ОтчетыПоказатьДополнительнуюИнформацию" Тогда
//   	ПоказатьПредупреждение(, НСтр("ru = 'Заполните обработчик команды '")"" + Команда.Имя + """");
//   КонецЕсли;
//
Процедура ФормаРегламентированнойОтчетности_ВыполнитьНазначаемуюКомандуНаКлиенте(Форма, Команда) Экспорт
	
КонецПроцедуры

// Процедура переопределяет имя формы выбора периода для установки отбора в форме "1С Отчетность".
//
// Параметры:
//  ПолноеИмяФормыВыбораПериода  - Строка - Полный путь к форме выбора периода.
//
// Пример:
//  ПолноеИмяФормыВыбораПериода = "ОбщаяФорма.ВыборПроизвольногоПериода";
//
Процедура ФормаРегламентированнойОтчетности_ИмяФормыВыбораПериода(ПолноеИмяФормыВыбораПериода) Экспорт
	
КонецПроцедуры

// Процедура переопределяет имя и параметры открытия формы выбора отчета для установки отбора в форме "1С Отчетность".
//
// Параметры:
//  ПолноеИмяФормыВыбораВидаОтчета - Строка - Полный путь к форме выбора вида отчета.
//  ПараметрыФормыВыбораВидаОтчета - Структура - Параметры открытия формы выбора вида отчета.
//
// Пример:
//  ПолноеИмяФормыВыбораВидаОтчета = "ОбщаяФорма.ФормаПодбораЗначенийВСписок";
//
Процедура ФормаРегламентированнойОтчетности_ОпределениеФормыВыбораВидаОтчета(ПолноеИмяФормыВыбораВидаОтчета,
																			 ПараметрыФормыВыбораВидаОтчета) Экспорт
	
КонецПроцедуры


// Процедура проверяет, выполнялась ли ранее настройка автозаполнения.
//
// Параметры:
//   ПараметрыОтчета                        - Структура 
//   ВыполняемоеОповещение                  - ОписаниеОповещения - Описание оповещения, которое будет вызвано после
//                                                       выполнения данной операции. В качестве результата описания
//                                                       оповещения должно передаваться булево значение, от которого
//                                                       зависит будет ли выполнятся дальнейший код в процедуре, которая
//                                                       вызвала этот метод.
//
Процедура ПроверитьНастройкиЗаполненияОтчета(ПараметрыОтчета, ВыполняемоеОповещение) Экспорт
	
КонецПроцедуры	

// Процедура проверяет, выполнялась ли ранее настройка автозаполнения.
//
// Параметры:
//   ПараметрыОтчета       - Структура - параметры регл. отчета.
//   ВыполняемоеОповещение - ОписаниеОповещения - Описание оповещения, которое будет вызвано после выполнения данной
//											 	  операции. В качестве результата описания оповещения должно
//												  передаваться булево значение, от которого зависит будет ли выполнятся
//												  дальнейший код в процедуре, которая вызвала этот метод.
//   СтандартнаяОбработка  - Булево - по умолчанию Истина. Если потребитель будет совершать какие-то действия
//														   с последующим выполнением ОписаниеОповещения необходимо
//														   выставить флажок в Ложь.
//
Процедура ПроверитьНастройкиАвтозаполненияОтчета(ПараметрыОтчета, ВыполняемоеОповещение, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры


// Процедура открывает форму настройки автозаполнения.
//
Процедура ОткрытьФормуНастройкиАвтозаполнения(ПараметрыФормы) Экспорт
             	
КонецПроцедуры

// Процедура реализует печать объектов, отображаемых на закладке Отчеты и Уведомления формы Отчетность
// Параметры
//	Ссылка - СправочникСсылка, ДокументСсылка - Ссылка на объект, который необходимо напечатать
//		Если для данного объекта печать невозможна - нужно выдавать соотвествующее предупрежедние
//	ИмяМакетаДляПечати - Строка - имя макета для печати, при использовании которого необходимо распечатать объект
//		Если ИмяМакетаДляПечати пустое, то для печати использовать основной макет
//	СтандартнаяОбработка - Булево - Если СтандартнаяОбработка = Истина, то будет выполнена печать с помощью подсистемы печати из БСП. 
Процедура Печать(Ссылка, ИмяМакетаДляПечати, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Процедура реализует выгрузку объектов, отображаемых на закладке Отчеты и Уведомления формы Отчетность
// Параметры
//	Ссылка - СправочникСсылка, ДокументСсылка - Ссылка на объект, который необходимо выгрузить
// Если для данного объекта выгрузка невозможна - нужно выдавать соотвествующее предупрежедние
//
Процедура Выгрузить(Ссылка, УникальныйИдентификаторФормы = Неопределено) Экспорт
	
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.СправкиНДФЛДляПередачиВНалоговыйОрган") Тогда
		ИмяФайла = СправкиПоНДФЛ.ПолучитьИмяФайлаНДФЛ(Ссылка)+".XML";
		АдресФайла = СправкиПоНДФЛ.СохранитьФайлВыгрузкиСправки2НДФЛ(Ссылка);
		ПолучитьФайл(АдресФайла, ИмяФайла, Истина);
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЖурналУчетаСчетовФактур") Тогда
		
		УникальныйИдентификаторЖурнала = Новый УникальныйИдентификатор;
		ВыгружаемыеДанные = РегламентированнаяОтчетностьУСНВызовСервера.ПолучитьВыгружаемыеДанныеЖурналаУчетаСчетовФактур(
			Ссылка, 
			УникальныйИдентификаторЖурнала);
			
		РегламентированнаяОтчетностьУСНКлиент.СохранитьФайлВыгрузкиНаКлиенте(ВыгружаемыеДанные);
		
	КонецЕсли;	
	
КонецПроцедуры

// Процедура реализует создание объектов, отображаемых на закладке Уведомления и Отчетность формы Отчетность, не
// входящие в состав БРО Параметры
//	Организация - СправочникСсылка.Организации - Организация, по которой нужно создать объект
//  Тип  - Тип - Тип объекта, который необходимо создать
//  СтандартнаяОбработка - Булево - Если СтандартнаяОбработка = Истина, то будет выполнено создание объекта стандартным образом
Процедура СоздатьНовыйОбъект(Организация, Тип, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Процедура открывает окно выбора обособленных подразделений в случае, когда стандартный механизм 
// по каким-либо причинам не может быть использован
// Вызывается из форм статистики (ЗП-*, П-4 и некоторых других)
// В качестве callback-процедуры следует использовать РегламентированнаяОтчетностьКлиент.ОбработкаВыбораОбособленногоПодразделения
// Параметры
//  Форма - форма отчета откуда открывается выбор подразделения
//  СтандартнаяОбработка - если отработано необходимо выставить СтандартнаяОбработка = Ложь
// Пример для ЗУП 3.0 КОРП
//  Там форма выбора это форма списка с параметром открытия РежимВыбора = Истина
//  СтандартнаяОбработка = Ложь;
//  Отбор = Новый Структура("Владелец, ИмеетНомерТерриториальногоОрганаРосстата",
//  Форма.СтруктураРеквизитовФормы.Организация, Истина); Параметры = Новый Структура("Отбор, РежимВыбора", Отбор, Истина);
//  ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработкаВыбораОбособленногоПодразделения",
//  РегламентированнаяОтчетностьКлиент, Новый Структура("Форма", Форма)); ОткрытьФорму("Справочник.ПодразделенияОрганизаций.ФормаВыбора",Параметры,Форма,,,,ОповещениеОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
//
Процедура ОбработкаВыбораПоляОбособленныхПодразделений(Форма, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Процедура определяет, открывать или нет из формы "1С-Отчетность" файлы, присоединенные к объекту.
//
// Параметры:
//  ПараметрыПроверки - Структура:
//   "Владелец"             - СправочникСсылка, ДокументСсылка - ссылка на объект;
//   "ТекстПредупреждения"  - Строка - если заполнен и СтандартнаяОбработка = Ложь, то будет выведено предупреждение;
//   "СтандартнаяОбработка" - Булево - если Ложь, открытие присоединенных файлов не выполняется.
//
// Пример:
//  Если ТипЗнч(ПараметрыПроверки.Владелец) = Тип("СправочникСсылка.МакетыПенсионныхДел") Тогда
//  	
//  	ПараметрыПроверки.СтандартнаяОбработка = Ложь;
//  	
//  	ПараметрыПроверки.ТекстПредупреждения = НСтр(
//  	"ru='Присоединение файлов к ""Макетам пенсионных дел"" из списка отчетов не предусмотрено'");
//  	
//  КонецЕсли;
//
Процедура ПроверитьВладельцаПриОткрытииПрисоединенныхФайловИзСпискаОтчетов(ПараметрыПроверки) Экспорт
	
КонецПроцедуры

// Открывает форму закрытия месяца.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - ссылка на элемент справочника "Организации".
//  ПериодРегистрации - Дата - закрываемый период.
//
// Пример реализации:
//  ПараметрыФормы = Новый Структура;
//  ПараметрыФормы.Вставить("Организация", Организация);
//  ПараметрыФормы.Вставить("ПериодРегистрации", ПериодРегистрации);
//  ОткрытьФорму("Обработка.ЗакрытиеМесяца.Форма.Форма", ПараметрыФормы, ЭтотОбъект);
//
Процедура ОткрытьФормуЗакрытияМесяца(Организация, ПериодРегистрации) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("ПериодРегистрации", ПериодРегистрации);
	ОткрытьФорму("Обработка.ЗакрытиеМесяца.Форма.Форма", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

// Дополняет функционал обработчика "ОбработкаОповещения" общей формы "Регламентированная отчетность",
// здесь можно добавить новую функциональность к существующей обработке оповещения.
//
// Параметры:
//  ИмяСобытия - Строка - Имя события может быть использовано для идентификации сообщений принимающими их формами.
//  Параметр   - Параметр сообщения. Могут быть переданы любые необходимые данные.
//  Источник   - Источник события. Например, в качестве источника может быть указана другая форма.
//  Форма      - ФормаКлиентскогоПриложения - Общая форма "Регламентированная отчетность".
//
// Пример:
//  Если ИмяСобытия = "Получены новые сообщения 1С-Отчетности" И Источник <> Форма Тогда
//      Оповестить("Закрыть форму новых сообщений 1С-Отчетности",, Форма);
//  КонецЕсли;
//
Процедура ФормаРегламентированнойОтчетности_ОбработкаОповещения(ИмяСобытия, Параметр, Источник, Форма) Экспорт
	
КонецПроцедуры

// Процедура открывает форму для заполнения регистрирующего органа организации.
//
// Параметры:
//  Организация           - СправочникСсылка.Организации - ссылка на элемент справочника организаций.
//  ВыполняемоеОповещение - ОписаниеОповещения - описание оповещения, которое будет вызвано после выполнения
//                          данной операции.
//
// Пример:
//  ПараметрыФормы = Новый Структура;
//  ПараметрыФормы.Вставить("Ключ", Организация);
//  ОткрытьФорму("Справочник.Организации.Форма.ФормаОрганизации", ПараметрыФормы,,,,, ВыполняемоеОповещение);
//
Процедура ОткрытьФормуДляЗаполненияРегистрирующегоОргана(Организация, ВыполняемоеОповещение) Экспорт
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Организация);
	ОткрытьФорму("Справочник.Организации.Форма.ФормаЭлемента", ПараметрыФормы,,,,, ВыполняемоеОповещение);
КонецПроцедуры

// Процедура открывает форму настроек непосредственно перед автозаполнением регламентированного отчета
// (например, сразу после нажатия кнопки "Заполнить" в форме регламентированного отчета), если в последнем
// поддерживается такая возможность.
//
// Параметры:
//  ВыполняемоеОповещение - ОписаниеОповещения - описание оповещения, которое будет вызвано после выполнения
//                          данной операции.
//                          Параметры передаются в свойстве ДополнительныеПараметры описания оповещения -
//                          Структура - структура с проивольными полями, позволяющими идентифицировать отчет.
//                          Возвращаемый результат - Структура - структура с полями (обязательно одно из полей):
//                            * НастройкиАвтозаполнения - Структура - параметы автозаполнения, которые будут переданы
//                                                        в свойстве "НастройкиАвтозаполнения" параметров отчета
//                                                        процедуры "ЗаполнитьОтчет" общего модуля
//                                                        "РегламентированнаяОтчетностьПереопределяемый";
//                            * ТекстПриОтказе - Строка - текст для выдачи предупреждения и прерывания автозаполнения.
//
// Пример (перед автозаполнением отчета "РегламентированныйОтчетДвижениеСредствПоСчетуВБанкеЗаПределамиРФ"):
//  ПараметрыОповещения = Новый Структура;
//  ПараметрыОповещения.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
//  ОповещениеОВыборе = Новый ОписаниеОповещения("ОткрытьФормуВыбораСчетаЗавершение", ЭтотОбъект, ПараметрыОповещения);
//  ДополнительныеПараметры = ВыполняемоеОповещение.ДополнительныеПараметры;
//  Организация = ДополнительныеПараметры.Организация;
//  СписокИностранныхБанков = УчетДенежныхСредствВызовСервера.СписокИностранныхБанков();
//  НастройкиКомпоновки = Новый НастройкиКомпоновкиДанных;
//  ЭлементОтбора = НастройкиКомпоновки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
//  ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Банк");
//  ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
//  ЭлементОтбора.Использование  = Истина;
//  ЭлементОтбора.ПравоеЗначение = СписокИностранныхБанков;
//  ПараметрыОтбора = Новый Структура;
//  ПараметрыОтбора.Вставить("Владелец", Организация);
//  ПараметрыФормы = Новый Структура;
//  ПараметрыФормы.Вставить("ФиксированныеНастройки", НастройкиКомпоновки);
//  ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
//  ПараметрыФормы.Вставить("РежимВыбора", Истина);
//  ОткрытьФорму("Справочник.БанковскиеСчета.ФормаВыбора", ПараметрыФормы,,,,, ОповещениеОВыборе);
//
Процедура ОткрытьФормуНастроекПередАвтозаполнениемРеглОтчета(ВыполняемоеОповещение) Экспорт
	
КонецПроцедуры

// Проверяет возможность автоматического заполнения регламентированного отчета по данным ИБ конфигурации.
//
// Параметры:
//  ИмяФормы - Строка - имя формы регламентированного отчета;
//  Отказ - Булево - признак отказа от автозаполнения регл. отчета.
//
// Пример реализации:
//  Если НЕ ТарификацияБПВызовСервераПовтИсп.РазрешенУчетРегулярнойДеятельности() Тогда
//  	ТарификацияБПКлиент.ОповеститьОбОграниченииТарифа(ИмяФормы + ".ЗаполнитьАвто");
//      Отказ = Истина;
//  КонецЕсли;
//
Процедура ПроверитьВозможностьАвтоЗаполненияРеглОтчета(ИмяФормы, Отказ) Экспорт
	
	
КонецПроцедуры

// Открывает форму для интерактивного выбора контрактов и дальнейшего помещения по адресу во временном хранилище
// коллекции реквизитов, идентифицирующих контракты, используемой для выборочного заполнения отчета
// "РегламентированныйОтчетИсполнениеКонтрактовГОЗ".
//
// Параметры:
//  Организация                        - СправочникСсылка.Организации - ссылка на элемент справочника "Организации".
//  ДатаСоставленияОтчета              - Дата - дата составления отчета "РегламентированныйОтчетИсполнениеКонтрактовГОЗ".
//  АдресВоВременномХранилищеКонтракты - Строка - адрес во временном хранилище, по которому надо поместить коллекцию
//                                       (возможны типы значений коллекции: Массив, ТаблицаЗначений, ДеревоЗначений,
//                                       Структура) реквизитов, идентифицирующих контракты (возможны простые типы
//                                       значений реквизитов).
//
// Пример реализации:
//  ОткрытьФорму("Отчет.ИсполнениеКонтрактовГОЗ.Форма.ФормаВыбораКонтрактов", СтруктураПараметров);
//
Процедура ОткрытьФормуВыбораСпискаКонтрактов(СтруктураПараметров) Экспорт
	
КонецПроцедуры

Процедура ОткрытьФормуПредпросмотраОтчетов(Форма, Заголовок) Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Заголовок", Заголовок);
	ПараметрыОткрытия.Вставить("Результат", РегламентированнаяОтчетностьУСН.АдресХранилищаТабличногоДокумента(Форма.ТабличныйДокумент, Форма.УникальныйИдентификатор));
	ОткрытьФорму("ОбщаяФорма.ФормаПредпросмотраОтчета", ПараметрыОткрытия, Форма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму выбора контрагента.
//
// Параметры:
//  Владелец - УправляемаяФорма - форма, в которой осуществляется выбор контрагента;
//  ВыполняемоеОповещение - ОписаниеОповещения - описание оповещения, которое будет вызвано после завершения
//   работы с формой выбора.
//
// Пример реализации:
//  ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора", ,
//   Владелец, , , , ВыполняемоеОповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
//
Процедура ОткрытьФормуВыбораКонтрагента(Владелец, ВыполняемоеОповещение) Экспорт
	ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора", ,
		Владелец, , , , ВыполняемоеОповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти
