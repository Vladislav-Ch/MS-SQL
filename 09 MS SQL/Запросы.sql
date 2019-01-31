--Запросы
use Database1
go

--Запрос 1
--Вывести марки заданного типа
declare @mark nvarchar(50) 
set @mark = N'Кварцевые'

exec Proc1 @mark
go

--Запрос 2
--Вывести марки часов в заданной стране
declare @country nvarchar(50)
set @country = 'Россия'

exec Proc2 @country
go

--запрос 3
--продажи за период времени
declare @date1 date
declare @date2 date
set @date1 = '2018-02-01'
set @date2 = '2018-02-15'

exec Proc3 @date1, @date2
go

--запрос 4
--продажи по продавцу и  периоду
declare @name nvarchar(50)
declare @date1 date
declare @date2 date

set @name = 'Аггей'
set @date1 = '2018-02-01'
set @date2 = '2018-03-15'

exec Proc4 @name, @date1, @date2
go

--Запрос 5
--Вывести информацию по мех. часам цена которая не превышает заданную
declare @mark nvarchar(50)
declare @price float

set @mark = 'Механические'
set @price = 10000

exec Proc5 @mark, @price
go

--запрос 6
--Средняя стоимость продажи по продавцам, упорядочить по убыванию стоимости
exec Proc6 
go

--запрос 7
--Продавцы количество и стоимость их продаж за последнюю неделю (для тестирования 
--оставить одного продавца без продаж)
declare @data1 date
declare @data2 date

set @data1 = '2018-01-28'
set @data2 = '2018-03-04'
exec Proc7 @data1, @data2
go

--запрос 8
--Изменение цены товара (на заданное число (сделаем по марке часов))
declare @mark nvarchar(50)
declare @price float

set @mark = 'Восток-1'
set @price = 10000

exec Proc8 @price, @mark
go

--запрос9
--вывести производителей, общая сумма сумма часов в магазине не превышает заданное число
declare @tmp int

set @tmp = 15

exec Proc9 @tmp
go

--Запрос 10
--Изменение количества товара (заданное кол-во) по опред марки
declare @count int
declare @mark nvarchar(50)

set @count = 10
set @mark = 'Rolex-1'

exec Proc10 @count, @mark
go

-- Запрос 11
-- Изменение названия производителя
declare @oldername nvarchar(50)
declare @newname nvarchar(50)

set @oldername = 'ВОСТОК'
set @newname = 'НОВЫЙ ВОСТОК'

exec Proc11 @oldername, @newname
go

--запрос 12
--Добавление часов
declare @merkaClock int
declare @type int
declare @price float
declare @count int
declare @Manuf int

set @merkaClock = 7
set @type = 1
set @price = 15000
set @count = 12
set @Manuf = 1

exec Proc12 @merkaClock, @type, @price, @count, @Manuf 
go

--запрос 13
--Добавление производителя
declare @name nvarchar(50)
declare @country int
 set @name = 'Новый производитель'
set @country = 1

exec Proc13 @name, 	@country	
go

--Запрос 14
--Добавление записи о продаже
declare @Date_Sales date
declare @ID_Sellers int
declare @ID_Clock int
declare @CountSales int

set @Date_Sales = '2018-03-05'
set @ID_Sellers = 1
set @ID_Clock = 12
set @CountSales =2

exec Proc14 @Date_Sales, @ID_Sellers, @ID_Clock, @CountSales
go

--Запрос 15
--Удаление записи о продаже - количество часов в магазине должно измениться
declare @id int
set @id = 2
exec Proc15 @id
 go

--Запрос 16
--Изменение количества проданных часов в записи о продаже - количество часов в магазине 
--должно измениться 
declare @countSales int
	,@idSelling int
set @countSales = 4
set @idSelling = 2
exec Proc16 @countSales, @idSelling
go

