﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Параметры = ПараметрыВЗависимостиОтНаполненностиСправочника();
	
	ОткрытьФорму(Параметры.ИмяФормы, Параметры.ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПараметрыВЗависимостиОтНаполненностиСправочника()
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяФормы", "Справочник.НастройкиРассылкиСостояниеКомпании.ФормаСписка");
	Результат.Вставить("ПараметрыФормы", Новый Структура);
	
	Если Не ПравоДоступа("Добавление", Метаданные.Справочники.НастройкиРассылкиСостояниеКомпании) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	НастройкиРассылкиСостояниеКомпании.Ссылка
	|ИЗ
	|	Справочник.НастройкиРассылкиСостояниеКомпании КАК НастройкиРассылкиСостояниеКомпании");
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		СтандартнаяОбработка = Ложь;
		Результат.ИмяФормы = "Справочник.НастройкиРассылкиСостояниеКомпании.ФормаОбъекта";
		Возврат Результат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Количество() <> 1 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Выборка.Следующий();
	Результат.ПараметрыФормы.Вставить("Ключ", Выборка.Ссылка);
	Результат.ИмяФормы = "Справочник.НастройкиРассылкиСостояниеКомпании.ФормаОбъекта";
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
