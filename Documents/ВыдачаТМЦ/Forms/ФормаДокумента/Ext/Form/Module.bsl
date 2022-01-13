﻿&НаКлиенте
Перем ЗапретРедСФото;

&НаСервереБезКонтекста
Функция ПолучитьДО(ИНН,КонстантаСклад)
	сс = Справочники.Организации.НайтиПоКоду(ИНН);
	Если сс.Пустая() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Если сс = КонстантаСклад.Организация Тогда
		Возврат Справочники.Организации.ПустаяСсылка();
	ИНаче
		Возврат сс;
	КонецеСЛИ;
	
КонецФункции


&НаКлиенте
Процедура ЗаполнитьОснование(ДанныЕ)
	
	СткРез = глОбщийКлиент.ЗаполнитьОснование(ДанныЕ);
	
	ОБъект.ДокументОснование = СткРез.ВидДок+" №"+СткРез.номерПЛ+" от "+Формат(СткРез.ДатаПЛ,"ДФ=dd.MM.yyyy");
	
	ОБъект.гарНомер 	= СткРез.ГарНомер;
	ОБъект.ГосНомер 	= СткРез.ГосНомер;
	ОБъект.ТС			= СткРез.ТС;
	ОБъект.Сотрудник 	= СткРез.Сотрудник;
	ОБъект.ТабНомер	    = СткРез.ТабНомер;
	Если СокрЛП(СткРез.ИНН)<>"" Тогда
		организацияДО = ПолучитьДО(СткРез.ИНН,ОБъект.Склад);
		ОБъект.ИННДО  = СткРез.ИНН;
	ИНаче
		организацияДО = "";
		ОБъект.ИННДО  = "";
	КонецЕсли;
	Элементы.организацияДО.Видимость = ЗначениеЗаполнено(организацияДО);
	
	
КонецПроцедуры


&НаКлиенте
Процедура НоменклатураОкончаниеВводаТекста(Элемент, Текст="", ДанныеВыбора=Неопределено, ПараметрыПолученияДанных=Неопределено, СтандартнаяОбработка=Истина)
	СтандартнаяОбработка = ложь;
	
	ТекНом = Неопределено;
	
		
	Если стрДлина(Текст)>21  Тогда
		ЗаполнитьОснование(Текст);
		Текст="";
	ИначеЕсли СокрлП(ОБъект.ДокументОснование)="" ТОгда
		
		#Если МобильноеПриложениеКлиент Тогда
			СредстваМультимедиа.ВоспроизвестиТекст("Не указан документ основание!"); 
		#КонецЕсли
		Текст="";
	ИНаче
		ТекНом = глОбщий.НоменклатураАвтоПодборНаСервере(Текст,Текст);
	КонецЕСЛИ;
	
	
	Если ТекНом <> Неопределено Тогда
		Текст = "";
		ЭтаФорма.СтрокаПодбора = "";
		Если НайтиТекущуюСтроку(ТекНом) Тогда
			КолПлюс(Элемент,Ложь);
		ИНаче
			
			новСтр = Объект.Материалы.Добавить();
			текСтрСписка = Объект.Материалы.Количество();
			
			новСтр.Количество      = 1;
			новСтр.Номенклатура    = ТекНом;
		КонецЕсли;
		
		Сигнал();
		ЭтаФорма.Записать();
	ИНаче
		ЭтаФорма.СтрокаПодбора = Текст;
		
	КонецеСЛИ;
	
	ОбновитьОтображениеДанныхФормы();
	ПриИзмененииКоличество();
	этаФорма.Модифицированность=Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеДанныхФормы()
	
	Если текСтрСписка > Объект.Материалы.Количество() Тогда 
		ЭтаФорма.Заголовок = ""; 
		Возврат; 
	КонецеСЛИ;
	ТекСтр = Объект.Материалы[текСтрСписка-1];
	
	
	
	ЭтаФорма.Заголовок = "Остаток: "+ПолучитьТхтОстатки(ТекСтр.Номенклатура,Объект.Склад,ТекСтр.Количество);
	
	#Если МобильноеПриложение Тогда
		ЭтаФорма.ТекущийЭлемент = элементы.СтрокаПодбора;
		ЭтаФорма.НачатьРедактированиеЭлемента();
	#КонецЕсли
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТхтОстатки(текНоменклатура,ТекСклад,ТекКол)
	
	Если ЗначениеЗаполнено(текНоменклатура) = Ложь Тогда
		Возврат "";
	КонецЕСЛИ;
	
	Стк = РегистрыСведений.Остатки.ПолучитьОстатокПоНоменклатуре(ТекСклад,текНоменклатура);
	
	Возврат ""+ТекКол+"/"+(Стк.Остаток);//+ТекКол);
	
	
КонецФункции




&НаКлиенте
Функция НайтиТекущуюСтроку(ТекНом)
	
	мас = Объект.Материалы.НайтиСтроки(Новый структура("Номенклатура",ТекНом));
	Если Мас.Количество()=0 ТОгда 
		Возврат Ложь;
	КонецЕСЛИ;
	
	текСтрСписка = мас[0].номерСтроки;
	//Элементы.Материалы.ТекущаяСтрока=мас[0].ПолучитьИдентификатор();
	
	Возврат Истина;
	
	
КонецФункции

&НаКлиенте
Процедура КолПлюс(Команда,ОбновитьДанныеФормы=Истина)
	
	Если текСтрСписка > Объект.Материалы.Количество() Тогда Возврат; КонецеСЛИ;
	ТекСтр = Объект.Материалы[текСтрСписка-1];
	
	Если Команда.Имя = "КолМинус" Тогда
		Кол =  -1;
	Иначе
		Кол = 1;
	КонецЕсЛИ;
	
	ТекСтр.Количество = Макс(0,ТекСтр.Количество+кол);
	ИзменениеСтрокиДатаИзменения(текСтр);
	ПриИзмененииКоличество();
	
	Если ОбновитьДанныеФормы Тогда
		ОбновитьОтображениеДанныхФормы();
	КонецЕСЛИ;
	этаФорма.Модифицированность=Истина;
	ЭтаФорма.Записать();
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	Если текСтрСписка > Объект.Материалы.Количество() Тогда Возврат; КонецеСЛИ;
	ТекСтр = Объект.Материалы[текСтрСписка-1];
	
	Если текКолСписка>ТекСтр.Количество и Объект.ЕстьФото и ЗапретРедСФото=Истина Тогда
		Сообщить("Нельзя увеличивать количество с заверенной фотографией");
		возврат;
	КонецеслИ;
	
	ТекСтр.Количество = Макс(0,текКолСписка);
	ИзменениеСтрокиДатаИзменения(текСтр);
	
	ОбновитьОтображениеДанныхФормы();
	этаФорма.Модифицированность=Истина;
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеСтрокиДатаИзменения(текСтр)
	Если Объект.ЕстьФото=Ложь ТОгда Возврат; КонецеСЛИ;
	текСтр.ДатаИзменения = ТекущаяДата();
	Если Элементы.МатериалыДатаИзменения.Видимость = Ложь ТОгда
		Элементы.МатериалыДатаИзменения.Видимость = Истина;
	КонецеСЛИ;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.Ссылка)=ложь Тогда
		Объект.Дата = ТекущаяДата();
		Объект.Склад = глДоступ.ПолучитьОсновнойСклад();
	Иначе
		ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка,,ЭтаФорма.УникальныйИдентификатор);	
	КонецЕСЛИ;

	Если ЗначениеЗаполнено(Объект.Склад) = Ложь ТОгда
		отказ = истина;
		Сообщить("Не выбран склад!");
	КонецЕСЛИ;
	
	Если Объект.ЕстьФото Тогда
		фотоБин = ПолучитьНавигационнуюСсылку(Объект.ссылка,"фото");
	КонецеСЛИ;
	
	Если Параметры.Свойство("данныеПар") Тогда
		данныеПар = Параметры.данныеПар;
	КонецЕСЛИ;
	
	текСтрСписка = 1;
	

КонецПроцедуры

&НаКлиенте
Процедура СканироватьШтрихКод(Команда)
	
	#Если МобильноеПриложениеКлиент Тогда
		Опопвещение = Новый ОписаниеОповещения("ЗавершениеСканирования",ЭтотОбъект);
		СредстваМультимедиа.ПоказатьСканированиеШтрихКодов("Сканирование штрих-кода",Опопвещение);
	#КонецЕсли
	
КонецПроцедуры


&НаКлиенте
Процедура ЗавершениеСканирования(ШтрихКод,Результат,Сообщение,ДопПар ) Экспорт
	
	НоменклатураОкончаниеВводаТекста(Элементы.СтрокаПодбора, ШтрихКод, Неопределено, Неопределено, ложь);	
	#Если МобильноеПриложениеКлиент Тогда
		СредстваМультимедиа.ЗакрытьСканированиеШтрихКодов();
	#КонецЕсли

	ЭтаФорма.ТекущийЭлемент = элементы.СтрокаПодбора;
	ЭтаФорма.НачатьРедактированиеЭлемента();
	
КонецПроцедуры

&НаКлиенте
Процедура Фото(Команда)
	
	Прм = Новый Структура();
	
	Мас = Новый Массив;
	//Для каждого Стр из Объект.Материалы Цикл
	//	Стк = новый Структура("Номенклатура,Количество");
	//	ЗаполнитьЗначенияСвойств(Стк,Стр);
	//	Мас.Добавить(Стк);
	//Конеццикла;
	ПРм.Вставить("масном",мас);
	
	оо = новый ОписаниеОповещения("ПослеФото",этотОбъект);
	
	ОткрытьФорму("Документ.ВыдачаТМЦ.Форма.ФормаФото",ПРм,ЭтаФорма,,,,оо,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	если СокрЛП(АдресФотоХР)<>"" тогда
	   ПослеФото(Неопределено,Неопределено);	
	КонецЕСЛИ;
КонецПроцедуры

&НаКлиенте
Процедура ПослеФото(Рез,Пар) Экспорт
	Если Объект.ЕстьФото Тогда
		ЭтаФорма.ТекущийЭлемент=Элементы.стрФото;
		ЭтаФорма.Записать();
	КонецеслИ;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	
	ТекущийОбъект.ЕстьФото = Ложь;
	Если ЭтоАдресВременногоХранилища(АдресФотоХР)  Тогда
		ТекущийОбъект.фото = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресФотоХР));
	КонецЕсли;
	
	п = ТекущийОбъект.фото.Получить();
	Если ТипЗнч(п) = Тип("ДвоичныеДанные") Тогда
		ТекущийОбъект.ЕстьФото = п.Размер()>100;
	КонецЕСЛИ;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	фотоБин = ПолучитьНавигационнуюСсылку(Объект.ссылка,"фото");
	АдресФотоХР = Неопределено;
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	пСтр = "";
	Для каждого Стр из Объект.Материалы Цикл
		Если Стр.Количество <> 0 Тогда
			пСтр = пСтр+Лев(Стр.Номенклатура,20)+" ";
		КонецЕсли;
	КонецЦикла;
	Объект.СтрИнфо = пСтр;
КонецПроцедуры

&НаКлиенте
Процедура грпСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.стрФото Тогда
		Если Объект.ЕстьФото=ложь Тогда
			Фото(Неопределено);	
		КонецесЛИ;
	ИНачеЕсли ТекущаяСтраница = Элементы.стрОсновная Тогда
		ЭтаФорма.ТекущийЭлемент = элементы.СтрокаПодбора;
		ЭтаФорма.НачатьРедактированиеЭлемента();
	КонецеСЛИ;
КонецПроцедуры

&НаКлиенте
Процедура МатериалыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	текСтрСписка = ВыбраннаяСтрока+1;
	ПриИзмененииКоличество();
	ОбновитьОтображениеДанныхФормы();
	
	Если Элемент.ТекущийЭлемент.Имя = "МатериалыВесУтиль" Тогда
		оо = новый ОписаниеОповещения("ПослеВводаКоличестваМеталлолома",ЭтотОбъект);
		ПоказатьВводЧисла(оо,Элемент.ТекущиеДанные.ВесУтиль,"Укажите количество металлолома",9,3);
	КонецеСЛИ;
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаКоличестваМеталлолома(Рез,Пар) Экспорт
	
	Если Рез = Неопределено Тогда Возврат; КонецеСЛИ;
	Если текСтрСписка > Объект.Материалы.Количество() Тогда Возврат; КонецеСЛИ;
	Объект.Материалы[текСтрСписка-1].ВесУтиль = Рез;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКоличество()
	Если Объект.Материалы.Количество()<текСтрСписка Тогда
		текКолСписка = 0;	
	Иначе
		текКолСписка = Объект.Материалы[текСтрСписка-1].Количество;	
	КонецесЛИ;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)  
	
	ПриИзмененииКоличество();
	#Если МобильноеПриложениеКлиент Тогда
		ЭтаФорма.ТекущийЭлемент = элементы.СтрокаПодбора;
		ЭтаФорма.НачатьРедактированиеЭлемента();
	#КонецЕсли
	
	ЗапретРедСФото = Истина;
	Если ЗапретРедСФото=Истина Тогда
		Элементы.КолПлюс.Видимость = Объект.ЕстьФото=Ложь;
		Элементы.ГруппаПодбор.Видимость = Объект.ЕстьФото=Ложь;
	КонецеСЛИ;
	//Видимость колонки дата изменения
	Для каждого Стр из Объект.Материалы Цикл
		Если Стр.ДатаИзменения<>Дата(1,1,1) Тогда
			Элементы.МатериалыДатаИзменения.Видимость = Истина;
			Прервать;
		КонецеСЛИ;
	КонецЦикла;

	
	Если ДанныеПар<>"" тогда
		ЗаполнитьОснование(ДанныеПар);
		ЭтаФорма.Модифицированность = Истина;
	КонецеСЛИ;
	
	ЕстьМеталлоломПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ЕстьМеталлоломПриИзменении(Элемент=Неопределено)
	Если ЕстьМеталлолом=ложь ТОгда
		Для каждого Стр из Объект.Материалы Цикл
			Если Стр.ВесУтиль<>0 Тогда
				ЕстьМеталлолом = Истина;
				ПРервать;
			КонецеслИ;
		КонецЦикла;
		
	КонецеСЛИ;
	
	Элементы.МатериалыВесУтиль.Видимость = ЕстьМеталлолом;
КонецПроцедуры


	
