create or replace function get_uk return number
as
    res number;
begin
    select s_uk_generator.nextval 
    into   res
    from   dual;
    
    return res;
exception
    when others then
        dbms_output.put_line('Ошибка '  ||chr(10)||
        dbms_utility.format_error_stack||
        dbms_utility.format_error_backtrace());

end;
/
