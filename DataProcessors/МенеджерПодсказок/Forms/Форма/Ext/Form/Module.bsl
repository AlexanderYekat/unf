﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура УбратьГиперссылку(ТекущийЭлементСхемы)
	
	ТекущийЭлементСхемы.Гиперссылка = Ложь;
	ТекущийЭлементСхемы.Шрифт = Новый Шрифт(ТекущийЭлементСхемы.Шрифт,,,,, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ВызватьИсключение НСтр("ru = 'Не поддерживается в мобильном клиенте.'")
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = НСтр("ru = 'Подсказка: '") + Параметры.Заголовок;
	КонецЕсли;
	
	Если Параметры.Свойство("КлючПодсказки") Тогда
		Если СтрНайти(Параметры.КлючПодсказки, "ГрафическаяСхема") > 0 Тогда
			ГрафическаяСхема = Обработки.МенеджерПодсказок.ПолучитьМакет(Параметры.КлючПодсказки);
			Элементы.СтраницыПоТипамМакетов.ТекущаяСтраница = Элементы.СтраницаГрафическаяСхема;
			Элементы.ГруппаПодвал54ФЗ.Видимость = (Параметры.КлючПодсказки = "ГрафическаяСхема_Розница");
			
			Если Параметры.КлючПодсказки = "ГрафическаяСхема_РасчетыСКурьерскойКомпаниейИОплатаНаложеннымПлатежом"
				И НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ГрафикВыполненияЗаказов) Тогда
				ТекущийЭлементСхемы = ГрафическаяСхема.ЭлементыГрафическойСхемы.Найти("ДействиеЗаказПокупателя");
				Если ТекущийЭлементСхемы <> Неопределено Тогда
					УбратьГиперссылку(ТекущийЭлементСхемы);
				КонецЕсли;
				ТекущийЭлементСхемы = ГрафическаяСхема.ЭлементыГрафическойСхемы.Найти("ДействиеЗаказПокупателя2");
				Если ТекущийЭлементСхемы <> Неопределено Тогда
					УбратьГиперссылку(ТекущийЭлементСхемы);
				КонецЕсли;
			КонецЕсли;
		Иначе
			МакетПодсказки = Обработки.МенеджерПодсказок.ПолучитьМакет(Параметры.КлючПодсказки).ПолучитьТекст();
			Элементы.СтраницыПоТипамМакетов.ТекущаяСтраница = Элементы.СтраницаHTML;
			Элементы.ГруппаПодвал54ФЗ.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ИспользоватьПодключаемоеОборудование = ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудование");
	ИспользоватьДисконтныеКарты = ПолучитьФункциональнуюОпцию("ИспользоватьДисконтныеКарты");
	ИспользоватьСкидкиНаценки = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки") ИЛИ
		ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиНаценкиПродажи");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура МакетПодсказкиПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если СтрНайти(ДанныеСобытия.href, "unf://") <> 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		СтрокаИмяФормы = ДанныеСобытия.href;
		Если СтрНайти(ДанныеСобытия.href, "v8cfgHelp") <> 0 Тогда
			СтрокаИмяФормы = СтрЗаменить(СтрокаИмяФормы, "v8cfgHelp/v8config/", "");
		КонецЕсли;
		СтрокаИмяФормы = СтрЗаменить(СтрокаИмяФормы, "unf://", "");
		СтрокаИмяФормы = СтрЗаменить(СтрокаИмяФормы, "/", "");
		Попытка
			ОткрытьФорму(СтрокаИмяФормы);
		Исключение
		КонецПопытки;
		
	ИначеЕсли СтрНайти(ДанныеСобытия.href, "e1cib/") > 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		НавигационнаяСсылка = Сред(ДанныеСобытия.href, СтрНайти(ДанныеСобытия.href, "e1cib/"));
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылка);
		
	ИначеЕсли СтрНайти(ДанныеСобытия.href, "http") > 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ДанныеСобытия.href);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафическаяСхемаВыбор(Элемент)
	
	ЭлементСхемы = Элементы.ГрафическаяСхема.ТекущийЭлемент;
	
	Если ЭлементСхемы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяЭлемента = ЭлементСхемы.Имя;
	
	// Розница
	Если ИмяЭлемента = "ДействиеЧекККМ" ИЛИ
		ИмяЭлемента = "ДействиеЧекККМЗаказы" ИЛИ
		ИмяЭлемента = "ЧекККМНаВозвратЗаказы" ИЛИ
		ИмяЭлемента = "ЧекККМНаВозврат" Тогда
		
		ОткрытьФорму("ЖурналДокументов.ЧекиККМ.ФормаСписка");
		
	ИначеЕсли ИмяЭлемента = "ДействиеОтчетОРозничныхПродажах" ИЛИ
		
		ИмяЭлемента = "ДействиеОтчетОРозничныхПродажахЗаказы" ИЛИ
		ИмяЭлемента = "ДействиеОтчетОРозничныхПродажахАвтономноеРМ" Тогда
		ОткрытьФорму("Документ.ОтчетОРозничныхПродажах.ФормаСписка");
		
	ИначеЕсли ИмяЭлемента = "ДекорацияКассыККМ" Тогда
		
		ОткрытьФорму("Справочник.КассыККМ.ФормаСписка");
		
	ИначеЕсли ИмяЭлемента = "ДекорацияНастройки" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РазделПоУмолчанию", "Продажи");
		
		ОткрытьФорму("Обработка.НастройкаПрограммы.Форма",
			ПараметрыФормы,,,,,,);
		
	ИначеЕсли ИмяЭлемента = "ДекорацияВыемкаНаличных" ИЛИ 
		ИмяЭлемента = "ДекорацияВыемкаНаличныхЗаказ" Тогда
		
		ОткрытьФорму("Обработка.МенеджерПодсказок.Форма.ПросмотрКартинки", Новый Структура("ИмяКартинки", "Розница_ВыемкаНаличных"));
		
	ИначеЕсли ИмяЭлемента = "ДекорацияКакВключитьФО_ИспользоватьЗаказы" Тогда
		
		ОткрытьФорму("Обработка.МенеджерПодсказок.Форма.ПросмотрКартинки", Новый Структура("ИмяКартинки", "Розница_КакВключитьФО_ИспользоватьЗаказы"));
		
	ИначеЕсли ИмяЭлемента = "ДействиеПеремещениеДенегВКассуККМ" ИЛИ
		ИмяЭлемента = "ДействиеПеремещениеДенегВКассуККМЗаказы" Тогда
		
		ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "ПеремещениеВКассуККМ", Неопределено, "ДокументыПоКассе");
		
	ИначеЕсли ИмяЭлемента = "ДействиеВнесениеДенег" 
		ИЛИ ИмяЭлемента = "ДействиеВнесениеДенегЗаказ" Тогда
		
		ОткрытьФорму("Документ.РасходИзКассы.Форма.ФормаВнесенияНаличных");
		
	ИначеЕсли ИмяЭлемента = "ДействиеВыемкаНаличных" ИЛИ
		ИмяЭлемента = "ДействиеВыемкаНаличныхЗаказ" Тогда
		
		ОткрытьФорму("Документ.ВыемкаНаличных.ФормаСписка");
		
	ИначеЕсли ИмяЭлемента = "ДействиеРозничнаяВыручка" ИЛИ
		ИмяЭлемента = "ДействиеРозничнаяВыручкаЗаказы" Тогда
		
		ОткрытьФорму("Документ.ПоступлениеВКассу.ФормаСписка", Новый Структура("КПоступлению"));
		
	ИначеЕсли ИмяЭлемента = "ДействиеРозничнаяВыручкаАвтономноеРМ" Тогда
		
		ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "РозничнаяВыручка", Неопределено, "ДокументыПоКассе");
		
	ИначеЕсли ИмяЭлемента = "ДействиеИнвентаризация" ИЛИ
		ИмяЭлемента = "ДействиеИнвентаризацияСуммовойУчет" Тогда
		
		ОткрытьФорму("Документ.ИнвентаризацияЗапасов.ФормаОбъекта");
		
	ИначеЕсли ИмяЭлемента = "ДействиеЗаказПокупателя" ИЛИ
		ИмяЭлемента = "ДействиеЗаказПокупателя2" Тогда
		
		ОткрытьФорму("Документ.ЗаказПокупателя.ФормаСписка");
		
	ИначеЕсли ИмяЭлемента = "СправочникПодключаемоеОборудование" Тогда
		
		Если ИспользоватьПодключаемоеОборудование Тогда
			ОткрытьФорму("Справочник.ПодключаемоеОборудование.ФормаСписка");
		Иначе
			ОповещениеПослеОтветаНаВопрос = Новый ОписаниеОповещения("ОбработкаОтветаНаВопросОНастройкеПодключаемогоОборудования", ЭтотОбъект);
			ПоказатьВопрос(ОповещениеПослеОтветаНаВопрос, НСтр("ru = 'Необходимо предварительно включить опцию ""Подключаемое оборудование"". Перейти к настройкам опций?'"), РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
		
	ИначеЕсли ИмяЭлемента = "ДействиеПеремещениеЗапасовАвтономноеРМ" ИЛИ
		
		ИмяЭлемента = "ДействиеПеремещениеЗапасовСуммовойУчет" Тогда
		ОткрытьФорму("Документ.ПеремещениеЗапасов.ФормаСписка");
		
	ИначеЕсли ИмяЭлемента = "ДействиеПриемРозничнойВыручкиСуммовойУчет" Тогда
		
		ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "РозничнаяВыручкаСуммовойУчет", Неопределено, "ДокументыПоКассе");
		
	ИначеЕсли ИмяЭлемента = "ДействиеПереоценкаСуммовойУчет" Тогда
		
		ОткрытьФорму("Документ.ПереоценкаВРозницеСуммовойУчет.ФормаОбъекта");
		
	ИначеЕсли ИмяЭлемента = "ОткрытьРМК" Тогда
		
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("e1cib/command/Документ.ЧекККМ.Команда.РабочееМестоКассира");
		
	// Отчеты
	ИначеЕсли ИмяЭлемента = "ДекорацияОтчеты" Тогда
		
		Форма = ОткрытьФорму("ОбщаяФорма.ФормаСпискаОтчетов");
		Форма.Инициализировать("Продажи");
		
	ИначеЕсли ИмяЭлемента = "ДекорацияОтчетыЗаказы" Тогда
		
		ФормаПараметры = Новый Структура();
		ФормаПараметры.Вставить("ПутьКПодсистеме", "Продажи");
		ФормаПараметры.Вставить("Теги", "Заказы");
		Форма = ОткрытьФорму("ОбщаяФорма.ФормаСпискаОтчетов", ФормаПараметры, , "" + УникальныйИдентификатор + "_Заказы");
		
	ИначеЕсли ИмяЭлемента = "ДекорацияОтчетыРозница" Тогда
		
		ФормаПараметры = Новый Структура();
		ФормаПараметры.Вставить("ПутьКПодсистеме", "Продажи");
		ФормаПараметры.Вставить("Теги", "Розница");
		Форма = ОткрытьФорму("ОбщаяФорма.ФормаСпискаОтчетов", ФормаПараметры, , ""+УникальныйИдентификатор+"_Розница");
		
	// Конец Отчеты
	// Учебные материалы
	ИначеЕсли ИмяЭлемента = "ДекорацияВидеоРолики" Тогда
		
		АдресСтраницы = "https://www.youtube.com/watch?v=iFJcMVZ2W98&list=PLCusuGHiDvVnVmj9h6TnylpRG-PZ6ngOV";
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);
		
	ИначеЕсли ИмяЭлемента = "ДекорацияСамоучитель" Тогда
		
		АдресСтраницы = "https://its.1c.ru/db/pubunfreal#content:14:1";
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);
		
	ИначеЕсли ИмяЭлемента = "ДекорацияОписаниеКонфигурации" Тогда
		
		АдресСтраницы = "http://its.1c.ru/db/unfdoc#content:5:1:issogl1_2.10_розничные_продажи";
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);
		
	// Конец Учебные материалы
	// Конец Розница
	
	// Доставка
	ИначеЕсли ИмяЭлемента = "ДекорацияНастройкиДоставка" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РазделПоУмолчанию", "Компания");
		
		ОткрытьФорму("Обработка.НастройкаПрограммы.Форма",
			ПараметрыФормы,,,,,,);
		
	ИначеЕсли ИмяЭлемента = "ДекорацияОписаниеКонфигурацииДоставка" Тогда
		
		АдресСтраницы = "http://its.1c.ru/db/unfdoc";
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);
		
	ИначеЕсли ИмяЭлемента = "ДекорацияСамоучительДоставка" Тогда
		
		АдресСтраницы = "http://its.1c.ru/db/pubunfreal";
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);
		
	ИначеЕсли ИмяЭлемента = "ДекорацияИнформацияОбОбновлениях" Тогда
		
		АдресСтраницы = "http://its.1c.ru/db/updinfo#content:44:hdoc";
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);
		
	ИначеЕсли ИмяЭлемента = "ДействиеГрупповоеСозданиеРасходныхНакладныхИзМаршрутногоЛиста" Тогда
		
		ОткрытьФорму("Документ.МаршрутныйЛист.ФормаСписка");
		
	ИначеЕсли ИмяЭлемента = "ДействиеОформлениеРасходнойНакладнойДляПокупателя"
		ИЛИ ИмяЭлемента = "ДействиеОформлениеРасходнойНакладнойДляПокупателя2" Тогда
		
		ОткрытьФорму("Документ.РасходнаяНакладная.ФормаСписка");
		
	ИначеЕсли ИмяЭлемента = "ДействиеПриходнаяНакладнаяНаУслугиАгента"
		ИЛИ ИмяЭлемента = "ДействиеПриходнаяНакладнаяНаУслугиАгента2" Тогда
		
		ОткрытьФорму("Документ.ПриходнаяНакладная.ФормаОбъекта");
		
	ИначеЕсли ИмяЭлемента = "ДействиеПоступлениеОплатыОтАгента"
		ИЛИ ИмяЭлемента = "ДействиеПоступлениеОплатыОтАгента2" Тогда
		
		СтруктураЗначенияЗаполнения = Новый Структура("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеНаСчет.ОтКурьерскойКомпанииПочты"));
		ПараметрыОткрытияФормы = Новый Структура("ЗначенияЗаполнения", СтруктураЗначенияЗаполнения);
		ОткрытьФорму("Документ.ПоступлениеНаСчет.ФормаОбъекта", ПараметрыОткрытияФормы);
		
	ИначеЕсли ИмяЭлемента = "ДействиеОплатаУслугКурьерскойКомпании" Тогда
		
		СтруктураЗначенияЗаполнения = Новый Структура("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСоСчета.Поставщику"));
		ПараметрыОткрытияФормы = Новый Структура("ЗначенияЗаполнения", СтруктураЗначенияЗаполнения);
		ОткрытьФорму("Документ.РасходСоСчета.ФормаОбъекта", ПараметрыОткрытияФормы);
		
	ИначеЕсли ИмяЭлемента = "ДействиеВзаимозачетДолгаЗаУслугиКурьерскойКомпании" Тогда
		
		СтруктураЗначенияЗаполнения = Новый Структура("ВидОперации, ВидПрочегоВзаимозачета",
			ПредопределенноеЗначение("Перечисление.ВидыОперацийВзаимозачет.ПрочийВзаимозачет"),
			ПредопределенноеЗначение("Перечисление.ВидыПрочегоВзаимозачета.ДолгПрочегоКонтрагентаИДолгПередПоставщиком"));
		ПараметрыОткрытияФормы = Новый Структура("ЗначенияЗаполнения", СтруктураЗначенияЗаполнения);
		ОткрытьФорму("Документ.Взаимозачет.ФормаОбъекта", ПараметрыОткрытияФормы);
		
	// КонецДоставка
	
	ИначеЕсли СтрНайти(ИмяЭлемента, "Справочник") > 0 Тогда
		
		ОткрытьФорму("Справочник."+СтрЗаменить(ИмяЭлемента, "Справочник", "")+".ФормаСписка");
		
	ИначеЕсли СтрНайти(ИмяЭлемента, "Обработка") > 0 Тогда
		
		Если ИмяЭлемента = "ОбработкаДисконтныеКарты" И НЕ ИспользоватьДисконтныеКарты Тогда
			ОповещениеПослеОтветаНаВопрос = Новый ОписаниеОповещения("ОбработкаОтветаНаВопросОДисконтныхКартах", ЭтотОбъект);
			ПоказатьВопрос(ОповещениеПослеОтветаНаВопрос, НСтр("ru = 'Необходимо предварительно включить опцию ""Дисконтные карты"". Перейти к настройкам опций?'"), РежимДиалогаВопрос.ДаНет);
			Возврат;
		ИначеЕсли ИмяЭлемента = "ОбработкаВидыСкидокНаценокРучныеИАвтоматические" И НЕ ИспользоватьСкидкиНаценки Тогда
			ОповещениеПослеОтветаНаВопрос = Новый ОписаниеОповещения("ОбработкаОтветаНаВопросОСкидках", ЭтотОбъект);
			ПоказатьВопрос(ОповещениеПослеОтветаНаВопрос, НСтр("ru = 'Необходимо предварительно включить опцию ""Скидки и наценки в продажах"" или ""Автоматические скидки"". 
				|Перейти к настройкам опций?'"), РежимДиалогаВопрос.ДаНет);
			Возврат;
		КонецЕсли;
		
		ОткрытьФорму("Обработка."+СтрЗаменить(ИмяЭлемента, "Обработка", "")+".Форма");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПодключитьКассыК_ОФДНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://v8.1c.ru/cnt.jsp/:kd_unf:/https://portal.1c.ru/applications/56");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВсеО54ФЗНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://v8.1c.ru/cnt.jsp/:kd_unf:/http://v8.1c.ru/kkt");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаОтветаНаВопросОНастройкеПодключаемогоОборудования(ВыбраннаяКнопка, ПараметрыОтвета) Экспорт
	
	Если ВыбраннаяКнопка = КодВозвратаДиалога.Да Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РазделПоУмолчанию", "ПодключаемоеОборудование");
		
		ОткрытьФорму("Обработка.НастройкаПрограммы.Форма",
			ПараметрыФормы,,,,,,);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтветаНаВопросОДисконтныхКартах(ВыбраннаяКнопка, ПараметрыОтвета) Экспорт
	
	Если ВыбраннаяКнопка = КодВозвратаДиалога.Да Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РазделПоУмолчанию", "Продажи");
		// Поисковую строку задавать не нужно, т.к. опция ИспользоватьДисконтныеКарты зависит от опции ИспользоватьСкидкиИНаценкиВПродажах.
		// А если установить строку поиска, то будет видна только опция ИспользоватьДисконтныеКарты.
		
		ОткрытьФорму("Обработка.НастройкаПрограммы.Форма",
			ПараметрыФормы,,,,,,);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтветаНаВопросОСкидках(ВыбраннаяКнопка, ПараметрыОтвета) Экспорт
	
	Если ВыбраннаяКнопка = КодВозвратаДиалога.Да Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РазделПоУмолчанию", "Продажи");
		
		ОткрытьФорму("Обработка.НастройкаПрограммы.Форма",
			ПараметрыФормы,,,,,,);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
