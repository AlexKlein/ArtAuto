declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table auto_dim');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table auto_dim (uk               number not null,
                       model_uk         number,
                       car_plate        varchar2(8),
                       vin              varchar2(32),
                       mileage          number,
                       year_of_creation date,
                       client_uk        number)
tablespace apex;

comment on table auto_dim is 'Список автомобилей клиентов';

comment on column auto_dim.uk               is 'Уникальный ключ';
comment on column auto_dim.model_uk         is 'Модель';
comment on column auto_dim.car_plate        is 'Государственный номер';
comment on column auto_dim.vin              is 'VIN';
comment on column auto_dim.mileage          is 'Пробег';
comment on column auto_dim.year_of_creation is 'Год выпуска';
comment on column auto_dim.client_uk        is 'Владелец';

create unique index uk_auto_dim on auto_dim
(uk)
tablespace apex;