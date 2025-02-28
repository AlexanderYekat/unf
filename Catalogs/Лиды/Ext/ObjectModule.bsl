﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;

	ДозаполнитьПоУмолчанию();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		ДатаСоздания = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ЗаполнитьНомерТелефона();
	ЗаполнитьАдресЭП();
	СформироватьОсновныеСведенияЛида();
	
	СостоянияЛидов.ПередЗаписьюЛида(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовыйЛид", ЭтоНовый());
	ДополнительныеСвойства.Вставить("СостояниеЛидаПередЗаписью", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "СостояниеЛида"));
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	СостоянияЛидов.ПриЗаписиЛида(ЭтотОбъект);
	Если ДополнительныеСвойства.Свойство("НеЗаписыватьДанныеВРегистр") Тогда
		Возврат;
	ИначеЕсли ДополнительныеСвойства.Свойство("КанбанЛидов") Тогда
		РегистрыСведений.КанбанЛидов.ПереместитьЛид(ДополнительныеСвойства.КанбанЛидов.СостояниеЛида, Ссылка.СостояниеЛида, Ссылка, ДополнительныеСвойства.КанбанЛидов.Порядок);
	ИначеЕсли ДополнительныеСвойства.ЭтоНовыйЛид Тогда
		РегистрыСведений.КанбанЛидов.ДобавитьЛидВКонец(СостояниеЛида, Ссылка);
	ИначеЕсли ДополнительныеСвойства.СостояниеЛидаПередЗаписью <> СостояниеЛида Тогда
		РегистрыСведений.КанбанЛидов.ПереместитьЛид(ДополнительныеСвойства.СостояниеЛидаПередЗаписью, СостояниеЛида, Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	СостояниеДоКопирования = СостояниеЛида;
	СостояниеЛида = ЗаполнениеОбъектовУНФ.ПолучитьСостояниеЛида();
	
	Если НЕ СостояниеДоКопирования = Справочники.СостоянияЛидов.Завершен Тогда
		Возврат;
	КонецЕсли;
	
	ПричинаНеуспешногоЗавершенияРаботы = Неопределено;
	ВариантЗавершения = Неопределено;
	ДатаЗавершенияРаботы = Дата('00010101');
	ЗаметкиЗавершенияРаботы = Неопределено;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не Справочники.ГруппыДоступаЛидов.ИспользуютсяГруппыДоступа() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ГруппаДоступа");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ВариантЗавершения) 
		ИЛИ ВариантЗавершения = Перечисления.ВариантЗавершенияРаботыСЛидом.ПереведенВПокупателя Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПричинаНеуспешногоЗавершенияРаботы");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.ТекущиеВходящиеЗвонки.ПередУдалениемКонтакта(Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДозаполнитьПоУмолчанию()
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнойОтветственный");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СостояниеЛида) Тогда
		СостояниеЛида = ЗаполнениеОбъектовУНФ.ПолучитьСостояниеЛида();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ГруппаДоступа) Тогда
		ГруппаДоступа = Справочники.ГруппыДоступаЛидов.ГруппаДоступаПоУмолчанию();
	КонецЕсли;

КонецПроцедуры

Процедура СформироватьОсновныеСведенияЛида() Экспорт
	
	МассивСтрок = Новый Массив;
	
	Если Не ПустаяСтрока(Наименование) Тогда
		МассивСтрок.Добавить(Наименование);
	КонецЕсли;
	
	Если Не ПустаяСтрока(НаименованиеКомпании) Тогда
		МассивСтрок.Добавить(НаименованиеКомпании);
	КонецЕсли;

	КИ = КонтактнаяИнформация.Выгрузить();
	КИ.Сортировать("Вид");
	Для Каждого СтрокаКИ Из КИ Цикл
		Если ПустаяСтрока(СтрокаКИ.Представление) Тогда
			Продолжить;
		КонецЕсли;
		МассивСтрок.Добавить(СтрокаКИ.Представление);
	КонецЦикла;

	Если ДополнительныеСвойства.Свойство("ОсновныеСведенияКонтактныхЛиц") Тогда
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивСтрок, ДополнительныеСвойства.ОсновныеСведенияКонтактныхЛиц);
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КонтактыЛида.Наименование КАК Наименование,
		|	КонтактыЛида.КонтактнаяИнформация.(
		|		Представление КАК Представление,
		|		Вид КАК ВидКИ
		|	) КАК КонтактнаяИнформация
		|ИЗ
		|	Справочник.КонтактыЛидов КАК КонтактыЛида
		|ГДЕ
		|	КонтактыЛида.ПометкаУдаления = ЛОЖЬ
		|	И КонтактыЛида.Владелец = &Лид
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование,
		|	ВидКИ";
		
		Запрос.УстановитьПараметр("Лид", Ссылка);
		
		ВыборкаКЛ = Запрос.Выполнить().Выбрать();
		Пока ВыборкаКЛ.Следующий() Цикл
			
			Если МассивСтрок.Количество() > 0 Тогда
				МассивСтрок.Добавить(Символы.ПС);
			КонецЕсли;
			МассивСтрок.Добавить(ВыборкаКЛ.Наименование);
			
			ВыборкаКИ = ВыборкаКЛ.КонтактнаяИнформация.Выбрать();
			Пока ВыборкаКИ.Следующий() Цикл
				Если ПустаяСтрока(ВыборкаКИ.Представление) Тогда
					Продолжить;
				КонецЕсли;
				МассивСтрок.Добавить(ВыборкаКИ.Представление);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(Комментарий) Тогда
		МассивСтрок.Добавить(Комментарий);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ответственный) Тогда
		МассивСтрок.Добавить(Ответственный);
	КонецЕсли;
	
	ОсновныеСведения = СтрСоединить(МассивСтрок, Символы.ПС);
	
КонецПроцедуры

// Процедура заполняет вспомогательный реквизит "НомерТелефона"
//
Процедура ЗаполнитьНомерТелефона() Экспорт
	
	НомераТелефонов = Новый Массив;
	
	Для Каждого СтрокаКИ Из КонтактнаяИнформация Цикл
		Если СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
			НомераТелефонов.Добавить(СтрокаКИ.НомерТелефона);
		КонецЕсли;
	КонецЦикла;
	
	Если ДополнительныеСвойства.Свойство("НомераТелефоновКонтактаЛида") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НомераТелефонов, ДополнительныеСвойства.НомераТелефоновКонтактаЛида);
	КонецЕсли;

	НомерТелефонаДляПоиска = СтрСоединить(НомераТелефонов, ", ");
	
КонецПроцедуры

// Процедура заполняет вспомогательный реквизит "АдресЭП"
//
Процедура ЗаполнитьАдресЭП() Экспорт
	
	АдресаЭП = Новый Массив;
	
	Для Каждого СтрокаКИ Из КонтактнаяИнформация Цикл
		Если СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
			АдресаЭП.Добавить(СтрокаКИ.Представление);
		КонецЕсли;
	КонецЦикла;
	
	Если ДополнительныеСвойства.Свойство("АдресаЭПКонтактовЛида") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(АдресаЭП, ДополнительныеСвойства.АдресаЭПКонтактовЛида);
	КонецЕсли;
	
	АдресЭПДляПоиска = СтрСоединить(АдресаЭП, ", ");
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли