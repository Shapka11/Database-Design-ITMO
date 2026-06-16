#!/bin/bash
set -e

FILE_NAME=$(basename "${1:-$CURRENT_MIGRATION}")

count=$(grep -i -c "^-- *changeset" "/tmp/migrations/$FILE_NAME" || echo 0)

if [ "$count" -gt 0 ]; then
  liquibase \
    --url="jdbc:postgresql://${POSTGRES_HOST}:5432/${POSTGRES_DB}_test?sslmode=disable" \
    --username="${POSTGRES_USER}" \
    --password="${POSTGRES_PASSWORD}" \
    --changelog-file="$FILE_NAME" \
    --search-path="/tmp/migrations" \
    rollback-count "$count"
fi