﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Предопределенный Тогда
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("КодПоОКЗ"));
	Иначе
		
		Если ЗначениеЗаполнено(КодПрофессиональнойДеятельности) Тогда
			Если СтрДлина(СокрЛП(КодПрофессиональнойДеятельности)) < 10 Тогда 
				ОбщегоНазначения.СообщитьПользователю(
					Нстр("ru = 'Неверно заполнен Код профессиональной деятельности - недостаточно символов.'"), 
					ЭтотОбъект, "КодПрофессиональнойДеятельности", , Отказ);
			ИначеЕсли Не ЗначениеЗаполнено(Сред(КодПрофессиональнойДеятельности, 8, 1))
				Или (Не СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(Сред(КодПрофессиональнойДеятельности, 8, 1))
				И Не СтроковыеФункцииКлиентСерверРФ.ТолькоКириллицаВСтроке(Сред(КодПрофессиональнойДеятельности, 8, 1))) Тогда
				ОбщегоНазначения.СообщитьПользователю(
					Нстр("ru = 'Неверно заполнен Код профессиональной деятельности - восьмым символом должна быть буква.'"), 
					ЭтотОбъект, "КодПрофессиональнойДеятельности", , Отказ);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли