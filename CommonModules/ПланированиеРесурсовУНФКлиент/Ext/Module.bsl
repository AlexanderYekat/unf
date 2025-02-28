﻿#Область ПрограммныйИнтерфейс

Функция ПолучитьМесяцПоНомеру(НомерМесяца, БезСклонения = Ложь) Экспорт
	
	СоответствиеМесяцев = Новый Соответствие();
	
	Если БезСклонения Тогда
		
		СоответствиеМесяцев.Вставить(1, "январь");
		СоответствиеМесяцев.Вставить(2, "Февраль");
		СоответствиеМесяцев.Вставить(3, "март");
		СоответствиеМесяцев.Вставить(4, "апрель");
		СоответствиеМесяцев.Вставить(5, "май");
		СоответствиеМесяцев.Вставить(6, "июнь");
		СоответствиеМесяцев.Вставить(7, "июль");
		СоответствиеМесяцев.Вставить(8, "август");
		СоответствиеМесяцев.Вставить(9, "сентябрь");
		СоответствиеМесяцев.Вставить(10, "октябрь");
		СоответствиеМесяцев.Вставить(11, "ноябрь");
		СоответствиеМесяцев.Вставить(12, "декабрь");
		
	Иначе
		
		СоответствиеМесяцев.Вставить(1, "января");
		СоответствиеМесяцев.Вставить(2, "Февраля");
		СоответствиеМесяцев.Вставить(3, "марта");
		СоответствиеМесяцев.Вставить(4, "апреля");
		СоответствиеМесяцев.Вставить(5, "мая");
		СоответствиеМесяцев.Вставить(6, "июня");
		СоответствиеМесяцев.Вставить(7, "июля");
		СоответствиеМесяцев.Вставить(8, "августа");
		СоответствиеМесяцев.Вставить(9, "сентября");
		СоответствиеМесяцев.Вставить(10, "октября");
		СоответствиеМесяцев.Вставить(11, "ноября");
		СоответствиеМесяцев.Вставить(12, "декабря");
		
	КонецЕсли;
	
	Возврат СоответствиеМесяцев.Получить(НомерМесяца);
	
КонецФункции

Функция ПредставлениеДнейНедели(ТекущиеДанные) Экспорт
	
	СтрокаПредставления = "";
	
	Если ТекущиеДанные.Пн Тогда СтрокаПредставления = " Пн," КонецЕсли;
	Если ТекущиеДанные.Вт Тогда СтрокаПредставления = СтрокаПредставления + " Вт," КонецЕсли;
	Если ТекущиеДанные.Ср Тогда СтрокаПредставления = СтрокаПредставления + " Ср," КонецЕсли;
	Если ТекущиеДанные.Чт Тогда СтрокаПредставления = СтрокаПредставления + " Чт," КонецЕсли;
	Если ТекущиеДанные.Пт Тогда СтрокаПредставления = СтрокаПредставления + " Пт," КонецЕсли;
	Если ТекущиеДанные.Сб Тогда СтрокаПредставления = СтрокаПредставления + " Сб," КонецЕсли;
	Если ТекущиеДанные.Вс Тогда СтрокаПредставления = СтрокаПредставления + " Вс" КонецЕсли;
	
	Если СтрЗаканчиваетсяНа(СтрокаПредставления, " ,") Тогда
		ДлинаСтроки = СтрДлина(СтрокаПредставления);
		СтрокаПредставления = " в "+Лев(СтрокаПредставления,ДлинаСтроки - 2);
		СтрокаПредставления = СтрокаПредставления;
	КонецЕсли;
	
	Возврат СтрокаПредставления;
	
КонецФункции

Функция ЭтоПоследняяНеделяМесяца(ДатаНедели) Экспорт
	
	МесяцДатыНедели = Месяц(ДатаНедели);
	
	Если Не МесяцДатыНедели = Месяц(КонецНедели(ДатаНедели)) 
		Или Не МесяцДатыНедели = Месяц(КонецНедели(ДатаНедели+10)) Тогда
		Возврат Истина
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

//  Предмет исчисления
//
// Параметры:
//  Число						 - Число - 
//  ПараметрыПредметаИсчисления1 - Строка - 
//  ПараметрыПредметаИсчисления2 - Строка - 
//  ПараметрыПредметаИсчисления3 - Строка - 
//  Род							 - Строка - 
// 
// Возвращаемое значение:
//  Строка - число строкой и предмет исчисления
//
Функция ПредметИсчисления(Число, ПараметрыПредметаИсчисления1, ПараметрыПредметаИсчисления2,
	ПараметрыПредметаИсчисления3, Род) Экспорт
	
	ФорматнаяСтрока = "Л = ru_RU";
	
	ПараметрыПредметаИсчисления = "%1,%2,%3,%4,,,,,0";
	ПараметрыПредметаИсчисления = СтрШаблон(
		ПараметрыПредметаИсчисления,
		ПараметрыПредметаИсчисления1,
		ПараметрыПредметаИсчисления2,
		ПараметрыПредметаИсчисления3,
		Род);
		
	ЧислоСтрокойИПредметИсчисления = НРег(ЧислоПрописью(Число, ФорматнаяСтрока, ПараметрыПредметаИсчисления));
	
	ЧислоПрописью = ЧислоСтрокойИПредметИсчисления;
	ЧислоПрописью = СтрЗаменить(ЧислоПрописью, ПараметрыПредметаИсчисления1, "");
	ЧислоПрописью = СтрЗаменить(ЧислоПрописью, ПараметрыПредметаИсчисления2, "");
		
	ПредметИсчисления = СтрЗаменить(ЧислоСтрокойИПредметИсчисления, ЧислоПрописью, "");
	
	Возврат ПредметИсчисления;
	
КонецФункции

Функция СоответствиеНомераДнюНедели(НомерДня) Экспорт
	
	СоответствиеВозврата = Новый Соответствие;
	
	СоответствиеВозврата.Вставить(1,"понедельник");
	СоответствиеВозврата.Вставить(2,"вторник");
	СоответствиеВозврата.Вставить(3,"среда");
	СоответствиеВозврата.Вставить(4,"четверг");
	СоответствиеВозврата.Вставить(5,"пятница");
	СоответствиеВозврата.Вставить(6,"суббота");
	СоответствиеВозврата.Вставить(7,"воскресенье");
	
	Возврат СоответствиеВозврата.Получить(НомерДня);
	
КонецФункции

Процедура ЗаполнитьДлительностьВТаблицеВыбранныхРесурсов(РесурсыПредприятия) Экспорт
	
	Для Каждого СтрокаТаблицы Из РесурсыПредприятия Цикл
		
		ОкончаниеПериода = ?(СтрокаТаблицы.Финиш = КонецДня(СтрокаТаблицы.Финиш), СтрокаТаблицы.Финиш +1, СтрокаТаблицы.Финиш);
		ДлительностьВМинутах = (ОкончаниеПериода - СтрокаТаблицы.Старт)/60;
		
		СтрокаТаблицы.Дни = 0;
		
		Если ДлительностьВМинутах >= 1440 Тогда
			СтрокаТаблицы.Дни = Цел(ДлительностьВМинутах/1440);
		КонецЕсли;
		
		СтрокаТаблицы.Время = Дата(1,1,1)+((ДлительностьВМинутах - СтрокаТаблицы.Дни*1440)*60);

	КонецЦикла;
	
КонецПроцедуры

// Очищает данные строки ресурсов
//
Процедура ОчиститьДанныеСтроки(ТекущиеДанные, ОчищатьДату = Истина) Экспорт
	
	ТекущиеДанные.НомерНеделиМесяца = 0;
	ТекущиеДанные.НомерМесяца = 0;
	ТекущиеДанные.ДатаПовторения = 0;
	ТекущиеДанные.ДеньНеделиМесяца = 0;
	ТекущиеДанные.ПоследнийДеньМесяца = Ложь;

	ТекущиеДанные.ВидЗавершения = Неопределено;
	ТекущиеДанные.ЗавершатьПосле = Неопределено;
	
	ТекущиеДанные.ИнтервалПовторения = 0;
	ТекущиеДанные.ВидПовтора = "Не повторять";
	ТекущиеДанные.РасшифровкаСчетчика = "";
	
	ТекущиеДанные.Пн = Ложь;
	ТекущиеДанные.Вт = Ложь;
	ТекущиеДанные.Ср = Ложь;
	ТекущиеДанные.Чт = Ложь;
	ТекущиеДанные.Пт = Ложь;
	ТекущиеДанные.Сб = Ложь;
	ТекущиеДанные.Вс = Ложь;
	
	Если ОчищатьДату Тогда
		ТекущиеДанные.Дни = 0;
		ТекущиеДанные.Время = Дата(1,1,1);
		ТекущиеДанные.Старт = Дата(1,1,1);
		ТекущиеДанные.Финиш = Дата(1,1,1);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроконтролироватьШагПланирования(ТекущиеДанные, ЭтоДатаНачала = Ложь, ИзменениеВремени = Ложь) Экспорт
	
	КратностьПланирования = ТекущиеДанные.КратностьПланирования;
	
	ОкончаниеПериода = ТекущиеДанные.Финиш;
	НачалоПериода = ТекущиеДанные.Старт;
	
	ОкончаниеПериода = ?(ОкончаниеПериода = КонецДня(ОкончаниеПериода), ОкончаниеПериода +1, ОкончаниеПериода);
	
	Если ТекущиеДанные.КонтролироватьШаг И ЗначениеЗаполнено(КратностьПланирования) Тогда
		
		РазностьДат = ОкончаниеПериода - НачалоПериода;
		
		КратностьПланированияВСек = КратностьПланирования*60;
		КоличествоВхожденийКратностиВИнтервал = Окр(РазностьДат/КратностьПланированияВСек,0, РежимОкругления.Окр15как20);
		
		Если ЭтоДатаНачала Тогда
			НачалоПериода = ОкончаниеПериода - ?(КоличествоВхожденийКратностиВИнтервал <= 0,1,КоличествоВхожденийКратностиВИнтервал) * КратностьПланированияВСек;
		Иначе
			ОкончаниеПериода = НачалоПериода + ?(КоличествоВхожденийКратностиВИнтервал <= 0,1,КоличествоВхожденийКратностиВИнтервал) * КратностьПланированияВСек;
		КонецЕсли;
		
		ДлительностьВМинутах = (ОкончаниеПериода - НачалоПериода)/60;
		
		ТекущиеДанные.Дни = 0;
		ТекущиеДанные.Время = 0;
		
		Если ДлительностьВМинутах >= 1440 Тогда
			ТекущиеДанные.Дни = Цел(ДлительностьВМинутах/1440);
		КонецЕсли;
		
		ТекущиеДанные.Время = Дата(1,1,1)+((ДлительностьВМинутах - ТекущиеДанные.Дни*1440)*60);
		
		ТекущиеДанные.Финиш = ОкончаниеПериода;
		ТекущиеДанные.Старт = НачалоПериода;
		
	Иначе
		
		ДлительностьВМинутах = (ОкончаниеПериода - НачалоПериода)/60;
		
		Если Не ИзменениеВремени Тогда
			ДлительностьВМинутах = (ОкончаниеПериода - НачалоПериода)/60;
			
			ТекущиеДанные.Дни = 0;
			ТекущиеДанные.Время = 0;
			
			Если ДлительностьВМинутах >= 1440 Тогда
				ТекущиеДанные.Дни = Цел(ДлительностьВМинутах/1440);
			КонецЕсли;
			
			ТекущиеДанные.Время = Дата(1,1,1)+((ДлительностьВМинутах - ТекущиеДанные.Дни*1440)*60);
		КонецЕсли;
		
	КонецЕсли;
	
	ТекущиеДанные.Финиш = ?(НачалоДня(ТекущиеДанные.Финиш)> НачалоДня(ТекущиеДанные.Старт) И ТекущиеДанные.Финиш = НачалоДня(ТекущиеДанные.Финиш), ТекущиеДанные.Финиш - 1, ТекущиеДанные.Финиш);
	
КонецПроцедуры

#КонецОбласти