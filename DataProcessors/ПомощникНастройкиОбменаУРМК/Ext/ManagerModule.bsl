﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

Процедура ПодготовитьДанныеНастроекОбмена(Параметры, АдресРезультата) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("НастройкиПодготовлены", Ложь);
	
	РасширенныйРежим = ИнтеграцияУРМКСлужебный.ИспользоватьРасширенныйРежимНастройкиУРМК();
	
	Запрос = Новый Запрос;
	ТекстЗапроса = "
		|ВЫБРАТЬ
		|	УРМККассыККМ.Ссылка КАК УРМК,
		|	УРМККассыККМ.КассаККМ КАК КассаККМ,
		|	ВЫБОР
		|		КОГДА НЕ ОбменСУРМК.Код ЕСТЬ NULL
		|			ТОГДА ИСТИНА
		|	КОНЕЦ КАК УзелНастроен
		|ПОМЕСТИТЬ втУРМККассыККМ
		|ИЗ
		|	Справочник.УниверсальныеРабочиеМестаКассиров.КассыККМ КАК УРМККассыККМ
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланОбмена.ОбменСУРМК КАК ОбменСУРМК
		|		ПО (УРМККассыККМ.Ссылка = ОбменСУРМК.УРМК)
		|ГДЕ
		|	НЕ УРМККассыККМ.Ссылка.ПометкаУдаления
		|	И УРМККассыККМ.Ссылка.ТорговыйОбъект = &ТорговыйОбъект
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОбменСУРМККассыККМ.КассаККМ КАК КассаККМ
		|ПОМЕСТИТЬ втКассыККМОбменСУРМК
		|ИЗ
		|	ПланОбмена.ОбменСУРМК.КассыККМ КАК ОбменСУРМККассыККМ
		|ГДЕ
		|	НЕ ОбменСУРМККассыККМ.Ссылка.ЭтотУзел
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
		|	КассыККМ.Ссылка КАК КассаККМ,
		|	[Организация]
		|	втУРМККассыККМ.УРМК КАК УРМК
		|ИЗ
		|	[КассаККМУРМК] КАК КассыККМ
		|		ЛЕВОЕ СОЕДИНЕНИЕ втУРМККассыККМ КАК втУРМККассыККМ
		|		ПО (втУРМККассыККМ.КассаККМ = КассыККМ.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ втКассыККМОбменСУРМК КАК втКассыККМОбменСУРМК
		|		ПО (втКассыККМОбменСУРМК.КассаККМ = КассыККМ.Ссылка)
		|ГДЕ
		|	НЕ КассыККМ.ПометкаУдаления
		|	[ПереопределяемыеОтборы]
		|	И [ТорговыйОбъект] = &ТорговыйОбъект
		|	И втКассыККМОбменСУРМК.КассаККМ ЕСТЬ NULL
		|	И втУРМККассыККМ.УзелНастроен ЕСТЬ NULL
		|	[РасширенныйРежим]
		|";

	МетаданныеКассыККМ = ИнтеграцияУРМКСлужебный.МетаданныеПоОпределяемомуТипу("КассаККМУРМК");
	
	ПустаяСсылкаКассаККМ = Метаданные.ОпределяемыеТипы.КассаККМУРМК.Тип.ПривестиЗначение();
	ПустаяСсылкаТорговыйОбъект = Метаданные.ОпределяемыеТипы.ТорговыйОбъектУРМК.Тип.ПривестиЗначение();
	
	ТорговыйОбъектТипРеквизитаСтрокой = ОбщегоНазначения.СтроковоеПредставлениеТипа(ТипЗнч(ПустаяСсылкаТорговыйОбъект));
	ИмяРеквизитаТорговыйОбъект = ИнтеграцияУРМКСлужебный.ИменаРеквизитовПоТипу(ПустаяСсылкаКассаККМ, Тип(ТорговыйОбъектТипРеквизитаСтрокой), "Подразделение");
	
	ПустаяСсылкаОрганизация = Метаданные.ОпределяемыеТипы.ОрганизацияУРМК.Тип.ПривестиЗначение();
	ОрганизацияТипРеквизитаСтрокой = ОбщегоНазначения.СтроковоеПредставлениеТипа(ТипЗнч(ПустаяСсылкаОрганизация));
	ИмяРеквизитаОрганизация = ИнтеграцияУРМКСлужебный.ИменаРеквизитовПоТипу(ПустаяСсылкаКассаККМ, Тип(ОрганизацияТипРеквизитаСтрокой));

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[КассаККМУРМК]", МетаданныеКассыККМ.ПолноеИмя());
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ТорговыйОбъект]",
		?(ИмяРеквизитаТорговыйОбъект = "","", "КассыККМ." + ИмяРеквизитаТорговыйОбъект));
		
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[Организация]",
		?(ИмяРеквизитаОрганизация = "","", "КассыККМ." +ИмяРеквизитаОрганизация+ " КАК Организация,"));

	ПереопределяемыеОтборы = ИнтеграцияУРМКПереопределяемый.ОтборыТекстаЗапросовПодготовитьДанныеНастроекОбмена();	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПереопределяемыеОтборы]", ?(ПереопределяемыеОтборы = "","", ПереопределяемыеОтборы));
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[РасширенныйРежим]", ?(РасширенныйРежим, "И НЕ втУРМККассыККМ.УРМК ЕСТЬ NULL", ""));
		
	Запрос.УстановитьПараметр("ТорговыйОбъект", Параметры.ТорговыйОбъект);
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.УРМК) Тогда
			УРМК = Выборка.УРМК;
		Иначе
			УРМКОбъект = Справочники.УниверсальныеРабочиеМестаКассиров.СоздатьЭлемент();
			
			Наименование = НСтр("ru = 'РМК (%1)'");
			УРМКОбъект.Наименование = СтрШаблон(Наименование, Выборка.КассаККМ.Наименование);
			
			ЗаполнитьЗначенияСвойств(УРМКОбъект, Параметры);
			
			НоваяСтрока = УРМКОбъект.КассыККМ.Добавить();
			НоваяСтрока.КассаККМ = Выборка.КассаККМ;
			
			Попытка
				УРМКОбъект.Записать();
				УРМК = УРМКОбъект.Ссылка;
			Исключение
				УРМК = Справочники.УниверсальныеРабочиеМестаКассиров.ПустаяСсылка();
			КонецПопытки;
		КонецЕсли;

		Сч = 0;
		ПрефиксПриемника = "";
		ВсеСимвольныеПрефиксыЗаняты = Ложь;
		Пока Не ЗначениеЗаполнено(ПрефиксПриемника) Цикл
			Если Сч > 100 Тогда 
				ВсеСимвольныеПрефиксыЗаняты = Истина;
				Если Сч > 200 Тогда // Пора выходить из цикла
					Результат.Вставить("НумерацияЗакончилась");
					Прервать;
				КонецЕсли;
			КонецЕсли;				
			ГСЧ = Новый ГенераторСлучайныхЧисел(ТекущаяУниверсальнаяДатаВМиллисекундах());
			Для Проход = 1 По 2 Цикл
				СлучайныйСимвол = Символ(ГСЧ.СлучайноеЧисло(1040,1060));
				ПрефиксПриемника = ПрефиксПриемника + СлучайныйСимвол;
			КонецЦикла;
			Если ВсеСимвольныеПрефиксыЗаняты Тогда
				СлучайноеЧисло = ГСЧ.СлучайноеЧисло(0,9);
				ПрефиксПриемника = СтрЗаменить(ПрефиксПриемника, Прав(СокрЛП(ПрефиксПриемника), 1), СлучайноеЧисло);
			КонецЕсли;
			Если ЗначениеЗаполнено(ПланыОбмена.ОбменСУРМК.НайтиПоКоду(ПрефиксПриемника)) Тогда
				ПрефиксПриемника = "";
				Сч = Сч + 1;
			КонецЕсли;
		КонецЦикла;
			
		Параметры.Вставить("УРМК", УРМК);
		Параметры.Вставить("КассаККМ", Выборка.КассаККМ);
		Параметры.Вставить("Организация", Выборка.Организация);
		Параметры.Вставить("НаименованиеВторойБазы",  УРМК.Наименование);
		Параметры.Вставить("КодНовогоУзлаВторойБазы", ПрефиксПриемника);
		Параметры.Вставить("КодУзлаКорреспондента",   ПрефиксПриемника);
		Параметры.Вставить("ПрефиксИнформационнойБазыПриемника", ПрефиксПриемника);
		
		Если ЗначениеЗаполнено(ПрефиксПриемника) Тогда
			
			Результат.Вставить("НастройкиПодготовлены", Истина);
			
			Если Параметры.ИспользоватьПараметрыТранспортаFILE Тогда
				
				КаталогНастроек = Параметры.FILEКаталогОбменаИнформацией;
				Параметры.FILEКаталогОбменаИнформацией = ПодкаталогПоПрефиксуПриемника(КаталогНастроек, ПрефиксПриемника, Результат);
				
			ИначеЕсли Параметры.ИспользоватьПараметрыТранспортаFTP Тогда
				
				КаталогНастроек = Параметры.КаталогНастроекПодключенияДляВыгрузки;
				Параметры.КаталогНастроекПодключенияДляВыгрузки = ПодкаталогПоПрефиксуПриемника(КаталогНастроек, ПрефиксПриемника, Результат);

			КонецЕсли;

		КонецЕсли;
		Результат.Вставить("НастройкиОбмена", Параметры);
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеДляНачальнойВыгрузки(Параметры, АдресРезультата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	МенеджерОбменаУРМКУНФ.РегистрацияИзмененийНачальнойВыгрузкиДанных(Параметры.УзелОбмена);
	
	УстановитьПризнакНачальнойВыгрузкиДанных(Параметры.УзелОбмена);
	
	Результат = Новый Структура;
	Результат.Вставить("ДанныеЗарегистрированы", Истина);
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ВыгрузитьДанные(Параметры, АдресРезультата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	УзелОбмена = Параметры.УзелОбмена;
	КаталогОбмена = Параметры.КаталогОбмена;
	ДействиеПриОбмене = Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
	
	КодОтправителя = СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПланыОбмена.ОбменСУРМК.ЭтотУзел(), "Код"));
	КодПолучателя  = СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УзелОбмена, "Код"));

	ИмяФайла = ИмяФайлаСообщенияОбмена(КодОтправителя, КодПолучателя);
	ИмяФайлаДляВыгрузки = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		КаталогОбмена, ИмяФайла + ".xml");
	
	ЗафиксироватьНачалоОбмена(УзелОбмена, ДействиеПриОбмене);
	
	Попытка
		ОбработкаКонвертацииXDTO = Обработки.КонвертацияОбъектовXDTO.Создать();
	
		ОбработкаКонвертацииXDTO.РежимОбмена = "Выгрузка";
		ОбработкаКонвертацииXDTO.УзелДляОбмена = УзелОбмена;
		ОбработкаКонвертацииXDTO.ИмяФайлаОбмена = ИмяФайлаДляВыгрузки;
		ОбработкаКонвертацииXDTO.КлючСообщенияЖурналаРегистрации = ИнтеграцияУРМКСлужебный.КлючСообщенияЖурналаРегистрации(УзелОбмена, ДействиеПриОбмене);
		
		ОбработкаКонвертацииXDTO.ВыполнитьВыгрузкуДанных();
		
		Если РезультатВыполненияОбменаВыполнено(ОбработкаКонвертацииXDTO.РезультатВыполненияОбмена()) Тогда
			
			Результат = Новый Структура;
			Результат.Вставить("ДанныеВыгружены", Истина);
			
			ПоместитьВоВременноеХранилище(Результат, АдресРезультата);

		Иначе
			ВызватьИсключение ОбработкаКонвертацииXDTO.СтрокаСообщенияОбОшибке();
		КонецЕсли;
		
		ЗафиксироватьЗавершениеОбмена(
			УзелОбмена,
			ДействиеПриОбмене,
			ОбработкаКонвертацииXDTO.РезультатВыполненияОбмена());
	Исключение
		ЗафиксироватьЗавершениеОбмена(
			УзелОбмена,
			ДействиеПриОбмене,
			Перечисления.РезультатыВыполненияОбмена.Ошибка);
		ВызватьИсключение;
	КонецПопытки;
		
КонецПроцедуры

#Область Печать

Функция СформироватьПечатнуюФормуКодыПодключения(ТаблицаНастройкиПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ПолеСправа  = 2;
	ТабличныйДокумент.ПолеСлева   = 2;
	
	МакетКодыПодключения = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПомощникНастройкиОбменаУРМК.КодыПодключения");
	ОбластьКодПодключения = МакетКодыПодключения.ПолучитьОбласть("Строка");
	
	ИдентификаторПользователяИБ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователи.ТекущийПользователь(), "ИдентификаторПользователяИБ");
	
	УстановитьПривилегированныйРежим(Истина);
	СвойстваПользователяИБ = Пользователи.СвойстваПользователяИБ(ИдентификаторПользователяИБ);
	УстановитьПривилегированныйРежим(Ложь);

	Для каждого СтрокаНастроекПечати Из ТаблицаНастройкиПечати Цикл
		ОбластьКодПодключения.Параметры.УРМК = СтрокаНастроекПечати.УРМК;
		ОбластьКодПодключения.Параметры.КодУзла = СтрокаНастроекПечати.КодУзла;
		ОбластьКодПодключения.Параметры.АдресПубликации = СтрокаНастроекПечати.АдресПубликации;
		
		РисунокШтрихкод = ОбластьКодПодключения.Рисунки.ШтрихкодПечать;
		
		ПараметрыКартинки = Новый Структура;
		ПараметрыКартинки.Вставить("Ширина", 175);
		ПараметрыКартинки.Вставить("Высота", 175);
		
		СтрокаДляКодирования = СтрокаНастроекПечати.АдресПубликации + ";"
			+ СтрокаНастроекПечати.КодУзла + ";"
			+ СвойстваПользователяИБ.Имя;

		РисунокШтрихкод.Картинка = ИнтеграцияУРМКСлужебный.ПолучитьКартинкуQRКода(
			ПараметрыКартинки,
			СтрокаДляКодирования);
		
		ТабличныйДокумент.Вывести(ОбластьКодПодключения);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПризнакНачальнойВыгрузкиДанных(Знач УзелИнформационнойБазы)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы", УзелИнформационнойБазы);
	СтруктураЗаписи.Вставить("НачальнаяВыгрузкаДанных", Истина);
	СтруктураЗаписи.Вставить("НомерОтправленногоНачальнаяВыгрузкаДанных",
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УзелИнформационнойБазы, "НомерОтправленного") + 1);
	
	ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "ОбщиеНастройкиУзловИнформационныхБаз");
	
КонецПроцедуры

Процедура ЗафиксироватьНачалоОбмена(УзелОбмена, ДействиеПриОбмене)
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы", УзелОбмена);
	СтруктураЗаписи.Вставить("ДействиеПриОбмене",      ДействиеПриОбмене);
	СтруктураЗаписи.Вставить("ДатаНачала",             ТекущаяДатаСеанса());
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияОбменовДаннымиОбластейДанных");
	Иначе
		ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияОбменовДанными");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗафиксироватьЗавершениеОбмена(УзелОбмена, ДействиеПриОбмене, РезультатВыполнения)
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("УзелИнформационнойБазы",    УзелОбмена);
	СтруктураЗаписи.Вставить("ДействиеПриОбмене",         ДействиеПриОбмене);
	СтруктураЗаписи.Вставить("ДатаОкончания",             ТекущаяДатаСеанса());
	СтруктураЗаписи.Вставить("РезультатВыполненияОбмена", РезультатВыполнения);
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияОбменовДаннымиОбластейДанных");
	Иначе
		ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияОбменовДанными");
	КонецЕсли;
	
	Если РезультатВыполненияОбменаВыполнено(РезультатВыполнения) Тогда

		Если ОбщегоНазначения.РазделениеВключено()
			И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
			ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияУспешныхОбменовДаннымиОбластейДанных");
		Иначе
			ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияУспешныхОбменовДанными");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, Знач ИмяРегистра)
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра]; // ОбъектМетаданныхРегистрСведений
	
	// Создаем менеджер записи регистра.
	МенеджерЗаписи = РегистрыСведений[ИмяРегистра].СоздатьМенеджерЗаписи();
	
	// Устанавливаем отбор по измерениям регистра.
	Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		
		ИмяИзмерения = Измерение.Имя;
		
		// Если задано значение в структуре, то отбор устанавливаем.
		Если СтруктураЗаписи.Свойство(ИмяИзмерения) Тогда
			
			МенеджерЗаписи[ИмяИзмерения] = СтруктураЗаписи[ИмяИзмерения];
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Считываем запись из базы данных.
	МенеджерЗаписи.Прочитать();
	
	// Заполняем значения свойств записи из переданной структуры.
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтруктураЗаписи);
	
	// записываем менеджер записи
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Процедура ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, Знач ИмяРегистра, Загрузка = Ложь)
	
	НаборЗаписей = СоздатьНаборЗаписейРегистраСведений(СтруктураЗаписи, ИмяРегистра);
	
	// Добавляем только одну запись в новый набор записей.
	НоваяЗапись = НаборЗаписей.Добавить();
	
	// Заполняем значения свойств записи из переданной структуры.
	ЗаполнитьЗначенияСвойств(НоваяЗапись, СтруктураЗаписи);
	
	НаборЗаписей.ОбменДанными.Загрузка = Загрузка;
	
	// записываем набор записей
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция СоздатьНаборЗаписейРегистраСведений(СтруктураЗаписи, ИмяРегистра)

	НаборЗаписей = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей(); // РегистрСведенийНаборЗаписей
	
	// Устанавливаем отбор по измерениям регистра.
	Для Каждого КлючЗначение Из СтруктураЗаписи Цикл		
		УстановитьЗначениеЭлементаОтбора(НаборЗаписей.Отбор, КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;
	
	Возврат НаборЗаписей;
	
КонецФункции

Процедура УстановитьЗначениеЭлементаОтбора(Отбор, КлючЭлемента, ЗначениеЭлемента)
	
	ЭлементОтбора = Отбор.Найти(КлючЭлемента);
	Если ЭлементОтбора <> Неопределено Тогда
		ЭлементОтбора.Установить(ЗначениеЭлемента);
	КонецЕсли;
	
КонецПроцедуры

Функция РезультатВыполненияОбменаВыполнено(РезультатВыполненияОбмена)
	
	Возврат РезультатВыполненияОбмена = Неопределено
		Или РезультатВыполненияОбмена = Перечисления.РезультатыВыполненияОбмена.Выполнено
		Или РезультатВыполненияОбмена = Перечисления.РезультатыВыполненияОбмена.ВыполненоСПредупреждениями;
	
КонецФункции

Функция ИмяФайлаСообщенияОбмена(КодУзлаОтправителя, КодУзлаПолучателя)
	
	ШаблонИмени = "[Префикс]_[УзелОтправитель]_[УзелПолучатель]";
	ШаблонИмени = СтрЗаменить(ШаблонИмени, "[Префикс]",         "Message");
	ШаблонИмени = СтрЗаменить(ШаблонИмени, "[УзелОтправитель]", КодУзлаОтправителя);
	ШаблонИмени = СтрЗаменить(ШаблонИмени, "[УзелПолучатель]",  КодУзлаПолучателя);
	
	Возврат ШаблонИмени;
	
КонецФункции

Функция ПодкаталогПоПрефиксуПриемника(КаталогНастроек, ПрефиксПриемника, Результат)
	
	Каталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогНастроек) + ПрефиксПриемника;
	
	СоздатьКаталог(Каталог);
	
	КаталогНаДиске = Новый Файл(Каталог);
    Если Не КаталогНаДиске.Существует() Тогда
		Результат.Вставить("НастройкиПодготовлены", Ложь);
		Результат.Вставить("ОшибкаСозданияКаталога");
	Иначе
		Возврат Каталог;
	КонецЕсли;

	Возврат "";
	
КонецФункции

#КонецОбласти


#КонецЕсли