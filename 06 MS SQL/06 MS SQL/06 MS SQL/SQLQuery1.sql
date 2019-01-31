create database Database1
go

BEGIN TRANSACTION
--создание таблицы TypePublication1
create table TypePublication(
	id				 int	      not null identity(1,1) constraint TypePublication_PK primary key (id)
	,TypePublication nvarchar(50) not null
);
go

--проверяем транзакцию
declare @point int
set @point = -1
if @@ERROR != 0 set @point = 0
save transaction PointOne

--заполнение таблицы TypePublication1
insert into TypePublication values
	('Газета')
	,('Журнал')
go

--создание таблицы Subscriber
create table Subscriber(
	id int not null identity(1,1) constraint Subscriber_PK primary key (id)
   ,Surname nvarchar(50) not null
   ,Name nvarchar(50) not null
   ,Patronymic nvarchar(50) not null
);

--проверяем транзакцию
if @@ERROR != 0 and @point = -1 set @point = 1
save transaction PointTwo

--Заполнение таблицы Subscriber
insert into Subscriber values
	('Иванов', 'Иван', 'Иванович')
   ,('Булкина', 'Светлана', 'Петровна')
   ,('Егоров', 'Сергей', 'Викторович')
   ,('Савельев', 'Виктор', 'Петрович')
   ,('Журавлева', 'Екатерина', 'Павловна')

--Создание таблицы Publications
create table Publications(
	id int not null identity(1,1) constraint Publications_PK primary key (id)
   ,NamePublications nvarchar(50) not null
   ,IDTypePublications int not null constraint IDTypePublications_FK foreign key (IDTypePublications) references TypePublication (id)
   ,Price float not null
);

if @@ERROR != 0 and @point = -1 set @point = 2
save transaction PointThree

--Заполнение таблицы Publications
insert into Publications values
	('Вечерняя Макеевка', 1, 150)
	,('OOP', 2, 88)
	,('Телегид', 2, 99,99)
	,('Голос Правды', 1, 120)

--Создание таблицы MyOrder
create table MyOrder(
	id int not null identity(1,1) constraint MyOrder_PK primary key (id)
	,IDSubscriber int not null constraint IDSubscriber_FK foreign key (IDSubscriber) references Subscriber (id)
	,Street nvarchar(50) not null 
	,HousNumber int not null
	,ApartNumber int not null
	,IDPublications int not null constraint IDPublications_FK foreign key (IDPublications) references Publications (id)
	,DateofSubscription date not null
	,PeriodSubscription int not null
);

if @@ERROR != 0 and @point = -1 set @point = 3
save transaction PointFour

--Заполнение таблицы MyOrder
insert into MyOrder values
	 (1, 'Артема', 23, 55, 1, 2017-11-01, 5)
	,(2, 'Пушкина', 2, 54, 3, 2017-11-15, 2)
	,(5, 'Украинская', 45, 2, 2, 2017-11-29, 3)
	,(3, 'Артема', 12, 4, 4, 2018-02-01, 4)
	,(4, 'Пушкина', 2, 49, 1, 2018-02-025, 4)

if @@ERROR != 0 and @point = -1 set @point = 4
save transaction PointFive

if @point = -1
	begin 
		print 'Транзакция успешно прошла'
		COMMIT TRANSACTION
	end
else
	begin

	if @point = 0
	begin
		print 'Транзакция не выполнена'
		COMMIT TRANSACTION
	end
	if @point  = 1
	begin
		print 'Транзакция сохранена в точке 1'
		COMMIT TRANSACTION
	end
	if @point  = 2
	begin
		print 'Транзакция сохранена в точке 2'
		COMMIT TRANSACTION
	end
	if @point  = 3
	begin
		print 'Транзакция сохранена в точке 3'
		COMMIT TRANSACTION
	end
	if @point  = 4
	begin
		print 'Транзакция сохранена в точке 4'
		COMMIT TRANSACTION
	end
end

