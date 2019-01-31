create database Database1
go

--создание таблицы TypePublication1
create table TypePublication1(
	id				 int	      not null identity(1,1) constraint TypePublication_PK primary key (id)
	,TypePublication nvarchar(50) not null
);
go
--заполнение таблицы TypePublication1
insert into TypePublication1 values
	('Газета')
	,('Журнал')
go

--Формируем процедуры
--Запрос 1
--Выбирает из таблицы ИЗДАНИЯ информацию о доступных для подписки журналах, 
--стоимость 1 экземпляра для которых меньше заданной параметром процедуры
create function Function1(@price float)
returns table
as
return

select
	*
from
	Publications
where 
	Price < @price

--Запрос 2
--Выбирает из таблиц информацию о подписчиках, проживающих на заданной улице, 
--в заданном доме, которые оформили подписку на издание с заданным наименованием
create function Function2(@street nvarchar(50), @hous int, @namepub nvarchar(50))
returns table
as
return

select
	(select Surname + N' ' + SUBSTRING(Subscriber.Name, 1, 1) + N'.' + SUBSTRING(Subscriber.Patronymic, 1, 1) + N'.' from Subscriber where IDSubscriber = Subscriber.id) as 'Ф.И.О'
	,(select Publications.NamePublications from Publications where MyOrder.IDPublications = Publications.id) as 'Наименование издания'

	
from
	MyOrder join Publications on MyOrder.IDPublications = Publications.Id
where 
	Street like @street and HousNumber = @hous and Publications.NamePublications like @namepub

--Запрос 3
--Выбирает из таблицы ИЗДАНИЯ информацию об изданиях,
--для которых значение в поле Цена 1 экземпляра находится в диапазоне от 50 до 150 рублей
create function Function3 (@price1 float, @price2 float)
returns table
as
return

select
	*
from
	Publications
where
	Price between @price1 and @price2 

--Запрос 4
--Выбирает из таблицы ИЗДАНИЯ информацию об изданиях с заданной ценой 1 экземпляра. 
create function Function4 (@price float)
returns table
as
return

select
	*
from
	Publications
where
	Price = @price

--Запрос 5
--Выбирает из таблиц ИЗДАНИЯ и ПОДПИСКА информацию обо всех оформленных подписках, 
--для которых срок подписки есть значение из заданного диапазона. 
create function Function5 (@tmp1 int, @tmp2 int)
returns table
as
return

select
	(select Surname + N' ' + SUBSTRING(Subscriber.Name, 1, 1) + N'.' + SUBSTRING(Subscriber.Patronymic, 1, 1) + N'.' from Subscriber where IDSubscriber = Subscriber.id) as 'Ф.И.О'
	,(select Publications.NamePublications from Publications where MyOrder.IDPublications = Publications.id) as 'Наименование издания'
	,(select TypePublication from TypePublication where MyOrder.IDPublications = TypePublication.Id) as 'Тип издания'
	,(select Publications.Price from Publications where MyOrder.IDPublications = Publications.id) as 'Цена'
	,MyOrder.DateofSubscription as 'Дата'
	,MyOrder.PeriodSubscription as 'Период'
from
	MyOrder
where
	MyOrder.PeriodSubscription between @tmp1 and @tmp2

--Запрос 7
--Выполняет группировку по полю Вид издания. 
--Для каждого вида вычисляет максимальную и минимальную цену 1 экземпляра. Функция без параметров
create function Function7()
returns table
as
return

select
	(select TypePublication from TypePublication where Publications.IDTypePublications = TypePublication.Id) as 'Тип издания'
	,MIN(Price) as 'Мин Цена'
	,MAX(Price) as 'Макс Цена'
from
	Publications
group by
	Publications.IDTypePublications
	
--Запрос 8
--Выполняет группировку по полю Улица. Для каждой улицы вычисляет количество подписчиков, 
--проживающих на данной улице (итоги по полю Код получателя). Функция без параметров
create function Function8()
returns table 
as
return

select
	Street as 'Улица'
	,COUNT(MyOrder.IDSubscriber) as 'Кол-во подписчиков'
from
	MyOrder
group by
	Street;