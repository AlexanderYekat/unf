﻿
#Область ПрограммныйИнтерфейс

Функция СоздатьОбсуждениеЖурналЗвонков() Экспорт
	
	Возврат ТелефонияСервер.СоздатьОбсуждениеЖурналЗвонков();
	
КонецФункции

Функция ИдентификаторОбсужденияЖурналЗвонков() Экспорт
	
	Возврат ТелефонияСервер.ИдентификаторОбсужденияЖурналЗвонков();
	
КонецФункции

Функция ОбработатьЗвонок(НомерКонтакта, Пользователь, ДатаЗвонка, ТипЗвонка, ВариантСобытия) Экспорт
	
	Возврат ТелефонияСервер.ОбработатьЗвонок(НомерКонтакта, Пользователь, ДатаЗвонка, ТипЗвонка, ВариантСобытия);
	
КонецФункции

Функция ПолучитьДанныеВходящегоЗвонка(ОчиститьДанные = Неопределено) Экспорт
	
	Возврат ТелефонияСервер.ДанныеВходящегоЗвонкаТекущегоПользователя(ОчиститьДанные);
	
КонецФункции

Функция СсылкаНаЗаписьРазговора(Событие, Ошибка) Экспорт
	
	Возврат ТелефонияСервер.СсылкаНаЗаписьРазговора(Событие, Ошибка);
	
КонецФункции

Процедура ПозвонитьПоНомеру(НомерАбонента, Событие, Ошибка, СтрокаПояснения) Экспорт
	
	ТелефонияСервер.ПозвонитьПоНомеру(НомерАбонента,,, Событие, Ошибка, СтрокаПояснения);
	
КонецПроцедуры

#КонецОбласти
