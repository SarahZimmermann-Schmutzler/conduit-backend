#!/usr/bin/env bash

# Exit immediately if any command exits with a non-zero status
set -e


# Step 1: Run database migrations
echo "Running database migrations..."
python manage.py makemigrations || { echo "Makemigrations failed"; exit 1; }
python manage.py migrate || { echo "Migration failed"; exit 1; }


# Step 2: Create a superuser
echo "Creating superuser..."
python manage.py createsuperuser --noinput \
  --email "$DJANGO_SUPERUSER_EMAIL" \
  --username "$DJANGO_SUPERUSER_USERNAME"


# Step 3: Start the Django server 
#echo "Starting the server..."
python manage.py runserver 0.0.0.0:8000