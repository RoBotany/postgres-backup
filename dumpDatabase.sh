DUMP_FILE_NAME="pg_backup_`date +%Y-%m-%d-%H-%M`.dump"

# If product prefix is passed, use it to name dump file
if [ ! -z "$1" ]; then
  DUMP_FILE_NAME="$1_$DUMP_FILE_NAME"

  # Purge SPECIFIC backups older than PURGE_AFTER_DAYS if specified
  if [ ! -z "${PURGE_AFTER_DAYS}" ]; then
    echo "Deleting PostgreSQL backups for ${1} older than ${PURGE_AFTER_DAYS} days"
    NAME_MATCH="${1}_pg_backup_*.dump"
    find /pg_backup -name $NAME_MATCH -mtime +${PURGE_AFTER_DAYS} -exec rm {} \;
  fi
fi

cd pg_backup

echo "Creating dump: $DUMP_FILE_NAME"

# If POSTGRES_CONNECTION_URI is set, extract PGUSER, PGPASSWORD, PGHOST, PGPORT, PGDATABASE from it
#
# We expect POSTGRES_CONNECTION_URI in the following format:
#
# postgres://<USERNAME>:<PASSWORD>@<HOST>:<PORT>/<DATABASE>
#
if [ ! -z "${POSTGRES_CONNECTION_URI}" ]; then
  echo "POSTGRES_CONNECTION_URI is set; extracting PGUSER, PGPASSWORD, PGHOST, PGDATABASE from it"
  export PGUSER=$(echo $POSTGRES_CONNECTION_URI | cut -d: -f2 | sed 's#//##g')
  export PGPASSWORD=$(echo $POSTGRES_CONNECTION_URI | cut -d: -f3 | cut -d@ -f1)
  export PGHOST=$(echo $POSTGRES_CONNECTION_URI | cut -d: -f3 | cut -d@ -f2)
  export PGPORT=$(echo $POSTGRES_CONNECTION_URI | cut -d: -f4 | cut -d/ -f1)
  export PGDATABASE=$(echo $POSTGRES_CONNECTION_URI | cut -d: -f4 | cut -d/ -f2)
  echo "Extracted PGUSER=${PGUSER} from POSTGRES_CONNECTION_URI"
  echo "Extracted PGHOST=${PGHOST} from POSTGRES_CONNECTION_URI"
  echo "Extracted PGPORT=${PGPORT} from POSTGRES_CONNECTION_URI"
  echo "Extracted PGDATABASE=${PGDATABASE} from POSTGRES_CONNECTION_URI"
fi

# pg_dump should use value of PGPASSWORD for authentication automatically
pg_dump -C -w --format=c --blobs --username=$PGUSER --host=$PGHOST --port=$PGPORT --dbname=$PGDATABASE > $DUMP_FILE_NAME

if [ $? -ne 0 ]; then
  rm $DUMP_FILE_NAME
  echo "Back up not created, check db connection settings"
  exit 1
fi

echo 'Successfully Backed Up'
exit 0
