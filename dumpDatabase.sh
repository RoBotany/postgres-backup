DUMP_FILE_NAME="pg_backup_`date +%Y-%m-%d-%H-%M`.dump"

# If product prefix is passed, use it to name dump file
if [ ! -z "$1" ]; then
  DUMP_FILE_NAME="$1_$DUMP_FILE_NAME"
fi

echo "Creating dump: $DUMP_FILE_NAME"

cd pg_backup

pg_dump -C -w --format=c --blobs > $DUMP_FILE_NAME

if [ $? -ne 0 ]; then
  rm $DUMP_FILE_NAME
  echo "Back up not created, check db connection settings"
  exit 1
fi

echo 'Successfully Backed Up'
exit 0