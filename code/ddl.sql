--md. samaul islam
--id 128415

-- Use master database
use master;
go

-- If exists then drop database
if exists (select name from sys.databases where name ='MetroRailDb')
begin 
    drop database MetroRailDb;
end;
go

-- Create MetroRailDb database
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

-- Use the newly created database
use MetroRailDb;
go

-- Create Stations table
create table Stations (
    StationId int primary key identity(1,1),
    StationName varchar(100) not null,
    Location varchar(150) not null,
    OpenedDate DATE not null,
    Status varchar(50) check (Status IN ('Operational', 'Under Maintenance'))
);
go

-- Create Lines table
create table Lines (
    LineId int primary key identity(1,1),
    LineName varchar(100) not null,
    Color varchar(50) not null,
    TotalStations int not null
);
go

-- Create Trains table
create table Trains (
    TrainId int primary key identity(1,1),
    TrainNumber varchar(50) not null,
    LineId int not null references Lines(LineId),
    Capacity int not null,
    Status varchar(50) check (Status IN ('Operational', 'Under Maintenance'))
);
go

-- Create Schedules table
create table Schedules (
    ScheduleId int primary key identity(1,1),
    TrainId int not null references Trains(TrainId),
    StationId int not null references Stations(StationId),
    DepartureTime TIME,
    ArrivalTime TIME,
    DayOfWeek varchar(9) not null,
    Direction varchar(4) check (Direction IN ('Up', 'Down'))
);
go

-- Create Passengers table
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

-- Create LineStations table
create table LineStations (
    LineStationId int identity(1,1),
    LineId int not null references Lines(LineId),
    StationId int not null references Stations(StationId),
    primary key (LineStationId, LineId, StationId)
);
go

-- Create Routes table
create table Routes (
    RouteId int primary key identity(1,1),
    StartingStationId int not null references Stations(StationId),
    EndingStationId int not null references Stations(StationId),
    Distance decimal(10,2) not null
);
go

-- Create Tickets table
create table Tickets (
    TicketId int primary key identity(1,1),
    PassengerId int not null references Passengers(PassengerId),
    RouteId int not null references Routes(RouteId),
    TrainId int not null references Trains(TrainId),
    PurchaseDate DATE not null,
    TicketPrice decimal(10,2) not null
);
go

-- Create TicketLogs table
create table TicketLogs(
    TicketLogId int primary key identity(1,1),
    TicketId int,
    Action varchar(60),
    ActionDate date
);
go

-- Create Procedures
-- Insert Ticket Procedure
create proc procInsertTickets(    
    @PassengerId int,
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

-- Update Ticket Procedure
create proc procUpdateTickets(
    @TicketId int,
    @PassengerId int,
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

-- Delete Ticket Procedure
create proc procDeleteTicket(
    @TicketId int
)
as
begin
    delete from Tickets
    where TicketId = @TicketId;
end;
go

-- Retrieve Ticket Procedure
create proc procGetTickets(
    @TicketId int
)
as
begin
    select * from Tickets
    where TicketId = @TicketId
end;
go

-- Ticket Valid Trigger
create trigger triValidTrigger
on Tickets
instead of insert
as
begin
    declare @Price decimal(5,2);
    select @Price = inserted.TicketPrice from inserted;
    if (@Price <= 0)
    begin
        raiserror('Ticket Price must be greater than 0', 16, 1);
    end
    else 
    begin
        insert into Tickets(PassengerId, RouteId, TrainId, PurchaseDate, TicketPrice)
        select PassengerId, RouteId, TrainId, PurchaseDate, TicketPrice from inserted;
    end
end;
go

-- Insert, Update, Delete After Trigger
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
            set @Action = 'Ticket Insert';
        end
    end
    else if exists(select * from deleted)        
    begin
        select @TicketId = deleted.TicketId from deleted;
        set @Action = 'Ticket Delete';
    end

    -- Insert Log
    insert into TicketLogs(TicketId, Action, ActionDate)
    values(@TicketId, @Action, getdate()); 
end;
go

-- Create stored procedure to get tickets for a specific passenger
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

-- Create Function to Calculate Fare
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

-- Add Default Constraint to Status Column in Stations Table
alter table Stations
add constraint DF_Stations_Status default 'Operational' for Status;
go

-- Add Not Null Constraint to Capacity Column in Trains Table
alter table Trains
alter column Capacity int not null;
go

-- Create Index on TrainNumber Column in Trains Table
create index In_TrainId on Trains (TrainId);
go

-- Create Trigger to Update Total Stations in Lines Table
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

-- Create Scalar Function to Get Station Name
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

-- Create Table-Valued Function to Get Trains by Line
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

-- Create Multi-Statement Table-Valued Function to Get Passenger Details
create function GetPassengerDetails (@PassengerId int)
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

-- Create Simple View
create view vw_StationInfo
as
select StationId, StationName, Location
from Stations;
go

-- Create Complex View with Encryption
create view vw_TrainScheduleEncryption
with encryption
as
select T.TrainNumber, S.StationName, Sch.DepartureTime, Sch.ArrivalTime
from Schedules Sch
join Trains T on Sch.TrainId = T.TrainId
join Stations S on Sch.StationId = S.StationId
where Sch.Direction = 'Up';
go

-- Create Complex View with Schema Binding
create view vw_TrainScheduleSchema
with schemabinding
as
select T.TrainNumber, S.StationName, Sch.DepartureTime, Sch.ArrivalTime
from dbo.Schedules Sch
join dbo.Trains T on Sch.TrainId = T.TrainId
join dbo.Stations S on Sch.StationId = S.StationId
where Sch.Direction = 'Down';
go

-- Create Complex View with Encryption and Schema Binding
create view vw_TrainScheduleTogether
with encryption, schemabinding
as
select T.TrainNumber, S.StationName, Sch.DepartureTime, Sch.ArrivalTime
from dbo.Schedules Sch
join dbo.Trains T on Sch.TrainId = T.TrainId
join dbo.Stations S on Sch.StationId = S.StationId;
go

-- CTE for Uttara Stations
WITH UttaraStations AS
(
    SELECT StationId, StationName, Location
    FROM Stations
    WHERE Location = 'Uttara'
)
SELECT *
FROM UttaraStations;
go

-- CTE for Total Train Count
WITH TrainCount AS
(
    SELECT TrainId, TrainNumber
    FROM Trains
)
SELECT COUNT(*) AS TotalTrains
FROM TrainCount;
go
