#!/bin/bash

#******************************* HISTORY *******************************************
#Date        Author            ID       Description
#----------  ---------------  --------  --------------------------------------------
#2019-28-02  Klein A.M.       [000000]  Script created.
#******************************* HISTORY *******************************************

# attributes of database
DB_HostName=$1
DB_Port=1521
DB_SID=XE
DB_UserSYS=SYS
DB_PasswordSYS=oracle
DB_UserName=APEX
DB_Password=$2

# export system environment variables
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
export ORACLE_SID=XE
export ORACLE_OWNER=oracle
export ORACLE_TERM=xterm
export TNS_ADMIN=$ORACLE_HOME/network/admin
export NLS_LANG=RUSSIAN_RUSSIA.AL32UTF8
export PATH=$PATH:$ORACLE_HOME/bin:/u01/app/oracle/product/11.2.0/xe/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# change schema password
echo "Changing schema password"
sed -i "s/&APEX_PWD/$DB_Password/g" /app/coding/db_scripts/sys/users/apex.sql

# file creation with script for installation Oracle objects
sc_file_sys="orainstsc_sys.txt"
sc_file_usr="orainstsc_usr.txt"
sc_file_apx="orainstsc_apx.txt"

# writing objects in common order
echo "`date` : Script file filling"

find /app/coding/db_scripts  -maxdepth 3 -type f | grep sys/tablespaces  > "${sc_file_sys}"
find /app/coding/db_scripts  -maxdepth 3 -type f | grep sys/users       >> "${sc_file_sys}"
find /app/coding/db_scripts  -maxdepth 3 -type f | grep apex/tables      > "${sc_file_usr}"
find /app/coding/db_scripts  -maxdepth 3 -type f | grep apex/sequences  >> "${sc_file_usr}"
find /app/coding/db_scripts  -maxdepth 3 -type f | grep apex/functions  >> "${sc_file_usr}"
find /app/coding/db_scripts  -maxdepth 3 -type f | grep apex/triggers   >> "${sc_file_usr}"
find /app/coding/db_scripts  -maxdepth 3 -type f | grep apex/scripts    >> "${sc_file_usr}"
find /app/coding/application -maxdepth 1 -type f | grep APEX_WKS.sql     > "${sc_file_apx}"
find /app/coding/application -maxdepth 1 -type f | grep f100.sql        >> "${sc_file_apx}"

echo "`date` : Script file filled"

# function for database status checking
db_statuscheck_sys() {
    echo "`date` : Trying to connect as "${DB_UserSYS}"@"${DB_SID}""
    echo "`date` : Connection string in use is : (DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_HostName})(PORT=${DB_Port})))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=${DB_SID}))) as SYSDBA"
    echo "exit" | $ORACLE_HOME/bin/sqlplus "${DB_UserSYS}/${DB_PasswordSYS}@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_HostName})(PORT=${DB_Port})))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=${DB_SID}))) as SYSDBA" | grep -v "Connected to:" > /dev/null
if [ $? -eq 0 ] 
    then
        DB_STATUS="UP"
        export DB_STATUS
        echo "`date` : Connection is possible"
    else
        DB_STATUS="DOWN"
        export DB_STATUS
        echo "`date` : Connection is impossible"
        exit 1
    fi
}

db_statuscheck_usr() {
    echo "`date` : Trying to connect as "${DB_UserName}"@"${DB_SID}""
    echo "`date` : Connection string in use is : (DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST="${DB_HostName}")(PORT="${DB_Port}")))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME="${DB_SID}")))"
    echo "exit" | $ORACLE_HOME/bin/sqlplus "${DB_UserName}/${DB_Password}@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_HostName})(PORT=${DB_Port})))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=${DB_SID}))) as SYSDBA" | grep -v "Connected to:" > /dev/null
if [ $? -eq 0 ] 
then
DB_STATUS="UP"
export DB_STATUS
echo "`date` : Connection is possible"

    else
DB_STATUS="DOWN"
export DB_STATUS
echo "`date` : Connection is impossible"
exit 1
fi
}

# function for start installing Oracle objects in SYS schema
install_sys() {
    db_statuscheck_sys
    
    if [[ "$DB_STATUS" == "DOWN" ]] 
    then
        exit 1
    fi       
    
    if [[ "$DB_STATUS" == "UP" ]] 
    then
        # installing objects through script file
        for file in $(cat "${sc_file_sys}")
        do

            echo "`date` : Installing script in $file"
            echo "`date` : Executed script output:"
            $ORACLE_HOME/bin/sqlplus -s -L ""${DB_UserSYS}"/"${DB_PasswordSYS}"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST="${DB_HostName}")(PORT="${DB_Port}")))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME="${DB_SID}"))) as SYSDBA" <<EOF
            @$file;
            commit;
            quit;
EOF
        done

        echo "`date` : Installation completed"
    else
        exit
    fi
}

# function for start installing Oracle objects in User's schema
install_usr() {
    db_statuscheck_usr
    
    if [[ "$DB_STATUS" == "DOWN" ]] 
    then
        exit 1
    fi
        
    if [[ "$DB_STATUS" == "UP" ]] 
    then

        # installing objects through script file
        for file in $(cat "${sc_file_usr}")
        do

            echo "`date` : Installing script in $file"
            echo "`date` : Executed script output:"
            $ORACLE_HOME/bin/sqlplus -s -L ""${DB_UserName}"/"${DB_Password}"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST="${DB_HostName}")(PORT="${DB_Port}")))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME="${DB_SID}")))" <<EOF
            @$file;
            commit;
            quit;
EOF
        done

        echo "`date` : Installation completed"
    else
        exit
    fi
}

# function for start installing Apex workspace and application
install_apx() {
    db_statuscheck_sys
    
    if [[ "$DB_STATUS" == "DOWN" ]] 
    then
        exit 1
    fi       
    
    if [[ "$DB_STATUS" == "UP" ]] 
    then
        # installing objects through script file
        for file in $(cat "${sc_file_apx}")
        do

            echo "`date` : Installing script in $file"
            echo "`date` : Executed script output:"
            $ORACLE_HOME/bin/sqlplus -s -L ""${DB_UserSYS}"/"${DB_PasswordSYS}"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST="${DB_HostName}")(PORT="${DB_Port}")))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME="${DB_SID}"))) as SYSDBA" <<EOF
            @$file;
            commit;
            quit;
EOF
        done

        echo "`date` : Installation completed"
    else
        exit
    fi
}

# function for upgrade Apex version
upgrade_apx() {
    db_statuscheck_sys
    
    if [[ "$DB_STATUS" == "DOWN" ]] 
    then
        exit 1
    fi       
    
    if [[ "$DB_STATUS" == "UP" ]] 
    then
        unzip /app/upgrade/apex_19.1.zip
cd /app/apex
# installing objects

$ORACLE_HOME/bin/sqlplus -s -L ""${DB_UserSYS}"/"${DB_PasswordSYS}"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST="${DB_HostName}")(PORT="${DB_Port}")))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME="${DB_SID}"))) as SYSDBA" <<EOF
@apexins1.sql SYSAUX SYSAUX TEMP /i/
commit;
quit;
EOF
        $ORACLE_HOME/bin/sqlplus -s -L ""${DB_UserSYS}"/"${DB_PasswordSYS}"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST="${DB_HostName}")(PORT="${DB_Port}")))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME="${DB_SID}"))) as SYSDBA" <<EOF
@apexins2.sql SYSAUX SYSAUX TEMP /i/
commit;
quit;
EOF
        $ORACLE_HOME/bin/sqlplus -s -L ""${DB_UserSYS}"/"${DB_PasswordSYS}"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST="${DB_HostName}")(PORT="${DB_Port}")))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME="${DB_SID}"))) as SYSDBA" <<EOF
@apexins3.sql SYSAUX SYSAUX TEMP /i/
commit;
quit;
EOF
        $ORACLE_HOME/bin/sqlplus -s -L ""${DB_UserSYS}"/"${DB_PasswordSYS}"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST="${DB_HostName}")(PORT="${DB_Port}")))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME="${DB_SID}"))) as SYSDBA" <<EOF
@apex_epg_config.sql /app
commit;
quit;
EOF
        cd /app
rm -rf /app/apex
rm -rf /app/upgrade
        echo "`date` : Upgrade completed"
    else
        exit
    fi
}

# installing Oracle objects
exec_install() {
    echo "`date` : Start of objects installation"
    install_sys
    install_usr
install_apx
    echo "`date` : Done"
}

# executing upgrade Apex version
upgrade_apx

# executing installation
exec_install

# removing script files
rm orainstsc_sys.txt
rm orainstsc_usr.txt
rm orainstsc_apx.txt
echo "Script files removed"

echo "Installation well done"
