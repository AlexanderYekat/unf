﻿#Область ПрограммныйИнтерфейс

// Процедура заполняет КПП на базе ИНН
//
// Параметры:
//  ИНН  - Строка - ИНН на основании которого будет сгенерирован КПП;
//  КПП  - Строка - КПП, текущий КПП контрагента;
//
Процедура ЗаполнитьКПППоИНН(Знач ИНН, КПП) Экспорт
	
	// Если КПП формируется стандартным образом по ИНН, то для КПП берутся 
	// первые 4 цифры ИНН + 01001, например:
	// ИНН 7712563009
	// КПП 771201001
	
	// Если не указано ИНН то прерываем выполнение операции
	Если (СтрДлина(ИНН) < 4) Тогда
		Возврат;
	КонецЕсли;
	
	КПП = Лев(ИНН, 4) + "01001";
	
КонецПроцедуры

#КонецОбласти
