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

--Stations table
create table Stations(
	StationId int primary key identity(1,1),
	StationName varchar(80) not null,
	Location varchar(80),
	PlatformCount int,
	OpeningDate date
);
go
--create stations procedure
create proc ProcStations(
	@StationName varchar(80),
	@Location varchar(80),
	@PlatformCount int,
	@OpeningDate date
)
as
begin
	insert into Stations(StationName, Location, PlatformCount, OpeningDate)
	values(@StationName, @Location,@PlatformCount, @OpeningDate)
end;
go

--create log table
create table StationsLog(
	StationsLog int primary key identity(1,1),
	StationId int references Stations(StationId),
	Action varchar(30),
	ActionDate date
);
go
--insert log  trigger
create trigger triStationsLog
on Stations
after insert
as
begin
	declare @StationId int
	select @StationId = inserted.StationId
	from inserted;

	insert into StationSLog
	values(@StationId,'Station added', getdate());
end;
go
--insert validation count platform grether then 0 trigger 

create trigger triPlatformCount
on Stations
instead of insert
as
begin

	declare @StationName varchar(60);
	select @StationName = inserted.StationName
	from inserted;
	if exists (select * from inserted where PlatformCount <= 0)
	begin
		raiserror('Platform count must be grether then 0', 16,1);
	end
	else if exists (select 1 from Stations where @StationName = StationName)
	begin 
		raiserror('Station already Exists', 16,1);
	end
	else
	begin
		insert into Stations(StationName, Location, PlatformCount, OpeningDate)
		select StationName, Location, PlatformCount, OpeningDate from inserted;
	end
end;
go

select * from StationSLog;
--insert into ProcStations
exec ProcStations @StationName='Uttora North',@Location='Uttora',@PlatformCount='2',@OpeningDate='2022-12-29';
exec ProcStations @StationName='Uttora Center',@Location='Uttora',@PlatformCount='2',@OpeningDate='2023-02-18';
exec ProcStations @StationName='Uttora South',@Location='Uttra',@PlatformCount='2',@OpeningDate='2023-03-31';
exec ProcStations @StationName='Pallabi',@Location='Pallabi',@PlatformCount='2',@OpeningDate='2023-01-25';
exec ProcStations @StationName='Mirpur 11',@Location='Mirpur 11',@PlatformCount='2',@OpeningDate='2023-03-15';
exec ProcStations @StationName='Mirpur 10',@Location='Mirput 10',@PlatformCount='2',@OpeningDate='2023-03-01';
exec ProcStations @StationName='Kazipara',@Location='Kazipara',@PlatformCount='2',@OpeningDate='2023-03-15';
exec ProcStations @StationName='Shewrapara',@Location='Shewrapara',@PlatformCount='2',@OpeningDate='2023-03-31';
exec ProcStations @StationName='Agargaon',@Location='Agargaon',@PlatformCount='2',@OpeningDate='2022-12-29';
exec ProcStations @StationName='Bijoy Sarani',@Location='Bijoy Sarani',@PlatformCount='2',@OpeningDate='2023-12-23';
exec ProcStations @StationName='Farmgate',@Location='Farmgate',@PlatformCount='2',@OpeningDate='2023-09-04';
exec ProcStations @StationName='Karwan Bazar',@Location='Karwan Bazar',@PlatformCount='2',@OpeningDate='2022-12-31';
exec ProcStations @StationName='Shahbag',@Location='Shahbag',@PlatformCount='2',@OpeningDate='2022-12-15';
exec ProcStations @StationName='Dhaka University',@Location='Dhaka University',@PlatformCount='2',@OpeningDate='2023-11-13';
exec ProcStations @StationName='Bangladesh Secretariat',@Location='Bangladesh Secretariat',@PlatformCount='2',@OpeningDate='2023-11-05';
exec ProcStations @StationName='Motijheel',@Location='Motijheel',@PlatformCount='2',@OpeningDate='2023-11-05';

select * from StationsLog;

select * from Stations;

--up and down platform
create table Platforms(
	PlatformId int primary key identity(1,1),
	StationId int references Stations(StationId),
	PlatformType varchar(10) check(PlatformType='up' or PlatformType='down'),
	PlatfromNo int
);
go



--insert store procedure
create proc procPlatforms(	
	@StationId int,
	@PlatformType varchar(10),
	@PlatfromNo int
)
as 
begin
	if exists(select 1 from Platforms where StationId= @StationId and PlatformType= @PlatformType and PlatfromNo = @PlatfromNo)
	begin
	raiserror ('Already platform number exists',16,1);
	end
	else
	begin
	insert into Platforms
	values(@StationId, @PlatformType,@PlatfromNo)
	end
end;
go


--up down platformlog table
create table platformslog(
	platformslog int primary key identity(1,1),
	PlatformId int references Platforms(PlatformId),
	Action varchar(90),
	ActionDate date
);
go
--insert into platformLog table
create trigger triPlatformLog
on Platforms
after insert 
as
begin
	declare @PlatformId int;
	select @PlatformId = inserted.PlatformId
	from inserted;
	insert into platformslog 
	values(@PlatformId,'Platform added', getdate())
end;
go

--trigger duplicate value not insert
create trigger triInsertPlatformValid
on Platforms
instead of insert
as
begin
if exists(select * from Platforms where StationId = (Select StationId from inserted) and PlatformType =(select PlatformType from inserted) and PlatfromNo = (select PlatfromNo from inserted))
begin
	raiserror('Platfrom alredy exists',16,1);
end
else
begin
insert into Platforms(StationId, PlatformType, PlatfromNo)
select StationId, PlatformType, PlatfromNo from inserted
end
end;
go

select * from Platforms;
go
select * from Stations;

exec procPlatforms @StationId=1,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=2,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=3,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=4,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=5,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=6,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=7,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=8,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=9,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=10,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=11,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=12,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=13,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=14,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=15,@PlatformType='up',@PlatfromNo=1;
exec procPlatforms @StationId=16,@PlatformType='up',@PlatfromNo=1;

exec procPlatforms @StationId=1,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=2,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=3,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=4,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=5,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=6,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=7,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=8,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=9,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=10,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=11,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=12,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=13,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=14,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=15,@PlatformType='down',@PlatfromNo=2;
exec procPlatforms @StationId=16,@PlatformType='down',@PlatfromNo=2;


--lines table
create table Lines (
	LineId int primary key identity(1,1),
	LineName varchar(80),
	Color varchar(20),
	Length decimal(5,2),
	OpeningDate date
);
go

--routes table
create table Routes (
	RouteId int primary key identity(1,1),
	LineId int references Lines(LineId),
	StartStationId int  references Stations(StationId),
	EndStationId int references Stations(StationId),
	RouteName varchar(50),
	Distance decimal(5,2)
);
go
--train table

create table Trains(
	TrainId int primary key identity(1,1),
	TrainNumber varchar(20),
	Capacity int,
	TrainType varchar(20),
	Manufacturer varchar(100),
	InServiceDate date
);
go

--Schedules table
create table Schedules (
	SchedulesId int primary key identity(1,1),
	TrainId int references Trains(TrainId),
	RouteId int references Routes(RouteId),
	DepartureTime time,
	ArrivalTime time,
	Frequency varchar(20)
);
go
--passengers
create table Passengers(
	PassengerId int primary key identity(1,1),
	Name varchar(100),
	age int,
	Gender varchar(10),
	ContactNumber varchar(15)
);
go

--Tickets table 
create table Tickets (
	TicketsId int primary key identity(1,1),
	PassengerId int references Passengers(PassengerId),
	RouteId int references Routes(RouteId),
	TrainId int references Trains(TrainId),
	TicketType varchar(20),
	Price decimal(8,2),
	PurchaseDate date
);
go

--maintenance table
create table MaintenanceRecords(
	RecordId int primary key identity(1,1),
	TrainId int references Trains(TrainId),
	MaintenanceDate date,
	Details text,
	cost decimal(10,2)
);
go

--line stations table
create table LineStations (
	LineId int references Lines(LineId),
	StationId int references Stations(StationId),
	Sequence int
);
go
--fares table
create table Fares (
	FareId int primary key identity(1,1),
	RouteId int references Routes(RouteId),
	FareAmount decimal(8,2),
	FareType varchar(20)
);
go
--Train Stations
CREATE TABLE TrainStations (
    TrainID int references Trains(TrainID),
    StationID int references Stations(StationID),
    ArrivalTime time,
    DepartureTime time,
    primary key (TrainID, StationID, ArrivalTime)
);
go

--start dml 

select * from trains;
go