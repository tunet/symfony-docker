docker-up:
	docker compose up -d --build

docker-down:
	docker compose down

run-php:
	docker compose exec php zsh

install-symfony:
	symfony new . --version="6.3.*" --webapp

check-symfony:
	symfony book:check-requirements
