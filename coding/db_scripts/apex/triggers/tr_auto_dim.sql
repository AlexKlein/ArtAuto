create or replace trigger tr_auto_dim
before insert on auto_dim
referencing new as new old as old
for each row
begin
    if :new.uk is null or 
       :new.uk = 0 then
        select get_uk 
        into   :new.uk 
        from   dual;
    end if;
end;
/
