﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция НормативныйДокумент(Значение) Экспорт
	
	Если Значение = ФЗ79 Тогда
		
		Возврат НСтр("ru = 'Федеральный закон от 27.07.2004 № 79-ФЗ ""О государственной гражданской службе Российской Федерации""'");
		
	ИначеЕсли Значение = ЗРФ31321 Тогда
		
		Возврат НСтр("ru = 'Закон РФ от 26.06.1992 № 3132-1 ""О статусе судей в Российской Федерации""'");
		
	ИначеЕсли Значение = ФЗ25 Тогда
		
		Возврат НСтр("ru = 'Федеральный закон от 02.03.2007 № 25-ФЗ ""О муниципальной службе в Российской Федерации""'");
		
	ИначеЕсли Значение = ФЗ41 Тогда
		
		Возврат НСтр("ru = 'Федеральный закон от 08.05.1996 № 41-ФЗ ""О производственных кооперативах""'");
		
	ИначеЕсли Значение = ФЗ328 Тогда
		
		Возврат НСтр("ru = 'Федеральный закон от 01.10.2019 № 328-ФЗ ""О службе в органах принудительного исполнения Российской Федерации и внесении изменений в отдельные законодательные акты Российской Федерации""'");
		
	ИначеЕсли Значение = ФЗ342 Тогда
		
		Возврат НСтр("ru = 'Федеральный закон от 30.11.2011 № 342-ФЗ ""О службе в органах внутренних дел Российской Федерации и внесении изменений в отдельные законодательные акты Российской Федерации""'");
		
	ИначеЕсли Значение = ФЗ113 Тогда
		
		Возврат НСтр("ru = 'Федеральный закон от 25.07.2002 № 113-ФЗ ""Об альтернативной гражданской службе""'");
		
	ИначеЕсли Значение = УИКРФ Тогда
		
		Возврат НСтр("ru = 'Уголовно-исполнительный кодекс Российской Федерации'");
		
	ИначеЕсли Значение = ФЗ114 Тогда
		
		Возврат НСтр("ru = 'Федеральный закон от 21.07.1997 № 114-ФЗ ""О службе в таможенных органах Российской Федерации""'");
		
	ИначеЕсли Значение = ФЗ141 Тогда
		
		Возврат НСтр("ru = 'Федеральный закон от 23.05.2016 № 141-ФЗ ""О службе в федеральной противопожарной службе Государственной противопожарной службы и внесении изменений в отдельные законодательные акты Российской Федерации""'");
		
	ИначеЕсли Значение = ФЗ197 Тогда
		
		Возврат НСтр("ru = 'Федеральный закон от 19.07.2018 № 197-ФЗ ""О службе в уголовно-исполнительной системе Российской Федерации и о внесении изменений в Закон Российской Федерации ""Об учреждениях и органах, исполняющих уголовные наказания в виде лишения свободы""'");
		
	ИначеЕсли Значение = ФЗ403 Тогда
		
		Возврат НСтр("ru = 'Федеральный закон от 28.12.2010 № 403-ФЗ ""О Следственном комитете Российской Федерации""'");
		
	ИначеЕсли Значение = ФЗ53 Тогда
		
		Возврат НСтр("ru = 'Федеральный закон от 28.03.1998 № 53-ФЗ ""О воинской обязанности и военной службе""'");

	КонецЕсли;
	
	Возврат НСтр("ru = 'Трудовой кодекс Российской Федерации'");
	
КонецФункции

Функция НормативныйДокументВРодительномПадеже(Значение) Экспорт
	
	Если Значение = ФЗ79 Тогда
		
		Возврат НСтр("ru = 'Федерального закона от 27.07.2004 № 79-ФЗ ""О государственной гражданской службе Российской Федерации""'");
		
	ИначеЕсли Значение = ЗРФ31321 Тогда
		
		Возврат НСтр("ru = 'Закона РФ от 26.06.1992 № 3132-1 ""О статусе судей в Российской Федерации""'");
		
	ИначеЕсли Значение = ФЗ25 Тогда
		
		Возврат НСтр("ru = 'Федерального закона от 02.03.2007 № 25-ФЗ ""О муниципальной службе в Российской Федерации""'");
		
	ИначеЕсли Значение = ФЗ41 Тогда
		
		Возврат НСтр("ru = 'Федерального закона от 08.05.1996 № 41-ФЗ ""О производственных кооперативах""'");
		
	ИначеЕсли Значение = ФЗ328 Тогда
		
		Возврат НСтр("ru = 'Федерального закона от 01.10.2019 № 328-ФЗ ""О службе в органах принудительного исполнения Российской Федерации и внесении изменений в отдельные законодательные акты Российской Федерации""'");
		
	ИначеЕсли Значение = ФЗ342 Тогда
		
		Возврат НСтр("ru = 'Федерального закона от 30.11.2011 № 342-ФЗ ""О службе в органах внутренних дел Российской Федерации и внесении изменений в отдельные законодательные акты Российской Федерации""'");
		
	ИначеЕсли Значение = ФЗ113 Тогда
		
		Возврат НСтр("ru = 'Федерального закона от 25.07.2002 № 113-ФЗ ""Об альтернативной гражданской службе""'");
		
	ИначеЕсли Значение = УИКРФ Тогда
		
		Возврат НСтр("ru = 'Уголовно-исполнительного кодекса Российской Федерации'");
		
	ИначеЕсли Значение = ФЗ114 Тогда
		
		Возврат НСтр("ru = 'Федерального закона от 21.07.1997 № 114-ФЗ ""О службе в таможенных органах Российской Федерации""'");
		
	ИначеЕсли Значение = ФЗ141 Тогда
		
		Возврат НСтр("ru = 'Федерального закона от 23.05.2016 № 141-ФЗ ""О службе в федеральной противопожарной службе Государственной противопожарной службы и внесении изменений в отдельные законодательные акты Российской Федерации""'");
		
	ИначеЕсли Значение = ФЗ197 Тогда
		
		Возврат НСтр("ru = 'Федерального закона от 19.07.2018 № 197-ФЗ ""О службе в уголовно-исполнительной системе Российской Федерации и о внесении изменений в Закон Российской Федерации ""Об учреждениях и органах, исполняющих уголовные наказания в виде лишения свободы""'");
		
	ИначеЕсли Значение = ФЗ403 Тогда
		
		Возврат НСтр("ru = 'Федерального закона от 28.12.2010 № 403-ФЗ ""О Следственном комитете Российской Федерации""'");
		
	ИначеЕсли Значение = ФЗ53 Тогда
		
		Возврат НСтр("ru = 'Федерального закона от 28.03.1998 № 53-ФЗ ""О воинской обязанности и военной службе""'");

	КонецЕсли;
	
	Возврат НСтр("ru = 'Трудового кодекса Российской Федерации'");
	
КонецФункции

#КонецОбласти

#КонецЕсли