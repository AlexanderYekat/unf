﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	СтруктураЗаполнения = Новый Структура;
	СтруктураЗаполнения.Вставить("ДокументОснованиеВозврат", ПараметрКоманды);
	ОткрытьФорму("Документ.РасходнаяНакладная.ФормаОбъекта", Новый Структура("Основание", СтруктураЗаполнения));
КонецПроцедуры

#КонецОбласти