﻿
#Область СлужебныеПроцедурыИФункции

Функция ОтветственныеЛицаОрганизации(Организация, Сведения, ДатаСведений) Экспорт
	
	Возврат ЗарплатаКадрыБазовый.ОтветственныеЛицаОрганизации(Организация, Сведения, ДатаСведений);
	
КонецФункции

Функция УсловияЗапросаПроверкиНеобходимостиЗаполненияПодчиненныхПодразделений(Запрос, ИсточникДанных) Экспорт
	
	Возврат ЗарплатаКадрыБазовый.УсловияЗапросаПроверкиНеобходимостиЗаполненияПодчиненныхПодразделений(Запрос, ИсточникДанных);

КонецФункции

Процедура ЗаполнитьПодчиненноеПодразделение(ПодразделениеОбъект, ИсточникДанных) Экспорт
	
	ЗарплатаКадрыБазовый.ЗаполнитьПодчиненноеПодразделение(ПодразделениеОбъект, ИсточникДанных);
		
КонецПроцедуры

Функция ЭтоОбъектЗарплатноКадровойБиблиотеки(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Возврат ЗарплатаКадрыБазовый.ЭтоОбъектЗарплатноКадровойБиблиотеки(ПолноеИмяОбъектаМетаданных);
	
КонецФункции

Функция ЭтоБазоваяВерсияКонфигурации() Экспорт
	Возврат ЗарплатаКадрыБазовый.ЭтоБазоваяВерсияКонфигурации();
КонецФункции

// См. ЗарплатаКадры.ИспользуютсяДокументыОплатыВедомостей.
Функция ИспользуютсяДокументыОплатыВедомостей() Экспорт
	Возврат ЗарплатаКадрыБазовый.ИспользуютсяДокументыОплатыВедомостей();
КонецФункции

Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
	
КонецПроцедуры

// Получает информацию о виде расчета.
Функция ПолучитьИнформациюОВидеРасчета(ВидРасчета) Экспорт
	
	Возврат ЗарплатаКадрыБазовый.ПолучитьИнформациюОВидеРасчета(ВидРасчета);
	
КонецФункции

// См. ЗарплатаКадры.ЗарегистрироватьОплатуВедомостей.
Процедура ЗарегистрироватьОплатуВедомостей(ПлатежныйДокумент, Организация, Ведомости, ФизическиеЛица = Неопределено, ДатаОперации = Неопределено, Отказ = Ложь) Экспорт
	ЗарплатаКадрыБазовый.ЗарегистрироватьОплатуВедомостей(ПлатежныйДокумент, Организация, Ведомости, ФизическиеЛица, ДатаОперации, Отказ);	
КонецПроцедуры

#Область БлокФункцийПолученияЗначенийПоУмолчанию

Процедура ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения, ДатаЗначений) Экспорт
	ЗарплатаКадрыБазовый.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения, ДатаЗначений);
КонецПроцедуры

// Массив поддерживаемых идентификаторов значений по умолчанию.
Функция СписокДоступныхЗначенийПоУмолчанию() Экспорт
	Возврат ЗарплатаКадрыБазовый.СписокДоступныхЗначенийПоУмолчанию();
КонецФункции

#КонецОбласти

#Область БазоваяФункциональность

Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	ЗарплатаКадрыБазовый.ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
КонецПроцедуры

#КонецОбласти

#Область БизнесПроцессыИЗадачи

Процедура ПриЗаполненииНаборовЗначенийДоступаБизнесПроцессовИЗадач(Объект, Таблица) Экспорт
	ЗарплатаКадрыБазовый.ПриЗаполненииНаборовЗначенийДоступаБизнесПроцессовИЗадач(Объект, Таблица);
КонецПроцедуры

#КонецОбласти

#Область ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.
Процедура ОпределитьОбъектыСКомандамиОтчетов(Объекты) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область Взаимодействия

Процедура ПриЗаполненииНаборовЗначенийДоступаВзаимодействий(Объект, Таблица) Экспорт
	ЗарплатаКадрыБазовый.ПриЗаполненииНаборовЗначенийДоступаВзаимодействий(Объект, Таблица);
КонецПроцедуры

#КонецОбласти

#Область Пользователи

Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	ЗарплатаКадрыБазовый.ПриОпределенииНазначенияРолей(НазначениеРолей)
КонецПроцедуры

#КонецОбласти

#Область ПрофилиБезопасности

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам.
//
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ДатыЗапретаИзмененияДанных

// См. ДатыЗапретаИзмененияПереопределяемый.ПриЗаполненииРазделовДатЗапретаИзменения.
Процедура ПриЗаполненииРазделовДатЗапретаИзменения(Разделы) Экспорт
	ЗарплатаКадрыБазовый.ПриЗаполненииРазделовДатЗапретаИзменения(Разделы);
КонецПроцедуры

// См. ДатыЗапретаИзмененияПереопределяемый.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения.
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	ЗарплатаКадрыБазовый.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных);
КонецПроцедуры

#КонецОбласти

#Область КалендарныеГрафики

Процедура ПриОбновленииПроизводственныхКалендарей(УсловияОбновления) Экспорт
	ЗарплатаКадрыБазовый.ПриОбновленииПроизводственныхКалендарей(УсловияОбновления)
КонецПроцедуры

Процедура ПриОбновленииДанныхЗависимыхОтПроизводственныхКалендарей(УсловияОбновления) Экспорт
	ЗарплатаКадрыБазовый.ПриОбновленииДанныхЗависимыхОтПроизводственныхКалендарей(УсловияОбновления)	
КонецПроцедуры

Процедура ПриЗаполненииИзменяемыхОбъектовЗависимыхОтПроизводственныхКалендарей(ИзменяемыеОбъекты) Экспорт
	ЗарплатаКадрыБазовый.ПриЗаполненииИзменяемыхОбъектовЗависимыхОтПроизводственныхКалендарей(ИзменяемыеОбъекты)
КонецПроцедуры
#КонецОбласти

#Область ПрефиксацияСправочниковПоОрганизации

Процедура ПолучитьПрефиксообразующиеРеквизиты(Объекты) Экспорт
	ЗарплатаКадрыБазовый.ПолучитьПрефиксообразующиеРеквизиты(Объекты);
КонецПроцедуры

#КонецОбласти

#Область РаботаСФайлами

Процедура ПриОпределенииСправочниковХраненияФайлов(ТипВладелецФайла, ИменаСправочников) Экспорт
	ЗарплатаКадрыБазовый.ПриОпределенииСправочниковХраненияФайлов(ТипВладелецФайла, ИменаСправочников);
КонецПроцедуры

#КонецОбласти

#Область СозданиеНаОсновании

// См. СозданиеНаОснованииПереопределяемый.ПриОпределенииОбъектовСКомандамиСозданияНаОсновании.
Процедура ПриОпределенииОбъектовСКомандамиСозданияНаОсновании(Объекты) Экспорт
	
	ЗарплатаКадрыБазовый.ПриОпределенииОбъектовСКомандамиСозданияНаОсновании(Объекты);
	
КонецПроцедуры

#КонецОбласти

#Область Свойства

// См. УправлениеСвойствамиПереопределяемый.ПриПолученииПредопределенныхНаборовСвойств.
Процедура ПриПолученииПредопределенныхНаборовСвойств(Наборы) Экспорт
	ЗарплатаКадрыБазовый.ПриПолученииПредопределенныхНаборовСвойств(Наборы);
КонецПроцедуры

// См. УправлениеСвойствамиПереопределяемый.ПриПолученииНаименованийНаборовСвойств.
Процедура ПриПолученииНаименованийНаборовСвойств(Наименования, КодЯзыка) Экспорт
	
КонецПроцедуры

// См. УправлениеСвойствамиПереопределяемый.ЗаполнитьНаборыСвойствОбъекта.
Процедура ЗаполнитьНаборыСвойствОбъекта(Объект, ТипСсылки, НаборыСвойств, СтандартнаяОбработка, КлючНазначения) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ЗапретРедактированияРеквизитовОбъектов

// См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами
//
Процедура ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты) Экспорт
	ЗарплатаКадрыБазовый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты)
КонецПроцедуры

#КонецОбласти

#Область КонтрольВеденияУчета

// См. КонтрольВеденияУчетаПереопределяемый.ПриОпределенииПроверок.
Процедура ПриОпределенииПроверок(ГруппыПроверок, Проверки) Экспорт
	ЗарплатаКадрыБазовый.ПриОпределенииПроверок(ГруппыПроверок, Проверки);
КонецПроцедуры

#КонецОбласти

#Область ЦентрМониторинга

// См. ЦентрМониторингаПереопределяемый.ПриСбореПоказателейСтатистикиКонфигурации.
Процедура ПриСбореПоказателейСтатистикиКонфигурации() Экспорт
	ЗарплатаКадрыБазовый.ПриСбореПоказателейСтатистикиКонфигурации();
КонецПроцедуры

#КонецОбласти

#Область НастройкиПрограммы

// См. НастройкиПрограммыПереопределяемый.НастройкиПользователейИПравПриСозданииНаСервере.
Процедура НастройкиПользователейИПравПриСозданииНаСервере(Форма) Экспорт
	
	ЗарплатаКадрыБазовый.НастройкиПользователейИПравПриСозданииНаСервере(Форма);
	
КонецПроцедуры

#КонецОбласти

#Область ТехнологияСервиса

Процедура ПриВключенииРазделенияПоОбластямДанных() Экспорт
	ЗарплатаКадрыБазовый.ПриВключенииРазделенияПоОбластямДанных();
КонецПроцедуры

Процедура УстановитьПраваПоУмолчанию(Пользователь) Экспорт
	ЗарплатаКадрыБазовый.УстановитьПраваПоУмолчанию(Пользователь)
КонецПроцедуры

#КонецОбласти

#Область ВыгрузкаЗагрузкаДанных

// Заполняет массив типов неразделенных данных, для которых поддерживается сопоставление ссылок
// при загрузке данных в другую информационную базу.
//
// Параметры:
//  Типы - Массив(ОбъектМетаданных).
//
Процедура ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке(Типы) Экспорт
	ЗарплатаКадрыБазовый.ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке(Типы);
КонецПроцедуры

// Заполняет массив типов неразделенных данных, для которых не требуется сопоставление ссылок
// при загрузке данных в другую информационную базу, т.к. корректное сопоставление ссылок
// гарантируется с помощью других механизмов.
//
// Параметры:
//  Типы - Массив(ОбъектМетаданных).
//
Процедура ПриЗаполненииТиповОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке(Типы) Экспорт
	ЗарплатаКадрыБазовый.ПриЗаполненииТиповОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке(Типы);
КонецПроцедуры

#КонецОбласти

#Область ПоставляемыеДанные

Процедура ПолучитьОбработчикиПоставляемыхДанных(Обработчики) Экспорт
	ЗарплатаКадрыБазовый.ПолучитьОбработчикиПоставляемыхДанных(Обработчики)	
КонецПроцедуры

#КонецОбласти

#Область ОчередьЗаданий

// См. ЗарплатаКадры.ПриПолученииСпискаШаблонов.
//
Процедура ПриПолученииСпискаШаблоновОчередиЗаданий(Шаблоны) Экспорт
	
КонецПроцедуры

// См. ЗарплатаКадры.ПриПолученииСпискаШаблонов.
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииВидовПодключаемыхКоманд.
Процедура ПриОпределенииВидовПодключаемыхКоманд(ВидыПодключаемыхКоманд) Экспорт
	
	ЗарплатаКадрыБазовый.ПриОпределенииВидовПодключаемыхКоманд(ВидыПодключаемыхКоманд);
	
КонецПроцедуры

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииСоставаНастроекПодключаемыхОбъектов.
Процедура ПриОпределенииСоставаНастроекПодключаемыхОбъектов(НастройкиПрограммногоИнтерфейса) Экспорт
	
КонецПроцедуры

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту.
Процедура ПриОпределенииКомандПодключенныхКОбъекту(НастройкиФормы, Источники, ПодключенныеОтчетыИОбработки, Команды) Экспорт
	
	ЗарплатаКадрыБазовый.ПриОпределенииКомандПодключенныхКОбъекту(НастройкиФормы, Источники, ПодключенныеОтчетыИОбработки, Команды)
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область РегламентныеЗадания

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
КонецПроцедуры

// См. БлокировкаРаботыСВнешнимиРесурсамиПереопределяемый.ПриЗапретеРаботыСВнешнимиРесурсами
Процедура ПриЗапретеРаботыСВнешнимиРесурсами() Экспорт

КонецПроцедуры

#КонецОбласти

#Область ТекущиеДела

// См. ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел.
Процедура ПриОпределенииОбработчиковТекущихДел(Обработчики) Экспорт
	
	ЗарплатаКадрыБазовый.ПриОпределенииОбработчиковТекущихДел(Обработчики);
	
КонецПроцедуры

#КонецОбласти

#Область ШаблоныСообщений

// См. ШаблоныСообщенийПереопределяемый.ПриОпределенииНастроек
Процедура ПриОпределенииНастроекШаблоновСообщений(Настройки) Экспорт
	
КонецПроцедуры

// См. ШаблоныСообщенийПереопределяемый.ПриПодготовкеШаблонаСообщения
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, НазначениеШаблона, ДополнительныеПараметры) Экспорт
	
	
КонецПроцедуры

// См. ШаблоныСообщенийПереопределяемый.ПриФормированииСообщения
Процедура ПриФормированииСообщения(Сообщение, НазначениеШаблона, ПредметСообщения, ПараметрыШаблона) Экспорт
	
	
КонецПроцедуры

// См. ШаблоныСообщенийПереопределяемый.ПриЗаполненииПочтыПолучателейВСообщении
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, НазначениеШаблона, ПредметСообщения) Экспорт

КонецПроцедуры

// См. ШаблоныСообщенийПереопределяемый.ПриЗаполненииТелефоновПолучателейВСообщении
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, НазначениеШаблона, ПредметСообщения) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область РегламентированнаяОтчетность
//


// См. ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.ВыгрузитьДокумент.
Функция ВыгрузитьДокумент(Ссылка, УникальныйИдентификатор = Неопределено) Экспорт
	
	Возврат ЗарплатаКадрыБазовый.ВыгрузитьДокумент(Ссылка, УникальныйИдентификатор);
	
КонецФункции
//

// Функция возвращает сведения об организации.
//
// Параметры:
//  Организация			- ссылка на элемент справочника "Организации";
//  ДатаЗначения		- дата, на которую нужно получить сведения;
//  СписокПоказателей	- список показателей, значения которых нужно вернуть.
//  
// Возвращаемое значение:
//  Структура с ключами из списка показателей и возвращаемыми значениями.
//
Функция ПолучитьСведенияОбОрганизации(Знач Организация, Знач ДатаЗначения = Неопределено, Знач СписокПоказателей = Неопределено) Экспорт
	Возврат ЗарплатаКадрыБазовый.ПолучитьСведенияОбОрганизации(Организация, ДатаЗначения, СписокПоказателей);
КонецФункции

// Процедура заполняет список используемых регламентированных отчетов.
//
Процедура ЗаполнитьСписокРегламентированныхОтчетов(СписокРегламентированныхОтчетов) Экспорт
	ЗарплатаКадрыБазовый.ЗаполнитьСписокРегламентированныхОтчетов(СписокРегламентированныхОтчетов);
КонецПроцедуры

// Процедура заполняет структуру показателей.
// Ключ структуры - идентификатор показателя.
// Значение структуры - массив из двух элементов:
// 	- признак автозаполнения показателя,
//	- признак расшифровки показателя.
//
// Параметры:
// 	ПоказателиОтчета - структура показателей отчета,
// 	ИДОтчета         - идентификатор отчета,
//	ИДРедакцииОтчета - идентификатор редакции формы отчета.
//  ПараметрыОтчета  - Структура - структура параметров отчета.
//
Процедура ЗаполнитьПоказателиРегламентированногоОтчета(ПоказателиОтчета, ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета = Неопределено) Экспорт
	ЗарплатаКадрыБазовый.ЗаполнитьПоказателиРегламентированногоОтчета(ПоказателиОтчета, ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета);
КонецПроцедуры

// Процедура заполняет переданную в виде контейнера структуру данных отчета.
//
Процедура ЗаполнитьРегламентированныйОтчет(ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета, Контейнер) Экспорт
	ЗарплатаКадрыБазовый.ЗаполнитьРегламентированныйОтчет(ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета, Контейнер);
КонецПроцедуры

// Для ЗарплатаКадры.ПолучитьНастройкиВидимостиЭлементовФормы возвращает характеристику показываемой формы регламентированного отчета.
//  
// Возвращаемое значение:
//  Булево, истина - если рассматриваемую форму заполнять автоматически мы еще не умеем.
//
Функция НоваяФормаРегламентированногоОтчета(ИДОтчета, ИДРедакцииОтчета) Экспорт
	Возврат	ЗарплатаКадрыБазовый.НоваяФормаРегламентированногоОтчета(ИДОтчета, ИДРедакцииОтчета)
КонецФункции

// Функция возвращает имя справочника обособленных подразделений,
// используемого для автоматического заполнения статистической отчетности.
//
// Пример:
//  Возврат "ПодразделенияОрганизаций";
//
Функция ИмяСправочникаОбособленныхПодразделений() Экспорт
	
	Возврат ЗарплатаКадрыБазовый.ИмяСправочникаОбособленныхПодразделений();
	
КонецФункции

// Функция возвращает имя реквизита справочника подразделений, который
// определяет, является ли подразделение обособленным (в трактовке Росстата).
// Используется для автоматического заполнения статистической отчетности.
//
// Тип реквизита - Булево.
// Если значение реквизита равно Истина - подразделение является обособленным.
// Если значение реквизита равно Ложь - подразделение не является обособленным.
//
// Пример:
//  Возврат "ИмеетНомерТерриториальногоОрганаРосстата";
//
Функция ИмяРеквизитаПризнакаОбособленногоПодразделения() Экспорт
	
	Возврат ЗарплатаКадрыБазовый.ИмяРеквизитаПризнакаОбособленногоПодразделения();
	
КонецФункции

// Процедура переопределяет свойства объекта, с которыми он будет отображен в форме Отчетность.
// Параметры:
//  СвойстваОбъектов  - ТаблицаЗначений - (см. РегламентированнаяОтчетностьПереопределяемый.ОпределитьСвойстваОбъектовДляОтображенииВФормеОтчетность).
Процедура ОпределитьСвойстваОбъектовДляОтображенииВФормеОтчетность(СвойстваОбъектов) Экспорт
	ЗарплатаКадрыБазовый.ОпределитьСвойстваОбъектовДляОтображенииВФормеОтчетность(СвойстваОбъектов);		
КонецПроцедуры

// Определяет свойства, касающиеся общих свойств объектов конфигураций-потребителей для отображения в форме Отчетность
// и возможности создания новый объектов из формы Отчетность.
//
// Параметры:
//  ТаблицаОписания  - ТаблицаЗначений -  (см. РегламентированнаяОтчетностьПереопределяемый.ОпределитьТаблицуОписанияОбъектовРегламентированнойОтчетности).
//
Процедура ОпределитьТаблицуОписанияОбъектовРегламентированнойОтчетности(ТаблицаОписания) Экспорт
	ЗарплатаКадрыБазовый.ОпределитьТаблицуОписанияОбъектовРегламентированнойОтчетности(ТаблицаОписания);	
КонецПроцедуры

// Процедура переопределяет обработчик подписки на событие "ЗаписьОбъектовРегламентированнойОтчетности*".
//
// Параметры: - (см. РегламентированнаяОтчетностьПереопределяемый.ЗаписьОбъектовРегламентированнойОтчетности).
//
Процедура ЗаписьОбъектовРегламентированнойОтчетности(Ссылка, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Получает код ОКПО обособленного подразделения
// 
// Параметры:
//   Подразделение - СправочникСсылка.ПодразделенияОрганизаций
//   КодОКПО       - Строка(14) - код ОКПО обособленного подразделения.
Процедура ПолучитьКодОКПОПодразделения(Знач Подразделение, КодОКПО) Экспорт 
	ЗарплатаКадрыБазовый.ПолучитьКодОКПОПодразделения(Подразделение, КодОКПО);
КонецПроцедуры

// Получает код органа ФСГС обособленного подразделения
// 
// Параметры:
//   Подразделение - СправочникСсылка.ПодразделенияОрганизаций
//   КодФСГС       - Строка(5) - код органа ФСГС для подразделения (например, "23-45").
//
Процедура ПолучитьКодОрганаФСГСПодразделения(Подразделение, КодФСГС) Экспорт 
	ЗарплатаКадрыБазовый.ПолучитьКодОрганаФСГСПодразделения(Подразделение, КодФСГС);
КонецПроцедуры

#КонецОбласти

#Область Печать

// Определяет объекты, в которых есть процедура ДобавитьКомандыПечати().
// Подробнее см. УправлениеПечатьюПереопределяемый.
//
// Параметры:
//  СписокОбъектов - Массив - список менеджеров объектов.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	ЗарплатаКадрыБазовый.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);
	
КонецПроцедуры

// Дополнительные настройки списка команд печати.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати.
//   * МенеджерКомандПечати     - МенеджерОбъекта - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Значение по умолчанию: Истина.
//
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
	ЗарплатаКадрыБазовый.ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка);
	
КонецПроцедуры

// См. УправлениеПечатьюПереопределяемый.ПриДобавленииКомандПечати
Процедура ПриДобавленииКомандПечати(ИмяФормы, КомандыПечати) Экспорт
	ЗарплатаКадрыБазовый.ПриДобавленииКомандПечати(ИмяФормы, КомандыПечати);
КонецПроцедуры

// См. УправлениеПечатьюПереопределяемый.ПриПолученииКомандПечати.
Процедура ПриПолученииКомандПечати(КомандыПечати, ИмяОбъекта) Экспорт
	
	ЗарплатаКадрыБазовый.ПриПолученииКомандПечати(КомандыПечати, ИмяОбъекта);
	
КонецПроцедуры

// См. УправлениеПечатьюПереопределяемый.ПриОпределенииОбъектовПечатнойФормы.
Процедура ПриОпределенииОбъектовПечатнойФормы(ОбъектыПечатнойФормы, ИдентификаторПечатнойФормы, ИмяМенеджераПечати, ПараметрыПечати) Экспорт
	
	ЗарплатаКадрыБазовый.ПриОпределенииОбъектовПечатнойФормы(ОбъектыПечатнойФормы, ИдентификаторПечатнойФормы, ИмяМенеджераПечати, ПараметрыПечати);
	
КонецПроцедуры

// См. УправлениеПечатьюПереопределяемый.ПриПечати.
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ЗарплатаКадрыБазовый.ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры

#КонецОбласти

#Область ЭлектронноеВзаимодействие

// См. ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьСоответствиеСправочников.
Процедура ЭлектронноеВзаимодействиеПриОпределенииСоответствияСправочников(СоответствиеСправочников) Экспорт
	
	ЗарплатаКадрыБазовый.ЭлектронноеВзаимодействиеПриОпределенииСоответствияСправочников(СоответствиеСправочников);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	ЗарплатаКадрыБазовый.ПриЗаполненииСписковСОграничениемДоступа(Списки);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииПоставляемыхПрофилейГруппДоступа.
Процедура ПриЗаполненииПоставляемыхПрофилейГруппДоступа(ОписанияПрофилей, ПараметрыОбновления) Экспорт
	ЗарплатаКадрыБазовый.ПриЗаполненииПоставляемыхПрофилейГруппДоступа(ОписанияПрофилей, ПараметрыОбновления);
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Список, Ограничение) Экспорт
	
	ЗарплатаКадрыБазовый.ПриЗаполненииОграниченияДоступа(Список, Ограничение);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных.
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	ЗарплатаКадрыБазовый.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииВидовДоступа.
Процедура ПриЗаполненииВидовДоступа(ВидыДоступа) Экспорт
	
	ЗарплатаКадрыБазовый.ПриЗаполненииВидовДоступа(ВидыДоступа);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииИспользованияВидаДоступа.
Процедура ПриЗаполненииИспользованияВидаДоступа(ИмяВидаДоступа, Использование) Экспорт
	
	ЗарплатаКадрыБазовый.ПриЗаполненииИспользованияВидаДоступа(ИмяВидаДоступа, Использование);
	
КонецПроцедуры

#КонецОбласти

#Область ИнтернетПоддержкаПользователей

// См. ИнтернетПоддержкаПользователейПереопределяемый.ПриИзмененииДанныхАутентификацииИнтернетПоддержки.
Процедура ПриИзмененииДанныхАутентификацииИнтернетПоддержки(ДанныеПользователя) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

// См. ЗарплатаКадры.ДобавитьКомандуПереходаКОбработкеРедактированиюЗаконодательныхЗначений.
Процедура ДобавитьКомандуПереходаКОбработкеРедактированиюЗаконодательныхЗначений(Форма, КоманднаяПанельФормы) Экспорт
	ЗарплатаКадрыБазовый.ДобавитьКомандуПереходаКОбработкеРедактированиюЗаконодательныхЗначений(Форма, КоманднаяПанельФормы);
КонецПроцедуры

Функция РегистраторыПереносаДанных() Экспорт
	Возврат ЗарплатаКадрыБазовый.РегистраторыПереносаДанных();
КонецФункции

#Область УправлениеОтборамиВФормахСДинамическимСписком

Процедура НастроитьМодифицирующийПараметрОтбора(СтрокаПараметра, Список, МетаданныеОбъекта, Элементы) Экспорт
	
КонецПроцедуры

Процедура ДополнитьОписаниеМодифицирующегоПараметраОтбора(ИмяПараметра, ОписаниеПараметра, ИмяМодификации) Экспорт
	
КонецПроцедуры

#КонецОбласти

Процедура ОбновитьЗначенияМинимальнойОплатыТрудаРФ(ТекстXML, ПолучатьДанныеИзСервиса) Экспорт
	ЗарплатаКадрыБазовый.ОбновитьЗначенияМинимальнойОплатыТрудаРФ(ТекстXML, ПолучатьДанныеИзСервиса);
КонецПроцедуры

// Выполняет начальное заполнение справочников и регистров сведений. Поддерживаются
// следующие имена объектов метаданных:
//
// Подсистема РасчетЗарплаты:
//		РегистрСведений.МинимальнаяОплатаТрудаРФ
//
// Подсистема УчетНДФЛ:
//		Справочник.ВидыВычетовНДФЛ
//		Справочник.ВидыДоходовНДФЛ
//		Справочник.СтатусыНалогоплательщиковПоНДФЛ
//		РегистрСведений.ВычетыПоДоходамНДФЛ
//		РегистрСведений.РазмерВычетовНДФЛ.
//
// Подсистема УчетСтраховыхВзносов:
//		Справочник.ВидыДоходовПоСтраховымВзносам
//		Справочник.ВидыТарифовСтраховыхВзносов
//		РегистрСведений.ПредельнаяВеличинаБазыСтраховыхВзносов
//		РегистрСведений.СтраховыеВзносыСкидкиКДоходам
//		РегистрСведений.ТарифыВзносовЗаЗанятыхНаРаботахСДосрочнойПенсией
//		РегистрСведений.ТарифыВзносовПоРезультатамСпециальнойОценкиУсловийТруда
//		РегистрСведений.ТарифыСтраховыхВзносов.
//
// Подсистема ПерсонифицированныйУчет;
//		Справочник.ВидыОбщественноПолезнойДеятельностиСЗВК
//		Справочник.ОснованияДосрочногоНазначенияПенсии
//		Справочник.ОснованияДосрочногоНазначенияПенсииДляСЗВК
//		Справочник.ПараметрыИсчисляемогоСтраховогоСтажа
//		Справочник.ТерриториальныеУсловияПФР
//		РегистрСведений.ДопустимыеСочетанияКодовГруппСтажа.
//
// Подсистема УчетПособийСоциальногоСтрахования:
//		РегистрСведений.МаксимальныйРазмерЕжемесячнойСтраховойВыплаты
//
Процедура УстановитьНачальныеЗначения(ИменаОбъектовМетаданных) Экспорт

	ЗарплатаКадрыБазовый.УстановитьНачальныеЗначения(ИменаОбъектовМетаданных);

КонецПроцедуры

Процедура ПроверитьВозможностьСменыГоловнойОрганизации(Организация, Отказ) Экспорт
	
	ЗарплатаКадрыБазовый.ПроверитьВозможностьСменыГоловнойОрганизации(Организация, Отказ);
	
КонецПроцедуры

Функция ОписанияРегистровСодержащихРегистрацииВНалоговомОргане() Экспорт
	
	Возврат ЗарплатаКадрыБазовый.ОписанияРегистровСодержащихРегистрацииВНалоговомОргане();
	
КонецФункции

// ЗарплатаКадрыПодсистемы.ПодписиДокументов

// См. ПодписиДокументовПереопределяемый.ПриОпределенииРолейПодписантов.
Процедура ПриОпределенииРолейПодписантов(РолиПодписантов) Экспорт
	ЗарплатаКадрыБазовый.ПриОпределенииРолейПодписантов(РолиПодписантов);
КонецПроцедуры


Процедура ОбработкаПолученияФормыСтатьиРасходовЗарплата(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	// в базовой реализации не переопределяется
	
КонецПроцедуры

// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов

Процедура ПроверитьИсключенияПроверкиЗапретаИзменения(Объект, ПроверкаЗапретаИзменения, УзелПроверкиЗапретаЗагрузки, ВерсияОбъекта) Экспорт
	
		
КонецПроцедуры

// Предназначена для использования в ОбщегоНазначенияПереопределяемый.ЗаполнитьТаблицуПереименованияОбъектовМетаданных.
//
// Заполняет переименования тех объектов метаданных, которые невозможно
// автоматически найти по типу, но ссылки на которые требуется сохранять
// в базе данных (например: подсистемы, роли).
//
// Подробнее: см. ОбщегоНазначения.ДобавитьПереименование().
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	ЗарплатаКадрыБазовый.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	
КонецПроцедуры

Процедура ОбработкаДокументовПечатныхФорм() Экспорт
	
	ЗарплатаКадрыБазовый.ОбработкаДокументовПечатныхФорм();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПоискИУдалениеДублей

Процедура ПриОпределенииОбъектовСПоискомДублей(Объекты) Экспорт
	
	ЗарплатаКадрыБазовый.ПриОпределенииОбъектовСПоискомДублей(Объекты);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПоискИУдалениеДублей

// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

// См. УчетОригиналовПервичныхДокументовПереопределяемый.ПриОпределенииОбъектовСКомандамиУчетаОригиналов.
Процедура ПриОпределенииОбъектовСКомандамиУчетаОригиналов(СписокОбъектов) Экспорт
	
КонецПроцедуры

// См. УчетОригиналовПервичныхДокументовПереопределяемый.ПриОпределенииМногосотрудниковыхДокументов.
Процедура ПриОпределенииМногосотрудниковыхДокументов(СписокОбъектов) Экспорт
	
КонецПроцедуры

// См. УчетОригиналовПервичныхДокументовПереопределяемый.ЗаполнитьТаблицуУчетаОригиналов.
Процедура ЗаполнитьТаблицуУчетаОригиналов(ТаблицаУчетаОригиналов) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

// СтандартныеПодсистемы.ИнформацияПриЗапуске

// См. ИнформацияПриЗапускеПереопределяемый.ОпределитьНастройки.
Процедура ОпределитьНастройки(Настройки) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ИнформацияПриЗапуске

#Область РаботаСФайлами

// См. РаботаСФайламиПереопределяемый.ПриСозданииФормыСпискаФайлов.
Процедура ПриСозданииФормыСпискаФайлов(Форма) Экспорт
	
	ЗарплатаКадрыБазовый.ПриСозданииФормыСпискаФайлов(Форма);
	
КонецПроцедуры

#КонецОбласти

#Область ИнтеграцияС1СДокументооборот

// См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ДополнитьСоответствиеТипов.
Процедура ДополнитьСоответствиеТипов(Таблица) Экспорт
	
	ЗарплатаКадрыБазовый.ДополнитьСоответствиеТипов(Таблица);
	
КонецПроцедуры

// См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ЗаполнитьРеквизитыИзПотребителя.
Процедура ЗаполнитьРеквизитыОбъектаДокументооборота(Прокси, ОбъектXDTO, СсылкаНаПотребитель) Экспорт
	
	ЗарплатаКадрыБазовый.ЗаполнитьРеквизитыОбъектаДокументооборота(Прокси, ОбъектXDTO, СсылкаНаПотребитель);
	
КонецПроцедуры

// См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПриЗаполненииСвойстваОбъектаXDTOПоЗначению.
Процедура ПриЗаполненииСвойстваОбъектаXDTOПоЗначению(Значение, Свойства, ТипОбъекта, ИмяСвойства, ТипСвойства,
		СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПриИзмененииСостоянияСогласования.
Процедура ПриИзмененииСостоянияСогласования(ПредметСогласования, Состояние, ВызовИзФормыОбъекта) Экспорт
	
КонецПроцедуры

// См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПриОпределенииЗначенияРеквизитаПоОбъектуXDTO.
Процедура ПриОпределенииЗначенияРеквизитаПоОбъектуXDTO(Результат, ЗначениеЗаполнения, ТипРеквизита, ИмяРеквизита,
		ТипОбъекта, Объект, ЭтоДополнительноеСвойство, Свойство, ПараметрыВыбора) Экспорт
	
	ЗарплатаКадрыБазовый.ПриОпределенииЗначенияРеквизитаПоОбъектуXDTO(
		Результат,
		ЗначениеЗаполнения,
		ТипРеквизита,
		ИмяРеквизита,
		ТипОбъекта,
		Объект,
		ЭтоДополнительноеСвойство,
		Свойство,
		ПараметрыВыбора);
	
КонецПроцедуры

// См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПриОпределенииНеобходимостиВыводитьКомандуПрисоединенныхФайловДО.
Процедура ПриОпределенииНеобходимостиВыводитьКомандуПрисоединенныхФайловДО(Форма, Результат, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПриОпределенииОбновляемыхРеквизитовПроведенногоДокумента.
Процедура ПриОпределенииОбновляемыхРеквизитовПроведенногоДокумента(ПолноеИмя, ОбновляемыеРеквизиты) Экспорт
	
КонецПроцедуры

// См. ИнтеграцияС1СДокументооборотПереопределяемый.ПриОпределенииСокращенногоНаименованияКонфигурации.
Процедура ПриОпределенииСокращенногоНаименованияКонфигурации(СокращенноеНаименование) Экспорт
	
КонецПроцедуры

// См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПриСозданииПоСсылке.
Процедура ПриСозданииПоСсылке(ОбъектИС, ОбъектXDTO, ЗаполняемыйОбъектИС) Экспорт
	
	ЗарплатаКадрыБазовый.ПриСозданииПоСсылке(ОбъектИС, ОбъектXDTO, ЗаполняемыйОбъектИС);
	
КонецПроцедуры

#КонецОбласти

Процедура ЗаполнитьДанныеПодписанта(Объект, ПолеПодписанта, ПолеДолжностиПодписанта) Экспорт
	ЗарплатаКадрыБазовый.ЗаполнитьДанныеПодписанта(Объект, ПолеПодписанта, ПолеДолжностиПодписанта);
КонецПроцедуры

#КонецОбласти
