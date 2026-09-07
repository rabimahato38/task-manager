.PHONY: help build run test clean lint format docker-build docker-run docker-stop docker-compose-up docker-compose-down

help:
	@echo "Available commands:"
	@echo "  make build              - Install dependencies"
	@echo "  make run                - Run app locally (development)"
	@echo "  make test               - Run tests"
	@echo "  make lint               - Run code linting"
	@echo "  make format             - Format code with black"
	@echo "  make clean              - Remove cache and build files"
	@echo "  make docker-build       - Build Docker image"
	@echo "  make docker-run         - Run Docker container"
	@echo "  make docker-stop        - Stop Docker container"
	@echo "  make docker-compose-up  - Start app with docker-compose"
	@echo "  make docker-compose-down - Stop docker-compose services"
	@echo "  make full-test          - Run all checks (lint, format, test)"

build:
	pip install -r requirements.txt

run:
	uvicorn app:app --host 0.0.0.0 --port 8000 --reload

test:
	pytest -v --cov=. --cov-report=html

lint:
	flake8 app.py test_app.py --max-line-length=100
	mypy app.py

format:
	black app.py test_app.py
	isort app.py test_app.py

clean:
	rm -rf __pycache__ .pytest_cache .mypy_cache .coverage htmlcov *.pyc
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true

docker-build:
	docker build -t task-manager:latest .

docker-run: docker-build
	docker run -d --name task-manager-app -p 8000:8000 task-manager:latest

docker-stop:
	docker stop task-manager-app && docker rm task-manager-app || true

docker-compose-up:
	docker-compose up -d

docker-compose-down:
	docker-compose down

full-test: lint test
	@echo "✓ All checks passed!"
