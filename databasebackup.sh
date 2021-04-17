#!/bin/bash

### printf colors ###
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)
YELLOW=$(tput setaf 3)

### echo colors ###
ECHO_RESET="\033[0m"
ECHO_YELLOW="\033[38;5;11m"

# user verification #
WHOAMI=`whoami`
if [ $WHOAMI != "root" ]; then
  printf "${RED}Access denied${NORMAL}"
  exit
else
  echo "${CYAN}Program executing now.${CYAN}"
fi

# error catching #
trap 'catch $? $LINENO' ERR
catch() {
  printf "${RED}Error occured in Line $2\n"
}

### variables ###

#checks where the bash script is
PFAD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

#some path variables
DATABASE_LIST="$PFAD/databases.list"
BACKUP_LOCATION="$PFAD/databasebackups/"

### code ###

#checking if database list exists
if test -f $DATABASE_LIST ; then
  printf ""
else
  printf "${RED}FATAL: No Database List found. Creating one and exiting so you can configure it.\n${NORMAL}"
  touch $DATABASE_LIST
  {
  printf "#!/bin/bash\n\n"
  printf "DATABASES=(\"db1\" \"db2\" \"db3\")"
  } >$DATABASE_LIST
  sleep 1
  printf "${GREEN}File successfully created.\n${NORMAL}"
  exit
fi

source $DATABASE_LIST

#checking if the backup directory exists
if test -d $BACKUP_LOCATION ; then
  printf "${CYAN}Backup Directory exists${NORMAL}\n"
else
  mkdir $BACKUP_LOCATION
  printf "${CYAN}Created Backup Directory successfully${NORMAL}\n"
fi

catch() {
  DATABASE_EXISTS=false
}

read -p "$(echo -e $ECHO_YELLOW"Are your databases in use right now? (y/n)"$ECHO_RESET )" DATABASE_IN_USE

if [ $DATABASE_IN_USE == "y" ]; then
  for i in ${!DATABASES[@]};
  do
    DATABASE=${DATABASES[$i]}
    sleep 1
    {
    sudo -u root mysqldump -u root --single-transaction $DATABASE > $BACKUP_LOCATION/$DATABASE.sql
    } 2>/dev/null
    if [ "$DATABASE_EXISTS" = false ] ; then
      printf "${RED}Database $DATABASE not existing${NORMAL}\n"
      DATABASE_EXISTS=null
    else
      printf "${GREEN}Database $DATABASE is now getting saved.${NORMAL}\n"
    fi
  done
else
  if [ $DATABASE_IN_USE == "n" ]; then
    for i in ${!DATABASES[@]};
    do
      DATABASE=${DATABASES[$i]}
      sleep 1
      {
      sudo -u root mysqldump -u root $DATABASE > $BACKUP_LOCATION/$DATABASE.sql
      } 2>/dev/null
      if [ "$DATABASE_EXISTS" = false ] ; then
        printf "${RED}Database $DATABASE not existing${NORMAL}\n"
        DATABASE_EXISTS=null
      else
        printf "${GREEN}Database $DATABASE is now getting saved.${NORMAL}\n"
      fi
    done
  else
    echo "\"$DATABASE_IN_USE\" is not a valid answer."
    exit
  fi
fi

printf "${CYAN}\nprogram ends.\n"
exit
