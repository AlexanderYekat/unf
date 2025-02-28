﻿
#Область ПрограммныйИнтерфейс

// Заполняет хозяйственную операцию в наборе записей
//
// Параметры:
//  НаборЗаписей - РегистрНакопления.НаборЗаписей
//
Процедура ЗаполнитьХозяйственнуюОперациюВНабореЗаписей(НаборЗаписей) Экспорт
	
	Регистратор = НаборЗаписей.Отбор.Регистратор.Значение;
	РегистраторМетаданные = Регистратор.Метаданные();
	ХозяйственнаяОперация = Неопределено;
	
	Если РегистраторМетаданные.Реквизиты.Найти("ХозяйственнаяОперация") = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИзмерениеХозяйственнаяОперацияБылоЗаполнено = Истина;
	
	Для Каждого Движение Из НаборЗаписей Цикл
		Если ЗначениеЗаполнено(Движение.ХозяйственнаяОперация) Тогда
			Продолжить;
		КонецЕсли;
		РазыменоватьХозяйственнуюОперациюИзРегистратора(Регистратор, ХозяйственнаяОперация);
		Если Не ЗначениеЗаполнено(ХозяйственнаяОперация) Тогда
			Продолжить;
		КонецЕсли;
		Движение.ХозяйственнаяОперация = ХозяйственнаяОперация;
		ИзмерениеХозяйственнаяОперацияБылоЗаполнено = Ложь;
	КонецЦикла;
	
	Если Не ИзмерениеХозяйственнаяОперацияБылоЗаполнено Тогда
		ИмяСобытия = НСтр("ru='Проведение.ХозяйственнаяОперация'", ОбщегоНазначения.КодОсновногоЯзыка());
		Комментарий = НСтр("ru='Измерение ""ХозяйственнаяОперация"" не было заранее заполнено при проведении и было разыменовано'");
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Предупреждение, НаборЗаписей.Метаданные(), Регистратор, Комментарий);
	КонецЕсли;
	
КонецПроцедуры

// Хозяйственная операция по виду операции документа
//
// Параметры:
//  ВидОперации		 - Строка, ПеречислениеСсылка.ВидыОпераций* - вид операции.
//  СсылкаНаДокумент - ДокументСсылка - ссылка на документ, для которого определяется хозяйственная операция.
// 
// Возвращаемое значение:
//  СправочникСсылка.ХозяйственныеОперации - предопределенный элемент справочника "Хозяйственные операции"
//
Функция ХозяйственнаяОперацияПоВидуОперацииДокумента(ВидОперации, СсылкаНаДокумент = Неопределено) Экспорт
	
	Если ТипЗнч(СсылкаНаДокумент) = Тип("ДокументСсылка.ЗакрытиеМесяца") Тогда
		
		Результат = Справочники.ХозяйственныеОперации.ЗакрытиеМесяца;
		
	ИначеЕсли ТипЗнч(СсылкаНаДокумент) = Тип("ДокументСсылка.ДоговорКредитаИЗайма") Тогда
		
		ШаблонСообщенияОбОшибке = НСтр("ru = 'Не удалось найти вид договора ""%1"" для документа ""%2"".
			|Имя значения = ""%3""'");
		
		Результат = ХозяйственнаяОперацияПоВидуОперации(ВидОперации, СсылкаНаДокумент, ШаблонСообщенияОбОшибке);
		
	ИначеЕсли ТипЗнч(ВидОперации) = Тип("Строка") Тогда
		
		ИмяПредопределенного = СтрШаблон("Справочник.ХозяйственныеОперации.%1", СокрЛП(ВидОперации));
		Результат = ОбщегоНазначения.ПредопределенныйЭлемент(ИмяПредопределенного);
		
	ИначеЕсли УДокументаЕстьРеквизитВидОперации(ВидОперации) Тогда
		
		Если ЗначениеЗаполнено(ВидОперации) Тогда
			
			ШаблонСообщенияОбОшибке = НСтр("ru = 'Не удалось найти вид операции ""%1"" для документа ""%2"".
				|Имя значения = %3'");
			
			Результат = ХозяйственнаяОперацияПоВидуОперации(ВидОперации, СсылкаНаДокумент, ШаблонСообщенияОбОшибке);
			
		Иначе
			
			Результат = Справочники.ХозяйственныеОперации.ПустаяСсылка();
			
		КонецЕсли;
		
	Иначе
		
		Результат = Справочники.ХозяйственныеОперации.ПустаяСсылка();
		
	КонецЕсли;
	
	ХозяйственныеОперацииСерверПереопределяемый.УстановитьХозяйственнуюОперациюПоВидуОперацииДокумента(ВидОперации,
		Результат, СсылкаНаДокумент);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ХозяйственнаяОперацияПоВидуОперации(ВидОперации, СсылкаНаДокумент, ШаблонСообщенияОбОшибке)
	
	Попытка 
		
		ИмяЗначенияПеречисления = ОбщегоНазначения.ИмяЗначенияПеречисления(ВидОперации);
		ИмяПредопределенного = СтрШаблон("Справочник.ХозяйственныеОперации.%1", ИмяЗначенияПеречисления);
		Результат = ОбщегоНазначения.ПредопределенныйЭлемент(ИмяПредопределенного);
		
	Исключение
		
		ТекстСообщенияОбОшибке = СтрШаблон(ШаблонСообщенияОбОшибке, ВидОперации, СсылкаНаДокумент, ИмяЗначенияПеречисления);
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщенияОбОшибке);
		Результат = Справочники.ХозяйственныеОперации.ПустаяСсылка();
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция УДокументаЕстьРеквизитВидОперации(ВидОперации)
	
	Возврат ВидОперации <> Неопределено;
	
КонецФункции

Процедура РазыменоватьХозяйственнуюОперациюИзРегистратора(Регистратор, ХозяйственнаяОперация)
	
	Если ЗначениеЗаполнено(ХозяйственнаяОперация) Тогда
		Возврат;
	КонецЕсли;
	ХозяйственнаяОперация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Регистратор, "ХозяйственнаяОперация");
	
КонецПроцедуры

#КонецОбласти
