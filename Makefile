.PHONY: help install test run docker-build docker-run docker-stop

help:
	@echo "Available commands:"
	@echo "  make install          - Install app + test dependencies"
	@echo "  make test             - Run tests"
	@echo "  make run              - Run app locally"
	@echo "  make docker-build     - Build Docker image"
	@echo "  make docker-run       - Run container"
	@echo "  make docker-stop      - Stop container"

install:
	python3 -m pip install --upgrade pip
	python3 -m pip install -r requirements.txt -r requirements-dev.txt

test: install
	python3 -m pytest -q --maxfail=1 --disable-warnings

run:
	python3 -m uvicorn app:app --host 0.0.0.0 --port 8000 --reload

docker-build:
	docker build -t task-manager:latest .

docker-run: docker-build
	docker run --rm -d --name task-manager -p 8000:8000 task-manager:latest

docker-stop:
	docker rm -f task-manager || true
