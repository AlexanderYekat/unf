﻿#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруСлужебныхРеквизитовНоменклатуры(Номенклатура) Экспорт

	// ++( 00-00012169
	СтруктураРеквизитов = Новый Структура("Артикул, ТипНоменклатуры, ХарактеристикиИспользуются, "
										+ "ЕдиницаИзмерения, ПроверятьЗаполнениеПартий, ИспользоватьПартии, "
										+ "ПроверятьЗаполнениеХарактеристики");
	// )++ 00-00012169
	// --( 00-00012169
	//СтруктураРеквизитов = Новый Структура("Артикул, ТипНоменклатуры, ХарактеристикиИспользуются, "
	//									+ "ЕдиницаИзмерения, ПроверятьЗаполнениеПартий, ИспользоватьПартии, "
	//									+ "ПроверятьЗаполнениеХарактеристики, СтатусУказанияСерий");
	// )-- 00-00012169
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Номенклатура.Артикул КАК Артикул,
	|	Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	Номенклатура.ИспользоватьХарактеристики КАК ХарактеристикиИспользуются,
	|	Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Номенклатура.ИспользоватьПартии КАК ИспользоватьПартии,
	// ++( 00-00012169
		//|	Номенклатура.ИспользоватьСерииНоменклатуры КАК ИспользоватьСерииНоменклатуры,
	// )++ 00-00012169
	|	Номенклатура.ПроверятьЗаполнениеПартий КАК ПроверятьЗаполнениеПартий,
	|	Номенклатура.ПроверятьЗаполнениеХарактеристики КАК ПроверятьЗаполнениеХарактеристики
	|ПОМЕСТИТЬ РеквизитыНоменклатуры
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеквизитыНоменклатуры.Артикул КАК Артикул,
	|	РеквизитыНоменклатуры.ТипНоменклатуры КАК ТипНоменклатуры,
	|	РеквизитыНоменклатуры.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	РеквизитыНоменклатуры.ХарактеристикиИспользуются КАК ХарактеристикиИспользуются,
	|	РеквизитыНоменклатуры.ПроверятьЗаполнениеПартий КАК ПроверятьЗаполнениеПартий,
	|	РеквизитыНоменклатуры.ИспользоватьПартии КАК ИспользоватьПартии,
	// ++( 00-00012169
	|	РеквизитыНоменклатуры.ПроверятьЗаполнениеХарактеристики КАК ПроверятьЗаполнениеХарактеристики
	// )++ 00-00012169
	// --( 00-00012169
	//|	РеквизитыНоменклатуры.ПроверятьЗаполнениеХарактеристики КАК ПроверятьЗаполнениеХарактеристики,
	// )-- 00-00012169
	// ++( 00-00012169
	//|	ВЫБОР
	//|		КОГДА НЕ РеквизитыНоменклатуры.ИспользоватьСерииНоменклатуры
	//|				ИЛИ РеквизитыНоменклатуры.ИспользоватьСерииНоменклатуры ЕСТЬ NULL
	//|			ТОГДА 0
	//|		КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	//|			ТОГДА 2
	//|		ИНАЧЕ 21
	//|	КОНЕЦ КАК СтатусУказанияСерий
	// )++ 00-00012169
	// --( 00-00012169
	//|	ВЫБОР
	//|		КОГДА РеквизитыНоменклатуры.ИспользоватьПартии
	//|			ТОГДА 1
	//|		ИНАЧЕ 0
	//|	КОНЕЦ КАК СтатусУказанияСерий
	// )-- 00-00012169
	|ИЗ
	|	РеквизитыНоменклатуры КАК РеквизитыНоменклатуры");
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Результат);
	КонецЕсли;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

// Параметры:
// 	ВидЦен - СправочникСсылка.ВидыЦен
// Возвращаемое значение:
// 	Булево
Функция ЦенаВключаетНДС(Знач ВидЦен) Экспорт 
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидЦен, "ЦенаВключаетНДС");
КонецФункции

#КонецОбласти

#Область ОбработкаСобытийФорм

Процедура ЗаполнитьПродукциюВЕТИС(ТекущаяСтрока, ПараметрыЗаполнения) Экспорт
	
	Отбор = Неопределено;
	ПараметрыЗаполнения.Свойство("ОтборПродукция",Отбор);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоответствиеНоменклатурыВЕТИС.Продукция КАК Продукция,
	|	СоответствиеНоменклатурыВЕТИС.Номенклатура КАК Номенклатура
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыВЕТИС КАК СоответствиеНоменклатурыВЕТИС
	|ГДЕ
	|	СоответствиеНоменклатурыВЕТИС.Номенклатура = &Номенклатура
	|	И СоответствиеНоменклатурыВЕТИС.Характеристика = &Характеристика
	|	И (СоответствиеНоменклатурыВЕТИС.Серия = &Серия 
	|		ИЛИ &СерияЗаполнена = ЛОЖЬ)
	|	И (СоответствиеНоменклатурыВЕТИС.Продукция.Производители.Производитель = &Предприятие
	|		ИЛИ &Предприятие = ЗНАЧЕНИЕ(Справочник.ПредприятияВЕТИС.ПустаяСсылка))
	|	И (СоответствиеНоменклатурыВЕТИС.Продукция.ХозяйствующийСубъектПроизводитель = &ХозяйствующийСубъект
	|		ИЛИ &ХозяйствующийСубъект = ЗНАЧЕНИЕ(Справочник.ХозяйствующиеСубъектыВЕТИС.ПустаяСсылка))
	|	И (НЕ &ИсключатьПродукциюТретьегоУровня
	|		ИЛИ СоответствиеНоменклатурыВЕТИС.Продукция.Идентификатор <> """")
	|");
	
	Запрос.УстановитьПараметр("Номенклатура",   ТекущаяСтрока.Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", ТекущаяСтрока.Характеристика);
	Запрос.УстановитьПараметр("Серия",          ТекущаяСтрока.Серия);
	Запрос.УстановитьПараметр("СерияЗаполнена", ЗначениеЗаполнено(ТекущаяСтрока.Серия));
	
	Если ЗначениеЗаполнено(Отбор) Тогда
		Если Отбор.Свойство("Предприятие") Тогда
			Запрос.УстановитьПараметр("Предприятие", Отбор.Предприятие);
		Иначе
			Запрос.УстановитьПараметр("Предприятие", Справочники.ПредприятияВЕТИС.ПустаяСсылка());
		КонецЕсли;
		Если Отбор.Свойство("ХозяйствующийСубъект") Тогда
			Запрос.УстановитьПараметр("ХозяйствующийСубъект", Отбор.ХозяйствующийСубъект);
		Иначе
			Запрос.УстановитьПараметр("ХозяйствующийСубъект", Справочники.ХозяйствующиеСубъектыВЕТИС.ПустаяСсылка());
		КонецЕсли;
	Иначе
		Запрос.УстановитьПараметр("Предприятие", Справочники.ПредприятияВЕТИС.ПустаяСсылка());
		Запрос.УстановитьПараметр("ХозяйствующийСубъект", Справочники.ХозяйствующиеСубъектыВЕТИС.ПустаяСсылка());
	КонецЕсли;
	
	Если ПараметрыЗаполнения.Свойство("ИсключатьПродукциюТретьегоУровня") Тогда
		Запрос.УстановитьПараметр("ИсключатьПродукциюТретьегоУровня", ПараметрыЗаполнения.ИсключатьПродукциюТретьегоУровня);
	Иначе
		Запрос.УстановитьПараметр("ИсключатьПродукциюТретьегоУровня", Ложь);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	КоличествоСопоставлено = Выборка.Количество();
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.НоменклатураДляВыбора) Тогда
		ТекущаяСтрока.НоменклатураДляВыбора.Очистить();
	Иначе
		ТекущаяСтрока.НоменклатураДляВыбора = Новый СписокЗначений;
	КонецЕсли;
	
	
	Пока Выборка.Следующий() Цикл
		Если КоличествоСопоставлено = 1 Тогда
			ТекущаяСтрока.Продукция = Выборка.Продукция;
		КонецЕсли;
		ТекущаяСтрока.НоменклатураДляВыбора.Добавить(Выборка.Продукция);
	КонецЦикла;
	
	Если КоличествоСопоставлено = 0 Тогда
		ТекущаяСтрока.Продукция = Неопределено;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ТогдаСопоставлениеТекст") Тогда 
		Если КоличествоСопоставлено > 1 Тогда
			ТекущаяСтрока.СопоставлениеТекст = СтрШаблон(НСтр("ru = '<Несколько позиций (%1)>'"), КоличествоСопоставлено);
		ИначеЕсли КоличествоСопоставлено = 1 Тогда
			ТекущаяСтрока.СопоставлениеТекст = "";
		Иначе
			ТекущаяСтрока.СопоставлениеТекст = НСтр("ru = '<Не сопоставлено>'");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьСериюРассчитатьСтатус(Объект, ТекущаяСтрока) Экспорт
	
	СерииИспользуются = ИнтеграцияИС.ПризнакИспользованияСерий(ТекущаяСтрока.Номенклатура);
	
	Если НЕ СерииИспользуются Тогда
		Возврат;
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) И ТекущаяСтрока.Номенклатура.ИспользоватьПартии Тогда
		
		Если ЗначениеЗаполнено(ТекущаяСтрока.Серия) И ТекущаяСтрока.Серия.Владелец = ТекущаяСтрока.Номенклатура Тогда
			
			ТекущаяСтрока.СтатусУказанияСерий = 1;
			
		Иначе
			
			ЗначенияПартииПоУмолчанию = НоменклатураВДокументахСервер.ЗначенияПартийНоменклатурыПоУмолчанию(ТекущаяСтрока.Номенклатура);
			
			ТекущаяСтрока.Серия = ?(ЗначениеЗаполнено(ЗначенияПартииПоУмолчанию), ЗначенияПартииПоУмолчанию, Справочники.ПартииНоменклатуры.ПустаяСсылка());
			ТекущаяСтрока.СтатусУказанияСерий = 1;
			
		КонецЕсли;
		
	Иначе
		
		ТекущаяСтрока.Серия = Справочники.ПартииНоменклатуры.ПустаяСсылка();
		ТекущаяСтрока.СтатусУказанияСерий = 0;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СерииНоменклатуры

Функция ПараметрыУказанияСерийСоответствиеНоменклатурыВЕТИС(Объект) Экспорт
	
	ПараметрыУказанияСерий = ПараметрыУказанияСерий();
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "РегистрСведений.СоответствиеНоменклатурыВЕТИС";
	ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	ПараметрыУказанияСерий.ТоварВШапке = Истина;
	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерий.ИмяТЧСерии = "";
	ПараметрыУказанияСерий.ИмяТЧТовары = "";
	ПараметрыУказанияСерий.ИмяПоляКоличество = Неопределено;
	ПараметрыУказанияСерий.ИмяПоляСклад = Неопределено;
	ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта = "ЭтаФорма";
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает параметры указания серий в документе 'ВходящаяТранспортнаяОперацияВЕТИС'.
//
// Возвращаемое значение:
//	Структура - Состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерийВходящаяТранспортнаяОперацияВЕТИС(Объект) Экспорт
	
	ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	
	Если ТипЗнч(Объект.ТорговыйОбъект) = Тип("СправочникСсылка.СтруктурныеЕдиницы") Тогда
		ИмяПоляСклад = "ТорговыйОбъект";
	Иначе
		ИмяПоляСклад = Неопределено;
	КонецЕсли;
	
	ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	УчитыватьСебестоимостьПоСериям = ИспользоватьСерииНоменклатуры;
	
	ПараметрыУказанияСерийТовары = ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерийТовары.ПолноеИмяОбъекта = "Документ.ВходящаяТранспортнаяОперацияВЕТИС";
	ПараметрыУказанияСерийТовары.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерийТовары.УчитыватьСебестоимостьПоСериям = УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерийТовары.ИменаПолейДополнительные.Добавить("ЕстьУточнения");
	
	ПараметрыУказанияСерийТовары.ИмяТЧСерии   = "Товары";
	ПараметрыУказанияСерийТовары.ИмяПоляСклад = ИмяПоляСклад;
	ПараметрыУказанияСерийТовары.Дата         = Объект.Дата;
	
	
	ПараметрыУказанияСерийТоварыУточнение = ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерийТоварыУточнение.ПолноеИмяОбъекта = "Документ.ВходящаяТранспортнаяОперацияВЕТИС";
	ПараметрыУказанияСерийТоварыУточнение.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерийТоварыУточнение.УчитыватьСебестоимостьПоСериям = УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерийТоварыУточнение.ИмяТЧТовары   = "ТоварыУточнение";
	ПараметрыУказанияСерийТоварыУточнение.ИмяТЧСерии   = "ТоварыУточнение";
	ПараметрыУказанияСерийТоварыУточнение.ИмяПоляСклад = ИмяПоляСклад;
	ПараметрыУказанияСерийТоварыУточнение.Дата         = Объект.Дата;
	
	ПараметрыУказанияСерий = Новый Структура;
	ПараметрыУказанияСерий.Вставить("Товары", ПараметрыУказанияСерийТовары); 
	ПараметрыУказанияСерий.Вставить("ТоварыУточнение", ПараметрыУказанияСерийТоварыУточнение); 
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает параметры указания серий в документе 'ИсходящаяТранспортнаяОперацияВЕТИС'.
//
// Возвращаемое значение:
//	Структура - Состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерийИсходящаяТранспортнаяОперацияВЕТИС(Объект) Экспорт
	
	ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	
	Если ТипЗнч(Объект.ТорговыйОбъект) = Тип("СправочникСсылка.СтруктурныеЕдиницы") Тогда
		ИмяПоляСклад = "ТорговыйОбъект";
	Иначе
		ИмяПоляСклад = Неопределено;
	КонецЕсли;
	
	ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	УчитыватьСебестоимостьПоСериям = ИспользоватьСерииНоменклатуры;
	
	ПараметрыУказанияСерийТовары = ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерийТовары.ПолноеИмяОбъекта = "Документ.ИсходящаяТранспортнаяОперацияВЕТИС";
	ПараметрыУказанияСерийТовары.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерийТовары.УчитыватьСебестоимостьПоСериям = УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерийТовары.ИменаПолейДополнительные.Добавить("ЕстьУточнения");
	
	ПараметрыУказанияСерийТовары.ИмяТЧСерии   = "Товары";
	ПараметрыУказанияСерийТовары.ИмяПоляСклад = ИмяПоляСклад;
	ПараметрыУказанияСерийТовары.Дата         = Объект.Дата;
	
	
	ПараметрыУказанияСерийТоварыУточнение = ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерийТоварыУточнение.ПолноеИмяОбъекта = "Документ.ИсходящаяТранспортнаяОперацияВЕТИС";
	ПараметрыУказанияСерийТоварыУточнение.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерийТоварыУточнение.УчитыватьСебестоимостьПоСериям = УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерийТоварыУточнение.ИмяТЧТовары   = "ТоварыУточнение";
	ПараметрыУказанияСерийТоварыУточнение.ИмяТЧСерии   = "ТоварыУточнение";
	ПараметрыУказанияСерийТоварыУточнение.ИмяПоляСклад = ИмяПоляСклад;
	ПараметрыУказанияСерийТоварыУточнение.Дата         = Объект.Дата;
	
	ПараметрыУказанияСерий = Новый Структура;
	ПараметрыУказанияСерий.Вставить("ИспользоватьСерииНоменклатуры", ИспользоватьСерииНоменклатуры);
	ПараметрыУказанияСерий.Вставить("Товары", ПараметрыУказанияСерийТовары); 
	ПараметрыУказанияСерий.Вставить("ТоварыУточнение", ПараметрыУказанияСерийТоварыУточнение); 
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает параметры указания серий в документе 'ПроизводственнаяОперацияВЕТИС'.
//
// Возвращаемое значение:
//	Структура - Состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерийПроизводственнаяОперацияВЕТИС(Объект) Экспорт
	
	ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	
	Если ТипЗнч(Объект.ТорговыйОбъект) = Тип("СправочникСсылка.СтруктурныеЕдиницы") Тогда
		ИмяПоляСклад = "ТорговыйОбъект";
	Иначе
		ИмяПоляСклад = Неопределено;
	КонецЕсли;
	
	ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	УчитыватьСебестоимостьПоСериям = ИспользоватьСерииНоменклатуры;
	
	ПараметрыУказанияСерийТовары = ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерийТовары.ПолноеИмяОбъекта = "Документ.ПроизводственнаяОперацияВЕТИС";
	ПараметрыУказанияСерийТовары.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерийТовары.УчитыватьСебестоимостьПоСериям = УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерийТовары.ИменаПолейДополнительные.Добавить("ЕстьУточнения");
	
	ПараметрыУказанияСерийТовары.ИмяТЧСерии   = "Товары";
	ПараметрыУказанияСерийТовары.ИмяПоляСклад = ИмяПоляСклад;
	ПараметрыУказанияСерийТовары.Дата         = Объект.Дата;
	
	
	ПараметрыУказанияСерийСырье = ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерийСырье.ПолноеИмяОбъекта = "Документ.ПроизводственнаяОперацияВЕТИС";
	ПараметрыУказанияСерийСырье.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерийСырье.УчитыватьСебестоимостьПоСериям = УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерийСырье.ИмяТЧТовары   = "Сырье";
	ПараметрыУказанияСерийСырье.ИмяТЧСерии   = "Сырье";
	ПараметрыУказанияСерийСырье.ИмяПоляСклад = ИмяПоляСклад;
	ПараметрыУказанияСерийСырье.Дата         = Объект.Дата;
	
	ПараметрыУказанияСерий = Новый Структура;
	ПараметрыУказанияСерий.Вставить("Товары", ПараметрыУказанияСерийТовары); 
	ПараметрыУказанияСерий.Вставить("Сырье", ПараметрыУказанияСерийСырье); 
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает параметры указания серий в документе 'ЗапросСкладскогоЖурналаВЕТИС'.
//
// Возвращаемое значение:
//	Структура - Состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерийЗапросСкладскогоЖурналаВЕТИС(Объект) Экспорт
	
	ПараметрыУказанияСерий = ПараметрыУказанияСерий();
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ЗапросСкладскогоЖурналаВЕТИС";
	
	ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	
	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерий.ИмяТЧСерии                     = "Товары";
	ПараметрыУказанияСерий.ИмяПоляСклад                   = Неопределено;
	ПараметрыУказанияСерий.Дата                           = Объект.Дата;
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает параметры указания серий в документе 'ВходящаяТранспортнаяОперацияВЕТИС'.
//
// Возвращаемое значение:
//	Структура - Состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерийИнвентаризацияПродукцииВЕТИС(Объект) Экспорт
	
	ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	
	Если ТипЗнч(Объект.ТорговыйОбъект) = Тип("СправочникСсылка.СтруктурныеЕдиницы") Тогда
		ИмяПоляСклад = "ТорговыйОбъект";
	Иначе
		ИмяПоляСклад = Неопределено;
	КонецЕсли;
	
	ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	УчитыватьСебестоимостьПоСериям = ИспользоватьСерииНоменклатуры;
	
	ПараметрыУказанияСерий = ПараметрыУказанияСерий();
	
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ИнвентаризацияПродукцииВЕТИС";
	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры  = ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям = УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерий.ИмяТЧСерии   = "Товары";
	ПараметрыУказанияСерий.ИмяПоляСклад = ИмяПоляСклад;
	ПараметрыУказанияСерий.Дата         = Объект.Дата;
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// ToDo:Убрать лишние параметры
// Структура параметров указания серий, возвращаемая процедурой модуля менеджера документа (обработки).
// Содержит свойства:
//
// ОБЯЗАТЕЛЬНЫЕ:
//	ИспользоватьСерииНоменклатуры - признак, нужно ли в документе заполнять статусы указания серий 
//	ПоляСвязиСерий - массив с именами реквизитов ТЧ Товары и ТЧ Серии, по которым устанавливается
//					 связь между табличными частями (поля связи "Номенклатура" и "Характеристика" 
//					 присутствуют всегда, их отдельно указывать не нужно)
//	СкладскиеОперации - массив значений ПеречислениеСсылка.СкладскиеОперации - складские операции, оформляемые документом
//	ПолноеИмяОбъекта - Строка - полное имя объекта. Например, Документ.РеализацияТоваровУслуг.
//	
//
// НЕОБЯЗАТЕЛЬНЫЕ:
//	ТолькоПросмотр - признак того, что серии в документе можно только просматривать (значение по умолчанию ЛОЖЬ)
//	ТоварВШапке - признак, что параметры указания серий определены для товара в шапке (иначе - для товара в ТЧ) (значение по умолчанию ЛОЖЬ)
//	БлокироватьДанныеФормы - признак того, что перед открытием форму указания серий, нужно заблокировать форму документа (значение по умолчанию ИСТИНА)
//								если ТолькоПросмотр = Истина, то данные формы не блокируются.
//
//	ИмяТЧТовары - имя табличной части со списком товаров (значение по умолчанию - "Товары")
//	ИмяТЧСерии - имя табличной части со списком серий (значение по умолчанию - "Серии")
//	ИмяПоляКоличество - имя поля в ТЧ "Товары", в котором пользователь редактирует количество (значение по умолчанию - "КоличествоУпаковок")
//	ИмяПоляСклад     - имя реквизита склада (значение по умолчанию - "Склад")
//	ИмяПоляПомещение - имя реквизита помещения, если не задано, значит в документе нет помещений
//	ИмяПоляДокументаРаспоряжения - Строка - если серии указываются в расходном ордере, то в этом параметре записывается имя поля распоряжения на отгрузку.
//											если серии указываются в накладной на поступление, то в этом параметре записывается имя поле распоряжения на 
//												поступление.
//											Значение поля используются для отображения остатков в формах.
//
//	ЭтоОрдер - признак того, что документ является ордером (значение по умолчанию ЛОЖЬ)
//	ЭтоЗаказ - признак того, что документ является заказом (значение по умолчанию ЛОЖЬ)
//	ЭтоНакладная - признак того, что документ является накладной (значение по умолчанию ЛОЖЬ).
//
//	ТолькоСерииДляСебестоимости - нужно указывать только серии, по которым ведется учет себестоимости (значение по умолчанию ЛОЖЬ)
//	ПланированиеОтгрузки - использование параметра политики указания серий "УказыватьПриПланированииОтгрузки" (значение по умолчанию ЛОЖЬ)
//	ПланированиеОтбора    - использование параметра политики указания серий "УказыватьПриПланированииОтбора" (значение по умолчанию ЛОЖЬ)
//	ПроверкаОтбора       - на адресном складе перед проверкой должны быть заполнены все серии, по которым ведется учет остатков
//	ФактОтбора - использование параметра политики указания серий "УказыватьПоФактуОтбора" (значение по умолчанию ЛОЖЬ)
//	ПодготовкаОрдера - параметр указывает, что ордер находится в статусе, когда происходит подготовка ордера и указание серий не обязательна (значение по умолчанию ЛОЖЬ)
//	ИменаПолейСтатусУказанияСерий - Массив - если в объекте несколько полей со статусом указания серий, то нужно добавить их имена в этот массив (значение по умолчанию пустой массив)
//	ИменаПолейДляОпределенияРаспоряжения - Массив - имена полей для определение распоряжения, по которому отображаются остатки в форме подбора серий
//													имена полей табличной части указываются в формате Товары_ДокументРезерваСерий (значение по умолчанию пустой массив)
//	ИспользоватьАдресноеХранение - Булево -  на складе, по которому оформлен документ, используется адресное хранение (значение по умолчанию ЛОЖЬ)
//	ИмяИсточникаЗначенийВФормеОбъекта - Строка - значение по умолчанию "Объект", если данные хранятся в реквизитах формы, то нужно указать "ЭтоФорма"
//	ОтборПроверяемыхСтрок
//	ТолькоСерииСУчетомОстатков - Булево - необходимо указывать серии только тогда, когда по ним ведется учет остатков. (значение по умолчанию - ЛОЖЬ)
//	ОсобеннаяПроверкаСтатусовУказанияСерий - Булево - признак, что в модуле менеджера объявлена процедура ТекстЗапросаПроверкиЗаполненияСерий(ПараметрыУказанияСерий)(значение по умолчанию - ЛОЖЬ)
//	ПараметрыЗапроса - Структура - содержит параметры запроса, используемые в функции ТекстЗапросаЗаполненияСтатусовУказанияСерий.
//	СерииПриПланированииОтгрузкиУказываютсяВТЧСерии - Булево - значение по умолчанию - ЛОЖЬ.
//
// Возвращаемое значение:
//	Структура.
//
Функция ПараметрыУказанияСерий() Экспорт
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ИспользоватьСерииНоменклатуры",Ложь);
	СтруктураПараметров.Вставить("УчитыватьСебестоимостьПоСериям",Ложь);
	СтруктураПараметров.Вставить("СкладскиеОперации",Новый Массив); 
	СтруктураПараметров.Вставить("ПоляСвязи", Новый Массив);
	СтруктураПараметров.Вставить("ПолноеИмяОбъекта", "");
	
	СтруктураПараметров.Вставить("ТолькоПросмотр",Ложь);
	СтруктураПараметров.Вставить("ТоварВШапке",Ложь);
	СтруктураПараметров.Вставить("БлокироватьДанныеФормы",Истина);
	СтруктураПараметров.Вставить("ИмяТЧТовары","Товары");
	СтруктураПараметров.Вставить("ИмяТЧСерии","Серии");
	СтруктураПараметров.Вставить("ИмяПоляКоличество","Количество");
	СтруктураПараметров.Вставить("ИмяПоляСклад","Склад");
	СтруктураПараметров.Вставить("ИмяПоляСкладОтправитель",Неопределено);
	СтруктураПараметров.Вставить("ИмяПоляСкладПолучатель",Неопределено);
	СтруктураПараметров.Вставить("ИмяПоляПомещение",Неопределено);
	СтруктураПараметров.Вставить("ЭтоОрдер",Ложь);
	СтруктураПараметров.Вставить("ЭтоЗаказ",Ложь);
	СтруктураПараметров.Вставить("ЭтоНакладная",Ложь);
	СтруктураПараметров.Вставить("ТолькоСерииДляСебестоимости",Ложь);
	СтруктураПараметров.Вставить("ПланированиеОтгрузки",Ложь);
	СтруктураПараметров.Вставить("ПланированиеОтбора",Ложь);
	СтруктураПараметров.Вставить("ПроверкаОтбора",Ложь);
	СтруктураПараметров.Вставить("ФактОтбора",Ложь);
	СтруктураПараметров.Вставить("ПодготовкаОрдера",Ложь);
	СтруктураПараметров.Вставить("РегистрироватьСерии", Истина);
	СтруктураПараметров.Вставить("Дата",Дата(1,1,1));
	СтруктураПараметров.Вставить("ИменаПолейСтатусУказанияСерий",Новый Массив);
	СтруктураПараметров.Вставить("ИменаПолейДляОпределенияРаспоряжения",Новый Массив);
	СтруктураПараметров.Вставить("ИменаПолейДополнительные",Новый Массив);
	СтруктураПараметров.Вставить("ИспользоватьАдресноеХранение",Ложь);
	СтруктураПараметров.Вставить("ИмяИсточникаЗначенийВФормеОбъекта","Объект");
	СтруктураПараметров.Вставить("ОтборПроверяемыхСтрок", Неопределено);
	СтруктураПараметров.Вставить("ТолькоСерииСУчетомОстатков", Ложь);
	СтруктураПараметров.Вставить("ОсобеннаяПроверкаСтатусовУказанияСерий", Ложь);
	СтруктураПараметров.Вставить("НужноОкруглятьКоличество", Истина);
	СтруктураПараметров.Вставить("ПараметрыЗапроса", Новый Структура);
	СтруктураПараметров.Вставить("СерииПриПланированииОтгрузкиУказываютсяВТЧСерии", Ложь);
	СтруктураПараметров.Вставить("ИспользуютсяТоварныеМеста", Ложь);
	СтруктураПараметров.Вставить("СерииМогутУказыватьсяВТаблицеУточнений", Ложь);
	
	СтруктураПараметров.Вставить("ОперацияДокумента", Неопределено);
	
	Возврат СтруктураПараметров;
	
КонецФункции

Функция ЗначенияРеквизитовДляЗаполненияПараметровУказанияСерий(Объект, ИменаРеквизитов) Экспорт
	
	Если Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Объект)) Тогда
		Структура = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект, ИменаРеквизитов);
	Иначе
		Структура = Новый Структура(ИменаРеквизитов);
		ЗаполнитьЗначенияСвойств(Структура, Объект);
	КонецЕсли;
	Если Структура.Свойство("Дата") И НЕ ЗначениеЗаполнено(Структура.Дата) Тогда
		Структура.Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	Если Структура.Свойство("ДатаОтгрузки") И НЕ ЗначениеЗаполнено(Структура.ДатаОтгрузки) Тогда
		Структура.ДатаОтгрузки = ТекущаяДатаСеанса();
	КонецЕсли;
	Возврат Структура;
	
КонецФункции

#КонецОбласти

#Область ПересчетКоличества

// Возвращает сведения о коэффициенте пересчета единицы измерения ВЕТИС.
//
// Параметры:
//	ЕдиницаИзмеренияВЕТИС	- СправочникСсылка.ЕдиницыИзмеренияВЕТИС	- Единица измерения ВЕТИС, коэффициент которой нужно 
//																		получить.
//	Номенклатура			- СправочникСсылка.Номенклатура				- Номенклатура для единицы хранения, которой осуществляется 
//																		получение коэффициента пересчета.
//	КэшированныеЗначения	- Структура									- Сохраненные значения параметров, используемых при обработке 
//																		строки таблицы.
//
// Возвращаемое значение:
//	Структура - см. описание модуля менеджера УпаковкиЕдиницы.КоэффициентЕдиницыИзмеренияПоВЕТИС.
//
Функция ДанныеЕдиницыИзмеренияВЕТИС(ЕдиницаИзмеренияВЕТИС, Номенклатура, КэшированныеЗначения) Экспорт
	
	ДанныеЕдиницыИзмеренияВЕТИС = ИнтеграцияВЕТИСУНФ.КоэффициентЕдиницыИзмеренияПоВЕТИС(ЕдиницаИзмеренияВЕТИС, Номенклатура);
	
	Если ДанныеЕдиницыИзмеренияВЕТИС.КэшироватьДанные Тогда
		
		КлючКоэффициента = ИнтеграцияВЕТИСУНФКлиентСервер.КлючКэшаУпаковки(Номенклатура, ЕдиницаИзмеренияВЕТИС);
		КэшированныеЗначения.КоэффициентыУпаковок.Вставить(КлючКоэффициента, ДанныеЕдиницыИзмеренияВЕТИС);
		
	КонецЕсли;
	
	Возврат ДанныеЕдиницыИзмеренияВЕТИС;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция ПолучитьДанныеХозяйствующегоСубъектаВЕТИС(Субъект) Экспорт
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Субъект, "СоответствуетОрганизации, Контрагент");
	
КонецФункции

Функция ХозяйствующийСубъектПоОрганизации(Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Субъект.Ссылка КАК ХозяйствующийСубъект
	|ИЗ
	|	Справочник.ХозяйствующиеСубъектыВЕТИС КАК Субъект
	|ГДЕ
	|	Субъект.Контрагент = &Организация
	|	И НЕ Субъект.Ссылка.ПометкаУдаления";
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 Тогда 
		Выборка.Следующий();
		Возврат Выборка.ХозяйствующийСубъект;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Неопределено;
	
КонецФункции

Функция НаименованиеОрганизацииПоУмолчанию() Экспорт
	
	Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	
	Если Организация.Пустая() Тогда
		
		Возврат НСтр("ru = 'ООО ""Кухни Ассоль""'");
		
	Иначе
		
		Возврат Организация.НаименованиеПолное;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти 