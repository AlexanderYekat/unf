﻿
#Область ПрограммныйИнтерфейс

Функция СтатусПоКоду(Код) Экспорт
	
	Коды = Новый Соответствие;
	Коды["DRAFT"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.Черновик");
	Коды["CREATED"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.Создан");
	Коды["SENDER_SENT"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ЖдетПодтвержденияСлужбыДоставки");
	Коды["DELIVERY_LOADED"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ПодтвержденСлужбойДоставки");
	Коды["ERROR"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.Ошибка");
	Коды["FULFILMENT_LOADED"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ПодтвержденЕдинымСкладом");
	Коды["SENDER_WAIT_FULFILMENT"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ОжидаетсяНаЕдиномСкладе");
	Коды["SENDER_WAIT_DELIVERY"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ОжидаетсяВСлужбеДоставки");
	Коды["FULFILMENT_ARRIVED"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.НаЕдиномСкладе");
	Коды["FULFILMENT_PREPARED"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ГотовКПередачеВСлужбуДоставки");
	Коды["FULFILMENT_TRANSMITTED"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ПереданВСлужбуДоставки");
	Коды["DELIVERY_AT_START"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.НаСкладеСлужбыДоставки");
	Коды["DELIVERY_TRANSPORTATION"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.Доставляется");
	Коды["DELIVERY_ARRIVED"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ВГородеПокупателя");
	Коды["DELIVERY_TRANSPORTATION_RECIPIENT"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ДоставляетсяПоГороду");
	Коды["DELIVERY_ARRIVED_PICKUP_POINT"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ВПунктеСамовывоза");
	Коды["DELIVERY_DELIVERED"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.Доставлен");
	Коды["RETURN_PREPARING"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ГотовитсяКВозврату");
	Коды["RETURN_ARRIVED_DELIVERY"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ВозвращенНаСкладСлужбыДоставки");
	Коды["RETURN_ARRIVED_FULFILMENT"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ВозвращенНаЕдиныйСклад");
	Коды["RETURN_PREPARING_SENDER"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ГотовКВозвратуВМагазин");
	Коды["RETURN_RETURNED"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.ВозвращенВМагазин");
	Коды["LOST"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.Утерян");
	Коды["UNEXPECTED"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.СтатусУточняется");
	Коды["CANCELED"] = ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.Отменен");
	
	Результат = Коды[ВРег(Код)];
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Возврат Результат;
	Иначе
		Возврат ПредопределенноеЗначение("Перечисление.СтатусыЯндексДоставки.СтатусУточняется");
	КонецЕсли;
	
КонецФункции

#КонецОбласти