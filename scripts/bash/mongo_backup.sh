# Set the date and time
DATE=$(date +"%Y%m%d")
TIME=$(date +"%H%M%S")

#!/bin/sh
export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`

DB_BACKUP_PATH='/root/backups'
MONGO_HOST='localhost'
MONGO_PORT='27017'

AUTH_ENABLED=1
MONGO_USER='admin'
MONGO_PASSWD='SOMEPASSWORD#321'
BACKUP_RETAIN_DAYS=14
BACKUP_DIR="/root/backups"

mkdir -p ${DB_BACKUP_PATH}/${TODAY}

AUTH_PARAM=""

if [ ${AUTH_ENABLED} -eq 1 ]; then
 AUTH_PARAM=" --username ${MONGO_USER} --password ${MONGO_PASSWD} "
fi

if [ ${DATABASE_NAMES} = "ALL" ]; then
 echo "You have choose to backup all databases"
 mongodump --host ${MONGO_HOST} --port ${MONGO_PORT} ${AUTH_PARAM} --out ${DB_BACKUP_PATH}/${TODAY}/
 /usr/bin/aws s3 sync /root/backups s3://SOMEBUCKET/somedirectory
else
 echo "Running backup for selected databases"
 for DB_NAME in ${DATABASE_NAMES}
 do
 mongodump --host ${MONGO_HOST} --port ${MONGO_PORT} --db ${DB_NAME} ${AUTH_PARAM} --out ${DB_BACKUP_PATH}/${TODAY}/
 done
fi

##REMOVALS
DBDELDATE=`date +"%d%b%Y" --date="${BACKUP_RETAIN_DAYS} days ago"`

if [ ! -z ${DB_BACKUP_PATH} ]; then
      cd ${DB_BACKUP_PATH}
      if [ ! -z ${DBDELDATE} ] && [ -d ${DBDELDATE} ]; then
            rm -rf ${DBDELDATE}
      fi
fi
