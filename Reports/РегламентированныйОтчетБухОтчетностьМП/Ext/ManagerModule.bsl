﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Возврат Перечисления.ВерсииФорматовВыгрузки.Версия500;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(254));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв4";
	НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина России от 17.08.2012 № 113н.";
	НоваяФорма.РедакцияФормы      = "от 17.08.2012 № 113н.";
	НоваяФорма.ДатаНачалоДействия = '2012-01-01';
	НоваяФорма.ДатаКонецДействия  = '2012-01-01';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв4_2";
	НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина России от 17.08.2012 № 113н.";
	НоваяФорма.РедакцияФормы      = "от 17.08.2012 № 113н.";
	НоваяФорма.ДатаНачалоДействия = '2012-01-01';
	НоваяФорма.ДатаКонецДействия  = '2014-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв4";
	НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина России от 17.08.2012 № 113н (в ред. приказа Минфина России от 06.04.2015 № 57н).";
	НоваяФорма.РедакцияФормы      = "от 06.04.2015 № 57н.";
	НоваяФорма.ДатаНачалоДействия = '2015-01-01';
	НоваяФорма.ДатаКонецДействия  = '2017-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв4";
	НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина России от 17.08.2012 № 113н (в ред. приказа Минфина России от 06.03.2018 № 41н).";
	НоваяФорма.РедакцияФормы      = "от 06.03.2018 № 41н.";
	НоваяФорма.ДатаНачалоДействия = '2018-01-01';
	НоваяФорма.ДатаКонецДействия  = '2018-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв4";
	НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина России от 17.08.2012 № 113н (в ред. приказа Минфина России от 19.04.2019 № 61н).";
	НоваяФорма.РедакцияФормы      = "от 19.04.2019 № 61н.";
	НоваяФорма.ДатаНачалоДействия = '2019-01-01';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт

КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20120101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "710098", '2012-08-17', "113н", "ФормаОтчета2012Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма20120101, "5.01");
	
	Форма20121201 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "710098", '2012-08-17', "113н", "ФормаОтчета2012Кв4_2");
	ОпределитьФорматВДеревеФормИФорматов(Форма20121201, "5.01");
	ОпределитьФорматВДеревеФормИФорматов(Форма20121201, "5.02");
	
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "710096", '2015-04-06', "57н", "ФормаОтчета2015Кв4", '2015-01-01', '2017-12-31');
	ОпределитьФорматВДеревеФормИФорматов(Форма20150101, "5.01");
	ОпределитьФорматВДеревеФормИФорматов(Форма20150101, "5.02");
	
	Форма20180101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "710096", '2018-03-06', "41н", "ФормаОтчета2015Кв4", '2018-01-01', '2018-12-31');
	ОпределитьФорматВДеревеФормИФорматов(Форма20180101, "5.02");
	
	Форма20190101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "710096", '2019-04-19', "61н", "ФормаОтчета2015Кв4", '2019-01-01', );
	ОпределитьФорматВДеревеФормИФорматов(Форма20190101, "5.03");
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция ОпределитьФорматВДеревеФормИФорматов(Форма, Версия, ДатаПриказа = '00010101', НомерПриказа = "",
			ДатаНачалаДействия = Неопределено, ДатаОкончанияДействия = Неопределено, ИмяОбъекта = "", Описание = "")
	
	НовСтр = Форма.Строки.Добавить();
	НовСтр.Код = СокрЛП(Версия);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ?(ДатаНачалаДействия = Неопределено, Форма.ДатаНачалаДействия, ДатаНачалаДействия);
	НовСтр.ДатаОкончанияДействия = ?(ДатаОкончанияДействия = Неопределено, Форма.ДатаОкончанияДействия, ДатаОкончанияДействия);
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#КонецЕсли