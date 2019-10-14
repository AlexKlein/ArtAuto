declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table model_dim');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table model_dim (uk       number not null,
                        maker_uk number,
                        name     varchar2(32))
tablespace apex;

comment on table model_dim is 'Список моделей автомобилей';

comment on column model_dim.uk       is 'Уникальный ключ';
comment on column model_dim.maker_uk is 'Производитель';
comment on column model_dim.name     is 'Название';

create unique index uk_model_dim on model_dim
(uk)
tablespace apex;
