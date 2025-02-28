﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура НачальноеЗаполнение() Экспорт
	
	ЗагрузитьКлассификатор();
	
КонецПроцедуры

Процедура ЗагрузитьКлассификатор() Экспорт
	
	ИменаПредопределенныхДанных = "ДГПХ,ДАВТ,ДОИП,ИЗЛД,ЛДПИ,ДГПХФЛНС,ДАВТФЛНС";
	НаименованияЭлементов = НаименованияПредопределенныхЭлементов();
	
	Для Каждого ИмяДанных Из СтрРазделить(ИменаПредопределенныхДанных, ",") Цикл
		
		Попытка
			СсылкаСправочника = ПредопределенноеЗначение("Справочник.ТрудовыеФункции." + ИмяДанных);
			ОбъектСправочника = СсылкаСправочника.ПолучитьОбъект();
		Исключение
			ОбъектСправочника = Справочники.ТрудовыеФункции.СоздатьЭлемент();
			ОбъектСправочника.ИмяПредопределенныхДанных = ИмяДанных;
		КонецПопытки;
		
		ОбъектСправочника.КодПрофессиональнойДеятельности = ИмяДанных;
		ОбъектСправочника.Наименование = НаименованияЭлементов.Получить(ИмяДанных);
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектСправочника);
		
	КонецЦикла;
	
КонецПроцедуры

Функция НаименованияПредопределенныхЭлементов()
	
	НаименованияЭлементов = Новый Соответствие;
	НаименованияЭлементов.Вставить("ДГПХ", НСтр("ru = 'Договор (работы, услуги)'"));
	НаименованияЭлементов.Вставить("ДАВТ", НСтр("ru = 'Договор авторского заказа'"));
	НаименованияЭлементов.Вставить("ДОИП", НСтр("ru = 'Договор об отчуждении исключительного права на произведения науки, литературы, искусства'"));
	НаименованияЭлементов.Вставить("ИЗЛД", НСтр("ru = 'Издательский лицензионный договор'"));
	НаименованияЭлементов.Вставить("ЛДПИ", НСтр("ru = 'Лицензионный договор о предоставлении права использования произведения науки, литературы, искусства,'"));
	НаименованияЭлементов.Вставить("ДГПХФЛНС", НСтр("ru = 'Договор (работы, услуги), страхование от несчастных случаев'"));
	НаименованияЭлементов.Вставить("ДАВТФЛНС", НСтр("ru = 'Договор авторского заказа, страхование от несчастных случаев'"));
	
	Возврат НаименованияЭлементов;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли