-- Stored procedure definition script add_client for Oracle
-- Generated by (c) Ispirer SQLWays 10.22.3 Build 6944 64bit Licensed to BSTU - Timothey - Belarus - Ispirer MnMTK 10 Microsoft SQL Server to Oracle Database Migration Demo License (1 month, 20220611)
-- Timestamp: Tue May 17 21:56:32 2022
SET DEFINE OFF

create   or replace PROCEDURE add_client(v_Secondname IN nvarchar2
 , v_Firstname IN nvarchar2
 , v_Phone IN nvarchar2
 , v_CoachId IN NUMBER) as
   v_refcur SYS_REFCURSOR;
begin
   insert into client(SecondName, FirstName, Phone, coachId)  values(v_Secondname, v_Firstname, v_Phone,v_CoachId);
        
   open v_refcur for select 0 from dual;
   dbms_sql.return_result(v_refcur);
end;
/

SHOW ERRORS;

EXIT;

