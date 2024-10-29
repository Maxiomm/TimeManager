#!/bin/bash

set -e

echo "Starting entrypoint script..."

# Set the PGPASSWORD environment variable for PostgreSQL
export PGPASSWORD=$POSTGRES_PASSWORD 

# Wait until Postgres is ready
# echo "Waiting for PostgreSQL to be ready..."
# until pg_isready -q -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER; do
#   echo "$(date) - waiting for database to start"
#   sleep 2
# done
# echo "PostgreSQL is ready."

# Ensure dependencies are up to date
echo "Fetching dependencies..."
mix deps.get || { echo "Failed to fetch dependencies"; exit 1; }
echo "Compiling dependencies..."
mix deps.compile || { echo "Failed to compile dependencies"; exit 1; }

# Create database if it doesn't exist
echo "Checking if database exists..."
if ! psql -lqt -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER | cut -d \| -f 1 | grep -qw $POSTGRES_DB; then
  echo "Database $POSTGRES_DB does not exist. Creating..."
  mix ecto.create || { echo "Database creation failed"; exit 1; }
else
  echo "Database $POSTGRES_DB already exists."
fi

# Always run migrations
echo "Running migrations..."
mix ecto.migrate || { echo "Database migration failed"; exit 1; }

# Start Phoenix server
echo "Starting Phoenix server in $MIV_ENV environment..."
exec mix phx.server