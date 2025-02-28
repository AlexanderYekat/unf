﻿#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПутьКПрограммеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогВыбораКаталога = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораКаталога.Заголовок = НСтр("ru = 'Выберите папку, в которую установлена программа проверки 2-НДФЛ'");
	ДиалогВыбораКаталога.Показать(Новый ОписаниеОповещения("ПроверкаСтороннейПрограммойПослеВыбораКаталога", ЭтотОбъект));

КонецПроцедуры

#КонецОбласти

#область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Закрыть(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПутьКПрограмме));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверкаСтороннейПрограммойПослеВыбораКаталога(ВыбранныеФайлы, ПараметрыПроверки) Экспорт 
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКПрограмме = ВыбранныеФайлы[0];	
		
КонецПроцедуры

#КонецОбласти