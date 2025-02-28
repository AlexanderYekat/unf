﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПравилаНачисленияБонусов.Параметры.УстановитьЗначениеПараметра("БонуснаяПрограмма", Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СобытияТаблицыФормы

&НаКлиенте
Процедура ПравилаНачисленияБонусовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ЭтоПравилоНачисленияБонусов", Истина);
	СтруктураРеквизитов.Вставить("СпособПредоставления", ПредопределенноеЗначение("Перечисление.СпособыПредоставленияСкидокНаценок.Округление"));
	СтруктураРеквизитов.Вставить("БонуснаяПрограмма", Объект.Ссылка);
	
	ОткрытьФорму("Справочник.АвтоматическиеСкидки.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", СтруктураРеквизитов));
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаНачисленияБонусовПриИзменении(Элемент)
	
	Элемент.Обновить();
	
КонецПроцедуры

#КонецОбласти