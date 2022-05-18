-- DDL script for table SportPlaces for Oracle
-- Generated by (c) Ispirer SQLWays 10.22.3 Build 6944 64bit Licensed to BSTU - Timothey - Belarus - Ispirer MnMTK 10 Microsoft SQL Server to Oracle Database Migration Demo License (1 month, 20220611)
-- Timestamp: Tue May 17 21:56:29 2022
-- Create table statement

SET DEFINE OFF


BEGIN
   EXECUTE IMMEDIATE ' DROP TABLE SportPlaces CASCADE CONSTRAINTS';
   EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/


CREATE TABLE SportPlaces
(
   id NUMBER(10,0) GENERATED BY DEFAULT AS IDENTITY(START WITH 25 INCREMENT BY 1)   NOT NULL,
   freeSpace BINARY_DOUBLE,
   point NVARCHAR2(100),
   namePlace NVARCHAR2(300) 
);


-- Primary key

ALTER TABLE SportPlaces ADD  CONSTRAINT PK__SportPla__3213E83FB4CF62C0
PRIMARY KEY(id);

EXIT;
