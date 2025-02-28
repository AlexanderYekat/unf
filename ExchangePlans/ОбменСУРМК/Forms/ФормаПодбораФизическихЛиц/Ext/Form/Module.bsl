﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АдресТаблицыФизическихЛиц") Тогда
		АдресТаблицыФизическихЛиц = Параметры.АдресТаблицыФизическихЛиц;
		ТаблицаФизЛиц = ПолучитьИзВременногоХранилища(АдресТаблицыФизическихЛиц);
		ПодобранныеФизическиеЛица.Загрузить(ТаблицаФизЛиц);
		ЗаполнитьМассивВыбранныхФизическихЛиц();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФизическихЛицВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	НоваяСтрока = ПодобранныеФизическиеЛица.Добавить();
	НоваяСтрока.ФизическоеЛицо = ТекущиеДанные.Ссылка;
	
	ЗаполнитьМассивВыбранныхФизическихЛиц();
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМассивВыбранныхФизическихЛиц()
	
	ТаблицаФизЛиц = ПодобранныеФизическиеЛица.Выгрузить();
	МассивВыбранныхФизЛиц = ТаблицаФизЛиц.ВыгрузитьКолонку("ФизическоеЛицо");
	
	СписокФизическихЛиц.Параметры.УстановитьЗначениеПараметра("МассивВыбранныхФизЛиц", МассивВыбранныхФизЛиц);
	
	Элементы.СписокФизическихЛиц.Обновить();
	
КонецПроцедуры


&НаКлиенте
Процедура Перенести(Команда)
	
	АдресТаблицыВоВременномХранилище = ВернутьАдресТаблицы();
	
	Закрыть(АдресТаблицыВоВременномХранилище);
	
КонецПроцедуры

&НаСервере
Функция ВернутьАдресТаблицы()
	
	Возврат ПоместитьВоВременноеХранилище(ПодобранныеФизическиеЛица.Выгрузить());
	
КонецФункции

&НаКлиенте
Процедура ПодобранныеФизическиеЛицаПриИзменении(Элемент)
	
	ЗаполнитьМассивВыбранныхФизическихЛиц();
	
КонецПроцедуры

#КонецОбласти
