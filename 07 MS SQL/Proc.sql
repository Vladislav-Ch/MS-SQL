use WeatherDB
go
--Создание процедур и функций
-- Запрос 1
-- Вывести сведения о погоде в заданном регионе
create proc Proc1 @region nvarchar(50)
as
begin
	select
		(select Regions.Name_Region from Regions where Weather.ID_Region = Regions.id) as N'Регион'
		,Weather.[Date] as N'Дата'
		,Weather.Temperature as N'Температура'
		,Weather.Rainfall as N'Осадки'
	from
		Weather join Regions on Weather.ID_Region = Regions.id
	where
		Regions.Name_Region = @region
end
go
		
-- Запрос 2
-- Вывести даты когда в заданном регионе шел снег и температура была ниже заданной отрицательной
create proc Proc2 @region nvarchar(50), @temp int
as
begin
	select
		 (select Regions.Name_Region from Regions where Weather.ID_Region = Regions.id) as N'Регион'
		,Weather.[Date] as N'Дата'
		,Weather.Temperature as N'Температура'
		,Weather.Rainfall as N'Осадки'
	from
		Weather join Regions on Weather.ID_Region = Regions.id
	where
		Regions.Name_Region = @region and
		Weather.Temperature < @temp
end
go
		
-- Запрос 3
-- Вывести информацию о погоде за прошедшую неделю в регионах, жители которых общаются на заданном языке
create proc Proc3 @language nvarchar(50)
as
begin
	select
		(select Regions.Name_Region from Regions where Weather.ID_Region = Regions.id) as N'Регион'
		,Weather.[Date] as N'Дата'
		,Weather.Temperature as N'Температура'
		,Weather.Rainfall as N'Осадки'
	from
		Weather join Regions on Weather.ID_Region = Regions.id
				
	where
		Regions.ID_Type_People = (select Type_People.id from Type_People where Type_People.ID_Language = @language)
end
go
-- Запрос 4
-- Вывести среднюю температуру за прошедшую неделю в регионах с площадью больше заданной


-- Запрос 5
-- Увеличить в заданном регионе температуру на 2 градуса за июль 2017 года
create proc Proc5 @region nvarchar(50)
as
begin
	update Weather
	set Temperature = Temperature + 2
	where
		Weather.ID_Region = (select Regions.id from Regions where Regions.Name_Region = @region) and
		Weather.[Date] between '2018-01-01' and '2018-01-30'
end
go
		

-- Запрос 6
-- Заменить вид осадков «дождь» на «снег» в зимние месяцы
create proc Proc6
as
begin
	update Weather
	set Rainfall = 'Снег'
	where
		Weather.[Date] between '2018-01-01' and '2018-03-30' and
		Rainfall = 'Дождь'
end
go

-- Запрос 7
-- Удалить данные о погоде в заданном регионе за заданный период
create proc Proc7 @region nvarchar(50)
as
begin
	delete Weather
	where
		 Weather.[Date] between '2018-01-01' and '2018-03-30' and
		 Weather.ID_Region = (select Regions.id from Regions where Regions.Name_Region = @region)
end
go