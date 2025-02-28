﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("ЖурналДокументыПоВнеоборотнымАктивам");
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	ПараметрыФормы = Новый Структура("ЭтоНачальнаяСтраница", Ложь);
	ОткрытьФорму("ЖурналДокументов.ДокументыПоВнеоборотнымАктивам.ФормаСписка", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
