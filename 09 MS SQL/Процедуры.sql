--процедуры
use Database1
go
--1
--Вывести марки заданного типа
create proc Proc1 @mark nvarchar(50)
as
begin
	select
		(select Name_Marka from Marka_Clock where Clock.ID_Marka_Clock = Marka_Clock.id) as 'Марка' 
		,(select Type_Clock from Type_Clocks where Clock.ID_Type_Clocks = Type_Clocks.id) as 'Тип часов'
	from
		Clock join Type_Clocks on Clock.ID_Type_Clocks = Type_Clocks.id
	where 
		Type_Clock = @mark
end
go

--Запрос 2
--Вывести марки часов в заданной стране
create proc Proc2 @country nvarchar(50)
as
begin
	select
		(select Name_Marka from Marka_Clock where Clock.ID_Marka_Clock = Marka_Clock.id) as 'Марка' 
		,(select Type_Clock from Type_Clocks where Clock.ID_Type_Clocks = Type_Clocks.id) as 'Тип часов'
		,(select Name_Country from Country where Manufacturers.ID_Country = Country.id) as 'Страна'
	from
		Clock join Manufacturers on Clock.ID_Manufacturers = Manufacturers.id
			  join Country on Manufacturers.ID_Country = Country.id
	where
		Country.Name_Country = @country
end
go

--запрос 3
--продажи за период времени
create proc Proc3 @data1 date, @data2 date
as
begin
	select
		Sales.Date_Sales as 'Дата'
		,(select Surname + N' ' + SUBSTRING(Sellers.Name, 1, 1) + N'.' + SUBSTRING(Sellers.Patronymic, 1, 1) + N'.' from Sellers where ID_Sellers = Sellers.id) as 'Ф.И.О'
		,(select Name_Marka from Marka_Clock where Clock.ID_Marka_Clock = Marka_Clock.id) as 'Марка часов' 
		,(select Type_Clock from Type_Clocks where Clock.ID_Type_Clocks = Type_Clocks.id) as 'Тип часов'
		,Clock.Price as 'Цена'
	from
		Sales join Clock on Sales.ID_Clock = Clock.id
	where
		Sales.Date_Sales between @data1 and @data2
end
go 

--запрос 4
--продажи по продавцу и  периоду
create proc Proc4 @name nvarchar(50), @data1 date, @data2 date
as
begin
	select
		Sales.Date_Sales as 'Дата'
		,(select Surname + N' ' + SUBSTRING(Sellers.Name, 1, 1) + N'.' + SUBSTRING(Sellers.Patronymic, 1, 1) + N'.' from Sellers where ID_Sellers = Sellers.id) as 'Ф.И.О'
		,(select Name_Marka from Marka_Clock where Clock.ID_Marka_Clock = Marka_Clock.id) as 'Марка часов' 
		,(select Type_Clock from Type_Clocks where Clock.ID_Type_Clocks = Type_Clocks.id) as 'Тип часов'
		,Clock.Price as 'Цена'
	from
		Sales join Sellers on Sales.ID_Sellers = Sellers.id 
			  join Clock on Sales.ID_Clock = Clock.id
	where
		Sales.Date_Sales between @data1 and @data2 and
		Sellers.Name = @name
end
go

--Запрос 5
--Вывести информацию по мех. часам цена которая не превышает заданную
create proc Proc5 @mark nvarchar(50), @price float
as
begin
	select
		(select Name_Marka from Marka_Clock where Clock.ID_Marka_Clock = Marka_Clock.id) as 'Марка' 
		,(select Type_Clock from Type_Clocks where Clock.ID_Type_Clocks = Type_Clocks.id) as 'Тип часов'
		,Price as 'Цена'

	from
		Clock join Type_Clocks on Clock.ID_Type_Clocks = Type_Clocks.id
	where 
		Type_Clock = @mark and
		Price <= @price
end
go

--запрос 6
--Средняя стоимость продажи по продавцам, упорядочить по убыванию стоимости
create proc Proc6 
as
begin
	select
		(select Surname + N' ' + SUBSTRING(Sellers.Name, 1, 1) + N'.' + SUBSTRING(Sellers.Patronymic, 1, 1) + N'.' from Sellers where ID_Sellers = Sellers.id) as 'Ф.И.О'
		,AVG(Price) as Price
	from
		Sales join Sellers on Sales.ID_Sellers = Sellers.id
			  join Clock on Sales.ID_Clock = Clock.id
	
	group by Sales.ID_Sellers
	order by Price desc
end
go 

--запрос 7
--Продавцы количество и стоимость их продаж за последнюю неделю (для тестирования 
--оставить одного продавца без продаж)
create proc Proc7 @data1 date, @data2 date
as
begin
	select 
		(select Surname + N' ' + SUBSTRING(Sellers.Name, 1, 1) + N'.' + SUBSTRING(Sellers.Patronymic, 1, 1) + N'.' from Sellers where ID_Sellers = Sellers.id) as 'Ф.И.О'
		,COUNT(CountSales) as 'Кол-во продаж'
		,SUM(Price) as 'Сумма продаж'
	from
		Sales join Sellers on Sales.ID_Sellers = Sellers.id
			  join Clock on Sales.ID_Clock = Clock.id
	where 
		Sales.Date_Sales between @data1 and @data2
	group by Sales.ID_Sellers
end
go

--запрос 8
--Изменение цены товара (на заданное число (сделаем по марке часов))
create proc Proc8 @price float, @mark nvarchar(50)
as
begin
	update Clock
	set Price += @price
	from
		Clock join Marka_Clock on Clock.ID_Marka_Clock = Marka_Clock.id
	where 
		Name_Marka = @mark
end
go

--запрос9
--вывести производителей, общая сумма сумма часов в магазине не превышает заданное число
create proc Proc9 @tmp int
as
begin
	select
		 Manufacturers.Name_Manufacturers as 'Производитель'
		,CountInMag as 'Кол-во в магазине'
	from
		Clock join Manufacturers on Clock.ID_Manufacturers = Manufacturers.id
	where
		Clock.CountInMag < @tmp
end
go

--Запрос 10
--Изменение количества товара (заданное кол-во) по опред марки
create proc Proc10 @count int, @mark nvarchar(50)
as
begin
	update Clock
	set CountInMag += @count
	from
		Clock join Marka_Clock on Clock.ID_Marka_Clock = Marka_Clock.id
	where
		Name_Marka = @mark
end
go
	
-- Запрос 11
-- Изменение названия производителя
create proc Proc11 @oldername nvarchar(50), @newname nvarchar(50)
as
begin
	update Manufacturers
	set Name_Manufacturers = @newname
	where 	Name_Manufacturers = @oldername
end
go

--запрос 12
--Добавление часов
create proc Proc12 @merkaClock int, @type int, @price float, @count int, @Manuf int
as
begin
	insert into Clock values
		(@merkaClock, @type, @price, @count, @Manuf)
end
go

--запрос 13
--Добавление производителя
create proc Proc13 @name nvarchar(50), @counrty int
as
begin
	insert into Manufacturers values
		(@name, @counrty)
end
go

--Запрос 14
--Добавление записи о продаже
create proc Proc14 @Date_Sales date, @ID_Sellers int, @ID_Clock int, @CountSales int
as
begin
	insert into Sales values
	(@Date_Sales, @ID_Sellers, @ID_Clock, @CountSales)
exec Proc14_1 @CountSales
end
go
--изменение кол-во часов в таблице Часы
create proc Proc14_1 @countClock int
as
begin
	update Clock
	set CountInMag -= @countClock
	from Clock join Sales on Clock.id = Sales.ID_Clock
end
go

--Запрос 15
--Удаление записи о продаже - количество часов в магазине должно измениться 
--сначала копируем в таблицу удаленных продаж(DeleteSales), потом удаляем из основной таблицы (Sales)
create proc Proc15 @id int
as
begin
	INSERT INTO DeleteSales (id, Date_Sales, ID_Sellers, ID_Clock, CountSales)
	select id, Date_Sales, ID_Sellers, ID_Clock, CountSales
	FROM Sales
	WHERE Sales.id = @id
exec Proc15_1 @id
end
go
create proc Proc15_1 @id int
as
begin
	delete
		
	from
		Sales
	where
		Sales.id = @id
end
go

create proc ProcUpd @count int, @id_mark int
as
begin
	update Clock
	set CountInMag -= @count
	where Clock.ID_Marka_Clock = @id_mark
end
go
--Запрос 16
--Изменение количества проданных часов в записи о продаже - количество часов в магазине 
--должно измениться 
create proc Proc16 @count int, @idsel int
as
begin
	begin tran
	declare @idsellcheck int
	set @idsellcheck=(select Sales.id from Sales where Sales.id = @idsel);

	declare @countcheck int
	set @countcheck = (select Clock.CountInMag
				from Clock join Sales on Clock.id = Sales.ID_Clock
				where Sales.id = @idsel);
	if(@count > @countcheck)begin
		print N'Нельзя продать больше чем в магазине'
		rollback tran
	end
	else
	if(@idsel is NULL)begin
		print N'Нет данных'
		rollback tran
	end
	else
	begin
		update Sales
		set Sales.CountSales=abs(@count)
		where Sales.id=@idsellcheck

		update Clock
		set Clock.CountInMag -= abs(@count)
		from Clock join Sales on Clock.id=Sales.ID_Clock
		where Sales.id=@idsel
		commit tran
 	end
end
go




backup database Database1 to dis='d:\PPS31-01\Database1.bak'

drop database Database1

restore database Database1 to dis='d:\PPS31-01\Database1.bak'