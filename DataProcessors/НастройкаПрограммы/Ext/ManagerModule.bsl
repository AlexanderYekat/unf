﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует служебную информацию для письма о новых возможностях
//
// Параметры:
//	Тег - Строка - Тег для добавляемой возможности
//
Функция СлужебнаяИнформацияДляПисьма(Тег) Экспорт
	
	Разделитель = "-------------------------------------------------------------------------------------";
	ВступительныйТекст = НСтр("ru = 'Спасибо, что помогаете развивать приложение! 
	|Мы обязательно прочитаем письмо и рассмотрим ваше пожелание, но вероятнее всего на письмо не ответим. 
	|Если у вас есть вопрос по работе приложения, требующий ответа, то зарегистрируйте обращение на линию консультации.'")
	+ Символы.ПС + Символы.ПС;

	Шаблон = НСтр("ru = 'Просьба не удалять данную информацию:
	|Конфигурация: [СинонимКонфигурации] ([ВерсияКонфигурации])
	|Платформа: 1С:Предприятие ([ВерсияПлатформы])
	|Тег: [Тег]'");
	
	СисИнфо = Новый СистемнаяИнформация;
	ВставляемыеЗначения = Новый Структура;
	ВставляемыеЗначения.Вставить("СинонимКонфигурации",	Метаданные.Синоним);
	ВставляемыеЗначения.Вставить("ВерсияКонфигурации",	Метаданные.Версия);
	ВставляемыеЗначения.Вставить("ВерсияПлатформы",		СисИнфо.ВерсияПриложения);
	ВставляемыеЗначения.Вставить("Тег",					Тег);
	ИнформацияОПрограмме = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Шаблон, ВставляемыеЗначения);
	
	СлужебнаяИнформацияДляПисьма = Разделитель + Символы.ПС + ВступительныйТекст + Символы.ПС + ИнформацияОПрограмме;
	Возврат СлужебнаяИнформацияДляПисьма;
	
КонецФункции

#КонецОбласти

#КонецЕсли