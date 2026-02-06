# Docker Lab - Production-Ready Flask Application

A secure, production-ready Flask application demonstrating Docker best practices and security hardening.

## 🔒 Security Features

### ✅ Implemented Best Practices

1. **Multi-Stage Builds**
   - Smaller final image size
   - Build dependencies not included in runtime
   - Uses Python virtual environment

2. **Optimized Layer Caching**
   - `requirements.txt` copied separately before application code
   - Dependencies installed only when requirements change
   - Faster rebuilds during development

3. **Non-Root User**
   - Container runs as `appuser` (not root)
   - Reduces attack surface
   - Follows principle of least privilege

4. **Read-Only Filesystem**
   - Root filesystem mounted as read-only
   - Only `/tmp` is writable (via tmpfs)
   - Prevents malicious file modifications

5. **Externalized Configuration**
   - No hardcoded values in code
   - Environment variables for all configuration
   - Easy to change per environment

6. **Additional Security**
   - `no-new-privileges` prevents privilege escalation
   - All Linux capabilities dropped
   - Minimal base image (`python:3.9-slim`)

## 📁 Project Structure

```
docker-lab/
├── app.py                 # Flask application with env var support
├── Dockerfile            # Multi-stage, secure Dockerfile
├── docker-compose.yml    # Compose file with security settings
├── requirements.txt      # Python dependencies
├── .env.example         # Example configuration file
├── .dockerignore        # Files to exclude from build
├── run-secure.sh        # Helper script for secure deployment
└── README.md           # This file
```

## 🚀 Quick Start

### Option 1: Using Docker Compose (Recommended)

```bash
docker-compose up -d
```

### Option 2: Using Helper Script

```bash
./run-secure.sh
```

### Option 3: Manual Docker Commands

```bash
# Build the image
docker build -t flask-app .

# Run with security hardening
docker run -d \
  --name flask-app-optimized \
  -p 5000:5000 \
  --read-only \
  --tmpfs /tmp:size=10M,mode=1777 \
  --security-opt=no-new-privileges:true \
  --cap-drop=ALL \
  -e ENVIRONMENT=production \
  -e DEBUG=false \
  flask-app
```

## ⚙️ Configuration

All configuration is externalized via environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `APP_HOST` | `0.0.0.0` | Host to bind the application |
| `APP_PORT` | `5000` | Port to run the application |
| `ENVIRONMENT` | `production` | Environment name |
| `DEBUG` | `false` | Enable Flask debug mode |

### Using .env File

```bash
# Copy example file
cp .env.example .env

# Edit as needed
vim .env

# Use with docker-compose
docker-compose up -d
```

### Override at Runtime

```bash
docker run -d \
  -p 5000:5000 \
  -e ENVIRONMENT=staging \
  -e DEBUG=true \
  flask-app
```

## 🧪 Testing

Test the application endpoints:

```bash
# Home endpoint
curl http://localhost:5000

# Health check endpoint
curl http://localhost:5000/health
```

Expected responses:
```
Hello from Docker! Running in production mode.
{"environment":"production","status":"healthy"}
```

## 🔍 Verify Security Features

```bash
# Verify read-only filesystem
docker inspect flask-app-optimized --format='ReadonlyRootfs: {{.HostConfig.ReadonlyRootfs}}'

# Verify non-root user
docker inspect flask-app-optimized --format='User: {{.Config.User}}'

# Verify security options
docker inspect flask-app-optimized --format='SecurityOpt: {{.HostConfig.SecurityOpt}}'

# Try to write to filesystem (should fail)
docker exec flask-app-optimized touch /test.txt
# Output: touch: cannot touch '/test.txt': Read-only file system
```

## 📋 Management Commands

```bash
# View logs
docker logs flask-app-optimized

# Follow logs
docker logs -f flask-app-optimized

# Stop container
docker stop flask-app-optimized

# Start stopped container
docker start flask-app-optimized

# Remove container
docker rm -f flask-app-optimized

# Check container status
docker ps | grep flask-app
```

## 🏗️ Dockerfile Features

### Multi-Stage Build

```dockerfile
# Stage 1: Builder - Install dependencies
FROM python:3.9-slim AS builder
# ... build steps ...

# Stage 2: Runtime - Lean production image
FROM python:3.9-slim
# ... copy from builder ...
```

### Layer Caching Optimization

```dockerfile
# Copy requirements first (changes rarely)
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy code last (changes frequently)
COPY . .
```

## 🎯 Best Practices Summary

- ✅ **Immutable Infrastructure**: Read-only filesystem
- ✅ **Least Privilege**: Non-root user
- ✅ **Defense in Depth**: Multiple security layers
- ✅ **Separation of Concerns**: Multi-stage builds
- ✅ **Configuration Management**: Externalized via env vars
- ✅ **Minimal Attack Surface**: Slim base image
- ✅ **Fast Builds**: Optimized layer caching
- ✅ **Ephemeral Storage**: tmpfs for temporary files

## 📚 Additional Resources

- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [OWASP Docker Security](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)

## 🤝 Contributing

Suggestions for additional security improvements are welcome!
