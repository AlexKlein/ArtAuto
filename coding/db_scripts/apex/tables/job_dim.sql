declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table job_dim');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table job_dim (uk          number not null,
                      parent_uk   number,
                      description varchar2(256))
tablespace apex;

comment on table job_dim is 'Работы сервиса';

comment on column job_dim.uk          is 'Уникальный ключ';
comment on column job_dim.parent_uk   is 'Тип работ';
comment on column job_dim.description is 'Описание';

create unique index uk_job_dim on job_dim
(uk)
tablespace apex;
