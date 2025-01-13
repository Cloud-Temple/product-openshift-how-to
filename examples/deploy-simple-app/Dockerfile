# Use the official Python image as a base
FROM python:3.10-slim


RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends postgresql-client \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /app
COPY app /app

# Set the working directory in the container
WORKDIR /app

# Install the Python dependencies
RUN pip install psycopg2-binary
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

RUN flask db upgrade

# Command to run the application with Gunicorn
# Using 1 workers and 2 threads here.
CMD [ "gunicorn", "--workers=1", "--threads=2", "--timeout=60", "--bind=0.0.0.0:8000", "--access-logfile=-", "--error-logfile=-", "--log-level=info", "app:app"]