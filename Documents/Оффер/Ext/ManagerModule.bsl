﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция СтруктураЗаполнения() Экспорт
	
	СтруктураЗаполнения = Новый Структура();
	СтруктураЗаполнения.Вставить("Кандидат", Справочники.ФизическиеЛица.ПустаяСсылка());
	СтруктураЗаполнения.Вставить("СрокПринятия", Дата(1, 1, 1, 0, 0, 0));
	СтруктураЗаполнения.Вставить("Должность", Справочники.Должности.ПустаяСсылка());
	СтруктураЗаполнения.Вставить("Подразделение", Неопределено);
	СтруктураЗаполнения.Вставить("ДолжностьПоШтатномуРасписанию", Справочники.ШтатноеРасписание.ПустаяСсылка());
	СтруктураЗаполнения.Вставить("ДатаВыходаНаРаботу", Дата(1, 1, 1, 0, 0, 0));
	СтруктураЗаполнения.Вставить("ИдентификаторДокумента", "");
	
	Возврат СтруктураЗаполнения;
	
КонецФункции 

Функция НовыйДокумент(СтруктураЗаполнения) Экспорт

	ДокументОбъект = Документы.Оффер.СоздатьДокумент();
	
	ДокументОбъект.Дата = ТекущаяДатаСеанса();
	ЗаполнитьЗначенияСвойств(ДокументОбъект, СтруктураЗаполнения);
	
	Возврат ДокументОбъект;

КонецФункции


#КонецОбласти

#КонецЕсли