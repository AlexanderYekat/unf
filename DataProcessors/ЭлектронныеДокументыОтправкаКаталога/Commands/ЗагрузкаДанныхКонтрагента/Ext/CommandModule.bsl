﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура("Контрагент", ПараметрКоманды);

	ОткрытьФорму("Обработка.ОбменСКонтрагентами.Форма.ЗагрузкаРеквизитовКонтрагента", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти
