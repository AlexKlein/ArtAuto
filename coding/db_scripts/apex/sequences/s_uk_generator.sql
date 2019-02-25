declare
    object_not_found exception;
    pragma exception_init(object_not_found, -02289);
begin
    execute immediate ('drop sequence s_uk_generator');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('������ '||sqlerrm);
end;
/
create sequence s_uk_generator;