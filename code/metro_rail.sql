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
	StationId int,
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

select * from Platforms;
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
	PlatformId int,
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

--line store procedure 
create proc addLines(
	@LineName varchar(80),
	@Color varchar(20),
	@Length decimal(5,2),
	@OpeningDate date
)
as
begin
	 insert into lines(LineName,Color,Length,OpeningDate)
	 values(@LineName,@Color,@Length,@OpeningDate)
end;
go

--lines log table
create table LineLogs(
	LineLogId int primary key identity(1,1),
	LineId int,
	Action varchar(90),
	ActionDate date
);
go

--insert line log table
create trigger triLineLogs
on Lines
after insert
as
begin
	declare @LineId int;
	select @LineId = inserted.LineId
	from inserted;

	insert into LineLogs(LineId, Action,ActionDate)
	values(@LineId, 'Line added', getdate());
end;
go
--lines table validation trigger
create trigger triLineValid
on Lines
instead of insert
as
begin
	if exists(select * from lines where  LineName = (select LineName from inserted) and Color = (select Color from inserted))
	begin
		raiserror('line alredy exists ' , 16, 1);
	end
	else
	begin
		insert into Lines (LineName, Color, Length,OpeningDate)
		select LineName, Color, Length,OpeningDate from inserted
	end
end;
go

--insert lines table
exec addLines @LineName='MRT Line 6',@Color='Red',@Length='21.26',@OpeningDate='2022-12-29';
--update lines
select * from Lines;
go

create proc procUpdateLine(
	@LineId int,
	@LineName varchar(80),
	@Color varchar(20),
	@Length decimal(5,2),
	@OpeningDate date
)
as
begin

	if exists (select 1 from Lines where @Color = Color)
	begin 
		raiserror ('allready color exists',16,1);
	end
	else
	begin
	update Lines
		set LineName= @LineName,
		Color=@Color,
		Length=@Length,
		OpeningDate =@OpeningDate
		where LineId = @LineId
	end
end;
go

--line update trigger
create trigger triUpdateLine
on Lines
after update
as
begin
	declare @LineId int
	select @LineId = inserted.LineId
	from inserted;
	insert into LineLogs (LineId, Action, ActionDate)
	values(@LineId, 'Line Updated', getdate())
end;
go

--update line tabe
exec procUpdateLine @LineId=1, @LineName='MRT Line 6',@Color='Greens',@Length='21.26',@OpeningDate='2022-12-29';
select * from lineLogs;
go
select * from lines;
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

--create proce routes table
create proc procRoutes(
	@LineId int,
	@StartStationId int,
	@EndStationId int,
	@RouteName varchar(50),
	@Distance decimal(5,2)
)
as
begin
	if @StartStationId = @EndStationId
	begin
		raiserror('Start and end station can not be same',16,2);
		return;
	end	
		insert into Routes(LineId, StartStationId,EndStationId,RouteName,Distance)
		values(@LineId, @StartStationId,@EndStationId,@RouteName,@Distance)

end;
go
--valid trigger Routes table
create trigger triRouteValid
on Routes
instead of insert
as
begin
	if exists (select 1 from routes where LineId = (select LineId from inserted) and StartStationId = (select StartStationId from inserted) and EndStationId = (select EndStationId from inserted))
	begin
		raiserror('Route is alredy exists',16,1);
	end
	--inesrt 
	insert into Routes(LineId, StartStationId, EndStationId, RouteName, Distance)
	select LineId, StartStationId, EndStationId, RouteName, Distance from inserted;
end;
go

--route log table
create table RouteLogs(
	RouteLogId int primary key identity(1,1),
	RouteId int,
	Action varchar(90),
	ActionDate date
);
go
--route log trigger
create trigger triRouteLog
on Routes
after insert , update, delete
as
begin
	declare @RouteId int, @Action varchar(90);
	if exists(select * from inserted)
	begin
		select @RouteId =RouteId from inserted;
		if exists (select * from deleted)
		begin 
			set @Action = 'Update Route'
		end
		else
		begin
			set @Action ='Inserted Route'
		end
	end	
	else if exists(select * from deleted)
	begin
		select @RouteId =RouteId from deleted
		set @Action = 'Deleted Route';
	end

	--insert log
	insert into RouteLogs(RouteId, Action,ActionDate)
	values (@RouteId, @Action, getdate());
end;
go

--insert into routes table on proc
exec procRoutes @LIneId =1,@StartStationId=1,@EndStationId=2,@RouteName='Route 1',@Distance=1.2;
exec procRoutes @LIneId =1,@StartStationId=2,@EndStationId=3,@RouteName='Route 2',@Distance=1.5;
exec procRoutes @LIneId =1,@StartStationId=3,@EndStationId=4,@RouteName='Route 3',@Distance=1.8;
exec procRoutes @LIneId =1,@StartStationId=4,@EndStationId=5,@RouteName='Route 4',@Distance=2.0;
exec procRoutes @LIneId =1,@StartStationId=5,@EndStationId=6,@RouteName='Route 5',@Distance=1.4;
exec procRoutes @LIneId =1,@StartStationId=6,@EndStationId=7,@RouteName='Route 6',@Distance=1.7;
exec procRoutes @LIneId =1,@StartStationId=7,@EndStationId=8,@RouteName='Route 7',@Distance=1.5;
exec procRoutes @LIneId =1,@StartStationId=8,@EndStationId=9,@RouteName='Route 8',@Distance=2.3;
exec procRoutes @LIneId =1,@StartStationId=9,@EndStationId=10,@RouteName='Route 9',@Distance=1.9;
exec procRoutes @LIneId =1,@StartStationId=10,@EndStationId=11,@RouteName='Route 10',@Distance=1.6;
exec procRoutes @LIneId =1,@StartStationId=11,@EndStationId=12,@RouteName='Route 11',@Distance=1.8;
exec procRoutes @LIneId =1,@StartStationId=12,@EndStationId=13,@RouteName='Route 12',@Distance=1.3;
exec procRoutes @LIneId =1,@StartStationId=13,@EndStationId=14,@RouteName='Route 13',@Distance=2.2;
exec procRoutes @LIneId =1,@StartStationId=14,@EndStationId=15,@RouteName='Route 14',@Distance=1.7;
exec procRoutes @LIneId =1,@StartStationId=15,@EndStationId=16,@RouteName='Route 15',@Distance=1.5;



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

--insert procedure
create proc procTrains(
	@TrainNumber varchar(20),
	@Capacity int,
	@TrainType varchar(20),
	@Manufacturer varchar(100),
	@InServiceDate date
)
as
begin
	insert into Trains(TrainNumber, Capacity, TrainType,Manufacturer,InServiceDate)
	values(@TrainNumber, @Capacity, @TrainType,@Manufacturer,@InServiceDate)
end;
go

--update train store procedure
create proc procTrainUpdate(
	@TrainId int,
	@TrainNumber varchar(20),
	@Capacity int,
	@TrainType varchar(20),
	@Manufacturer varchar(100),
	@InServiceDate date
)
as
begin
update Trains	  
set   
	@TrainNumber   =TrainNumber,   
	@Capacity 	   =Capacity, 	   
	@TrainType 	   =TrainType, 	   
	@Manufacturer  =Manufacturer,  
	@InServiceDate =InServiceDate 
	where TrainId = @TrainId;
end;
go

--delete train store procedure
create proc procDeleteTrain(
	@TrainId int
)
as
begin
	delete from Trains
	where @TrainId = TrainId
end;
go

--create train log table
create table TrainLogs(
	TrainLogIn int primary key identity(1,1),
	TrainId int,
	Action varchar(90),
	ActionDate date
);
go

--trigger Train insert
create trigger triTrainInster
on Trains
after insert, update, delete
as
begin
	declare @TrainId int , @Action varchar(90);
	if exists(select * from inserted)
	begin
	select @TrainId = inserted.TrainId 
	from inserted;
	if exists (select * from deleted)
	begin
		set @Action ='Update Train';
	end
	else
	begin
		set @Action ='Insert Train';
	end
	end
	else if exists(select * from deleted)
	begin
		select @TrainId = TrainId 
		from deleted;
		set @Action ='Delete Train';
	end

	--insert train
	insert into TrainLogs (TrainId, Action ,ActionDate)
	values(@TrainId, @Action, getdate());
end;
go

--train valid trigger
create trigger triInserTrainValid
on Trains
instead of insert
as
begin 
	if exists (select 1 from inserted where TrainNumber in (select TrainNumber from Trains))
	begin
		raiserror('Train Number already exists',16,1);
	end
	else
	begin
		insert into Trains(TrainNumber, Capacity,TrainType, Manufacturer,InServiceDate)
		select TrainNumber, Capacity,TrainType, Manufacturer,InServiceDate from inserted;
	end
end;
go

select * from trains;
---insert into train procedure 
exec procTrains @TrainNumber='MRT6-T01', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';
exec procTrains @TrainNumber='MRT6-T02', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';
exec procTrains @TrainNumber='MRT6-T03', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';
exec procTrains @TrainNumber='MRT6-T04', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';
exec procTrains @TrainNumber='MRT6-T05', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';
exec procTrains @TrainNumber='MRT6-T06', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';
exec procTrains @TrainNumber='MRT6-T07', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';
exec procTrains @TrainNumber='MRT6-T08', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';
exec procTrains @TrainNumber='MRT6-T09', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';
exec procTrains @TrainNumber='MRT6-T10', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';
exec procTrains @TrainNumber='MRT6-T11', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';
exec procTrains @TrainNumber='MRT6-T12', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';
exec procTrains @TrainNumber='MRT6-T13', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';
exec procTrains @TrainNumber='MRT6-T14', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';
exec procTrains @TrainNumber='MRT6-T15', @Capacity=2308, @TrainType='Electric', @Manufacturer='Kawasaki Heavy Industries Ltd.', @InServiceDate='2022-12-01';

select * from trains;
--Schedules table

create table Schedules (
	ScheduleId int primary key identity(1,1),
	TrainId int references Trains(TrainId),
	PlatformId int references Platforms(PlatformId),
	RouteId int references Routes(RouteId),
	DepartureTime time,
	ArrivalTime time,
	Frequency varchar(20)
);
go

--create Schedules store procedure
create proc procSchedules(
	@TrainId int,
	@PlatformId int,
	@RouteId int ,
	@DepartureTime time,
	@ArrivalTime time,
	@Frequency varchar(20)
)
as
begin
	insert into Schedules(TrainId,PlatformId,RouteId,DepartureTime,ArrivalTime,Frequency)
	values(@TrainId,@PlatformId,@RouteId,@DepartureTime,@ArrivalTime,@Frequency)
end;
go

--porce schedules update

create proc procUpdateSchedule(
	@ScheduleId int,
	@PlatformId int,
	@TrainId int  ,
	@RouteId int ,
	@DepartureTime time,
	@ArrivalTime time,
	@Frequency varchar(20)
)
as
begin
update Schedules

set
	TrainId =@TrainId,
	PlatformId=@PlatformId,
	RouteId =@RouteId,
	DepartureTime =@DepartureTime,
	ArrivalTime =@ArrivalTime,
	Frequency =@Frequency
	where @ScheduleId=ScheduleId
end;
go

--delete schedules

create proc procScheduleDelete(
	@ScheduleId int
)
as
begin

--delete schedules table
delete from Schedules
where @ScheduleId = ScheduleId
end;
go

--create scheduleLogs table
create table ScheduleLogs(
	ScheduleLogId int primary key identity(1,1),
	ScheduleId int,
	Action varchar(70),
	ActionDate date
);
go
--schdule insert trigger


create trigger triSchedules
on Schedules
after  insert , update, delete
as
begin 
declare @ScheduleId int, @Action varchar(70);
if exists (select * from inserted)
begin
select @ScheduleId = ScheduleId from inserted;
if exists (select * from deleted)
begin
	set @Action ='Updeted Schedule';
end
else 
begin
	set @Action ='Insert Schedule'; 
end
end
else if exists(select * from deleted)
begin
select @ScheduleId = ScheduleId from deleted;
set @Action ='delete Schedule';
end
--insert log 
 insert into ScheduleLogs(ScheduleId, Action,ActionDate)
 values(@ScheduleId, @Action,getdate())
end;
go

--trigger schedule validation
create trigger triScheduleValie
on Schedules
instead of insert
as
begin
	if exists(select 1 from inserted where  ArrivalTime >= DepartureTime)
	begin
	raiserror('Arival time must be grether then Departure time', 16,1);
	rollback;
	end
	--insert value
	insert into Schedules(TrainId,PlatformId,RouteId,DepartureTime,ArrivalTime,Frequency)
	select TrainId,PlatformId,RouteId,DepartureTime,ArrivalTime,Frequency from inserted;
end;
go


--inesrt schedules
-- Insert a new schedule
--up train
EXEC procSchedules @TrainId = 1, @PlatformId = 1,@RouteId = 1,@DepartureTime = '08:01', @ArrivalTime = '08:00',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 1, @PlatformId = 2,@RouteId = 2,@DepartureTime = '08:06', @ArrivalTime = '08:05',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 1, @PlatformId = 3,@RouteId = 3,@DepartureTime = '08:11', @ArrivalTime = '08:10',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 1, @PlatformId = 4,@RouteId = 4,@DepartureTime = '08:16', @ArrivalTime = '08:15',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 1, @PlatformId = 5,@RouteId = 5,@DepartureTime = '08:21', @ArrivalTime = '08:20',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 1, @PlatformId = 6,@RouteId = 6,@DepartureTime = '08:26', @ArrivalTime = '08:25',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 1, @PlatformId = 7,@RouteId = 7,@DepartureTime = '08:31', @ArrivalTime = '08:30',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 1, @PlatformId = 8,@RouteId = 8,@DepartureTime = '08:36', @ArrivalTime = '08:35',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 1, @PlatformId = 9,@RouteId = 9,@DepartureTime = '08:41', @ArrivalTime = '08:40',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 1, @PlatformId = 10,@RouteId = 10,@DepartureTime = '08:46', @ArrivalTime = '08:45',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 1, @PlatformId = 11,@RouteId = 11,@DepartureTime = '08:51', @ArrivalTime = '08:50',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 1, @PlatformId = 12,@RouteId = 12,@DepartureTime = '08:56', @ArrivalTime = '08:55',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 1, @PlatformId = 13,@RouteId = 13,@DepartureTime = '09:01', @ArrivalTime = '09:00',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 1, @PlatformId = 14,@RouteId = 14,@DepartureTime = '09:06', @ArrivalTime = '09:05',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 1, @PlatformId = 15,@RouteId = 15,@DepartureTime = '09:11', @ArrivalTime = '09:10',@Frequency = 'Every Day';

--down train
EXEC procSchedules @TrainId = 15, @PlatformId = 32,@RouteId = 15,@DepartureTime = '08:01', @ArrivalTime = '08:00',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 15, @PlatformId = 31,@RouteId = 14,@DepartureTime = '08:06', @ArrivalTime = '08:05',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 15, @PlatformId = 30,@RouteId = 13,@DepartureTime = '08:11', @ArrivalTime = '08:10',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 15, @PlatformId = 29,@RouteId = 12,@DepartureTime = '08:16', @ArrivalTime = '08:15',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 15, @PlatformId = 28,@RouteId = 11,@DepartureTime = '08:21', @ArrivalTime = '08:20',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 15, @PlatformId = 27,@RouteId = 10,@DepartureTime = '08:26', @ArrivalTime = '08:25',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 15, @PlatformId = 26,@RouteId = 9,@DepartureTime = '08:31', @ArrivalTime = '08:30',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 15, @PlatformId = 25,@RouteId = 8,@DepartureTime = '08:36', @ArrivalTime = '08:35',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 15, @PlatformId = 24,@RouteId = 7,@DepartureTime = '08:41', @ArrivalTime = '08:40',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 15, @PlatformId = 23,@RouteId = 6,@DepartureTime = '08:46', @ArrivalTime = '08:45',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 15, @PlatformId = 22,@RouteId = 5,@DepartureTime = '08:51', @ArrivalTime = '08:50',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 15, @PlatformId = 21,@RouteId = 4,@DepartureTime = '08:56', @ArrivalTime = '08:55',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 15, @PlatformId = 20,@RouteId = 3,@DepartureTime = '09:01', @ArrivalTime = '09:00',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 15, @PlatformId = 19,@RouteId = 2,@DepartureTime = '09:06', @ArrivalTime = '09:05',@Frequency = 'Every Day';
EXEC procSchedules @TrainId = 15, @PlatformId = 18,@RouteId = 1,@DepartureTime = '09:11', @ArrivalTime = '09:10',@Frequency = 'Every Day';

select  * from  schedules;
select * from trains;
select * from routes;
select * from Platforms;
select * from Stations;




--update
/*EXEC procUpdateSchedule 
    @ScheduleId = 1,
    @TrainId = 2,
    @RouteId = 3,
    @DepartureTime = '09:00:00',
    @ArrivalTime = '09:45:00',
    @Frequency = 'Weekdays';
go

--delete
EXEC procScheduleDelete 
    @ScheduleId = 1;
	go

	*/



--passengers
create table Passengers(
	PassengerId int primary key identity(1,1),
	Name varchar(100),
	age int,
	Gender varchar(10),
	ContactNumber varchar(15)
);
go

--passenger log table
create table PassengerLogs(
	PassengerLogId int primary key identity(1,1),
	PassengerId int,
	Action varchar(90),
	ActionDate date
);
go

--insert passenger proc
create proc procInsertPassengers(
	@Name varchar(100),
	@age int,
	@Gender varchar(10),
	@ContactNumber varchar(15)
)
as
begin
	insert into Passengers(Name,age,Gender,ContactNumber)
	values(@Name,@age,@Gender,@ContactNumber)
end;
go

--passenger update
create proc procUpdatePassengers(
	@PassengerId int,
	@Name varchar(100),
	@age int,
	@Gender varchar(10),
	@ContactNumber varchar(15)
)
as
begin
	update Passengers
	set Name = @Name,age=@age, Gender=@Gender, ContactNumber = @ContactNumber
	where PassengerId = @PassengerId;

end;
go
--passender delete
create proc procPassengerDelete(
	@PassengerId int
)
as
begin
	delete from Passengers
	where PassengerId = @PassengerId
end;
go
--retrive a passenger
create proc ProcGetPassengerDetails(
	@PassengerId int
)
as
begin
	select * from Passengers
	where PassengerId = @PassengerId
end
go


--function valid phone number
create function validPhone(@Phone varchar(30))
returns int
begin
	declare @Result int;
	set @Result =1;
	if @Phone like ('%[^0-9]%')
	begin
	set @Result = 0;
	end
	else if len(@Phone) !=11
	begin
	 set @Result =0;
	end
	--result return
	return @Result;
end;
go

--select  dbo.validPhone('01981154473');
--valid passenger
create trigger triPassengerValid
on Passengers
instead of insert
as
begin
	declare @Phone varchar(30);
	select @Phone = inserted.ContactNumber
	from inserted;
	if (dbo.validPhone(@Phone)=0)
	begin
		raiserror('not a valie phone number', 16,1);
		rollback transaction;
	end
	else
	begin
		insert into Passengers(Name,age,Gender,ContactNumber)
		select Name,age,Gender,ContactNumber from inserted;
	end
end;
go

--insert log file
create trigger triInserUpdateDelete
on Passengers
after insert, update, delete
as
begin
	declare @PassengerId int , @Action varchar(60);
	if exists(select * from inserted)
	begin
		select @PassengerId = inserted.PassengerId from inserted;
		if exists(select * from deleted)
		begin
			set @Action = 'Passenger Updated';
		end
		else
		begin
			set @Action = 'Passenger Inserted';
		end
	end
	else if exists(select * from deleted)
	begin
	set @Action = 'Passenger Deleted';
	end
	--
	insert into PassengerLogs(PassengerId, Action, ActionDate)
	values (@PassengerId, @Action, getdate());
end;
go


exec procInsertPassengers @Name='samaul',@age=24, @Gender='M',@ContactNumber='01981154473';
exec procUpdatePassengers @PassengerId = 1, @Name='Shovon',@age=24, @Gender='M',@ContactNumber='01981154478';
exec procPassengerDelete @PassengerId = 1;
exec ProcGetPassengerDetails @PassengerId = 2;


select * from passengers;


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
	@PassengerId int ,
	@RouteId int ,
	@TrainId int,
	@TicketType varchar(20),
	@Price decimal(8,2),
	@PurchaseDate date
)
as
begin
	insert into Tickets(PassengerId,RouteId,TrainId,TicketType,Price,PurchaseDate)
	values(@PassengerId,@RouteId,@TrainId,@TicketType,@Price,@PurchaseDate);
end;
go

--proc tickets update
create proc procUpdateTickets(
	@TicketId int,
	@PassengerId int ,
	@RouteId int ,
	@TrainId int,
	@TicketType varchar(20),
	@Price decimal(8,2),
	@PurchaseDate date
)
as
begin
	update Tickets
	set PassengerId =@PassengerId,
	RouteId = @RouteId, 
	TrainId=@TrainId,
	TicketType=@TicketType,
	Price=@Price,
	PurchaseDate=@PurchaseDate
	where TicketsId = @TicketId;
end;
go

--delete ticket proc
create proc procDeleteTicket(
	@TicketId int
)
as
begin
	delete from Tickets
	where TicketsId = @TicketId;
end;
go
--retrive ticket
create proc procGetTickets(
	@TicketId int
)
as
begin
	select * from Tickets
	where TicketsId = @TicketId
end;
go
--ticket valid trigger
create trigger triValidTrigger
on Tickets
instead of insert
as
begin
 declare @Price decimal(5,2);
 select @Price = inserted.Price from inserted;
	if (@Price<=0)
	begin
		raiserror('Price must be grether then 0',16,1);
		rollback transaction;
	end
	else 
	begin
		insert into Tickets(PassengerId, RouteId, TrainId, TicketType, Price,PurchaseDate)
		select PassengerId, RouteId, TrainId, TicketType, Price,PurchaseDate from inserted;
	end
end;
go

drop trigger triInsertUpdateDelete
--insert update delete after lot table insert
create trigger triInsertUpdateDelete
on Tickets
after insert, update, delete
as
begin
	declare @TicketId int, @Action varchar(60);
	if exists(select * from inserted)
	begin
	select @TicketId = TicketsId from inserted;
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
	select @TicketId =deleted.TicketsId from deleted
	 set @Action = 'ticket Delete';
	end

	--insert log
	insert into TicketLogs(TicketId, Action, ActionDate)
	values(@TicketId,@Action,getdate()); 
end;
go

--insert value 
exec procInsertTickets @PassengerId=2,@RouteId =1,@TrainId=1,@TicketType='vip',@Price=50,@PurchaseDate='2024-08-18';
exec procUpdateTickets @TicketId=1, @PassengerId=3,@RouteId =1,@TrainId=1,@TicketType='vip-ac',@Price=150,@PurchaseDate='2024-08-18';
exec procDeleteTicket @TicketId=1;

select * from tickets;
select * from Ticketlogs;

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