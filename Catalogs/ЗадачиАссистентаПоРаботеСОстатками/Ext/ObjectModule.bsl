﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Автор) Тогда
		Автор = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = Ложь;
	ДополнительныеСвойства.Свойство("ЭтоНовый", ЭтоНовый);
	
	АссистентУправления.УдалитьЗапланированныеЗаписиЗадачи(Ссылка);
	ЗапланироватьНовыеЗадачи();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПередВыполнениемЗадачи(Предмет, Источник, ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	
	
КонецПроцедуры

Процедура ВыполнитьЗадачу(Предмет, Источник, ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	ДанныеОбОстатках = МинимальныеОстаткиЗапасовНаСкладах();
	Если ДанныеОбОстатках.Количество() = 0 И Не НеобходимоПоприветствовать Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоОтправкаСообщенияОбсуждения = ЭтоОтправкаСообщенияОбсуждения();
	ЭтоОтправкаEmail = ЭтоОтправкаEmail();
	
	Если Не ЭтоОтправкаEmail И Не ЭтоОтправкаСообщенияОбсуждения Тогда
		ТекстОшибки = НСтр("ru='Не заполнен ни адрес электронной почты, ни обсуждение для отправки сообщения.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если ДанныеОбОстатках.Количество() = 0 И НеобходимоПоприветствовать Тогда
		ТекстСообщения = ТекстСообщенияОстатковДостаточно(ЭтоОтправкаEmail);
	Иначе
		ТекстСообщения = ТекстСообщенияОбОстаткахЗапасов(ДанныеОбОстатках, ЭтоОтправкаEmail);
	КонецЕсли;
	
	ДобавитьКнопкуЗаказать = ДанныеОбОстатках.Количество() <> 0;
	
	Если ЭтоОтправкаEmail Тогда
		СоздатьEmail(ТекстСообщения);
	Иначе
		ДанныеСообщения = ОбсужденияУНФ.НовыйДанныеСообщения();
		ДанныеСообщения.Текст = ТекстСообщения;
		ДанныеСообщения.Данные = ДанныеСообщенияОбОстатках(ДанныеОбОстатках);
		ДобавитьКнопкуПереходаВРасчетПотребностей(ДанныеОбОстатках, ДанныеСообщения.Действия);
		СоздатьСообщениеОбсуждения(ДанныеСообщения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыполненияЗадачи(Предмет, Источник, ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	Если НеобходимоПоприветствовать Тогда
		СброситьПризнакНеобходимоПоприветствовать();
	КонецЕсли;
	ЗапланироватьНовыеЗадачи();
	
КонецПроцедуры

Процедура ПоприветствоватьПользователяПередПервымВыполнением() Экспорт
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Используется Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоОтправкаСообщенияОбсуждения = ЭтоОтправкаСообщенияОбсуждения();
	ЭтоОтправкаEmail = ЭтоОтправкаEmail();
	
	Если Не ЭтоОтправкаEmail И Не ЭтоОтправкаСообщенияОбсуждения Тогда
		ТекстОшибки = НСтр("ru='Не заполнен ни адрес электронной почты, ни обсуждение для отправки сообщения.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ДанныеСообщения = ОбсужденияУНФ.НовыйДанныеСообщения();
	ДанныеСообщения.Текст = ТекстСообщенияПриветствиеПередПервымВыполнением();
	ДанныеСообщения.Получатель = Пользователи.АвторизованныйПользователь();
	СоздатьСообщениеОбсуждения(ДанныеСообщения, Истина);
	
	НовыеЗадачиКВыполнению = АссистентУправления.НовыйТаблицаРегулярныхЗадачКВыполнению();
	НоваяЗадача = НовыеЗадачиКВыполнению.Добавить();
	НоваяЗадача.Дата = НачалоДня(ТекущаяДатаСеанса());
	НоваяЗадача.Задача = Ссылка;
	
	АссистентУправления.ЗапланироватьВыполнениеРегулярныхЗадач(НовыеЗадачиКВыполнению);
	АссистентУправления.ВыполнитьРегулярныеЗадачиСейчасВФоне();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗапланироватьНовыеЗадачи()
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Используется Тогда
		Возврат;
	КонецЕсли;
	
	НовыеЗадачиКВыполнению = АссистентУправления.НовыйТаблицаРегулярныхЗадачКВыполнению();
	Справочники.ЗадачиАссистентаПоРаботеСОстатками.ЗапланироватьЗадачиКВыполнению(
		НовыеЗадачиКВыполнению, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка));
	Если НовыеЗадачиКВыполнению.Количество() <> 0 Тогда
		АссистентУправления.ЗапланироватьВыполнениеРегулярныхЗадач(НовыеЗадачиКВыполнению);
	КонецЕсли;
	
КонецПроцедуры

Функция МинимальныеОстаткиЗапасовНаСкладах()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УправлениеЗапасами.Организация КАК Организация,
	|	УправлениеЗапасами.Склад КАК Склад,
	|	УправлениеЗапасами.Номенклатура КАК Номенклатура,
	|	УправлениеЗапасами.Характеристика КАК Характеристика,
	|	УправлениеЗапасами.МинимальныйУровеньЗапаса КАК МинимальныйУровеньЗапаса,
	|	УправлениеЗапасами.МаксимальныйУровеньЗапаса КАК МаксимальныйУровеньЗапаса,
	|	ЕСТЬNULL(ОстаткиТоваров.Количество, 0) КАК ФактическийУровеньЗапаса,
	|	ЕСТЬNULL(ОстаткиТоваров.Резерв, 0) КАК ФактическийРезервЗапаса,
	|	ЕСТЬNULL(ОстаткиТоваров.Количество + ОстаткиТоваров.Резерв, 0) КАК ФактическийУровеньРезервЗапаса
	|ПОМЕСТИТЬ ВТ_НоменклатураУровеньЗапаса
	|ИЗ
	|	РегистрСведений.УправлениеЗапасами КАК УправлениеЗапасами
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОстаткиТоваров КАК ОстаткиТоваров
	|		ПО УправлениеЗапасами.Организация = ОстаткиТоваров.Организация
	|			И УправлениеЗапасами.Номенклатура = ОстаткиТоваров.Номенклатура
	|			И УправлениеЗапасами.Характеристика = ОстаткиТоваров.Характеристика
	|			И УправлениеЗапасами.Склад = ОстаткиТоваров.СтруктурнаяЕдиница
	|ГДЕ
	|	УправлениеЗапасами.Организация = &Организация
	|	И УправлениеЗапасами.Склад = &СтруктурнаяЕдиница
	|	И (ОстаткиТоваров.Количество ЕСТЬ NULL
	|			ИЛИ ОстаткиТоваров.Количество <= УправлениеЗапасами.МинимальныйУровеньЗапаса)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказыПоставщикамОстатки.ЗаказПоставщику КАК Заказ,
	|	ЗаказыПоставщикамОстатки.Номенклатура КАК Номенклатура,
	|	ЗаказыПоставщикамОстатки.Характеристика КАК Характеристика,
	|	ЗаказыПоставщикамОстатки.КоличествоОстаток КАК КоличествоЗаказано
	|ПОМЕСТИТЬ ВТ_НоменклатураЗаказано
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам.Остатки(
	|			,
	|			(Номенклатура, Характеристика) В
	|					(ВЫБРАТЬ
	|						ВТ_НоменклатураУровеньЗапаса.Номенклатура КАК Номенклатура,
	|						ВТ_НоменклатураУровеньЗапаса.Характеристика КАК Характеристика
	|					ИЗ
	|						ВТ_НоменклатураУровеньЗапаса КАК ВТ_НоменклатураУровеньЗапаса)
	|				И Организация = &Организация
	|				И Склад = &СтруктурнаяЕдиница) КАК ЗаказыПоставщикамОстатки
	|ГДЕ
	|	ЗаказыПоставщикамОстатки.КоличествоОстаток > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗаказыНаПроизводствоОстатки.ЗаказНаПроизводство,
	|	ЗаказыНаПроизводствоОстатки.Номенклатура,
	|	ЗаказыНаПроизводствоОстатки.Характеристика,
	|	ЗаказыНаПроизводствоОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ЗаказыНаПроизводство.Остатки(
	|			,
	|			(Номенклатура, Характеристика) В
	|					(ВЫБРАТЬ
	|						ВТ_НоменклатураУровеньЗапаса.Номенклатура,
	|						ВТ_НоменклатураУровеньЗапаса.Характеристика
	|					ИЗ
	|						ВТ_НоменклатураУровеньЗапаса КАК ВТ_НоменклатураУровеньЗапаса)
	|				И Организация = &Организация
	|				И Склад = &СтруктурнаяЕдиница) КАК ЗаказыНаПроизводствоОстатки
	|ГДЕ
	|	ЗаказыНаПроизводствоОстатки.КоличествоОстаток > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РазмещениеЗаказовОстатки.ИсточникОбеспечения КАК Заказ,
	|	РазмещениеЗаказовОстатки.Номенклатура КАК Номенклатура,
	|	РазмещениеЗаказовОстатки.Характеристика КАК Характеристика,
	|	РазмещениеЗаказовОстатки.КоличествоОстаток КАК ЗаказаноПодЗаказ
	|ПОМЕСТИТЬ ВТ_РазмещениеЗаказов
	|ИЗ
	|	РегистрНакопления.РазмещениеЗаказов.Остатки(
	|			,
	|			(Номенклатура, Характеристика) В
	|					(ВЫБРАТЬ
	|						ВТ_НоменклатураУровеньЗапаса.Номенклатура,
	|						ВТ_НоменклатураУровеньЗапаса.Характеристика
	|					ИЗ
	|						ВТ_НоменклатураУровеньЗапаса КАК ВТ_НоменклатураУровеньЗапаса)
	|				И Организация = &Организация) КАК РазмещениеЗаказовОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_НоменклатураЗаказано.Заказ КАК Заказ,
	|	ВТ_НоменклатураЗаказано.Номенклатура КАК Номенклатура,
	|	ВТ_НоменклатураЗаказано.Характеристика КАК Характеристика,
	|	ВТ_НоменклатураЗаказано.КоличествоЗаказано - ЕСТЬNULL(ВТ_РазмещениеЗаказов.ЗаказаноПодЗаказ, 0) КАК КоличествоЗаказаноСвободно,
	|	ГрафикДвиженияЗапасов.Период КАК ДатаПоступления
	|ПОМЕСТИТЬ ВТ_НоменклатураЗаказаноОжидаетсяПоЗаказам
	|ИЗ
	|	ВТ_НоменклатураЗаказано КАК ВТ_НоменклатураЗаказано
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ГрафикДвиженияЗапасов КАК ГрафикДвиженияЗапасов
	|		ПО ВТ_НоменклатураЗаказано.Заказ = ГрафикДвиженияЗапасов.Заказ
	|			И ВТ_НоменклатураЗаказано.Номенклатура = ГрафикДвиженияЗапасов.Номенклатура
	|			И ВТ_НоменклатураЗаказано.Характеристика = ГрафикДвиженияЗапасов.Характеристика
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_РазмещениеЗаказов КАК ВТ_РазмещениеЗаказов
	|		ПО ВТ_НоменклатураЗаказано.Заказ = ВТ_РазмещениеЗаказов.Заказ
	|			И ВТ_НоменклатураЗаказано.Номенклатура = ВТ_РазмещениеЗаказов.Номенклатура
	|			И ВТ_НоменклатураЗаказано.Характеристика = ВТ_РазмещениеЗаказов.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ВТ_НоменклатураЗаказаноОжидаетсяПоЗаказам.Заказ) КАК КоличествоЗаказов,
	|	ВТ_НоменклатураЗаказаноОжидаетсяПоЗаказам.Номенклатура КАК Номенклатура,
	|	ВТ_НоменклатураЗаказаноОжидаетсяПоЗаказам.Характеристика КАК Характеристика,
	|	СУММА(ВТ_НоменклатураЗаказаноОжидаетсяПоЗаказам.КоличествоЗаказаноСвободно) КАК КоличествоЗаказаноСвободно,
	|	МИНИМУМ(ВТ_НоменклатураЗаказаноОжидаетсяПоЗаказам.ДатаПоступления) КАК БлижайшаяДатаПоступления
	|ПОМЕСТИТЬ ВТ_НоменклатураЗаказаноОжидается
	|ИЗ
	|	ВТ_НоменклатураЗаказаноОжидаетсяПоЗаказам КАК ВТ_НоменклатураЗаказаноОжидаетсяПоЗаказам
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_НоменклатураЗаказаноОжидаетсяПоЗаказам.Номенклатура,
	|	ВТ_НоменклатураЗаказаноОжидаетсяПоЗаказам.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_НоменклатураУровеньЗапаса.Склад КАК СтруктурнаяЕдиница,
	|	ВТ_НоменклатураУровеньЗапаса.Номенклатура КАК Номенклатура,
	|	ВТ_НоменклатураУровеньЗапаса.Номенклатура.Код КАК КодНоменклатуры,
	|	ВТ_НоменклатураУровеньЗапаса.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВТ_НоменклатураУровеньЗапаса.Характеристика КАК Характеристика,
	|	ВТ_НоменклатураУровеньЗапаса.МинимальныйУровеньЗапаса КАК МинимальныйУровеньЗапаса,
	|	ВТ_НоменклатураУровеньЗапаса.МаксимальныйУровеньЗапаса КАК МаксимальныйУровеньЗапаса,
	|	ВТ_НоменклатураУровеньЗапаса.ФактическийУровеньЗапаса КАК ФактическийУровеньЗапаса,
	|	ВТ_НоменклатураУровеньЗапаса.ФактическийРезервЗапаса КАК ФактическийРезервЗапаса,
	|	ВТ_НоменклатураУровеньЗапаса.ФактическийУровеньРезервЗапаса КАК ФактическийУровеньРезервЗапаса,
	|	ВТ_НоменклатураЗаказаноОжидается.КоличествоЗаказов КАК КоличествоДокументовЗаказано,
	|	ВТ_НоменклатураЗаказаноОжидается.КоличествоЗаказаноСвободно КАК ОжидаетсяКПоступлениюКоличество,
	|	ВТ_НоменклатураЗаказаноОжидается.БлижайшаяДатаПоступления КАК ОжидаетсяКПоступлениюДата
	|ИЗ
	|	ВТ_НоменклатураУровеньЗапаса КАК ВТ_НоменклатураУровеньЗапаса
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_НоменклатураЗаказаноОжидается КАК ВТ_НоменклатураЗаказаноОжидается
	|		ПО ВТ_НоменклатураУровеньЗапаса.Номенклатура = ВТ_НоменклатураЗаказаноОжидается.Номенклатура
	|			И ВТ_НоменклатураУровеньЗапаса.Характеристика = ВТ_НоменклатураЗаказаноОжидается.Характеристика";
	
	Результат = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОписаниеОстатка = Новый Структура;
		ОписаниеОстатка.Вставить("СтруктурнаяЕдиница", Выборка.СтруктурнаяЕдиница);
		ОписаниеОстатка.Вставить("Номенклатура", Выборка.Номенклатура);
		ОписаниеОстатка.Вставить("КодНоменклатуры", Выборка.КодНоменклатуры);
		ОписаниеОстатка.Вставить("Характеристика", Выборка.Характеристика);
		ОписаниеОстатка.Вставить("ЕдиницаИзмерения", Выборка.ЕдиницаИзмерения);
		ОписаниеОстатка.Вставить("ФактическийУровеньЗапаса", Выборка.ФактическийУровеньЗапаса);
		ОписаниеОстатка.Вставить("МинимальныйУровеньЗапаса", Выборка.МинимальныйУровеньЗапаса);
		ОписаниеОстатка.Вставить("ОжидаетсяКПоступлениюКоличество", Выборка.ОжидаетсяКПоступлениюКоличество);
		ОписаниеОстатка.Вставить("ОжидаетсяКПоступлениюДата", Выборка.ОжидаетсяКПоступлениюДата);
		Результат.Добавить(ОписаниеОстатка);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ТекстСообщенияПриветствиеПередПервымВыполнением()
	
	ТекстСообщения = НСтр("ru='Теперь я буду следить за складскими остатками.
	|Если уровень запасов опустится до минимального, напишу об этом в обсуждении.
	|
	|Через минуту проверю текущие остатки, а дальше буду выполнять проверку каждый день в интервале %1 часов.'");
	ДобавитьТекстДобрыйДень(ТекстСообщения);
	ТекстСообщения = СтрШаблон(ТекстСообщения, ИнтервалВыполненияЗадачТекстом());
	Возврат ТекстСообщения;
	
КонецФункции

Функция ТекстСообщенияОстатковДостаточно(ЭтоОтправкаEmail)
	
	ТекстСообщения = НСтр("ru='Проверила остатки и увидела, что сейчас на складе «%1» уровень остатков выше заданного минимального.
	|
	|Дальше буду оповещать только при снижении уровня до минимального.'");
	Если ЭтоОтправкаEmail Тогда
		ДобавитьТекстДобрыйДень(ТекстСообщения);
		ДобавитьТекстПодписи(ТекстСообщения);
	КонецЕсли;
	ТекстСообщения = СтрШаблон(ТекстСообщения, СтруктурнаяЕдиница);
	Возврат ТекстСообщения;
	
КонецФункции

Процедура ДобавитьТекстДобрыйДень(ТекстСообщения)
	
	КомпонентыСтроки = Новый Массив;
	КомпонентыСтроки.Добавить(НСтр("ru='Добрый день!'")); // АПК:374
	КомпонентыСтроки.Добавить(Символы.ПС);
	КомпонентыСтроки.Добавить(Символы.ПС);
	КомпонентыСтроки.Добавить(ТекстСообщения);
	ТекстСообщения = СтрСоединить(КомпонентыСтроки);
	
КонецПроцедуры

Процедура ДобавитьТекстПодписи(ТекстСообщения)
	
	КомпонентыСтроки = Новый Массив;
	КомпонентыСтроки.Добавить(ТекстСообщения);
	КомпонентыСтроки.Добавить(Символы.ПС);
	КомпонентыСтроки.Добавить(Символы.ПС);
	КомпонентыСтроки.Добавить(НСтр("ru='С уважением, Даша
	|Ассистент 1С:Управление нашей фирмой'"));
	ТекстСообщения = СтрСоединить(КомпонентыСтроки);
	
КонецПроцедуры

Функция ТекстСообщенияОбОстаткахЗапасов(ДанныеОбОстатках, ЭтоОтправкаEmail)
	
	ТекстСообщения = НСтр("ru='Проверила остатки и увидела, что на складе «%1» заканчиваются следующие товары:
	|
	|%2
	|
	|Закажите их, чтобы пополнить запасы до того, как они закончатся.'");
	Если ЭтоОтправкаEmail Тогда
		ДобавитьТекстДобрыйДень(ТекстСообщения);
		ДобавитьТекстПодписи(ТекстСообщения);
	КонецЕсли;
	
	ТекстСообщенияСтрокаТовара = НСтр("ru='[НомерСтоки]. [КодНоменклатуры] [НоменклатураПредставление] [ХарактеристикаПредставление]
	|Сейчас на складе [ФактическийУровеньЗапаса] шт. (минимальный уровень [МинимальныйУровеньЗапаса]).
	|Заказано [ОжидаетсяКПоступлениюКоличество] шт., поступление ожидается [ОжидаетсяКПоступлениюДатаСтрокой].'");
	ТекстСообщенияСтрокаТовараОжидаетсяПоступление = НСтр("ru='[НомерСтоки]. [КодНоменклатуры] [НоменклатураПредставление] [ХарактеристикаПредставление]
	|Сейчас на складе [ФактическийУровеньЗапаса] шт. (минимальный уровень [МинимальныйУровеньЗапаса]).'");
	
	ТекстСообщенияСтроки = Новый Массив;
	Итератор = 1;
	Для каждого СтрокаОстатка Из ДанныеОбОстатках Цикл
		Если СтрокаОстатка.ОжидаетсяКПоступлениюКоличество <> NULL И СтрокаОстатка.ОжидаетсяКПоступлениюКоличество > 0 Тогда
			ТекстСообщенияСтрокаШаблон = ТекстСообщенияСтрокаТовара;
		Иначе
			ТекстСообщенияСтрокаШаблон = ТекстСообщенияСтрокаТовараОжидаетсяПоступление;
		КонецЕсли;
		СтрокаОстатка.Вставить("НомерСтоки", Итератор);
		Если Не ЭтоОтправкаEmail Тогда
			СтрокаОстатка.Вставить("НоменклатураПредставление", ПолучитьНавигационнуюСсылку(СтрокаОстатка.Номенклатура));
		Иначе
			СтрокаОстатка.Вставить("НоменклатураПредставление", СтрокаОстатка.Номенклатура);
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаОстатка.Характеристика) И СтрокаОстатка <> NULL Тогда
			СтрокаОстатка.Вставить("ХарактеристикаПредставление", "(" + Строка(СтрокаОстатка.Характеристика) + ")");
		Иначе
			СтрокаОстатка.Вставить("ХарактеристикаПредставление", "");
		КонецЕсли;
		СтрокаОстатка.Вставить("ОжидаетсяКПоступлениюДатаСтрокой", Формат(СтрокаОстатка.ОжидаетсяКПоступлениюДата, "ДЛФ=Д"));
		
		СтрокаОстатка = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ТекстСообщенияСтрокаШаблон, СтрокаОстатка);
		ТекстСообщенияСтроки.Добавить(СтрокаОстатка);
		Итератор = Итератор + 1;
	КонецЦикла;
	
	ТекстСообщенияВсеТоварыСтрокой = СтрСоединить(ТекстСообщенияСтроки, Символы.ПС);
	Возврат СтрШаблон(ТекстСообщения, СтруктурнаяЕдиница, ТекстСообщенияВсеТоварыСтрокой);
	
КонецФункции

Функция ИнтервалВыполненияЗадачТекстом()
	
	ВремяОтправленияЗадач = Справочники.ЗадачиАссистентаПоРаботеСОстатками.ВремяОтправленияЗадач();
	Если ВремяОтправленияЗадач = 8 Тогда
		Текст = НСтр("ru='8 - 12'");
	ИначеЕсли ВремяОтправленияЗадач = 16 Тогда
		Текст = НСтр("ru='6 - 12'");
	Иначе
		Текст = СтрШаблон(НСтр("ru='%1 - %2'"), ВремяОтправленияЗадач - 1, ВремяОтправленияЗадач + 1);
	КонецЕсли;
	Возврат Текст;
	
КонецФункции

Функция ЭтоОтправкаEmail()
	
	Возврат ЗначениеЗаполнено(УчетнаяЗапись) И ЗначениеЗаполнено(ПользовательДляОповещения);
	
КонецФункции

Функция ЭтоОтправкаСообщенияОбсуждения()
	
	Если СпособОповещения = Перечисления.СпособОповещенияАссистентаУправления.СообщениеЛичногоОбсужденияПользователю
		И ЗначениеЗаполнено(ПользовательДляОповещения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если СпособОповещения = Перечисления.СпособОповещенияАссистентаУправления.СообщениеОбщегоОбсуждения
		И ЗначениеЗаполнено(ИдентификаторОбщегоОбсуждения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура СоздатьEmail(ТекстСообщения)
	
	ПредставлениеПолучателя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПользовательДляОповещения, "Наименование");
	КонтактнаяИнформацияПользователя = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
		ПользовательДляОповещения, Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,, Ложь);
	АдресаЭлектроннойПочты = Новый Массив;
	Для каждого ДанныеКонтактнойИнформации Из КонтактнаяИнформацияПользователя Цикл
		ОписаниеПолучателя = Новый Структура;
		ОписаниеПолучателя.Вставить("Адрес", ДанныеКонтактнойИнформации.Представление);
		ОписаниеПолучателя.Вставить("Представление", ПредставлениеПолучателя);
		АдресаЭлектроннойПочты.Добавить(ОписаниеПолучателя);
	КонецЦикла;
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Кому", АдресаЭлектроннойПочты);
	ПараметрыПисьма.Вставить("Тема", НСтр("ru='Минимальный уровень остатков на складе'"));
	ПараметрыПисьма.Вставить("Тело", ТекстСообщения);
	ПочтовоеСообщение = РаботаСПочтовымиСообщениями.ПодготовитьПисьмо(УчетнаяЗапись, ПараметрыПисьма);
	РаботаСПочтовымиСообщениями.ОтправитьПисьмо(УчетнаяЗапись, ПочтовоеСообщение);
	
КонецПроцедуры

Процедура СоздатьСообщениеОбсуждения(ДанныеСообщения, ОтправитьСейчас = Ложь)
	
	Если ЗначениеЗаполнено(ИдентификаторОбщегоОбсуждения) Тогда
		ДанныеСообщения.Объект = Новый ИдентификаторОбсужденияСистемыВзаимодействия(ИдентификаторОбщегоОбсуждения);
	ИначеЕсли ЗначениеЗаполнено(ПользовательДляОповещения) Тогда
		ДанныеСообщения.Объект = ПользовательДляОповещения;
	Иначе
		ТекстОшибки = НСтр("ru='У задачи не заполнены параметры: ""Пользователь для оповещения"" или ""Общее обсуждение"".'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	ДанныеСообщения.Автор = АссистентУправления.ПользовательАссистент();
	
	Если ОтправитьСейчас Тогда
		ОбсужденияУНФ.СоздатьСообщение(ДанныеСообщения);
	Иначе
		ОбсужденияУНФ.СоздатьСообщениеОтложенно(ДанныеСообщения);
	КонецЕсли;
	
КонецПроцедуры

Процедура СброситьПризнакНеобходимоПоприветствовать()
	
	ОбменДаннымиЗагрузка = ОбменДанными.Загрузка;
	ОбменДанными.Загрузка = Истина;
	НеобходимоПоприветствовать = Ложь;
	Записать();
	ОбменДанными.Загрузка = ОбменДаннымиЗагрузка;
	
КонецПроцедуры

Процедура ДобавитьКнопкуПереходаВРасчетПотребностей(ДанныеОстатков, ДействияСообщения)
	
	Если ДанныеОстатков.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Константы.ФункциональнаяОпцияИспользоватьСервисРасчетПотребностей.Получить() <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ДействияСообщения.Добавить("ОткрытьРасчетПотребностейМинимальныеОстаткиЗапасов", НСтр("ru='Заказать'"));
	
КонецПроцедуры

Функция ДанныеСообщенияОбОстатках(ДанныеОбОстатках)
	
	Если ДанныеОбОстатках.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеСообщения = Новый Структура;
	ДанныеСообщения.Вставить("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	ДанныеСообщения.Вставить("Организация", Организация);
	ДанныеСообщения.Вставить("Номенклатура", Новый СписокЗначений);
	Для каждого ОписаниеОстатка Из ДанныеОбОстатках Цикл
		ДанныеСообщения.Номенклатура.Добавить(ОписаниеОстатка.Номенклатура);
	КонецЦикла;
	Возврат ДанныеСообщения;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли