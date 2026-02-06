# Flask Application

This is a simple Flask web application containerized with Docker.

## Features
- Flask web server
- Multi-stage Docker build for optimized image size
- Security best practices (non-root user, read-only filesystem)
- Health check endpoint
- Environment variable configuration

## Files
- `app.py` - Main Flask application
- `Dockerfile` - Multi-stage Docker build configuration
- `requirements.txt` - Python dependencies
- `run-secure.sh` - Security-focused startup script

## Running Locally

### Using Docker Compose (Recommended)
From the project root:
```bash
cd /home/weirdo/dev/containers/docker-lab-nginx
docker-compose up -d
```

### Manual Docker Build
```bash
cd app
docker build -t flask-app .
docker run -d -p 5000:5000 --name flask-app flask-app
```

## Endpoints
- `GET /` - Home page
- `GET /health` - Health check endpoint

## Environment Variables
- `APP_HOST` - Host to bind to (default: 0.0.0.0)
- `APP_PORT` - Port to listen on (default: 5000)
- `ENVIRONMENT` - Environment name (default: production)
- `DEBUG` - Enable debug mode (default: false)

## Testing
```bash
# Direct access
curl http://localhost:5000
curl http://localhost:5000/health

# Through Nginx proxy
curl http://localhost:8080
curl http://localhost:8080/health
```
