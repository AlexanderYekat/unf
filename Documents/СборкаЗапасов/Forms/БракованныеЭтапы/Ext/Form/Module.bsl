﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьЭтапыПроизводства") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	Если НЕ Параметры.Свойство("Спецификация") 
		ИЛИ НЕ Параметры.Свойство("ВыполненныеЭтапы")
		ИЛИ НЕ Параметры.Свойство("КлючСвязи", КлючСвязи) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Спецификация", Параметры.Спецификация);
	Запрос.УстановитьПараметр("Номенклатура", Параметры.Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Параметры.Характеристика);
	Запрос.УстановитьПараметр("Заказ", Параметры.Заказ);
	Запрос.УстановитьПараметр("Регистратор", Параметры.Регистратор);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(ЭтапыПроизводства.КоличествоПлан) КАК КоличествоПланФакт,
	|	ЭтапыПроизводства.Этап,
	|	СУММА(0) КАК Количество
	|ПОМЕСТИТЬ ВременнаяТаблицаЭтапы
	|ИЗ
	|	РегистрНакопления.ЭтапыПроизводства КАК ЭтапыПроизводства
	|ГДЕ
	|	ЭтапыПроизводства.Номенклатура = &Номенклатура
	|	И ЭтапыПроизводства.Характеристика = &Характеристика
	|	И ЭтапыПроизводства.Спецификация = &Спецификация
	|	И ЭтапыПроизводства.Заказ = &Заказ
	|	И ЭтапыПроизводства.Регистратор <> &Регистратор
	|СГРУППИРОВАТЬ ПО
	|	ЭтапыПроизводства.Этап
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СУММА(-ЭтапыПроизводства.КоличествоФакт),
	|	ЭтапыПроизводства.Этап,
	|	СУММА(ЭтапыПроизводства.КоличествоФакт)
	|ИЗ
	|	РегистрНакопления.ЭтапыПроизводства КАК ЭтапыПроизводства
	|ГДЕ
	|	ЭтапыПроизводства.Номенклатура = &Номенклатура
	|	И ЭтапыПроизводства.Характеристика = &Характеристика
	|	И ЭтапыПроизводства.Спецификация = &Спецификация
	|	И ЭтапыПроизводства.Заказ = &Заказ
	|	И ЭтапыПроизводства.Регистратор <> &Регистратор
	|СГРУППИРОВАТЬ ПО
	|	ЭтапыПроизводства.Этап
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаЭтапы.Этап КАК Значение,
	|	СУММА(ВременнаяТаблицаЭтапы.Количество) КАК Количество
	|ИЗ
	|	ВременнаяТаблицаЭтапы КАК ВременнаяТаблицаЭтапы
	|ГДЕ
	|	ВременнаяТаблицаЭтапы.Количество > 0
	|	И ВременнаяТаблицаЭтапы.Этап <> ЗНАЧЕНИЕ(Справочник.ЭтапыПроизводства.ЗавершениеПроизводства)
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблицаЭтапы.Этап
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаЭтапы.Этап КАК Значение,
	|	СУММА(ВременнаяТаблицаЭтапы.Количество) КАК Количество
	|ИЗ
	|	ВременнаяТаблицаЭтапы КАК ВременнаяТаблицаЭтапы
	|ГДЕ
	|	ВременнаяТаблицаЭтапы.Количество > 0
	|	И ВременнаяТаблицаЭтапы.Этап = ЗНАЧЕНИЕ(Справочник.ЭтапыПроизводства.ЗавершениеПроизводства)
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблицаЭтапы.Этап";
	МассивРезультатов = Запрос.ВыполнитьПакет();
	Выборка = МассивРезультатов[1].Выбрать();
	ТаблицаЗавершенных = МассивРезультатов[2].Выгрузить();
	Пока Выборка.Следующий() Цикл
		Если Выборка.Количество - ?(ТаблицаЗавершенных.Количество()>0,ТаблицаЗавершенных[0].Количество,0) > 0 Тогда
		НоваяСтрока = БракованныеЭтапы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.Количество = Выборка.Количество - ?(ТаблицаЗавершенных.Количество()>0,ТаблицаЗавершенных[0].Количество,0) ;
		КонецЕсли;
	КонецЦикла;
	Если БракованныеЭтапы.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	ИмяКлючаОбъекта = "СборкаЗапасовБрак";
	
	ЗначениеНастройки = ХранилищеСистемныхНастроек.Загрузить(ИмяКлючаОбъекта, ИмяКлючаОбъекта+"_" + "ПоказыватьИнформацию");
	
	Если ЗначениеНастройки = Неопределено Тогда
		ПоказыватьИнформацию = Истина;
	Иначе
		ПоказыватьИнформацию = ЗначениеНастройки;
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура УстановитьФлажки(Команда)
ИзменитьФлажки(Истина)
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
ИзменитьФлажки();
КонецПроцедуры

&НаСервере
Процедура ИзменитьФлажки(Отметка=Ложь)
	ТаблицаЭтапов = БракованныеЭтапы.Выгрузить();
	ТаблицаЭтапов.ЗаполнитьЗначения(Отметка,"Пометка" );
	БракованныеЭтапы.Загрузить(ТаблицаЭтапов);
КонецПроцедуры



&НаКлиенте
Процедура Выбрать(Команда)
	
	
	МассивЭтапов = ТаблицаЭтапов();
	
	
	ОповеститьОВыборе(МассивЭтапов);
КонецПроцедуры

&НаСервере
Функция ТаблицаЭтапов() 
	Отбор = Новый Структура();
	Отбор.Вставить("Пометка",Истина);
	ТаблицаЭтапов = БракованныеЭтапы.Выгрузить(Отбор, );
	МассивЭтапов = Новый Массив;
	Для Каждого Этап из ТаблицаЭтапов Цикл
	
	Результат = Новый Структура;
	Результат.Вставить("КлючСвязи", 	КлючСвязи);
	Результат.Вставить("Этап", 			Этап.Значение);
	Результат.Вставить("Количество", 	Этап.Количество);
	
	МассивЭтапов.Добавить(Результат);
	КонецЦикла;
	Возврат МассивЭтапов;
КонецФункции


&НаКлиенте
Процедура ДекорацияИнформацияПоОтходамЗакрытьНажатие(Элемент)
	Элементы.ГруппаИнформация.Видимость = Ложь;
	ПоказыватьИнформацию = Ложь;
	
	СохранитьНастройкуПоказыватьИнформациюПоНовойСхеме();
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкуПоказыватьИнформациюПоНовойСхеме()

	ИмяКлючаОбъекта = "СборкаЗапасовБрак";
	ХранилищеСистемныхНастроек.Сохранить(ИмяКлючаОбъекта,
	ИмяКлючаОбъекта+"_" + "ПоказыватьИнформацию", ПоказыватьИнформацию);
	
КонецПроцедуры