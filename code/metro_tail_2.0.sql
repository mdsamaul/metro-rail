--use master
use master;
go
--if exists then drop database 
if exists (select name from sys.databases where name ='MetroRailDb')
begin 
	drop database MetroRailDb;
end;
go

--create metroRailDb 
create database MetroRailDb
on primary(
	name ='metroRailDb_data_file',
	filename='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\metroRailDb_data_file.mdf',
	size=10mb,
	maxsize=100mb,
	filegrowth=10%
)
log on(
	name ='metroRailDb_log_file',
	filename='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\metroRailDb_log_file.mdf',
	size=5mb,
	maxsize=50mb,
	filegrowth=1mb
);
go

--use
use MetroRailDb;
go

--create Stations table
create table Stations (
    StationId int primary key identity(1,1),
    StationName varchar(100) not null,
    Location varchar(150) not null,
    OpenedDate DATE not null,
	 Status varchar(50) check (Status IN ('Operational', 'Under Maintenance'))
);
go

--insert into station table
insert into Stations (StationName, Location, OpenedDate, Status)
values 
('Uttara North', 'Uttara', '2022-12-28', 'Operational'),
('Uttara Center', 'Uttara', '2022-12-28', 'Operational'),
('Uttara South', 'Uttara', '2022-12-28', 'Operational'),
('Pallabi', 'Mirpur', '2022-12-28', 'Operational'),
('Mirpur 11', 'Mirpur', '2022-12-28', 'Operational'),
('Mirpur 10', 'Mirpur', '2022-12-28', 'Operational'),
('Kazipara', 'Mirpur', '2022-12-28', 'Operational'),
('Shewrapara', 'Mirpur', '2022-12-28', 'Operational'),
('Agargaon', 'Sher-e-Bangla Nagar', '2022-12-28', 'Operational'),
('Bijoy Sarani', 'Tejgaon', '2023-03-15', 'Operational'),
('Farmgate', 'Tejgaon', '2023-03-15', 'Operational'),
('Karwan Bazar', 'Tejgaon', '2023-03-15', 'Operational'),
('Shahbagh', 'Shahbagh', '2023-03-15', 'Operational'),
('Dhaka University', 'Dhaka', '2023-03-15', 'Operational'),
('bangladesh secretariat ', 'Dhaka', '2023-03-15', 'Operational'),
('Motijheel', 'Dhaka', '2023-03-15', 'Operational');
go
--lines table
create table Lines (
    LineId int primary key identity(1,1),
    LineName varchar(100) not null,
    Color varchar(50) not null,
    TotalStations int not null
);
go

--insert into lines table
insert into Lines (LineName, Color, TotalStations)
values 
('MRT Line 6', 'Red', 17);

--trains table
create table Trains (
    TrainId int primary key identity(1,1),
    TrainNumber varchar(50) not null,
    LineId int not null references Lines(LineId),
    Capacity int not null,
	Status varchar(50) check (Status IN ('Operational', 'Under Maintenance'))
);
go

--insert into data trains table
insert into Trains (TrainNumber, LineId, Capacity, Status)
values 
('Train 1', 1, 300, 'Operational'),
('Train 2', 1, 300, 'Operational'),
('Train 3', 1, 300, 'Operational'),
('Train 4', 1, 300, 'Operational'),
('Train 5', 1, 300, 'Operational'),
('Train 6', 1, 300, 'Operational'),
('Train 7', 1, 300, 'Operational'),
('Train 8', 1, 300, 'Operational'),
('Train 9', 1, 300, 'Operational'),
('Train 10', 1, 300, 'Operational');

--schedules table
create table Schedules (
    ScheduleId int primary key identity(1,1),
    TrainId int not null references Trains(TrainId),
    StationId int not null  references Stations(StationId),
    DepartureTime TIME,
    ArrivalTime TIME,
    DayOfWeek varchar(9) not null,
    Direction varchar(4) check (Direction IN ('Up', 'Down'))
);
go


-- insert Up platform schedule  Uttara North to Motijheel

insert into Schedules (TrainId, StationId, DepartureTime, ArrivalTime, DayOfWeek, Direction)
values 
(1, 1, '05:00:00', NULL, 'Monday', 'Up'),
(1, 2, '05:15:00', '05:10:00', 'Monday', 'Up'),
(1, 3, '05:30:00', '05:25:00', 'Monday', 'Up'),
(1, 4, '05:45:00', '05:40:00', 'Monday', 'Up'),
(1, 5, '06:00:00', '05:55:00', 'Monday', 'Up'),
(1, 6, '06:15:00', '06:10:00', 'Monday', 'Up'),
(1, 7, '06:30:00', '06:25:00', 'Monday', 'Up'),
(1, 8, '06:45:00', '06:40:00', 'Monday', 'Up'),
(1, 9, '07:00:00', '06:55:00', 'Monday', 'Up'),
(1, 10, '07:15:00', '07:10:00', 'Monday', 'Up'), 
(1, 11, '07:30:00', '07:25:00', 'Monday', 'Up'), 
(1, 12, '07:45:00', '07:40:00', 'Monday', 'Up'), 
(1, 13, '08:00:00', '07:55:00', 'Monday', 'Up'); 
go
--
-- down train   Motijheel on Monday (Down platform)

insert into Schedules (TrainId, StationId, DepartureTime, ArrivalTime, DayOfWeek, Direction)
values 
(10, 13, '05:00:00', NULL, 'Monday', 'Down'), 
(10, 12, '05:15:00', '05:10:00', 'Monday', 'Down'),
(10, 11, '05:30:00', '05:25:00', 'Monday', 'Down'),
(10, 10, '05:45:00', '05:40:00', 'Monday', 'Down'),
(10, 9, '06:00:00', '05:55:00', 'Monday', 'Down'), 
(10, 8, '06:15:00', '06:10:00', 'Monday', 'Down'), 
(10, 7, '06:30:00', '06:25:00', 'Monday', 'Down'), 
(10, 6, '06:45:00', '06:40:00', 'Monday', 'Down'), 
(10, 5, '07:00:00', '06:55:00', 'Monday', 'Down'), 
(10, 4, '07:15:00', '07:10:00', 'Monday', 'Down'), 
(10, 3, '07:30:00', '07:25:00', 'Monday', 'Down'), 
(10, 2, '07:45:00', '07:40:00', 'Monday', 'Down'), 
(10, 1, '08:00:00', '07:55:00', 'Monday', 'Down'); 
go

--Passengers table
create table Passengers (
    PassengerId int primary key identity(1,1),
    Name varchar(100) not null,
	Gender varchar(20) not null,
	Age int not null,
    ContactInfo varchar(150) not null,
    TicketNumber varchar(50) not null,
    JourneyDate DATE not null
);
go
--passenger table insert value
insert into Passengers (Name, Gender, Age, ContactInfo, TicketNumber, JourneyDate)
values
('Samaul',   'Male',20,'01981154473', 'TKT001', '2024-08-17'),
('Mimma',    'Female',25,'01981154478', 'TKT002', '2024-02-17'),
('Shihan',   'Male',4,'01981154479', 'TKT003', '2024-03-17'),
('Arafat',   'Male',30,'01981154470', 'TKT004', '2024-04-17'),
('Rta Akter','Female',35, '01981154471', 'TKT005', '2024-10-17');
go
--lineStations table
create table LineStations (
	LineStationId int identity(1,1),
    LineId int not null references Lines(LineId),
    StationId int not null references Stations(StationId),
    primary key (LineStationId, LineId, StationId)
);
go
--insert into Line Stations table

insert into LineStations ( LineId, StationId)
values
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(1, 16);
go
--route table
create table Routes (
    RouteId int primary key identity(1,1),
    StartingStationId int not null references Stations(StationId),
    EndingStationId int not null references Stations(StationId),
    Distance decimal(10,2) not null
);
go

--insert into Routes table
insert into Routes (StartingStationId, EndingStationId, Distance)
values
(1, 7, 3.20),   
(3, 5, 4.00),   
(5, 10, 5.75),  
(7, 14, 6.10),  
(9, 12, 4.30),  
(7, 2, 2.20),   
(13, 5, 3.50),  
(14, 10, 4.75), 
(10, 4, 3.20),  
(7, 3, 5.00);   
go

--ticket table
create table Tickets (
    TicketId int primary key identity(1,1),
    PassengerId int not null references Passengers(PassengerId),
    RouteId int not null references Routes(RouteId),
    TrainId int not null references Trains(TrainId),
    PurchaseDate DATE not null,
    TicketPrice decimal(10,2) not null
);
go

--log table tickets
 create table TicketLogs(
	TicketLogId int primary key identity(1,1),
	TicketId int,
	Action varchar(60),
	ActionDate date
);
go

--insert Tickets
create proc procInsertTickets(	
    @PassengerId int  ,
    @RouteId int,
    @TrainId int,
    @PurchaseDate DATE,
    @TicketPrice decimal(10,2)
)
as
begin
	insert into Tickets(PassengerId, RouteId, TrainId, PurchaseDate, TicketPrice)
	values(@PassengerId, @RouteId, @TrainId, @PurchaseDate, @TicketPrice);
end;
go

--proc tickets update
create proc procUpdateTickets(
	@TicketId int,
	@PassengerId int  ,
    @RouteId int,
    @TrainId int,
    @PurchaseDate DATE,
    @TicketPrice decimal(10,2)
)
as
begin
	update Tickets
	set PassengerId=@PassengerId, RouteId=@RouteId, TrainId=@TrainId, PurchaseDate=@PurchaseDate, TicketPrice=@TicketPrice
	where TicketId = @TicketId;
end;
go

--delete ticket proc
create proc procDeleteTicket(
	@TicketId int
)
as
begin
	delete from Tickets
	where TicketId = @TicketId;
end;
go
--retrive ticket
create proc procGetTickets(
	@TicketId int
)
as
begin
	select * from Tickets
	where TicketId = @TicketId
end;
go
--ticket valid trigger
create trigger triValidTrigger
on Tickets
instead of insert
as
begin
 declare @Price decimal(5,2);
 select @Price = inserted.TicketPrice from inserted;
	if (@Price<=0)
	begin
		raiserror('Ticket Price must be grether then 0',16,1);
		rollback transaction;
	end
	else 
	begin
		insert into Tickets(PassengerId, RouteId, TrainId, PurchaseDate, TicketPrice)
		select PassengerId, RouteId, TrainId, PurchaseDate, TicketPrice from inserted;
	end
end;
go

--insert update delete after lot table insert
create trigger triInsertUpdateDelete
on Tickets
after insert, update, delete
as
begin
	declare @TicketId int, @Action varchar(60);
	if exists(select * from inserted)
	begin
	select @TicketId = TicketId from inserted;
	if exists(select * from deleted)
	begin
		set @Action = 'Ticket updated';
	end
	else 
	begin
		set @Action ='ticket Insert';
	end
	end
	else if exists(select * from deleted)		
	begin
	select @TicketId =deleted.TicketId from deleted
	 set @Action = 'ticket Delete';
	end

	--insert log
	insert into TicketLogs(TicketId, Action, ActionDate)
	values(@TicketId,@Action,getdate()); 
end;
go

--insert value 
exec procInsertTickets @PassengerId=1, @RouteId=1, @TrainId=1, @PurchaseDate='2024-08-16', @TicketPrice=30.00;
exec procInsertTickets @PassengerId=2, @RouteId=2, @TrainId=2, @PurchaseDate='2024-08-16', @TicketPrice=40.00;
exec procInsertTickets @PassengerId=3, @RouteId=3, @TrainId=3, @PurchaseDate='2024-08-16', @TicketPrice=50.00;
exec procInsertTickets @PassengerId=4, @RouteId=4, @TrainId=4, @PurchaseDate='2024-08-16', @TicketPrice=60.00;
exec procInsertTickets @PassengerId=5, @RouteId=5, @TrainId=5, @PurchaseDate='2024-08-16', @TicketPrice=45.00;
exec procInsertTickets @PassengerId=1, @RouteId=6, @TrainId=6, @PurchaseDate='2024-08-16', @TicketPrice=35.00;
exec procInsertTickets @PassengerId=2, @RouteId=7, @TrainId=7, @PurchaseDate='2024-08-16', @TicketPrice=55.00;
exec procInsertTickets @PassengerId=3, @RouteId=8, @TrainId=8, @PurchaseDate='2024-08-16', @TicketPrice=50.00;
exec procInsertTickets @PassengerId=4, @RouteId=9, @TrainId=9, @PurchaseDate='2024-08-16', @TicketPrice=40.00;
exec procInsertTickets @PassengerId=5, @RouteId=10, @TrainId=10, @PurchaseDate='2024-08-16', @TicketPrice=60.00;
go

-- check Tickets 
insert into Tickets (PassengerId, RouteId, TrainId, PurchaseDate, TicketPrice)
values (1, 1, 1, '2024-08-17', -10.00);
go
-- Insert values into Tickets table
insert into Tickets (PassengerId, RouteId, TrainId, PurchaseDate, TicketPrice)
values
(1, 1, 1, '2024-08-16', 30.00), 
(2, 2, 2, '2024-08-16', 40.00), 
(3, 3, 3, '2024-08-16', 50.00), 
(4, 4, 4, '2024-08-16', 60.00), 
(5, 5, 5, '2024-08-16', 45.00), 
(1, 6, 6, '2024-08-16', 35.00), 
(2, 7, 7, '2024-08-16', 55.00), 
(3, 8, 8, '2024-08-16', 50.00), 
(4, 9, 9, '2024-08-16', 40.00), 
(5, 10, 10, '2024-08-16', 60.00);
go


exec procUpdateTickets @TicketId=1,@PassengerId=1, @RouteId=1, @TrainId=1, @PurchaseDate='2024-08-16', @TicketPrice=30.00;
exec procDeleteTicket @TicketId=1;

select * from Tickets;
go
select * from TicketLogs;
go
----- Create stored procedure to get tickets for a specific passenger
create procedure GetPassengerTickets(
    @PassengerId int)
as
begin
    select 
        T.TicketId,
        T.PurchaseDate,
        R.StartingStationId,
        R.EndingStationId,
        R.Distance,
        T.TicketPrice,
        TR.TrainNumber
    from 
        Tickets T
    inner join 
        Routes R on T.RouteId = R.RouteId
    inner join 
        Trains TR on T.TrainId = TR.TrainId
    where 
        T.PassengerId = @PassengerId;
end;
go
--get passenger 
exec GetPassengerTickets @PassengerId = 1;
go


-- Create a function to calculate the total fare for a ticket based on distance
create function CalculateFare (@RouteId int)
returns decimal(10,2)
as
begin
    declare @Fare decimal(10,2);
    
    select @Fare = Distance * 5 
    from Routes
    where RouteId = @RouteId;
    
    return @Fare;
end;
go

-- Use the function to calculate fare for route 1
select dbo.CalculateFare(4) as TotalFare;
go

-- Add a default value to the Status column in the Stations table
alter table Stations
add constraint DF_Stations_Status default 'Operational' for Status;
go

-- Add a not null constraint to the Capacity column in the Trains table
alter table Trains
alter column Capacity int not null;
go

-- Create an index on the TrainNumber column in the Trains table
create index In_TrainId on Trains (TrainId);
go


-- Create a trigger to update the total stations in the Lines table when a new station is added
create trigger trg_UpdateTotalStations
on LineStations
AFTER INSERT
as
begin
    update L
    set TotalStations = (select count(*) from LineStations where LineId = L.LineId)
    from Lines L
    where L.LineId IN (select LineId from inserted);
end;
go
--distinct 
select distinct Name
from Passengers;
go
--top
select TOP 5 *
from Tickets
order by PurchaseDate desc;
go
--top 3 passenger name
select distinct TOP 3 Name
from Passengers;
go
--where clause 
select *
from Passengers
where JourneyDate > '2024-06-01';
go 

select distinct Name
from Passengers
where Gender = 'Female' and age > 25;
go
--order by
select TOP 5 *
from Tickets
where RouteId = 1
order by PurchaseDate desc;
go
--like 
select *
from Passengers
where Name like 'A%';
go
--inner join 
select P.Name, T.TicketId, T.PurchaseDate
from Passengers P
inner join Tickets T on P.PassengerId = T.PassengerId;
go
--left join 
select P.Name, T.TicketId, T.PurchaseDate
from Passengers P
left join Tickets T on P.PassengerId = T.PassengerId;
go
--right join
select P.Name, T.TicketId, T.PurchaseDate
from Passengers P
right join Tickets T on P.PassengerId = T.PassengerId;
go
--full join
select P.Name, T.TicketId, T.PurchaseDate
from Passengers P
full outer join Tickets T on P.PassengerId = T.PassengerId;
go
--cross join
select P.Name, T.TicketId
from Passengers P
cross join Tickets T;
go
--join with where clause 
select P.Name, T.TicketId, T.PurchaseDate
from Passengers P
inner join Tickets T on P.PassengerId = T.PassengerId
where T.RouteId = 1;
--total passenger 
select count(*) as TotalPassengers
from Passengers;
--total sold of ticket
select RouteId, count(*) as TotalTicketsSold
from Tickets
group by RouteId;
--max fare 
select max(TicketPrice) as HighestFare
from Tickets;
go
--

select RouteId, AVG(TicketPrice) as AverageFare
from Tickets
group by RouteId;
go
--sale of ticket one day
select PurchaseDate, count(*) as TicketsSold
from Tickets
group by PurchaseDate
order by TicketsSold desc;
go

--max bye a ticket on passenger
select P.Name, count(T.TicketId) as TicketsPurchased
from Passengers P
inner join Tickets T on P.PassengerId = T.PassengerId
group by P.Name
order by TicketsPurchased desc;
go
--sub queries
select *
from Tickets
where TicketPrice = (select max(TicketPrice) from Tickets);
--mimimum price of ticket
select Name
from Passengers
where PassengerId IN (
    select PassengerId
    from Tickets
    where TicketPrice = (select min(TicketPrice) from Tickets)
);
go

--scalar function
create function GetStationName (@StationId int)
returns varchar(100)
as
begin
    declare @StationName varchar(100);
    
    select @StationName = StationName
    from Stations
    where StationId = @StationId;
    
    return @StationName;
end;
go

--
select dbo.GetStationName(1) as StationName;
go
--table function
create function GetTrainsByLine (@LineId int)
returns table
as
return
(
    select TrainId, TrainNumber, Capacity, Status
    from Trains
    where LineId = @LineId
);
go

select * from dbo.GetTrainsByLine(1);
go

--multi statement
create function  GetPassengerDetails (@PassengerId int)
returns @PassengerDetails table
(
    PassengerId int,
    Name varchar(100),
    ContactInfo varchar(150),
    TicketNumber varchar(50),
    JourneyDate date
)
as
begin
    insert into @PassengerDetails
    select PassengerId, Name, ContactInfo, TicketNumber, JourneyDate
    from Passengers
    where PassengerId = @PassengerId;

    return;
end;
go

select * from dbo.GetPassengerDetails(1);
go

--simple view
create view vw_StationInfo
as
select StationId, StationName, Location
from Stations;
go
select * from vw_StationInfo;
go



--complex view encryption 
create view vw_TrainScheduleEncryption
with encryption
as
select T.TrainNumber, S.StationName, Sch.DepartureTime, Sch.ArrivalTime
from Schedules Sch
join Trains T on Sch.TrainId = T.TrainId
join Stations S on Sch.StationId = S.StationId
where Sch.Direction = 'Up';
go

select * from vw_TrainScheduleEncryption;
go
-- complex view schemabinding 
create view vw_TrainScheduleSchema
with schemabinding
as
select T.TrainNumber, S.StationName, Sch.DepartureTime, Sch.ArrivalTime
from dbo.Schedules Sch
join dbo.Trains T on Sch.TrainId = T.TrainId
join dbo.Stations S on Sch.StationId = S.StationId
where Sch.Direction = 'down';
go

select * from dbo.vw_TrainScheduleSchema;
go


-- complex view encryption schemabinding together
create view vw_TrainScheduleTogether
with encryption, schemabinding
as
select T.TrainNumber, S.StationName, Sch.DepartureTime, Sch.ArrivalTime
from dbo.Schedules Sch
join dbo.Trains T on Sch.TrainId = T.TrainId
join dbo.Stations S on Sch.StationId = S.StationId
go

select * from dbo.vw_TrainScheduleTogether;
go

if @@ERROR =0
	begin
		print 'all comand execution successful';
	end
else
	begin
		print 'all command excution faild';
	end
go


-- CTE Uttora 
WITH UttaraStations AS
(
    SELECT StationId, StationName, Location
    FROM Stations
    WHERE Location = 'Uttara'
)
SELECT *
FROM UttaraStations;

-- CTE total train 
WITH TrainCount AS
(
    SELECT TrainId, TrainNumber
    FROM Trains
)
SELECT COUNT(*) AS TotalTrains
FROM TrainCount;



