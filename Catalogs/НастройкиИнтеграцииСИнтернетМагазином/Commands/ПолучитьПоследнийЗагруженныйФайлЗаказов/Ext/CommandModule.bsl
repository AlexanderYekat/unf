﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТекстДанных = ИнтеграцияСИнтернетМагазиномВызовСервера.ПрочитатьДанныеНаСервере(ПараметрКоманды,
	"ДанныеПоследнегоНепустогоОбмена");
	
	Текст = Новый ТекстовыйДокумент;
	Текст.УстановитьТекст(ТекстДанных);
	Текст.Показать(НСтр("ru = 'Текст заказов'"));
	
КонецПроцедуры

#КонецОбласти