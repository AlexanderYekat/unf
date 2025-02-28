﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкиКомпоновки = Неопределено;
	
	Если ЭтоАдресВременногоХранилища(Параметры.АдресНастроекКомпоновки) Тогда
		
		НастройкиКомпоновки = ПолучитьИзВременногоХранилища(Параметры.АдресНастроекКомпоновки);
		
	КонецЕсли;
		
	ИнициализироватьКомпоновщикСервер(НастройкиКомпоновки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	Закрыть(ПолучитьНастройкиКомпоновкиСервер());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьКомпоновщикСервер(НастройкиКомпоновки)
	
	СхемаВыгрузкиТоваров = Справочники.НастройкиИнтеграцииСИнтернетМагазином.ПолучитьМакет("СхемаВыгрузкиТоваров");
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаВыгрузкиТоваров, УникальныйИдентификатор);
	КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы)); 
	
	Если НастройкиКомпоновки = Неопределено Тогда
		КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(СхемаВыгрузкиТоваров.НастройкиПоУмолчанию);
	Иначе
		КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(НастройкиКомпоновки);
		КомпоновщикНастроекКомпоновкиДанных.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНастройкиКомпоновкиСервер()

	Настройки = КомпоновщикНастроекКомпоновкиДанных.ПолучитьНастройки();
	
	ОтборПредставление = ОбменСВнешнимиСистемамиЛогирование.ОбъектПредставление( Настройки.Отбор.Элементы );

	Результат = Новый Структура( "НастройкиКомпоновкиДанных, ОтборПредставление", Настройки, ОтборПредставление );

	Возврат Результат;
КонецФункции

#КонецОбласти
