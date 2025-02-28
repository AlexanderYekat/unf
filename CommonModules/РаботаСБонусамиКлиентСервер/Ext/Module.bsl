﻿#Область ПрограммныйИнтерфейс

// Функция проверяет валюту документа, и возвращает Ложь, если валюта не соответствует национальной.
// Бонусы в этом случае начислять нельзя.
//
// Параметры:
//  Валюта - СправочникСсылка.Валюты - Валюта документа, в которой указаны суммы в строках
//  НациональнаВалюта - СправочникСсылка.Валюты - Национальная валюта ведения учета
//  ТекстОшибки - Строка - Строка с описанием ошибки
//
// Возвращаемое значение:
//	- Булево - флаг разрешающий или запрещающий операции с бонусами для документа с указанными валютами
Функция ИспользованиеБонусовЗапрещено(Валюта, НациональнаВалюта, ТекстОшибки = "") Экспорт
	
	Если ЗначениеЗаполнено(Валюта) И Валюта <> НациональнаВалюта Тогда
		ТекстОшибки = НСтр("ru = 'Оплачивать сертификатом можно только документы по договорам в национальной валюте.'");
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти