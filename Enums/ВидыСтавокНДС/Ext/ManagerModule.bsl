﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

Функция ВидСтавки(СтавкаНДС) Экспорт
	Если СтавкаНДС = Неопределено ИЛИ Не ЗначениеЗаполнено(СтавкаНДС) Тогда
		Возврат Перечисления.ВидыСтавокНДС.ПустаяСсылка();
	КонецЕсли;
	Если ТипЗнч(СтавкаНДС) = Тип("СправочникСсылка.СтавкиНДС") Тогда
		РеквизитыСтавки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтавкаНДС, "Ставка,НеОблагается,Расчетная");
	Иначе
		РеквизитыСтавки = СтавкаНДС;
	КонецЕсли;
	
	Если РеквизитыСтавки.Ставка = 0 Тогда
		Если РеквизитыСтавки.НеОблагается Тогда
			Возврат Перечисления.ВидыСтавокНДС.БезНДС;
		Иначе
			Возврат Перечисления.ВидыСтавокНДС.Нулевая;
		КонецЕсли;
	ИначеЕсли РеквизитыСтавки.Ставка = 18 Тогда
		Если  РеквизитыСтавки.Расчетная Тогда
			Возврат Перечисления.ВидыСтавокНДС.ОбщаяРасчетная;
		Иначе
			Возврат Перечисления.ВидыСтавокНДС.Общая;
		КонецЕсли;
	ИначеЕсли РеквизитыСтавки.Ставка = 10 Тогда
		Если  РеквизитыСтавки.Расчетная Тогда
			Возврат Перечисления.ВидыСтавокНДС.ПониженнаяРасчетная;
		Иначе
			Возврат Перечисления.ВидыСтавокНДС.Пониженная;
		КонецЕсли;
	ИначеЕсли РеквизитыСтавки.Ставка = 20 Тогда
		Если РеквизитыСтавки.Расчетная Тогда
			Возврат Перечисления.ВидыСтавокНДС.ОбщаяРасчетная;
		Иначе
			Возврат Перечисления.ВидыСтавокНДС.Общая;
		КонецЕсли;
	Иначе
		Если РеквизитыСтавки.Ставка > 10 Тогда
			Если РеквизитыСтавки.Расчетная Тогда
				Возврат Перечисления.ВидыСтавокНДС.ОбщаяРасчетная;
			Иначе
				Возврат Перечисления.ВидыСтавокНДС.Общая;
			КонецЕсли;
		Иначе
			Если РеквизитыСтавки.Расчетная Тогда
				Возврат Перечисления.ВидыСтавокНДС.ПониженнаяРасчетная;
			Иначе
				Возврат Перечисления.ВидыСтавокНДС.Пониженная;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции



#КонецОбласти

#КонецЕсли