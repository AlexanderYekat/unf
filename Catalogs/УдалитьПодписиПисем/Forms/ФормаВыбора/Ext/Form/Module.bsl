﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ЭтоПересылкаОтветНаСообщение", ЭтоОтветПересылка);
	ОбновитьСписокПодписейНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокПодписейНаСервере()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	"ВладелецПодписи", Пользователи.ТекущийПользователь(), , , Истина);
	
КонецПроцедуры

&НаСервере
Процедура ИспользоватьКакОсновнуюНаСервере(СтруктураПараметров)
	
	Запись = РегистрыСведений.ОсновныеПодписиПисем.СоздатьМенеджерЗаписи();
	Запись.Пользователь = СтруктураПараметров.Пользователь;
	Запись.УчетнаяЗапись = СтруктураПараметров.УчетнаяЗапись;
	Запись.УдалитьПодпись = СтруктураПараметров.Подпись;
	
	Запись.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКакОсновную(Команда)
	
	Если НЕ КомандаИспользоватьКакОсновнуюДоступна() Тогда
		Возврат;
	КонецЕсли;
	
	НовыйОсновнаяПодпись = Элементы.Список.ТекущиеДанные.Ссылка;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Пользователь", Элементы.Список.ТекущиеДанные.ВладелецПодписи);
	СтруктураПараметров.Вставить("УчетнаяЗапись", Элементы.Список.ТекущиеДанные.УчетнаяЗапись);
	СтруктураПараметров.Вставить("Подпись", НовыйОсновнаяПодпись);
	
	ИспользоватьКакОсновнуюНаСервере(СтруктураПараметров);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Функция КомандаИспользоватьКакОсновнуюДоступна()
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка")
		Или Элементы.Список.ТекущиеДанные = Неопределено
		Или Элементы.Список.ТекущиеДанные.ЭтоОсновная
		Или Элементы.Список.ТекущиеДанные.ПометкаУдаления Тогда
		
		Возврат Ложь;
		
	КонецЕсли;

	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбработчикСписокПриАктивизацииСтроки", 0.5, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикСписокПриАктивизацииСтроки()
	
	Шаблон = Элементы.Список.ТекущаяСтрока;
	
	Если Шаблон = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущийШаблон = Шаблон Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийШаблон = Шаблон;
	
	ОбработатьАктивизациюСтроки(
		Шаблон,
		Предпросмотр,
		ЭтоОтветПересылка,
		УникальныйИдентификатор);
			
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбработатьАктивизациюСтроки(
	Шаблон,
	ТекстHTML,
	ЭтоПересылка,
	УникальныйИдентификаторФормы)
	
	ПодписьПриОтветеФорматированныйДокумент = Шаблон.Ссылка.ПодписьПриОтветеФорматированныйДокумент.Получить();
	ПодписьДляНовыхФорматированныйДокумент = Шаблон.Ссылка.ПодписьДляНовыхФорматированныйДокумент.Получить();
	
	ТекстПодписи = "";
	Картинки = Новый Структура;
	
	Если НЕ ЭтоПересылка Тогда
		ПодписьДляНовыхФорматированныйДокумент.ПолучитьHTML(ТекстПодписи, Картинки);
	Иначе
		ПодписьПриОтветеФорматированныйДокумент.ПолучитьHTML(ТекстПодписи, Картинки);
	КонецЕсли;
	
	ПеревестиКартинкиВДвоичныеДанные(ТекстПодписи, Картинки);
	
	ТекстHTML = ТекстПодписи;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПеревестиКартинкиВДвоичныеДанные(ТекстHTML, Картинки)
	
	Для Каждого Картинка Из Картинки Цикл
		
		ДвоичныеДанные = Картинка.Значение.ПолучитьДвоичныеДанные();
		ДанныеСтрокой = Base64Строка(ДвоичныеДанные);
		
		СтарыйSRC = СтрШаблон("src=""%1""", Картинка.Ключ);
		НовыйSRC = СтрШаблон("src=""data:image/jpg;base64,%1""", ДанныеСтрокой);
		ТекстHTML = СтрЗаменить(ТекстHTML, СтарыйSRC, НовыйSRC);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
