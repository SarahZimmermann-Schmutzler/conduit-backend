#!/usr/bin/env bash

# Exit immediately if any command exits with a non-zero status
set -e

# Step 1: Collect static files
echo "collect static files..."
python manage.py collectstatic --noinput

# Step 2: Run database migrations
echo "Running database migrations..."
python manage.py makemigrations || { echo "Makemigrations failed"; exit 1; }
python manage.py migrate || { echo "Migration failed"; exit 1; }


# Step 3: Create a superuser
echo "Creating superuser..."
python manage.py createsuperuser --noinput \
  --email "$DJANGO_SUPERUSER_EMAIL" \
  --username "$DJANGO_SUPERUSER_USERNAME"


# Step 4: Check if Gunicorn is installed
echo "Checking for gunicorn..."
if ! command -v gunicorn &> /dev/null
then
    echo "Gunicorn not found. Installing..."
    pip install gunicorn
fi


# Step 5: Start the Django server using Gunicorn
echo "Starting the server with gunicorn..."
exec gunicorn conduit.wsgi:application --bind 0.0.0.0:8000