This program is configurable and flexible to save your databases in .sql files in the "databasebackups" directory.
How to configure databases.list:
Default content of databases.list:
.
.
 #!/bin/bash
 
 DATABASES=("db1" "db2" "db3")
.
.
How to deploy your own databases:
 Syntax: 
  DATABASES=("your_first_database" "your_second_database" "your_third_database" "your_fourth_database" "...")
 Theoretically, it is infinitely expandable.

Have fun! 
