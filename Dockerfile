# base image (specific to the app's requirements)
FROM python:3.5-slim

# Set the working directory inside the container
WORKDIR /app

# Copy all project files into the container
COPY . $WORKDIR

# Upgrade pip to the latest version and install the required Python packages from requirements.txt
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Expose port 8000, which will be used by the Gunicorn server
EXPOSE 8000

# Set the entrypoint script for the container
ENTRYPOINT ["/app/entrypoint.sh"]