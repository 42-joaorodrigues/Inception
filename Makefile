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
	docker compose -f $(COMPOSE_FILE) up -d --build

# Stop containers
down:
	docker compose -f $(COMPOSE_FILE) down

# Rebuild without cache
re: setup
	docker compose -f $(COMPOSE_FILE) build --no-cache
	docker compose -f $(COMPOSE_FILE) up -d

# Show logs (all services)
logs:
	docker compose -f $(COMPOSE_FILE) logs -f

# Show status
ps:
	docker compose -f $(COMPOSE_FILE) ps

# Clean: remove containers + volumes + images
clean:
	docker compose -f $(COMPOSE_FILE) down -v --rmi all --remove-orphans

# Reset everything (clean + rebuild + remove data)
fclean: clean
	docker system prune -af --volumes
	@sudo rm -rf $(DATA_DIR)
	@echo "All data removed from $(DATA_DIR)"

.PHONY: all setup up down re logs ps clean fclean
