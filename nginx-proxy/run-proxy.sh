#!/bin/bash

# Nginx Reverse Proxy Run Script
# This script builds and runs the Nginx reverse proxy container

set -euo pipefail  # Exit on error, undefined variables, and pipe failures
IFS=$'\n\t'        # Set Internal Field Separator for safer iteration

# Configuration
readonly IMAGE_NAME="nginx-proxy"
readonly CONTAINER_NAME="nginx-proxy"
readonly HOST_PORT="8080"
readonly CONTAINER_PORT="80"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)/logs/nginx-proxy"
readonly LOG_FILE="${LOG_DIR}/nginx-proxy.log"

# Colors for output
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

# Logging functions
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >> "${LOG_FILE}"
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" >> "${LOG_FILE}"
    echo -e "${RED}Error: $*${NC}" >&2
}

log_success() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] SUCCESS: $*" >> "${LOG_FILE}"
    echo -e "${GREEN}✓ $*${NC}"
}

log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $*" >> "${LOG_FILE}"
}

# Cleanup function
cleanup() {
    local exit_code=$?
    if [[ ${exit_code} -ne 0 ]]; then
        log_error "Script failed with exit code: ${exit_code}"
        echo -e "${YELLOW}Check log file for details: ${LOG_FILE}${NC}"
    fi
}

trap cleanup EXIT

# Ensure log directory exists
mkdir -p "${LOG_DIR}"

# Initialize log file
log "=== Nginx Proxy Run Script Started ==="
log_info "Script directory: ${SCRIPT_DIR}"

echo -e "${GREEN}=== Nginx Reverse Proxy Setup ===${NC}"

# Check if Docker is running
log_info "Checking Docker availability..."
if ! docker info > /dev/null 2>&1; then
    log_error "Docker is not running"
    echo -e "${RED}Docker is not running. Please start Docker first.${NC}"
    exit 1
fi
log_success "Docker is available"
log_success "Docker is available"

# Stop and remove existing container if it exists
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    log_info "Found existing container, cleaning up..."
    if docker stop "${CONTAINER_NAME}" >> "${LOG_FILE}" 2>&1; then
        log_info "Container stopped"
    fi
    if docker rm "${CONTAINER_NAME}" >> "${LOG_FILE}" 2>&1; then
        log_info "Container removed"
    fi
    log_success "Cleaned up existing container"
fi

# Build the Docker image
log_info "Building Docker image: ${IMAGE_NAME}"
echo -e "${YELLOW}Building image...${NC}"
if docker build -t "${IMAGE_NAME}" . >> "${LOG_FILE}" 2>&1; then
    log_success "Image built: ${IMAGE_NAME}"
else
    log_error "Failed to build Docker image"
    exit 1
fi

# Run the container
log_info "Starting container: ${CONTAINER_NAME}"
echo -e "${YELLOW}Starting container...${NC}"
if docker run -d \
    --name "${CONTAINER_NAME}" \
    -p "${HOST_PORT}:${CONTAINER_PORT}" \
    --restart unless-stopped \
    "${IMAGE_NAME}" >> "${LOG_FILE}" 2>&1; then
    log_success "Container started: ${CONTAINER_NAME}"
else
    log_error "Failed to start container"
    exit 1
fi

# Wait for container to initialize
sleep 2

# Verify container is running
log_info "Verifying container status..."
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    log_error "Container is not running"
    echo -e "${RED}Container failed to start. Check logs: docker logs ${CONTAINER_NAME}${NC}"
    exit 1
fi
log_success "Container is running"

# Display status
echo ""
echo -e "${GREEN}=== Nginx Proxy is Running ===${NC}"
echo "  Port: http://localhost:${HOST_PORT}"
echo "  Status: docker ps | grep ${CONTAINER_NAME}"
echo "  Logs: docker logs -f ${CONTAINER_NAME}"
echo ""

# Test backend connectivity
log_info "Testing backend connectivity..."
if timeout 5 curl -sf "http://localhost:${HOST_PORT}" > /dev/null 2>&1; then
    log_success "Backend connection successful"
    echo -e "${GREEN}✓ Proxy routing to backend successfully${NC}"
else
    log_error "Cannot reach backend through proxy"
    echo -e "${YELLOW}⚠ Warning: Backend not reachable. Ensure Flask app is running on port 5000${NC}"
fi

log_info "Script completed successfully"
echo ""
