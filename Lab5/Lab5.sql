use SportPlace
go

alter table coach add parentId hierarchyId 

select * from coach;

update coach set parentId = hierarchyId::GetRoot() where Id != 0;

-- 2. отображает 

create procedure selectHid @QQQ hierarchyid
	as
	begin
	select
	parentId,
	parentId.ToString() as hidPathString,
	parentId.GetLevel() as hidPathlevel,
	FIO,
	payment
	from coach
	where parentId.IsDescendantOf(@QQQ)=1
	end;
go

exec selectHid '/';
go 

--3. Добавление

create procedure AddCoachUsingHierarchy (@fio nvarchar(100),
											@payment int,
											@parentId hierarchyId)
as
begin
begin try
declare @LCV hierarchyid
	begin transaction
		select @LCV=max(parentId)
		from coach where
		parentId.GetAncestor(1)=@parentId;
	insert into coach(FIO, payment, parentId)
	values (@FIO, @payment, @parentId.GetDescendant(@LCV,NULL));
	commit;
end try
BEGIN CATCH
    print ERROR_NUMBER() + ERROR_MESSAGE();
END CATCH
end;

execute AddCoachUsingHierarchy 'ROckефвш.',333 , '/1/4/';
select * from coach;

-- 4. проц, перемещ всю подчиненную ветку
-- парам - знач верхнего узла + знач узла, в кот. перемещ

Create procedure moveHid
	@OldParent hierarchyid, 
	@NewParent hierarchyid  
as
begin
DECLARE children_cursor CURSOR FOR  
	SELECT parentId FROM coach  
	WHERE parentId.GetAncestor(1) = @OldParent;  
DECLARE @ChildId hierarchyid;  
OPEN children_cursor  
FETCH NEXT FROM children_cursor INTO @ChildId;  
WHILE @@FETCH_STATUS = 0  
BEGIN  
START:  
    DECLARE @NewId hierarchyid;  
    SELECT @NewId = @NewParent.GetDescendant(MAX(parentId), NULL)  
    FROM coach WHERE parentId.GetAncestor(1) = @NewParent;  

    UPDATE coach 
    SET parentId = parentId.GetReparentedValue(@ChildId, @NewId)  
    WHERE parentId.IsDescendantOf(@ChildId) = 1;  
    IF @@error <> 0 GOTO START -- On error, retry  
        FETCH NEXT FROM children_cursor INTO @ChildId;  
END  
CLOSE children_cursor;  
DEALLOCATE children_cursor;  
end;
go 

exec moveHid '/3/','/1/4/';
exec moveHid '/1/4/', '/3/';
select parentId.ToString(), * from coach;

