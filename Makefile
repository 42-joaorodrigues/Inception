# ========================
# Inception Makefile
# ========================

COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = /home/joao-alm/data

# Default target
all: up

# Create data directories
setup:
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress
	@echo "Data directories created at $(DATA_DIR)"

# Build images and start containers
up: setup
	cd srcs && docker compose up -d --build

# Stop containers
down:
	cd srcs && docker compose down

# Clean everything (containers, volumes, images)
clean: down
	docker system prune -af
	docker volume prune -f
	@sudo rm -rf $(DATA_DIR)

# Rebuild without cache
re: clean setup
	cd srcs && docker compose build --no-cache
	cd srcs && docker compose up -d

# Show logs (all services)
logs:
	cd srcs && docker compose logs

# Show status
status:
	cd srcs && docker compose ps

.PHONY: all setup up down clean re logs status
