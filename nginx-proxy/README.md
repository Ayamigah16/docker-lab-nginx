# Nginx Reverse Proxy

This directory contains the Nginx reverse proxy configuration to route traffic to the Flask backend application.

## Setup Instructions

### 1. Ensure Flask App is Running

First, make sure your Flask app is running:

```bash
cd /home/weirdo/dev/containers/docker-lab-nginx
docker-compose up -d
```

Verify it's running:
```bash
curl http://localhost:5000
```

### 2. Build the Nginx Proxy Image

```bash
cd nginx-proxy
docker build -t nginx-proxy .
```

### 3. Run the Nginx Proxy Container

```bash
docker run -d -p 8080:80 --name nginx-proxy nginx-proxy
```

### 4. Test the Reverse Proxy

Visit http://localhost:8080 in your browser or use curl:

```bash
curl http://localhost:8080
```

You should see the response from your Flask app: "Hello from Docker! Running in production mode."

## Using Docker Network (Recommended)

For better container communication, use a Docker network:

```bash
# Create a network
docker network create app-network

# Run Flask app on the network
docker run -d --name flask-app --network app-network -p 5000:5000 flask-app-secure

# Update nginx.conf to use container name instead of host.docker.internal
# Change proxy_pass to: http://flask-app:5000

# Run Nginx on the same network
docker run -d -p 8080:80 --name nginx-proxy --network app-network nginx-proxy
```

## Stopping and Cleaning Up

```bash
# Stop containers
docker stop nginx-proxy
docker stop flask-app-secure

# Remove containers
docker rm nginx-proxy
docker rm flask-app-secure

# Remove image (optional)
docker rmi nginx-proxy
```

## Configuration Details

The nginx.conf includes:
- Listening on port 80
- Proxying to Flask app on port 5000
- Standard proxy headers for proper request forwarding
