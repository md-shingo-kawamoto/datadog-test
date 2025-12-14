#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# データベースが起動するのを待つ
echo "Waiting for database..."
until mysql -h"$DB_HOST" -u"$DB_USERNAME" -p"$DB_PASSWORD" -e "SELECT 1" &>/dev/null; do
  sleep 1
done

echo "Database is ready!"

# データベースの作成とマイグレーション
# bundle exec rails db:prepare
bundle exec rails db:create
bundle exec rails db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

