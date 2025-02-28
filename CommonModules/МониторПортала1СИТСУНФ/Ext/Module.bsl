﻿
#Область ПрограммныйИнтерфейс

// Определяет общие параметры функциональности Монитора Портала 1С:ИТС.
//
// Параметры:
//	ПараметрыМонитора - Структура - общие параметры Монитора:
//		* ИспользоватьОтображениеПриНачалеРаботы - Булево - управляет использованием
//			отображения Монитора при начале работы программы. Истина - использовать,
//			Ложь - не использовать. Значение по умолчанию - Истина;
//
//@skip-warning
Процедура ПриОпределенииОбщихПараметровМонитора(ПараметрыМонитора) Экспорт
	
	ПараметрыМонитора.ИспользоватьОтображениеПриНачалеРаботы = Ложь;
	
КонецПроцедуры

#КонецОбласти
