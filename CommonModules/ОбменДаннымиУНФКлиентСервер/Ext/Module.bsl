﻿#Область СлужебныйПрограммныйИнтерфейс

Функция ТипыСтруктурныхЕдиницСкладыИМагазины() Экспорт

	Результат = Новый Массив;
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСтруктурныхЕдиниц.МагазинГруппаСкладов"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСтруктурныхЕдиниц.Склад"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСтруктурныхЕдиниц.Розница"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСтруктурныхЕдиниц.РозницаСуммовойУчет"));

	Возврат Результат;

КонецФункции

Функция НовыеПараметрыФормыВыбораДополнительныхУсловий() Экспорт

	Результат = Новый Структура;
	Результат.Вставить("ТаблицаВыбора", "");
	Результат.Вставить("ТаблицаЗаполнения", "");
	Результат.Вставить("КолонкаЗаполнения", "");
	Результат.Вставить("ЗаголовокФормыВыбора", "");
	Результат.Вставить("АдресВыбранныхЗначений", "");
	Результат.Вставить("УпорядочитьПоВозрастаниюИерархии", Ложь);
	Результат.Вставить("Фильтры", Новый Массив);

	Возврат Результат;

КонецФункции

Функция НовыйФильтрФормыВыбораДополнительныхУсловий() Экспорт

	Результат = Новый Структура;
	Результат.Вставить("ИмяПараметра", "");
	Результат.Вставить("ИмяПоля", "");
	Результат.Вставить("ЗначениеПараметра", Новый Массив);

	Возврат Результат;

КонецФункции

#КонецОбласти