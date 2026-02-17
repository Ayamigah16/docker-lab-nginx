.PHONY: help build up down restart logs logs-flask logs-nginx test clean ps

help:
	@echo "Docker Lab Nginx - Available Make Commands"
	@echo "==========================================="
	@echo "  make build       - Build Docker images"
	@echo "  make up          - Start all services"
	@echo "  make down        - Stop all services"
	@echo "  make restart     - Restart all services"
	@echo "  make logs        - View logs from all services"
	@echo "  make logs-flask  - View Flask app logs"
	@echo "  make logs-nginx  - View Nginx proxy logs"
	@echo "  make test        - Run unit tests"
	@echo "  make ps          - Show running containers"
	@echo "  make clean       - Stop services and remove volumes"

build:
	@echo "Building Docker images..."
	docker-compose build

up:
	@echo "Starting services..."
	docker-compose up -d
	@echo "Services started! Access the app at http://localhost:8080"

down:
	@echo "Stopping services..."
	docker-compose down

restart: down up
	@echo "Services restarted!"

logs:
	docker-compose logs -f

logs-flask:
	docker-compose logs -f flask-app

logs-nginx:
	docker-compose logs -f nginx-proxy

test:
	@echo "Running unit tests..."
	docker-compose exec flask-app pytest app/tests/ -v

ps:
	docker-compose ps

clean:
	@echo "Stopping services and removing volumes..."
	docker-compose down -v
	@echo "Cleanup complete!"
