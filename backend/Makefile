.PHONY: env-dev env-prod deploy-dev deploy-prod down-dev down-prod assets-dev assets-prod migrate-dev migrate-prod migrate-fresh-dev migrate-fresh-prod

env-dev:
	@test -f .env.dev || (echo "Error: .env.dev not found. Copy .env.example to .env.dev and configure it." && exit 1)
	cp .env.dev .env

env-prod:
	@test -f .env.prod || (echo "Error: .env.prod not found. Copy .env.example to .env.prod and configure it." && exit 1)
	cp .env.prod .env

deploy-dev: down-dev env-dev
	docker compose -f docker-compose.yml up -d --build
	$(MAKE) assets-dev

deploy-prod: down-prod env-prod
	docker compose -f docker-compose.prod.yml up -d --build
	$(MAKE) assets-prod

assets-dev:
	docker compose -f docker-compose.yml exec app npm install
	docker compose -f docker-compose.yml exec app npm run build

assets-prod:
	docker compose -f docker-compose.prod.yml exec app npm install
	docker compose -f docker-compose.prod.yml exec app npm run build

migrate-dev:
	docker compose -f docker-compose.yml exec app php artisan migrate

migrate-prod:
	docker compose -f docker-compose.prod.yml exec app php artisan migrate

migrate-fresh-dev:
	docker compose -f docker-compose.yml exec app php artisan migrate:fresh

migrate-fresh-prod:
	docker compose -f docker-compose.prod.yml exec app php artisan migrate:fresh

down-dev:
	docker compose -f docker-compose.yml down

down-prod:
	docker compose -f docker-compose.prod.yml down
