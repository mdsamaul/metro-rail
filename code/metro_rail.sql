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