declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table calendar_fct');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table calendar_fct (order_date      date   not null,
                           auto_uk         number not null,
                           job_description varchar2(4000))
tablespace apex;

comment on table calendar_fct is 'Запись на сервис';

comment on column calendar_fct.order_date      is 'Дата записи';
comment on column calendar_fct.auto_uk         is 'Автомобиль';
comment on column calendar_fct.job_description is 'Описание, требующихся работ';