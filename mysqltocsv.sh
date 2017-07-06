#!/bin/bash
# Export a MySQL database table into CSV format
#
# Usage: mysqltocsv <host> <user> <pass> <database> <table> [fields] [header] [separator] [endline] [enclose] [escape] [endline];
#
# If fields is omitted '*' is assumed

HOST="$1"
USER="$2"
PASS="$3"
DATABASE="$4"
TABLE="$5"
FIELDS="$6"
HEADER="$7"
SEPARATOR="$8"
ENCLOSE="$9"
ESCAPE="$10"
ENDLINE="$11"
shift 11;

if [ -z "$HOST" ]; then
	echo "Usage: mysqltocsv  <host> <user> <pass> <database> <table> [fields] [header] [separator] [endline] [enclose] [escape] [endline]"
	exit 1
fi

if [ -z "$USER" ]; then
	echo "Usage: mysqltocsv <host> <user> <pass> <database> <table> [fields] [header] [separator] [endline] [enclose] [escape] [endline]"
	exit 1
fi

if [ -z "$PASSWORD" ]; then
	echo "Usage: mysqltocsv <host> <user> <pass> <database> <table> [fields] [header] [separator] [endline] [enclose] [escape] [endline]"
	exit 1
fi

if [ -z "$DATABASE" ]; then
	echo "Usage: mysqltocsv <host> <user> <pass> <database> <table> [fields] [header] [separator] [endline] [enclose] [escape] [endline]"
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

mysql "-h $HOST -u $USER -p $PASS" "$DATABASE" -e "$QUERY" "$@"

cat "$TMP"
rm "$TMP"

exit 0
