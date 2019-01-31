--Создание БД
if DB_ID('Database1') is null
	create database Database1
go

use Database1
go

--если таблицы были созданы удаляем их 
if OBJECT_ID('Sellers') is not null
	drop table Sellers
go

if OBJECT_ID('Type_Clocks') is not null
	drop table Type_Clocks
go

if OBJECT_ID('Country') is not null
	drop table Country
go

if OBJECT_ID('Manufacturers') is not null
	drop table Manufacturers
go

if OBJECT_ID('Marka_Clock') is not null
	drop table Marka_Clock
go

if OBJECT_ID('Clock') is not null
	drop table Clock
go

if OBJECT_ID('Sales') is not null
	drop table Sales
go

--Создание таблиц
--Транзакции
BEGIN TRANSACTION

--Создание таблицы Продавци
create table Sellers (
	 id			int			 not null identity(1,1) constraint Sellers_PK primary key (id)
	,Surname	nvarchar(50) not null 
	,Name		nvarchar(50) not null
	,Patronymic nvarchar(50) not null
	,Passport	nvarchar(50) not null UNIQUE --данные должны быть уникальными
	,Procent	int			not null 
);
go

--создание точки сохранений
if(@@ERROR = 0) begin
print N'Таблица была создана Sellers'
save transaction Point
end
else
rollback transaction

--создание таблицы Тип часов
create table Type_Clocks(
	 id			int			not null identity(1,1) constraint Type_Clock_PK primary key (id)
	,Type_Clock nvarchar(50) not null 
); 
go

--создание точки сохранений
if(@@ERROR = 0) begin
print N'Таблица была создана Type_Clocks'
save transaction Point
end
else
rollback transaction Point

--создание таблицы страны
create table Country(
	 id			  int		  not null identity(1,1) constraint Country_PK primary key (id)
	,Name_Country nvarchar(50) not null
);
go

--создание точки сохранений
if(@@ERROR = 0) begin
print N'Таблица была создана Country'
save transaction Point
end
else
rollback transaction Point

--Создание таблицы Производители
create table Manufacturers(
	 id					int			not null identity(1,1) constraint Manufacturers_PK primary key (id)
	,Name_Manufacturers nvarchar(50) not null
	,ID_Country			int		    not null constraint ID_Country_FK foreign key (ID_Country) references Country (id)
);
go

--создание точки сохранений
if(@@ERROR = 0) begin
print N'Таблица была создана Manufacturers'
save transaction Point
end
else
rollback transaction Point

--создание таблицы Марка часов
create table Marka_Clock(
	 id			int			not null identity(1,1) constraint Marka_Clock_PK primary key (id)
	,Name_Marka nvarchar(50) not null
);
go

--создание точки сохранений
if(@@ERROR = 0) begin
print N'Таблица была создана Marka_Clock'
save transaction Point
end
else
rollback transaction Point

--создаем таблицу Часы
create table Clock(
	 id				  int	not null identity(1,1) constraint Clock_PK primary key (id)
	,ID_Marka_Clock	  int	not null constraint ID_Marka_Clock_FK foreign key (ID_Marka_Clock) references Marka_Clock (id)
	,ID_Type_Clocks   int	not null constraint ID_Type_Clocks foreign key (ID_Type_Clocks) references Type_Clocks(id)
	,Price			  float not null
	,CountInMag		  int	not null
	,ID_Manufacturers int	not null constraint ID_Manufacturers foreign key (ID_Manufacturers) references Manufacturers (id)
);
go

--создание точки сохранений
if(@@ERROR = 0) begin
print N'Таблица была создана Clock'
save transaction Point
end
else
rollback transaction Point

--Создание таблицы Продажи
create table Sales (
	 id			int  not null identity(1,1) constraint Sales_PK primary key (id)
	,Date_Sales date not null
	,ID_Sellers int  not null constraint ID_Sellers_FK foreign key (ID_Sellers) references Sellers (id)
	,ID_Clock   int  not null constraint ID_Clock foreign key (ID_Clock) references Clock (id)
	,CountSales int  not null
);

if(@@ERROR = 0) begin
print N'Таблица была создана Sales'
save transaction Point
end
else
rollback transaction Point

--Создание таблицы Копии Продаж
create table DeleteSales (
	 id			int  
	,Date_Sales date 
	,ID_Sellers int  not null constraint ID_Sellers_FK2 foreign key (ID_Sellers) references Sellers (id)
	,ID_Clock   int  not null constraint ID_Clock2 foreign key (ID_Clock) references Clock (id)
	,CountSales int  not null
);

if(@@ERROR = 0) begin
print N'Таблица была создана DeleteSales'
save transaction Point
end
else
rollback transaction Point

--Заполнение таблиц


--создаем уникальные индексы для каждой таблицы
create unique index UniqSellers	      on Sellers		(Name, Surname, Patronymic, Passport, Procent);
create unique index UniqType_Clocks   on Type_Clocks	(Type_Clock);
--create unique index UniqCountry		  on Country	    (Name_Country);
--create unique index UniqManufacturers on Manufacturers	(Name_Manufacturers, ID_Country);
--create unique index UniqMarka_Clock	  on Marka_Clock	(Name_Marka);
--create unique index UniqClock		  on Clock			(ID_Marka_Clock, ID_Type_Clocks, Price, CountInMag, ID_Manufacturers);
create unique index UniqSales		  on Sales			(Date_Sales, ID_Sellers, ID_Clock, CountSales);
exec sp_helpindex Sales;


--заполнение таблицы Sellers
insert into Sellers values
	 ('Козырев', 'Козырев', 'Константинович', 'ВК 76453', 10)
	,('Миронова', 'Дина', 'Георгиевна', 'ВК 87201', 6)
	,('Беляева', 'Дина', 'Константиновна', 'ИА 76510', 8)
	,('Киселёв', 'Аггей', 'Павлович', 'ФП 76105', 2)
	,('Мамедова', 'Мира', 'Иосифовна', 'ВК 18230', 4)
	,('Вирская', 'Лада', 'Борисовна', 'ВК 87109', 5)
go

--создание точки сохранений
if(@@ERROR = 0) begin
print N'Таблица была заполнена Sellers'
save transaction Point
end
else
rollback transaction

--заполнение таблицы Type_Clocks
insert into Type_Clocks values
	 ('Кварцевые')
	,('Механические')
	,('Детские')
	,('Электронные')
go

--создание точки сохранений
if(@@ERROR = 0) begin
print N'Таблица была заполнена Type_Clocks'
save transaction Point
end
else
rollback transaction Point

--заполнение таблицы Страны
insert into Country values
	 ('Россия')
	,('Швейцария')
	,('Америка')
	,('Украина')
go

--создание точки сохранений
if(@@ERROR = 0) begin
print N'Таблица была заполнена Country'
save transaction Point
end
else
rollback transaction Point

--заполнение таблицы Manufacturers
insert into Manufacturers values
	 ('Adriatica', 2)
	,('ВОСТОК', 1)
	,('Rado', 2)
	,('Patek Philippe', 2)
	,('Rolex', 2)
	,('АРТ-ТА', 4)
	,('ЕСТ', 4)
	,('Амфибия', 1)
	,('Престиж', 1)
	,('Omega', 3)
	,('Cartier', 3)
go

--создание точки сохранений
if(@@ERROR = 0) begin
print N'Таблица была заполнена Manufacturers'
save transaction Point
end
else
rollback transaction Point

--заполнение таблицы Marka_Clock
insert into Marka_Clock values
	 ('Восток-1')
	,('Восток-23')
	,('Восток-17')
	,('Rolex-1')
	,('Rolex-2')
	,('Rolex-3')
	,('Rado-1')
	,('Rado-2')
	,('ЕСТ- 1')
	,('ЕСТ-2')
	,('Cartier-1')
	,('Cartier-2')
	,('Престиж-1')
	,('Престиж-2')
	,('Adriatica-1')
	,('Adriatica-2')
go

--создание точки сохранений
if(@@ERROR = 0) begin
print N'Таблица была заполнена Marka_Clock'
save transaction Point
end
else
rollback transaction Point

--заполнение таблицы Clock
insert into Clock values
	 (1, 1, 1564, 12, 1)
	,(2, 2, 6574, 5, 2)
	,(5, 4, 6549, 8, 5)
	,(3, 1, 6849, 15, 8)
	,(10, 1, 9875, 25, 2)
	,(4, 2, 4877, 12, 4)
	,(16, 1, 987, 18, 4)
	,(11, 4, 6574, 10, 2)
	,(14, 2, 9874, 15, 1)
	,(13, 3, 6872, 2, 1)
	,(12, 1, 98742, 8, 2)
	,(6, 3, 65749, 5, 1)
go

--создание точки сохранений
if(@@ERROR = 0) begin
print N'Таблица была заполнена Clock'
save transaction Point
end
else
rollback transaction Point

--заполнение таблицы Sales
insert into Sales values
	 ('2018-02-15', 1, 12, 2)
	,('2018-02-17', 2, 1, 1)
	,('2018-03-01', 4, 10, 2)
	,('2018-03-01', 4, 1, 1)
	,('2018-02-25', 3, 2, 2)
	,('2018-02-02', 3, 5, 2)
	,('2018-02-10', 1, 8, 1)
	,('2018-02-12', 1, 9, 2)
	,('2018-03-01', 2, 10, 2)
	,('2018-02-28', 4, 4, 1)
	,('2018-03-05', 2, 6, 2)
go

--создание точки сохранений
if(@@ERROR = 0) begin
print N'Таблица была заполнена Sales'
COMMIT TRANSACTION
end
else
rollback transaction Point
go

