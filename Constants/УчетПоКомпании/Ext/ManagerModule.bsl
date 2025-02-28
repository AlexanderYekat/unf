﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает в зависимости от признака ведения учета по компании
// компанию-организацию или организацию документа.
//
// Параметры:
//	Организация - СправочникСсылка.Организации.
//
// Возвращаемое значение:
//  СправочникСсылка.Организации - ссылка на организацию.
//
Функция Компания(Организация) Экспорт
	
	Если Не Получить() Тогда
		Возврат Организация;
	КонецЕсли;
		
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Компания
	|ИЗ
	|	Константы КАК Константы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО Константы.Компания = Организации.Ссылка");
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Организация;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Компания;
	КонецЕсли;
	
	Возврат Организация;
	
КонецФункции

#КонецОбласти

#КонецЕсли
