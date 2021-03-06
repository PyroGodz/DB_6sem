-- DDL script for table hal for Oracle
-- Generated by (c) Ispirer SQLWays 10.22.3 Build 6944 64bit Licensed to BSTU - Timothey - Belarus - Ispirer MnMTK 10 Microsoft SQL Server to Oracle Database Migration Demo License (1 month, 20220611)
-- Timestamp: Tue May 17 21:56:17 2022
-- Create table statement

SET DEFINE OFF


BEGIN
   EXECUTE IMMEDIATE ' DROP TABLE hal CASCADE CONSTRAINTS';
   EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/


CREATE TABLE hal
(
   id NUMBER(10,0) GENERATED BY DEFAULT AS IDENTITY(START WITH 4 INCREMENT BY 1)   NOT NULL,
   name NCLOB 
);


-- Primary key

ALTER TABLE hal ADD  CONSTRAINT PK__hal__3213E83FD1498666
PRIMARY KEY(id);

EXIT;

