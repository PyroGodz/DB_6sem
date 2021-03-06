-- Stored procedure definition script dbo.addSportPlace for Oracle
-- Generated by (c) Ispirer SQLWays 10.22.3 Build 6944 64bit Licensed to BSTU - Timothey - Belarus - Ispirer MnMTK 10 Microsoft SQL Server to Oracle Database Migration Demo License (1 month, 20220611)
-- Timestamp: Tue May 17 21:56:32 2022
SET DEFINE OFF

--Warning: object conversion was canceled because of license limitations. The target script equals to the source script.
----


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
/

SHOW ERRORS;

EXIT;

