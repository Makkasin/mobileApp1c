
Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка = Истина Тогда Возврат; КонецЕСЛИ;
	ДатаСинхронизации = дата(1,1,1);
	
	РегистрыСведений.СинхроДвж.ПризнакСинхронизацииСклада(Склад,Дата);
	
КонецПроцедуры
