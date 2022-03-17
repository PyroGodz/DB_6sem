drop database  SportPlace;
create database SportPlace;
go
use SportPlace;

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
    id int PRIMARY KEY ,
    FIO nvarchar(max),
    payment int
)
go
create table client(
    id int primary key,
    SecondName nvarchar(30),
    FirstName nvarchar(30),
    Phone nvarchar(15),
    coachId int,
    constraint FK_Client_To_Coach foreign key (coachId) references Coach(id)
)
go
create table hal(
    id int primary key ,
    name nvarchar(max)
)
go
create table abon(
    id int primary key ,
    descr nvarchar(max),
    price int,
    halId int,
    constraint FK_Anon_To_Hal foreign key (halId) references hal(id)
)
go
create table record(
    clientId int,
    abonId int,
    startAbon date,
    endAbon date,
    isPaid bit,
    constraint FK_Recor_To_Client foreign key (clientId) references client(id),
    constraint FK_Recor_To_Abon foreign key (abonId) references abon(id)
)

insert into coach values (1, 'Зубенко Михаил Петрович', 133),(2, 'Мядель Тимофей Дмитриевич', 999),(3, 'Петров Петор Епифанов', 133);
insert into client values (1, 'Петров', 'Петр', '375296663322',1), (2, 'Семенов', 'Семен', '375291112233',2), (3, 'Дмитро', 'Дима', '375292329988',3);
insert into hal values  (1,'Гимнастический зал'), (2,'Бассейн'),(3,'Зал аэробики');
insert into abon values (1, 'Спортивный',99,1), (2, 'Русалка',101,2), (3,'Классный', 88,3);
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
        insert into coach values (5, 'Пупкин Олег Владимирович', 666)
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
        insert into client values (99, 'Сидоров', 'Степан', '375295557799',2)
    end try
    begin catch
        rollback
        select error_message() as ErrorMessage
    end catch
go

exec insertClient;
select * from client;
delete from client where id = 99;
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
