declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table master_dim');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table master_dim (uk    number not null,
                         phone varchar2(16),
                         name  varchar2(256))
tablespace apex;

comment on table master_dim is 'Список мастеров';

comment on column master_dim.uk    is 'Уникальный ключ';
comment on column master_dim.phone is 'Телефон';
comment on column master_dim.name  is 'Имя';

create unique index uk_master_dim on master_dim
(uk)
tablespace apex;