﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ФИО = "";
	Если Не Параметры.Свойство("ФИО", ФИО) Тогда
		ТекстСообщения = НСтр("ru='Открытие формы возможно только из формы физического лица'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ФИО) = Тип("Структура") Тогда
		
		Фамилия = ФИО.Фамилия;
		Имя = ФИО.Имя;
		Отчество = ФИО.Отчество;
		
	Иначе
		
		ЧастиФИО = СтрРазделить(ФИО, " ");
		Если ЧастиФИО.Количество() > 0 Тогда
			
			Фамилия = ЧастиФИО[0];
			
			Если ЧастиФИО.Количество() > 1 Тогда
				Имя = ЧастиФИО[1];
			КонецЕсли;
			
			Если ЧастиФИО.Количество() > 2 Тогда
				ЧастиОтчества = Новый Массив;
				Для индекс = 2 По ЧастиФИО.Количество() - 1 Цикл
					ЧастиОтчества.Добавить(ЧастиФИО[индекс]);
				КонецЦикла;
				Отчество = СтрСоединить(ЧастиОтчества, " ");
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Период = ТекущаяДатаСеанса();
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СтруктураФИО = Новый Структура;
	СтруктураФИО.Вставить("Фамилия", Фамилия);
	СтруктураФИО.Вставить("Имя", Имя);
	СтруктураФИО.Вставить("Отчество", Отчество);
	СтруктураФИО.Вставить("Период", Период);
	Закрыть(СтруктураФИО);
	
КонецПроцедуры

#КонецОбласти