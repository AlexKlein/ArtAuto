declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table service_dim');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table service_dim (name          varchar2(256),
                          address       varchar2(256),
                          service_phone varchar2(16),
                          order_phone   varchar2(16))
tablespace apex;

comment on table service_dim is 'Реквизиты сервиса';

comment on column service_dim.name          is 'Название';
comment on column service_dim.address       is 'Адрес';
comment on column service_dim.service_phone is 'Телефон сервиса';
comment on column service_dim.order_phone   is 'Телефон отдела запасных частей';
