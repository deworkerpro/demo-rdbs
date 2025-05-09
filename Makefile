init: docker-down-clear docker-pull docker-build docker-up demo
up: docker-up
down: docker-down
restart: down up

docker-up:
	docker compose up -d

docker-down:
	docker compose down --remove-orphans

docker-down-clear:
	docker compose down -v --remove-orphans

docker-pull:
	docker compose pull

docker-build:
	docker compose build --pull

demo:
	docker compose run --rm client demo

.PHONY: client

client:
	docker compose run -it --rm client client

.PHONY: php

php:
	docker compose run --rm php php demo.php
