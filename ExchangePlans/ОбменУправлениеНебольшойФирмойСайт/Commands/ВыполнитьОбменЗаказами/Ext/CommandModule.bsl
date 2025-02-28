﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	УзелОбмена = ПараметрКоманды;

	Если УзелОбмена = ОбменССайтомПовтИсп.ПолучитьЭтотУзелПланаОбмена("ОбменУправлениеНебольшойФирмойСайт") Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр(
			"ru = 'Узел соответствует этой информационной базе и не может использоваться в обмене с сайтом. Используйте другой узел обмена или создайте новый.'"));
		Возврат;
	КонецЕсли;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УзелОбмена", УзелОбмена);
	ПараметрыФормы.Вставить("ВыгружатьТолькоИзменения", Истина);

	ПроверитьНастройкиУзла(УзелОбмена, ПараметрыФормы);
	Если Не ПараметрыФормы.ОбменЗаказами Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр(
			"ru = 'В выбранном узле не включен обмен заказами. Выполните необходимые настройки по обмену заказами.'"));
		Возврат;
	КонецЕсли;

	ОткрытьФорму("ПланОбмена.ОбменУправлениеНебольшойФирмойСайт.Форма.ФормаВыполнениеОбмена", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, УзелОбмена);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьНастройкиУзла(УзелОбмена, ПараметрыФормы)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	ОбменУправлениеНебольшойФирмойСайт.ОбменТоварами КАК ОбменТоварами,
				   |	ОбменУправлениеНебольшойФирмойСайт.ОбменЗаказами КАК ОбменЗаказами,
				   |	ОбменУправлениеНебольшойФирмойСайт.ОнлайнОплаты КАК ПечататьОнлайнЧеки
				   |ИЗ
				   |	ПланОбмена.ОбменУправлениеНебольшойФирмойСайт КАК ОбменУправлениеНебольшойФирмойСайт
				   |ГДЕ
				   |	ОбменУправлениеНебольшойФирмойСайт.Ссылка = &УзелОбмена";
	Запрос.УстановитьПараметр("УзелОбмена", УзелОбмена);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();

	Пока Выборка.Следующий() Цикл
		ПараметрыФормы.Вставить("ОбменТоварами", Ложь);
		ПараметрыФормы.Вставить("ОбменЗаказами", Выборка.ОбменЗаказами);
		ПараметрыФормы.Вставить("ОнлайнОплаты", Выборка.ПечататьОнлайнЧеки);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти
