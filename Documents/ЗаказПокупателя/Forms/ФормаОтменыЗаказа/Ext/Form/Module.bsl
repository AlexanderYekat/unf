﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаказов = Новый Структура;
	ПараметрыЗаказов.Вставить("ПричинаОтмены", ПричинаОтменыЗаказа);
	ПараметрыЗаказов.Вставить("Заметки", Заметки);
	
	Закрыть(ПараметрыЗаказов);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти