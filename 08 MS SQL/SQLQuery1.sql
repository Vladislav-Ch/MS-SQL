--проверка на наличие БД
drop database WeatherDB
go

if DB_ID('WeatherDB') is null
	create database WeatherDB
go

use WeatherDB
go

-- Если таблицы по заданию уже созданы удаляем их
if OBJECT_ID('Languages') is not null
drop table Languages
go

if OBJECT_ID('Type_People') is not null
drop table Type_People
go

if OBJECT_ID('Regions') is not null
drop table Regions
go

if OBJECT_ID('Weather') is not null
drop table Weather
go

--создание таблиц  и точек сохранения
BEGIN TRANSACTION
--создание таблицы Languages
create table Languages (
	id		 int		  not null identity(1,1) constraint Lenguages_PK primary key (id)
   ,[Language] nvarchar(50) not null  
);

--точка сохранения
if(@@ERROR = 0) begin
print N'Создана таблица Languages'
save transaction Point
end
else
rollback transaction

--создание таблицы Type_People
create table Type_People (
	 id			 int		  not null identity(1,1) constraint Type_People_PK primary key (id)
	,Name_Type   nvarchar(50) not null
	,ID_Language int		  not null constraint ID_Language_FK foreign key (ID_Language) references Languages (id)
);

--создание точки сохранения
if(@@ERROR = 0) begin
print N'Создана таблица Type_People'
save transaction Point
end
else
rollback transaction Point

--Создание таблицы Regions 
create table Regions (
	 id				int			 not null identity(1,1) constraint Regions_PK primary key (id)
	,Name_Region	nvarchar(50) not null
	,Area			float		 not null
	,ID_Type_People int			 not null constraint ID_Type_People_FK foreign key (ID_Type_People) references Type_People (id) 
);

--создание точки сохранения
if(@@ERROR = 0) begin
print N'Создана таблица Regions'
save transaction Point
end
else
rollback transaction Point

--Создание таблицы Weather
create table Weather (
	id			int			 not null identity(1,1) constraint Weather_PK primary key (id)
   ,ID_Region	int			 not null constraint ID_Region_FK foreign key (ID_Region) references Regions (id)
   ,[Date]	    date		 not null
   ,Temperature int			 not null
   ,Rainfall	nvarchar(50) not null
);

--создание точки сохранения
if(@@ERROR = 0) begin
print N'Создана таблица Weather'
COMMIT TRANSACTION
end
else
rollback transaction Point



--Заполнение таблиц
use WeatherDB
go

BEGIN TRANSACTION
--создаем уникальные индексы для каждой таблицы
create unique index UniqLanguages	  on Languages	([Language]);
create unique index UniqType_People   on Type_People(Name_Type);
create unique index UniqRegions		  on Regions	(Name_Region);
create unique index UniqWeather		  on Weather	(ID_Region, [Date]);
exec sp_helpindex Weather;

--заполнение таблицы Languages
insert into Languages values
	 ('Русский')
	,('Украинский')
	,('Немецкий')
	,('Английский')

--точка сохранения
if(@@ERROR = 0) begin
print N'Таблица Languages заполнена'
save transaction Point
end
else
rollback transaction

--заполнение таблицы Type_People
insert into Type_People values 
	 ('Русские', 1)
	,('Украинцы', 2)
	,('Немцы', 3)
	,('Американцы', 4)

--точка сохранения
if(@@ERROR = 0) begin
print N'Таблица Type_People заполнена'
save transaction Point
end
else
rollback transaction Point

--заполнение таблицы Regions
insert into Regions values
	 ('Северо-Восток России', 28599, 1)
	,('Юго-Запад России', 15874, 1)
	,('Север Америки', 5894, 4)
	,('Запад Украины', 19512, 2)
	,('Центр Германии', 1589, 3)

--точка сохранения
if(@@ERROR = 0) begin
print N'Таблица Regions заполнена'
save transaction Point
end
else
rollback transaction Point

--заполнение таблицы Weather
insert into Weather values
	 (1, '2018-01-05', -25, 'Снег')
	,(2, '2018-01-15', -2, 'Дождь')
	,(3, '2018-02-01', -10, 'Снег')
	,(4, '2018-01-07', 0, 'Туман')
	,(5, '2018-02-25', 2, 'Без осадков')

--точка сохранения
if(@@ERROR = 0) begin
print N'Таблица Weather заполнена'
COMMIT TRANSACTION
end
else
rollback transaction Point

go