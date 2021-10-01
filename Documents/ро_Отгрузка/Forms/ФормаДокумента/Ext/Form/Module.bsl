﻿
&НаКлиенте
Процедура Подбор(Команда)
	Стк = Новый Структура;
	Стк.Вставить("Контрагент",Объект.Контрагент);
	
	оо = Новый ОписаниеОповещения("ПослеЗакрытияПодбора",ЭтотОбъект);
	
	ОткрытьФорму("РегистрСведений.ОстаткиОборудования.Форма.ФормаСписка",Стк,ЭтаФорма,ЭтаФорма,,,оо,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияПодбора(Рез,ДопПар) Экспорт
	
	Если типЗнч(рез)<>Тип("Массив") ТОгда Возврат; КонецЕСЛИ;
	
	Для каждого стк из Рез Цикл
		м = Объект.ЗаказНаряды.НайтиСтроки(Новый структура("ЗаказНарядИд",Стк.ЗаказНарядИд));
		Если м.Количество()<>0 Тогда Продолжить; КонецЕсли;
		новСтр = Объект.ЗаказНаряды.Добавить();
		ЗаполнитьЗначенияСвойств(новСтр,стк);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМасКА()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ DISTINCT
	               |	ОстаткиОборудования.Контрагент КАК Контрагент
	               |ИЗ
	               |	РегистрСведений.ОстаткиОборудования КАК ОстаткиОборудования";
	Мас = новый Массив;
	Выб = Запрос.Выполнить().Выбрать();
	Пока Выб.Следующий() Цикл
		Мас.Добавить(Выб.Контрагент);
	КонецЦикла;
	
	Возврат Мас;
	
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	текЭЛ = Элементы.Контрагент;
	текЭЛ.КнопкаВыпадающегоСписка = Истина;
	текЭл.СписокВыбора.ЗагрузитьЗначения(ПолучитьМасКА()); 
	текЭл.РедактированиеТекста = Ложь;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Объект.Ссылка)=Ложь Тогда
		ДатаСинхронизации = Дата(1,1,1);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыгрузитьНаСервере(сс)
	// Вставить содержимое обработчика.
	Возврат глВыгрузкаДанных.ВыгрузитьРо_Отгрузку(сс);
КонецФункции

&НаКлиенте
Процедура Выгрузить(Команда)
	Если ЭтаФорма.Модифицированность = Истина Тогда
		Сообщить("Документ не записан!");
		Возврат;
	КонецеСЛИ;
	
	Если ВыгрузитьНаСервере(Объект.Ссылка)=Истина Тогда
		Объект.ДатаСинхронизации = ТекущаяДата();
		ЭтаФорма.Записать();
		ЭтаФорма.Закрыть();
	КонецеСЛИ;
КонецПроцедуры


