﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	СотрудникиПользователя = ПолучитьСотрудниковТекущегоПользователя();

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Сотрудник", СотрудникиПользователя));

	ОткрытьФорму("Отчет.ЗаданияНаРаботу.Форма", ПараметрыФормы);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьСотрудниковТекущегоПользователя()

	Возврат РегистрыСведений.СотрудникиПользователя.ПолучитьСотрудниковПользователя();

КонецФункции

#КонецОбласти
