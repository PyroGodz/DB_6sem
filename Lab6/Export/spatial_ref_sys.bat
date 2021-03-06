@echo off
if %SQLWAYS_CMD_ECHO%==on (@echo on)
echo.
echo Importing table spatial_ref_sys to Oracle
setlocal enabledelayedexpansion
rem Generated by (c) Ispirer SQLWays 10.22.3 Build 6944 64bit Licensed to BSTU - Timothey - Belarus - Ispirer MnMTK 10 Microsoft SQL Server to Oracle Database Migration Demo License (1 month, 20220611)
rem Timestamp: Tue May 17 21:56:32 2022

rem --------------------------------------------------------------
rem How to use this command file:

rem To create table, constraints, import data and create indexes run:
rem 	spatial_ref_sys.bat all

rem To create table and its constraints run:
rem 	spatial_ref_sys.bat table

rem To import data into the table run:
rem 	spatial_ref_sys.bat import

rem To create indexes for the table run:
rem 	spatial_ref_sys.bat idx

rem To execute all DDL statements for the table run:
rem 	spatial_ref_sys.bat ddl

rem --------------------------------------------------------------
rem Define a task to perform


@echo off

for %%x in (%*) do (
  if "%%~x"=="table" call:create_table
  if "%%~x"=="import" call:import_data
  if "%%~x"=="idx" call:create_idx
  if "%%~x"=="all" (
    call:create_table
    call:import_data
    call:create_idx
  )
)
@echo %SQLWAYS_CMD_ECHO%
goto end

rem --------------------------------------------------------------
:create_table
echo Creating table and its constraints using the Oracle SQL*Plus utility

D:\\app\\ora_install_user\\product\\12.1.0\\dbhome_1\\BIN\sqlplus system/Apahar33 @spatial_ref_sys_ddl.sql
goto:eof

rem --------------------------------------------------------------
:import_data
echo Importing data using the Oracle SQL*Loader utility

D:\\app\\ora_install_user\\product\\12.1.0\\dbhome_1\\BIN\sqlldr userid=system/Apahar33 control=spatial_ref_sys.ctl log=spatial_ref_sys.log rows=1000 readsize=1048576 bindsize=1048576


goto:eof

rem --------------------------------------------------------------
:create_idx

goto:eof



rem --------------------------------------------------------------
:end


rem End script
