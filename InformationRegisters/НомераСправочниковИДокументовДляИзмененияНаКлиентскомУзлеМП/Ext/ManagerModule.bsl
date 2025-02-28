﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаписатьИнформацию(Структура) Экспорт
	
	НаборЗаписей = РегистрыСведений.НомераСправочниковИДокументовДляИзмененияНаКлиентскомУзлеМП.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Ссылка.Установить(Структура.Ссылка);
	НаборЗаписей.Отбор.КодУзла.Установить(Структура.КодУзла);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	Для Каждого Элемент Из Структура Цикл
		НоваяЗапись[Элемент.Ключ] = Элемент.Значение;
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция ПроверитьНаличиеДанных(КодУзла) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НомераСправочниковИДокументовДляИзмененияНаКлиентскомУзлеМП.Ссылка КАК Ссылка,
		|	НомераСправочниковИДокументовДляИзмененияНаКлиентскомУзлеМП.Номер КАК Номер
		|ИЗ
		|	РегистрСведений.НомераСправочниковИДокументовДляИзмененияНаКлиентскомУзлеМП КАК НомераСправочниковИДокументовДляИзмененияНаКлиентскомУзлеМП
		|ГДЕ
		|	НомераСправочниковИДокументовДляИзмененияНаКлиентскомУзлеМП.КодУзла = &КодУзла";
	
	Запрос.УстановитьПараметр("КодУзла", КодУзла);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	МассивСЗаписями = Новый Массив;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Структура = Новый Структура("Ссылка, Номер", ВыборкаДетальныеЗаписи.Ссылка, ВыборкаДетальныеЗаписи.Номер);
		МассивСЗаписями.Добавить(Структура);
	КонецЦикла;
	
	Возврат МассивСЗаписями

КонецФункции

Процедура УдалитьЗаписи(КодУзла) Экспорт
	
	НаборЗаписей = РегистрыСведений.НомераСправочниковИДокументовДляИзмененияНаКлиентскомУзлеМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.КодУзла.Установить(КодУзла);
	НаборЗаписей.Записать();

КонецПроцедуры

Процедура УдалитьЗапись(Ссылка) Экспорт
	
	НаборЗаписей = РегистрыСведений.НомераСправочниковИДокументовДляИзмененияНаКлиентскомУзлеМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Ссылка.Установить(Ссылка);
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура УдалитьЗаписьДляЦентральногоУзла(КодУзла, Ссылка) Экспорт
	
	НаборЗаписей = РегистрыСведений.НомераСправочниковИДокументовДляИзмененияНаКлиентскомУзлеМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Ссылка.Установить(Ссылка);
	НаборЗаписей.Отбор.КодУзла.Установить(КодУзла);
	НаборЗаписей.Записать();

КонецПроцедуры

#КонецОбласти

#КонецЕсли
