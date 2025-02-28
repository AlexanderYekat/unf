﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Сохраняет в данных справочника сумму расходов на ККТ, уменьшающих платеж по патенту.
//
// Параметры:
//  ЗаписьКалендаря               - СправочникСсылка.ЗаписиКалендаряПодготовкиОтчетности
//  ОбъектУменьшенияНалога        - СправочникСсылка.Патенты,СправочникСсылка.ВидыДеятельностиЕНВД - ссылка на патент
//      или вид деятельности, налоговый платеж по которому уменьшается.
//  СуммаРасходов  - Число(10, 0) - сумма уменьшающих налог расходов на приобретение ККТ.
//                                  Сумма расходов не должна превышать установленный лимит - см. УчетПСН.ПредельныйРазмерВычетаПоРасходамНаККТ()
//
Процедура ЗаписатьРасходыУменьшающиеНалог(ЗаписьКалендаря, ОбъектУменьшенияНалога = Неопределено, СуммаРасходов,
	КодПООКТМО = "", КодИФНС = "") Экспорт

	Если Не ЗначениеЗаполнено(ЗаписьКалендаря) Тогда
		Возврат;
	КонецЕсли;

	Если СуммаРасходов > ПредельныйРазмерВычетаПоРасходамНаККТ() Тогда
		Возврат;
	КонецЕсли;

	ЗаписьРасход = РегистрыСведений.РасходыНаККТУменьшающиеНалог.СоздатьМенеджерЗаписи();
	ЗаписьРасход.ЗаписьКалендаря = ЗаписьКалендаря;
	ЗаписьРасход.ОбъектУменьшенияНалога = ОбъектУменьшенияНалога;
	ЗаписьРасход.КодПООКТМО = СокрЛП(КодПООКТМО);
	ЗаписьРасход.КодИФНС = СокрЛП(КодИФНС);
	ЗаписьРасход.РасходыУменьшающиеНалог = СуммаРасходов;

	ЗаписьРасход.Записать();
КонецПроцедуры

Процедура ПолучитьСуммуРасходовУменьшающиеНалог(ЗаписьКалендаря, ОбъектУменьшенияНалога = Неопределено, СуммаРасходов,
	КодПООКТМО = "", КодИФНС = "") Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	Сумма(РасходыНаККТУменьшающиеНалог.РасходыУменьшающиеНалог) КАК РасходыУменьшающиеНалог
						  |ИЗ
						  |	РегистрСведений.РасходыНаККТУменьшающиеНалог КАК РасходыНаККТУменьшающиеНалог
						  |ГДЕ
						  |	РасходыНаККТУменьшающиеНалог.ЗаписьКалендаря = &ЗаписьКалендаря");

	Запрос.УстановитьПараметр("ЗаписьКалендаря", ЗаписьКалендаря);
	Если ЗначениеЗаполнено(ОбъектУменьшенияНалога) Тогда
		Запрос.Текст = Запрос.Текст + " И РасходыНаККТУменьшающиеНалог.ОбъектУменьшенияНалога = &ОбъектУменьшенияНалога";
		Запрос.УстановитьПараметр("ОбъектУменьшенияНалога", ОбъектУменьшенияНалога);
	КонецЕсли;
	Если Не ПустаяСтрока(КодПООКТМО) Тогда
		Запрос.Текст = Запрос.Текст + " И РасходыНаККТУменьшающиеНалог.КодПООКТМО = &КодПООКТМО";
		Запрос.УстановитьПараметр("КодПООКТМО", СокрЛП(КодПООКТМО));
	КонецЕсли;
	Если Не ПустаяСтрока(КодПООКТМО) Тогда
		Запрос.Текст = Запрос.Текст + " И РасходыНаККТУменьшающиеНалог.КодИФНС = &КодИФНС";
		Запрос.УстановитьПараметр("КодИФНС", СокрЛП(КодИФНС));
	КонецЕсли;

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И ЗначениеЗаполнено(Выборка.РасходыУменьшающиеНалог) Тогда
		СуммаРасходов = Выборка.РасходыУменьшающиеНалог;
	Иначе
		СуммаРасходов = 0;
	КонецЕсли;

КонецПроцедуры

Функция ПредельныйРазмерВычетаПоРасходамНаККТ() Экспорт
	
	// Пункт 1.1 статьи 346.51 НК РФ.
	Возврат 18000;
	
КонецФункции

#КонецОбласти

#КонецЕсли
