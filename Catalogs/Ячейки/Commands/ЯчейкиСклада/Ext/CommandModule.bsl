﻿#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОтбора = Новый Структура("Владелец", ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура("Отбор, ТипСтруктурнойЕдиницы", ПараметрыОтбора, ПараметрыВыполненияКоманды.Источник.Объект.ТипСтруктурнойЕдиницы);
	ОткрытьФорму("Справочник.Ячейки.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
#КонецОбласти