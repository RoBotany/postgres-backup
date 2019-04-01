DUMP_FILE_NAME="pg_backup_`date +%Y-%m-%d-%H-%M`.dump"

# If product prefix is passed, use it to name dump file
if [ ! -z "$1" ]; then
  DUMP_FILE_NAME="$1_$DUMP_FILE_NAME"
fi

echo "Creating dump: $DUMP_FILE_NAME"

cd pg_backup

# If POSTGRES_CONNECTION_URI is set, use it; otherwise pg_dump will use PGHOST, PGDATABASE, PGUSER etc.
# https://stackoverflow.com/questions/29039437/how-to-use-pg-dump-with-a-connection-uri-url
if [ ! -z "${POSTGRES_CONNECTION_URI}" ]; then
  pg_dump -C -w --format=c --blobs $POSTGRES_CONNECTION_URI > $DUMP_FILE_NAME
else
  pg_dump -C -w --format=c --blobs > $DUMP_FILE_NAME
fi

if [ $? -ne 0 ]; then
  rm $DUMP_FILE_NAME
  echo "Back up not created, check db connection settings"
  exit 1
fi

echo 'Successfully Backed Up'
exit 0
