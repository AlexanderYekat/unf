﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сотрудники(Команда)
	ОткрытьФорму("Справочник.Сотрудники.ФормаСписка",,, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ПриемНаРаботу(Команда)
	ОткрытьФорму("Документ.ПриемНаРаботу.Форма.ФормаСписка",,, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура НачислениеЗарплаты(Команда)
	ОткрытьФорму("Документ.НачислениеЗарплаты.Форма.ФормаСписка",,, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ЗаявленияНаВычетыНДФЛ(Команда)
	ОткрытьФорму("ЖурналДокументов.ЗаявленияНаВычеты.ФормаСписка",,, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛица(Команда)
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаСписка",,, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура Начисления(Команда)
	ОткрытьФорму("ПланВидовРасчета.Начисления.ФормаСписка",,, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура Удержания(Команда)
	ОткрытьФорму("ПланВидовРасчета.Удержания.ФормаСписка",,, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура КадровыйПеревод(Команда)
	ОткрытьФорму("Документ.КадровыйПеревод.Форма.ФормаСписка",,, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура Увольнение(Команда)
	ОткрытьФорму("Документ.Увольнение.Форма.ФормаСписка",,, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ВедомостьВБанк(Команда)
	ОткрытьФорму("Документ.ВедомостьНаВыплатуЗарплатыВБанк.Форма.ФормаСписка",,, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ВедомостьВКассу(Команда)
	ОткрытьФорму("Документ.ВедомостьНаВыплатуЗарплатыВКассу.Форма.ФормаСписка",,, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура РегистрацияТрудовойДеятельности(Команда)
	ОткрытьФорму("Документ.РегистрацияТрудовойДеятельности.Форма.ФормаСписка",,, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ОформлениеДокументовРегУчета(Команда)
	ОткрытьФорму("Обработка.ФормированиеКадровыхДокументовРеглУчет.Форма");
КонецПроцедуры

&НаКлиенте
Процедура Отпуск(Команда)
	ОткрытьФорму("Документ.Отпуск.ФормаСписка",,, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ОтпускБезСохраненияОплаты(Команда)
	ОткрытьФорму("Документ.ОтпускБезСохраненияОплаты.ФормаСписка",,, УникальныйИдентификатор);
КонецПроцедуры   

&НаКлиенте
Процедура Отчеты(Команда)

	ПутьКПодсистеме = "ЗарплатаКадрыРегламентированныеУНФ";
	ФормаПараметры = Новый Структура("ПутьКПодсистеме", ПутьКПодсистеме);
	
	ИдентификаторЗамера = ОценкаПроизводительностиКлиент.ЗамерВремени("ПанельОтчетов.Открытие", , Ложь);
	Комментарий = Новый Соответствие;
	Комментарий.Вставить("ПутьКПодсистеме", ПутьКПодсистеме);
	ОценкаПроизводительностиКлиент.УстановитьКомментарийЗамера(ИдентификаторЗамера, Комментарий);
	
	Форма = ОткрытьФорму("ОбщаяФорма.ФормаСпискаОтчетов", ФормаПараметры, , ПутьКПодсистеме);
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(ИдентификаторЗамера);
	
КонецПроцедуры

#КонецОбласти


