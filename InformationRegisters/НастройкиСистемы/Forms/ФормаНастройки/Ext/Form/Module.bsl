
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	НастройкиСистемы.ИмяНастройки КАК ИмяНастройки,
	               |	НастройкиСистемы.Зн КАК Зн
	               |ИЗ
	               |	РегистрСведений.НастройкиСистемы КАК НастройкиСистемы
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Перечисление.НаименованиеНастройки КАК НаименованиеНастройки
	               |		ПО НастройкиСистемы.ИмяНастройки = НаименованиеНастройки.Ссылка";
	
	ТБл = Запрос.Выполнить().Выгрузить();
	Стк = новый структура();
	Для каждого Стр из Тбл Цикл
		Стк.Вставить(XMLСтрока(Стр.ИмяНастройки),Стр.Зн); 
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект,стк);
	
	
	ЭтаФорма.ТолькоПросмотр = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	Для каждого Эл из Элементы Цикл
		Если ТипЗнч(Эл)<>Тип("ПолеФормы") Тогда ПродолжитЬ; КонецЕСЛИ;
		глДоступ.УстановитьНАстройку(Эл.Имя,ЭтаФорма[Эл.Имя]);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписок(Команда)
	ПолучитьФорму("РегистрСведений.НастройкиСистемы.Форма.ФормаСписка").Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОрганизации(Команда)
	глВыгрузкаДанных.ЗагрузитьНоменклатуруАлга("ALLORG");
КонецПроцедуры
