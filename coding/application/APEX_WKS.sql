set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_default_workspace_id=>1691315221256815
);
end;
/
prompt  WORKSPACE 1691315221256815
--
-- Workspace, User Group, User, and Team Development Export:
--   Date and Time:   11:00 Thursday October 10, 2019
--   Exported By:     ADMIN
--   Export Type:     Workspace Export
--   Version:         5.0.4.00.12
--   Instance ID:     103875576328913
--
-- Import:
--   Using Instance Administration / Manage Workspaces
--   or
--   Using SQL*Plus as the Oracle user APEX_050000
 
begin
    wwv_flow_api.set_security_group_id(p_security_group_id=>1691315221256815);
end;
/
----------------
-- W O R K S P A C E
-- Creating a workspace will not create database schemas or objects.
-- This API creates only the meta data for this APEX workspace
prompt  Creating workspace APEX_WKS...
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
end;
/
begin
wwv_flow_fnd_user_api.create_company (
  p_id => 1691473732256836
 ,p_provisioning_company_id => 1691315221256815
 ,p_short_name => 'APEX_WKS'
 ,p_display_name => 'APEX_WKS'
 ,p_first_schema_provisioned => 'APEX'
 ,p_company_schemas => 'APEX'
 ,p_account_status => 'ASSIGNED'
 ,p_allow_plsql_editing => 'Y'
 ,p_allow_app_building_yn => 'Y'
 ,p_allow_packaged_app_ins_yn => 'Y'
 ,p_allow_sql_workshop_yn => 'Y'
 ,p_allow_websheet_dev_yn => 'Y'
 ,p_allow_team_development_yn => 'Y'
 ,p_allow_to_be_purged_yn => 'Y'
 ,p_allow_restful_services_yn => 'Y'
 ,p_source_identifier => 'APEX_WKS'
 ,p_path_prefix => 'APEX_WKS'
 ,p_files_version => 1
 ,p_workspace_image => wwv_flow_api.g_varchar2_table
);
end;
/
----------------
-- G R O U P S
--
prompt  Creating Groups...
prompt  Creating group grants...
----------------
-- U S E R S
-- User repository for use with APEX cookie-based authentication.
--
prompt  Creating Users...
begin
wwv_flow_fnd_user_api.create_fnd_user (
  p_user_id                      => '1691251530256814',
  p_user_name                    => 'ADMIN',
  p_first_name                   => '',
  p_last_name                    => '',
  p_description                  => '',
  p_email_address                => 'admin@gmail.com',
  p_web_password                 => 'CD2EE58B449B2D2E97616428E3917A1EB9596BEF',
  p_web_password_format          => '5;2;10000',
  p_group_ids                    => '',
  p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
  p_default_schema               => 'APEX',
  p_account_locked               => 'N',
  p_account_expiry               => to_date('201910101100','YYYYMMDDHH24MI'),
  p_failed_access_attempts       => 0,
  p_change_password_on_first_use => 'Y',
  p_first_password_use_occurred  => 'Y',
  p_allow_app_building_yn        => 'Y',
  p_allow_sql_workshop_yn        => 'Y',
  p_allow_websheet_dev_yn        => 'Y',
  p_allow_team_development_yn    => 'Y',
  p_allow_access_to_schemas      => '');
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
