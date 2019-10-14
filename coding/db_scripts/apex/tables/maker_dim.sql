declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table maker_dim');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table maker_dim (uk number not null,
                        name varchar2(32))
tablespace apex;

comment on table maker_dim is 'Производители автомобилей';

comment on column maker_dim.uk   is 'Уникальный ключ';
comment on column maker_dim.name is 'Название';

create unique index uk_maker_dim on maker_dim
(uk)
tablespace apex;
