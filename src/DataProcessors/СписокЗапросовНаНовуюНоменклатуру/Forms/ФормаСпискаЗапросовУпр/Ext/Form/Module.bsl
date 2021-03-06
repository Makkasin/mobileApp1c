
&НаКлиенте
Процедура СделатьЗапросНасервере()
	ОткрытьФормуМодально("Справочник.Номенклатура.Форма.ФормаЗапросаУпр");
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьЗапрос(Команда)
	СделатьЗапросНасервере();
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	       ОбновитьНаСервере();
КонецПроцедуры
	
Процедура ОбновитьНаСервере()
	
	зпТбл.Очистить();
	
	СткСоединение = глОбщий.СткПолучитьСоединение();
	
	Соединение = Новый HTTPСоединение(
	СткСоединение.Сервер, // сервер (хост)
	СткСоединение.Порт, // порт, по умолчанию для http используется 80, для https 443
	СткСоединение.Логин, // пользователь для доступа к серверу (если он есть)
	СткСоединение.Пароль, // пароль для доступа к серверу (если он есть)
	, // здесь указывается прокси, если он есть
	, // таймаут в секундах, 0 или пусто - не устанавливать
	// защищенное соединение, если используется https
	);
	
	
	Запрос = Новый HTTPЗапрос("/Urals_BUH/hs/invAPI/LISTREQ");
	
	Результат = Соединение.Получить(Запрос);
	Если Результат.КодСостояния <> 200 Тогда 
		Сообщить("Ошибка синхронизации: код "+Результат.КодСостояния);
		Сообщить(результат.ПолучитьТелоКакСтроку());
		Возврат ;
	КонецЕСЛИ;
	
	Мас   = XMLзначение(Тип("ХранилищеЗначения"),Результат.ПолучитьТелоКакСтроку()).Получить();
	Тбл   = Мас[1];
	
	Для каждого Стр из Тбл Цикл
		новстр = зпТбл.Добавить();
		ЗаполнитьЗначенияСвойств(новстр,Стр);
		новСтр.Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Стр.НоменклатураGUID));
	КонецЦикла;
	зпТбл.сортировать("Лог desc");
	
	Возврат;
	
	Стк  = Новый Структура();
	чтДЖ = Новый ЧтениеJSON;
	чтДЖ.УстановитьСтроку(Результат.ПолучитьТелоКакСтроку());
	чтДЖ.Прочитать();	
	Пока чтДЖ.Прочитать() Цикл
		
		Если  чтДж.ТипТекущегоЗначения = ТипЗначенияJSON.НачалоМассива Тогда Продолжить; КонецеСЛИ;
		Если  чтДж.ТипТекущегоЗначения = ТипЗначенияJSON.КонецМассива Тогда Продолжить; КонецеСЛИ;
		
		Если  чтДж.ТипТекущегоЗначения = ТипЗначенияJSON.НачалоОбъекта Тогда 
			Стк  = Новый Структура();
			Продолжить; 
		ИначеЕсли  чтДж.ТипТекущегоЗначения = ТипЗначенияJSON.КонецОбъекта и Стк.Количество()<>0 Тогда 
			//ЗаписатьТбл(Стк);
			Стк  = Новый Структура();
			Продолжить; 
		ИначеЕсли  чтДж.ТипТекущегоЗначения = ТипЗначенияJSON.ИмяСвойства Тогда 
			свво = чтДж.ТекущееЗначение;
			чтДЖ.Прочитать();
			Если  чтДж.ТипТекущегоЗначения = ТипЗначенияJSON.Строка или чтДж.ТипТекущегоЗначения = ТипЗначенияJSON.Число или чтДж.ТипТекущегоЗначения = ТипЗначенияJSON.Булево  Тогда 
				Если свво = "Количество объектов JSON" Тогда
					итОбк=чтДж.ТекущееЗначение;
				ИНачеЕсли Найти(свво,"DT")<>0 Тогда
					Стк.Вставить(СтрЗаменить(свво,"DT",""),XMLЗначение(Тип("Дата"),чтДж.ТекущееЗначение));
				ИНаче
					Стк.Вставить(свво,чтДж.ТекущееЗначение);
				КонецеСЛИ;
			КонецЕсли;
		КонецеСЛИ;
		
	КонецЦикла;
	
	зпТбл.сортировать("Лог desc");
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСткТбл()
	Стк = новый структура;
	Для каждого кол из зпТбл.Выгрузить().Колонки Цикл
		Стк.Вставить(кол.имя,Неопределено);
	КонецЦикла;
	Возврат Стк;
КонецФункции

&НаКлиенте
Процедура зпТблВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Текстр = Элементы.зпТбл.ТекущиеДанные;
	
	Стк = ПолучитьСткТбл();
	Для каждого Эл из Стк Цикл
		Стк.Вставить(Эл.Ключ,ТекСтр[Эл.Ключ]);
	КонецЦикла;
	
	ОткрытьФорму("Обработка.СписокЗапросовНаНовуюНоменклатуру.Форма.Форма",Стк);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьНаСервере();
	фильтрТбл();
КонецПроцедуры

&НаКлиенте
Процедура Незакрытые(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура фильтрТблПриИзменении(Элемент)
	 фильтрТбл();
КонецПроцедуры

&НаКлиенте
Процедура фильтрТбл()
	
	Если фильтрТбл=0 ТОгда
		Элементы.зпТбл.ОтборСтрок = Новый ФиксированнаяСтруктура("ДатаЗакрытияЗапроса",Дата(1,1,1));
	ИНаче
		Элементы.зпТбл.ОтборСтрок = Неопределено;
	КонецЕСли;
	
КонецПроцедуры
