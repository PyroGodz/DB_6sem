--Task2. ������� ������� ������, ���� � �������������
create login John with password = 'john';
create login Jane with password = 'jane';
create user John for login John;
create user Jane for login Jane;
--�������� ���� CURRENT_USER (dbo)
create role user_role;
grant create table, alter, select, insert, delete, update, execute, control, references to pyrog
grant ALTER ANY SERVER AUDIT to pyrog
--3. ������������� ���� ��� ���������

exec sp_addrolemember 'db_datareader', 'John';
exec sp_addrolemember 'db_ddladmin', 'John';
use SportPlace
deny select on coach to Jane;
go

setuser;

drop procedure us_proc_GetCoach 

create procedure us_proc_GetCoach 
with execute as 'John'
	as select * from coach;

alter authorization on us_proc_GetCoach to John;
grant execute on us_proc_GetCoach to Jane;
		
setuser 'Jane';
exec us_proc_GetCoach;

setuser 'John';
exec us_proc_GetCoach;

setuser 'John';
select * from  coach;
setuser;
--4.	������ ��� ���������� ������ ����������� ������������. 
USE master;
GO
CREATE SERVER AUDIT Lab10_Audit  
    TO APPLICATION_LOG;
GO  

select * from sys.server_audits;
--5.	��������� ��������� �����, ������������������ ������ ������.
ALTER SERVER AUDIT Lab10_Audit  
WITH (STATE = ON);  
GO 
create server audit specification ServerAuditSpecification1
	for server audit Lab10_Audit 
	add (database_change_group)
	with (state=on)

--6.	������� ����������� ������� ������.
--7.	������ ��� ������ ����������� ������������.
--8.	��������� ����� ��, ������������������ ������ ������
USE SportPlace  
GO    
CREATE DATABASE AUDIT SPECIFICATION Audit_VAC_Lab10
FOR SERVER AUDIT Lab10_Audit 
ADD (SELECT, INSERT ON abon BY dbo )   --audit_action_specification
WITH (STATE = ON) ;   
GO

--9.	���������� ����� �� � �������.
USE master  
GO    
ALTER SERVER AUDIT Lab10_Audit  
WITH (STATE = OFF);  
GO 
USE master
GO
ALTER DATABASE AUDIT SPECIFICATION Audit_VAC_Lab10
WITH (STATE = OFF);  
GO 

--10.	������� ��� ���������� SQL Server ������������� ���� ����������.
USE master
GO
CREATE ASYMMETRIC KEY Lab10akey   
    WITH ALGORITHM = RSA_2048   
    ENCRYPTION BY PASSWORD = 'Lab10';   
GO  

USE SportPlace
GO
CREATE ASYMMETRIC KEY Lab10akey   
    WITH ALGORITHM = RSA_2048   
    ENCRYPTION BY PASSWORD = 'Lab10';   
GO  


--11.	����������� � ������������ ������ ��� ������ ����� �����.
use master;
drop database EncryptedDB
CREATE DATABASE EncryptedDB;

GO
USE EncryptedDB
GO
CREATE TABLE CreditCardInformation
(
	PersonID int PRIMARY KEY IDENTITY,
	CreditCardNumber varbinary(max)
)

CREATE ASYMMETRIC KEY Lab10akey   
    WITH ALGORITHM = RSA_2048   
    ENCRYPTION BY PASSWORD = 'Lab10';   
GO  

GO
--���������� � ������� �������������� �����.
INSERT INTO CreditCardInformation(CreditCardNumber)
VALUES (ENCRYPTBYASYMKEY( AsymKey_ID('Lab10akey') ,  0x012345))
GO
SELECT * FROM CreditCardInformation
GO
--������������� � ������� �������������� �����.
SELECT PersonID, CONVERT(nvarchar(max),  DecryptByAsymKey( AsymKey_Id('Lab10akey'), CreditCardNumber, N'Lab10'))   
,DecryptByAsymKey( AsymKey_Id('Lab10akey'), CreditCardNumber, N'Lab10')
AS DecryptedData   
FROM CreditCardInformation
GO  

--12.	������� ��� ���������� SQL Server ����������.
use EncryptedDB
go
create certificate SampleCert
encryption by password = N'Lab10'
with subject = N'���� ��������',
Expiry_DATE = N'28/10/2022';

--13.	����������� � ������������ ������ ��� ������ ����� �����������.
INSERT INTO CreditCardInformation values(EncryptByCert(Cert_ID('SampleCert'), N'��������� ������'));
GO
SELECT * FROM CreditCardInformation
GO
SELECT (Convert(Nvarchar(100), DecryptByCert(Cert_ID('SampleCert'), CreditCardInformation.CreditCardNumber, N'Lab10'))) FROM CreditCardInformation;
GO

--14.	������� ��� ���������� SQL Server ������������ ���� ���������� ������.
--��� ���������� ���� �����
create Symmetric key SKey
WITH ALGORITHM = AES_256  ENCRYPTION
 by password = 'Lab10';

Open symmetric key SKey
Decryption by password = 'Lab10'
create Symmetric key SData
with Algorithm =  AES_256
encryption by symmetric key SKey;

Open symmetric key SData 
Decryption by symmetric key SKey;

create Master key encryption by password = N'Lab10';
--15.	����������� � ������������ ������ ��� ������ ����� �����.
--���������� � ������� ������������ �����.
INSERT INTO CreditCardInformation VALUES (ENCRYPTBYKEY( Key_GUID('SData') , N'Secret Data'))
GO
SELECT * FROM CreditCardInformation
GO
--������������� � ������� ������������ �����.
SELECT [PersonID], CONVERT(nvarchar(max),  DecryptByKey( [CreditCardNumber])) AS DecryptedData  FROM [dbo].[CreditCardInformation]
GO 

--16.	������������������ ���������� ���������� ���� ������.
USE SportPlace;
drop master key;
GO  
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Lab10';  
go
CREATE CERTIFICATE MyServerCert WITH SUBJECT = 'My DEK Certificate';  
go  

--n wk
create database s;
USE EncryptedDB;
GO  
CREATE DATABASE ENCRYPTION KEY  
WITH ALGORITHM = AES_128  
ENCRYPTION BY SERVER CERTIFICATE MyServerCert;  
GO  
ALTER DATABASE s  
SET ENCRYPTION ON;  
GO  
---wk

select @@VERSION

alter database CampersRentApp
set encryption on;
go

select encryption_state from sys.dm_database_encryption_keys
--17.	������������������ ���������� �����������.
select HASHBYTES('SHA1', 'Hesh example');

--18.	������������������ ���������� ��� ��� ������ �����������.
use EncryptedDB
GO
select SignByCert(Cert_Id( 'SampleCert' ),'dadaya', N'Lab10')

--19.	������� ��������� ����� ����������� ������ � ������������.
Backup certificate SampleCert
to File = N'D:\Subject\BD3\Lab\Lab10\Cert.cer'
with private key (
File = N'D:\Subject\BD3\Lab\Lab10\Cert.pvk',
Encryption by password = N'Lab10',
Decryption by password = N'Lab10');