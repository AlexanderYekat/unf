﻿
#Область ПрограммныйИнтерфейс

// Определяет является ли текущее решение отраслевым решением на базе 1С:Розница
//
// Параметры:
//  ЭтоРозница	 - Булево	 - флаг показывающий является ли текущее решение отраслевым решением 1С:Розница
//
Процедура ЭтоОтраслевоеРешениеРозница(ЭтоРозница) Экспорт

КонецПроцедуры

// Позволяет дополнить стандартный список имен конфигураций семейства Розница / Управление нашей фирмой
//
// Параметры:
//  ИменаСемействаКонфигураций	 - 	Массив из Строка- в качестве элемента массива 
//                            необходимо указывать имя конфигурации, например "РозницаБазовая".
//
Процедура ПриОпределенииСпискаИменСемействаКонфигураций(ИменаСемействаКонфигураций) Экспорт

КонецПроцедуры

#КонецОбласти