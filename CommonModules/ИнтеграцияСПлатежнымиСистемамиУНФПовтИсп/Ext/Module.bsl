﻿
#Область ПрограммныйИнтерфейс

// Определяет доступность использования функциональности выполнения операций
// в платежной системе на основании прав доступа пользователя.
//
// Возвращаемое значение:
//  Булево - если Истина, оплата в платежной системе доступна.
//
Функция ИнтеграцияДоступна() Экспорт

	Возврат ИнтеграцияСПлатежнымиСистемамиУНФ.ИнтеграцияДоступна();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСписокТиповДокументов() Экспорт
	
	ИменаОснованийПлатежа = Новый Массив;

	Для Каждого Тип Из Метаданные.ОпределяемыеТипы.ДокументОперацииСБП.Тип.Типы() Цикл
		
		ПолноеИмяДокумента = Метаданные.НайтиПоТипу(Тип).ПолноеИмя();
		
		Если Не СтрЗаканчиваетсяНа(ПолноеИмяДокумента, ".ПлатежнаяСсылкаСБПc2b") Тогда
			ИменаОснованийПлатежа.Добавить(ПолноеИмяДокумента);
		КонецЕсли
		
	КонецЦикла;
	
	Возврат ИменаОснованийПлатежа;
	
КонецФункции

#КонецОбласти
