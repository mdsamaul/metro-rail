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
    StationName VARCHAR(100) NOT NULL,
    Location VARCHAR(150) NOT NULL,
    OpenedDate DATE NOT NULL
);
go
--lines table
CREATE TABLE Lines (
    LineId INT PRIMARY KEY IDENTITY(1,1),
    LineName VARCHAR(100) NOT NULL,
    Color VARCHAR(50) NOT NULL,
    TotalStations INT NOT NULL
);
go

--trains table
CREATE TABLE Trains (
    TrainId INT PRIMARY KEY IDENTITY(1,1),
    TrainNumber VARCHAR(50) NOT NULL,
    LineId INT NOT NULL REFERENCES Lines(LineId),
    Capacity INT NOT NULL
);
go

--schedules table
CREATE TABLE Schedules (
    ScheduleId INT PRIMARY KEY IDENTITY(1,1),
    TrainId INT NOT NULL REFERENCES Trains(TrainId),
    StationId INT NOT NULL REFERENCES Stations(StationId),
    DepartureTime TIME NOT NULL,
    ArrivalTime TIME NOT NULL,
    DayOfWeek NVARCHAR(20) NOT NULL
);
go
--Passengers table
CREATE TABLE Passengers (
    PassengerId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    ContactInfo NVARCHAR(150) NOT NULL,
    TicketNumber NVARCHAR(50) NOT NULL,
    JourneyDate DATE NOT NULL
);
go
--lineStations table
CREATE TABLE LineStations (
	LineStationId int,
    LineId INT NOT NULL REFERENCES Lines(LineId),
    StationId INT NOT NULL REFERENCES Stations(StationId),
    PRIMARY KEY (LineStationId, LineId, StationId)
);
go

--route table
CREATE TABLE Routes (
    RouteId INT PRIMARY KEY IDENTITY(1,1),
    RouteName NVARCHAR(100) NOT NULL,
    StartingStationId INT NOT NULL REFERENCES Stations(StationId),
    EndingStationId INT NOT NULL REFERENCES Stations(StationId),
    Distance DECIMAL(10,2) NOT NULL
);
go

--ticket table
CREATE TABLE Tickets (
    TicketId INT PRIMARY KEY IDENTITY(1,1),
    PassengerId INT NOT NULL REFERENCES Passengers(PassengerId),
    RouteId INT NOT NULL REFERENCES Routes(RouteId),
    TrainId INT NOT NULL REFERENCES Trains(TrainId),
    PurchaseDate DATE NOT NULL,
    TicketPrice DECIMAL(10,2) NOT NULL
);
go
