﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Если ПараметрыВыполненияКоманды.Источник = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
	ОткрытьФорму("Документ.ЧекККМ.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);

	СтатистикаИспользованияФормКлиент.ПроверитьЗаписатьСтатистикуКоманды(
		"СоздатьНаОсновании.СоздатьЧекККМ", ПараметрыВыполненияКоманды.Источник);

КонецПроцедуры

#КонецОбласти
