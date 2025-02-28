﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает новую связь между контактом и контрагентом
//
// Параметры:
//  - Контрагент - СправочникСсылка.Контрагенты
//  - Контакт - СправочникСсылка.КонтактныеЛица
//
Процедура НоваяСвязь(Контрагент, Контакт, Должность = "", Автор = Неопределено, Период = Неопределено, Порядок = 0) Экспорт
	
	СвязиКонтрагента = РегистрыСведений.СвязиКонтрагентКонтакт.СрезПервых(, Новый Структура("Контрагент", Контрагент));
	
	НеобходимоДобавитьНовуюЗапись = Истина;
	
	НоваяЗапись = Новый Структура;
	НоваяЗапись.Вставить("Контрагент", Контрагент);
	НоваяЗапись.Вставить("Контакт", Контакт);
	НоваяЗапись.Вставить("Период", ?(ЗначениеЗаполнено(Период), Период, ТекущаяДатаСеанса()));
	НоваяЗапись.Вставить("Должность", Должность);
	НоваяЗапись.Вставить("СвязьНедействительна", Ложь);
	НоваяЗапись.Вставить("Порядок", Порядок);
	
	УстановленнаяСвязь = СвязиКонтрагента.Найти(Контакт, "Контакт");
	Если УстановленнаяСвязь <> Неопределено Тогда
		
		АктуальнаяСвязьКонтрагентКонтакт = РегистрыСведений.СвязиКонтрагентКонтакт.СрезПоследних(, Новый Структура("Контрагент,Контакт", Контрагент, Контакт));
		Если АктуальнаяСвязьКонтрагентКонтакт.Количество() <> 0 Тогда
			НеобходимоДобавитьНовуюЗапись = ЗаписиОтличаются(НоваяЗапись, АктуальнаяСвязьКонтрагентКонтакт[0]);
			ИзмененПорядок = ИзмененПорядокЗаписи(НоваяЗапись, АктуальнаяСвязьКонтрагентКонтакт[0]);
		КонецЕсли;
		
	КонецЕсли;
		
	Если НЕ НеобходимоДобавитьНовуюЗапись И НЕ ИзмененПорядок Тогда
		Возврат;
	КонецЕсли;
	
	ПорядокЗаписи = 0;
	Если СвязиКонтрагента.Количество() <> 0 И УстановленнаяСвязь = Неопределено Тогда
		СвязиКонтрагента.Сортировать("Порядок Возр");
		ПорядокЗаписи = СвязиКонтрагента[СвязиКонтрагента.Количество() - 1].Порядок + 1;
	КонецЕсли;
	Если ЗначениеЗаполнено(Порядок) Тогда
		ПорядокЗаписи = Порядок;
	КонецЕсли;
	
	НоваяЗапись.Вставить("Порядок", ПорядокЗаписи);
	
	Если Автор = Неопределено Тогда
		Автор = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	НоваяЗапись.Вставить("Автор", Автор);
	
	НаборЗаписей = РегистрыСведений.СвязиКонтрагентКонтакт.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Контрагент.Установить(НоваяЗапись.Контрагент);
	НаборЗаписей.Отбор.Контакт.Установить(НоваяЗапись.Контакт);
	
	ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), НоваяЗапись);
	НаборЗаписей.Записать(НЕ НеобходимоДобавитьНовуюЗапись);
	
КонецПроцедуры

Процедура УстановитьНедействительной(Контрагент, Контакты, Период = Неопределено) Экспорт
	
	Если ТипЗнч(Контакты) = Тип("Массив") Тогда
		МассивКонтактов = Контакты;
	Иначе
		МассивКонтактов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Контакты);
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.СвязиКонтрагентКонтакт.СоздатьНаборЗаписей();
	АктуальныеСвязи = РегистрыСведений.СвязиКонтрагентКонтакт.СрезПоследних(, Новый Структура("Контрагент", Контрагент));
	
	Для каждого Контакт Из МассивКонтактов Цикл
		АктуальнаяЗапись = АктуальныеСвязи.Найти(Контакт);
		Если АктуальнаяЗапись = Неопределено ИЛИ АктуальнаяЗапись.СвязьНедействительна Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, АктуальнаяЗапись,, "Порядок");
		НоваяЗапись.Период = ?(ЗначениеЗаполнено(Период), Период, ТекущаяДатаСеанса());
		НоваяЗапись.Автор = Пользователи.ТекущийПользователь();
		НоваяЗапись.СвязьНедействительна = Истина;
	КонецЦикла;
	
	НаборЗаписей.Записать(Ложь);
	
КонецПроцедуры

Процедура ИзменитьПорядок(Контрагент, Контакт, Смещение, ПорядокИзменен, ВключатьНедействительные) Экспорт
	
	СвязиКонтрагента = РегистрыСведений.СвязиКонтрагентКонтакт.СрезПервых(, Новый Структура("Контрагент", Контрагент));
	
	СвязьКонтрагентКонтакт = СвязиКонтрагента.Найти(Контакт, "Контакт");
	ПоследнийЭлементСписка = (СвязьКонтрагентКонтакт.Порядок = СвязиКонтрагента.Количество());
	
	Если СвязьКонтрагентКонтакт = Неопределено ИЛИ (ПоследнийЭлементСписка И Смещение > 0) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	КонтактныеЛица.Ссылка КАК Контакт,
	|	СвязиКонтрагентКонтактСрезПервых.Порядок КАК Порядок
	|ИЗ
	|	РегистрСведений.СвязиКонтрагентКонтакт.СрезПервых(, Контрагент = &Контрагент) КАК СвязиКонтрагентКонтактСрезПервых
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛица КАК КонтактныеЛица
	|		ПО СвязиКонтрагентКонтактСрезПервых.Контакт = КонтактныеЛица.Ссылка";
	
	Если НЕ ВключатьНедействительные Тогда
		
		Запрос.Текст = Запрос.Текст + " ГДЕ КонтактныеЛица.Недействителен = ЛОЖЬ";
		
		Если Смещение > 0 Тогда
			Запрос.Текст = Запрос.Текст + " И Порядок > &Порядок УПОРЯДОЧИТЬ ПО Порядок ВОЗР";
		Иначе
			Запрос.Текст = Запрос.Текст + " И Порядок < &Порядок  УПОРЯДОЧИТЬ ПО Порядок УБЫВ";
		КонецЕсли;
		
	Иначе
		
		Если Смещение > 0 Тогда
			Запрос.Текст = Запрос.Текст + " ГДЕ Порядок > &Порядок УПОРЯДОЧИТЬ ПО Порядок ВОЗР";
		Иначе
			Запрос.Текст = Запрос.Текст + " ГДЕ Порядок < &Порядок  УПОРЯДОЧИТЬ ПО Порядок УБЫВ";
		КонецЕсли;
		
	КонецЕсли;
	
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Порядок", СвязьКонтрагентКонтакт.Порядок);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Смещение = Выборка.Порядок - СвязьКонтрагентКонтакт.Порядок;
	СвязиКонтрагента.Сортировать("Порядок Возр");
	СвязиКонтрагента.Сдвинуть(СвязьКонтрагентКонтакт, Смещение);
	
	НовыйПорядок = 0;
	НачатьТранзакцию();
	Попытка
		Для каждого Строка Из СвязиКонтрагента Цикл
			НовыйПорядок = НовыйПорядок + 1;
			
			МенеджерЗаписи = РегистрыСведений.СвязиКонтрагентКонтакт.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Период = Строка.Период;
			МенеджерЗаписи.Контрагент = Строка.Контрагент;
			МенеджерЗаписи.Контакт = Строка.Контакт;
			МенеджерЗаписи.Прочитать();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Строка);
			МенеджерЗаписи.Порядок = НовыйПорядок;
			МенеджерЗаписи.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
		ПорядокИзменен = Истина;
	Исключение
		ОтменитьТранзакцию();
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗаписиОтличаются(НоваяЗапись, АктуальнаяЗапись)
	
	Возврат НоваяЗапись.Должность <> АктуальнаяЗапись.Должность
		ИЛИ НоваяЗапись.СвязьНедействительна <> АктуальнаяЗапись.СвязьНедействительна;
	
КонецФункции

Функция ИзмененПорядокЗаписи(НоваяЗапись, АктуальнаяЗапись)
	
	Возврат НоваяЗапись.Порядок <> АктуальнаяЗапись.Порядок;
	
КонецФункции

#КонецОбласти

#КонецЕсли