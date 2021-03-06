
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Имя = ПолучитьИмяВременногоФайла("html");
	Шаблон = Обработки.СделатьПодпись.ПолучитьМакет("ШаблонДокумента");
	
	
	ТХТ = Новый ЗаписьТекста(Имя, "UTF-8");
	ТХТ.Записать(Шаблон.Область(1,1).Текст);
	ТХТ.Закрыть();
	
	ДокументHTML = Имя;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПриложениеПодписи(Команда)
	#Если МобильноеПриложениеКлиент Тогда
		//Путь = КаталогДокументов() + "sign.png";
		//
		//Картина = Новый Картинка;
		//Картина.Записать(Путь);

		НовВз = Новый ЗапускПриложенияМобильногоУстройства("android.intent.action.EDIT");        
		НовВз.Тип = "image/*";
		НовВз.Приложение = "ru.acode.sign";
		РезультатРаботы = НовВз.Запустить(Истина);
		Если НЕ РезультатРаботы Тогда
			Сообщить("Не удалось запустить программу!");
			Возврат
		КонецЕсли;
		Файл = НовВз.ДополнительныеДанные.Получить("ru.acode.sign.EXTRA_NAME_TEMP_FILE_PATH").Значение;
		Результат = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Файл));
		УдалитьФайлы(Файл);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПриложение(Команда)
	Путь = КаталогДокументов() + "sign.apk";
	УстановитьПриложениеСервер(Путь);
	ЗапуститьПриложение(Путь);
КонецПроцедуры
 
&НаСервере
Процедура УстановитьПриложениеСервер(Знач Путь)
	ПрПодписи = Обработки.СделатьПодпись.ПолучитьМакет("ПриложениеДляПодписи");
	ПрПодписи.Записать(Путь);
КонецПроцедуры

&НаКлиенте
Процедура ДокументHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	ДДКартины = СтрЗаменить(ДанныеСобытия.href,"data:image/png;base64,","");	
	ДД = Base64Значение(ДДКартины);
	Результат = ПоместитьВоВременноеХранилище(ДД);
КонецПроцедуры

