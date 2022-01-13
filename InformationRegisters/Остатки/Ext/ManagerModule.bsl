﻿Функция ПолучитьОстатокПоНоменклатуре(ТекСклад,Номенклатура,поМестам=Ложь) Экспорт
	
	Запрос = новый Запрос;
	Запрос.Текст = "
|
|SELECT
|   CASE WHEN МЕсто = ""0"" Then """" ELSE место END Место,
|	СУММА(Остатки.Расход) КАК Расход,
|	СУММА(Остатки.Остаток) КАК Остаток
|
|FROM
|(ВЫБРАТЬ
|	CASE WHEN &Поместам = Истина Тогда Остатки.Место ELSE Неопределено END Место, 
|	Остатки.Количество КАК Остаток,
|	0 Расход
|ИЗ
|	РегистрСведений.Остатки КАК Остатки
|ГДЕ
|	Остатки.Склад = &Склад
|	и Остатки.Номенклатура = &Номенклатура
|	и Остатки.Забаланс = Ложь
|	
|	
|UNION ALL
|
|SELECT
|Неопределено  Место, 
|-Количество,
|Количество Расход
|
|
|FROM Справочник.двжТМЦ Спр
|ГДЕ
|	   Спр.Склад = &Склад
|	и  Спр.Номенклатура = &Номенклатура
|	и (  (Спр.Дата >= &Дата и Спр.ДатаСинхронизации > &ДатаСинхронизации)  или Спр.ДатаСинхронизации = ДатаВремя(1,1,1))
|
|UNION ALL
|
|SELECT
|Неопределено  Место, 
|-ДокМат.Количество,
|ДокМат.Количество Расход
|
|
|FROM Документ.ВыдачаТМЦ.Материалы ДокМат
|INNER JOIN Документ.ВыдачаТМЦ Док ON ДокМат.ссылка = Док.ссылка
|ГДЕ
|	   Док.Склад = &Склад
|	и  ДокМат.Номенклатура = &Номенклатура
|	и (  (Док.Дата >= &Дата и Док.ДатаСинхронизации > &ДатаСинхронизации)  или Док.ДатаСинхронизации = ДатаВремя(1,1,1))
|) Остатки
|GROUP BY Место
|
	|";
	Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
	Запрос.УстановитьПараметр("Склад",ТекСклад);
	Запрос.УстановитьПараметр("ПоМестам",поМестам);
	
	Стк = РегистрыСведений.СинхроДвж.ПоследняяВыгрузкаНаСервер(ТекСклад);
	
	//ПолучитьДатыОстатковПоСкладу
	Запрос.УстановитьПараметр("Дата",Стк.ДАта);
	Запрос.УстановитьПараметр("ДатаСинхронизации",Стк.ДатаСинхронизации);
	
	Если ПоМестам=Ложь Тогда
		Выб = запрос.Выполнить().Выбрать();
		Стк = Новый СТруктура("Остаток,Расход","-","-");
		Если Выб.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(Стк,Выб);
		КонецЕСлИ;
		Возврат Стк;
	Иначе
		Возврат Запрос.Выполнить().Выгрузить();
	КонецеСЛИ;
	
КонецФункции

Функция ПолучитьТблОстатки(ТекСклад,Номенклатура,ТекОст="",поМестам=Ложь) Экспорт
	
	Тбл = РегистрыСведений.Остатки.ПолучитьОстатокПоНоменклатуре(ТекСклад,Номенклатура,Истина);
	ТекОст = Тбл.Итог("Остаток");
	
	//Уберем нулевые строки
	Для а=-Тбл.КОличество() по -1 Цикл
		Если Тбл[-а-1].Остаток = 0 ТОгда
			Тбл.Удалить(Тбл[-а-1]);
		КонецЕСЛИ;
	КонецЦиклА;
	
	Возврат Тбл;
	
КонецФункции

Функция ПолучитьДатыОстатковПоСкладу(Склад) Экспорт
	
	Стк = новый Структура("ДатаЗагрузки,ДатаПредОстатков",Дата(1,1,1),дата(1,1,1));
	
	Запрос = новый Запрос;
	Запрос.Текст = "
|SELECT top 1
|	ДатаПредОстатков, ДатаЗагрузки
|
|FROM РегистрСведений.Остатки КАК Остатки
|ГДЕ
|	Остатки.Склад = &Склад
|
|";
	
	Запрос.УстановитьПараметр("Склад",Склад);
	
	Выб = Запрос.Выполнить().Выбрать();
	Если Выб.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Стк,Выб);
	КонецЕслИ;
	
	Возврат Стк;
	
КонецФункции

