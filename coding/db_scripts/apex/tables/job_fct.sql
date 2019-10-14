declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table job_fct');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('Ошибка '||sqlerrm);
end;
/
create table job_fct (order_ccode varchar2(256) not null,
                      job_cnt     number,
                      job_price   number        not null,
                      job_uk      number        not null)
tablespace apex;

comment on table job_fct is 'Запись на сервис';

comment on column job_fct.order_ccode is 'Заказ наряд';
comment on column job_fct.job_cnt     is 'Количество работ';
comment on column job_fct.job_price   is 'Цена работ';
comment on column job_fct.job_uk      is 'Тип работ';
