
&НаСервереБезКонтекста
Процедура СторноНаСервере(сс)
	Справочники.двжТМЦ.СторноНаСервере(сс);
КонецПроцедуры

&НаКлиенте
Процедура Сторно(Команда)
	СторноНаСервере(Объект.Ссылка);
	Элементы.Сторно.Видимость = ложЬ;
	ОповеститьОЗаписиНового(Объект.Ссылка);
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Сделатьсторно(Команда)
	Элементы.Сторно.Видимость = 1 - Элементы.Сторно.Видимость;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьСторно(сс,ТекКол)
	Если ТекКол<=0 Тогда Возврат Ложь; КонецЕСЛИ;
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	двжТМЦ.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.двжТМЦ КАК двжТМЦ
	               |ГДЕ
	               |	двжТМЦ.спрСторно = &спрСторно";
	Запрос.УстановитьПараметр("спрСторно",сс);
	Возврат  Запрос.Выполнить().Пустой();
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.Сделатьсторно.Видимость = ЕстьСторно(Объект.Ссылка,объект.Количество);
	Элементы.ГруппаРедактирования.ТолькоПросмотр = Элементы.Сделатьсторно.Видимость;
	ОбновитьНормыМаслаНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура СканироватьШК(Команда)
	#Если МобильноеПриложениеКлиент Тогда
		Опопвещение = Новый ОписаниеОповещения("ЗавершениеСканирования",ЭтотОбъект);
		СредстваМультимедиа.ПоказатьСканированиеШтрихКодов("Сканирование штрих-кода",Опопвещение);
		
		//бин = СредстваМультимедиа.СделатьФотоснимок(ТипКамерыУстройства.Задняя);
		//Сообщить(Бин.ТипСодержимого);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеСканирования(ШтрихКод,Результат,Сообщение,ДопПар ) Экспорт
	
	НоменклатураОкончаниеВводаТекста(Неопределено, ШтрихКод, Неопределено, Неопределено, ложь);	
	#Если МобильноеПриложениеКлиент Тогда
		СредстваМультимедиа.ЗакрытьСканированиеШтрихКодов();
	#КонецЕсли
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДО(ИНН,КонстантаСклад)
	сс = Справочники.Организации.НайтиПоКоду(ИНН);
	Если сс.Пустая() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Если сс = КонстантаСклад.Организация Тогда
		Возврат Справочники.Организации.ПустаяСсылка();
	ИНаче
		Возврат сс;
	КонецеСЛИ;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьОснование(ДанныЕ)
	
	
	СткРез = глОбщийКлиент.ЗаполнитьОснование(ДанныЕ);
	
	Объект.ДокументОснование = СткРез.ВидДок+" №"+СткРез.номерПЛ+" от "+Формат(СткРез.ДатаПЛ,"ДФ=dd.MM.yyyy");
	
	Объект.гарНомер 	= СткРез.ГарНомер;
	Объект.ГосНомер 	= СткРез.ГосНомер;
	Объект.ТС			= СткРез.ТС;
	Объект.Сотрудник 	= СткРез.Сотрудник;
	Объект.ТабНомер	    = СткРез.ТабНомер;
	Если СокрЛП(СткРез.ИНН)<>"" Тогда
		организацияДО = ПолучитьДО(СткРез.ИНН,Объект.Склад);
		Объект.ИННДО  = СткРез.ИНН;
	ИНаче
		организацияДО = "";
		Объект.ИННДО  = "";
	КонецЕсли;
	Элементы.организацияДО.Видимость = ЗначениеЗаполнено(организацияДО);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ложь;
	ТекНом = Неопределено;
	
	
	Если стрДлина(Текст)>21  Тогда
		ЗаполнитьОснование(Текст);
		Текст="";
	ИНаче
		ШтрихКод = "";
		Производитель = "";
		Объект.Номенклатура = глОбщий.НоменклатураАвтоПодборНаСервере(Текст,ШтрихКод,Производитель);
	КонецЕСЛИ;
	
	ОбновитьНормыМасла();
	
	ЭтаФорма.Заголовок = " "+ПолучитьТхтОстатки(Объект.Номенклатура,Объект.Склад);
	ЭтаФорма.ОбновитьОтображениеДанных();
	
	
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПолучитьТхтОстатки(текИнв,ТекСклад)
	
	Если ЗначениеЗаполнено(текИнв) = Ложь Тогда
		Возврат "";
	КонецЕСЛИ;
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   //|	SUM(инвИнвентаризация.Количество) КАК Кол,
				   //|    0 Ост
				   //|ИЗ
				   //|	Справочник.двжТМЦ КАК инвИнвентаризация
				   //|ГДЕ
				   //|	инвИнвентаризация.Номенклатура = &Номенклатура
				   //|
				   //|UNION ALL
				   //|
				   //|ВЫБРАТЬ
				   |    0 Кол,
				   |	SUM(Остатки.Количество) КАК Ост
				   |ИЗ
				   |	РегистрСведений.Остатки КАК Остатки
				   |ГДЕ
				   |	Остатки.Номенклатура = &Номенклатура
				   |  и Склад = &Склад
				   |";
	Запрос.УстановитьПараметр("Номенклатура",текИнв);
	Запрос.УстановитьПараметр("Склад",ТекСклад);
	Тбл = запрос.Выполнить().Выгрузить();
	
	Возврат "остаток: "+Тбл.Итог("Ост");
	
	
КонецФункции


&НаСервере
Процедура ОбновитьНормыМаслаНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Агрегат)=Ложь ТОгда
		Объект.Агрегат = Справочники.ВидыАгрегатовТС.НайтиПоНаименованию("Двигатель");
	КонецеСЛИ;
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	НормыМасло.Долив КАК Долив,
	               |	НормыМасло.Акт КАК Акт,
	               |	НормыМасло.дтЗам КАК дтЗам,
	               |	НормыМасло.НормаЗамена КАК НормаЗамена,
	               |	НормыМасло.нрДолив КАК нрДолив
	               |ИЗ
	               |	РегистрСведений.НормыМасло КАК НормыМасло
	               |ГДЕ
	               |	НормыМасло.ГарНомер = &ГарНомер
	               |	И НормыМасло.Агрегат = &Агрегат";
	Запрос.УстановитьПараметр("ГарНомер",СокрЛП(Объект.ГарНомер));
	Запрос.УстановитьПараметр("Агрегат",Объект.Агрегат);
	
	Тбл = Запрос.Выполнить().Выгрузить();
	
	
	Норма = "";
	дтЗамены="";
	Долив = "";
	Акт = "";
	
	Если Тбл.Количество()=0 ТОгда Возврат; КонецЕСЛИ;
	
	Если Объект.ТипРасходаМасла=0 ТОгда
		Норма = ТБл[0].нрДолив;
	ИНАчеЕсли Объект.ТипРасходаМасла=1 ТОгда
		Норма = ТБл[0].НормаЗамена;
	КонецЕСЛИ;
	
	ДтЗамены = Тбл[0].дтЗам;
	Долив = ТБл[0].Долив;
	Акт = ТБл[0].Акт;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНормыМасла(Элемент=Неопределено)
	
	Если СокрЛП(Объект.ГарНомер)="" Тогда Возврат; КонецеСЛИ;
	
	ОбновитьНормыМаслаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.ВидДвижения<>1 ТОгда
		Объект.ВидДвижения=1;
	КонецеСЛИ;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.Номенклатура)=Ложь ТОгда
		Сообщить("Не выбрана номенклатура");
		Отказ = Истина;
		Возврат;
	КонецеСЛИ;
	Если ЗначениеЗаполнено(Объект.Агрегат)=Ложь ТОгда
		Сообщить("Не выбран агрегат");
		Отказ = Истина;
		Возврат;
	КонецеСЛИ;
	Если ЗначениеЗаполнено(Объект.Склад)=Ложь ТОгда
		Сообщить("Не выбран склад");
		Отказ = Истина;
		Возврат;
	КонецеСЛИ;
	Если Объект.Количество = 0 ТОгда
		Сообщить("Не указано количество");
		Отказ = Истина;
		Возврат;
	КонецеСЛИ;
	Если СокрлП(Объект.ГарНомер)="" ТОгда
		Сообщить("Не выбран автомобиль");
		Отказ = Истина;
		Возврат;
	КонецеСЛИ;
	
	
	Объект.Дата = текущаяДата();
	Объект.Лог = ""+ТекущаяДата()+"_"+ИмяКомпьютера();
	Объект.ВидДвижения = 1;

КонецПроцедуры
	



