﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДеревоФайлов = ДанныеФормыВЗначение(ПрисоединенныеФайлыВыбранныхОбъектов, Тип("ДеревоЗначений"));
	
	Для каждого ВладелецФайлов Из Параметры.ВладельцыПрисоединенныхФайлов Цикл
		
		СписокПрисоединенныхФайлов = Новый Массив;
		РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(ВладелецФайлов.Значение, СписокПрисоединенныхФайлов);
		
		Если СписокПрисоединенныхФайлов.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаВладелецФайлов = ДеревоФайлов.Строки.Добавить();
		СтрокаВладелецФайлов.ВладелецФайла = ВладелецФайлов.Значение;
		СтрокаВладелецФайлов.Представление = ВладелецФайлов.Значение;
		СтрокаВладелецФайлов.ИндексКартинки = -1;
		
		Для каждого ПрисоединенныйФайл Из СписокПрисоединенныхФайлов Цикл
			
			ДополнительныеПараметры = РаботаСФайламиКлиентСервер.ПараметрыДанныхФайла();
			ДополнительныеПараметры.ИдентификаторФормы = УникальныйИдентификатор;
			ДополнительныеПараметры.ПолучатьСсылкуНаДвоичныеДанные = Ложь;
			ДанныеФайла = РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайл, ДополнительныеПараметры);
			
			СтрокаФайл = СтрокаВладелецФайлов.Строки.Добавить();
			СтрокаФайл.ВладелецФайла = ВладелецФайлов.Значение;
			СтрокаФайл.ПрисоединенныйФайл = ПрисоединенныйФайл;
			СтрокаФайл.Представление = ПрисоединенныйФайл;
			СтрокаФайл.ИндексКартинки = РаботаСФайламиСлужебныйКлиентСервер.ИндексПиктограммыФайла(ДанныеФайла.Расширение);
			СтрокаФайл.ДатаИзменения = МестноеВремя(ДанныеФайла.ДатаМодификацииУниверсальная, ЧасовойПоясСеанса());
			СтрокаФайл.Отредактировал = ДанныеФайла.АвторТекущейВерсии;
			СтрокаФайл.Автор = ДанныеФайла.Автор;
			СтрокаФайл.Редактирует = ДанныеФайла.Редактирует;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ЗначениеВДанныеФормы(ДеревоФайлов, ПрисоединенныеФайлыВыбранныхОбъектов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрисоединенныеФайлыВыбранныхОбъектов

&НаКлиенте
Процедура ПрисоединенныеФайлыВыбранныхОбъектовВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбранныеФайлы = ВыбранныеФайлы();
	Если ВыбранныеФайлы.Количество() <> 0 Тогда
		ОповеститьОВыборе(ВыбранныеФайлы);
		Возврат;
	КонецЕсли;
	
	ВыбранныеФайлы = ВсеПодчиненныеФайлыВыбранныхВладельцев();
	Если ВыбранныеФайлы.Количество() <> 0 Тогда
		ОповеститьОВыборе(ВыбранныеФайлы);
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Просмотреть(Команда)
	
	Если Элементы.ПрисоединенныеФайлыВыбранныхОбъектов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПрисоединенныйФайл = Элементы.ПрисоединенныеФайлыВыбранныхОбъектов.ТекущиеДанные.ПрисоединенныйФайл;
	
	Если НЕ ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла(ПрисоединенныйФайл));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДанныеФайла(ПрисоединенныйФайл)
	
	ДополнительныеПараметры = РаботаСФайламиКлиентСервер.ПараметрыДанныхФайла();
	ДополнительныеПараметры.ИдентификаторФормы = УникальныйИдентификатор;
	Возврат РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайл, ДополнительныеПараметры);
	
КонецФункции

&НаКлиенте
Функция ВыбранныеФайлы()
	
	ВыбранныеФайлы = Новый Массив;
	
	Для каждого ИдентификаторСтроки Из Элементы.ПрисоединенныеФайлыВыбранныхОбъектов.ВыделенныеСтроки Цикл
		Строка = ПрисоединенныеФайлыВыбранныхОбъектов.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЗначениеЗаполнено(Строка.ПрисоединенныйФайл) Тогда
			ВыбранныеФайлы.Добавить(Строка.ПрисоединенныйФайл);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВыбранныеФайлы;
	
КонецФункции

&НаКлиенте
Функция ВсеПодчиненныеФайлыВыбранныхВладельцев()
	
	ВыбранныеФайлы = Новый Массив;
	
	Для каждого ИдентификаторСтроки Из Элементы.ПрисоединенныеФайлыВыбранныхОбъектов.ВыделенныеСтроки Цикл
		Строка = ПрисоединенныеФайлыВыбранныхОбъектов.НайтиПоИдентификатору(ИдентификаторСтроки);
		ЭтоСтрокаВладелецФайлов = НЕ ЗначениеЗаполнено(Строка.ПрисоединенныйФайл);
		Если НЕ ЭтоСтрокаВладелецФайлов Тогда
			Продолжить;
		КонецЕсли;
		
		ПодчиненныеСтроки = Строка.ПолучитьЭлементы();
		Для каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл
			Если ЗначениеЗаполнено(ПодчиненнаяСтрока.ПрисоединенныйФайл) Тогда
				ВыбранныеФайлы.Добавить(ПодчиненнаяСтрока.ПрисоединенныйФайл);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ВыбранныеФайлы;
	
КонецФункции

#КонецОбласти
