-- Stored procedure definition script dbo.insertCoach for Oracle
-- Generated by (c) Ispirer SQLWays 10.22.3 Build 6944 64bit Licensed to BSTU - Timothey - Belarus - Ispirer MnMTK 10 Microsoft SQL Server to Oracle Database Migration Demo License (1 month, 20220611)
-- Timestamp: Tue May 17 21:56:32 2022
SET DEFINE OFF

--Warning: object conversion was canceled because of license limitations. The target script equals to the source script.
----

create   procedure insertCoach
as
    begin try
        insert into coach values ( '?????? ???? ????????????', 666)
    end try
    begin catch
        rollback
        select error_message() as ErrorMessage;
    end catch
/

SHOW ERRORS;

EXIT;

