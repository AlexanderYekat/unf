﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем МассивИзмененныхРеквизитов;

#КонецОбласти

#Область Служебные

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиентеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Ответ = Результат;
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДобавитьИзображениеНаКлиентеФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьПрисоединенныйФайл()
	
	ОчиститьСообщения();
	
	ИмяРеквизитаОбъекта = "";
	
	Если КэшЗначений.РаботаСЛоготипом Тогда
		
		ИмяРеквизитаОбъекта = "ФайлЛоготип";
		
	ИначеЕсли КэшЗначений.РаботаСФаксимиле Тогда
		
		ИмяРеквизитаОбъекта = "ФайлФаксимильнаяПечать";
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ИмяРеквизитаОбъекта)
		И ЗначениеЗаполнено(КонтекстПечати[ИмяРеквизитаОбъекта]) Тогда
		
		ДанныеФайла = ПолучитьДанныеФайла(КонтекстПечати[ИмяРеквизитаОбъекта], УникальныйИдентификатор);
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Отсутствует изображение для просмотра'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "АдресКартинки");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиентеФрагмент()
	
	Перем ИдентификаторФайла, ИмяРеквизитаОбъекта, Фильтр;
	
	Если КэшЗначений.РаботаСЛоготипом Тогда
		
		ИмяРеквизитаОбъекта = "ФайлЛоготип";
		
	ИначеЕсли КэшЗначений.РаботаСФаксимиле Тогда
		
		ИмяРеквизитаОбъекта = "ФайлФаксимильнаяПечать";
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КонтекстПечати[ИмяРеквизитаОбъекта]) Тогда
		
		ПросмотретьПрисоединенныйФайл();
		
	ИначеЕсли ЗначениеЗаполнено(КонтекстПечати.Ссылка) Тогда
		
		ИдентификаторФайла = Новый УникальныйИдентификатор;
		
		Фильтр = РаботаСФайламиУНФКлиентСервер.ФильтрФайловИзображений();
		
		РаботаСФайламиКлиент.ДобавитьФайлы(КонтекстПечати.Ссылка, ИдентификаторФайла, Фильтр);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиенте()
	
	Если НЕ ЗначениеЗаполнено(КонтекстПечати.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		Ответ = Неопределено;
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ДобавитьИзображениеНаКлиентеЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	ДобавитьИзображениеНаКлиентеФрагмент();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайла(ФайлКартинки, УникальныйИдентификатор)
	
	ДополнительныеПараметры = РаботаСФайламиКлиентСервер.ПараметрыДанныхФайла();
	ДополнительныеПараметры.ИдентификаторФормы = УникальныйИдентификатор;
	
	Возврат РаботаСФайлами.ДанныеФайла(ФайлКартинки, ДополнительныеПараметры);
	
КонецФункции

&НаКлиенте
Процедура ЗафиксироватьИзменениеЗначенияРеквизита(ИмяРеквизита)
	
	Если МассивИзмененныхРеквизитов.Найти(ИмяРеквизита) = Неопределено Тогда
		
		МассивИзмененныхРеквизитов.Добавить(ИмяРеквизита);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзмененияИЗакрытьФорму(Команда = Неопределено)
	
	ПараметрыЗакрытия = Новый Структура;
	Если Команда <> Неопределено Тогда
		
		ПараметрыЗакрытия.Вставить("Команда", Команда);
		
	КонецЕсли;
	
	ИзмененныеРеквизиты = Новый Структура;
	Для каждого ЭлементМассива Из МассивИзмененныхРеквизитов Цикл
		
		ИзмененныеРеквизиты.Вставить(ЭлементМассива, КонтекстПечати[ЭлементМассива]);
		
	КонецЦикла;
	ПараметрыЗакрытия.Вставить("ИзмененныеРеквизиты", ИзмененныеРеквизиты);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура ЗаголовокФормы()
	
	ЭтаФорма.Заголовок = Обработки.РеквизитыПечати.ЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеФлагамиРаботыСКартинками(ЭтоРаботаСЛоготипом = Ложь, ЭтоРаботаСФаксимиле = Ложь)
	
	КэшЗначений.РаботаСЛоготипом = ЭтоРаботаСЛоготипом;
	КэшЗначений.РаботаСФаксимиле = ЭтоРаботаСФаксимиле;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеФаксимилеФрагмент()
	
	Перем ИдентификаторФайла;
	
	УправлениеФлагамиРаботыСКартинками(Ложь, Истина);
	
	ИдентификаторФайла = Новый УникальныйИдентификатор;
	РаботаСФайламиКлиент.ДобавитьФайлы(ОрганизацияСсылка, ИдентификаторФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеЛоготипаФрагмент()
	
	Перем ИдентификаторФайла;
	
	УправлениеФлагамиРаботыСКартинками(Истина, Ложь);
	
	ИдентификаторФайла = Новый УникальныйИдентификатор;
	РаботаСФайламиКлиент.ДобавитьФайлы(ОрганизацияСсылка, ИдентификаторФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзПрисоединенныхФайлов()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла", ОрганизацияСсылка);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НавигационнаяСсылкаКартинки(ФайлКартинки, ИдентификаторФормы)
	
	Если Не ЗначениеЗаполнено(ФайлКартинки) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		ДополнительныеПараметры = РаботаСФайламиКлиентСервер.ПараметрыДанныхФайла();
		ДополнительныеПараметры.ИдентификаторФормы = ИдентификаторФормы;
		
		Возврат РаботаСФайлами.ДанныеФайла(ФайлКартинки, ДополнительныеПараметры).СсылкаНаДвоичныеДанныеФайла;
		
	Исключение
		Возврат "";
	КонецПопытки;
	
КонецФункции

#КонецОбласти

#Область Форма

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаголовокФормы();
	
	КэшЗначений = Новый Структура;
	КэшЗначений.Вставить("РаботаСЛоготипом", Ложь);
	КэшЗначений.Вставить("РаботаСФаксимиле", Ложь);
	
	ОрганизацияСсылка = Параметры.КонтекстПечати.Ссылка;
	
	ЗаполнитьЗначенияСвойств(КонтекстПечати, Параметры.КонтекстПечати, "ПодписьРуководителя, ПодписьГлавногоБухгалтера, ФайлЛоготип, ФайлФаксимильнаяПечать");
	
	Если ЗначениеЗаполнено(КонтекстПечати.ФайлЛоготип) Тогда
		
		АдресЛоготипа = НавигационнаяСсылкаКартинки(КонтекстПечати.ФайлЛоготип, УникальныйИдентификатор);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КонтекстПечати.ФайлФаксимильнаяПечать) Тогда
		
		АдресФаксимильнойПечати = НавигационнаяСсылкаКартинки(КонтекстПечати.ФайлФаксимильнаяПечать, УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МассивИзмененныхРеквизитов = Новый Массив;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" Тогда
		
		Модифицированность	= Истина;
		Если КэшЗначений.РаботаСЛоготипом Тогда
			
			КонтекстПечати.ФайлЛоготип = ?(ТипЗнч(Источник) = Тип("Массив"), Источник[0], Источник);
			ДвоичныеДанныеКартинки = РаботаСФайламиУНФВызовСервера.СсылкаНаДвоичныеДанныеФайла(КонтекстПечати.ФайлЛоготип,
				УникальныйИдентификатор);
			Если ДвоичныеДанныеКартинки <> Неопределено Тогда
				АдресЛоготипа = ДвоичныеДанныеКартинки;
			КонецЕсли;
			КэшЗначений.РаботаСЛоготипом = Ложь;
			
			ЗафиксироватьИзменениеЗначенияРеквизита("ФайлЛоготип");
			
		ИначеЕсли КэшЗначений.РаботаСФаксимиле Тогда
			
			КонтекстПечати.ФайлФаксимильнаяПечать = ?(ТипЗнч(Источник) = Тип("Массив"), Источник[0], Источник);
			ДвоичныеДанныеКартинки = РаботаСФайламиУНФВызовСервера.СсылкаНаДвоичныеДанныеФайла(КонтекстПечати.ФайлФаксимильнаяПечать,
				УникальныйИдентификатор);
			Если ДвоичныеДанныеКартинки <> Неопределено Тогда 
				АдресФаксимильнойПечати = ДвоичныеДанныеКартинки;
			КонецЕсли;
			КэшЗначений.РаботаСФаксимиле = Ложь;
			
			ЗафиксироватьИзменениеЗначенияРеквизита("ФайлФаксимильнаяПечать");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура ОК(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура СоставКомиссийНажатие(Элемент)
	
	ЗначениеОтбора = Новый Структура;
	ЗначениеОтбора.Вставить("Организация", ОрганизацияСсылка);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отбор", ЗначениеОтбора);
	
	ОткрытьФорму("Справочник.Комиссии.ФормаСписка", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотрПечатнойФормыСчетНаОплату(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.Организации",
		"ПредварительныйПросмотрПечатнойФормыСчетНаОплату", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОрганизацияСсылка), ЭтотОбъект, Новый Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьИзображениеЛоготипа(Команда)
	
	ОчиститьСообщения();
	Если ЗначениеЗаполнено(КонтекстПечати.ФайлЛоготип) Тогда
		
		РаботаСФайламиКлиент.ОткрытьФормуФайла(КонтекстПечати.ФайлЛоготип);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Отсутствует изображение для редактирования'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "АдресЛоготипа");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьИзображениеФаксимиле(Команда)
	
	ОчиститьСообщения();
	
	Если ЗначениеЗаполнено(КонтекстПечати.ФайлФаксимильнаяПечать) Тогда
		
		РаботаСФайламиКлиент.ОткрытьФормуФайла(КонтекстПечати.ФайлФаксимильнаяПечать);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Отсутствует изображение для редактирования'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "АдресЛоготипа");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеЛоготипа(Команда)
	
	ДобавитьИзображениеЛоготипаФрагмент();
	
	ЗафиксироватьИзменениеЗначенияРеквизита("ФайлЛоготип");
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеФаксимиле(Команда)
	
	ДобавитьИзображениеФаксимилеФрагмент();
	
	ЗафиксироватьИзменениеЗначенияРеквизита("ФайлФаксимильнаяПечать");
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИзображениеЛоготипа(Команда)
	
	КонтекстПечати.ФайлЛоготип = Неопределено;
	АдресЛоготипа = "";
	
	ЗафиксироватьИзменениеЗначенияРеквизита("ФайлЛоготип");
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИзображениеФаксимиле(Команда)
	
	КонтекстПечати.ФайлФаксимильнаяПечать = Неопределено;
	АдресФаксимильнойПечати = "";
	
	ЗафиксироватьИзменениеЗначенияРеквизита("ФайлФаксимильнаяПечать");
	
КонецПроцедуры

&НаКлиенте
Процедура ЛоготипИзПрисоединенныхФайлов(Команда)
	
	УправлениеФлагамиРаботыСКартинками(Истина, Ложь);
	ВыбратьКартинкуИзПрисоединенныхФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ФаксимилеИзПрисоединенныхФайлов(Команда)
	
	УправлениеФлагамиРаботыСКартинками(Ложь, Истина);
	ВыбратьКартинкуИзПрисоединенныхФайлов();
	
КонецПроцедуры

#КонецОбласти

#Область Реквизиты

&НаКлиенте
Процедура АдресЛоготипаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаблокироватьДанныеФормыДляРедактирования();
	
	УправлениеФлагамиРаботыСКартинками(Истина, Ложь);
	ДобавитьИзображениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресФаксимильнойПечатиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаблокироватьДанныеФормыДляРедактирования();
	
	УправлениеФлагамиРаботыСКартинками(Ложь, Истина);
	ДобавитьИзображениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьРуководителяПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьГлавногоБухгалтераПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

#КонецОбласти
