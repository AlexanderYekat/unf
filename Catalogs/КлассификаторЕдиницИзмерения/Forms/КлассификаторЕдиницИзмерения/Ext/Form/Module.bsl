﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Дерево = Справочники.КлассификаторЕдиницИзмерения.ПолучитьДанныеКлассификатора();
	
	Дерево.Колонки.Добавить("Выбран",     Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Существует", Новый ОписаниеТипов("Булево"));
	
	СсылкаПоКоду = Новый Соответствие;
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЕдиницыИзмерения.Ссылка КАК Ссылка,
	|	ЕдиницыИзмерения.Код КАК Код
	|ИЗ
	|	Справочник.КлассификаторЕдиницИзмерения КАК ЕдиницыИзмерения
	|ГДЕ
	|	ЕдиницыИзмерения.Код <> """"");
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СсылкаПоКоду[СокрЛП(Выборка.Код)] = Выборка.Ссылка;
	КонецЦикла;
	
	ОбработатьДерево(Дерево, СсылкаПоКоду);
	
	СоответствиеЕдиниц = Новый ФиксированноеСоответствие(СсылкаПоКоду);
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоКлассификатора");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоКлассификатора

&НаКлиенте
Процедура ОбходДереваВверх(ТекущиеДанные)
	
	Родитель = ТекущиеДанные.ПолучитьРодителя();
	Если Родитель <> Неопределено Тогда // Верхний уровень
		
		ДочерниеСтроки = Родитель.ПолучитьЭлементы();
		КоличествоВыбранных = 0;
		ОбщееКоличество = 0;
		Для каждого Элемент Из ДочерниеСтроки Цикл
			Если Элемент.Выбран = 2 Тогда
				КоличествоВыбранных = КоличествоВыбранных + 0.5;
			ИначеЕсли Элемент.Выбран = 1 Тогда
				КоличествоВыбранных = КоличествоВыбранных + 1;
			КонецЕсли;
			ОбщееКоличество = ОбщееКоличество + 1;
		КонецЦикла;
		
		Если ОбщееКоличество = КоличествоВыбранных Тогда
			Родитель.Выбран = 1;
		ИначеЕсли КоличествоВыбранных = 0 Тогда
			Родитель.Выбран = 0;
		Иначе
			Родитель.Выбран = 2;
		КонецЕсли;
		
		ОбходДереваВверх(Родитель);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбходДереваВниз(ТекущиеДанные)
	
	ДочерниеСтроки = ТекущиеДанные.ПолучитьЭлементы();
	Для каждого Элемент Из ДочерниеСтроки Цикл
		Элемент.Выбран = ТекущиеДанные.Выбран;
		ОбходДереваВниз(Элемент);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранПриИзменении(ТекущиеДанные)
	
	Если ТекущиеДанные.Выбран = 2 Тогда
		ТекущиеДанные.Выбран = 0;
	КонецЕсли;
	
	ОбходДереваВверх(ТекущиеДанные);
	ОбходДереваВниз(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКлассификатораВыбранПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоКлассификатора.ТекущиеДанные;
	ВыбранПриИзменении(ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(РезультатПодбораНаСервере());
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатораКодЧисловой.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатораУсловноеОбозначениеНациональное.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатораУсловноеОбозначениеМеждународное.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатораКодовоеБуквенноеОбозначениеНациональное.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатораКодовоеБуквенноеОбозначениеМеждународное.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоКлассификатора.КодЧисловой");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатора.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоКлассификатора.КодЧисловой");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста,,, Истина));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатора.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоКлассификатора.Существует");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаСервере
Функция РезультатПодбораНаСервере()
	
	Результат = Новый Структура;
	Результат.Вставить("НовыеЭлементы", Новый Массив);
	Результат.Вставить("СообщениеОбОшибке", "");
	
	Дерево = РеквизитФормыВЗначение("ДеревоКлассификатора");
	
	НачатьТранзакцию();
	
	Попытка
		
		Для Каждого СтрокаУровень1 Из Дерево.Строки Цикл
			
			Если Не СтрокаУровень1.Выбран Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого СтрокаУровень2 Из СтрокаУровень1.Строки Цикл
				
				Если Не СтрокаУровень2.Выбран Тогда
					Продолжить;
				КонецЕсли;
				
				Для Каждого СтрокаУровень3 Из СтрокаУровень2.Строки Цикл
					
					Если Не СтрокаУровень3.Выбран Тогда
						Продолжить;
					КонецЕсли;
					
					НоваяЕдиницаИзмерения = Ложь;
					ЕдиницаСсылка = СоответствиеЕдиниц.Получить(СокрЛП(СтрокаУровень3.КодЧисловой));
					
					Если ЕдиницаСсылка <> Неопределено Тогда
						СправочникОбъект = ЕдиницаСсылка.ПолучитьОбъект();
					Иначе
						НоваяЕдиницаИзмерения = Истина;
						СправочникОбъект = Справочники.КлассификаторЕдиницИзмерения.СоздатьЭлемент();
					КонецЕсли;
					
					СправочникОбъект.Наименование = НаименованиеЕдиницыИзмерения(СтрокаУровень3);
					СправочникОбъект.МеждународноеСокращение = СтрЗаменить(СтрокаУровень3.КодовоеБуквенноеОбозначениеМеждународное, Символы.ПС, "/");
					СправочникОбъект.НаименованиеПолное = СтрЗаменить(СтрокаУровень3.Наименование,Символы.ПС,"/");
					СправочникОбъект.Код = СокрЛП(СтрокаУровень3.КодЧисловой);
					
					Если ЗначениеЗаполнено(СтрокаУровень3.ТипИзмеряемойВеличины) Тогда
						СправочникОбъект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин[СтрокаУровень3.ТипИзмеряемойВеличины];
					КонецЕсли;
					
					СправочникОбъект.Записать();
					
					Если НоваяЕдиницаИзмерения Тогда
						Результат.НовыеЭлементы.Добавить(СправочникОбъект.Ссылка);
					КонецЕсли;
					
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		Результат.НовыеЭлементы.Очистить();
		
		Результат.СообщениеОбОшибке = НСтр("ru = 'Не удалось подобрать единицу измерения из классификатора.'");
		
		КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка(); // Для записи события в журнал регистрации.
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Подбор единиц измерения из классификатора.'", КодОсновногоЯзыка),
		УровеньЖурналаРегистрации.Ошибка, , ,
		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция НаименованиеЕдиницыИзмерения(Знач СтрокаУровень3)
	
	Если ЗначениеЗаполнено(СтрокаУровень3.УсловноеОбозначениеНациональное) Тогда
		Результат = СтрокаУровень3.УсловноеОбозначениеНациональное;
	ИначеЕсли ЗначениеЗаполнено(СтрокаУровень3.УсловноеОбозначениеМеждународное) Тогда
		Результат = СтрокаУровень3.УсловноеОбозначениеМеждународное;
	ИначеЕсли ЗначениеЗаполнено(СтрокаУровень3.КодовоеБуквенноеОбозначениеНациональное) Тогда
		Результат = СтрокаУровень3.КодовоеБуквенноеОбозначениеНациональное;
	ИначеЕсли ЗначениеЗаполнено(СтрокаУровень3.КодовоеБуквенноеОбозначениеМеждународное) Тогда
		Результат = СтрокаУровень3.КодовоеБуквенноеОбозначениеМеждународное;
	Иначе
		Результат = СтрокаУровень3.Наименование;
	КонецЕсли;
	
	Возврат СтрЗаменить(Результат, Символы.ПС, "/");

КонецФункции

&НаСервере
Процедура ОбработатьДерево(Дерево, СсылкаПоКоду)
	
	МассивКУдалению = Новый Массив;
	ОбработатьУровень(Дерево.Строки, МассивКУдалению, СсылкаПоКоду, 1);
	УдалитьСтрокиИзКоллекцииСтрок(Дерево.Строки, МассивКУдалению);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьУровень(Строки, МассивКУдалению, СсылкаПоКоду, Уровень)
	
	Для каждого ТекСтрока Из Строки Цикл
		Если Уровень = 3 Тогда
			
			Если СсылкаПоКоду[ТекСтрока.КодЧисловой] <> Неопределено Тогда
				ТекСтрока.Существует = Истина;
				ТекСтрока.Выбран     = Истина;
			КонецЕсли;
			
		Иначе
			МассивКУдалениюСледующегоУровня = Новый Массив;
			ОбработатьУровень(ТекСтрока.Строки, МассивКУдалениюСледующегоУровня, СсылкаПоКоду, Уровень + 1);
			УдалитьСтрокиИзКоллекцииСтрок(ТекСтрока.Строки, МассивКУдалениюСледующегоУровня);
			Если ТекСтрока.Строки.Количество() = 0 Тогда
				МассивКУдалению.Добавить(ТекСтрока);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСтрокиИзКоллекцииСтрок(Строки, МассивКУдалению)
	Для Каждого СтрокаКУдалению Из МассивКУдалению Цикл
		Строки.Удалить(СтрокаКУдалению);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
