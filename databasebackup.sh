#!/bin/bash

# user verification #
WHOAMI=`whoami`
if [ $WHOAMI != "root" ]; then
  echo "Access denied"
  exit
else
  echo "Program executing now."
fi

# error catching #
trap 'catch $? $LINENO' ERR
catch() {
  echo "Error occured in Line $2"
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
  echo "FATAL: No Database List found. Creating one and exiting so you can configure it."
  touch $DATABASE_LIST
  {
  printf "#!/bin/bash\n\n"
  printf "DATABASES=(\"db1\" \"db2\" \"db3\")"
  } >$DATABASE_LIST
  sleep 1
  echo "File successfully created."
  exit
fi

source $DATABASE_LIST

#checking if the backup directory exists
if test -d $BACKUP_LOCATION ; then
  echo "Backup Directory exists"
else
  mkdir $BACKUP_LOCATION
  echo "Created Backup Directory successfully"
fi

catch() {
  echo "Database $DATABASE not found."
}

read -p 'Are your databases in use right now? (y/n)' DATABASE_IN_USE

if [ $DATABASE_IN_USE == "y" ]; then
  for i in ${!DATABASES[@]};
  do
    DATABASE=${DATABASES[$i]}
    printf "$DATABASE is now getting saved.\n"
    sleep 1
    {
    sudo -u root mysqldump -u root --single-transaction $DATABASE > $BACKUP_LOCATION/$DATABASE.sql
    } 2>/dev/null
  done
else
  if [ $DATABASE_IN_USE == "n" ]; then
    for i in ${!DATABASES[@]};
    do
      DATABASE=${DATABASES[$i]}
      printf "$DATABASE is now getting saved.\n"
      sleep 1
      {
      sudo -u root mysqldump -u root $DATABASE > $BACKUP_LOCATION/$DATABASE.sql
      } 2>/dev/null
    done
  else
    echo "\"$DATABASE_IN_USE\" is not a valid answer."
    exit
  fi
fi

echo "program ends."
exit
