﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подтвердить(Команда)
	
	ПараметрыЗакрытия = Новый Структура();
	ПараметрыЗакрытия.Вставить("Значение", Значение);
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

#КонецОбласти

