use SportPlace;
go


drop table Report;
go
create table Report
(
    id INTEGER primary key identity(1,1),
    xml_column XML
);

--task3

select * from client;

go
create procedure generateXML
as
declare @x XML
set @x = (Select	clnt.FirstName [Имя клиента], 
					abn.descr [Секция], 
					GETDATE() [Дата вып.]
	from  record rcrd 
					join client clnt on clnt.id = rcrd.clientId
					join abon abn on abn.id = rcrd.abonId
	FOR XML AUTO);
	SELECT @x
go

execute generateXML;

--task3
create or alter procedure insertInReport 
as
begin
declare @s XML
set @s = (Select	clnt.FirstName [Имя клиента], 
					abn.descr [Секция], 
					GETDATE() [Дата вып.]
	from  record rcrd 
					join client clnt on clnt.id = rcrd.clientId
					join abon abn on abn.id = rcrd.abonId
	FOR XML AUTO);
	insert into Report values(@s)
end

exec insertInReport
select * from Report

--task4
create primary xml index My_XML_Index on Report(xml_column)

--task5
create or alter procedure selectXmlData
as
select xml_column.query('/clnt') as [xml данные] from Report for xml auto, type;

create or alter procedure selectXmlData1
as
select xml_column.query('/clnt/abn') as [xml данные] from Report for xml auto, type;

create or alter procedure selectXmlData2
as
select xml_column.value('(/clnt/@Имя_x0020_клиента)[1]', 'nvarchar(max)') as [xml данные] from Report for xml auto, type;


exec selectXmlData
go
exec selectXmlData1
go
exec selectXmlData2