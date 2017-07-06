#!/bin/bash
# Export a MySQL database table into CSV format
#
# Usage: mysqltocsv <config> <database> <table> [fields] [header] [separator] [endline] [enclose] [escape] [endline];
#
# If fields is omitted '*' is assumed

CONFIG="$1"
DATABASE="$2"
TABLE="$3"
FIELDS="$4"
HEADER="$5"
SEPARATOR="$6"
ENCLOSE="$7"
ESCAPE="$8"
ENDLINE="$9"
shift 9;

if [ -z "$CONFIG" ]; then
	echo "Usage: mysqltocsv <config> <database> <table> [fields] [header] [separator] [endline] [enclose] [escape] [endline]"
	exit 1
fi

if [ -z "$DATABASE" ]; then
	echo "Usage: mysqltocsv <config> <database> <table> [fields] [header] [separator] [endline] [enclose] [escape] [endline]"
	exit 1
fi

if [ -z "$TABLE" ]; then
	echo "Table name missing"
	exit 1
fi

if [ -z "$FIELDS" ]; then
	FIELDS="*"
fi

if [ -z "$SEPARATOR" ]; then
	SEPARATOR=";"
fi

if [ -z "$ENDLINE" ]; then
	ENDLINE="\r\n"
fi

if [ -z "$ENCLOSE" ]; then
	ENCLOSE="\""
fi

if [ -z "$ESCAPE" ]; then
	ESCAPE="\\\\"
fi

TMP=`mktemp -p /tmp -u mysql-csv.XXXXXX`

QUERY="SELECT $FIELDS INTO OUTFILE '$TMP' FIELDS TERMINATED BY '$SEPARATOR' ENCLOSED BY '$ENCLOSE' ESCAPED BY '$ESCAPE' LINES TERMINATED BY '$ENDLINE' FROM $TABLE"

if [ -n "$HEADER" ]; then
    QUERY="(SELECT $HEADER) UNION (${QUERY})"
fi

mysql --login-path="$CONFIG" "$DATABASE" -e "$QUERY "$@"

cat "$TMP"
sudo rm "$TMP"

exit 0
