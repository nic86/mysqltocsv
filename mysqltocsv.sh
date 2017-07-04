#!/bin/bash
# Export a MySQL database table into CSV format
#
# Usage: mysql-csv <database> <table> [fields] [extra parameters]
#
# If fields is omitted '*' is assumed

DATABASE="$1"
TABLE="$2"
FIELDS="$3"
shift; shift; shift

if [ -z "$DATABASE" ]; then
	echo "Usage: mysql-csv <database> <table> [fields] [extra parameters]"
	exit 1
fi

if [ -z "$TABLE" ]; then
	echo "Table name missing"
	exit 1
fi
	
if [ -z "$FIELDS" ]; then
	FIELDS="*"
fi

TMP=`mktemp -p /tmp -u mysql-csv.XXXXXX`

mysql "$DATABASE" -e "SELECT $FIELDS INTO OUTFILE '$TMP' FIELDS TERMINATED BY ',' ENCLOSED BY '\"' ESCAPED BY '\\\\' LINES TERMINATED BY '\n' FROM $TABLE" "$@"

cat "$TMP"
sudo rm "$TMP"
