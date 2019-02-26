declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table client_dim');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table client_dim (uk    number not null,
                         phone varchar2(16),
                         name  varchar2(256),
                         email varchar2(256))
tablespace apex;

comment on table client_dim is 'Список клиентов';

comment on column client_dim.uk    is 'Уникальный ключ';
comment on column client_dim.phone is 'Телефон';
comment on column client_dim.name  is 'Имя';
comment on column client_dim.email is 'Электронная почта';

create unique index uk_client_dim on client_dim
(uk)
tablespace apex;