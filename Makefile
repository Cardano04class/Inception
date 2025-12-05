COMPOSE=docker-compose -f srcs/docker-compose.yml


all: build up


build:
$(COMPOSE) build --no-cache


up: build
$(COMPOSE) up -d


down:
$(COMPOSE) down


logs:
$(COMPOSE) logs -f


clean: down
docker system prune -af --volumes


re: clean all


.PHONY: all build up down logs clean re