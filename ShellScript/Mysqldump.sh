#!/bin/bash

#エラー発生時に処理を止める
set -e

#環境変数にユーザー名とパスワードをセットする
source /home/menta/set_db_env.sh

# バックアップを保存するディレクトリ
 BACKUP_DIR="/path/to/backup/directory"
#
# # MySQLの設定
 DB_NAME="wordpress_db"

# # 日付形式 (YYYY-MM-DD)
 DATE=$(date +"%Y-%m-%d")

# # バックアップファイル名
 BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$DATE.sql"

# # 古いバックアップを削除するための日数 (例: 5日)
 DAYS_TO_KEEP=5

# # ディレクトリが存在しない場合は作成
 mkdir -p $BACKUP_DIR

# # MySQLデータベースのバックアップを作成
mysqldump --single-transaction --databases "$DB_NAME"  > $BACKUP_FILE
# # 古いバックアップを削除
OLD_DATE=`date +%Y%m%d --date "5 days ago"`
DUMP=${DIR}/mysqldump.${DATE}.sql
OLD_DUMP=${DIR}/mysqldump.${OLD_DATE}.sql

rm -f ${OLD_DUMP}


 


# # バックアップ完了メッセージ
 echo "Backup of $DB_NAME completed and old backups deleted."
