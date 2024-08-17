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
    OpenedDate DATE NOT NULL,
	 Status NVARCHAR(50) CHECK (Status IN ('Operational', 'Under Maintenance'))
);
go

--insert into station table
INSERT INTO Stations (StationName, Location, OpenedDate, Status)
VALUES 
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
CREATE TABLE Lines (
    LineId INT PRIMARY KEY IDENTITY(1,1),
    LineName VARCHAR(100) NOT NULL,
    Color VARCHAR(50) NOT NULL,
    TotalStations INT NOT NULL
);
go

--insert into lines table
INSERT INTO Lines (LineName, Color, TotalStations)
VALUES 
('MRT Line 6', 'Red', 17);

--trains table
CREATE TABLE Trains (
    TrainId INT PRIMARY KEY IDENTITY(1,1),
    TrainNumber VARCHAR(50) NOT NULL,
    LineId INT NOT NULL REFERENCES Lines(LineId),
    Capacity INT NOT NULL,
	Status NVARCHAR(50) CHECK (Status IN ('Operational', 'Under Maintenance'))
);
go

--insert into data trains table
INSERT INTO Trains (TrainNumber, LineId, Capacity, Status)
VALUES 
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
CREATE TABLE Schedules (
    ScheduleId INT PRIMARY KEY IDENTITY(1,1),
    TrainId INT NOT NULL REFERENCES Trains(TrainId),
    StationId INT NOT NULL  REFERENCES Stations(StationId),
    DepartureTime TIME,
    ArrivalTime TIME,
    DayOfWeek VARCHAR(9) NOT NULL,
    Direction VARCHAR(4) CHECK (Direction IN ('Up', 'Down'))
);
go


-- insert Up platform schedule  Uttara North to Motijheel

INSERT INTO Schedules (TrainId, StationId, DepartureTime, ArrivalTime, DayOfWeek, Direction)
VALUES 
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
--
-- down train   Motijheel on Monday (Down platform)

INSERT INTO Schedules (TrainId, StationId, DepartureTime, ArrivalTime, DayOfWeek, Direction)
VALUES 
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
CREATE TABLE Passengers (
    PassengerId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    ContactInfo NVARCHAR(150) NOT NULL,
    TicketNumber NVARCHAR(50) NOT NULL,
    JourneyDate DATE NOT NULL
);
go
--passenger table insert value
INSERT INTO Passengers (Name, ContactInfo, TicketNumber, JourneyDate)
VALUES
('Samaul', '01981154473', 'TKT001', '2024-08-17'),
('Mimma', '01981154478', 'TKT002', '2024-08-17'),
('Shihan', '01981154479', 'TKT003', '2024-08-17'),
('Arafat', '01981154470', 'TKT004', '2024-08-17'),
('Rta Akter', '01981154471', 'TKT005', '2024-08-17');
go
--lineStations table
CREATE TABLE LineStations (
	LineStationId int identity(1,1),
    LineId INT NOT NULL REFERENCES Lines(LineId),
    StationId INT NOT NULL REFERENCES Stations(StationId),
    PRIMARY KEY (LineStationId, LineId, StationId)
);
go
--insert into Line Stations table

INSERT INTO LineStations ( LineId, StationId)
VALUES
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
CREATE TABLE Routes (
    RouteId INT PRIMARY KEY IDENTITY(1,1),
    StartingStationId INT NOT NULL REFERENCES Stations(StationId),
    EndingStationId INT NOT NULL REFERENCES Stations(StationId),
    Distance DECIMAL(10,2) NOT NULL
);
go

--insert into Routes table
INSERT INTO Routes (StartingStationId, EndingStationId, Distance)
VALUES
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
GO

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

-- Insert values into Tickets table
INSERT INTO Tickets (PassengerId, RouteId, TrainId, PurchaseDate, TicketPrice)
VALUES
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
GO
----- Create stored procedure to get tickets for a specific passenger
CREATE PROCEDURE GetPassengerTickets
    @PassengerId INT
AS
BEGIN
    SELECT 
        T.TicketId,
        T.PurchaseDate,
        R.StartingStationId,
        R.EndingStationId,
        R.Distance,
        T.TicketPrice,
        TR.TrainNumber
    FROM 
        Tickets T
    INNER JOIN 
        Routes R ON T.RouteId = R.RouteId
    INNER JOIN 
        Trains TR ON T.TrainId = TR.TrainId
    WHERE 
        T.PassengerId = @PassengerId;
END;
GO


--get passenger 
EXEC GetPassengerTickets @PassengerId = 1;
go

---- Create trigger to check ticket price before inserting
CREATE TRIGGER trg_CheckTicketPrice
ON Tickets
AFTER INSERT
AS
BEGIN
    
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE TicketPrice <= 0
    )
    BEGIN
        RAISERROR ('Ticket price must be greater than zero.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- check Tickets 
INSERT INTO Tickets (PassengerId, RouteId, TrainId, PurchaseDate, TicketPrice)
VALUES (1, 1, 1, '2024-08-17', -10.00);
go

-- Create a function to calculate the total fare for a ticket based on distance
CREATE FUNCTION CalculateFare (@RouteId INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Fare DECIMAL(10,2);
    
    SELECT @Fare = Distance * 5 
    FROM Routes
    WHERE RouteId = @RouteId;
    
    RETURN @Fare;
END;
GO

-- Use the function to calculate fare for route 1
SELECT dbo.CalculateFare(4) AS TotalFare;
GO

-- Add a default value to the Status column in the Stations table
ALTER TABLE Stations
ADD CONSTRAINT DF_Stations_Status DEFAULT 'Operational' FOR Status;
GO

-- Add a NOT NULL constraint to the Capacity column in the Trains table
ALTER TABLE Trains
ALTER COLUMN Capacity INT NOT NULL;
GO


-- Create an index on the TrainNumber column in the Trains table
CREATE INDEX IX_TrainNumber ON Trains (TrainNumber);
GO


-- Create a trigger to update the total stations in the Lines table when a new station is added
CREATE TRIGGER trg_UpdateTotalStations
ON LineStations
AFTER INSERT
AS
BEGIN
    UPDATE L
    SET TotalStations = (SELECT COUNT(*) FROM LineStations WHERE LineId = L.LineId)
    FROM Lines L
    WHERE L.LineId IN (SELECT LineId FROM inserted);
END;
GO