#!/bin/bash
set -eu

$("/tmp/set_db.env.sh")

DB_NAME="wordpress_db"
DATE=$(date +"%Y-%m-%d")

DAYS_TO_KEEP=5
BACKUP_DIR="$HOME/backup/$(date '+%Y%m%d')"
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$DATE.sql"
OLD_DATE=`date +%Y%m%d --date "5 days ago"`
OLD_DUMP=${BACKUP_DIR}/mysqldump.${OLD_DATE}.sql

LOG_FILE="/var/log/mysqldump.log"

mkdir -p "$BACKUP_DIR"

mysqldump -v --single-transaction --skip-lock-tables --default-character-set=utf8mb4 -h localhost -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" | gzip > ${BACKUP_DIR}/bk.$(date "+%Y%m%d").gz

rm -f ${OLD_DUMP}
echo "Backup of $DB_NAME completed and old backups deleted."