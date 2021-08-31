﻿
&НаКлиенте
Процедура ПечатьМеста()
	
	АдресПринтера = глОбщий.АдресПринтера();
	
	Стр = "";
	Если Стеллаж<>0 Тогда
		Стр=Стр+Стеллаж;
	КонецеСЛИ;
	Если Линия<>0 Тогда
		Стр=Стр+Линия;
	КонецеСЛИ;
	
	Для а=1 по Макс(1,ряд) Цикл
		Для б=1 по макс(1,Полка) Цикл
		п=Стр+а+б;
		глВыгрузкаДанных.ПечатьZPL(п,АдресПринтера,Истина);
		КонецЦикла;
	КонецЦиклА;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьОдноМесто()
	
	АдресПринтера = глОбщий.АдресПринтера();
	глВыгрузкаДанных.ПечатьZPL(Формат(Место,"ЧГ=0"),АдресПринтера,Истина);
	
КонецПроцедуры


&НаКлиенте
Процедура Печать(Команда)
	
	Если Команда.Имя = "ПечатьМесто" Тогда
		ОдноМесто= Истина;
	ИНаче
		ОдноМесто = ложь;
	КонецЕСЛИ;
		
	АдресПринтера = глОбщий.АдресПринтера();
	Если ЗначениеЗаполнено(АдресПринтера) = Ложь Тогда
		Стр = "";
		ООП = новый ОписаниеОповещения("ОкончаниеВводаСтроки",ЭтаФорма,ОдноМесто);
		ПоказатьВводСтроки(ООП,Стр,"Введите IP адрес принтера",,Ложь);
		ВозвраТ;
	КонецЕСЛИ;
	
	Если ОдноМесто Тогда
		ПечатьОдноМесто();
	ИНАче
		ПечатьМеста();
	КонецЕСЛИ;
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеВводаСтроки(Стр,ОдноМесто) Экспорт
	
	Если Стр = Неопределено Тогда ВозвраТ; КонецЕСЛИ;
	глОбщий.АдресПринтера(Стр);	
	Если ОдноМесто Тогда
		ПечатьОдноМесто();
	ИНАче
		ПечатьМеста();
	КонецЕСЛИ;
	
КонецПроцедуры


&НаКлиенте
Процедура СтеллажПриИзменении(Элемент)
	Стр = "";
	Если Стеллаж<>0 Тогда
		Стр=Стр+Стеллаж;
	КонецеСЛИ;
	Если Линия<>0 Тогда
		Стр=Стр+Линия;
	КонецеСЛИ;
	
	Рез = "";
	Для а=1 по Макс(1,ряд) Цикл
		Для б=1 по макс(1,Полка) Цикл
		п=Стр+а+б;
		Рез = Рез + п+"; ";
		КонецЦикла;
	КонецЦиклА;
	
	Элементы.ВидКод.Заголовок = "На печать : "+Рез;
КонецПроцедуры

