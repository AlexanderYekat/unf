﻿#Область СлужебныйПрограммныйИнтерфейс

// Возвращает основной режим выполнения обработчиков обновления Зарплатно-кадровой библиотеки.
//
// Возвращаемое значение:
//   Строка - "Монопольно" или "Отложенно".
//
Функция ОсновнойРежимВыполненияОбновления() Экспорт
	РежимОбновления = "Монопольно";
	ЗарплатаКадрыПереопределяемый.УстановитьОсновнойРежимВыполненияОбновления(РежимОбновления);
	Возврат РежимОбновления;
КонецФункции

// Добавляет обработчик обновления который будет выполняться при переходе с конфигурации с другим именем.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - Передается "как есть" из одноименного параметра вызывающей процедуры.
//   ИмяПроцедуры    - Строка - Имя вызываемой процедуры. Процедура будет вызвана без параметров.
//   ОбщиеДанные     - Булево - Истина, если изменяемые процедурой данные неразделенные. Ложь - если разделенные.
//   ПереходСБазовых - Булево - Истина, если требуется выполнять при переходе с базовых конфигураций.
//   ПереходСПроф    - Булево - Истина, если требуется выполнять при переходе с обычных конфигураций.
//
Процедура ДобавитьОбработчикПерехода(Обработчики, ИмяПроцедуры, ОбщиеДанные, ПереходСБазовых = Истина, ПереходСПроф = Истина) Экспорт
	
	Фильтр = Новый Структура("Процедура, ОбщиеДанные", ИмяПроцедуры, ОбщиеДанные);
	ДобавленныеИмена = КоллекцииБЗК.УникальныеЗначенияКолонкиСФильтром(Обработчики, Фильтр, "ПредыдущееИмяКонфигурации");
	
	Если ДобавленныеИмена.Найти("*") <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПереходСБазовых И ПереходСПроф Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Процедура                 = ИмяПроцедуры;
		Обработчик.ОбщиеДанные               = ОбщиеДанные;
		Обработчик.ПредыдущееИмяКонфигурации = "*";
		
	Иначе
		
		Если ПереходСБазовых Тогда
			ИменаКонфигураций = ИменаБазовыхКонфигураций();
			Для Каждого ИмяКонфигурации Из ИменаКонфигураций Цикл
				Если ДобавленныеИмена.Найти(ИмяКонфигурации) = Неопределено Тогда
					Обработчик = Обработчики.Добавить();
					Обработчик.Процедура                 = ИмяПроцедуры;
					Обработчик.ОбщиеДанные               = ОбщиеДанные;
					Обработчик.ПредыдущееИмяКонфигурации = ИмяКонфигурации;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ПереходСПроф Тогда
			ИменаКонфигураций = ИменаКонфигурацийПроф();
			Для Каждого ИмяКонфигурации Из ИменаКонфигураций Цикл
				Если ДобавленныеИмена.Найти(ИмяКонфигурации) = Неопределено Тогда
					Обработчик = Обработчики.Добавить();
					Обработчик.Процедура                 = ИмяПроцедуры;
					Обработчик.ОбщиеДанные               = ОбщиеДанные;
					Обработчик.ПредыдущееИмяКонфигурации = ИмяКонфигурации;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает массив строк - имена базовых конфигураций для зарплатных обработчиков обновления.
Функция ИменаБазовыхКонфигураций() Экспорт
	Результат = Новый Массив;
	Результат.Добавить("ЗарплатаИУправлениеПерсоналомБазовая");
	Результат.Добавить("ЗарплатаИКадрыГосударственногоУчрежденияБазовая");
	Возврат Результат;
КонецФункции

// Возвращает массив строк - имена Проф конфигураций для зарплатных обработчиков обновления.
Функция ИменаКонфигурацийПроф() Экспорт
	Результат = Новый Массив;
	Результат.Добавить("БЗКР");
	Результат.Добавить("ЗарплатаИУправлениеПерсоналом");
	Результат.Добавить("ЗарплатаИКадрыГосударственногоУчреждения");
	Возврат Результат;
КонецФункции

#КонецОбласти
