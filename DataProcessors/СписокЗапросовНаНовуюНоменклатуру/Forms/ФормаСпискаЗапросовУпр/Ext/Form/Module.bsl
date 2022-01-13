﻿
&НаКлиенте
Процедура СделатьЗапросНасервере()
	
	ОткрытьФормуМодально("Обработка.СписокЗапросовНаНовуюНоменклатуру.Форма.ФормаПлз");
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

&НаСервере
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
	
	Если ЭтаФорма.ДоступНаСозданиеНоменклатуры = Ложь Тогда
		Стк = новый Структура();
		Стк.Вставить("user",СокрЛП(глДоступ.ПолучитьНаименованиеУстройства()));
		Стк.Вставить("inn",СокрЛП(Константы.Склад.Получить().Организация.Код));
		хр = Новый ХранилищеЗначения(Стк,новый СжатиеДанных(5));
		Запрос.УстановитьТелоИзСтроки(xmlстрока(хр));
	КонецесЛИ;
	
	Результат = Соединение.POST(Запрос);
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
	
	Если ДоступНаСозданиеНоменклатуры Тогда
		ОткрытьФорму("Обработка.СписокЗапросовНаНовуюНоменклатуру.Форма.Форма",Стк);
	ИНАче
		ОткрытьФорму("Обработка.СписокЗапросовНаНовуюНоменклатуру.Форма.ФормаПлз",Стк);
	КонецЕСЛИ;
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

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоступНаСозданиеНоменклатуры = глДоступ.ДоступЗапросыНаНовуюНоменклатуру();
	Если ДоступНаСозданиеНоменклатуры=Ложь ТОгда
		ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + глДоступ.ПолучитьНаименованиеУстройства();
	КонецЕСЛИ;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗаписьСписокЗапросовНаНовуюНоменклатуру" Тогда
		Для каждого Стр из зпТбл Цикл
			Если Стр.идЗапроса = параметр.идЗапроса Тогда
				ЗаполнитьЗначенияСвойств(Стр,Параметр);
				прервать;
			КонецеСЛИ;
		КонецЦикла;
		
		фильтрТбл();
	КонецесЛИ;
КонецПроцедуры
