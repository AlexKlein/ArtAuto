create user apex
  identified by &APEX_PWD
  --default tablespace apex
  temporary tablespace temp
  profile default
  account unlock;
  -- 2 Roles for APEX 
  grant connect to apex with admin option;
  grant resource to apex;
  alter user apex default role all;
  -- 14 System Privileges for APEX 
  grant alter session to apex;
  grant alter system to apex;
  grant create database link to apex;
  grant create job to apex;
  grant create procedure to apex;
  grant create session to apex;
  grant create table to apex;
  grant create view to apex;
  grant debug connect session to apex;
  grant execute any procedure to apex;
  grant lock any table to apex;
  grant select any dictionary to apex;
  grant select any table to apex;
  grant unlimited tablespace to apex;
  -- 1 Tablespace Quota for APEX 
  --alter user apex quota unlimited on apex;
  -- 1 Object Privilege for APEX 
    grant select on sys.user$ to apex;
  -- 1 Resoure Group Privilege for APEX 
begin
  sys.dbms_resource_manager.clear_pending_area();
  sys.dbms_resource_manager.create_pending_area();
  sys.dbms_resource_manager_privs.grant_switch_consumer_group
    ('APEX','SYS_GROUP',false);
  sys.dbms_resource_manager.submit_pending_area();
end;
/
begin
  sys.dbms_resource_manager.set_initial_consumer_group
    ('APEX','SYS_GROUP');
end;
/
