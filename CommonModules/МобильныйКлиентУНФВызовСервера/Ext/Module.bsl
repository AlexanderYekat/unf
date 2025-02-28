﻿#Область ПрограммныйИнтерфейс

// См. РегистрыСведений.СчетчикДляОткрытияФормыОценкиМобильногоКлиента.ЗначениеСчетчика
Функция ЗначениеСчетчикаДляОткрытияФормыОценки() Экспорт
	
	Возврат РегистрыСведений.СчетчикДляОткрытияФормыОценкиМобильногоКлиента.ЗначениеСчетчика();
	
КонецФункции

// См. РегистрыСведений.СчетчикДляОткрытияФормыОценкиМобильногоКлиента.УстановитьЗначение
Процедура УстановитьСчетчикДляОткрытияФормыОценки(ЗначениеСчетчика) Экспорт
	
	РегистрыСведений.СчетчикДляОткрытияФормыОценкиМобильногоКлиента.УстановитьЗначение(ЗначениеСчетчика);
	
КонецПроцедуры

// См. РегистрыСведений.СчетчикЗапусковКлиента.УвеличитьСчетчик
Процедура УвеличитьСчетчикЗапусковКлиента(ЭтоМобильныйКлиент) Экспорт
	
	РегистрыСведений.СчетчикЗапусковКлиента.УвеличитьСчетчик(ЭтоМобильныйКлиент);
	
КонецПроцедуры

// См. РегистрыСведений.СчетчикЗапусковКлиента.ЗначенияСчетчика
Функция ЗначенияСчетчикаЗапусковКлиента() Экспорт
	
	Возврат РегистрыСведений.СчетчикЗапусковКлиента.ЗначенияСчетчика();
	
КонецФункции

// См. РегистрыСведений.СчетчикЗапусковКлиента.УстановитьЗапретОткрытияФормыОпроса
Процедура УстановитьЗапретОткрытияФормыОпроса(ЗапретОткрытияОпроса) Экспорт
	
	РегистрыСведений.СчетчикЗапусковКлиента.УстановитьЗапретОткрытияФормыОпроса(ЗапретОткрытияОпроса);
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиентаПриЗапуске.
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Параметры.Вставить("ПараметрыЗапускаМобильногоКлиента", ЗначенияСчетчиков(ОбщегоНазначения.ЭтоМобильныйКлиент()));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗначенияСчетчиков(ЭтоМобильныйКлиент)
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("НужноОткрытьФормуОценкиМобильногоКлиента", Ложь);
	Если ЭтоМобильныйКлиент Тогда
		СчетчикОткрытияФормыОценкиПриложения = ЗначениеСчетчикаДляОткрытияФормыОценки();
		Если СчетчикОткрытияФормыОценкиПриложения >= 3 Тогда
			СтруктураВозврата.НужноОткрытьФормуОценкиМобильногоКлиента = Истина;
		ИначеЕсли СчетчикОткрытияФормыОценкиПриложения <> -1 Тогда
			СчетчикОткрытияФормыОценкиПриложения = СчетчикОткрытияФормыОценкиПриложения + 1;
			УстановитьСчетчикДляОткрытияФормыОценки(СчетчикОткрытияФормыОценкиПриложения);
		КонецЕсли;
	КонецЕсли;
	
	УвеличитьСчетчикЗапусковКлиента(ЭтоМобильныйКлиент);
	
	ЗначенияСчетчикаЗапусковКлиента = ЗначенияСчетчикаЗапусковКлиента();
	
	СтруктураВозврата.Вставить("ЗначенияСчетчикаЗапусковКлиента", ЗначенияСчетчикаЗапусковКлиента);
	СтруктураВозврата.Вставить("ЭтоМобильныйКлиент", ЭтоМобильныйКлиент);
	СтруктураВозврата.Вставить("ИспользоватьМобильнуюТелефонию", ПолучитьФункциональнуюОпцию("ИспользоватьМобильнуюТелефонию"));
	
	Возврат СтруктураВозврата;
	
КонецФункции

#КонецОбласти
