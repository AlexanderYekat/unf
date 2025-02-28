﻿#Область СлужебныйПрограммныйИнтерфейс

&НаКлиенте
// Функция определяет разность дат в месяцах.
//
Функция СрокПоДатеОкончания(ДатаОкончания, ДатаНачала) Экспорт

	Если ДатаОкончания < ДатаНачала Тогда
		Возврат 0;
	КонецЕсли;

	ГодНачала = Год(ДатаНачала);
	ГодОкончания = Год(ДатаОкончания);

	МесяцНачала = Месяц(ДатаНачала);
	МесяцОкончания = Месяц(ДатаОкончания);

	ДеньНачала = День(ДатаНачала);
	ДеньОкончания = День(ДатаОкончания);
	
	Если МесяцОкончания < МесяцНачала Тогда
		ВычитаемыйГод = 1;
		ВычитаемыеМесяцы = 12;
	Иначе
		ВычитаемыйГод = 0;
		ВычитаемыеМесяцы = 0;
	КонецЕсли;
	
	Если ДеньОкончания < ДеньНачала Тогда
		ВычитаемыеДни = 1;
	Иначе
		ВычитаемыеДни = 0;
	КонецЕсли;

	Возврат Макс(((ГодОкончания - ГодНачала) - ВычитаемыйГод), 0) * 12 + (МесяцОкончания - МесяцНачала + 1
		+ ВычитаемыеМесяцы - ВычитаемыеДни);

КонецФункции

// Выполняет расчет коэффициента для аннуитетных платежей.
//
// Параметры:
//	Ставка - Число - процентная ставка за период погашения (месяц)
//	Срок - Число - количество периодов погашения (месяцев)
// Возвращаемое значение:
// 	Число - коэффициент аннуитетных платежей
&НаКлиенте
Функция КоэффициентАннуитета(Ставка, Срок) Экспорт

	Если Срок = 0 Тогда
		Возврат 0;
	КонецЕсли;

	Если Ставка = 0 Тогда
		Возврат 1 / Срок;
	КонецЕсли;

	Возврат Ставка / (1 - Pow(1 + Ставка, -Срок));

КонецФункции

&НаКлиенте
Функция ПроцентнаяСтавкаЗаМесяц(ПроцентнаяСтавкаГодовая) Экспорт

	Если ПроцентнаяСтавкаГодовая = 0 Тогда
		Возврат 0;
	Иначе
		Возврат ПроцентнаяСтавкаГодовая / 12;
	КонецЕсли;

КонецФункции

#КонецОбласти