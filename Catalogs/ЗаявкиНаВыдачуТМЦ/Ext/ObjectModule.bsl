
Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка = Истина Тогда Возврат; КонецЕСЛИ;
	ДатаСинхронизации = дата(1,1,1);
	Если идПланшета = "" Тогда
		идПланшета = ИмяКомпьютера();
		имяПланшета = глДоступ.ПолучитьИмяПользователя();
	КонецЕсли;
	Если Выдано = Количество Тогда
		Статус = 2;
	КонецЕсли;
	
КонецПроцедуры
