﻿#Область СлужебныйПрограммныйИнтерфейс

Функция ЧтениеJSONВСтруктуру(Знач СтруктураВСтроке, ВернутьСоответствие = Истина) Экспорт
	
	Возврат ОбменССайтом.ЧтениеJSONВСтруктуру(СтруктураВСтроке, ВернутьСоответствие);

КонецФункции

Функция ЗаписьJSONВСтруктуру(Знач СтруктураЗначений) Экспорт
	
	Возврат ОбменССайтом.ЗаписьJSONВСтруктуру(СтруктураЗначений);
	
КонецФункции

Функция ПоляПоискаКонтрагентов(ИскатьПоНаименованию=Истина) Экспорт
	
	Возврат ОбменССайтом.ПоляПоискаКонтрагентов(ИскатьПоНаименованию);
	
КонецФункции

Функция ПоляПоискаКонтрагентовПоУмолчанию(ИскатьПоНаименованию=Истина) Экспорт
	
	Возврат ОбменССайтом.ПоляПоискаКонтрагентовПоУмолчанию(ИскатьПоНаименованию);
	
КонецФункции

Функция ТекстФайлаОбмена(УзелОбмена, ВыгружатьТолькоИзменения = Истина) Экспорт

	Возврат ОбменССайтом.ТекстФайлаОбмена(УзелОбмена, ВыгружатьТолькоИзменения);
	
КонецФункции

Функция ВыполнитьТестовоеПодключениеКСайту(СтруктураПодключения, ТекстСообщения) Экспорт
	
	Возврат ОбменССайтом.ВыполнитьТестовоеПодключениеКСайту(СтруктураПодключения, ТекстСообщения);
	
КонецФункции

#КонецОбласти
