﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Запустить формирование списка документов по контрагенту.
//
// Параметры:
//  ДополнительныеПараметры - Структура - со свойствами:
//    ТекстЗапросаФильтрПолный - Строка - текст запроса
//    ПараметрыЗапроса - Структура - параметры запроса
//    ТекстЗапросаПоДокументам - Строка - текст запроса по документам
//  АдресРезультата - адрес во временном хранилище
//
Процедура ЗапуститьФормированиеСпискаДокументовПоКонтрагенту(ДополнительныеПараметры, АдресРезультата) Экспорт
	
	Запрос = Новый Запрос(ДополнительныеПараметры.ТекстЗапросаФильтрПолный);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Запрос.Параметры, ДополнительныеПараметры.ПараметрыЗапроса);
	Запрос.МенеджерВременныхТаблиц  = Новый МенеджерВременныхТаблиц;
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);

	Запрос.Текст = ДополнительныеПараметры.ТекстЗапросаПоДокументам;
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

// Групповое проведение документов
//
// Параметры:
//  ДополнительныеПараметры - Структура - со свойствами:
//    ВыбранныеДокументы - Массив - документы для проведения
//    РежимЗаписи - Массив - документы для проведения
//  АдресРезультата - адрес во временном хранилище
//
Процедура ГрупповоеПроведениеДокументов(ДополнительныеПараметры, АдресРезультата) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИзмененоДокументов", 0);
	Результат.Вставить("ИзмененныеТипы", Новый Массив);
	
	Для каждого Документ Из ДополнительныеПараметры.ВыбранныеДокументы Цикл
		
		ДокументОбъект = Документ.ПолучитьОбъект();
		
		Попытка
			ДокументОбъект.Заблокировать();
			ДокументЗаполнен = ДокументОбъект.ПроверитьЗаполнение();
			Если НЕ ДокументЗаполнен Тогда
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Ошибка заполнения документа.'"), Документ);
				Продолжить;
			КонецЕсли;
			ДокументОбъект.Записать(ДополнительныеПараметры.РежимЗаписи);
			
			Результат.ИзмененоДокументов = Результат.ИзмененоДокументов + 1;
			Тип = ТипЗнч(Документ);
			Если Результат.ИзмененныеТипы.Найти(Тип) = Неопределено Тогда
				Результат.ИзмененныеТипы.Добавить(Тип);
			КонецЕсли;
		Исключение
			ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), Документ);
		КонецПопытки;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

// Возвращает отборы документов.
// 
// Возвращаемое значение:
//  Соответствие - где ключ - имя документа, значение - группа отбора.
//
Функция ОтборыДокументов() Экспорт
	
	Результат = Новый Соответствие;
	
	Результат["ЗаказПокупателя"] = "ОтборЗаказыИСчета";
	Результат["ЗаказПоставщику"] = "ОтборЗаказыИСчета";
	Результат["СчетНаОплату"] = "ОтборЗаказыИСчета";
	Результат["СчетНаОплатуПоставщика"] = "ОтборЗаказыИСчета";
	
	Результат["АвансовыйОтчет"] = "ОтборНакладные";
	Результат["АктВыполненныхРабот"] = "ОтборНакладные";
	Результат["ВводНачальныхОстатков"] = "ОтборНакладные";
	Результат["Доверенность"] = "ОтборНакладные";
	Результат["ДополнительныеРасходы"] = "ОтборНакладные";
	Результат["ОтчетКомиссионера"] = "ОтборНакладные";
	Результат["ОтчетКомитенту"] = "ОтборНакладные";
	Результат["ОтчетОПереработке"] = "ОтборНакладные";
	Результат["ОтчетПереработчика"] = "ОтборНакладные";
	Результат["ПередачаВА"] = "ОтборНакладные";
	Результат["ПеремещениеЗапасов"] = "ОтборНакладные";
	Результат["ПриходнаяНакладная"] = "ОтборНакладные";
	Результат["ПриходнаяНакладная"] = "ОтборНакладные";
	Результат["ПрочиеРасходы"] = "ОтборНакладные";
	Результат["РасходнаяНакладная"] = "ОтборНакладные";
	Результат["СчетФактура"] = "ОтборНакладные";
	Результат["СчетФактураПолученный"] = "ОтборНакладные";
	
	Результат["Взаимозачет"] = "ОтборОплаты";
	Результат["ДоговорКредитаИЗайма"] = "ОтборОплаты";
	Результат["НачисленияПоКредитамИЗаймам"] = "ОтборОплаты";
	Результат["ОперацияПоПлатежнымКартам"] = "ОтборОплаты";
	Результат["ПлатежноеПоручение"] = "ОтборОплаты";
	Результат["ПоступлениеВКассу"] = "ОтборОплаты";
	Результат["ПоступлениеДСПлан"] = "ОтборОплаты";
	Результат["ПоступлениеНаСчет"] = "ОтборОплаты";
	Результат["РасходДСПлан"] = "ОтборОплаты";
	Результат["РасходИзКассы"] = "ОтборОплаты";
	Результат["РасходСоСчета"] = "ОтборОплаты";
	Результат["СверкаВзаиморасчетов"] = "ОтборОплаты";
	
	Результат["ЧекККМ"] = "ОтборРозница";
	Результат["ЧекККМВозврат"] = "ОтборРозница";
	Результат["ЧекККМКоррекции"] = "ОтборРозница";
	Результат["ОтчетОРозничныхПродажах"] = "ОтборРозница";
	
	Результат["МассоваяРассылка"] = "ОтборСобытия";
	Результат["ОтзывСогласияНаОбработкуПерсональныхДанных"] = "ОтборСобытия";
	Результат["Событие"] = "ОтборСобытия";
	Результат["СогласиеНаОбработкуПерсональныхДанных"] = "ОтборСобытия";
	
	Возврат Результат;
	
КонецФункции

// Документы, для которых уточняется доступ по виду операции
// 
// Возвращаемое значение:
//  Соответствие - Уточняемые типы документов
Функция УточняемыеТипыДокументов() Экспорт
	
	ОписаниеОбъектов = Новый Соответствие();
	ОписаниеОбъектов.Вставить("ПриходнаяНакладная", Тип("ДокументСсылка.ПриходнаяНакладная"));
	ОписаниеОбъектов.Вставить("РасходнаяНакладная", Тип("ДокументСсылка.РасходнаяНакладная"));
	
	Возврат ОписаниеОбъектов;
	
КонецФункции

// Возвращает список возможных фильтров для документов
//
// Возвращаемое значение:
//  Массив - список возможных фильтров
//
Функция ПолныйСписокФильтров() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Организация");
	Результат.Добавить("Контрагент");
	Результат.Добавить("Договор");
	Результат.Добавить("КонтрагентПолучатель");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли