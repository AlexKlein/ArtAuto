#!/bin/bash

#******************************* HISTORY *******************************************
#Date        Author            ID       Description
#----------  ---------------  --------  --------------------------------------------
#2019-28-02  Klein A.M.       [000000]  Script created.
#******************************* HISTORY *******************************************

# attributes of database
DB_HostName="localhost"
DB_Port="1521"
DB_SID="XE"
DB_UserSYS="SYS"
DB_PasswordSYS="<PASSWORD>"
DB_UserName="APEX"
DB_Password="<PASSWORD>"

# file creation with script for installation Oracle objects
sc_file_sys="orainstsc_sys.txt"
sc_file_usr="orainstsc_usr.txt"

# writing objects in common order
echo "`date` : Script file filling"
	
find  coding/db_scripts -maxdepth 3 -type f | grep sys/users        > "${sc_file_sys}"
find  coding/db_scripts -maxdepth 3 -type f | grep sys/tablespaces >> "${sc_file_sys}"
find  coding/db_scripts -maxdepth 3 -type f | grep apex/tables      > "${sc_file_usr}"
find  coding/db_scripts -maxdepth 3 -type f | grep apex/sequences  >> "${sc_file_usr}"
find  coding/db_scripts -maxdepth 3 -type f | grep apex/functions  >> "${sc_file_usr}"
find  coding/db_scripts -maxdepth 3 -type f | grep apex/triggers   >> "${sc_file_usr}"
find  coding/db_scripts -maxdepth 3 -type f | grep apex/scripts    >> "${sc_file_usr}"

echo "`date` : Script file filled"

# function for database status checking
db_statuscheck_sys() {
    echo "`date` : Trying to connect as "${DB_UserSYS}"@"${DB_SID}""
    echo "`date` : Connection string in use is : (DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST="${DB_HostName}")(PORT="${DB_Port}")))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME="${DB_SID}"))) as SYSDBA"
    echo "exit" | sqlplus "${DB_UserSYS}/${DB_PasswordSYS}@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_HostName})(PORT=${DB_Port})))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=${DB_SID}))) as SYSDBA" | grep -q "Connected to:" > /dev/null
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
    echo "exit" | sqlplus "${DB_UserName}/${DB_Password}@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_HostName})(PORT=${DB_Port})))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=${DB_SID})))" | grep -q "Connected to:" > /dev/null
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
        for file in `cat orainstsc.txt`
        do

            echo "`date` : Installing script in $file"
            echo "`date` : Executed script output:"
            sqlplus -s -L ""${DB_UserSYS}"/"${DB_PasswordSYS}"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST="${DB_HostName}")(PORT="${DB_Port}")))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME="${DB_SID}")))" <<EOF
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
        for file in `cat orainstsc.txt`
        do

            echo "`date` : Installing script in $file"
            echo "`date` : Executed script output:"
            sqlplus -s -L ""${DB_UserName}"/"${DB_Password}"@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST="${DB_HostName}")(PORT="${DB_Port}")))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME="${DB_SID}")))" <<EOF
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

# installing Oracle objects
exec_install() {
    echo "`date` : Start of objects installation"
    install_sys
	install_usr
    echo "`date` : Done"
}

#executing installation
exec_install

#removing script files
rm orainstsc_sys.txt
rm orainstsc_usr.txt