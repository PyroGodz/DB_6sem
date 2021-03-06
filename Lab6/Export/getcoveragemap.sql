-- Stored procedure definition script dbo.GetCoverageMap for Oracle
-- Generated by (c) Ispirer SQLWays 10.22.3 Build 6944 64bit Licensed to BSTU - Timothey - Belarus - Ispirer MnMTK 10 Microsoft SQL Server to Oracle Database Migration Demo License (1 month, 20220611)
-- Timestamp: Tue May 17 21:56:32 2022
SET DEFINE OFF

--Warning: object conversion was canceled because of license limitations. The target script equals to the source script.
----


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
/

SHOW ERRORS;

EXIT;

