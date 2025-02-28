﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗарплатаКадры.ДобавитьКомандуПереходаКОбработкеРедактированиюЗаконодательныхЗначений(ЭтотОбъект, Элементы.КоманднаяПанельФормы);
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВосстановитьНачальныеЗначения(Команда)
	
	ЗарплатаКадрыКлиент.ВосстановитьНачальныеЗначенияСлужебный(ЭтотОбъект, "РегистрСведений.РазмерВычетовНДФЛ");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьОбработкуРедактированиеЗаконодательныхЗначений(Команда)
	
	ЗарплатаКадрыКлиент.ОткрытьОбработкуРедактированиеЗаконодательныхЗначений();
	
КонецПроцедуры

#КонецОбласти
