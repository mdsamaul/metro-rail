--md. samaul islam
--id 128415

-- Insert into Stations table
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

-- Insert into Lines table
insert into Lines (LineName, Color, TotalStations)
values 
('MRT Line 6', 'Red', 17);
go

-- Insert into Trains table
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
go

-- Insert into Schedules table (Up platform schedule)
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

-- Insert into Schedules table (Down platform schedule)
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

-- Insert into Passengers table
insert into Passengers (Name, Gender, Age, ContactInfo, TicketNumber, JourneyDate)
values
('Samaul', 'Male', 20, '01981154473', 'TKT001', '2024-08-17'),
('Mimma', 'Female', 25, '01981154478', 'TKT002', '2024-02-17'),
('Shihan', 'Male', 4, '01981154479', 'TKT003', '2024-03-17'),
('Arafat', 'Male', 30, '01981154470', 'TKT004', '2024-04-17'),
('Rta Akter', 'Female', 35, '01981154471', 'TKT005', '2024-10-17');
go

-- Insert into LineStations table
insert into LineStations (LineId, StationId)
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

-- Insert into Routes table
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

-- Insert into Tickets table (example data, adjust as needed)
insert into Tickets (PassengerId, RouteId, TrainId, PurchaseDate, TicketPrice)
values
(1, 1, 1, '2024-08-17', 50.00),
(2, 2, 2, '2024-08-18', 55.00),
(3, 3, 3, '2024-08-19', 60.00);
go

-- Insert into TicketLogs table
insert into TicketLogs (TicketId, Action, ActionDate)
values
(1, 'Purchased', '2024-08-17'),
(2, 'Cancelled', '2024-08-18'),
(3, 'Refunded', '2024-08-19');
go

-- Insert Values into Tickets table using Procedure
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

-- Update Ticket Value using Procedure
exec procUpdateTickets @TicketId=1, @PassengerId=1, @RouteId=1, @TrainId=1, @PurchaseDate='2024-08-16', @TicketPrice=30.00;

-- Delete Ticket Value using Procedure
exec procDeleteTicket @TicketId=1;

-- Check Tickets
select * from Tickets;
go

-- Check Ticket Logs
select * from TicketLogs;
go

-- Insert Invalid Ticket (to test trigger)
insert into Tickets (PassengerId, RouteId, TrainId, PurchaseDate, TicketPrice)
values (1, 1, 1, '2024-08-17', -10.00);
go

-- Get Passenger Tickets using Procedure
exec GetPassengerTickets @PassengerId = 1;
go


-- Use Function to Calculate Fare for Route 4
select dbo.CalculateFare(4) as TotalFare;
go

-- Use the Function to Get Station Name
select dbo.GetStationName(1) as StationName;
go

-- Use Table-Valued Function to Get Trains by Line
select * from dbo.GetTrainsByLine(1);
go

-- Use Multi-Statement Table-Valued Function to Get Passenger Details
select * from dbo.GetPassengerDetails(1);
go

-- Select Distinct Names from Passengers
select distinct Name
from Passengers;
go

-- Select Top 5 Tickets by Purchase Date Descending
select TOP 5 *
from Tickets
order by PurchaseDate desc;
go

-- Select Top 3 Distinct Passenger Names
select distinct TOP 3 Name
from Passengers;
go

-- Select Passengers Where Journey Date is After June 1, 2024
select *
from Passengers
where JourneyDate > '2024-06-01';
go

-- Select Distinct Female Passengers Over Age 25
select distinct Name
from Passengers
where Gender = 'Female' and age > 25;
go

-- Select Top 5 Tickets for Route 1 Ordered by Purchase Date Descending
select TOP 5 *
from Tickets
where RouteId = 1
order by PurchaseDate desc;
go

-- Select Passengers Whose Names Start with 'A'
select *
from Passengers
where Name like 'A%';
go

-- Inner Join Passengers and Tickets
select P.Name, T.TicketId, T.PurchaseDate
from Passengers P
inner join Tickets T on P.PassengerId = T.PassengerId;
go

-- Left Join Passengers and Tickets
select P.Name, T.TicketId, T.PurchaseDate
from Passengers P
left join Tickets T on P.PassengerId = T.PassengerId;
go

-- Right Join Passengers and Tickets
select P.Name, T.TicketId, T.PurchaseDate
from Passengers P
right join Tickets T on P.PassengerId = T.PassengerId;
go

-- Full Outer Join Passengers and Tickets
select P.Name, T.TicketId, T.PurchaseDate
from Passengers P
full outer join Tickets T on P.PassengerId = T.PassengerId;
go

-- Cross Join Passengers and Tickets
select P.Name, T.TicketId
from Passengers P
cross join Tickets T;
go

-- Join with Where Clause
select P.Name, T.TicketId, T.PurchaseDate
from Passengers P
inner join Tickets T on P.PassengerId = T.PassengerId
where T.RouteId = 1;
go

-- Total Number of Passengers
select count(*) as TotalPassengers
from Passengers;
go

-- Total Tickets Sold by Route
select RouteId, count(*) as TotalTicketsSold
from Tickets
group by RouteId;
go

-- Maximum Ticket Price
select max(TicketPrice) as HighestFare
from Tickets;
go

-- Average Ticket Price by Route
select RouteId, AVG(TicketPrice) as AverageFare
from Tickets
group by RouteId;
go

-- Ticket Sales Per Day
select PurchaseDate, count(*) as TicketsSold
from Tickets
group by PurchaseDate
order by TicketsSold desc;
go

-- Maximum Tickets Purchased by a Passenger
select P.Name, count(T.TicketId) as TicketsPurchased
from Passengers P
inner join Tickets T on P.PassengerId = T.PassengerId
group by P.Name
order by TicketsPurchased desc;
go

-- Subquery to Get Tickets with Maximum Price
select *
from Tickets
where TicketPrice = (select max(TicketPrice) from Tickets);
go

-- Minimum Ticket Price Passengers
select Name
from Passengers
where PassengerId IN (
    select PassengerId
    from Tickets
    where TicketPrice = (select min(TicketPrice) from Tickets)
);
go

-- Select from Complex View with Encryption
select * from vw_TrainScheduleEncryption;
go

-- Select from Complex View with Schema Binding
select * from dbo.vw_TrainScheduleSchema;
go

-- Select from Complex View with Encryption and Schema Binding
select * from dbo.vw_TrainScheduleTogether;
go

-- Check for Execution Errors
if @@ERROR = 0
begin
    print 'All commands executed successfully';
end
else
begin
    print 'All commands execution failed';
end
go
