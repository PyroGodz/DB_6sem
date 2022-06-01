drop database  SportPlace;
create database SportPlace;
go
use SportPlace;

select name from sys.database_principals

CREATE LOGIN Pyrog
    WITH PASSWORD = '1111';
GO

CREATE USER Pyrog FOR LOGIN Pyrog;
GO
grant insert, select, update, delete to Pyrog

go
select * from coach
select * from client
select * from hal
select * from abon
select * from record
go
drop table record
drop table abon
drop table hal
drop table client
drop table coach
go
create table coach(
    id integer identity (1,1) PRIMARY KEY not null,
    FIO nvarchar(max) not null,
    payment integer not null
)
go
create table client(
    id integer identity (1,1) primary key not null,
    SecondName nvarchar(30) not null ,
    FirstName nvarchar(30) not null ,
    Phone nvarchar(15) null,
    coachId int null,
    constraint FK_Client_To_Coach foreign key (coachId) references Coach(id)
)
go
create table hal(
    id int identity (1,1) primary key not null ,
    name nvarchar(max) not null
)
go
create table abon(
    id int identity (1,1) primary key ,
    descr nvarchar(max),
    price int,
    halId int,
    constraint FK_Anon_To_Hal foreign key (halId) references hal(id)
)
go
create table record(
    clientId int not null ,
    abonId int not null ,
    startAbon date not null ,
    endAbon date not null ,
    isPaid bit not null ,
    constraint FK_Recor_To_Client foreign key (clientId) references client(id),
    constraint FK_Recor_To_Abon foreign key (abonId) references abon(id)
)

insert into coach values ( 'Зубенко Михаил Петрович', 133),( 'Мядель Тимофей Дмитриевич', 999),( 'Петров Петор Епифанов', 133);
insert into client values ( 'Петров', 'Петр', '375296663322',1), ( 'Семенов', 'Семен', '375291112233',2), ( 'Дмитро', 'Дима', '375292329988',3);
insert into hal values  ('Гимнастический зал'), ('Бассейн'),('Зал аэробики');
insert into abon values ('Спортивный',99,1), ('Русалка',101,2), ('Классный', 88,3);
insert into record values (1,1,'2022-03-01','2022-05-01',0), (2,2,'2022-02-09','2022-05-09',0), (3,3,'2022-01-01','2022-06-01',1);
go

create view paidClients as select * from record where isPaid = 1;
go
create view highPaidCoach as select * from coach where payment > 500;
go
select * from paidClients;
select * from highPaidCoach;
drop view paidClients;
drop view highPaidCoach;

create index indexClient on client (id);
create index indexAbon on abon (id);
drop index client.indexClient;
drop index abon.indexAbon;

create or alter procedure insertCoach
as
    begin try
        insert into coach values ( 'Пупкин Олег Владимирович', 666)
    end try
    begin catch
        rollback
        select error_message() as ErrorMessage;
    end catch
go

exec insertCoach;
select * from coach;
delete from coach where id=5;
drop procedure insertCoach;

create or alter procedure insertClient
as
    begin try
        insert into client values ( 'Сидоров', 'Степан', '375295557799',2)
    end try
    begin catch
        rollback
        select error_message() as ErrorMessage
    end catch
go

exec insertClient;
select * from client;
delete from client where id = 5;
drop procedure insertClient;

create or alter procedure insertRecord
as
    begin try
        insert into record values (99,3,'2022-02-02','2022-04-02',1)
    end try
    begin catch
    end catch
go
exec insertRecord;
select * from record;
delete from record where clientId = 99;
drop procedure insertRecord;

create or alter function isAllowed(@currentDate as date)
returns @records table(
    clientId int,
    abonId int,
    startAbon date,
    endAbon date,
    isPaid bit)
    as
    begin
        insert into @records
        select * from record where @currentDate between startAbon and endAbon
        return
    end
go
select * from isAllowed('2022-05-12');
drop function isAllowed;

create or alter trigger insertClientMessage
    on client
    after insert
    as
    begin try
        select ('Клиент был успешно добавлен')
    end try
    begin catch
        rollback
        select error_message() as ErrorMessage
    end catch
    go
drop trigger insertClientMessage

create or alter trigger insertCoachMessage
    on coach
    after insert
    as
    begin try
        select ('Тренер был успешно добавлен')
    end try
    begin catch
        rollback
        select error_message() as ErrorMessage
    end catch
    go
drop trigger insertCoachMessage

create or alter procedure checkPass
as
    begin try
        select c.FirstName as Name, c.SecondName as Sename, c.Phone as Phone, a.descr as 'Name of aboniment' from record r
            inner join abon a
            on r.abonId = a.id
            inner join client c
            on r.clientId = c.id
            where isPaid = 1
    end try
    begin catch
        select error_message() as ErrorMessage
    end catch
go

exec checkPass;
select * from record;
drop procedure checkPass;

create or alter procedure add_coach
    @FIO nvarchar(max),
    @payment int
as
    begin
        insert into coach(FIO, payment) values(@FIO, @payment)
        select 0;
    end
go
create or alter procedure add_hal
    @name nvarchar(max)
as
    begin
        insert into hal values (@name)
        select 0;
    end
go

create or alter procedure add_client
    @Secondname nvarchar(max),
    @Firstname nvarchar(max),
    @Phone nvarchar(max),
    @CoachId int
as
    begin
        insert into client values (@Secondname, @Firstname, @Phone,@CoachId)
        select 0;
    end
go


create or alter procedure drop_coach
    @id int
as
    begin
        delete from coach where id = @id;
        select 0;
    end
go

create or alter procedure drop_client
    @id int
as
    begin
        delete from client where id = @id;
        select 0;
    end
go
create or alter procedure drop_hal
    @id int
as
    begin
        delete from hal where id = @id;
        select 0;
    end
go


create or alter procedure change_coach
    @id int,
    @FIO nvarchar(max),
    @payment int
as
    begin
        update coach set FIO=@FIO, payment=@payment
            where id = @id;
        select 0;
    end
go

create or alter procedure change_client
    @id int,
    @Secondname nvarchar(max),
    @Firstname nvarchar(max),
    @Phone nvarchar(max),
    @CoachId int
as
    begin
        update client set SecondName = @Secondname, FirstName = @Firstname, Phone = @Phone, coachId = @CoachId
            where id = @id;
        select 0;
    end
go

create or alter procedure change_hal
    @id int,
    @name nvarchar(max)
as
    begin
        update hal set  name = @name where id = @id;
        select 0;
    end
go

create or alter procedure getAllCoaches
as
    select * from coach
go
create or alter procedure getAllHals
as
    select * from hal
go
create or alter procedure getAllClients
as
    select * from client
go


create or alter procedure getCount as select count(*) from coach where payment < 1000
go
-------------------------------Lab_3--------------------------------------------------------

sp_configure 'clr enabled', 1
Reconfigure
EXEC sp_configure 'clr strict security', 0;

RECONFIGURE;
drop procedure ReadFile
drop procedure WriteFile
drop assembly ReadTextLib;
alter database SportPlace set trustworthy on;
CREATE ASSEMBLY ReadTextLib from 'D:\Study\Practice\DB_6sem\Lab3\Lab3\bin\Debug\Lab3.dll' WITH PERMISSION_SET= unsafe

create or alter procedure WriteFile @filename nvarchar(max), @data nvarchar(max)
as
external name [ReadTextLib].[Lab3.Task1].[WriteFile]
go

exec WriteFile 'D:\a.txt', 'sportEvent';

create or alter procedure ReadFile @path nvarchar(max)
as
external name [ReadTextLib].[Lab3.Task1].[ReadTextFile]
go

exec ReadFile 'D:\a.txt';


drop type dbo.Address
CREATE TYPE dbo.Address
EXTERNAL NAME ReadTextLib.[Address];

-----------------------------Lab_4----------------------------------------

select * from gadm40_blr_2

-----------------------------Lab_9----------------------------------------
select * from coach
select * from client
select * from hal
select * from abon
select * from record

insert into coach values ( 'Генадий Аркадий Леонидович', 535),( 'Глукома Константин Мозгович', 322),( 'Сидор Яблок Джекович', 444);
insert into coach values ( 'Фибонач Ваня Иван', 531),( 'Икаров Зевс Стасянович', 322),( 'Хиджабов Адж Кин', 444),( 'Хин Ло Цзи', 221),( 'Вин Вожэ Кыг', 431 ),( 'Ямок Крич Кон', 123),( 'Якур Вар Джи', 143),( 'Кин Фо Джи', 553),( ' Ямур Сын Сон', 343),( 'Явар Джи Богд', 437),( 'Фин Ла Джи', 878),( 'Ниц Вац Шнейдж', 787),( 'Лоу Бан Джи', 891),( 'Бих Чжо Дан', 121),( 'Фан Джи Ман', 767),( 'Кун Ла Пир', 656),( 'Пирамид Кун Ваъ', 989);
insert into client values ( 'Петров', 'Петр', '375296663322',1), ( 'Семенов', 'Семен', '375291112233',2), ( 'Дмитро', 'Дима', '375292329988',3);
insert into client values ( 'Вин', 'Джо', 'Сын',13), ( 'Лао', 'Цзи', 'Кон',12), ( 'Вин', 'Бо', 'Ци', 11), ( 'Жан', 'Ла', 'Пэн',10), ( 'Кинг', 'Панч', 'Мен',9), ( 'Лэпс', 'Конг', 'Лин',8), ( 'Вар', 'Цзи', 'Фанжэ',7), ( 'Цзи', 'Кан', 'Воу',4), ( 'Фин', 'Ляо', 'Жо',5);
insert into hal values  ('Гимнастический зал'), ('Бассейн'),('Зал аэробики');
insert into hal values  ('Такой зал'),('Сякой зал'),('Инако зал'),('Карате зал'),('Спортзал'),('Не зал'),('Душ'),('Туалет'),('Мокрый зал'),('Красивый зал'),('Вонючий зал');
insert into abon values ('Спортивный',99,1), ('Русалка',101,2), ('Классный', 88,3);
insert into abon values ('Для качков',123,5), ('Для лысых',121,3), ('Для волосатых', 98,14), ('Для птиц',11 ,6), ('Разуваться при входе', 12, 7), ('Без ног ONLY', 0, 8), ('С компом', 55, 9), ('С собакой', 77, 10), ('Для кошатников', 99, 11), ('Для КРЫС', 100, 12);
insert into record values (34,16,'2022-03-01','2022-05-01',0), (36,15,'2022-03-01','2022-05-01',0), (35,14,'2022-03-01','2022-05-01',0), (37,13,'2022-03-01','2022-05-01',0), (38, 12,'2022-03-01','2022-05-01',0), (39,11,'2022-03-08','2022-05-02',0), (40, 10,'2022-03-07','2022-05-03',0), (41,9,'2022-03-06','2022-05-04',0), (42,10,'2022-03-05','2022-05-05',0), (43,8,'2022-03-04','2022-05-06',0), (44,7,'2022-03-03','2022-07-01',0), (45, 13,'2022-03-02','2022-05-09',0);

insert into record values (40, 10,'2022-03-07','2022-05-03',0), (40,9,'2022-03-06','2022-05-04',0), (40,10,'2022-03-05','2022-05-05',0), (40,8,'2022-03-04','2022-05-06',0), (40,7,'2022-03-03','2022-07-01',0), (40, 13,'2022-03-02','2022-05-09',0);
--Task 2 --- Объем услуг
SELECT count(*) FROM abon
	WHERE price BETWEEN 60 AND 200;

SELECT Id, descr, price
	,sum(price) OVER() as "Объем услуг"
	,(100.00*price / (sum(price) OVER())) AS "Percent"  
FROM abon   
	WHERE price BETWEEN 60 AND 200

SELECT max(price),
	(100.00*max(price)/ sum(price)) as "Porc"
	from abon
	WHERE price BETWEEN 60 AND 200

--Task 3
SELECT * , ROW_NUMBER() OVER(PARTITION BY clientId ORDER BY endAbon) AS rownum
FROM record;

--4
SELECT count(*) FROM record;

delete x from 
(
  select *, rn=row_number() over (partition by clientId order by endAbon)
  from record 
) x

where rn > 1;



--5
select * from
(select price,
		record.clientId,
		record.startAbon,
		 sum(price) over (partition by record.clientId) as [count],
	rn = row_number() over (partition by record.clientId order by record.startAbon desc)
	from record join abon on abon.id = record.abonId
	) x
	where rn between 1 and 6;

--6
select * from(
	select hal.name, count(price) over (partition by hal.id ) as "Наиболее использованные",
	rn = row_number() over (partition by hal.id order by hal.name desc) 
	from hal join abon on abon.halId = hal.id 
	) x
	where rn < 2

	--или 

	select hal.name, cnt = count(price) over (partition by hal.id )  from hal join abon on abon.halId = hal.id order by cnt desc;