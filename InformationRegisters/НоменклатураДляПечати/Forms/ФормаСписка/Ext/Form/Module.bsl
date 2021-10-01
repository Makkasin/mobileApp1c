﻿
&НаСервереБезКонтекста
Функция МасРег()
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	НоменклатураДляПечати.Номенклатура КАК Номенклатура
	               |ИЗ
	               |	РегистрСведений.НоменклатураДляПечати КАК НоменклатураДляПечати";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Номенклатура");
	
КонецФункции

&НаСервереБезКонтекста
Процедура УдалитьВсе()
	
	наб = РегистрыСведений.НоменклатураДляПечати.СоздатьНаборЗаписей();
	наб.Записать();
	
КонецПроцедуры


&НаКлиенте
Процедура ПечатьЭтикеток(Команда)
	
	  мас = МасРег();
	  
	  Для каждого эл из мас Цикл
		  глОбщийКлиент.ПечатьЭтикетки(эл,ложь,1);
	  КонецЦикла;
	  
	  УдалитьВсе();
	  
	 Элементы.Список.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура УдалитьВсе1(Команда)
	УдалитьВсе();
КонецПроцедуры
