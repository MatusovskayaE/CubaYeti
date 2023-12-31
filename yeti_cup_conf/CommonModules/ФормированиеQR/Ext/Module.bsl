﻿функция ПолучитьГенераторQRкода()
	
	лМакетКомпоненты	= ПолучитьОбщийМакет("КомпонентаПечатиQRКода");
	
	лАдрес=ПоместитьВоВременноеХранилище(лМакетКомпоненты);
	
	ГенераторQRкода=неопределено;
	
	Попытка
		Если ПодключитьВнешнююКомпоненту(лАдрес,"QR") тогда
			ГенераторQRкода=новый("AddIn.QR.QRCodeExtension");
		Иначе
			сообщить("Не удалось подключить компоненту генерации QR кода");		
		КонецЕсли;
	Исключение
		Сообщить(ОписаниеОшибки());	
	КонецПопытки;
	
	Возврат ГенераторQRкода;
	
конецФункции

// Возвращает двоичные данные для формирования QR кода.
//
// Параметры:
//  QRСтрока         - Строка - данные, которые необходимо разместить в QR-коде.
//
//  УровеньКоррекции - Число - уровень погрешности изображения при котором данный QR-код все еще возможно 100%
//                             распознать.
//                     Параметр должен иметь тип целого и принимать одно из 4 допустимых значений:
//                     0(7% погрешности), 1(15% погрешности), 2(25% погрешности), 3(35% погрешности).
//
//  Размер           - Число - определяет длину стороны выходного изображения в пикселях.
//                     Если минимально возможный размер изображения больше этого параметра - код сформирован не будет.
//
// Возвращаемое значение:
//  ДвоичныеДанные  - буфер, содержащий байты PNG-изображения QR-кода.
// 
// Пример:
//  
//  // Выводим на печать QR-код, содержащий в себе информацию зашифрованную по УФЭБС.
//
//  QRСтрока = УправлениеПечатью.ФорматнаяСтрокаУФЭБС(РеквизитыПлатежа);
//  ТекстОшибки = "";
//  ДанныеQRКода = получитьQRкод(QRСтрока, 0, 190);
//  Если ДанныеQRКода=неопределено тогда
//  возврат;
//  КонецЕсли;
//
//  КартинкаQRКода = Новый Картинка(ДанныеQRКода);
//  ОбластьМакета.Рисунки.QRКод.Картинка = КартинкаQRКода;
//
Функция ПолучитьQRкод(QRСтрока, УровеньКоррекции, Размер) Экспорт
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	
	ГенераторQRКода = ПолучитьГенераторQRкода();
	
	Если ГенераторQRКода = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		ДвоичныеДанныеКартинки = ГенераторQRКода.GenerateQRCode(QRСтрока, УровеньКоррекции, Размер);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	Возврат ДвоичныеДанныеКартинки;
	
КонецФункции

Функция РазобратьСтроку(Стр, Разделитель) Экспорт
	
	МассивСтроки = Новый Массив;
	
	Если ПустаяСтрока(Стр) Тогда
		Возврат МассивСтроки;	
	КонецЕсли; 
	
	Поиск = Найти(Стр,Разделитель);
	Пока Поиск<>0 Цикл
		ПодСтр = Лев(Стр,Поиск-1);
		МассивСтроки.Добавить(СтрЗаменить(ПодСтр,"""",""));
		Стр = Сред(Стр,Поиск+1);		
		Поиск = Найти(Стр,Разделитель);
	КонецЦикла; 
	МассивСтроки.Добавить(СтрЗаменить(Стр,"""",""));
	
	Возврат МассивСтроки;
	
КонецФункции
