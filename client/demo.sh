#!/bin/bash

set -o errexit
set -o pipefail

export PGPASSWORD="${POSTGRES_PASSWORD:?}"
psql --host="${POSTGRES_HOST:?}" --username="${POSTGRES_USER:?}" --dbname="${POSTGRES_DB:?}" < demo.sql
