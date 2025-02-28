﻿
#Область ПрограммныйИнтерфейс

// Переопределяет открытие формы настройка кассового qr-кода СБП
//
// Параметры:
//  КассаККМ 		- ОпределяемыйТип.КассаККМРМК - касса qr-кода;
//  Организация 	- ОпределяемыйТип.ОрганизацияРМК - организация кассового qr-кода;
//  ТорговыйОбъект 	- ОпределяемыйТип.ТорговыйОбъектРМК - торговый объект кассового qr-кода;
//
//@skip-warning
Процедура ОткрытьФормуНастройкиКассовогоQRКода(КассаККМ, Организация, ТорговыйОбъект) Экспорт
	
	ИнтеграцияСПлатежнымиСистемамиУНФКлиент.ОткрытьФормуНастройкиКассовогоQRКода(
		КассаККМ, 
		Организация, 
		ТорговыйОбъект);
	
КонецПроцедуры

#КонецОбласти
