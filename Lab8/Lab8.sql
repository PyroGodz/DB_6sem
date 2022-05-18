create tablespace ts_blob
datafile 'D:\Study\Practice\DB_6sem\Lab8\blob.dbf'
size 50m autoextend on next 1m;

create user C##MTD_lr8 identified by User1;
grant all privileges to  C##MTD_lr8;

alter user C##MTD_lr8 container=all;
select * from v$tablespace

alter user C##MTD_lr8 default tablespace ts_blob
quota unlimited on ts_blob
account unlock container=current;

create directory BLOBS as 'D:\Study\Practice\DB_6sem\Lab8\folder';
grant read, write on directory BLOBS to C##MTD_lr8;


create table BigFiles
(
    id number(5) primary key,
    FOTO BLOB,
    DOC_or_PDF BFILE
);
commit;
--insert into BigFiles values(1, BFILENAME('BLOBS', 'pic.png'), null);
insert into BigFiles values(1, null, BFILENAME('BLOBS', 'DocFile.docx'));
insert into BigFiles values(2, null, BFILENAME('BLOBS', 'text.txt'));

select * from BigFiles;

DECLARE
l_bfile BFILE;
l_blob BLOB;
l_dest_offset INTEGER := 1;
l_src_offset INTEGER := 1;
BEGIN
INSERT INTO BigFiles(id, FOTO, DOC_or_PDF) values (5, empty_blob(), null)
RETURN FOTO INTO l_blob;
l_bfile := BFILENAME('BLOBS', 'pic.png');
DBMS_LOB.fileopen(l_bfile, DBMS_LOB.file_readonly);
DBMS_LOB.loadblobfromfile (dest_lob => l_blob, src_bfile => l_bfile, amount => DBMS_LOB.lobmaxsize, dest_offset => l_dest_offset, src_offset => l_src_offset);
DBMS_LOB.fileclose(l_bfile);
COMMIT;
END;

delete from BigFiles where id = 2
select * from BigFiles