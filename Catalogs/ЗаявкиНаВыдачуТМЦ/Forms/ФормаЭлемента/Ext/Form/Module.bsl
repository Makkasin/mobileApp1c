﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	этаформа.ТолькоПросмотр = истина;
	п = нрег(глДоступ.ПолучитьИмяПользователя());
	рез = Ложь;
	Если Найти(п,"блинов")<>0 Тогда
		Рез = Объект.Статус=0;
	КонецЕСЛИ;
	
	Элементы.Согласовать.видимость = Рез;
	Элементы.Отказать.видимость = Рез;
КонецПроцедуры

&НаСервере
Процедура СогласоватьНаСервере(Рез)
	ОБк = РеквизитФормыВЗначение("Объект");
	Обк.Статус = рез;
	Обк.Записать();
	Попытка 
		глВыгрузкаДанных.ВыгрузитьЗапросыНаВыдачуТМЦ(Обк.ссылка);
		исключение конецпопытки;
КонецПроцедуры

&НаКлиенте
Процедура Согласовать(Команда)
	Если Команда.Имя = "Согласовать" Тогда
		СогласоватьНаСервере(1);
	ИНаче
		СогласоватьНаСервере(-1);
	КонецЕслИ;
	ОповеститьОбИзменении(ОБъект.Ссылка);
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Отказать(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры
