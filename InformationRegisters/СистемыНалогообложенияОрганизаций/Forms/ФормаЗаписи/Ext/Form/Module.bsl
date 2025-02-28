﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Ключ.Пустой() Тогда
		Если Параметры.ЕстьСобственныеДанныеЗаполнения Тогда
			Менеджер = РегистрыСведений.СистемыНалогообложенияОрганизаций.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(Менеджер, Параметры.СобственныеДанныеЗаполнения);
			Менеджер.Прочитать();
			Если Менеджер.Выбран() Тогда
				ЗначениеВРеквизитФормы(Менеджер, "Запись");
			Иначе
				ЗаполнитьЗначенияСвойств(Запись, Параметры.СобственныеДанныеЗаполнения);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ВидыОбъектовНалогообложения = Новый Структура;
	ВидыОбъектовНалогообложения.Вставить("Доходы", Перечисления.ВидыОбъектовНалогообложения.Доходы);
	ВидыОбъектовНалогообложения.Вставить("ДоходыМинусРасходы", Перечисления.ВидыОбъектовНалогообложения.ДоходыМинусРасходы);
	
	
	
	Если Запись.Организация.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо Тогда
		Элементы.ГруппаУСН.Видимость = Запись.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная;
		Элементы.ПрименяетсяПатент.Видимость = Ложь;
	Иначе
		Элементы.ПрименяетсяПатент.Видимость = Запись.СистемаНалогообложения <> Перечисления.СистемыНалогообложения.ОсобыйПорядок;
		Элементы.ГруппаУСН.Видимость = Запись.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная;
	КонецЕсли;
	Элементы.ПлательщикЕНВД.Видимость = Запись.СистемаНалогообложения <> Перечисления.СистемыНалогообложения.ОсобыйПорядок;
	
	Если Запись.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Общая Тогда
		СистемаНалогообложенияПредставление = 0;
	ИначеЕсли Запись.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная Тогда
		СистемаНалогообложенияПредставление = 1;
	ИначеЕсли Запись.СистемаНалогообложения = Перечисления.СистемыНалогообложения.ОсобыйПорядок Тогда
		Если Запись.ПрименяетсяПатент Тогда
			СистемаНалогообложенияПредставление = 3;
		Иначе
			СистемаНалогообложенияПредставление = 2;
		КонецЕсли;
	ИначеЕсли Запись.СистемаНалогообложения = Перечисления.СистемыНалогообложения.АУСН Тогда
		СистемаНалогообложенияПредставление = 4;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ЗаписьСистемыНалогообложения",Новый Структура("Организация", Запись.Организация));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОбъектНалогообложенияПриИзменении(Элемент)
	Если Запись.ОбъектНалогообложения = ВидыОбъектовНалогообложения.Доходы Тогда
		Запись.СтавкаНалога           = 6;
		Запись.ПовышеннаяСтавкаНалога = 8;
	ИначеЕсли Запись.ОбъектНалогообложения = ВидыОбъектовНалогообложения.ДоходыМинусРасходы Тогда
		Запись.СтавкаНалога           = 15;
		Запись.ПовышеннаяСтавкаНалога = 20;
	Иначе
		Запись.СтавкаНалога = 0;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СистемаНалогообложенияПриИзменении(Элемент)
	СистемаНалогообложенияПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедырИФункции

&НаСервере
Процедура СистемаНалогообложенияПриИзмененииНаСервере()
	
	Если СистемаНалогообложенияПредставление = 0 Тогда
		Запись.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Общая;
		Запись.ПлательщикУСН = Ложь;
	ИначеЕсли СистемаНалогообложенияПредставление = 1 Тогда
		Запись.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная;
		Запись.ПлательщикУСН = Истина;
	ИначеЕсли СистемаНалогообложенияПредставление = 2 Тогда
		Запись.ПлательщикЕНВД = Истина;
		Запись.ПрименяетсяПатент = Ложь;
		Запись.ПлательщикУСН = Ложь;
		Запись.СистемаНалогообложения = Перечисления.СистемыНалогообложения.ОсобыйПорядок;
	ИначеЕсли СистемаНалогообложенияПредставление = 3 Тогда
		Запись.ПрименяетсяПатент = Истина;
		Запись.ПлательщикЕНВД = Ложь;
		Запись.ПлательщикУСН = Ложь;
		Запись.СистемаНалогообложения = Перечисления.СистемыНалогообложения.ОсобыйПорядок;
	КонецЕсли;
	
	Если Запись.Организация.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
		Элементы.ГруппаУСН.Видимость = Запись.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная;
		
		Элементы.ПрименяетсяПатент.Видимость = Запись.СистемаНалогообложения <> Перечисления.СистемыНалогообложения.ОсобыйПорядок;
	Иначе
		Элементы.ГруппаУСН.Видимость = Запись.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная;
		Элементы.ПрименяетсяПатент.Видимость = Ложь;
	КонецЕсли;
	Элементы.ПлательщикЕНВД.Видимость = Запись.СистемаНалогообложения <> Перечисления.СистемыНалогообложения.ОсобыйПорядок;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	СистемаНалогообложенияПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти
