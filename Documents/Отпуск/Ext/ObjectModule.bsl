﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Документы.Отпуск.ЗаполнитьДатуЗапретаРедактирования(ЭтотОбъект);
	
	РасчетЗарплатыДляНебольшихОрганизацийСобытия.ДокументыПередЗаписью(ЭтотОбъект, Отказ);
	
	Начислено = Начисления.Итог("Результат");
	Удержано = НДФЛ.Итог("Налог");
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		Если ДанныеЗаполнения.Свойство("Начисления") Тогда
			Для Каждого Начисление Из ДанныеЗаполнения.Начисления Цикл
				НовоеНачисление = Начисления.Добавить();
				ЗаполнитьЗначенияСвойств(НовоеНачисление, Начисление);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	// Заполним описание данных для проведения в учете начисленной зарплаты.
	ДанныеДляПроведенияУчетЗарплаты = ОтражениеЗарплатыВУчете.ОписаниеДанныеДляПроведения();
	ДанныеДляПроведенияУчетЗарплаты.Движения 				= Движения;
	ДанныеДляПроведенияУчетЗарплаты.Организация 			= Организация;
	ДанныеДляПроведенияУчетЗарплаты.ПериодРегистрации 		= ПериодРегистрации;
	ДанныеДляПроведенияУчетЗарплаты.ПланируемаяДатаВыплаты 	= ПланируемаяДатаВыплаты;
	ДанныеДляПроведенияУчетЗарплаты.ПорядокВыплаты 			= Перечисления.ХарактерВыплатыЗарплаты.Зарплата;
	ДанныеДляПроведенияУчетЗарплаты.МенеджерВременныхТаблиц = ДанныеДляПроведения.МенеджерВременныхТаблиц;
	
	УчетНачисленнойЗарплаты.ЗарегистрироватьНачисления(ДанныеДляПроведенияУчетЗарплаты, Отказ, ДанныеДляПроведения.НачисленияПоСотрудникам, Неопределено);
	УчетНачисленнойЗарплаты.ЗарегистрироватьОтработанноеВремя(ДанныеДляПроведенияУчетЗарплаты, Отказ, ДанныеДляПроведения.ОтработанноеВремяПоСотрудникам, Истина);
	
	// Подготовка данных для регистрации удержаний, НДФЛ и Корректировок выплаты в учете начисленной зарплаты.
	УчетНачисленнойЗарплаты.СоздатьВТРаспределениеНачисленийТекущегоДокумента(ДанныеДляПроведенияУчетЗарплаты);
	
	// НДФЛ
	СформироватьДоходыНДФЛ(Отказ, ДанныеДляПроведения);
	// Дополняем доходы НДФЛ сведениями о распределении по статьям финансирования и/или статьям расходов.
	ОтражениеЗарплатыВУчетеБазовый.ДополнитьСведенияОДоходахНДФЛСведениямиОРаспределенииПоСтатьям(Движения);
	
	ДатаОперации = ДатаОперацииПоНалогомИВзносам();
	УчетНДФЛ.СформироватьНалогиВычеты(Движения, Отказ, Организация, ДатаОперации, ДанныеДляПроведения.НДФЛ, , Ложь);
	УчетНДФЛ.СформироватьДокументыУчтенныеПриРасчетеДляМежрасчетногоДокумента(Движения, Отказ, Организация, ФизическоеЛицо, Ссылка);
	
	УчетНачисленнойЗарплаты.ПодготовитьДанныеНДФЛКРегистрации(ДанныеДляПроведения.НДФЛПоСотрудникам, Организация, ДатаОперации);
	УчетНачисленнойЗарплаты.ЗарегистрироватьНДФЛПоСотрудникам(ДанныеДляПроведенияУчетЗарплаты, Отказ, ДанныеДляПроведения.НДФЛПоСотрудникам);
	УчетНачисленнойЗарплаты.ЗарегистрироватьНДФЛКЗачетуВозврату(ДанныеДляПроведенияУчетЗарплаты, Отказ,
			ДанныеДляПроведения.КорректировкиВыплатыПоСотрудникам, ДанныеДляПроведения.НДФЛПоСотрудникам);
	
	// Страховые взносы
	ОтражениеЗарплатыВБухучете.СоздатьВТНачисленияСДаннымиЕНВД(Организация, ПериодРегистрации, ДанныеДляПроведения.МенеджерВременныхТаблиц, ДанныеДляПроведения.НачисленияПоСотрудникам);
	УчетСтраховыхВзносов.СформироватьСведенияОДоходахСтраховыеВзносы(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляПроведения.МенеджерВременныхТаблиц, , Истина);
	
	УчетСтажаПФР.ЗарегистрироватьПериодыВУчетеСтажаПФР(Движения, ДанныеДляРегистрацииВУчетаСтажаПФР());
	
	Если Не Отказ Тогда
		
		// формирование проводок
		ДанныеДляПроведения = ОтражениеЗарплатыВУчете.НоваяСтруктураРезультатыРасчетаЗарплаты();
		ДанныеДляПроведения.НачисленияУдержания = Движения.НачисленияУдержанияПоСотрудникам.Выгрузить();
		СтрокаСписокТаблиц = "НачисленнаяЗарплатаИВзносы, НачисленныйНДФЛ";
		ОтражениеЗарплатыВБухучете.СформироватьДвиженияПоДокументу(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляПроведения, СтрокаСписокТаблиц);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьДатуВыплаты(ЭтотОбъект, Отказ);
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачалаОсновногоОтпуска, "Объект.ДатаНачалаОсновногоОтпуска", Отказ,
		НСтр("ru='Дата начала отпуска'"));
	
	Если ЗначениеЗаполнено(НачалоПериодаЗаКоторыйПредоставляетсяОтпуск) Тогда
		
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, НачалоПериодаЗаКоторыйПредоставляетсяОтпуск, "Объект.НачалоПериодаЗаКоторыйПредоставляетсяОтпуск", Отказ,
			НСтр("ru='Начало периода за который предоставляется отпуск'"));
		
		Если ЗначениеЗаполнено(КонецПериодаЗаКоторыйПредоставляетсяОтпуск)
			И КонецПериодаЗаКоторыйПредоставляетсяОтпуск < НачалоПериодаЗаКоторыйПредоставляетсяОтпуск Тогда
			
			ТекстСообщения = НСтр("ru='Окончание периода за который предоставляется отпуск не может быть меньше его начала'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.КонецПериодаЗаКоторыйПредоставляетсяОтпуск", , Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаОкончанияОсновногоОтпуска)
		И ДатаОкончанияОсновногоОтпуска < ДатаНачалаОсновногоОтпуска Тогда
		
		ТекстСообщения = НСтр("ru  = 'Начало периода работы за который предоставляется отпуск (компенсация) не может быть больше окончания этого периода.'"); 
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.НачалоПериодаЗаКоторыйПредоставляетсяОтпуск", , Отказ);
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
		ПараметрыПолученияСотрудниковОрганизаций.Организация 					= Организация;
		ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода					= ДатаНачалаОсновногоОтпуска;
		ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода				= ДатаНачалаОсновногоОтпуска;
		
		КадровыйУчет.ПроверитьРаботающихСотрудников(
			Сотрудник,
			ПараметрыПолученияСотрудниковОрганизаций,
			Отказ,
			Новый Структура("ИмяОбъекта,ИмяПоляСотрудник", "Объект", "Сотрудник"));
			
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
	РасчетЗарплаты.ЗаполнитьНачисления(ДанныеДляПроведения, Ссылка, , "ДатаНачала");
	РасчетЗарплаты.ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, Ссылка);
	РасчетЗарплаты.ЗаполнитьДанныеКорректировкиВыплаты(ДанныеДляПроведения, Ссылка);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Функция ДанныеДляРегистрацииВУчетаСтажаПФР()
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Ссылка);
	
	ДанныеДляРегистрацииВУчете = Документы.Отпуск.ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок);
		
	Возврат ДанныеДляРегистрацииВУчете[Ссылка];
														
КонецФункции

Процедура СформироватьДоходыНДФЛ(Отказ = Ложь, ДанныеДляПроведения = Неопределено) Экспорт
	
	Если ДанныеДляПроведения = Неопределено Тогда
		ДанныеДляПроведения = ДанныеДляПроведения();
	КонецЕсли; 
	
	ДатаОперации = ДатаОперацииПоНалогомИВзносам();
	УчетНДФЛ.СформироватьДоходыНДФЛПоНачислениям(
		Движения, Отказ, Организация, ДатаОперации, ПланируемаяДатаВыплаты, ДанныеДляПроведения.МенеджерВременныхТаблиц, ПериодРегистрации, Ложь, Ложь, , Ссылка);
	
КонецПроцедуры

Функция ДатаОперацииПоНалогомИВзносам()
	Возврат УчетНДФЛ.ДатаОперацииПоДокументу(Дата, ПериодРегистрации);
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли