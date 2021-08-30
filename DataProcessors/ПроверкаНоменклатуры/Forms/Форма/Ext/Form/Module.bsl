﻿&НаКлиенте
Перем КонстантаСклад;


&НаКлиенте
Процедура ЗаполнитьОснование(ДанныЕ)
	
	СткРез = глОбщийКлиент.ЗаполнитьОснование(ДанныЕ);
	
	ЭтаФорма.ДопИНфо = "";
	Для каждого Эл из СткРез Цикл
		ЭтаФорма.ДопИНфо = ЭтаФорма.ДопИНфо+Эл.Ключ+": "+Эл.Значение+Символы.ПС;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	ТекНом = Неопределено;
	ШтрихКод = "";
	Производитель = "";
	ДопИНфо = "";
	
	//Установка места
	Если Лев(Текст,3) = "(!)" Тогда
		ЭтаФорма.Место = Число(Сред(Текст,4));
		#Если МобильноеПриложениеКлиент Тогда
			СредстваМультимедиа.ВоспроизвестиТекст("Место "+ЭтаФорма.Место); 
		#КонецЕсли
		Текст="";
	ИНачеЕсли стрДлина(Текст)>21  Тогда
		ЗаполнитьОснование(Текст);
		Текст="";
	ИНаче
		ТекНом = глОбщий.НоменклатураАвтоПодборНаСервере(Текст,ШтрихКод,Производитель);
	КонецЕСЛИ;
	
	
	Если ТекНом <> Неопределено Тогда
		Сигнал();
		Текст = "";
		ЭтаФорма.СтрокаПодбора = "";
		ЭтаФорма.Номенклатура = ТекНом;
		
	ИНаче
		ЭтаФорма.СтрокаПодбора = Текст;
		Если СтрДлина(Текст)>7 Тогда
			ВопросШтрихКод();
		КонецеслИ;
		
		ЭтаФорма.Номенклатура = Неопределено;
	КонецеСЛИ;
	
	ОбновитьОтображениеДанныхФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросШтрихКод()
	
	Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопрос",ЭтотОбъект); // Прописываем название процедуры-обработчика.
	
	
	
	ПоказатьВопрос(Оповещение, "Записать штрих-код?",  // вместо привычного "Вопрос", теперь "ПоказатьВопрос"
	
	РежимДиалогаВопрос.ДаНет,
	
	0,  // задержка (секунды). необязательно
	
	КодВозвратаДиалога.Да, // задает кнопку по умолчанию. необязательно
	
	"" // устанавливаем заголовок. необязательно
	
);
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопрос(Результат, Параметры) Экспорт // здесь, думаю, комментировать нечего


Если Результат = КодВозвратаДиалога.Да Тогда
	
	Фрм = ПолучитьФорму("РегистрСведений.ШтрихКоды.Форма.ФормаЗаписи",,ЭтаФорма,ЭтаФорма);
	Фрм.ЭтаФорма.Запись.ШтрихКод = ЭтаФорма.СтрокаПодбора;
	Фрм.Открыть();
	
КонецЕсли;

ЭтаФорма.СтрокаПодбора = "";

КонецПроцедуры


&НаКлиенте
Процедура ОбновитьОтображениеДанныхФормы()
	
	ЭтаФорма.Остаток = ПолучитьТхтОстатки(ЭтаФорма.Номенклатура,КонстантаСклад);
	
	//#Если МобильныйКлиент Тогда
		ЭтаФорма.ТекущийЭлемент = элементы.СтрокаПодбора;
		ЭтаФорма.НачатьРедактированиеЭлемента();
	//#КонецЕсли
	
КонецПроцедуры



&НаСервере
Функция ПолучитьТхтОстатки(текНом,КонстантаСклад)
	
	Если ЗначениеЗаполнено(текНом) = Ложь Тогда
		Возврат "";
	КонецЕСЛИ;
	
	
	пТекОст = "";
	ТБл = РегистрыСведений.Остатки.ПолучитьТблОстатки(КонстантаСклад,текНом,пТекОст);
	ТекОст = пТекОст;
	
	ТблОст.Загрузить(Тбл);
	
	тблДВж.Загрузить(ПолучитьТблДвж(текНом));
	
	Возврат ТекОст;
	
	
КонецФункции

Функция ПолучитьТблДвж(ТекНом)
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	двжТМЦ.Дата КАК Дата,
	               |	двжТМЦ.Сотрудник КАК Сотрудник,
	               |	двжТМЦ.ГарНомер КАК ГарНомер,
	               |	двжТМЦ.ТС КАК ТС,
	               |	двжТМЦ.Количество КАК Количество
	               |ИЗ
	               |	Справочник.двжТМЦ КАК двжТМЦ
	               |ГДЕ
	               |	двжТМЦ.Номенклатура = &Номенклатура
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Дата УБЫВ";
	Запрос.УстановитьПараметр("Номенклатура",ТекНом);
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если МобильноеПриложениеКлиент Тогда
		ПодключитьОбработчикОжидания("ФокусНаПодбор",1,Ложь);
	#КонецЕсли
	
	СекундВПолеМесто = 0;

	КонстантаСклад = глДоступ.ПолучитьОсновнойСклад();
	Если ЗначениеЗаполнено(КонстантаСклад) = Ложь ТОгда
		отказ = истина;
		Сообщить("Не выбран склад!");
	КонецЕСЛИ;
	
	Стк = глОбщий.ОбновитьДтСинхроНасервере();
	ЭтаФорма.тхтОстатки = "Остатки загружены "+стк.остатки;

	
КонецПроцедуры


&НаКлиенте
Процедура ФокусНаПодбор()
	
	Если ТипЗнч(ЭтаФорма.ТекущийЭлемент)=Тип("ПолеФормы") Тогда
		Простой = ложЬ;
		
		Если ЭтаФорма.ТекущийЭлемент.Имя = "СтрокаПодбора" Тогда
			ЭтаФорма.НачатьРедактированиеЭлемента();
			Возврат;
		КонецЕСЛИ;
	КонецЕСЛИ;
	
	ЭтаФорма.ТекущийЭлемент = элементы.СтрокаПодбора;
	ЭтаФорма.НачатьРедактированиеЭлемента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЭтикетки(Команда)
	
	Если Команда.имя = "ПечатьЭтикеткиСУказаниемПринтера" Тогда
		глОбщийКлиент.ПечатьЭтикетки(ЭтаФорма.Номенклатура,Истина);
	ИНаче
		глОбщийКлиент.ПечатьЭтикетки(ЭтаФорма.Номенклатура);
	КонецЕСЛИ;

КонецПроцедуры

&НаКлиенте
Процедура СканироватьШтрихКод(Команда)
	#Если МобильноеПриложениеКлиент Тогда
		Опопвещение = Новый ОписаниеОповещения("ЗавершениеСканирования",ЭтотОбъект);
		СредстваМультимедиа.ПоказатьСканированиеШтрихКодов("Сканирование штрих-кода",Опопвещение);
		
		//бин = СредстваМультимедиа.СделатьФотоснимок(ТипКамерыУстройства.Задняя);
		//Сообщить(Бин.ТипСодержимого);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеСканирования(ШтрихКод,Результат,Сообщение,ДопПар ) Экспорт
	
	НоменклатураОкончаниеВводаТекста(Элементы.СтрокаПодбора, ШтрихКод, Неопределено, Неопределено, ложь);	
	#Если МобильноеПриложениеКлиент Тогда
		СредстваМультимедиа.ЗакрытьСканированиеШтрихКодов();
	#КонецЕсли

	
КонецПроцедуры



