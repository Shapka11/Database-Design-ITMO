#!/bin/sh

MINIO_URL=${MINIO_URL:-"http://minio:9000"}
BACKUP_RETENTION_COUNT=${BACKUP_RETENTION_COUNT:-5}

echo "=== 1. Ожидаем доступности MinIO ==="
until curl -s http://minio:9000 > /dev/null; do
    echo "Ожидание запуска MinIO..."
    sleep 2
done
echo "MinIO запущен!"

echo "=== 2. Первичная настройка MinIO ==="
mc alias set root_minio "$MINIO_URL" "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"
mc mb root_minio/"$BUCKET_BACKUP_NAME" --ignore-existing

POLICY='{"Version":"2012-10-17","Statement":[{"Action":["s3:PutObject","s3:GetObject","s3:DeleteObject","s3:ListBucket"],"Effect":"Allow","Resource":["arn:aws:s3:::'$BUCKET_BACKUP_NAME'","arn:aws:s3:::'$BUCKET_BACKUP_NAME'/*"]}]}'
echo "$POLICY" > /tmp/policy.json

mc admin policy create root_minio backup_policy /tmp/policy.json
mc admin user add root_minio "$MINIO_BACKUP_USER" "$MINIO_BACKUP_PASSWORD"
mc admin policy attach root_minio backup_policy --user "$MINIO_BACKUP_USER"
mc alias set backup_minio "$MINIO_URL" "$MINIO_BACKUP_USER" "$MINIO_BACKUP_PASSWORD"


echo "=== 3. Генерация скрипта для Cron ==="
cat << 'EOF' > /do_backup.sh
#!/bin/sh
FILE_NAME="backup_$(date +%s).sql"
TEMP_FILE="/tmp/$FILE_NAME"

PGPASSWORD="$POSTGRES_PASSWORD" pg_dump -h haproxy -p 5432 -U "$POSTGRES_USER" -d "$POSTGRES_DB" > "$TEMP_FILE"

mc cp "$TEMP_FILE" backup_minio/"$BUCKET_BACKUP_NAME"/

mc ls backup_minio/"$BUCKET_BACKUP_NAME"/ | awk '{print $NF}' | grep 'backup_' | sort -r | tail -n +"$((BACKUP_RETENTION_COUNT + 1))" | while read -r f; do
    mc rm backup_minio/"$BUCKET_BACKUP_NAME"/"$f"
done

echo "backup_last_time_seconds $(date +%s)" > /var/www/metrics
echo "backup_size_bytes $(stat -c%s "$TEMP_FILE")" >> /var/www/metrics

rm -f "$TEMP_FILE"
echo "[Бэкап завершен успешно]"
EOF

chmod +x /do_backup.sh

echo "=== 4. Настройка расписания (Cron) ==="
echo "$BACKUP_INTERVAL /do_backup.sh" > /etc/crontabs/root
crond -b -l 2

echo "=== 5. Запуск экспортера метрик ==="
mkdir -p /var/www
printf "backup_last_time_seconds 0\nbackup_size_bytes 0\n" > /var/www/metrics

echo "Запуск веб-сервера на порту 8080..."
exec httpd -f -p 8080 -h /var/www