﻿#Область ПрограммныйИнтерфейс

// Переопределяются идентификаторы внешних компонент, которые используются в конфигурации.
// Указанные внешние компоненты будут загружены при обработке поставляемых данных.
//
// Параметры:
//  Идентификаторы - Массив из Строка - содержит идентификаторы внешних компоненты.
//
//@skip-warning
Процедура ПриОпределенииИспользуемыхВерсийВнешнихКомпонент(Идентификаторы) Экспорт
	
	Идентификаторы.Добавить("XMLDSignAddIn");
	Идентификаторы.Добавить("ExtraCryptoAPI");
	
	ЭлектронноеВзаимодействие.ПриОпределенииИспользуемыхВерсийВнешнихКомпонент(Идентификаторы);
	
КонецПроцедуры

#КонецОбласти
