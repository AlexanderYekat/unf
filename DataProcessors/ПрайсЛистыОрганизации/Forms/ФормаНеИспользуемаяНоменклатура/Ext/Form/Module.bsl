﻿
&НаСервере
Процедура ОбновитьТабличныйДокументНаСервере()
	
	// 1. Получим СКД
	СхемаКомпоновкиДанных = Обработки.ПрайсЛистыОрганизации.ПолучитьМакет("СКД_НеИспользуемаяНоменклатура");
	
	// 2. создаем настройки для схемы 
	НастройкиКомпоновкиДанных = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	// 3. готовим макет 
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, ДанныеРасшифровки, , Тип("ГенераторМакетаКомпоновкиДанных"));
	
	// 4. исполняем макет 
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет, , ДанныеРасшифровки);
	ПроцессорКомпоновки.Сбросить();
	
	// 5. выводим результат 
	ТабличныйДокумент.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабличныйДокумент);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	АдресХранилищаСКД 				= ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	АдресХранилищаДанныеРасшифровки = ПоместитьВоВременноеХранилище(ДанныеРасшифровки, УникальныйИдентификатор);
	
КонецПроцедуры

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьТабличныйДокументНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СобытияРеквизитовФормы

&НаКлиенте
Процедура ТабличныйДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДоступныеДействия = Новый Массив;
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьЗначениеРасшифровки", ЭтотОбъект);
	
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(АдресХранилищаДанныеРасшифровки, Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресХранилищаСКД));
	ОбработкаРасшифровки.ПоказатьВыборДействия(ОписаниеОповещения, Расшифровка, ДоступныеДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗначениеРасшифровки(ВыполненноеДействие, ПараметрВыполненногоДействия, ДополнительныеПараметры) Экспорт
	
	Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
		
		Если ЗначениеЗаполнено(ПараметрВыполненногоДействия) Тогда
			
			ПоказатьЗначение(, ПараметрВыполненногоДействия);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьТабличныйДокументНаСервере();
	
КонецПроцедуры

#КонецОбласти