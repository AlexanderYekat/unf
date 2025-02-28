﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при нажатии на гиперссылку или двойном щелчке на ячейке 
// табличного документа с описанием изменений системы (общий макет ОписаниеИзмененийСистемы).
//
// Параметры:
//   Область - ОбластьЯчеекТабличногоДокумента - область документа, на 
//             которой произошло нажатие.
//
Процедура ПриНажатииНаГиперссылкуВДокументеОписанияОбновлений(Знач Область) Экспорт
	
	

КонецПроцедуры

// Вызывается в обработчике ПередНачаломРаботыСистемы, проверяет возможность
// обновления на текущую версию программы.
//
// Параметры:
//  ВерсияДанных - Строка - версия данных основной конфигурации, с которой выполняется обновление
//                          (из регистра сведений ВерсииПодсистем).
//
Процедура ПриОпределенииВозможностиОбновления(Знач ВерсияДанных) Экспорт
	
	ДопустимаяВерсия = "1.6.25.226";
	
	Результат = ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияДанных, ДопустимаяВерсия);
	Если ВерсияДанных <> "0.0.0.0" И Результат < 0 Тогда
		Сообщение = НСтр("ru = 'Обновление на текущую версию допустимо только с версии %1 и выше.
			|(Недопустимая попытка обновления с версии %2)
			|Необходимо восстановить информационную базу из резервной копии
			|и повторить обновление согласно файлу 1cv8upd.htm'");
		Сообщение = СтрШаблон(Сообщение, ДопустимаяВерсия, ВерсияДанных);
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
