# Stage 1: Builder stage
FROM python:3.9-slim AS builder

WORKDIR /app

# Copy only requirements first for better layer caching
COPY requirements.txt .

# Install dependencies to /opt/venv
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt


# Stage 2: Runtime stage
FROM python:3.9-slim

WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder /opt/venv /opt/venv

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Copy application code with correct ownership
COPY --chown=appuser:appuser . .

# Externalized configuration via environment variables
# These can be overridden at runtime
ENV APP_HOST=0.0.0.0 \
    APP_PORT=5000 \
    ENVIRONMENT=production \
    DEBUG=false \
    PYTHONUNBUFFERED=1

# Activate virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Switch to non-root user
USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
