
Функция auth(login, password, champname)
	
	ТипAutentific	= ФабрикаXDTO.Тип("yeti_cup", "autentific");
	
	Результат		= ФабрикаXDTO.Создать(ТипAutentific);
	
	ТипUser			= ФабрикаXDTO.Тип("yeti_cup", "user");
	
	// добавим пустой пользователя
	// на случай если пользователей нема
	User			= ФабрикаXDTO.Создать(ТипUser);

	User.code		= "";
	User.name		= "";

	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ
	            	  |	Users.Код КАК code,
	            	  |	Users.Наименование КАК name,
	            	  |	Dostizheniya.role КАК role
	            	  |ИЗ
	            	  |	Справочник.Users КАК Users
	            	  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Dostizheniya КАК Dostizheniya
	            	  |		ПО (Users.Ссылка = Dostizheniya.profile.user_id
	            	  |				И Dostizheniya.championate.Наименование = &champname)
	            	  |ГДЕ
	            	  |	(ВРЕГ(Users.email) = ВРЕГ(&email)
	            	  |			ИЛИ НЕ СТРНАЙТИ(Users.phone_number, &phone) = 0)
	            	  |	И Users.password = &password";
	Запрос.УстановитьПараметр("email",		login);
	Запрос.УстановитьПараметр("phone",		Сред(login, 2));
	Запрос.УстановитьПараметр("password",	password);
	Запрос.УстановитьПараметр("champname",	champname);
	
	Выборка			= Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Результат.result	= Истина;
		
		User.code			= Выборка.code;
		User.name			= Выборка.name;
		
		Попытка
			Результат.role	= Перечисления.РолиНаЧемпионате.Индекс(Выборка.role);
		Исключение
			Результат.role	= 0;
		КонецПопытки;
		
	Иначе
		
		Результат.role		= "";
		Результат.result	= Ложь;
		
	КонецЕсли;
		
	Результат.user	= User;
	
	Возврат Результат;
	
КонецФункции

Функция champlist(date)
	
	ТипChampList	= ФабрикаXDTO.Тип("yeti_cup", "champlist");
	
	Результат		= ФабрикаXDTO.Создать(ТипChampList);
	
	ТипChamp		= ФабрикаXDTO.Тип("yeti_cup", "champ");

	// добавим пустой чемпионат
	// на случай если чемпионатов нема
	Champ		= ФабрикаXDTO.Создать(ТипChamp);
	
	Champ.code	= "";
	Champ.name	= "";
	
	Результат.champ.Добавить(Champ);
	
	
	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ
	            	  |	Championahips.Код КАК code,
	            	  |	Championahips.Наименование КАК name
	            	  |ИЗ
	            	  |	Справочник.Championahips КАК Championahips
	            	  |ГДЕ
	            	  |	(&ДатаНачала МЕЖДУ Championahips.begin_date И КОНЕЦПЕРИОДА(Championahips.end_date, ДЕНЬ)
	            	  |			ИЛИ &ДатаОкончания МЕЖДУ Championahips.begin_date И КОНЕЦПЕРИОДА(Championahips.end_date, ДЕНЬ))";
	Запрос.УстановитьПараметр("ДатаНачала",		date - 86400);
	Запрос.УстановитьПараметр("ДатаОкончания",	date + 86400);
	
	Выборка			= Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Champ		= ФабрикаXDTO.Создать(ТипChamp);
		
		Champ.code	= Выборка.code;
		Champ.name	= Выборка.name;
		
		Результат.champ.Добавить(Champ);
		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

Функция timelines(champname)
	
	ТипTimelines	= ФабрикаXDTO.Тип("yeti_cup", "timelines");
	
	Результат		= ФабрикаXDTO.Создать(ТипTimelines);
	
	ТипTimeline		= ФабрикаXDTO.Тип("yeti_cup", "timeline");

	// добавим пустое событие
	// на случай если событий нема
	Timeline		= ФабрикаXDTO.Создать(ТипTimeline);
	
	Timeline.code	= "";
	Timeline.name	= "";
	Timeline.description	= "";
	Timeline.picture		= "";
	
	Результат.timeline.Добавить(Timeline);
	
	Запрос			= Новый Запрос;
	
	Запрос.Текст	= "ВЫБРАТЬ
	            	  |	Timeline.Код КАК code,
	            	  |	Timeline.Наименование КАК name,
	            	  |	Timeline.event_descriptions КАК description,
	            	  |	Timeline.event_pictures КАК picture
	            	  |ИЗ
	            	  |	Справочник.Timeline КАК Timeline
	            	  |ГДЕ
	            	  |	Timeline.Владелец.Наименование = &champname";
	Запрос.УстановитьПараметр("champname",	champname);
	
	Выборка			= Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Timeline	= ФабрикаXDTO.Создать(ТипTimeline);
		
		Timeline.code	= Выборка.code;
		Timeline.name	= Выборка.name;
		Timeline.description	= Выборка.description;
		Timeline.picture		= Base64Строка(Выборка.picture.Получить());
		
		Результат.timeline.Добавить(Timeline);
		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

Функция profile(code, name)
	
	ТипProfile		= ФабрикаXDTO.Тип("yeti_cup", "profile");
	
	Profile			= ФабрикаXDTO.Создать(ТипProfile);
	
	// добавим пустой профиль
	// на случай если профиля нема

	Profile.fitst_name	= "";
	Profile.second_name	= "";
	Profile.last_name	= "";
	Profile.age			= "";
	Profile.birthday	= Дата(1,1,1);
	Profile.location	= "";
	Profile.school		= "";
	Profile.email		= "";
	Profile.phone		= "";
	Profile.photo		= "";
	Profile.role		= 0;

	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ
	            	  |	Profile.fitst_name КАК fitst_name,
	            	  |	Profile.second_name КАК second_name,
	            	  |	Profile.last_name КАК last_name,
	            	  |	Profile.age КАК age,
	            	  |	Profile.birthday КАК birthday,
	            	  |	Profile.location КАК location,
	            	  |	Profile.school КАК school,
	            	  |	Profile.photo КАК photo,
	            	  |	Profile.user_id.email КАК email,
	            	  |	Profile.user_id.phone_number КАК phone
	            	  |ИЗ
	            	  |	Справочник.Profile КАК Profile
	            	  |ГДЕ
	            	  |	Profile.user_id.Код = &code
	            	  |	И Profile.user_id.Наименование = &name";
	Запрос.УстановитьПараметр("code",		code);
	Запрос.УстановитьПараметр("name",		name);
	
	Выборка			= Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(Profile, Выборка, , "photo");
		
		ДанныеФото		= Выборка.photo.Получить();
		
		Если Не ДанныеФото = Неопределено Тогда
			
			Profile.photo	= Base64Строка(ДанныеФото);
			
		КонецЕсли;
		
	КонецЕсли;
		
	Возврат Profile;
	
КонецФункции

Функция historys(code, name)
	
	ТипHistorys		= ФабрикаXDTO.Тип("yeti_cup", "historys");
	
	Результат		= ФабрикаXDTO.Создать(ТипHistorys);
	
	ТипHistory		= ФабрикаXDTO.Тип("yeti_cup", "history");
	
	ТипChamp		= ФабрикаXDTO.Тип("yeti_cup", "champ");

	// добавим пустое достижение
	// на случай если достижений нема
	History			= ФабрикаXDTO.Создать(ТипHistory);
	
	Champ			= ФабрикаXDTO.Создать(ТипChamp);
	Champ.code		= "";
	Champ.name		= "";
	
	History.champ		= Champ;
	History.champdate	= Дата(1,1,1);
	History.role		= "";
	History.result		= 0;

	Результат.history.Добавить(History);
	
	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ
	            	  |	Dostizheniya.championate.Ссылка КАК champ,
	            	  |	Dostizheniya.championship_date КАК champdate,
	            	  |	Dostizheniya.result КАК result,
	            	  |	Dostizheniya.role КАК role
	            	  |ИЗ
	            	  |	РегистрСведений.Dostizheniya КАК Dostizheniya
	            	  |ГДЕ
	            	  |	Dostizheniya.profile.user_id.Код = &code
	            	  |	И Dostizheniya.profile.user_id.Наименование = &name";
	Запрос.УстановитьПараметр("code",		code);
	Запрос.УстановитьПараметр("name",		name);
	
	Выборка			= Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		History			= ФабрикаXDTO.Создать(ТипHistory);
		
		Champ			= ФабрикаXDTO.Создать(ТипChamp);
		Champ.code		= Выборка.champ.Код;
		Champ.name		= Выборка.champ.Наименование;
		
		History.champ		= Champ;
		History.champdate	= Выборка.champdate;
		History.result		= Выборка.result;
		History.role		= Строка(Выборка.role);

		Результат.history.Добавить(History);
		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

Функция ping()
	Возврат Истина;
КонецФункции

Функция checkqr(qr, champname)

	// в qr у нас предположительно данные
	// фио профиля + код пользователя
	
	Массив	= ФормированиеQR.РазобратьСтроку(qr, "|");
	
	ТипProfile		= ФабрикаXDTO.Тип("yeti_cup", "profile");
	
	Profile			= ФабрикаXDTO.Создать(ТипProfile);
	
	// добавим пустой профиль
	// на случай если профиля нема

	Profile.fitst_name	= "";
	Profile.second_name	= "";
	Profile.last_name	= "";
	Profile.age			= "";
	Profile.birthday	= Дата(1,1,1);
	Profile.location	= "";
	Profile.school		= "";
	Profile.email		= "";
	Profile.phone		= "";
	Profile.photo		= "";
	Profile.role		= 0;

	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ
	            	  |	ProfileRef.fitst_name КАК fitst_name,
	            	  |	ProfileRef.second_name КАК second_name,
	            	  |	ProfileRef.last_name КАК last_name,
	            	  |	ProfileRef.age КАК age,
	            	  |	ProfileRef.birthday КАК birthday,
	            	  |	ProfileRef.location КАК location,
	            	  |	ProfileRef.school КАК school,
	            	  |	ProfileRef.user_id.email КАК email,
	            	  |	ProfileRef.user_id.phone_number КАК phone,
	            	  |	ProfileRef.photo КАК photo,
	            	  |	Dostizheniya.role КАК role
	            	  |ИЗ
	            	  |	Справочник.Profile КАК ProfileRef
	            	  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Dostizheniya КАК Dostizheniya
	            	  |		ПО (ProfileRef.Ссылка = Dostizheniya.profile
	            	  |				И Dostizheniya.championate.Наименование = &champname)
	            	  |ГДЕ
	            	  |	ProfileRef.user_id.Код = &code";
	Запрос.УстановитьПараметр("code",		Массив[3]);
	Запрос.УстановитьПараметр("champname",	champname);

	Выборка			= Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(Profile, Выборка, , "photo, role");
		
		Profile.role		= Перечисления.РолиНаЧемпионате.Индекс(Выборка.role);
		
		ДанныеФото			= Выборка.photo.Получить();
		
		Если Не ДанныеФото = Неопределено Тогда
			
			Profile.photo	= Base64Строка(ДанныеФото);
			
		КонецЕсли;
		
	КонецЕсли;
		
	Возврат Profile;
	
КонецФункции

Функция search(search, champname)
	
	ТипProfiles		= ФабрикаXDTO.Тип("yeti_cup", "profiles");
	
	Результат		= ФабрикаXDTO.Создать(ТипProfiles);
	
	ТипProfile		= ФабрикаXDTO.Тип("yeti_cup", "profile");
	
	Profile			= ФабрикаXDTO.Создать(ТипProfile);
	
	// добавим пустой профиль
	// на случай если профиля нема

	Profile.fitst_name	= "";
	Profile.second_name	= "";
	Profile.last_name	= "";
	Profile.age			= "";
	Profile.birthday	= Дата(1,1,1);
	Profile.location	= "";
	Profile.school		= "";
	Profile.email		= "";
	Profile.phone		= "";
	Profile.photo		= "";
	Profile.role		= 0;
	
	Результат.profile.Добавить(Profile);

	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ
	            	  |	ProfileRef.fitst_name КАК fitst_name,
	            	  |	ProfileRef.second_name КАК second_name,
	            	  |	ProfileRef.last_name КАК last_name,
	            	  |	ProfileRef.age КАК age,
	            	  |	ProfileRef.birthday КАК birthday,
	            	  |	ProfileRef.location КАК location,
	            	  |	ProfileRef.school КАК school,
	            	  |	ProfileRef.user_id.email КАК email,
	            	  |	ProfileRef.user_id.phone_number КАК phone,
	            	  |	ProfileRef.photo КАК photo,
	            	  |	Dostizheniya.role КАК role
	            	  |ИЗ
	            	  |	Справочник.Profile КАК ProfileRef
	            	  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Dostizheniya КАК Dostizheniya
	            	  |		ПО (Dostizheniya.profile = ProfileRef.Ссылка)
	            	  |			И (Dostizheniya.championate.Наименование = &champname)
	            	  |ГДЕ
	            	  |	(ВРЕГ(ProfileRef.fitst_name) ПОДОБНО &ПолеПоиска
	            	  |			ИЛИ ВРЕГ(ProfileRef.second_name) ПОДОБНО &ПолеПоиска
	            	  |			ИЛИ ВРЕГ(ProfileRef.last_name) ПОДОБНО &ПолеПоиска)";
	Запрос.УстановитьПараметр("ПолеПоиска", "%" + ВРЕГ(search) + "%");
	Запрос.УстановитьПараметр("champname",	champname);
	
	Выборка			= Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Profile		= ФабрикаXDTO.Создать(ТипProfile);
		
		Profile.fitst_name	= "";
		Profile.second_name	= "";
		Profile.last_name	= "";
		Profile.age			= "";
		Profile.birthday	= Дата(1,1,1);
		Profile.location	= "";
		Profile.school		= "";
		Profile.email		= "";
		Profile.phone		= "";
		Profile.photo		= "";
		Profile.role		= 0;
		
		ЗаполнитьЗначенияСвойств(Profile, Выборка, , "photo, role");
		
		Попытка
			Profile.role	= Перечисления.РолиНаЧемпионате.Индекс(Выборка.role);
		Исключение
			Profile.role	= 0;
		КонецПопытки;
		
		ДанныеФото			= Выборка.photo.Получить();
		
		Если Не ДанныеФото = Неопределено Тогда
			
			Profile.photo	= Base64Строка(ДанныеФото);
			
		КонецЕсли;
		
		Результат.profile.Добавить(Profile);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции
