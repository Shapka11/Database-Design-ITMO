#!/bin/bash
set -e

FILE_NAME=$(basename "${1:-$CURRENT_MIGRATION}")

liquibase \
  --url="jdbc:postgresql://${POSTGRES_HOST}:5432/${POSTGRES_DB}_test?sslmode=disable" \
  --username="${POSTGRES_USER}" \
  --password="${POSTGRES_PASSWORD}" \
  --changelog-file="$FILE_NAME" \
  --search-path="/tmp/migrations" \
  update