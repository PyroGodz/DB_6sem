-- DDL script for table coach for Oracle
-- Generated by (c) Ispirer SQLWays 10.22.3 Build 6944 64bit Licensed to BSTU - Timothey - Belarus - Ispirer MnMTK 10 Microsoft SQL Server to Oracle Database Migration Demo License (1 month, 20220611)
-- Timestamp: Tue May 17 21:56:21 2022
-- Create table statement

SET DEFINE OFF


BEGIN
   EXECUTE IMMEDIATE ' DROP TABLE coach CASCADE CONSTRAINTS';
   EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/


CREATE TABLE coach
(
   id NUMBER(10,0) GENERATED BY DEFAULT AS IDENTITY(START WITH 23 INCREMENT BY 1)   NOT NULL,
   FIO NCLOB,
   payment NUMBER(10,0),
   parentId VARCHAR2(892)
);


-- Primary key

ALTER TABLE coach ADD  CONSTRAINT PK__coach__3213E83F9A769081
PRIMARY KEY(id);

EXIT;
