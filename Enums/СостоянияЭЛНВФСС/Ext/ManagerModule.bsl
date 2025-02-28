﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Находит ссылку, соответствующую коду состояния ЭЛН в ФСС.
Функция НайтиПоКодуФСС(КодФСС) Экспорт
	Если ТипЗнч(КодФСС) = Тип("Строка") Тогда
		КодЧислом = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(КодФСС);
	ИначеЕсли ТипЗнч(КодФСС) = Тип("Число") Тогда
		КодЧислом = КодФСС;
	Иначе
		КодЧислом = 0;
	КонецЕсли;
	
	Если КодЧислом = 10 Тогда
		Возврат Открыт;
		
	ИначеЕсли КодЧислом = 20 Тогда
		Возврат Продлен;
		
	ИначеЕсли КодЧислом = 30 Тогда
		Возврат Закрыт;
		
	ИначеЕсли КодЧислом = 40 Тогда
		Возврат НаправленНаМСЭ;
		
	ИначеЕсли КодЧислом = 50 Тогда
		Возврат ДополненДаннымиМСЭ;
		
	ИначеЕсли КодЧислом = 60 Тогда
		Возврат ПринятРеестрЭЛН;
		
	ИначеЕсли КодЧислом = 70 Тогда
		Возврат ПринятРеестрПВСО;
		
	ИначеЕсли КодЧислом = 80 Тогда
		Возврат ВыплаченФСС;
		
	ИначеЕсли КодЧислом = 90 Тогда
		Возврат Аннулирован;
		
	КонецЕсли;
	
	Возврат ПустаяСсылка();
КонецФункции

// Возвращает соответствие ссылок их приоритету. Чем ниже приоритет - тем выше "вес".
Функция Приоритеты() Экспорт
	Результат = Новый Соответствие;
	Результат.Вставить(Аннулирован,        1);
	Результат.Вставить(ВыплаченФСС,        2);
	Результат.Вставить(ПринятРеестрПВСО,   3);
	Результат.Вставить(ПринятРеестрЭЛН,    4);
	Результат.Вставить(Закрыт,             Приоритет_Закрыт());
	Результат.Вставить(ДополненДаннымиМСЭ, 6);
	Результат.Вставить(НаправленНаМСЭ,     7);
	Результат.Вставить(Продлен,            8);
	Результат.Вставить(Открыт,             9);
	Возврат Результат;
КонецФункции

Функция Приоритет_Закрыт() Экспорт
	Возврат 5;
КонецФункции

#КонецОбласти

#КонецЕсли