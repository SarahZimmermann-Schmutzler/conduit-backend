# Stage 1: Build the dependencies in an isolated environment
#base image (specific to the app's requirements)
FROM python:3.5-slim AS builder

WORKDIR /app

# Copy only the requirements file to install dependencies
COPY requirements.txt $WORKDIR

# Upgrade pip and install dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Stage 2: Copy application files into a lightweight image
FROM python:3.5-slim

WORKDIR /app

# Copy only the installed dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.5 /usr/local/lib/python3.5

# Copy the project files into the container
COPY . $WORKDIR

# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Expose the port for Gunicorn
EXPOSE 8000

# Use the entrypoint script to start the app
ENTRYPOINT ["/app/entrypoint.sh"]