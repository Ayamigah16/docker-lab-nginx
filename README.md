# Docker Lab - Nginx Reverse Proxy with Flask Backend

Production-ready containerized application demonstrating Docker best practices: Nginx reverse proxy, secure Flask backend, container networking, and centralized logging.

## 🎯 What's Inside

- **Flask Backend** (`/app`) - Secure Python application with multi-stage builds, non-root user, read-only filesystem
- **Nginx Proxy** (`/nginx-proxy`) - Reverse proxy routing traffic to backend with logging
- **Docker Network** - Containers communicate on isolated bridge network
- **Centralized Logs** - All logs in `/logs` directory (app and nginx)
- **Docker Compose** - Single-command orchestration of all services

## 📁 Structure

```
docker-lab-nginx/
├── app/                    # Flask backend application
│   ├── app.py             # Application code
│   ├── Dockerfile         # Multi-stage secure build
│   ├── run-secure.sh      # Helper script
│   └── README.md          # Detailed app docs
├── nginx-proxy/           # Nginx reverse proxy
│   ├── nginx.conf         # Proxy configuration
│   ├── Dockerfile         # Nginx image
│   ├── run-proxy.sh       # Helper script with logging
│   └── README.md          # Detailed proxy docs
├── logs/                  # Centralized logs (ignored by git)
│   ├── app/              # Flask logs
│   └── nginx-proxy/      # Nginx access/error logs
├── docker-compose.yml     # Service orchestration
└── README.md             # This file
```

## 🚀 Quick Start

### Using Docker Compose (Recommended)

```bash
# Start both services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Using Helper Scripts

```bash
# Start Flask app
cd app && ./run-secure.sh

# Start Nginx proxy
cd nginx-proxy && ./run-proxy.sh
```

## 🌐 Access

| Service | URL | Purpose |
|---------|-----|---------|
| **Nginx Proxy** | http://localhost:8080 | Main entry point (recommended) |
| **Flask Direct** | http://localhost:5000 | Direct backend access |
| **Health Check** | http://localhost:8080/health | Service health status |

## 🔒 Security Features

- Multi-stage Docker builds for minimal image size
- Non-root user execution
- Read-only root filesystem
- Resource limits (CPU/memory)
- No new privileges security option
- Environment-based configuration
- Alpine/slim base images

## 📋 Common Commands

```bash
# Restart services
docker-compose restart

# Rebuild and start
docker-compose up -d --build

# View container logs
docker-compose logs nginx-proxy
docker-compose logs flask-app

# Execute command in container
docker-compose exec flask-app sh

# Check logs directory
ls -lh logs/nginx-proxy/
ls -lh logs/app/
```

## 📖 Detailed Documentation

- **Flask App**: See [app/README.md](app/README.md) for application details, configuration, and deployment
- **Nginx Proxy**: See [nginx-proxy/README.md](nginx-proxy/README.md) for proxy configuration and networking

## 🛠️ Configuration

Environment variables (Flask app):
- `APP_HOST` - Bind address (default: 0.0.0.0)
- `APP_PORT` - Listen port (default: 5000)
- `ENVIRONMENT` - Environment name (default: production)
- `DEBUG` - Debug mode (default: false)

Edit `docker-compose.yml` to modify service configuration.

## 🧪 Testing

```bash
# Test proxy routing
curl http://localhost:8080

# Test health endpoint
curl http://localhost:8080/health

# Expected output
Hello from Docker! Running in production mode.
{"environment":"production","status":"healthy"}
```

## 📚 Learning Resources

- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Reverse Proxy Guide](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
