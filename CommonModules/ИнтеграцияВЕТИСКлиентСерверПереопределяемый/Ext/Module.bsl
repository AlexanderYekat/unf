﻿#Область СлужебныйПрограммныйИнтерфейс

// Заполняет соответствие полей документов-оснований и исходящей транспортной операции
// 
// Возвращаемое значение:
//  Соответствие - соответствие со свойствами:
//   * ИмяДокумента - Соответствие - ключом свойства является имя документа, например "РеализацияТоваровУслуг",
//                                  а значением - соответствие со свойствами:
//   ** ГрузоотправительХозяйствующийСубъект - Строка - имя поля документа, которое соответствует контрагенту
//  	                                               хозяйствующего субъекта грузоотправителя
//   ** ГрузоотправительПредприятие - Строка - имя поля документа, которое соответствует предприятию грузоотправителя
//   ** ГрузополучательХозяйствующийСубъект - Строка - имя поля документа, которое соответствует контрагенту
//  	                                              хозяйствующего субъекта грузополучателя
//   ** ГрузополучательПредприятие - Строка - имя поля документа, которое соответствует предприятию грузополучателя
Процедура ЗаполнитьСоответствиеПолейДокументовОснованийИИсходящейТранспортнойОперации(СоответствиеПолей) Экспорт
	
	ИнтеграцияВЕТИСУНФКлиентСервер.ЗаполнитьСоответствиеПолейДокументовОснованийИИсходящейТранспортнойОперации(СоответствиеПолей);
	
КонецПроцедуры

// Заполняет соответствие полей документов-оснований и входящей транспортной операции
//
// Возвращаемое значение:
//  Соответствие - соответствие со свойствами:
//   * ИмяДокумента - Соответствие - ключом свойства является имя документа, например "РеализацияТоваровУслуг",
//                                  а значением - соответствие со свойствами:
//   ** ГрузоотправительХозяйствующийСубъект - Строка - имя поля документа, которое соответствует контрагенту
//                                                     хозяйствующего субъекта грузоотправителя
//   ** ГрузоотправительПредприятие - Строка - имя поля документа, которое соответствует предприятию грузоотправителя
//   ** ГрузополучательХозяйствующийСубъект - Строка - имя поля документа, которое соответствует контрагенту
//                                                    хозяйствующего субъекта грузополучателя
//   ** ГрузополучательПредприятие - Строка - имя поля документа, которое соответствует предприятию грузополучателя
Процедура ЗаполнитьСоответствиеПолейДокументовОснованийИВходящейТранспортнойОперации(СоответствиеПолей) Экспорт
	
	ИнтеграцияВЕТИСУНФКлиентСервер.ЗаполнитьСоответствиеПолейДокументовОснованийИВходящейТранспортнойОперации(СоответствиеПолей);
	
КонецПроцедуры

// Заполняет соответствие полей документов-оснований и производственных операций
//
// Возвращаемое значение:
//  Соответствие - соответствие со свойствами:
//   * ИмяДокумента - Соответствие - ключом свойства является имя документа, например "СборкаТоваров",
//                                  а значением - соответствие со свойствами:
//   ** ХозяйствующийСубъект - Строка - имя поля документа, которое соответствует хозяйствующему субъекту
//   ** Предприятие - Строка - имя поля документа, которое соответствует предприятию хозяйствующего субъекта
Процедура ЗаполнитьСоответствиеПолейДокументовОснованийИПроизводственнойОперации(СоответствиеПолей) Экспорт
	
	ИнтеграцияВЕТИСУНФКлиентСервер.ЗаполнитьСоответствиеПолейДокументовОснованийИПроизводственнойОперации(СоответствиеПолей);
	
КонецПроцедуры

// Заполняет соответствие полей документов-оснований и инвентаризации продукции
//
// Возвращаемое значение:
//  Соответствие - соответствие со свойствами:
//   * ИмяДокумента - Соответствие - ключом свойства является имя документа, например "СписаниеНедостачТоваров",
//                                  а значением - соответствие со свойствами:
//   ** ХозяйствующийСубъект - Строка - имя поля документа, которое соответствует хозяйствующему субъекту
//   ** Предприятие - Строка - имя поля документа, которое соответствует предприятию хозяйствующего субъекта
Процедура ЗаполнитьСоответствиеПолейДокументовОснованийИИнвентаризацииПродукции(СоответствиеПолей) Экспорт
	
	ИнтеграцияВЕТИСУНФКлиентСервер.ЗаполнитьСоответствиеПолейДокументовОснованийИИнвентаризацииПродукции(СоответствиеПолей);
	
КонецПроцедуры

// Заполняет свойства (например, Видимость, Доступность итп) отдельных элементов формы документа 
// 'ПроизводственнаяОперацияВЕТИС' в зависимости от документа-основания.
//
// Параметры:
//  ДокументОснование - ОпределяемыйТип.ОснованиеПроизводственнаяОперацияВЕТИС - Основание документа.
//  Свойства          - Структура                                              - Свойства элементов.
Процедура ЗаполнитьСвойстваЭлементовПроизводственнойТранзакцииПоДокументуОснованию(Свойства, ДокументОснование) Экспорт
	
	ИнтеграцияВЕТИСУНФКлиентСервер.ЗаполнитьСвойстваЭлементовПроизводственнойТранзакцииПоДокументуОснованию(Свойства, ДокументОснование);
	
КонецПроцедуры

// Заполняет признак необходимости заполнения реквизита 'ТорговыйОбъект' документа 'ПроизводственнаяОперацияВЕТИС'.
//
// Параметры:
//  ДокументОснование - ОпределяемыйТип.ОснованиеПроизводственнаяОперацияВЕТИС - Основание документа.
//  Заполнять         - Булево                                                 - Необходимость заполнения.
Процедура ЗаполнятьТорговыйОбъектПоДокументуОснованию(ДокументОснование, Заполнять) Экспорт
	
	ИнтеграцияВЕТИСУНФКлиентСервер.ЗаполнятьТорговыйОбъектПоДокументуОснованию(ДокументОснование, Заполнять);
	
КонецПроцедуры

// Заполняет структуру, содержащую поля кэшируемых значений.
// 
// Параметры:
//   КэшированныеЗначения - (см. ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения) - результат.
//
Процедура ЗаполнитьСтруктуруКэшируемыеЗначения(КэшированныеЗначения) Экспорт
	
	ИнтеграцияВЕТИСУНФКлиентСервер.ЗаполнитьСтруктуруКэшируемыеЗначения(КэшированныеЗначения);
	
КонецПроцедуры

// Возвращает параметры формы подбора товаров.
//
// Параметры:
// ПараметрыПодбора - Структура - Структура со свойствами:
//  * СкрыватьКнопкуЗапрашиватьКоличество     - Булево - Признак необходимости сокрытия кнопки указания количества.
//  * РежимПодбораБезКоличественныхПараметров - Булево - Признак работы формы подбора товаров с выключенным режимом 
//                                                       использования количественных параметров.
//  * Склад - ОпределяемыйТип.ТорговыйОбъектВЕТИС - Склад, на котором осуществляется подбор товаров.
//  Форма - ФормаКлиентскогоПриложения - Форма, в которой вызывается команда открытия формы подбора товаров.
//  ПараметрыУказанияСерий - Произвольный - См. ИнтеграцияИС.ПараметрыУказанияСерий. 
Процедура ЗаполнитьПараметрыФормыПодбораТоваров(ПараметрыПодбора, Форма, ПараметрыУказанияСерий) Экспорт
	
	ИнтеграцияВЕТИСУНФКлиентСервер.ЗаполнитьПараметрыФормыПодбораТоваров(ПараметрыПодбора, Форма, ПараметрыУказанияСерий);
	
КонецПроцедуры

// Пересчитывает количество из базовой единицы измерения номенклатуры в единицу измерения ВЕТИС.
//
Процедура ЗаполнитьКоличествоЕдиницВЕТИС(КоличествоВЕТИС, Количество, Номенклатура, ЕдиницаИзмеренияВЕТИС, КэшированныеЗначения, ТекстОшибки) Экспорт
	
	КоличествоВЕТИС = ИнтеграцияВЕТИСУНФКлиентСервер.КоличествоЕдиницВЕТИС(
		Количество,
		Номенклатура,
		ЕдиницаИзмеренияВЕТИС,
		КэшированныеЗначения,
		ТекстОшибки);
	
КонецПроцедуры

// Пересчитывает количество из единицы измерения ВЕТИС в базовую единицу измерения номенклатуры.
//
Процедура ЗаполнитьКоличествоЕдиницПоВЕТИС(Количество, КоличествоВЕТИС, Номенклатура, ЕдиницаИзмеренияВЕТИС, КэшированныеЗначения, ТекстОшибки = Неопределено) Экспорт
	
	Количество = ИнтеграцияВЕТИСУНФКлиентСервер.КоличествоЕдиниц(
		КоличествоВЕТИС,
		Номенклатура,
		ЕдиницаИзмеренияВЕТИС,
		КэшированныеЗначения,
		ТекстОшибки);
	
КонецПроцедуры

// Заполняет параметры оформления серии по данным строки (если использование условного оформления не возможно).
//
// Параметры:
//   ПараметрыОформленияСерии - Структура - поля, на основании которых можно оформить элемент формы.
//   ДанныеСтроки - Структура, ДанныеФормыЭлементКоллекции - данные, в которых содержится информация по оформлению серии.
//
Процедура ЗаполнитьПараметрыОформленияСерииПоДаннымСтроки(ПараметрыОформленияСерии, ДанныеСтроки) Экспорт
	
	ИнтеграцияВЕТИСУНФКлиентСервер.ЗаполнитьПараметрыОформленияСерииПоДаннымСтроки(ПараметрыОформленияСерии, ДанныеСтроки);
	
КонецПроцедуры

#КонецОбласти
