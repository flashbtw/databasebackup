This program is configurable and flexible to save your databases in .sql files in the "databasebackups" directory.<br\>
How to configure databases.list:<br\>
Default content of databases.list:<br\>

```bash
#!/bin/bash
 
DATABASES=("db1" "db2" "db3")
```

How to deploy your own databases:<br\>
**__Syntax:__** <br\>
DATABASES=("your_first_database" "your_second_database" "your_third_database" "your_fourth_database" "...")<br\><br\>
Theoretically, it is infinitely expandable.<br\><br\>
Have fun! 
