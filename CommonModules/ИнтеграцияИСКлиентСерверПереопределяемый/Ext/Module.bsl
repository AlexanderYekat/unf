﻿
#Область СлужебныйПрограммныйИнтерфейс

#Область СерииНоменклатуры

// Процедура устанавливает использование статусов серий необязательного вида "Можно указать"
// для объектов метаданных подсистемы ГосИС
//
// Параметры:
//  Использовать - Булево - разрешить использование статусов
//  ПараметрыУказанияСерий - Произвольный - Параметры указания серий.
Процедура ИспользоватьСтатусСерийМожноУказать(Использовать, ПараметрыУказанияСерий) Экспорт
	
	Возврат;

КонецПроцедуры

// Функция проверяет необходимость указания серии в строке по статусу.
//
// Параметры:
//  ТребуетсяУказать    - Булево - в этом статусе требуется указание серий.
//  СтатусУказанияСерий - Число  - статус указания серии в строке табличной части
//
Процедура ПроверитьНеобходимоУказатьСерию(ТребуетсяУказать, СтатусУказанияСерий) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В процедуре требуется определить признак использования серий по параметрам указания серий
//
// Параметры:
//  Использование - Булево - Признак использования серий
//  ПараметрыУказанияСерий - Произвольный - Параметры указания серий объекта конфигурации.
//
Процедура ИспользованиеСерийПоПараметрамУказанияСерий(Использование, ПараметрыУказанияСерий) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

// Заполняет представление строки номенклатуры.
//
// Параметры:
//  Представление  - Строка                                     - представление для заполнения,
//  Номенклатура   - ОпределяемыйТип.Номенклатура               - ссылка на номенклатуру,
//  Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - ссылка на характеристику номенклатуры,
//  Упаковка       - ОпределяемыйТип.Упаковка                   - ссылка на упаковку.
//  Серия          - ОпределяемыйТип.СерияНоменклатуры          - ссылка на серию номенклатуры.
Процедура ЗаполнитьПредставлениеНоменклатуры(Представление, Номенклатура, Характеристика, Упаковка, Серия) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ЗаполнитьСоответствиеПолейДокументовОснований(Форма, ТипОбъекта, СоответствиеПолей) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СерииНоменклатуры

#КонецОбласти
