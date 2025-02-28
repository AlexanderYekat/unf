﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Контрагенты") 
		 ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Организации") ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Владелец = ДанныеЗаполнения;
		ВалютаДенежныхСредств = Константы.НациональнаяВалюта.Получить();
		СчетУчета = ПланыСчетов.Управленческий.Банк;
		ВидСчета = "Расчетный";
		ВариантВыводаМесяца = Перечисления.ВариантыВыводаМесяцаВДатеДокумента.Числом;
		Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
			ВариантУказанияКПП = Перечисления.ВариантыУказанияКПП.ПриПеречисленииНалогов;
		Иначе
			ВариантУказанияКПП = Перечисления.ВариантыУказанияКПП.ВоВсехПлатежныхПоручениях;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда	
		
		СтандартнаяОбработка = Ложь;
		
		Если Не ДанныеЗаполнения.Свойство("ВариантУказанияКПП") Тогда
			ВариантУказанияКПП = Перечисления.ВариантыУказанияКПП.ВоВсехПлатежныхПоручениях;
		КонецЕсли;
	
		Если Не ДанныеЗаполнения.Свойство("СчетУчета") Тогда
			СчетУчета = ПланыСчетов.Управленческий.Банк;
		КонецЕсли;
	
		Если Не ДанныеЗаполнения.Свойство("ВидСчета") Тогда
			ВидСчета = "Расчетный";
		КонецЕсли;
	
		Если Не ДанныеЗаполнения.Свойство("ВариантВыводаМесяца") Тогда
			ВариантВыводаМесяца = Перечисления.ВариантыВыводаМесяцаВДатеДокумента.Числом;
		КонецЕсли;
	
		Если Не ДанныеЗаполнения.Свойство("ВариантУказанияКПП") Тогда
			ВариантУказанияКПП = Перечисления.ВариантыУказанияКПП.ВоВсехПлатежныхПоручениях;
		КонецЕсли;
	
		Если Не ДанныеЗаполнения.Свойство("Банк") Тогда
			РаботаСБанкамиБП.УстановитьБанк(ДанныеЗаполнения);
		ИначеЕсли ЗначениеЗаполнено(ДанныеЗаполнения.Банк)
				И ТипЗнч(ДанныеЗаполнения.Банк) = Тип("СправочникСсылка.КлассификаторБанков") Тогда
				ЗаполнитьБанкПоКлассификаторуБанков(ДанныеЗаполнения);
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Если Не ДанныеЗаполнения.Свойство("Наименование") Тогда
			НаименованиеБанка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Банк, "Наименование");
			Наименование = Лев(СокрЛп(НомерСчета) + ?(ЗначениеЗаполнено(НаименованиеБанка), ", в " + НаименованиеБанка, ""), 100);
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Организации") Тогда
		ПроверяемыеРеквизиты.Добавить("СчетУчета");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьРеквизитОсновнойБанковскийСчет();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СчетУчета) Тогда
		СчетУчета = ПланыСчетов.Управленческий.Банк;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьНаименование() Экспорт
	
	Наименование = СтрШаблон(
		НСтр("ru = '%1, в %2'"),
		СокрЛП(НомерСчета),
		Банк);
	
КонецПроцедуры

Процедура ОчиститьРеквизитОсновнойБанковскийСчет()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Контрагенты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.БанковскийСчетПоУмолчанию = &БанковскийСчет
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.БанковскийСчетПоУмолчанию = &БанковскийСчет
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ФизическиеЛица.Ссылка
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	ФизическиеЛица.БанковскийСчетПоУмолчанию = &БанковскийСчет";
	
	Запрос.УстановитьПараметр("БанковскийСчет", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СправочникОбъект.БанковскийСчетПоУмолчанию = Неопределено;
		СправочникОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьБанкПоКлассификаторуБанков(ДанныеЗаполнения)
	
	РеквизитыБанка = БанковскиеСчетаВызовСервера.ПолучитьРеквизитыБанкаИзКлассификатора(ДанныеЗаполнения.Банк);
	ДанныеЗаполнения.Вставить("Банк", РеквизитыБанка.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли