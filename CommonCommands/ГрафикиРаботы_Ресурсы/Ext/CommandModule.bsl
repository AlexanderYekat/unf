﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("Подсистема", 1);
	ОткрытьФорму("Справочник.ГрафикиРаботы.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "ГрафикиРаботы_Ресурсы", ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

#КонецОбласти