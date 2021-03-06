&НаКлиенте
Функция МожноРедактироватьОффЛайн()
	
	Если ЗначениеЗаполнено(Объект.Ссылка)=Ложь Тогда возврат Истина; КонецЕСЛИ;
	Если Объект.ДатаИзменения = Дата(1,1,1) Тогда Возврат Ложь; КонецЕСЛИ;	
	Если Объект.ДатаСинхронизации = Дата(1,1,1) Тогда Возврат Истина; КонецЕСЛИ;	
	
	Возврат Ложь;
	
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если глДоступ.ДоступНоменклатура()=Ложь Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
		Возврат;
	КонецЕСЛИ;
	
	
	Если МожноРедактироватьОффЛайн()=Ложь  Тогда
		ЭтаФорма.КоманднаяПанель.Видимость=Ложь;
		Элементы.ФормаЗаписатьОнЛайн.Видимость = истина;
	КонецЕСЛИ;
	
	Если  Объект.ДатаИзменения <> Дата(1,1,1) 
		или Объект.ДатаСинхронизации <> Дата(1,1,1) Тогда
		Элементы.ДатаИзменения.Видимость = Истина;
		Элементы.ДатаСинхронизации.Видимость = истина;
	КонецЕСЛИ;
	
	Элементы.ЕдИзм.СписокВыбора.ЗагрузитьЗначения(ДанныеЕдИзм());
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеЕдИзм()
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ DISTINCT
	               |	Номенклатура.ЕдИзм КАК ЕдИзм
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура";
	ТБл =Запрос.Выполнить().Выгрузить();
	Возврат Тбл.ВыгрузитьКолонку("ЕдИзм");
	
КонецФункции



&НаСервере
Функция ЗаписатьОнЛайнНаСервере()
	
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
	
	// Вставить содержимое обработчика.
	Обк = РеквизитФормыВЗначение("Объект");
	Если  глВыгрузкаДанных.ВыгрузитьОбк(Новый Структура("ВидСпр","Номенклатура"),Соединение,Обк,1) Тогда
		//Обк.ОбменДанными.Загрузка = истина;
		//Обк.Записать();
		Возврат ИстинА;
	ИНаче
		Возврат Ложь;
	КонецЕСЛИ;
	
		
КонецФункции

&НаКлиенте
Процедура ЗаписатьОнЛайн(Команда)
	
	Если глДоступ.ДоступНоменклатура()=Ложь Тогда
		Возврат;
	КонецЕСЛИ;
	
	Если ЗаписатьОнЛайнНаСервере() Тогда
		ЭтаФорма.Прочитать();
		ЭтаФорма.Модифицированность = Ложь;
		ОповеститьОбИзменении(Объект.Ссылка);
		ЭтаФорма.Закрыть();
	КонецЕСЛИ;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если  МожноРедактироватьОффЛайн()=Ложь Тогда
		отказ = Истина;
		Сообщить("Можно записать только через кнопку <Запись ОнЛайн>");
	КонецЕСЛИ;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЭтикетки(Команда=Неопределено)
	
	ссНом = объект.Ссылка;
	Если ЗначениеЗаполнено(ссНом)=Ложь или ЭтаФорма.Модифицированность=Истина Тогда 
		Сообщить("Объект не записан!");
		Возврат; 
	КонецЕСЛИ;
	
	Если Команда.имя = "ПечатьЭтикеткиСУказаниемПринтера" Тогда
		глОбщийКлиент.ПечатьЭтикетки(ссНом,Истина);
	ИНаче
		глОбщийКлиент.ПечатьЭтикетки(ссНом);
	КонецЕСЛИ;

КонецПроцедуры

