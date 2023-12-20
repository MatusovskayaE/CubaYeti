﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Процедура ЗагрузкаСайта(Адрес)
	
	// тут надо как-то понять - грузим ли в существующую папку
	// в принципе пох - создаем
	Сайт				= Справочники.Сайты.СоздатьГруппу();
	// получим "последний" каталог
	ВремКаталог			= Каталог;
	МестоСлеша			= СтрНайти(ВремКаталог, "\");
	Пока Не МестоСлеша = 0 Цикл
		ВремКаталог		= Сред(ВремКаталог, МестоСлеша + 1);
		МестоСлеша		= СтрНайти(ВремКаталог, "\");
	КонецЦикла;
	Сайт.Наименование	= ВремКаталог;
	Сайт.Записать();
	
	ТипыФайлов			= ПолучитьТипыФайлов();
	
	МассивДанных		= ПолучитьИзВременногоХранилища(Адрес);
	
	Для каждого Файл из МассивДанных Цикл
			
		Элемент					= Справочники.Сайты.СоздатьЭлемент();
		
		Элемент.Наименование	= Файл.Имя;
		Элемент.ТипЭлемента		= ТипыФайлов[Файл.Расширение];
		
		Элемент.Родитель		= Сайт.Ссылка;
		
		Элемент.Данные			= Новый ХранилищеЗначения(Файл.Данные);
		
		Элемент.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТипыФайлов()
	
	ТипыФайлов	= Новый Структура;
	
	Для каждого Пер из Перечисления.ТипыЭлементов Цикл
		
		ТипыФайлов.Вставить(Строка(Пер), Пер);
		
	КонецЦикла;
	
	Возврат ТипыФайлов;
	
КонецФункции
	
&НаКлиенте
Процедура ИмяКаталогаНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	
	ДиалогВыбораФайла	= Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	
	ДиалогВыбораФайла.Заголовок = НСтр("ru = 'Выберите каталог для загрузки'");
	ДиалогВыбораФайла.ПредварительныйПросмотр = Ложь;

	ДиалогВыбораФайла.Каталог = Элемент.ТекстРедактирования;
	
	Если ДиалогВыбораФайла.Выбрать() Тогда
		
		Каталог	= ДиалогВыбораФайла.Каталог;
		
		ТипыФайлов			= ПолучитьТипыФайлов();
		
		МассивФайлов		= НайтиФайлы(Каталог, "*.*");
				
		МассивДанных		= Новый Массив;
		
		Для каждого Файл из МассивФайлов Цикл
			
			// папки на хуй
			Если Файл.Расширение = "" Тогда
				Продолжить;
			КонецЕсли;
			
			// проверим расширения
			Если Не ТипыФайлов.Свойство(Сред(Файл.Расширение,2)) Тогда
				Продолжить;
			КонецЕсли;
			
			ЭлемДанных		= Новый Структура;
			ЭлемДанных.Вставить("Имя",			Файл.ИмяБезРасширения);
			ЭлемДанных.Вставить("Расширение",	Сред(Файл.Расширение,2));
			ЭлемДанных.Вставить("Данные",		Новый ДвоичныеДанные(Файл.ПолноеИмя));
			
			МассивДанных.Добавить(ЭлемДанных);
			
		КонецЦикла;
		
		ЗагрузкаСайта(ПоместитьВоВременноеХранилище(МассивДанных));
		
	КонецЕсли;
	
КонецПроцедуры
