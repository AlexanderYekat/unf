﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата              = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный     = Пользователи.ТекущийПользователь();
	Уведомление       = Документы.УведомлениеОСпецрежимахНалогообложения.ПустаяСсылка();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не УчетнаяПолитика.ПлательщикЕНП(Организация, Дата) Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Организация %1 не является плательщиком единого налогового платежа'"),
			Организация);
			
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
			,
			"Организация",
			"Объект",
			Отказ);
		
	КонецЕсли;
	
	Для Каждого СтрокаДокумента Из Налоги Цикл
		
		Если ЗначениеЗаполнено(СтрокаДокумента.СрокУплаты)
			И СтрокаДокумента.СрокУплаты < НачалоДня(Дата) Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Вероятно, некорректно заполнена колонка ""Срок уплаты"" в строке %1 списка ""Налоги"": указанное значение меньше даты заявления'"),
				СтрокаДокумента.НомерСтроки);
				
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
				,
				"Налоги",
				"Объект");
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Проверка уникальности записей в документе
	ПроверитьУникальностьДанныхДокумента(Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДаннымиСобытияУНФ.ПропуститьДозаполнениеДокумента(ЭтотОбъект, РежимЗаписи) Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = Налоги.Итог("Сумма");
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ДополнительныеСвойства.Свойство("ГрупповоеПерепроведение") И ДополнительныеСвойства.ГрупповоеПерепроведение Тогда
		Возврат;
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("СинхронизацияСостоянийУведомлений") Тогда
		Возврат;
	КонецЕсли;
	
	АктуализироватьУведомлениеОСпецрежимахНалогообложения(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ДополнительныеСвойства.Свойство("ГрупповоеПерепроведение") И ДополнительныеСвойства.ГрупповоеПерепроведение Тогда
		Возврат;
	КонецЕсли;
	
	Если Налоги.Количество() <> 0 Тогда 
		ЗаписьКалендаря = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеСвойства,     "ЗаписьКалендаря");
		ПериодСобытияКалендаря = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеСвойства, "ПериодСобытия");

		РегистрыСведений.ЗадачиБухгалтераУведомления.ДобавитьЗапись(Организация, Ссылка, ЗаписьКалендаря, ПериодСобытияКалендаря);
	КонецЕсли;
	
	Если Не ЭтотОбъект.Проведен Тогда
		РегистрыСведений.ЗадачиБухгалтераУведомления.УдалитьЗапись(Организация, Ссылка);
	КонецЕсли;
	
	ЕдиныйНалоговыйСчет.СинхронизироватьСостояниеУведомлений(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	//	
	// Подготовка наборов записей.
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ЗаявлениеОЗачетеВСчетПредстоящейОбязанности.ПодготовитьПараметрыПроведения(
		Ссылка,
		Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	// Погашение налога
	ЕдиныйНалоговыйСчет.ЗачетАвансаПоЕдиномуНалоговомуСчетуПоЗаявлениюОЗачете(
		ПараметрыПроведения,
		ПараметрыПроведения.ЗаявлениеОЗачетеВСчетПредстоящейОбязанности,
		Движения,
		Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	Движения.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьОбязательныеПоля(Отказ) Экспорт
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не указана организация.'"), ЭтотОбъект, "Организация", "Объект", Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДанныеДокумента(Отказ) Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Ошибки = Неопределено;
	ДополнительныеСвойства.Свойство("Ошибки", Ошибки);
	
КонецПроцедуры

Функция ТребуетсяАктуализация(ТекущийОбъект)
	
	ТребуетсяАктуализация = Ложь;
	Если Ссылка.Пустая() Или ТекущийОбъект.ДополнительныеСвойства.Свойство("Актуализировать") Тогда
		ТребуетсяАктуализация = Истина;
	Иначе
		ОбъектДоИзменения    = Ссылка.ПолучитьОбъект();
		ОбъектПослеИзменения = ТекущийОбъект;
		Если ОбъектДоИзменения.Дата <> ОбъектПослеИзменения.Дата
			Или ОбъектДоИзменения.Комментарий <> ОбъектПослеИзменения.Комментарий
			Или ОбъектДоИзменения.СуммаДокумента <> ОбъектПослеИзменения.СуммаДокумента
			Или ОбъектДоИзменения.Налоги.Количество() <> ОбъектПослеИзменения.Налоги.Количество() Тогда
			ТребуетсяАктуализация = Истина;
		Иначе
			СписокКолонок = ТекущийОбъект.Метаданные().ТабличныеЧасти.Налоги.Реквизиты;
			Для ИндексСтроки = 0 По ОбъектДоИзменения.Налоги.Количество() - 1 Цикл
				СтрокаДоИзменения    = ОбъектДоИзменения.Налоги[ИндексСтроки];
				СтрокаПослеИзменения = ОбъектПослеИзменения.Налоги[ИндексСтроки];
				Для Каждого Колонка Из СписокКолонок Цикл
					Если СтрокаДоИзменения[Колонка.Имя] <> СтрокаПослеИзменения[Колонка.Имя] Тогда
						ТребуетсяАктуализация = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТребуетсяАктуализация;
	
КонецФункции

Процедура АктуализироватьУведомлениеОСпецрежимахНалогообложения(ТекущийОбъект)
	
	Если Не ТребуетсяАктуализация(ТекущийОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ГоловнаяОрганизация         = ТекущийОбъект.Организация;
	РегистрацияВНалоговомОргане = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ГоловнаяОрганизация, "РегистрацияВНалоговомОргане");
	ЭтоЮЛ                       = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЭтоЮрЛицо(ГоловнаяОрганизация);
	
	Если Не ЗначениеЗаполнено(ТекущийОбъект.Ссылка) Тогда
		СсылкаОбъекта = Документы.ЗаявлениеОЗачетеВСчетПредстоящейОбязанности.ПолучитьСсылку();
		ТекущийОбъект.УстановитьСсылкуНового(СсылкаОбъекта);
	Иначе
		СсылкаОбъекта = ТекущийОбъект.Ссылка;
	КонецЕсли;
	
	// Титульный
	ДанныеУведомленияТитульный = Новый Структура;
	ДанныеУведомленияТитульный.Вставить("ПрЗачет", "2");
	
	Если ЭтоЮЛ Тогда 
		СтрокаСведений = "ИННЮЛ,НаимЮЛПол,КППЮЛ,ТелОрганизации,ФамилияРук,ИмяРук,ОтчествоРук";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
			ГоловнаяОрганизация,
			ТекущийОбъект.Дата,
			СтрокаСведений);
		ДанныеУведомленияТитульный.Вставить("ИНН",     СведенияОбОрганизации.ИННЮЛ);
		ДанныеУведомленияТитульный.Вставить("КПП",     СведенияОбОрганизации.КППЮЛ);
		ДанныеУведомленияТитульный.Вставить("Тлф",     СведенияОбОрганизации.ТелОрганизации);
	Иначе
		СтрокаСведений = "ФИО,ИННФЛ,ТелСлуж,ФамилияИП,ИмяИП,ОтчествоИП";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
			ГоловнаяОрганизация,
			ТекущийОбъект.Дата,
			СтрокаСведений);
		ДанныеУведомленияТитульный.Вставить("ИНН",     СведенияОбОрганизации.ИННФЛ);
		ДанныеУведомленияТитульный.Вставить("Тлф",     СведенияОбОрганизации.ТелСлуж);
		ДанныеУведомленияТитульный.Вставить("КПП",     "");
	КонецЕсли;
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ",     ТекущийОбъект.Дата);
	ДанныеУведомленияТитульный.Вставить("РегистрацияВИФНС", РегистрацияВНалоговомОргане);
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РегистрацияВНалоговомОргане, "Код,Представитель,КПП,ДокументПредставителя");
	ДанныеУведомленияТитульный.Вставить("КодНО", Реквизиты.Код);
	ДанныеУведомленияТитульный.Вставить("КПП",   Реквизиты.КПП);
	
	ПодписантФамилия  = "";
	ПодписантИмя      = "";
	ПодписантОтчество = "";
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		СведенияОПредставителе = РегламентированнаяОтчетностьВызовСервера.ПолучитьПоКодамСведенияОПредставителе(
			ТекущийОбъект.Организация,
			ДанныеУведомленияТитульный["КодНО"], 
			ДанныеУведомленияТитульный["КПП"]);
		Если ЗначениеЗаполнено(СведенияОПредставителе.НаименованиеОрганизацииПредставителя) Тогда
			ПодписантСтр = СведенияОПредставителе.ФИОПредставителя;
			ФИО = РегламентированнаяОтчетность.РазложитьФИО(ПодписантСтр);
			ПодписантФамилия = СокрЛП(ФИО.Фамилия);
			ПодписантИмя = СокрЛП(ФИО.Имя);
			ПодписантОтчество = СокрЛП(ФИО.Отчество);
		Иначе
			ДанныеПредставителя = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОФизЛице(
				Реквизиты.Представитель,
				,
				ТекущийОбъект.Дата);
			ПодписантФамилия  = СокрЛП(ДанныеПредставителя.Фамилия);
			ПодписантИмя      = СокрЛП(ДанныеПредставителя.Имя);
			ПодписантОтчество = СокрЛП(ДанныеПредставителя.Отчество);
			ПодписантСтр = СокрЛП(ПодписантФамилия + " " + ПодписантИмя + " " + ПодписантОтчество);
		КонецЕсли;
		ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПодписантСтр);
		ДанныеУведомленияТитульный.Вставить("НаимОргПред",                    СведенияОПредставителе.НаименованиеОрганизацииПредставителя);
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ",              "2");
		ДанныеУведомленияТитульный.Вставить("НаимДок",                        Реквизиты.ДокументПредставителя);
	Иначе
		Если ЭтоЮЛ Тогда
			ПодписантФамилия  = СведенияОбОрганизации.ФамилияРук;
			ПодписантИмя      = СведенияОбОрганизации.ИмяРук;
			ПодписантОтчество = СведенияОбОрганизации.ОтчествоРук;
		Иначе
			ПодписантФамилия  = СведенияОбОрганизации.ФамилияИП;
			ПодписантИмя      = СведенияОбОрганизации.ИмяИП;
			ПодписантОтчество = СведенияОбОрганизации.ОтчествоИП;
		КонецЕсли;
		ПодписантСтр = СокрЛП(ПодписантФамилия + " " + ПодписантИмя + " " + ПодписантОтчество);
		ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПодписантСтр);
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ",              "1");
		ДанныеУведомленияТитульный.Вставить("НаимДок",                        "");
	КонецЕсли;
	
	МассивРегистраций = ОбщегоНазначения.ВыгрузитьКолонку(ТекущийОбъект.Налоги, "РегистрацияВНалоговомОргане", Истина);
	РквизитыРегистраций = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивРегистраций, "КПП");
	
	// МнгСтр2
	ДанныеУведомленияРезультат = Новый Массив;
	Для Каждого ТекущаяСтрока Из ТекущийОбъект.Налоги Цикл
		
		СтруктураДанныхНалог = Новый Структура;
		СтруктураДанныхНалог.Вставить("КПП",        РквизитыРегистраций[ТекущаяСтрока.РегистрацияВНалоговомОргане]);
		СтруктураДанныхНалог.Вставить("ОКТМО",      СокрЛП(ТекущаяСтрока.КодПоОКТМО));
		СтруктураДанныхНалог.Вставить("КБК",        ТекущаяСтрока.КодБК);
		СтруктураДанныхНалог.Вставить("СумЗачет2",  ТекущаяСтрока.Сумма);
		СтруктураДанныхНалог.Вставить("СрокУпл",    ТекущаяСтрока.СрокУплаты);
		СтруктураДанныхНалог.Вставить("ПрНалАгент", ?(ТекущаяСтрока.НалоговыйАгент, "1", "2"));
		
		ДанныеУведомленияРезультат.Добавить(СтруктураДанныхНалог);
		
	КонецЦикла;
	
	ПараметрыЗаявления = Новый Структура;
	ПараметрыЗаявления.Вставить("Организация",          ГоловнаяОрганизация);
	ПараметрыЗаявления.Вставить("РегистрацияВИФНС",     РегистрацияВНалоговомОргане);
	ПараметрыЗаявления.Вставить("Титульная",            ДанныеУведомленияТитульный);
	ПараметрыЗаявления.Вставить("ЗачетСумЕНС",          Новый Структура("МнгСтр2", ДанныеУведомленияРезультат));
	ПараметрыЗаявления.Вставить("ПодписантФамилия",     ПодписантФамилия);
	ПараметрыЗаявления.Вставить("ПодписантИмя",         ПодписантИмя);
	ПараметрыЗаявления.Вставить("ПодписантОтчество",    ПодписантОтчество);
	ПараметрыЗаявления.Вставить("ДокументОснование",    СсылкаОбъекта);
	ПараметрыЗаявления.Вставить("ДатаОснования",        Дата);
	ПараметрыЗаявления.Вставить("КомментарийОснования", Комментарий);
	Если ЗначениеЗаполнено(ТекущийОбъект.Уведомление) И ОбщегоНазначения.СсылкаСуществует(ТекущийОбъект.Уведомление) Тогда
		ПараметрыЗаявления.Вставить("СсылкаНаДокумент", ТекущийОбъект.Уведомление);
	КонецЕсли;
	
	ТекущийОбъект.Уведомление = Отчеты.РегламентированноеУведомлениеЗачетНалога.СформироватьНовоеУведомление(
			Отчеты.РегламентированноеУведомлениеЗачетНалога.ДействующаяРедакцияФормы(ТекущийОбъект.Дата),
			ПараметрыЗаявления);
	
КонецПроцедуры

Процедура ПроверитьУникальностьДанныхДокумента(Отказ)
	
	ТаблицаНалоги = Налоги.Выгрузить();
	КолонкиСверки = "Налог, КодБК, СчетУчета, РегистрацияВНалоговомОргане, КодПоОКТМО, СрокУплаты";
	ТаблицаНалоги.Свернуть(КолонкиСверки);
	Если ТаблицаНалоги.Количество() <> Налоги.Количество() Тогда
		ОтборСтрок = Новый Структура(КолонкиСверки);
		Для Каждого СтрокаТаблицы Из ТаблицаНалоги Цикл
			
			ЗаполнитьЗначенияСвойств(ОтборСтрок, СтрокаТаблицы);
			МассивСтрок = Налоги.НайтиСтроки(ОтборСтрок);
			Если МассивСтрок.Количество() = 1 Тогда
				Продолжить;
			КонецЕсли;
			
			НомераСтрок = "";
			Для Каждого СтрокаМассива Из МассивСтрок Цикл
				НомераСтрок = НомераСтрок + ?(НомераСтрок <> "", ", ", "") + СтрокаМассива.НомерСтроки;
			КонецЦикла;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Дублируются ключевые значения в строках %1 списка ""Налоги""'"),
				НомераСтрок);
				
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
				,
				"Налоги",
				"Объект",
				Отказ);
				
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли