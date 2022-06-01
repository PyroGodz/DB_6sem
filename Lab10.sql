--Task2
--Чтобы создать, изменить или удалить аудит сервера, участникам требуется разрешение
--После того как создана спецификация аудита сервера, ее могут просмотреть участники с разрешениями
CREATE USER pyrog FOR LOGIN pyrog;
GO
grant create table, alter, select, insert, delete, update, execute, control, references to pyrog
grant ALTER ANY SERVER AUDIT, CONTROL SERVER to pyrog
--3.	Продемонстрируйте заимствование прав для любой процедуры в базе данных
--4.	Создать для экземпляра SQL Server объект аудита.
--5.	Задать для серверного аудита необходимые спецификации. 
USE master;
GO
CREATE SERVER AUDIT Lab10_Audit  
    TO APPLICATION_LOG;
GO  
CREATE SERVER AUDIT Payrole_Security_Audit  
    TO FILE ( FILEPATH =   
'D:\Study\Practice\DB_6sem\Lab10' ) ;   
GO  
-- Enable the server audit.   
ALTER SERVER AUDIT Payrole_Security_Audit   
WITH (STATE = ON) ;  

--6.	Запустить серверный аудит, продемонстрировать журнал аудита.
ALTER SERVER AUDIT Lab10_Audit  
WITH (STATE = ON);  
GO 
--7.	Создать необходимые объекты аудита.

--8.	Задать для аудита необходимые спецификации.
--9.	Запустить аудит БД, продемонстрировать журнал аудита
USE SportPlace  
--аудит БД создан, и отключен в 10 задании. Это чтобы включить
ALTER DATABASE AUDIT SPECIFICATION Audit_VAC_Lab10
WITH (STATE = ON);  
GO 

GO    
CREATE DATABASE AUDIT SPECIFICATION Audit_VAC_Lab10
FOR SERVER AUDIT Lab10_Audit 
ADD (SELECT, INSERT ON abon BY dbo )   --audit_action_specification
WITH (STATE = ON) ;   
GO

select * from abon
--10.	Остановить аудит БД и сервера.
USE master  
GO    
ALTER SERVER AUDIT Lab10_Audit  
WITH (STATE = OFF);  
GO 
USE SportPlace
GO
ALTER DATABASE AUDIT SPECIFICATION Audit_VAC_Lab10
WITH (STATE = OFF);  
GO 

select * from abon

--11.	Создать для экземпляра SQL Server ассиметричный ключ шифрования.
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


--11 и 12.	Зашифровать и расшифровать данные при помощи этого ключа.
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
--Шифрование с помощью асииметричного ключа.
INSERT INTO CreditCardInformation(CreditCardNumber)
VALUES (ENCRYPTBYASYMKEY( AsymKey_ID('Lab10akey') ,  0x012345))
GO
SELECT * FROM CreditCardInformation
GO
--Расшифрование с помощью асииметричного ключа.
SELECT PersonID, CONVERT(nvarchar(max),  DecryptByAsymKey( AsymKey_Id('Lab10akey'), CreditCardNumber, N'Lab10'))   
,DecryptByAsymKey( AsymKey_Id('Lab10akey'), CreditCardNumber, N'Lab10')
AS DecryptedData   
FROM CreditCardInformation
GO  

--13 и 14.	Создать для экземпляра SQL Server сертификат.
use EncryptedDB
go
create certificate SampleCert
encryption by password = N'Lab10'
with subject = N'Цель создания',
Expiry_DATE = N'01/06/2022';

INSERT INTO CreditCardInformation values(EncryptByCert(Cert_ID('SampleCert'), N'Секретные данные'));
GO
SELECT * FROM CreditCardInformation
GO
SELECT (Convert(Nvarchar(100), DecryptByCert(Cert_ID('SampleCert'), CreditCardInformation.CreditCardNumber, N'Lab10'))) FROM CreditCardInformation;
GO

--15.	Создать для экземпляра SQL Server симметричный ключ шифрования данных.
--для шифрования симм ключа
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

--16.	Зашифровать и расшифровать данные при помощи этого ключа.
--Шифрование с помощью симетричного ключа.
INSERT INTO CreditCardInformation VALUES (ENCRYPTBYKEY( Key_GUID('SData') , N'Secret Data'))
GO
SELECT * FROM CreditCardInformation
GO
--Расшифрование с помощью симетричного ключа.
SELECT [PersonID], CONVERT(nvarchar(max),  DecryptByKey( [CreditCardNumber])) AS DecryptedData  FROM [dbo].[CreditCardInformation]
GO 

--17.	Продемонстрировать прозрачное шифрование базы данных.
USE SportPlace;  
GO  
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Lab10';  
go
CREATE CERTIFICATE MyServerCert WITH SUBJECT = 'My DEK Certificate';  
go  


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

SELECT *
FROM sys.dm_database_encryption_keys
WHERE encryption_state = 3;
GO  

--18.	Продемонстрировать применение хэширования.
select HASHBYTES('SHA1', 'Hesh exampl');

--19.	Продемонстрировать применение ЭЦП при помощи сертификата.
use EncryptedDB
GO
select SignByCert(Cert_Id( 'SampleCert' ),'dadaya', N'Lab10')

--20.	Сделать резервную копию необходимых ключей и сертификатов.
--перед запуском проверить в папке, созданы ли они, если да, то удалить x2: Cert
Backup certificate SampleCert
to File = N'D:\Study\Practice\DB_6sem\Lab10\Cert.cer'
with private key (
File = N'D:\Study\Practice\DB_6sem\Lab10\Cert.pvk',
Encryption by password = N'Lab10',
Decryption by password = N'Lab10');