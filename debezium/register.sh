#!/bin/bash
set -e

CONNECT_URL="http://localhost:8083/connectors/postgres-connector/config"

echo "Ожидание запуска Kafka Connect (порт 8083)..."
until curl -s -o /dev/null -w "%{http_code}" http://localhost:8083/ | grep -q "200"; do
  sleep 2
done
echo "Kafka Connect готов к работе!"

echo "Отправка конфигурации Debezium коннектора..."

curl -i -X PUT \
  -H "Accept:application/json" \
  -H "Content-Type:application/json" \
  -d @connector.config.json \
  "$CONNECT_URL"

echo -e "\nЗапрос на регистрацию коннектора отправлен!"