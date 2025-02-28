﻿
#Область СлужебныйПрограммныйИнтерфейс

// Добавляет в список поставляемые драйверы в составе конфигурации.
// 
// Параметры:
//  ДрайвераОборудования - см. МенеджерОборудования.НоваяТаблицаПоставляемыхДрайверовОборудования
//
Процедура ОбновитьПоставляемыеДрайвера(ДрайвераОборудования) Экспорт
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ДисплейПокупателя;
	Драйвер.ИмяДрайвера  = "Драйвер1СДисплейПокупателя";
	Драйвер.Наименование = НСтр("ru = '1С:Дисплей покупателя'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "CustomerDisplayEx"; 
	Драйвер.ВерсияДрайвера = "5.1.2.2";
	
	// ++ НеМобильноеПриложение
	// ++ Локализация  
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ДисплейПокупателя;
	Драйвер.ИмяДрайвера  = "ДрайверАТОЛДисплеиПокупателя8X";
	Драйвер.Наименование = НСтр("ru = 'АТОЛ:Дисплеи покупателя 8.X'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ATOL_Line_1CInt"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ДисплейПокупателя;
	Драйвер.ИмяДрайвера  = "ДрайверPOSUAДисплеиПокупателя";
	Драйвер.Наименование = НСтр("ru = 'POSUA:Дисплеи покупателя'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "LPOSVFD"; 
	Драйвер.ВерсияДрайвера = "1.0.8.0"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ДисплейПокупателя;
	Драйвер.ИмяДрайвера  = "Драйвер1СРарусДисплеиПокупателя";
	Драйвер.Наименование = НСтр("ru = '1С-Рарус:Дисплеи покупателя'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "d_android1c83"; 
	Драйвер.ВерсияДрайвера = "1.0.15.54"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ДисплейПокупателя;
	Драйвер.ИмяДрайвера  = "ДрайверСканкодДисплеиПокупателяNative";
	Драйвер.Наименование = НСтр("ru = 'Сканкод:Дисплеи покупателя (Native API)'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "DSPPromag8"; 
	Драйвер.ВерсияДрайвера = "1.0.0.3"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ДисплейПокупателя;
	Драйвер.ИмяДрайвера  = "ДрайверКристаллСервисДисплеиПокупателяVikiVision";
	Драйвер.Наименование = НСтр("ru = 'Кристалл Сервис:Дисплей покупателя Viki Vision'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "VikiVision"; 
	Драйвер.ВерсияДрайвера = "1.03"; 

	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ДисплейПокупателя;
	Драйвер.ИмяДрайвера  = "ДрайверККСДисплеиПокупателя";
	Драйвер.Наименование = НСтр("ru = 'ККС:Дисплеи покупателя'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "VFCD220E"; 
	Драйвер.ВерсияДрайвера = "1.0.1.1"; 
	Драйвер.СнятСПоддержки = Истина;
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ДисплейПокупателя;
	Драйвер.ИмяДрайвера  = "ДрайверЭвоторДисплейПокупателя";
	Драйвер.Наименование = НСтр("ru = 'Эвотор:Дисплей покупателя'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "EvoKKMExtension36"; 
	Драйвер.ВерсияДрайвера = "1.9.412.3006"; 
	Драйвер.ИмяМакетаДрайвера = "ДрайверЭвоторККТ54ФЗ";
	// -- Локализация      
	// -- НеМобильноеПриложение     
	
КонецПроцедуры

// Подготовить данные операции.
// 
// Параметры:
//  ПараметрыПодключения - Структура -Параметры подключения
//  Команда - Строка - Команда
//  ПараметрыОперации - Структура -Параметры операции
// 
// Возвращаемое значение:
//  Неопределено.
Функция ПодготовитьДанныеОперации(ПараметрыПодключения, Команда, ПараметрыОперации) Экспорт
	
	ДанныеОперации = ПараметрыОперацииДисплеиПокупателя(); 
	ДанныеОперации.ТекстHTML = "<p>No information</p>";
	Если ПараметрыПодключения.ДисплейОтображаетHTML Тогда
		ФорматЧисла = "ЧДЦ=2; ЧРД=.; ЧН=0.00";
		ФорматЧислаТаблица = "ЧРД=.;ЧЦ=12;ЧДЦ=2;ЧН=0.00;ЧГ=0";
	Иначе
		ФорматЧисла = "ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧГ=0";
		ФорматЧислаТаблица = "ЧРД=.;ЧЦ=12;ЧДЦ=2;ЧН=0.00;ЧГ=0";
	КонецЕсли;

	// ++ НеМобильноеПриложение
	Если Команда = "DisplayInfo" Тогда      
		
		Если ПараметрыОперации.Операция = "СервисныйРежим" Тогда
			
			Если ПараметрыОперации.ГотовностьКРаботе Тогда
				СтрокиТекста = НСтр("ru='ДОБРО ПОЖАЛОВАТЬ!'"); // АПК: 374 - интерфейсная особенность
				СтатусОперации = Перечисления.СтатусОперацииНаДисплее.ВыполненоУспешно;
				ТекстОперации = НСтр("ru = 'ГОТОВ К ПРОДАЖЕ'");
			ИначеЕсли НЕ ПараметрыОперации.ГотовностьКРаботе Тогда
				СтрокиТекста = НСтр("ru='КАССА НЕ РАБОТАЕТ!'"); // АПК: 374 - интерфейсная особенность
				СтатусОперации = Перечисления.СтатусОперацииНаДисплее.ОперацияНеВыполнена;
				ТекстОперации = НСтр("ru = 'НЕДОСТУПНО'");
			Иначе                                                    
				СтрокиТекста = НСтр("ru='СЕРВИСНЫЙ РЕЖИМ'");
				СтатусОперации = Перечисления.СтатусОперацииНаДисплее.ОжиданиеОперации;
				ТекстОперации = НСтр("ru = 'НЕДОСТУПНО'");
			КонецЕсли;
			
			ШаблонДисплеиПокупателя = МенеджерОборудованияПовтИсп.СодержимоеОбщегоМакета("ШаблонДисплеяПокупателя");     
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%TITLE%", " ");
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%CAPTION%", XMLСтрока(ПараметрыОперации.НазваниеОрганизации));
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%OPERATION%", ТекстОперации);     
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%DESC%", " ");     
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%INFO%", СтрокиТекста);  
			// ++ Локализация
			Если ПараметрыОперации.ГотовностьКРаботе Тогда
				ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%MP_INFO%", НСтр("ru = 'Для поверки чеков используйте<br>Мои чеки онлайн'"));  
				ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "<!--BOTTOM_MP2", "");          
				ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "BOTTOM_MP2-->", "");
			КонецЕсли;
			// -- Локализация
			ОбновитьСтатус(ШаблонДисплеиПокупателя, СтатусОперации);   
			ДанныеОперации.СтатусОперации = СтатусОперации;
			
			// Текст на обычный дисплей покупателя
			Если ПустаяСтрока(ПараметрыОперации.СтрокиТекста) Тогда
				ДанныеОперации.СтрокиТекста = СтрокиТекста; 
			Иначе
				ДанныеОперации.СтрокиТекста = ПараметрыОперации.СтрокиТекста;
			КонецЕсли;
			
		ИначеЕсли ПараметрыОперации.Операция = "Информация" Тогда   
			
			СтрокиТекста = ПараметрыОперации.СтрокиТекста;
			СтрокиТекста = СтрЗаменить(СтрокиТекста, Символы.ПС, "<br>"); 
			
			ШаблонДисплеиПокупателя = МенеджерОборудованияПовтИсп.СодержимоеОбщегоМакета("ШаблонДисплеяПокупателя");     
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%TITLE%", " ");
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%CAPTION%", XMLСтрока(ПараметрыОперации.НазваниеОрганизации));
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%OPERATION%", НСтр("ru = 'ИНФОРМАЦИЯ'"));     
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%DESC%", " ");     
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%INFO%", СтрокиТекста);   
			Если ПустаяСтрока(ПараметрыОперации.КартинкаBase64) Тогда                                   
				ОбновитьСтатус(ШаблонДисплеиПокупателя, ПараметрыОперации.СтатусОперации);    
			Иначе
				ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%QR%", ПараметрыОперации.КартинкаBase64);    
			КонецЕсли;                                            
			ДанныеОперации.СтатусОперации = ПараметрыОперации.СтатусОперации;
			
			// Текст на обычный дисплей покупателя
			ДанныеОперации.СтрокиТекста = ПараметрыОперации.СтрокиТекста; 
			
		ИначеЕсли ПараметрыОперации.Операция = "ПлатежнаяОперация" Тогда   
			
			ШаблонДисплеиПокупателя = МенеджерОборудованияПовтИсп.СодержимоеОбщегоМакета("ШаблонДисплеяПокупателя");   
			
			Если ПараметрыОперации.СтатусОперации = Перечисления.СтатусОперацииНаДисплее.ВыполненоУспешно Тогда
				СтатусТекс = НСтр("ru='УСПЕШНО'");
			ИначеЕсли ПараметрыОперации.СтатусОперации = Перечисления.СтатусОперацииНаДисплее.ОперацияНеВыполнена Тогда
				СтатусТекс = НСтр("ru='ОТКАЗ'");
			ИначеЕсли ПараметрыОперации.СтатусОперации = Перечисления.СтатусОперацииНаДисплее.ОжиданиеОперации Тогда
				Если ПараметрыОперации.Возврат Тогда
					СтатусТекс = НСтр("ru='ОЖИДАНИЕ ВОЗВРАТА ОПЛАТЫ'");
				Иначе
					СтатусТекс = НСтр("ru='ОЖИДАНИЕ ОПЛАТЫ'");
				КонецЕсли;
			ИначеЕсли ПараметрыОперации.СтатусОперации = Перечисления.СтатусОперацииНаДисплее.Информация Тогда
				СтатусТекс = НСтр("ru='ИНФОРМАЦИЯ'");         
			КонецЕсли; 
					
			Если ПараметрыОперации.НаличнаяОплата Тогда
				Если ПараметрыОперации.Возврат Тогда
					ТипПлатежнойСистемы = НСтр("ru='НАЛИЧНЫЕ'"); 
				Иначе
					ТипПлатежнойСистемы = НСтр("ru='НАЛИЧНАЯ ОПЛАТА'"); 
				КонецЕсли;
			ИначеЕсли Не ПустаяСтрока(ПараметрыОперации.ТипПлатежнойСистемы) Тогда
				ТипПлатежнойСистемы = Строка(ПараметрыОперации.ТипПлатежнойСистемы)
			Иначе
				Если ПараметрыОперации.Возврат Тогда
					ТипПлатежнойСистемы = НСтр("ru='БЕЗНАЛИЧНЫЙ ВОЗВРАТ'"); 
				Иначе
					ТипПлатежнойСистемы = НСтр("ru='БЕЗНАЛИЧНАЯ ОПЛАТА'");      
				КонецЕсли;
			КонецЕсли;                                                     
			
			Если (ПараметрыОперации.ТипПлатежнойСистемы = Перечисления.ТипыПлатежнойСистемыККТ.СистемаБыстрыхПлатежей 
				Или ПараметрыОперации.ТипПлатежнойСистемы = Перечисления.ТипыПлатежнойСистемыККТ.ЮКасса)
				И ПараметрыОперации.СтатусОперации = Перечисления.СтатусОперацииНаДисплее.ОжиданиеОперации Тогда      
				Если ПараметрыОперации.ТипПлатежнойСистемы = Перечисления.ТипыПлатежнойСистемыККТ.СистемаБыстрыхПлатежей  Тогда
					Комментарий = НСтр("ru='Для совершения платежа отсканируйте QR-код'");
				ИначеЕсли ПараметрыОперации.ТипПлатежнойСистемы = Перечисления.ТипыПлатежнойСистемыККТ.ЮКасса Тогда
					Комментарий = НСтр("ru='Для входа в личный кабинет отсканируйте QR-код'");
				КонецЕсли;
				Если Не ПустаяСтрока(ПараметрыОперации.ЗначениеQRКода) Тогда
					ПараметрыШтрихкода = ГенерацияШтрихкода.ПараметрыГенерацииШтрихкода();
					ПараметрыШтрихкода.Ширина = 300;
					ПараметрыШтрихкода.Высота = 300;
					ПараметрыШтрихкода.ТипКода = 16; // QR
					ПараметрыШтрихкода.Штрихкод = ПараметрыОперации.ЗначениеQRКода;
					ПараметрыШтрихкода.УбратьЛишнийФон = Истина;    
					РезультатШтрихкод = ГенерацияШтрихкода.ИзображениеШтрихкода(ПараметрыШтрихкода);
					КартинкаBase64 = Base64Строка(РезультатШтрихкод.ДвоичныеДанные);       
					ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%QR%", КартинкаBase64);    
					ДанныеОперации.ЗначениеQRКода = ПараметрыОперации.ЗначениеQRКода;
				КонецЕсли;                                                     
			Иначе
				ОбновитьСтатус(ШаблонДисплеиПокупателя, ПараметрыОперации.СтатусОперации);
			КонецЕсли; 
			
			Если ПустаяСтрока(ПараметрыОперации.ДополнительныйТекст) Тогда             
				Если (ПараметрыОперации.СтатусОперации = Перечисления.СтатусОперацииНаДисплее.ВыполненоУспешно 
					Или ПараметрыОперации.СтатусОперации = Перечисления.СтатусОперацииНаДисплее.ОжиданиеОперации) 
					И ПараметрыОперации.НаличнаяОплата И ПараметрыОперации.Сдача > 0 Тогда
					ОперацияОписание = НСтр("ru='СДАЧА'");     
					ОперацияИнфо = Формат(ПараметрыОперации.Сдача, ФорматЧисла);  
				Иначе
					ОперацияОписание = НСтр("ru='СУММА'");     
					ОперацияИнфо = Формат(ПараметрыОперации.Сумма, ФорматЧисла);  
				КонецЕсли;   
			Иначе
				ОперацияОписание = ПараметрыОперации.ДополнительныйТекст;  
				ОперацияИнфо = " ";     
			КонецЕсли;                                                     
			
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%DESC%", ОперацияОписание);  
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%INFO%", ОперацияИнфо);     
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%TITLE%", "");
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%CAPTION%", ТипПлатежнойСистемы);
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%OPERATION%", СтатусТекс);    
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%COMMENT%", Комментарий);    
			ДанныеОперации.СтатусОперации = ПараметрыОперации.СтатусОперации;
			
			// Текст на обычный дисплей покупателя
			Если ПустаяСтрока(ПараметрыОперации.СтрокиТекста) Тогда
				ДанныеОперации.СтрокиТекста = НСтр("ru='ПЛАТЕЖНАЯ ОПЕРАЦИЯ'") + Символы.ПС + СтатусТекс;
			Иначе
				ДанныеОперации.СтрокиТекста = ПараметрыОперации.СтрокиТекста;
			КонецЕсли;
			
		ИначеЕсли ПараметрыОперации.Операция = "СписокТоваров" Тогда 
			
			ШаблонДисплеиПокупателя = МенеджерОборудованияПовтИсп.СодержимоеОбщегоМакета("ШаблонДисплеяПокупателяЧек");
			КолонкиТабличнойЧасти = ПараметрыОперации.КолонкиТабличнойЧасти;
			ЗаголовокТаблицы = "<tr>"; 
			ШаблонСтроки = "";  
			Ширина = 10;
			ВыводитьПодвалСкидка = Ложь;
			Для Каждого КолонкаТабличнойЧасти Из ПараметрыОперации.КолонкиТабличнойЧасти Цикл                                        
				Если ВРег(КолонкаТабличнойЧасти.Имя) = НСтр("ru = 'СКИДКА'") Тогда
					ВыводитьПодвалСкидка = Истина;
				КонецЕсли;
				Ширина = Строка(?(КолонкаТабличнойЧасти.Ширина > 0, КолонкаТабличнойЧасти.Ширина, 10));
				Заголовок = КолонкаТабличнойЧасти.Заголовок;
				ЗаголовокТаблицы = ЗаголовокТаблицы + СтрШаблон("<td %1 width=""%2"">%3</td>", 
					СтрокаВыравнивания(КолонкаТабличнойЧасти.Выравнивание),
					Ширина + "%", 
					Заголовок);   
				ШаблонСтроки = ШаблонСтроки + СтрШаблон("<td %1 width=""%2"">%3</td>", 
					СтрокаВыравнивания(КолонкаТабличнойЧасти.Выравнивание), 
					Ширина + "%", 
					"%" + КолонкаТабличнойЧасти.Имя + "%");   
			КонецЦикла;                                                        
			ШаблонСтроки = ШаблонСтроки;
			ЗаголовокТаблицы = ЗаголовокТаблицы  + "</tr>";
			
			ТабличнаяЧасть = "";
			
			КоличествоСтрок = ПараметрыОперации.ТабличнаяЧасть.Количество();
			ТекущаяСтрока = 1;
			Для Каждого СтрокаТабличнаяЧасть Из ПараметрыОперации.ТабличнаяЧасть Цикл 
				ТекстСтроки = СтрШаблон("<tr %1>", ?(ТекущаяСтрока = КоличествоСтрок, "position_anchor=""true"" style=""background: #D5EAFF""", "")) + ШаблонСтроки;
				Для Каждого СтрокаТаблицы Из СтрокаТабличнаяЧасть Цикл    
					ТекстСтроки = СтрЗаменить(ТекстСтроки, "%" + СтрокаТаблицы.Ключ + "%", СтрокаТаблицы.Значение);
				КонецЦикла;            
				ТекстСтроки = ТекстСтроки + "</tr>";
				ТабличнаяЧасть = ТабличнаяЧасть + ТекстСтроки;
				ТекущаяСтрока = ТекущаяСтрока + 1;
			КонецЦикла;     
			
			ПодвалСкидка = "";
			Если ВыводитьПодвалСкидка Или ПараметрыОперации.ПодвалСкидка > 0 Тогда
				ПодвалСкидка = СтрШаблон("<tr><td align=""right"" colspan=""%1"">%2</td><td align=""right"" width=""%3"">%4</td></tr>", 
					КолонкиТабличнойЧасти.Количество() - 1, 
					НСтр("ru='Скидка'"),
					Ширина + "%",
					Формат(ПараметрыОперации.ПодвалСкидка, ФорматЧислаТаблица));
			КонецЕсли;
			ПодвалТаблицы = ПодвалСкидка + СтрШаблон("<tr><td align=""right"" colspan=""%1"">%2</td><td align=""right"" width=""%3"">%4</td></tr>", 
				КолонкиТабличнойЧасти.Количество() - 1, 
				НСтр("ru='Итого'"),
				Ширина + "%",
				Формат(ПараметрыОперации.ПодвалСумма, ФорматЧислаТаблица));
			
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "<!--Head-->" , ЗаголовокТаблицы);
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "<!--Table-->", ТабличнаяЧасть);        
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "<!--Foot-->" , ПодвалТаблицы);  
			
			// Текст на обычный дисплей покупателя
			Если ПустаяСтрока(ПараметрыОперации.СтрокиТекста) Тогда
				ДанныеОперации.СтрокиТекста = НСтр("ru='ИТОГО:'") + " " + Формат(ПараметрыОперации.ПодвалСумма, ФорматЧисла);  
			Иначе
				ДанныеОперации.СтрокиТекста = ПараметрыОперации.СтрокиТекста;
			КонецЕсли;
				
		ИначеЕсли ПараметрыОперации.Операция = "ФискальныйЧек" Тогда
			
			Если Не ПустаяСтрока(ПараметрыОперации.ЗначениеQRКода) Тогда          
				ПараметрыШтрихкода = ГенерацияШтрихкода.ПараметрыГенерацииШтрихкода();
				ПараметрыШтрихкода.Ширина = 400;
				ПараметрыШтрихкода.Высота = 400;
				ПараметрыШтрихкода.ТипКода = 16; // QR
				ПараметрыШтрихкода.Штрихкод = ПараметрыОперации.ЗначениеQRКода;
				ПараметрыШтрихкода.УбратьЛишнийФон = Истина;    
				РезультатШтрихкод = ГенерацияШтрихкода.ИзображениеШтрихкода(ПараметрыШтрихкода);
				КартинкаBase64 = Base64Строка(РезультатШтрихкод.ДвоичныеДанные);       
				ДанныеОперации.ЗначениеQRКода = ПараметрыОперации.ЗначениеQRКода;
			КонецЕсли;       
			
			// Текст на обычный дисплей покупателя
			Если ПустаяСтрока(ПараметрыОперации.СтрокиТекста) Тогда
				ДанныеОперации.СтрокиТекста = НСтр("ru='СПАСИБО ЗА ПОКУПКУ!'");
			Иначе
				ДанныеОперации.СтрокиТекста = ПараметрыОперации.СтрокиТекста;
			КонецЕсли;
			
			ШаблонДисплеиПокупателя = МенеджерОборудованияПовтИсп.СодержимоеОбщегоМакета("ШаблонДисплеяПокупателя");    
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%TITLE%", "");
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%CAPTION%", НСтр("ru='Получите электронный чек'"));
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%OPERATION%", НСтр("ru='СПАСИБО ЗА ПОКУПКУ'"));     
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%DESC%", НСтр("ru='Сканируйте QR-код <br> в мобильном приложении'"));     
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%INFO%", "");   
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%QR%", КартинкаBase64);    
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "<!--MP", "");          
			ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "MP-->", "");
			ДанныеОперации.СтатусОперации = ПараметрыОперации.СтатусОперации;
			
			
		КонецЕсли;
		
		ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "%COMMENT%", "");    
		ДанныеОперации.ТекстHTML = ШаблонДисплеиПокупателя;
			
	КонецЕсли;
	
	ДанныеОперации.Вставить("КодСтатусОперации", СтатусОперацииНаДисплее(ПараметрыОперации.СтатусОперации));
	ДанныеОперации.Вставить("КодСтатусаРабочегоМеста", ПараметрыОперации.КодСтатусаРабочегоМеста);
	// -- НеМобильноеПриложение 
	
	Возврат ДанныеОперации;       
	
КонецФункции

Процедура ОбработатьДанныеОперации(ПараметрыПодключения, Команда, РезультатВыполнения, ДанныеОперации) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции   

// Заполнить структуру операции
// 
// Возвращаемое значение:
//  Структура - Параметры операции:
// * Результат - Булево.
// * ТекстОшибки - Строка.
Функция ПараметрыОперацииДисплеиПокупателя()
	
	ПараметрыОперации = Новый Структура();
	ПараметрыОперации.Вставить("Результат", Истина); 
	ПараметрыОперации.Вставить("СтрокиТекста");    
	ПараметрыОперации.Вставить("ЗначениеQRКода"); // Строка - значение QR кода
	ПараметрыОперации.Вставить("КартинкаQRКода"); // Строка - строка с base64 представлением png картинки логотипа.      
	ПараметрыОперации.Вставить("СтатусОперации", 0); // Число - Статус: 0-Не установлены, 1-Выполнено успешно, 2-Операция не выполнена
	ПараметрыОперации.Вставить("КодСтатусаРабочегоМеста");
	ПараметрыОперации.Вставить("ТекстОшибки");     
	ПараметрыОперации.Вставить("ТекстHTML");
	Возврат ПараметрыОперации;
	
КонецФункции 

// ++ НеМобильноеПриложение 

Процедура ОбновитьСтатус(ШаблонДисплеиПокупателя, СтатусОперации) 
	
	Если СтатусОперации = Перечисления.СтатусОперацииНаДисплее.ВыполненоУспешно Тогда
		ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "<!--OK", "");
		ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "OK-->", "");
	ИначеЕсли СтатусОперации = Перечисления.СтатусОперацииНаДисплее.ОперацияНеВыполнена Тогда
		ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "<!--FAIL", "");
		ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "FAIL-->", "");
	ИначеЕсли СтатусОперации = Перечисления.СтатусОперацииНаДисплее.ОжиданиеОперации Тогда
		ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "<!--WAIT", "");
		ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "WAIT-->", "");
	ИначеЕсли СтатусОперации = Перечисления.СтатусОперацииНаДисплее.Информация Тогда
		ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "<!--INFO", "");
		ШаблонДисплеиПокупателя = СтрЗаменить(ШаблонДисплеиПокупателя, "INFO-->", "");
	КонецЕсли; 
	
КонецПроцедуры

Функция СтрокаВыравнивания(Выравнивание)
	
	Если Выравнивание = ГоризонтальноеПоложение.Лево Тогда 
		Результат = "align=""left""";
	ИначеЕсли Выравнивание = ГоризонтальноеПоложение.Право Тогда 
		Результат = "align=""right""";
	Иначе
		Результат = "align=""center""";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// -- НеМобильноеПриложение 

// Код статуса операции на дисплее.
// 
// Параметры:    
//   ПеречислениеСсылка.СтатусОперацииНаДисплее - Cтатус операции на дисплее
// Возвращаемое значение:
//   КодСтатуса - Число - Код статуса.
//
Функция СтатусОперацииНаДисплее(СтатусОперации) Экспорт
	
	Если СтатусОперации = Неопределено Тогда
		КодСтатуса = 0
	Иначе
		СтатусыОперации = Новый Соответствие(); 
		СтатусыОперации.Вставить(Перечисления.СтатусОперацииНаДисплее.ВыполненоУспешно   , 0);
		СтатусыОперации.Вставить(Перечисления.СтатусОперацииНаДисплее.ВыполненоУспешно   , 1);
		СтатусыОперации.Вставить(Перечисления.СтатусОперацииНаДисплее.ОперацияНеВыполнена, 2);
		СтатусыОперации.Вставить(Перечисления.СтатусОперацииНаДисплее.ОжиданиеОперации   , 3);
		СтатусыОперации.Вставить(Перечисления.СтатусОперацииНаДисплее.Информация         , 4);
		КодСтатуса = СтатусыОперации.Получить(СтатусОперации);
	КонецЕсли;
	
	Возврат КодСтатуса;
	
КонецФункции

#КонецОбласти