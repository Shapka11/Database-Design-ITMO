#!/bin/bash
set -e

until pg_isready -h "$POSTGRES_HOST" -p 5432 -U "$POSTGRES_USER"; do sleep 2; done

cp -r /liquibase/changelog /tmp/migrations
find /tmp/migrations -type f -name "*.sql" -exec sed -i "s/\${SEED_COUNT}/${SEED_COUNT:-1}/g" {} +

if [ $# -gt 0 ]; then
  echo "Executing custom Liquibase command: $@"
  exec liquibase \
    --url="jdbc:postgresql://$POSTGRES_HOST:5432/$POSTGRES_DB" \
    --username="$POSTGRES_USER" \
    --password="$POSTGRES_PASSWORD" \
    --changelog-file="changelog.xml" \
    --search-path="/tmp/migrations" \
    "$@"
fi

PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d postgres \
  -c "DROP DATABASE IF EXISTS ${POSTGRES_DB}_test;" \
  -c "CREATE DATABASE ${POSTGRES_DB}_test;"

echo "Running Seqwall..."

DATABASE_URL="postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:5432/${POSTGRES_DB}_test?sslmode=disable" \
seqwall staircase \
    --migrations-path="/tmp/migrations" \
    --upgrade="/scripts/ci-up-one.sh {current_migration}" \
    --downgrade="/scripts/ci-down-one.sh {current_migration}"

echo "Applying migrations to main database..."

if [ "${MIGRATION_VERSION}" = "latest" ]; then
  liquibase \
    --url="jdbc:postgresql://$POSTGRES_HOST:5432/$POSTGRES_DB" \
    --username="$POSTGRES_USER" \
    --password="$POSTGRES_PASSWORD" \
    --changelog-file="changelog.xml" \
    --search-path="/tmp/migrations" \
    update
else
  liquibase \
    --url="jdbc:postgresql://$POSTGRES_HOST:5432/$POSTGRES_DB" \
    --username="$POSTGRES_USER" \
    --password="$POSTGRES_PASSWORD" \
    --changelog-file="changelog.xml" \
    --search-path="/tmp/migrations" \
    update-count "${MIGRATION_VERSION}"
fi

echo "=== Ready! ==="