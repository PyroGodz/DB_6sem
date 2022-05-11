use sportplace
go

drop procedure allSportPlaces;
go
create procedure allSportPlaces
as
begin
	select * from SportPlaces;
end

select * from gadm40_blr_2
--2
alter table record add placeId integer;
go
alter table record add foreign key(placeId) references SportPlaces(id)

drop table SportPlaces
go
create table SportPlaces
(
	id integer identity(1,1) not null primary key,
	namePlace nvarchar(300) null,
	freeSpace float null,
	point nvarchar(100) null
)

select * from SportPlaces


drop procedure addSportPlace;
go

select * from geometry_columns;

--3. пересечение, исключение, объединение точек
declare @poly1 geometry, @poly2 geometry 
	select @poly1 = point from SportPlaces where id = 13;
	select @poly2 = point from SportPlaces where id = 16;
	declare @inters geometry = @poly1.STIntersection(@poly2);
	declare @dif geometry = @poly1.STDifference(@poly2);
	declare @union geometry = @poly1.STUnion(@poly2);
	select @inters.STAsText() as 'Peresechenie',
			@dif.STAsText() as 'Iskluchenie',
			@union.STAsText() as 'Union';
--4. наименьшее растояние между точками
	declare @g geometry;
	declare @h geometry;
	declare @dist float;
	select @g = ogr_geometry.STAsText() from gadm40_blr_2 where ogr_fid=4;
	select @h = ogr_geometry.STAsText() from gadm40_blr_2 where ogr_fid=3;
	select @dist = @g.STDistance(@h);
	select @dist as 'Длина', (select name_1 from gadm40_blr_2 where ogr_fid=3) as 'Точка1', 
			name_1 as 'Точка2' from gadm40_blr_2 where ogr_fid=4;


--Изменение

	go
	select ogr_geometry.STBuffer(1) as BUFFER from gadm40_blr_2 where ogr_fid = 1
	select ogr_geometry.Reduce(0.3) as BUFFER from gadm40_blr_2 where ogr_fid = 1

-- Пространственные индексы
	create spatial index index_shape
	on gadm40_blr_2(ogr_geometry)
	using geometry_grid
	with (bounding_box = (xmin=0, ymin = 0, xmax=500, ymax=200),
	grids= (LOW,LOW,MEDIUM,HIGH),
	PAD_INDEX = ON);
--Добавление расположения спортивного объекта.	
drop procedure AddSportPlace;
go

create procedure addSportPlace @name nvarchar(300),
												@freeSpace float,
												@point nvarchar(100)
as 
begin
	set nocount on;
	begin try
		declare @g geometry = GEOMETRY::STGeomFromText(@point,0);
		set @g.STSrid = 4326;
		insert into SportPlaces(namePlace, freeSpace, point)
		output Inserted.Id
		values (@name,@freeSpace,CAST(GEOMETRY::STGeomFromText(@point,0) AS nvarchar));
	
	end try
	begin catch
		print error_message();
		throw;
	end catch
end;
delete from SportPlaces where namePlace = 'Volna';

select * from SportPlaces;

delete SportPlaces
exec addSportPlace 'FOK Zvezda', '100', 'POINT(27.603850 53.945802)';
exec addSportPlace 'Minsk Arena', '300', 'POINT(30.603850 52.945802)';
exec addSportPlace 'Volna', '50', 'POINT(30.603850 54.945802)';
exec addSportPlace 'Minsk Arena', '240', 'POINT(26.603850 54.945802)';

-- получить наименьшее растояние между спортивными комплексами
select * from SportPlaces;

go
drop procedure GetPlaceMap
go
create procedure GetPlaceMap
as
begin
	set nocount on;
	create table #Points(point geometry);
	declare points_cursor cursor for
	select point from SportPlaces;
	declare @g geometry;
	open points_cursor
	fetch next from points_cursor
	into @g;
	while @@FETCH_STATUS = 0
	begin
		insert into #Points values (@g);
		fetch next from points_cursor
		into @g;
	end
	select ogr_geometry.STAsText() from gadm40_blr_2
	union all
	select point.STBuffer(0.07).STAsText() from #Points;
	
	close points_cursor
	deallocate points_cursor
	drop table #Points;
end;

exec GetPlaceMap


drop procedure GetCoverageMap
go
create procedure GetCoverageMap
as
begin
	declare points_cursor cursor for
	select point from SportPlaces;
	declare @cur geometry;
	declare @union geometry = null;
	declare @firstTime bit = 1;
	open points_cursor
	fetch next from points_cursor
	into @cur;
	while @@FETCH_STATUS = 0
	begin
		if @firstTime <> 1
			set @union = @union.STUnion(@cur.STBuffer(0.6))
		else
		begin
			set @union = @cur.STBuffer(0.6);
			set @firstTime = 0;
		end
		fetch next from points_cursor
		into @cur;
	end
	
	select ogr_geometry.STAsText() from gadm40_blr_2
	union all
	select @union.STAsText();

	
	close points_cursor
	deallocate points_cursor
end

exec GetCoverageMap



drop procedure CalculateShortestPath;
go
create procedure CalculateShortestPath(@p1 geometry, @p2 geometry)
as
begin
	declare @distance float = @p1.STDistance(@p2);
	declare @line geometry;
	select @distance as 'Distance';
	select @line = @p1.ShortestLineTo(@p2);
	
end

declare @pt1 geometry, @pt2 geometry;
select @pt1 = point from SportPlaces where id = 13;
select @pt2 = point from SportPlaces where id = 16;
exec CalculateShortestPath @pt1, @pt2;


drop procedure CalculateShortestPath2;
go
create procedure CalculateShortestPath2(@p1 nvarchar(100), @p2 nvarchar(100))
as
begin
	declare @g1 geometry = GEOMETRY::STGeomFromText(@p1,0);
	declare @g2 geometry = GEOMETRY::STGeomFromText(@p2,0);
	declare @distance float = @g1.STDistance(@g2);
	declare @line geometry;
	select @distance as 'Distance';
	select @line = @g1.ShortestLineTo(@g2);
	
end

--drop procedure getSquere
--as

--create procedure getSquere(@p1 nvarchar(100), @p2 nvarchar(100))
--as
--begin
--	DECLARE @g geometry;  
--	SET @g = geometry::STGeomFromText('LINESTRING('@p1', '@p2')', 0);  
--	SELECT @g.STEnvelope().ToString();
--end

declare @pt1 geometry, @pt2 geometry;
select @pt1 = point from SportPlaces where id = 13;
select @pt2 = point from SportPlaces where id = 16;
exec CalculateShortestPath @pt1, @pt2;
