﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("СпособПополнения", "Производство");
	ОткрытьФорму("Обработка.РасчетПотребностей.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "РасчетПотребностейПроизводство", ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти 

