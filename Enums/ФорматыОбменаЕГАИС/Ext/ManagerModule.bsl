﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ФорматОбменаНеМенееV3(ФорматОбмена) Экспорт
	
	Если ЗначениеЗаполнено(ФорматОбмена)
		И ФорматОбмена <> Перечисления.ФорматыОбменаЕГАИС.V1
		И ФорматОбмена <> Перечисления.ФорматыОбменаЕГАИС.V2 Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ФорматОбменаНеМенееV4(ФорматОбмена) Экспорт
	
	Если ЗначениеЗаполнено(ФорматОбмена)
		И ФорматОбмена <> Перечисления.ФорматыОбменаЕГАИС.V1
		И ФорматОбмена <> Перечисления.ФорматыОбменаЕГАИС.V2
		И ФорматОбмена <> Перечисления.ФорматыОбменаЕГАИС.V3 Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецЕсли