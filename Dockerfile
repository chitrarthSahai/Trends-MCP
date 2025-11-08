# Use Python 3.11 slim image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies if needed
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY src/ ./src/

# Expose the port
EXPOSE 8999

# Set the command to run fastmcp
# --host should bind to 0.0.0.0 to accept connections from ingress controller
# The external URL is handled by Azure Container Apps ingress
CMD ["fastmcp", "run", "src/server.py", "--transport", "streamable-http", "--port", "8999", "--host", "0.0.0.0"]

