﻿
#Область ПрограммныйИнтерфейс

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФВызовСервера.УстановитьНаименованиеДисконтнойКарты
// Процедура формирует наименование элемента справочника по значению других реквизитов.
//
Функция УстановитьНаименованиеДисконтнойКарты(Владелец, ВладелецКарты, КодКартыШтрихкод, КодКартыМагнитный) Экспорт
	
	Возврат ДисконтныеКартыУНФВызовСервера.УстановитьНаименованиеДисконтнойКарты(Владелец, ВладелецКарты, КодКартыШтрихкод, КодКартыМагнитный);
	
КонецФункции // ПолучитьНаименованиеДисконтнойКарты()

#Область ПоискДисконтныхКарт

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФВызовСервера.НайтиДисконтныеКартыПоДаннымСоСчитывателяМагнитныхКарт
//
// Функция выполняет поиск дисконтных карт по данным, полученным из считывателя
// магнитных карт
//
// Параметры
//  Данные - Массив данных, полученный из считывателя магнитных карт.
//
// Возвращаемое значение
//  Структура. В структуре содержится 2 таблицы значений: Зарегистрированные дисконтные карты
//  и НеЗарегистрированныеДисконтныеКарты.
//
Функция НайтиДисконтныеКартыПоДаннымСоСчитывателяМагнитныхКарт(Данные, ТипКода) Экспорт
	
	Возврат ДисконтныеКартыУНФВызовСервера.НайтиДисконтныеКартыПоДаннымСоСчитывателяМагнитныхКарт(Данные, ТипКода);
	
КонецФункции

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФВызовСервера.НайтиВидыДисконтныхКартПоДаннымСоСчитывателяМагнитныхКарт
//
// Функция выполняет поиск дисконтных карт по данным, полученным из считывателя
// магнитных карт
//
// Параметры
//  Данные - Массив данных, полученный из считывателя магнитных карт.
//
// Возвращаемое значение
//  Структура. В структуре содержится 2 таблицы значений: Зарегистрированные дисконтные карты
//  и НеЗарегистрированныеДисконтныеКарты.
//
Функция НайтиВидыДисконтныхКартПоДаннымСоСчитывателяМагнитныхКарт(Данные, ТипКода, ВидДисконтнойКарты) Экспорт
	
	Возврат ДисконтныеКартыУНФВызовСервера.НайтиВидыДисконтныхКартПоДаннымСоСчитывателяМагнитныхКарт(Данные, ТипКода, ВидДисконтнойКарты);
	
КонецФункции

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФВызовСервера.ПодготовитьКодКартыПоНастройкамПоУмолчанию
//
// Процедура убирает слева знак ";" и справа знак "?"
//
Процедура ПодготовитьКодКартыПоНастройкамПоУмолчанию(КодКарты) Экспорт
	
	ДисконтныеКартыУНФВызовСервера.ПодготовитьКодКартыПоНастройкамПоУмолчанию(КодКарты);
	
КонецПроцедуры

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФВызовСервера.НайтиДисконтныеКартыПоШтрихкоду
//
// Функция выполняет поиск дисконтных карт по штрихкоду
//
// Параметры
//  Штрихкод - Строка
//
// Возвращаемое значение
//  Структура. В структуре содержится 2 таблицы значений: Зарегистрированные дисконтные карты
//  и НеЗарегистрированныеДисконтныеКарты.
//
Функция НайтиДисконтныеКартыПоШтрихкоду(Штрихкод) Экспорт
	
	Возврат ДисконтныеКартыУНФВызовСервера.НайтиДисконтныеКартыПоШтрихкоду(Штрихкод);
	
КонецФункции

#КонецОбласти

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФВызовСервера.НужноОчиститьДисконтнуюКартуПриСменеВладельца
//
Функция НужноОчиститьДисконтнуюКартуПриСменеВладельца(пКонтрагент, пДисконтнаяКарта, пПустойКонтрагентПередИзменением) Экспорт
	
	Возврат ДисконтныеКартыУНФВызовСервера.НужноОчиститьДисконтнуюКартуПриСменеВладельца(пКонтрагент, пДисконтнаяКарта, пПустойКонтрагентПередИзменением);
	
КонецФункции

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФВызовСервера.СтарыйМеханизмСкидок
//
// Старый механизм скидок
//
// Параметры:
//  ДисконтнаяКарта - СправочникСсылка.ДисконтныеКарты
// 
// Возвращаемое значение:
//  Булево - используется старый механизм скидок
//
Функция СтарыйМеханизмСкидок(ДисконтнаяКарта) Экспорт
	
	Возврат ДисконтныеКартыУНФВызовСервера.СтарыйМеханизмСкидок(ДисконтнаяКарта);
	
КонецФункции

#КонецОбласти
