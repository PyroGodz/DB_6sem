-- Create a sequence and trigger to implement the identity column
-- For table abon for Oracle
-- Generated by (c) Ispirer SQLWays 10.22.3 Build 6944 64bit Licensed to BSTU - Timothey - Belarus - Ispirer MnMTK 10 Microsoft SQL Server to Oracle Database Migration Demo License (1 month, 20220611)
-- Timestamp: Tue May 17 21:56:19 2022

-- Altering identity column to implement generate always as identity

ALTER TABLE abon MODIFY id NUMBER(10,0) GENERATED ALWAYS AS IDENTITY START WITH LIMIT VALUE INCREMENT BY 1;
/

EXIT;

