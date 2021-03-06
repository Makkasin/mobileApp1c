Процедура ОбменВФоне() Экспорт
	
	глОбщий.ЗаписатьРегСинхро("Синхро",ТекущаяДата());

	Мас = ФоновыеЗадания.ПолучитьФоновыеЗадания();
	Для каждого Эл из Мас Цикл
		Если Эл.Наименование = "Синхро" Тогда
			Если Эл.Конец = Дата(1,1,1) ТОгда 
				Возврат; //Предыдущее задание еще не завершилось
			КонецЕСЛИ;
		КонецЕСЛИ;
	КонецЦикла;
	
	
	ФоновыеЗадания.Выполнить("глВыгрузкаДанных.Обмен",,,"Синхро");
	
КонецПроцедуры

Процедура PUSHВФоне() Экспорт
	

	Мас = ФоновыеЗадания.ПолучитьФоновыеЗадания();
	Для каждого Эл из Мас Цикл
		Если Эл.Наименование = "PUSHВФоне" Тогда
			Если Эл.Конец = Дата(1,1,1) ТОгда 
				Возврат; //Предыдущее задание еще не завершилось
			КонецЕСЛИ;
		КонецЕСЛИ;
	КонецЦикла;
	
		
	Мас = новый Массив;
	Мас.добавить("");
	
	ФоновыеЗадания.Выполнить("глВыгрузкаДанных.PUSH",Мас,,"PUSHВФоне");
	
	
КонецПроцедуры

Процедура ПрочитатьОтветОбкСПрогрессБаром(Адрес,Тбл) Экспорт
	
	СткКол = Новый Структура();
	Для каждого Кол из Тбл.Колонки Цикл
		СткКол.Вставить(Кол.имя,"");
	Конеццикла;
	
    сткПрог = Новый Структура("Вид,Зн","",0);	
	Т = ТБл.Скопировать(,"ВидСпр");
	Т.свернуть("ВидСпр","");
	Для каждого С из Т Цикл
		Мас = Тбл.НайтиСтроки(Новый Структура("ВидСпр",С.ВидСпр));
		СткПрог.Вид = С.ВидСпр;
		СткПрог.Зн  = 0;
		ном = 0; итКол = Мас.Количество();
		Для Повтор=1 по 3 Цикл
			Для а=-Мас.Количество() по -1 Цикл
				Эл = Мас[-а-1];
				Попытка
					глВыгрузкаДанных.ЗаписатьОбк(эл,СткКол);
				исключение
					продолжить;
				КонецПопытки;
				
				Мас.удалить(-а-1);
				
				ном=Ном+1;
				СткПрог.Вид = ""+С.ВидСпр+" "+ном+" из "+итКол;
				СткПрог.Зн = ОКР(ном/итКол*100,1);
				ПоместитьВоВременноеХранилище(СткПрог,Адрес);
			Конеццикла;
		Конеццикла;
	КонецЦикла;
	
	
КонецПроцедуры
