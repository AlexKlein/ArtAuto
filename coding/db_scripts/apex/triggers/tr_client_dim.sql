create or replace trigger tr_client_dim
before insert on client_dim
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
