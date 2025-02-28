﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("ЖурналДокументыПоЗапасам");
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	ПараметрыОткрытия = Новый Структура("ЭтоНачальнаяСтраница", Ложь);
	ОткрытьФорму("ЖурналДокументов.ДокументыПоЗапасам.ФормаСписка", ПараметрыОткрытия,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти
