#!/bin/bash

find /data/db -type f -name "*.gz" -mtime +35 -delete

BASE_FILENAME="prd-$(date +%Y%m%d).sql"
FILENAME="/data/db/${BASE_FILENAME}"

echo "Extracting Prod DB to ${FILENAME} ..."
export PGPASSWORD=something
time pg_dump -h proddb.something.com -U postgres -C postgres -f ${FILENAME}
pg_exit_code="$?"

if [[ "${pg_exit_code}" -ne '0' ]]; then
  echo "Subject:DATABASE BACKUP FAILURE"|/usr/sbin/sendmail dash@somewhere.com
fi

echo "Compressing ${FILENAME} ..."
time gzip ${FILENAME}

echo "Copying ${FILENAME}.gz to S3 ..."
/usr/local/bin/aws s3 sync /data/db/ s3://backup-data/pg_dump/
