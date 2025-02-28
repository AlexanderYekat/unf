﻿
#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	Настройки.ПроверкаДокументаПередЗаписью = Истина;
	Настройки.ПроверкаДокументаПриЗаписи = Истина;
	
КонецПроцедуры

Процедура ПроверкаДокументаПередЗаписью(Источник) Экспорт
	
	Если Источник.ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ АссистентУправления.Используется() Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьДополнительныеСвойства(Источник);
	
	ПроверитьИзменениеСостоянияЗаказаПокупателяПередЗаписью(Источник);
	ПроверитьИзменениеОтветственногоЗаказаПокупателяПередЗаписью(Источник);
	
КонецПроцедуры

Процедура ПроверкаДокументаПриЗаписи(Источник) Экспорт
	
	Если Источник.ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ АссистентУправления.Используется() Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьИзменениеСостоянияЗаказаПокупателяПриЗаписи(Источник);
	ПроверитьИзменениеОтветственногоЗаказаПокупателяПриЗаписи(Источник);
	
КонецПроцедуры

Процедура ВыполнитьДействие(Действие, Контекст, ПараметрыЗадачи, ДополнительныеПараметры, Результат) Экспорт
	
	Если Действие = "ОповеститьСотрудникаОбИзмененииСостоянияЗаказаПокупателяВОбсуждении"
		ИЛИ Действие = "ОповеститьСотрудникаОбИзмененииСостоянияЗаказНарядаВОбсуждении" Тогда
		ОповеститьСотрудникаОбИзмененииСостоянияЗаказаПокупателяВОбсуждении(Контекст, ПараметрыЗадачи, ДополнительныеПараметры, Результат);
	ИначеЕсли Действие = "ОповеститьСотрудникаОбИзмененииСостоянияЗаказаПокупателяПоEmail"
		ИЛИ Действие = "ОповеститьСотрудникаОбИзмененииСостоянияЗаказНарядаПоEmail" Тогда
		ОповеститьСотрудникаОбИзмененииСостоянияЗаказаПокупателяПоEmail(Контекст, ПараметрыЗадачи, ДополнительныеПараметры, Результат);
	ИначеЕсли Действие = "ОповеститьСотрудникаОбИзмененииСостоянияЗаказаПокупателяПоSMS"
		ИЛИ Действие = "ОповеститьСотрудникаОбИзмененииСостоянияЗаказНарядаПоSMS" Тогда
		ОповеститьСотрудникаОбИзмененииСостоянияЗаказаПокупателяПоSMS(Контекст, ПараметрыЗадачи, ДополнительныеПараметры, Результат);
	ИначеЕсли Действие = "ОповеститьСотрудникаОбОтветственностиЗаЗаказПокупателяВОбсуждении"
		ИЛИ Действие = "ОповеститьСотрудникаОбОтветственностиЗаЗаказНарядВОбсуждении" Тогда
		ОповеститьСотрудникаОбОтветственностиЗаЗаказПокупателяВОбсуждении(Контекст, ПараметрыЗадачи, ДополнительныеПараметры, Результат);
	ИначеЕсли Действие = "ОповеститьСотрудникаОбОтветственностиЗаЗаказПокупателяПоEmail"
		ИЛИ Действие = "ОповеститьСотрудникаОбОтветственностиЗаЗаказНарядПоEmail" Тогда
		ОповеститьСотрудникаОбОтветственностиЗаЗаказПокупателяПоEmail(Контекст, ПараметрыЗадачи, ДополнительныеПараметры, Результат);
	ИначеЕсли Действие = "ОповеститьСотрудникаОбОтветственностиЗаЗаказПокупателяПоSMS"
		ИЛИ Действие = "ОповеститьСотрудникаОбОтветственностиЗаЗаказНарядПоSMS" Тогда
		ОповеститьСотрудникаОбОтветственностиЗаЗаказПокупателяПоSMS(Контекст, ПараметрыЗадачи, ДополнительныеПараметры, Результат);
	Иначе
		ТекстОшибки = СтрШаблон(НСтр("ru='Неизвестное действие: %1.'"), Действие);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеКонвертации(КомпонентыОбмена) Экспорт
	
	Если КомпонентыОбмена.НаправлениеОбмена <> "Получение" Тогда
		Возврат;
	КонецЕсли;
	
	УзелОбмена = КомпонентыОбмена.УзелКорреспондента;
	НовыеЗаказыПокупателей = КомпонентыОбмена.ПараметрыКонвертации.НовыеЗаказыПокупателей;
	Для каждого Ссылка Из НовыеЗаказыПокупателей Цикл
		ПослеСозданияНовогоЗаказаПокупателя(Ссылка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СобытияАссистента

#Область ПроверкаСобытий

Процедура ПроверитьИзменениеСостоянияЗаказаПокупателяПередЗаписью(Источник)
	
	Если ТипЗнч(Источник) <> Тип("ДокументОбъект.ЗаказПокупателя") Тогда
		Возврат;
	КонецЕсли;
	
	СостояниеЗаказаДо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "СостояниеЗаказа");;
	Источник.ДополнительныеСвойства.АссистентУправления.АссистентУправленияРаботаСЗаказами.Вставить("СостояниеЗаказаДо", СостояниеЗаказаДо);
	Источник.ДополнительныеСвойства.АссистентУправления.АссистентУправленияРаботаСЗаказами.Вставить("ЭтоНовый", Источник.ЭтоНовый());
	
КонецПроцедуры

Процедура ПроверитьИзменениеСостоянияЗаказаПокупателяПриЗаписи(Источник)
	
	Если ТипЗнч(Источник) <> Тип("ДокументОбъект.ЗаказПокупателя") Тогда
		Возврат;
	КонецЕсли;
	
	СостояниеЗаказаТекущее = Источник.СостояниеЗаказа;
	СостояниеЗаказаДо = Источник.ДополнительныеСвойства.АссистентУправления.АссистентУправленияРаботаСЗаказами.СостояниеЗаказаДо;
	ЭтоНовый = Источник.ДополнительныеСвойства.АссистентУправления.АссистентУправленияРаботаСЗаказами.ЭтоНовый;
	
	Если СостояниеЗаказаТекущее <> СостояниеЗаказаДо Тогда
		Если Источник.ЭтоЗаказНаряд() Тогда
			ПриИзмененииСостоянияЗаказНаряда(Источник.Ссылка, СостояниеЗаказаДо, СостояниеЗаказаТекущее, ЭтоНовый);
		Иначе
			ПриИзмененииСостоянияЗаказаПокупателя(Источник.Ссылка, СостояниеЗаказаДо, СостояниеЗаказаТекущее, ЭтоНовый);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьИзменениеОтветственногоЗаказаПокупателяПередЗаписью(Источник)
	
	Если ТипЗнч(Источник) <> Тип("ДокументОбъект.ЗаказПокупателя") Тогда
		Возврат;
	КонецЕсли;
	
	ОтветственныйДо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "Ответственный");
	Источник.ДополнительныеСвойства.АссистентУправления.АссистентУправленияРаботаСЗаказами.Вставить("Ответственный", ОтветственныйДо);
	Источник.ДополнительныеСвойства.АссистентУправления.АссистентУправленияРаботаСЗаказами.Вставить("ЭтоНовый", Источник.ЭтоНовый());
	
КонецПроцедуры

Процедура ПроверитьИзменениеОтветственногоЗаказаПокупателяПриЗаписи(Источник)
	
	Если ТипЗнч(Источник) <> Тип("ДокументОбъект.ЗаказПокупателя") Тогда
		Возврат;
	КонецЕсли;
	
	ОтветственныйТекущий = Источник.Ответственный;
	ОтветственныйДо = Источник.ДополнительныеСвойства.АссистентУправления.АссистентУправленияРаботаСЗаказами.Ответственный;
	ЭтоНовый = Источник.ДополнительныеСвойства.АссистентУправления.АссистентУправленияРаботаСЗаказами.ЭтоНовый;
	
	Если ОтветственныйТекущий <> ОтветственныйДо Тогда
		Если Источник.ЭтоЗаказНаряд() Тогда
			ПриИзмененииОтветственногоЗаказНаряд(Источник.Ссылка, ОтветственныйДо, ОтветственныйТекущий, ЭтоНовый);
		Иначе
			ПриИзмененииОтветственногоЗаказаПокупателя(Источник.Ссылка, ОтветственныйДо, ОтветственныйТекущий, ЭтоНовый);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияЗаказаПокупателя

Процедура ПриИзмененииСостоянияЗаказаПокупателя(Заказ, ПредыдущееСостояние, НовоеСостояние, ЭтоНовыйЗаказ = Ложь)
	ТекущееСобытие = "ПриИзмененииСостоянияЗаказаПокупателя";
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПредыдущееСостояние", ПредыдущееСостояние);
	ДополнительныеПараметры.Вставить("НовоеСостояние", НовоеСостояние);
	ДополнительныеПараметры.Вставить("ЭтоНовый", ЭтоНовыйЗаказ);
	
	АссистентУправления.ПриСрабатыванииСобытия2(ТекущийМенеджер(), ТекущееСобытие, Заказ,, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ПриИзмененииСостоянияЗаказНаряда(Заказ, ПредыдущееСостояние, НовоеСостояние, ЭтоНовыйЗаказ = Ложь)
	ТекущееСобытие = "ПриИзмененииСостоянияЗаказНаряда";
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПредыдущееСостояние", ПредыдущееСостояние);
	ДополнительныеПараметры.Вставить("НовоеСостояние", НовоеСостояние);
	ДополнительныеПараметры.Вставить("ЭтоНовый", ЭтоНовыйЗаказ);
	
	АссистентУправления.ПриСрабатыванииСобытия2(ТекущийМенеджер(), ТекущееСобытие, Заказ,, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ПриИзмененииОтветственногоЗаказаПокупателя(Заказ, ОтветственныйДо, ОтветственныйТекущий, ЭтоНовыйЗаказ = Ложь)
	ТекущееСобытие = "ПриИзмененииОтветственногоЗаказаПокупателя";
	
	АссистентУправления.ПриСрабатыванииСобытия2(ТекущийМенеджер(), ТекущееСобытие, Заказ);
	
КонецПроцедуры

Процедура ПриИзмененииОтветственногоЗаказНаряд(Заказ, ОтветственныйДо, ОтветственныйТекущий, ЭтоНовыйЗаказ = Ложь)
	ТекущееСобытие = "ПриИзмененииОтветственногоЗаказНаряд";
	
	АссистентУправления.ПриСрабатыванииСобытия2(ТекущийМенеджер(), ТекущееСобытие, Заказ);
	
КонецПроцедуры

Процедура ПослеСозданияНовогоЗаказаПокупателя(Заказ)
	
	ПриИзмененииСостоянияЗаказаПокупателя(Заказ, Справочники.СостоянияЗаказовПокупателей.ПустаяСсылка(), Заказ.СостояниеЗаказа, Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ДействияАссистента

#Область ДействияСЗаказомПокупателя

Процедура ОповеститьСотрудникаОбИзмененииСостоянияЗаказаПокупателяВОбсуждении(Контекст, ПараметрыЗадачи, ДополнительныеПараметры, Результат) Экспорт
	
	ЭтоНовый = Неопределено;
	ДополнительныеПараметры.Свойство("ЭтоНовый", ЭтоНовый);
	
	ЗаказПокупателя = Контекст.Предмет;
	Если НЕ ЗаказВНужномСостоянии(ЗаказПокупателя, ПараметрыЗадачи) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаказа = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗаказПокупателя,
		"СостояниеЗаказа,ВидЗаказа,Ответственный,ВариантЗавершения");
	
	ПользовательОтветственный = РегистрыСведений.СотрудникиПользователя.ПолучитьПользователяПоСотруднику(ДанныеЗаказа.Ответственный);
	
	Если ЭтоНовый = Истина Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru='Появился новый заказ в состоянии %1.
			|%2'"),
			ДанныеЗаказа.СостояниеЗаказа,
			ПолучитьНавигационнуюСсылку(ЗаказПокупателя));
	Иначе
		ТекстСообщения = СтрШаблон(
			НСтр("ru='%1 в состоянии %2'"),
			ПолучитьНавигационнуюСсылку(ЗаказПокупателя),
			ДанныеЗаказа.СостояниеЗаказа);
	КонецЕсли;
	
	ДанныеСообщения = ОбсужденияУНФ.НовыйДанныеСообщения();
	СпособыОповещений = Перечисления.СпособОповещенияАссистентаУправления;
	
	Если ПараметрыЗадачи.СпособОповещения = СпособыОповещений.СообщениеОбщегоОбсуждения Тогда
		ДанныеСообщения.Объект = ПараметрыЗадачи.ИдентификаторОбщегоОбсуждения;
	ИначеЕсли ПараметрыЗадачи.СпособОповещения = СпособыОповещений.СообщениеКонтекстногоОбсужденияБезОповещения Тогда
		ДанныеСообщения.Объект = ЗаказПокупателя;
	ИначеЕсли ПараметрыЗадачи.СпособОповещения = СпособыОповещений.СообщениеКонтекстногоОбсужденияПользователю Тогда
		ДанныеСообщения.Объект = ЗаказПокупателя;
		ДанныеСообщения.Получатель = ПараметрыЗадачи.ПользовательДляОповещения;
	ИначеЕсли ПараметрыЗадачи.СпособОповещения = СпособыОповещений.СообщениеКонтекстногоОбсужденияОтветственному Тогда
		ДанныеСообщения.Объект = ЗаказПокупателя;
		ДанныеСообщения.Получатель = ДанныеЗаказа.Ответственный;
	ИначеЕсли ПараметрыЗадачи.СпособОповещения = СпособыОповещений.СообщениеЛичногоОбсужденияОтветственному Тогда
		ДанныеСообщения.Объект = ПользовательОтветственный;
	ИначеЕсли ПараметрыЗадачи.СпособОповещения = СпособыОповещений.СообщениеЛичногоОбсужденияПользователю Тогда
		ДанныеСообщения.Объект = ПараметрыЗадачи.ПользовательДляОповещения;
	КонецЕсли;
	
	ДанныеСообщения.Текст = ТекстСообщения;
	Результат.ДанныеСообщений.Добавить(ДанныеСообщения);
	
КонецПроцедуры

Процедура ОповеститьСотрудникаОбИзмененииСостоянияЗаказаПокупателяПоEmail(Контекст, ПараметрыЗадачи, ДополнительныеПараметры, Результат) Экспорт
	
	Если НЕ ЗаказВНужномСостоянии(Контекст.Предмет, ПараметрыЗадачи) Тогда
		Возврат;
	КонецЕсли;
	
	Событие = СоздатьEmail(Контекст.Предмет, ПараметрыЗадачи.УчетнаяЗапись);
	
	Событие.ЗаполнитьПоШаблону(ПараметрыЗадачи.ШаблонСообщения, Контекст.Предмет);
	Событие.Участники.Очистить();
	ЗаполнитьУчастниковСобытия(Событие, ПараметрыЗадачи.ПользовательДляОповещения);
	
	Событие.Записать();
	
	ОтправитьСобытие(Событие);
	
КонецПроцедуры

Процедура ОповеститьСотрудникаОбИзмененииСостоянияЗаказаПокупателяПоSMS(Контекст, ПараметрыЗадачи, ДополнительныеПараметры, Результат) Экспорт
	
	Если НЕ ЗаказВНужномСостоянии(Контекст.Предмет, ПараметрыЗадачи) Тогда
		Возврат;
	КонецЕсли;
	
	Событие = СоздатьSMS(Контекст.Предмет);
	
	Событие.ЗаполнитьПоШаблону(ПараметрыЗадачи.ШаблонСообщения, Контекст.Предмет);
	Событие.Участники.Очистить();
	ЗаполнитьУчастниковСобытия(Событие, ПараметрыЗадачи.ПользовательДляОповещения);
	
	Событие.Записать();
	
	ОтправитьСобытие(Событие);
	
КонецПроцедуры

Процедура ОповеститьСотрудникаОбОтветственностиЗаЗаказПокупателяВОбсуждении(Контекст, ПараметрыЗадачи, ДополнительныеПараметры, Результат)
	
	ЗаказПокупателя = Контекст.Предмет;
	ДанныеЗаказа = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗаказПокупателя, "Ответственный");
	
	ТекстСообщения = СтрШаблон(
		НСтр("ru='Вы назначены ответственным за %1'"),
		ПолучитьНавигационнуюСсылку(Контекст.Предмет));
	
	ДанныеСообщения = ОбсужденияУНФ.НовыйДанныеСообщения();
	ПользовательОтветственный = РегистрыСведений.СотрудникиПользователя.ПолучитьПользователяПоСотруднику(
		ДанныеЗаказа.Ответственный);
	СпособыОповещений = Перечисления.СпособОповещенияАссистентаУправления;
	
	Если ПараметрыЗадачи.СпособОповещения = СпособыОповещений.СообщениеКонтекстногоОбсужденияОтветственному Тогда
		ДанныеСообщения.Объект = ЗаказПокупателя;
		ДанныеСообщения.Получатель = ПользовательОтветственный;
	ИначеЕсли ПараметрыЗадачи.СпособОповещения = СпособыОповещений.СообщениеЛичногоОбсужденияОтветственному Тогда
		ДанныеСообщения.Объект = ПользовательОтветственный;
	КонецЕсли;
	
	ДанныеСообщения.Текст = ТекстСообщения;
	Результат.ДанныеСообщений.Добавить(ДанныеСообщения);
	
КонецПроцедуры

Процедура ОповеститьСотрудникаОбОтветственностиЗаЗаказПокупателяПоEmail(Контекст, ПараметрыЗадачи, ДополнительныеПараметры, Результат)
	
	ЗаказПокупателя = Контекст.Предмет;
	ДанныеЗаказа = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗаказПокупателя, "Ответственный");
	ПользовательОтветственный = РегистрыСведений.СотрудникиПользователя.ПолучитьПользователяПоСотруднику(
		ДанныеЗаказа.Ответственный);
	
	Событие = СоздатьEmail(ЗаказПокупателя, ПараметрыЗадачи.УчетнаяЗапись);
	
	Событие.ЗаполнитьПоШаблону(ПараметрыЗадачи.ШаблонСообщения, ЗаказПокупателя);
	Событие.Участники.Очистить();
	ЗаполнитьУчастниковСобытия(Событие, ПользовательОтветственный);
	
	Событие.Записать();
	
	ОтправитьСобытие(Событие);
	
КонецПроцедуры

Процедура ОповеститьСотрудникаОбОтветственностиЗаЗаказПокупателяПоSMS(Контекст, ПараметрыЗадачи, ДополнительныеПараметры, Результат)
	
	ЗаказПокупателя = Контекст.Предмет;
	ДанныеЗаказа = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗаказПокупателя, "Ответственный");
	ПользовательОтветственный = РегистрыСведений.СотрудникиПользователя.ПолучитьПользователяПоСотруднику(
		ДанныеЗаказа.Ответственный);
	
	Событие = СоздатьSMS(Контекст.Предмет);
	
	Событие.ЗаполнитьПоШаблону(ПараметрыЗадачи.ШаблонСообщения, Контекст.Предмет);
	Событие.Участники.Очистить();
	ЗаполнитьУчастниковСобытия(Событие, ПользовательОтветственный);
	
	Событие.Записать();
	
	ОтправитьСобытие(Событие);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбщиеПроцедурыИФункции

Функция ТекущийМенеджер()
	
	Возврат "АссистентУправленияРаботаСЗаказами";
	
КонецФункции

Процедура ДобавитьДополнительныеСвойства(Объект)
	
	Если НЕ Объект.ДополнительныеСвойства.АссистентУправления.Свойство(ТекущийМенеджер()) Тогда
		Объект.ДополнительныеСвойства.АссистентУправления.Вставить(ТекущийМенеджер(), Новый Структура);
	КонецЕсли;
	
КонецПроцедуры

Функция СоздатьEmail(ДокументОснование, УчетнаяЗапись)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ТипСобытия", Перечисления.ТипыСобытий.ЭлектронноеПисьмо);
	ЗначенияЗаполнения.Вставить("ДокументОснование", ДокументОснование);
	
	НовоеСобытие = Документы.Событие.СоздатьДокумент();
	НовоеСобытие.ДополнительныеСвойства.Вставить("ЭтоЗаписьАссистентом", Истина);
	НовоеСобытие.Заполнить(ЗначенияЗаполнения);
	НовоеСобытие.Дата = ТекущаяДатаСеанса();
	НовоеСобытие.УчетнаяЗапись = УчетнаяЗапись;
	
	Возврат НовоеСобытие;
	
КонецФункции

Функция СоздатьSMS(ДокументОснование)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ТипСобытия", Перечисления.ТипыСобытий.СообщениеSMS);
	ЗначенияЗаполнения.Вставить("ДокументОснование", ДокументОснование);
	
	НовоеСобытие = Документы.Событие.СоздатьДокумент();
	НовоеСобытие.ДополнительныеСвойства.Вставить("ЭтоЗаписьАссистентом", Истина);
	НовоеСобытие.Заполнить(ЗначенияЗаполнения);
	НовоеСобытие.Дата = ТекущаяДатаСеанса();
	
	Возврат НовоеСобытие;
	
КонецФункции

Процедура ЗаполнитьУчастниковСобытия(Событие, Получатель)
	
	Если Событие.ТипСобытия = Перечисления.ТипыСобытий.ЭлектронноеПисьмо Тогда
		ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты
	ИначеЕсли Событие.ТипСобытия = Перечисления.ТипыСобытий.СообщениеSMS Тогда
		ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.Телефон;
	Иначе
		Возврат;
	КонецЕсли;
	
	КонтактнаяИнформацияПолучателя = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Получатель), ТипКонтактнойИнформации, , ТекущаяДатаСеанса());
	Для каждого СтрокаКонтактнойИнформации Из КонтактнаяИнформацияПолучателя Цикл
		НоваяСтрока = Событие.Участники.Добавить();
		НоваяСтрока.Контакт = Получатель;
		НоваяСтрока.КакСвязаться = СтрокаКонтактнойИнформации.Представление;
	КонецЦикла;
	
КонецПроцедуры

Функция ЗаполненоКакСвязатьсяВСобытии(Событие)
	
	Для каждого Участник Из Событие.Участники Цикл
		Если ЗначениеЗаполнено(Участник.КакСвязаться) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Процедура ОтправитьСобытие(Событие)
	
	Если Событие.ТипСобытия <> Перечисления.ТипыСобытий.ЭлектронноеПисьмо
		И Событие.ТипСобытия <> Перечисления.ТипыСобытий.СообщениеSMS Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполненоКакСвязаться = ЗаполненоКакСвязатьсяВСобытии(Событие);
	ПолучательСообщения = АссистентУправления.ПолучитьОтветственного(Событие.Ссылка);
	
	Если НЕ ЗаполненоКакСвязаться Тогда
		ДанныеСообщения = ОбсужденияУНФ.НовыйДанныеСообщения();
		ДанныеСообщения.Объект = Событие.Ссылка;
		ДанныеСообщения.Текст = НСтр("ru='Не удалось отправить сообщение, т.к. отсутствуют получатели'");
		ДанныеСообщения.Автор = АссистентУправления.ПользовательАссистент();
		ДанныеСообщения.Получатель = ПолучательСообщения;
		ОбсужденияУНФ.СоздатьСообщениеОтложенно(ДанныеСообщения);
		Возврат;
	КонецЕсли;
	
	Попытка
		Если Событие.ТипСобытия = Перечисления.ТипыСобытий.ЭлектронноеПисьмо Тогда
			Событие.ОтправитьЭлектронноеПисьмо();
		ИначеЕсли Событие.ТипСобытия = Перечисления.ТипыСобытий.СообщениеSMS Тогда
			Событие.ОтправитьSMS();
		КонецЕсли;
		СообщениеОтправлено = Истина;
	Исключение
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		СообщениеОтправлено = Ложь;
	КонецПопытки;
	
	Если СообщениеОтправлено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСообщения = ОбсужденияУНФ.НовыйДанныеСообщения();
	ДанныеСообщения.Объект = Событие.Ссылка;
	ДанныеСообщения.Текст = ТекстОшибки;
	ДанныеСообщения.Автор = АссистентУправления.ПользовательАссистент();
	ДанныеСообщения.Получатель = ПолучательСообщения;
	ОбсужденияУНФ.СоздатьСообщениеОтложенно(ДанныеСообщения);
	
КонецПроцедуры

Функция ЗаказВНужномСостоянии(Заказ, ПараметрыЗадачи)
	
	ДанныеЗаказа = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Заказ,
		"СостояниеЗаказа,ВидЗаказа,ВариантЗавершения");
	
	Если ПараметрыЗадачи.СостояниеЗаказа <> ДанныеЗаказа.СостояниеЗаказа Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПараметрыЗадачи.ВидЗаказа <> ДанныеЗаказа.ВидЗаказа Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если СостоянияЗаказов.ЭтоСостояниеЗавершен(ПараметрыЗадачи.СостояниеЗаказа)
		И ПараметрыЗадачи.ВариантЗавершения <> ДанныеЗаказа.ВариантЗавершения Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецОбласти
