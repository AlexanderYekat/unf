﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("МассивОрганизаций") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьОрганизации(Параметры.МассивОрганизаций);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗакрыть(Команда)
	
	ПараметрыЗакрытияФормы = Новый Структура();
	ПараметрыЗакрытияФормы.Вставить("АдресТаблицыВоВременномХранилище", СформироватьТаблицуВыбранныхЗначений());
	ПараметрыЗакрытияФормы.Вставить("ИмяТаблицыДляЗаполнения",          "Организации");
	
	ОповеститьОВыборе(ПараметрыЗакрытияФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметку(Команда)
	ЗаполнитьОтметки(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	ЗаполнитьОтметки(Истина);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОтметки(ЗначениеОтметки)
	
	ТаблицаЗаполняемыхЗначений = Организации.Выгрузить();
	ТаблицаЗаполняемыхЗначений.ЗаполнитьЗначения(ЗначениеОтметки, "Использовать");
	Организации.Загрузить(ТаблицаЗаполняемыхЗначений);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОрганизации(МассивОрганизаций)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Организация,
	|	ВЫБОР
	|		КОГДА Организации.Ссылка В (&МассивПереданыхЗначений)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Использовать
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("МассивПереданыхЗначений", МассивОрганизаций);
	Организации.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Функция СформироватьТаблицуВыбранныхЗначений()

	ТаблицаВыбранныхЗначений = Организации.Выгрузить(Новый Структура("Использовать", Истина), "Организация");
	Возврат ПоместитьВоВременноеХранилище(ТаблицаВыбранныхЗначений, УникальныйИдентификатор);

КонецФункции

#КонецОбласти
