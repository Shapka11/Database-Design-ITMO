#!/bin/bash
set -e

mkdir -p /var/lib/postgresql/data_dir
chown -R postgres:postgres /var/lib/postgresql/data_dir
chmod 0700 /var/lib/postgresql/data_dir

exec gosu postgres patroni /etc/patroni/patroni.yaml