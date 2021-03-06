-- Function definition script fn_diagramobjects for Oracle
-- Generated by (c) Ispirer SQLWays 10.22.3 Build 6944 64bit Licensed to BSTU - Timothey - Belarus - Ispirer MnMTK 10 Microsoft SQL Server to Oracle Database Migration Demo License (1 month, 20220611)
-- Timestamp: Tue May 17 21:56:32 2022
SET DEFINE OFF


CREATE OR REPLACE FUNCTION fn_diagramobjects RETURN NUMBER
   as
   v_id_upgraddiagrams  NUMBER(10,0);
   v_id_sysdiagrams  NUMBER(10,0);
   v_id_helpdiagrams  NUMBER(10,0);
   v_id_helpdiagramdefinition  NUMBER(10,0);
   v_id_creatediagram  NUMBER(10,0);
   v_id_renamediagram  NUMBER(10,0);
   v_id_alterdiagram  NUMBER(10,0); 
   v_id_dropdiagram  NUMBER(10,0);
   v_InstalledObjects  NUMBER(10,0);
BEGIN
   v_InstalledObjects := 0;
   v_id_upgraddiagrams := SWF_OBJECT_ID(N'dbo.sp_upgraddiagrams','U');
   v_id_sysdiagrams := SWF_OBJECT_ID(N'dbo.sysdiagrams','U');
   v_id_helpdiagrams := SWF_OBJECT_ID(N'dbo.sp_helpdiagrams','U');
   v_id_helpdiagramdefinition := SWF_OBJECT_ID(N'dbo.sp_helpdiagramdefinition','U');
   v_id_creatediagram := SWF_OBJECT_ID(N'dbo.sp_creatediagram','U');
   v_id_renamediagram := SWF_OBJECT_ID(N'dbo.sp_renamediagram','U');
   v_id_alterdiagram := SWF_OBJECT_ID(N'dbo.sp_alterdiagram','U');
   v_id_dropdiagram := SWF_OBJECT_ID(N'dbo.sp_dropdiagram','U');
   if v_id_upgraddiagrams is not null then
      v_InstalledObjects := v_InstalledObjects+1;
   end if;
   if v_id_sysdiagrams is not null then
      v_InstalledObjects := v_InstalledObjects+2;
   end if;
   if v_id_helpdiagrams is not null then
      v_InstalledObjects := v_InstalledObjects+4;
   end if;
   if v_id_helpdiagramdefinition is not null then
      v_InstalledObjects := v_InstalledObjects+8;
   end if;
   if v_id_creatediagram is not null then
      v_InstalledObjects := v_InstalledObjects+16;
   end if;
   if v_id_renamediagram is not null then
      v_InstalledObjects := v_InstalledObjects+32;
   end if;
   if v_id_alterdiagram  is not null then
      v_InstalledObjects := v_InstalledObjects+64;
   end if;
   if v_id_dropdiagram is not null then
      v_InstalledObjects := v_InstalledObjects+128;
   end if;
   return v_InstalledObjects; 
END;

	
/

SHOW ERRORS;

EXIT;

