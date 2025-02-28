﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриДобавленииПараметровШаблона(НазначениеШаблона, ПараметрыШаблона) Экспорт
	
	МенеджерОбъектаПоНазначениюШаблона(НазначениеШаблона).ПриДобавленииПараметровШаблона(НазначениеШаблона, ПараметрыШаблона);
	
КонецПроцедуры

Процедура ПриПолученииЗначенийПараметровШаблона(ОбъектПечати, НазначениеШаблона, ОписаниеПараметров, ДополнительныеПараметры) Экспорт
	
	МенеджерОбъектаПоНазначениюШаблона(НазначениеШаблона).ПриПолученииЗначенийПараметровШаблона(ОбъектПечати, НазначениеШаблона, ОписаниеПараметров, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ПриВыводеТаблицыПараметровШаблона(ПараметрыПечати, ИмяТаблицы, ОписаниеПараметров, ПараметрыВывода) Экспорт
	
	МенеджерОбъектаПоНазначениюШаблона(ПараметрыПечати.НазначениеШаблона).ПриВыводеТаблицыПараметровШаблона(ПараметрыПечати, ИмяТаблицы, ОписаниеПараметров, ПараметрыВывода);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция МенеджерОбъектаПоНазначениюШаблона(НазначениеШаблона)
	
	Если НазначениеШаблона = Перечисления.НазначенияШаблоновПечатиОфисныхДокументов.ДоговорКонтрагента
		ИЛИ НазначениеШаблона = Перечисления.НазначенияШаблоновПечатиОфисныхДокументов.ДоговорКонтрагентаЗаказ
		ИЛИ НазначениеШаблона = Перечисления.НазначенияШаблоновПечатиОфисныхДокументов.ДоговорКонтрагентаЗаказНаряд
		ИЛИ НазначениеШаблона = Перечисления.НазначенияШаблоновПечатиОфисныхДокументов.ДоговорКонтрагентаСчет Тогда
		
		Возврат Справочники.ДоговорыКонтрагентов;
		
	ИначеЕсли НазначениеШаблона = Перечисления.НазначенияШаблоновПечатиОфисныхДокументов.КоммерческоеПредложение Тогда
		
		Возврат Документы.ЗаказПокупателя;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли
