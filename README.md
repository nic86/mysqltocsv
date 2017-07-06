# mysqltocsv
Export data from mysql to csv file


Command Line Use:

user@hostname:~$./mysqltocsv 'dbhost' 'user' 'pass' 'dbname' 'dbtable' 'fields' 'headers' 'separator' 'enclose' 'escape' 'endline' > destinationfile.csv




Verify mysql variables 'secure_file_priv':

mysql -e SHOW VARIABLES LIKE "secure_file_priv"
