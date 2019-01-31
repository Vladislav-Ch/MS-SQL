--запросы
use WeatherDB
go

--Запрос 1
declare @region nvarchar(50)
set @region = 'Юго-Запад России'
exec Proc1 @region
go

--Запрос 2
declare @region nvarchar(50)
declare @temp int
set @region = 'Северо-Восток России'
set @temp = -10
exec Proc2 @region, @temp
go

--Запрос 3
declare @language nvarchar(50)
set @language = 'Русский'
exec Proc3 @language 
go

--Запрос 5
declare @region nvarchar(50)
set @region = 'Юго-Запад России'
exec Proc5 @region
go

--Запрос 6
exec Proc6 
go

--Запрос 7
declare @region nvarchar (50)
set @region = 'Юго-Запад России'
exec Proc7 @region
go

backup database WeatherDB to dis='d:\PPS31-01\WeatherDB.bak'

drop database WeatherDB

restore database WeatherDB to dis='d:\PPS31-01\WeatherDB.bak'