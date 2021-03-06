&НаСервере
Функция Данные()
	
	Орг = глДоступ.ПолучитьОрганизацию();
	Если Орг = Неопределено ТОгда Возврат Неопределено; КонецЕСЛИ;
	АПИ = СокрЛП(Орг.APIrestENT);
	Если АПИ = "" ТОгда Возврат Неопределено; КонецЕСЛИ; 
	
	СткСоединение = глОбщий.СткПолучитьСоединение(Орг);
		Соединение = Новый HTTPСоединение(
        СткСоединение.Сервер, // сервер (хост)
        СткСоединение.Порт, // порт, по умолчанию для http используется 80, для https 443
        СткСоединение.Логин, // пользователь для доступа к серверу (если он есть)
        СткСоединение.Пароль, // пароль для доступа к серверу (если он есть)
        , // здесь указывается прокси, если он есть
        , // таймаут в секундах, 0 или пусто - не устанавливать
          // защищенное соединение, если используется https
    );
	
	
	Запрос = Новый HTTPЗапрос("/"+АПИ+"/hs/entAPI/DATATSPODR");
    Результат = Соединение.Получить(Запрос);
	
	Если Результат.КодСостояния <> 200 Тогда 
		Сообщить("Ошибка синхронизации: код "+Результат.КодСостояния);
		Сообщить(результат.ПолучитьТелоКакСтроку());
		Возврат Неопределено;
	КонецЕСЛИ;
	
	итТБл.Загрузить(XMLзначение(Тип("ХранилищеЗначения"),результат.ПолучитьТелоКакСтроку()).Получить());
	Возврат Истина;
 	
КонецФункции


&НаСервере
Процедура ОбновитьНаСервере()
	
	тДрево = РеквизитФормыВЗначение("Древо");
	тДрево.Строки.Очистить();
	
	Если ЗначениеЗаполнено(Подразделение)=Истина Тогда
		Тбл = итТбл.Выгрузить(Новый Структура("Подр",Подразделение));
	Иначе
		Тбл = итТбл.Выгрузить();
	КонецеСЛИ;
	
	Если ТБл = Неопределено Тогда Возврат; КонецеСЛИ;
	
	ТБл.Сортировать("ГарНомер,дтНач");
	Т = Тбл.Скопировать(,"ТС,ГарНомер,ГосНомер");
	
	Т.Свернуть("ТС,ГарНомер,ГосНомер","");
	ЕстьФильтр = СокрЛП(СтрПоиска)<>"";
	Для каждого С из Т ЦИкл
		
		Если ЕстьФильтр=Истина Тогда
			Если Найти(С.ТС,СтрПоиска)=0
				и Найти(С.ГарНомер,СтрПоиска)=0
				и Найти(С.ГосНомер,СтрПоиска)=0 ТОгда
				Продолжить;
			КонецЕсли;
		КонецеСЛИ;
		
		ТекСтроки = тДрево.строки.Добавить();
		ЗаполнитьЗначенияСвойств(ТекСтроки,С);
		
		итСтр = "";
		Мас = ТБл.НайтиСтроки(Новый Структура("ТС,ГарНомер,ГосНомер",С.ТС,С.ГарНомер,С.ГосНомер));
		ДЛя каждого Эл из Мас Цикл
			Если СокрЛП(Эл.Вид)="" ТОгда ПродолжитЬ; КонецеСЛИ;
			новСтр = ТекСтроки.строки.Добавить();
			НовСтр.ТС = Эл.Сотр;
			Новстр.Вид   = Эл.Вид;
			НовСтр.ГарНомер = Эл.Номер;
			Если ЗначениеЗаполнено(Эл.дтКон) ТОгда
				НовСтр.ГосНомер = ""+Формат(Эл.дтНач,"ДФ=dd.MM")+"-"+Формат(Эл.дтКон,"ДФ=dd.MM.yy");
			ИНаче
				НовСтр.ГосНомер = Формат(Эл.дтНач,"ДФ=dd.MM.yy");
			КонецЕСЛИ;
			
			Если Найти(Эл.Вид,"Рем")<>0 ТОгда
				итСтр = итСтр+"; "+Эл.Вид;
			ИНАче
				п = СтрЗаменить(Эл.Сотр," ",Символы.ПС);
				итСтр = итСтр+"; "+СтрПолучитьСтроку(п,1);
			КонецЕСЛИ;
			
		КонецЦикла;
		
		ТекСтроки.Вид = Сред(итСтр,3);
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(тДрево, "Древо");
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокПодр()
	
	Т = итТбл.Выгрузить(,"Подр");
	Т.Свернуть("Подр","");
	Т.Сортировать("Подр");
	Элементы.Подразделение.СписокВыбора.ЗагрузитьЗначения(Т.выгрузитьКолонку("Подр"));
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда=Неопределено)
	Данные();
	ОбновитьСписокПодр();
	ОбновитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ОбновитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Обновить();
КонецПроцедуры

&НаКлиенте
Процедура СтрПоискаПриИзменении(Элемент)
	ОбновитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура QRкод(Команда)
	текСтр = Элементы.Древо.ТекущаяСтрока;
	Если ЗначениеЗаполнено(текСтр)=Ложь Тогда 
		Сообщить("Нет объекта для печати!");
		Возврат; 
	КонецЕСЛИ;
	
	
	Фрм = ПолучитьФорму("Обработка.СписокТС.Форма.ФормаQR");
	Стк = ПолучитьQR(текСтр,Фрм.УникальныйИдентификатор);
	Если Стк=Неопределено ТОгда Возврат; КонецеСЛИ;
	ЗаполнитьЗначенияСвойств(фрм,Стк);
	Фрм.Открыть();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьQR(НомСтр,АдресКарт)
	
	ТекСтр = Древо.НайтиПоИдентификатору(НомСтр);

	Орг = глДоступ.ПолучитьОрганизацию();
	Если Орг = Неопределено ТОгда Возврат Неопределено; КонецЕСЛИ;
	АПИ = СокрЛП(Орг.APIrestENT);
	Если АПИ = "" ТОгда Возврат Неопределено; КонецЕСЛИ; 
	
	СткСоединение = глОбщий.СткПолучитьСоединение(Орг);
		Соединение = Новый HTTPСоединение(
        СткСоединение.Сервер, // сервер (хост)
        СткСоединение.Порт, // порт, по умолчанию для http используется 80, для https 443
        СткСоединение.Логин, // пользователь для доступа к серверу (если он есть)
        СткСоединение.Пароль, // пароль для доступа к серверу (если он есть)
        , // здесь указывается прокси, если он есть
        , // таймаут в секундах, 0 или пусто - не устанавливать
          // защищенное соединение, если используется https
    );
	
	Стк = Новый Структура("ТС,ГарНомер,ГосНомер,Сотр");
	ЗаполнитьЗначенияСвойств(Стк,ТекСтр);
	Стк.Сотр = глДоступ.ПолучитьИмяПользователя();
	
	Запрос = Новый HTTPЗапрос("/"+АПИ+"/hs/entAPI/GETQR");
	хр = Новый ХранилищеЗначения(Стк,Новый СжатиеДанных(5));
	Запрос.УстановитьТелоИзСтроки(XMLСтрока(хр));
	
    Результат = Соединение.ОтправитьДляОбработки(Запрос);
	Если Результат.КодСостояния <> 200 Тогда 
		Сообщить("Ошибка синхронизации: код "+Результат.КодСостояния);
		Сообщить(результат.ПолучитьТелоКакСтроку());
		Возврат Неопределено;
	КонецЕСЛИ;
	
	БИН = Результат.ПолучитьТелоКакДвоичныеДанные();
	Карт = Новый Картинка(БИН);
	Стк.Вставить("ПолеКартинки",ПоместитьВоВременноеХранилище(Карт,АдресКарт));
	
	Возврат Стк;
	
КонецФункции

&НаСервере
Функция ЗатратыНаСервере(НомСтр)
	
	ТекСтр = Древо.НайтиПоИдентификатору(НомСтр);

	Орг = глДоступ.ПолучитьОрганизацию();
	Если Орг = Неопределено ТОгда Возврат Неопределено; КонецЕСЛИ;
	АПИ = СокрЛП(Орг.APIrest);
	Если АПИ = "" ТОгда Возврат Неопределено; КонецЕСЛИ; 
	
	СткСоединение = глОбщий.СткПолучитьСоединение(Орг);
		Соединение = Новый HTTPСоединение(
        СткСоединение.Сервер, // сервер (хост)
        СткСоединение.Порт, // порт, по умолчанию для http используется 80, для https 443
        СткСоединение.Логин, // пользователь для доступа к серверу (если он есть)
        СткСоединение.Пароль, // пароль для доступа к серверу (если он есть)
        , // здесь указывается прокси, если он есть
        , // таймаут в секундах, 0 или пусто - не устанавливать
          // защищенное соединение, если используется https
    );
	
	Запрос = Новый HTTPЗапрос("/"+АПИ+"/hs/invAPI/ZTRTS?OS="+СокрЛП(ТекСтр.ГарНомер));
	
    Результат = Соединение.Получить(Запрос);
	Если Результат.КодСостояния <> 200 Тогда 
		Сообщить("Ошибка синхронизации: код "+Результат.КодСостояния);
		Сообщить(результат.ПолучитьТелоКакСтроку());
		Возврат Неопределено;
	КонецЕСЛИ;
	
	
	Возврат Результат.ПолучитьТелоКакСтроку(); 
	
КонецФункции

&НаКлиенте
Процедура Затраты(Команда)
	
	текСтр = Элементы.Древо.ТекущаяСтрока;
	Если ЗначениеЗаполнено(текСтр)=Ложь Тогда 
		Сообщить("Нет объекта для печати!");
		Возврат; 
	КонецЕСЛИ;
	
	
	СтрХМЛ = ЗатратыНаСервере(текСтр);
	Если СтрХМЛ=Неопределено ТОгда Возврат; КонецеСЛИ;
	Фрм = ПолучитьФорму("Обработка.СписокТС.Форма.ФормаЗтр");
	Фрм.ЗаполнитьХМЛ(стрХМЛ);
	Фрм.Открыть();
	
	
КонецПроцедуры
