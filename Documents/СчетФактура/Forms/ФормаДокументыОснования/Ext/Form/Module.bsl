﻿
#Область Служебные

&НаКлиенте
Процедура ПроверитьЗаполнениеРеквизитовФормы(Отказ)
	
	НомерСтроки = 0;
	Для каждого СтрокаДокументыОснования Из ДокументыОснования Цикл
		
		НомерСтроки = НомерСтроки + 1;
		Если НЕ ЗначениеЗаполнено(СтрокаДокументыОснования.ДокументОснование) Тогда
			
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Не заполнена колонка ""Документ основание"" в строке '")
				+ Строка(НомерСтроки)
				+ НСтр("ru = ' списка ""Документы основания"".'");
			Сообщение.Поле = "Документ";
			Сообщение.Сообщить();
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДокументыОснованияВХранилище()
	
	ДокументыОснованияВХранилище = ДокументыОснования.Выгрузить(, "ДокументОснование");
	ДокументыОснованияВХранилище.Свернуть("ДокументОснование");
	
	ПоместитьВоВременноеХранилище(ДокументыОснованияВХранилище, КэшЗначений.АдресОснований);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыИспользуемыхДокументов()
	
	ТипыРеализаций = Новый Массив(2);
	ТипыРеализаций[0] = Тип("ДокументСсылка.РасходнаяНакладная");
	ТипыРеализаций[1] = Тип("ДокументСсылка.АктВыполненныхРабот");
	
	ТипыАвансов = Новый Массив(3);
	ТипыАвансов[0] = Тип("ДокументСсылка.ОперацияПоПлатежнымКартам");
	ТипыАвансов[1] = Тип("ДокументСсылка.ПоступлениеНаСчет");
	ТипыАвансов[2] = Тип("ДокументСсылка.ПоступлениеВКассу");
	
	Для каждого СтрокаТаблицы Из ДокументыОснования Цикл
		
		ТипДокументаОснования = ТипЗнч(СтрокаТаблицы.ДокументОснование);
		
		Если КэшЗначений.ЕстьРеализация = Неопределено
			И ТипыРеализаций.Найти(ТипДокументаОснования) <> Неопределено Тогда
			
			КэшЗначений.ЕстьРеализация = Истина;
			КэшЗначений.ЕстьОтчетКомитенту = Ложь;
			КэшЗначений.ЕстьАвансы = Ложь;
			Прервать;
			
		ИначеЕсли КэшЗначений.ЕстьОтчетКомитенту = Неопределено 
			И ТипДокументаОснования = Тип("ДокументСсылка.ОтчетКомитенту") Тогда
			
			КэшЗначений.ЕстьОтчетКомитенту = Истина;
			КэшЗначений.ЕстьРеализация = Ложь;
			КэшЗначений.ЕстьАвансы = Ложь;
			Прервать;
			
		ИначеЕсли КэшЗначений.ЕстьАвансы = Неопределено
			И ТипыАвансов.Найти(ТипДокументаОснования) <> Неопределено Тогда
			
			КэшЗначений.ЕстьРеализация = Ложь;
			КэшЗначений.ЕстьОтчетКомитенту = Ложь;
			КэшЗначений.ЕстьАвансы = Истина;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура АдаптироватьПараметрыФормы()
	
	КэшЗначений.ЕстьОтчетКомитенту = ?(ТипЗнч(КэшЗначений.ЕстьОтчетКомитенту) <> Тип("Булево"), Ложь, КэшЗначений.ЕстьОтчетКомитенту);
	КэшЗначений.ЕстьРеализация = ?(ТипЗнч(КэшЗначений.ЕстьРеализация) <> Тип("Булево"), Ложь, КэшЗначений.ЕстьРеализация);
	КэшЗначений.ЕстьАвансы = (КэшЗначений.ВидОперации = Перечисления.ВидыОперацийСчетФактура.Аванс ИЛИ КэшЗначений.ВидОперации = Перечисления.ВидыОперацийСчетФактура.КорректировкаАванса);
	
	Если КэшЗначений.ЕстьОтчетКомитенту = Ложь
		И КэшЗначений.ЕстьРеализация = Ложь
		И КэшЗначений.ЕстьАвансы = Ложь Тогда
		
		КэшЗначений.ЕстьРеализация = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Форма

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИменаПолей =
	"Ссылка,
	|ВидОперации, ЭтоВозврат, Исправление,
	|Организация, Контрагент, Договор, Валюта,
	|АдресОснований,
	|ЕстьОтчетКомитенту, ЕстьРеализация, ЕстьАвансы,
	|ТолькоПросмотрСпискаОснований";
	
	КэшЗначений = Новый Структура(ИменаПолей);
	ЗаполнитьЗначенияСвойств(КэшЗначений, Параметры);
	АдаптироватьПараметрыФормы();
	
	ДокументыОснования.Загрузить(ПолучитьИзВременногоХранилища(КэшЗначений.АдресОснований));
	ЗаполнитьВидыИспользуемыхДокументов();
	
	Если КэшЗначений.ТолькоПросмотрСпискаОснований = Истина Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДокументыОснования", "ТолькоПросмотр", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОК", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОК", "Доступность", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура ОК(Команда)
	
	Отказ = Ложь;
	ПроверитьЗаполнениеРеквизитовФормы(Отказ);
	
	Если НЕ Отказ Тогда
		
		ЗаписатьДокументыОснованияВХранилище();
		КэшЗначений.Вставить("ВыполненаКоманда", КодВозвратаДиалога.OK);
		
		Закрыть(КэшЗначений);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область РеквизитыФормы

&НаКлиенте
Процедура ДокументыОснованияДокументОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Документ.СчетФактура.Форма.ФормаПодбораДокументовОснований", КэшЗначений, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыОснованияДокументОснованиеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекСтрока = Элементы.ДокументыОснования.ТекущиеДанные;
	ТекСтрока.ДокументОснование = ?(ТипЗнч(ВыбранноеЗначение) = Тип("Структура"), ВыбранноеЗначение.Документ, ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти