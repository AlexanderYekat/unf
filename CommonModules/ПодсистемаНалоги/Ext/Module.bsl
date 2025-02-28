﻿#Область ПрограммныйИнтерфейс

// См. ОбновлениеИнформационнойБазыУНФ.ОбновлениеРозницыДоУНФ
Процедура ОбновлениеРозницыДоУНФ() Экспорт
	
	УстановитьКонстантыОбновленияРозницыДоУНФ();
	ЗаполнитьДанныеПриПереходеСРозницы();
	
КонецПроцедуры

// Процедура выполняет первоначальное заполнение данных подсистемы и включение функциональности при первом запуске приложения
//
Процедура ПриПервомЗапуске() Экспорт
	
	УстановитьКонстантыНачальногоЗаполнения();
	ПервоначальноеЗаполнениеОбъектовПодсистемы();
	
КонецПроцедуры

// Процедура выполняет первоначальное заполнение данных подсистемы
//
Процедура ПервоначальноеЗаполнениеОбъектовПодсистемы() Экспорт
	
	// Заполнение регистра сведений ЗначенияКБК
	РегистрыСведений.ЗначенияКБК.ЗагрузитьЗначенияКБК();
	ДанныеГосударственныхОрганов.ДобавитьОбновитьПолучательКазначейство();

КонецПроцедуры

// Процедура выполняет первоначальное включение функциональности подсистемы
//
Процедура УстановитьКонстантыНачальногоЗаполнения() Экспорт
	
	РежимЗапускаУНФ = Константы.ТекущийРежимЗапускаУНФ.Получить();
	ЭтоРозница 		= ВозможностиПриложения.ЭтоРозница();
	ЭтоУНФ 			= ВозможностиПриложения.ЭтоУНФ();
	
	ЭтоНастольноеПриложениеУНФ 	= ЭтоУНФ И РежимЗапускаУНФ = Перечисления.РежимыЗапускаУНФ.НастольноеПриложение;
	
	Если ЭтоУНФ Тогда
		// Установка константы функциональной опции участия в опросе
		Константы.ФункциональнаяОпцияОпросНалоги.Установить(Истина);
	КонецЕсли;
	
	Если ЭтоНастольноеПриложениеУНФ Тогда
		Константы.ИспользоватьКалендарьПодготовкиОтчетности.Установить(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьКонстантыОбновленияРозницыДоУНФ()
	Константы.ФункциональнаяОпцияОпросНалоги.Установить(Истина);
	Константы.ИспользоватьКалендарьПодготовкиОтчетности.Установить(Истина);
КонецПроцедуры

Процедура ЗаполнитьДанныеПриПереходеСРозницы()
	Возврат;
КонецПроцедуры

#КонецОбласти