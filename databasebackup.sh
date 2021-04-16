#!/bin/bash

WHOAMI=`whoami`
if [ $WHOAMI != "root" ]; then
  echo "Access denied"
else
  echo "Program executing now."
fi

PFAD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
DATABASE_LIST="$PFAD/databases.list"
BACKUP_LOCATION="$PFAD/databasebackups/"
source $DATABASE_LIST

if test -d $BACKUP_LOCATION ; then
  echo "Backup Directory already exists"
else
  mkdir $BACKUP_LOCATION
  echo "Created Backup Directory successfully"
fi

for i in ${!DATABASES[@]};
do
  DATABASE=${DATABASES[$i]}
  printf "$DATABASE is now getting saved.\n"
  sleep 1
  sudo -u root mysqldump -u root $DATABASE > $BACKUP_LOCATION/$DATABASE.sql
done

echo "program ends."
exit
