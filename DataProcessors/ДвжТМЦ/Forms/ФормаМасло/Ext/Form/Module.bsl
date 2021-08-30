﻿
&НаКлиенте
Процедура ВыдатьМасло(Команда)
	Форма = ПолучитьФорму("Справочник.двжТМЦ.Форма.ФормаВыдачаМасла",,ЭтаФорма,ЭтаФорма);
	Форма.ЭтотОбъект.Объект.Склад = Склад;
	Форма.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНормы(Команда)
	ОбновитьНормыНасервере();
	глОбщий.ЗагрузитьОстаткиНаСервере(Склад);
КонецПроцедуры

&НаСервере
Процедура ОбновитьНормыНасервере()
	РегистрыСведений.НормыМасло.ЗагрузитьАЗУР(Склад.Организация);
КонецПроцедуры

&НаКлиенте
Процедура СписокДвжВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = ЛожЬ;
	ОткрытьФорму("Справочник.двжТМЦ.Форма.ФормаВыдачаМасла",Новый Структура("Ключ",ВыбраннаяСтрока),ЭтаФорма,ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	глДоступ.УстановитьСкладМасло(Склад);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Склад)=Ложь ТОгда
		Склад = глДоступ.ПолучитьСкладМасло();
	КонецеСЛИ;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьДень(Команда)
	
	ТекДт = глОбщий.ПоследнийНезакратыйДень();
	Если ЗначениеЗаполнено(ТекДТ)=Ложь ТОгда
		Сообщить("Все транзакции закрыты!");
		Возврат;
	КонецеСЛИ;
	глВыгрузкаДанных.ВыгрузитьДвжТМЦ(Истина);
	Оповестить("ОбновитьДтСинхро");
	ЭтаФорма.Закрыть();


КонецПроцедуры
