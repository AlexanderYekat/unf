﻿
#Область ОбработчикиСобытий

Процедура СписокЗаказовОбработкаОповещенияФрагмент(Форма, ИмяСобытия, ИмяСписка = "Список") Экспорт

	Если ИмяСобытия = "Запись_РасходнаяНакладная"
		ИЛИ ИмяСобытия = "Запись_АктВыполненныхРабот"
		ИЛИ ИмяСобытия = "Запись_ЧекККМ_с_ЗаказомПокупателя"
		ИЛИ ИмяСобытия = "ОповещениеОбОплатеЗаказа" 
		ИЛИ ИмяСобытия = "ОбновитьФормуСпискаДокументовЧекККМ" 
		ИЛИ ИмяСобытия = "ОповещениеОбИзмененииДолга" Тогда
		// АПК:280-выкл - Не смысла проверять "Видимость" таблицы формы, т.к. скрывается страница, где находится таблица
		Попытка
			Форма.Элементы[ИмяСписка].Обновить();
		Исключение
		КонецПопытки;
		// АПК:280-выкл
	КонецЕсли;

КонецПроцедуры

Процедура СписокДокументовОтгрузкиОбработкаОповещенияФрагмент(Форма, ИмяСобытия, ИмяСписка = "Список") Экспорт

	Если ИмяСобытия = "ОповещениеОбИзмененииДолга" Тогда
		// АПК:280-выкл - В случае невидимости элемента нет нужды его обновлять
		Попытка
			Форма.Элементы[ИмяСписка].Обновить();
		Исключение
		КонецПопытки;
		// АПК:280-выкл
	КонецЕсли;

КонецПроцедуры

#КонецОбласти