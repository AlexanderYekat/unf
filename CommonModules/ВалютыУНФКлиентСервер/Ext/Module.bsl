﻿#Область ПрограммныйИнтерфейс

// Функция пересчитывает сумму из одной валюты в другую
//
// Параметры:      
//	Сумма         - Число - сумма, которую следует пересчитать.
// 	КурсНач       - Число - курс из которого надо пересчитать.
// 	КурсКон       - Число - курс в который надо пересчитать.
// 	КратностьНач  - Число - кратность из которого надо пересчитать 
//                  (по умолчанию = 1).
// 	КратностьКон  - Число - кратность в который надо пересчитать 
//                  (по умолчанию = 1).
//
// Возвращаемое значение: 
//  Число - сумма, пересчитанная в другую валюту.
//
Функция Пересчитать(Сумма, КурсНач, КурсКон, КратностьНач = 1, КратностьКон = 1) Экспорт

	Если (КурсНач = КурсКон) И (КратностьНач = КратностьКон) Тогда
		Возврат Сумма;
	КонецЕсли;

	Если КурсНач = 0 Или КурсКон = 0 Или КратностьНач = 0 Или КратностьКон = 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Обнаружен нулевой курс валюты. Пересчет не выполнен.'");
		Сообщение.Сообщить();
		Возврат Сумма;
	КонецЕсли;

	Результат = Окр((Сумма * КурсНач * КратностьКон) / (КурсКон * КратностьНач), 2);

	Возврат Результат;

КонецФункции

#КонецОбласти