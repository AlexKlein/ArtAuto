declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table order_fct');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table order_fct (order_ccode    varchar2(256) not null,
                        order_date     date          not null,
                        auto_uk        number        not null,
                        recommendation varchar2(4000))
tablespace apex;

comment on table order_fct is 'Запись на сервис';

comment on column order_fct.order_ccode    is 'Заказ наряд';
comment on column order_fct.order_date     is 'Дата проведения работ';
comment on column order_fct.auto_uk        is 'Автомобиль';
comment on column order_fct.recommendation is 'Рекомендации сервиса на будущее';