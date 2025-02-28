﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

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
	
	// 00.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Служебный";
	Элемент.Наименование = НСтр("ru='Служебный'");
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ГруппаСчетов;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 01.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ВнеоборотныеАктивы";
	Элемент.Наименование = НСтр("ru='Имущество'");
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ВнеоборотныеАктивы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 02.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "АмортизацияВнеоборотныхАктивов";
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.Наименование = НСтр("ru='Амортизация имущества'");
	Элемент.ТипСчета = Перечисления.ТипыСчетов.АмортизацияВнеоборотныхАктивов;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 08.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ВложенияВоВнеоборотныеАктивы";
	Элемент.Наименование = НСтр("ru='Вложения в имущество'");
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ПрочиеВнеоборотныеАктивы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 10.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "СырьеИМатериалы";
	Элемент.Наименование = НСтр("ru='Сырье и материалы'");
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Запасы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 19.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "НДСПоПриобретеннымЦенностям";
	Элемент.Наименование = НСтр("ru='НДС по приобретенным ценностям'");
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Дебиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 20.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "НезавершенноеПроизводство";
	Элемент.Наименование = НСтр("ru='Незавершенное производство'");
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.НезавершенноеПроизводство;
	Элемент.СчетЗакрытия = ПланыСчетов.Управленческий.ТоварыПродукция;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 25.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "КосвенныеЗатраты";
	Элемент.Наименование = НСтр("ru='Косвенные затраты'");
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.КосвенныеЗатраты;
	Элемент.СчетЗакрытия = ПланыСчетов.Управленческий.НезавершенноеПроизводство;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.ОбъемВыпуска;
	
	// 41.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ТоварыПродукция";
	Элемент.Наименование = НСтр("ru='Товары, продукция'");
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Запасы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 42.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ТорговаяНаценка";
	Элемент.Наименование = НСтр("ru='Торговая наценка'");
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ТорговаяНаценка;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 50.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Касса";
	Элемент.Наименование = НСтр("ru='Касса'");
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ДенежныеСредства;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 51.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Банк";
	Элемент.Наименование = НСтр("ru='Банк'");
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ДенежныеСредства;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 57.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПереводыВПути";
	Элемент.Наименование = НСтр("ru='Переводы в пути'");
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ДенежныеСредства;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 58.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ФинансовыеВложения";
	Элемент.Наименование = НСтр("ru='Финансовые вложения'");
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ДенежныеСредства;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 60.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПоставщикамиИПодрядчиками";
	Элемент.Наименование = НСтр("ru='Расчеты с поставщиками и подрядчиками'");
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ГруппаСчетов;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 60.01
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПоставщиками";
	Элемент.Наименование = НСтр("ru='Расчеты с поставщиками'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыСПоставщикамиИПодрядчиками;
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Кредиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 60.02
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыПоАвансамВыданным";
	Элемент.Наименование = НСтр("ru='Расчеты по авансам выданным'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыСПоставщикамиИПодрядчиками;
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Дебиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 62.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПокупателямиИЗаказчиками";
	Элемент.Наименование = НСтр("ru='Расчеты с покупателями и заказчиками'");
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ГруппаСчетов;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 62.01
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПокупателями";
	Элемент.Наименование = НСтр("ru='Расчеты с покупателями'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыСПокупателямиИЗаказчиками;
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Дебиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 62.02
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыПоАвансамПолученным";
	Элемент.Наименование = НСтр("ru='Расчеты по авансам полученным'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыСПокупателямиИЗаказчиками;
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Кредиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 66.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыПоКраткосрочнымКредитамИЗаймам";
	Элемент.Наименование = НСтр("ru='Расчеты по краткосрочным кредитам и займам'");
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.КредитыИЗаймы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 67.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыПоДолгосрочнымКредитамИЗаймам";
	Элемент.Наименование = НСтр("ru='Расчеты по долгосрочным кредитам и займам'");
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ДолгосрочныеОбязательства;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 68.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыПоНалогам";
	Элемент.Наименование = НСтр("ru='Расчеты по налогам'");
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ГруппаСчетов;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 68.01
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Налоги";
	Элемент.Наименование = НСтр("ru='Налоги'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыПоНалогам;
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Кредиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 68.02
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "НалогиКВозмещению";
	Элемент.Наименование = НСтр("ru='Налоги к возмещению'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыПоНалогам;
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Дебиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;  
	
	// 68.90
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ЕдиныйНалоговыйСчет";
	Элемент.Наименование = НСтр("ru='Единый налоговый счет'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыПоНалогам;
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Кредиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 70.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПерсоналомПоОплатеТруда";
	Элемент.Наименование = НСтр("ru='Расчеты с персоналом по оплате труда'");
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Кредиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 71.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПодотчетнымиЛицами";
	Элемент.Наименование = НСтр("ru='Расчеты с подотчетными лицами'");
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ГруппаСчетов;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 71.01
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПодотчетниками";
	Элемент.Наименование = НСтр("ru='Авансы, выданные подотчетным лицам'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыСПодотчетнымиЛицами;
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Дебиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 71.02
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПерерасходПодотчетников";
	Элемент.Наименование = НСтр("ru='Перерасход подотчетных лиц'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыСПодотчетнымиЛицами;
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Кредиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// Прочие расчеты
	// 73
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПерсоналомПоПрочимОперациям";
	Элемент.Наименование = НСтр("ru='Расчеты с персоналом по прочим операциям'");
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ГруппаСчетов;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 73.01
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыПоПредоставленнымЗаймам";
	Элемент.Наименование = НСтр("ru='Расчеты по предоставленным займам'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыСПерсоналомПоПрочимОперациям;
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.КредитыИЗаймы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 73.02
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыПоВозмещениюМатериальногоУщерба";
	Элемент.Наименование = НСтр("ru='Расчеты по возмещению материального ущерба'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыСПерсоналомПоПрочимОперациям;
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Дебиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 75
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыСУчредителями";
	Элемент.Наименование = НСтр("ru='Расчеты с учредителями'");
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ГруппаСчетов;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 75.01
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыПоВкладамВУставныйКапитал";
	Элемент.Наименование = НСтр("ru='Расчеты по вкладам в уставный капитал'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыСУчредителями;
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Дебиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 75.02
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыПоВыплатеДоходов";
	Элемент.Наименование = НСтр("ru='Расчеты по выплате доходов'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыСУчредителями;
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Кредиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 76
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыСРазнымиДебиторамиИКредиторами";
	Элемент.Наименование = НСтр("ru='Расчеты с разными дебиторами и кредиторами'");
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ГруппаСчетов;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 76.01
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыСРазнымиДебиторами";
	Элемент.Наименование = НСтр("ru='Расчеты с разными дебиторами'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыСРазнымиДебиторамиИКредиторами;
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Дебиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 76.02
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыСРазнымиКредиторами";
	Элемент.Наименование = НСтр("ru='Расчеты с разными кредиторами'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыСРазнымиДебиторамиИКредиторами;
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Кредиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	//76.05
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасчетыСПрочимиПоставщикамиИТаможеннымиОрганами";
	Элемент.Наименование = НСтр("ru='Расчеты с прочими поставщиками и таможенными органами'");
	Элемент.Родитель = ПланыСчетов.Управленческий.РасчетыСРазнымиДебиторамиИКредиторами;
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Кредиторы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	// Конец Прочие расчеты
	
	// 80.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "УставныйКапитал";
	Элемент.Наименование = НСтр("ru='Уставный капитал'");
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Капитал;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 82.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РезервныйИДобавочныйКапитал";
	Элемент.Наименование = НСтр("ru='Резервный и добавочный капитал'");
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.РезервныйИДобавочныйКапитал;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 84.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "НераспределеннаяПрибыль";
	Элемент.Наименование = НСтр("ru='Нераспределенная прибыль (непокрытый убыток)'");
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.НераспределеннаяПрибыль;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 90.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Продажи";
	Элемент.Наименование = НСтр("ru='Продажи'");
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ГруппаСчетов;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 90.01
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ВыручкаОтПродаж";
	Элемент.Наименование = НСтр("ru='Выручка от продаж'");
	Элемент.Родитель = ПланыСчетов.Управленческий.Продажи;
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Доходы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 90.02
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "СебестоимостьПродаж";
	Элемент.Наименование = НСтр("ru='Себестоимость продаж'");
	Элемент.Родитель = ПланыСчетов.Управленческий.Продажи;
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.СебестоимостьПродаж;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 90.03
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Продажи_НДС";
	Элемент.Наименование = НСтр("ru='Налог на добавленную стоимость'");
	Элемент.Родитель = ПланыСчетов.Управленческий.Продажи;
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Расходы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 90.07
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "КоммерческиеРасходы";
	Элемент.Наименование = НСтр("ru='Коммерческие расходы'");
	Элемент.Родитель = ПланыСчетов.Управленческий.Продажи;
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Расходы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.ОбъемПродаж;
	
	// 90.08
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "УправленческиеРасходы";
	Элемент.Наименование = НСтр("ru='Управленческие расходы'");
	Элемент.Родитель = ПланыСчетов.Управленческий.Продажи;
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.Расходы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.ОбъемПродаж;
	
	// 91.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПрочиеДоходыИРасходы";
	Элемент.Наименование = НСтр("ru='Прочие доходы и расходы'");
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ГруппаСчетов;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 91.01
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПрочиеДоходы";
	Элемент.Наименование = НСтр("ru='Прочие доходы'");
	Элемент.Родитель = ПланыСчетов.Управленческий.ПрочиеДоходыИРасходы;
	Элемент.Вид = ВидСчета.Пассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ПрочиеДоходы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.ОбъемПродаж;
	
	// 91.02
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПрочиеРасходы";
	Элемент.Наименование = НСтр("ru='Прочие расходы'");
	Элемент.Родитель = ПланыСчетов.Управленческий.ПрочиеДоходыИРасходы;
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ПрочиеРасходы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.ОбъемПродаж;
	
	// 91.03
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПроцентыПоКредитам";
	Элемент.Наименование = НСтр("ru='Проценты по кредитам'");
	Элемент.Родитель = ПланыСчетов.Управленческий.ПрочиеДоходыИРасходы;
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ПроцентыПоКредитам;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.ОбъемПродаж;
	
	// 94.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "НедостачиИПотериОтПорчиЦенностей";
	Элемент.Наименование = НСтр("ru='Недостачи и потери от порчи ценностей'");
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ПрочиеОборотныеАктивы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 97.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РасходыБудущихПериодов";
	Элемент.Наименование = НСтр("ru='Расходы будущих периодов'");
	Элемент.Вид = ВидСчета.Активный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ПрочиеОборотныеАктивы;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 99.
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПрибылиИУбытки";
	Элемент.Наименование = НСтр("ru='Прибыли и убытки'");
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ГруппаСчетов;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 99.01
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПрибылиИУбыткиБезНалогаНаПрибыль";
	Элемент.Наименование = НСтр("ru='Прибыли и убытки (за исключением налога на прибыль)'");
	Элемент.Родитель = ПланыСчетов.Управленческий.ПрибылиИУбытки;
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.ПрибылиУбытки;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
	// 99.02
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПрибылиИУбытки_НалогНаПрибыль";
	Элемент.Наименование = НСтр("ru='Налог на прибыль'");
	Элемент.Родитель = ПланыСчетов.Управленческий.ПрибылиИУбытки;
	Элемент.Вид = ВидСчета.АктивноПассивный;
	Элемент.ТипСчета = Перечисления.ТипыСчетов.НалогНаПрибыль;
	Элемент.СпособРаспределения = Перечисления.БазыРаспределенияРасходов.НеРаспределять;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецЕсли
