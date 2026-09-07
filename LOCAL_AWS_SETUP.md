---
# Local Development Guide

## Quick Start (Local Development)

### Option 1: Using Make (Recommended)
```bash
# Install dependencies
make build

# Run app locally (with hot reload)
make run

# Run tests
make test

# Full testing pipeline (lint + test)
make full-test
```

### Option 2: Using Docker Compose
```bash
# Start app with docker-compose
make docker-compose-up

# View logs
docker-compose logs -f app

# Stop services
make docker-compose-down
```

### Option 3: Manual Setup
```bash
pip install -r requirements.txt
uvicorn app:app --reload
```

## Docker Testing (Local)

### Build Docker Image
```bash
make docker-build
# or
docker build -t task-manager:latest .
```

### Run Docker Container
```bash
docker run -d -p 8000:8000 --name task-manager task-manager:latest

# Test health endpoint
curl http://localhost:8000/health

# View logs
docker logs task-manager

# Stop container
docker stop task-manager
```

## Running Tests

### Unit Tests
```bash
pytest
pytest -v  # verbose
pytest --cov=.  # with coverage
pytest --cov=. --cov-report=html  # HTML report
```

### Code Quality Checks
```bash
# Linting
flake8 app.py test_app.py

# Type checking
mypy app.py

# Code formatting
black app.py test_app.py

# Import sorting
isort app.py test_app.py
```

## CI/CD Workflow

### GitHub Actions (Local Testing)
The workflow runs automatically on:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches

### Manual Workflow Testing (Optional)
To test GitHub Actions locally, you can use `act`:
```bash
# Install act
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | bash

# Run workflow
act push -b -j test
```

## AWS Deployment (Next Steps)

### 1. Set GitHub Secrets
In GitHub repo → Settings → Secrets and variables → Actions:
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
- `AWS_ACCESS_KEY_ID` (for AWS deployment)
- `AWS_SECRET_ACCESS_KEY` (for AWS deployment)
- `AWS_REGION` (e.g., us-east-1)

### 2. Create AWS Resources
```bash
# Create ECR repository
aws ecr create-repository --repository-name task-manager

# Create ECS cluster (if using ECS)
aws ecs create-cluster --cluster-name task-manager-cluster
```

### 3. Push to Main Branch
Once AWS credentials are added to GitHub secrets, pushing to main will:
1. Run tests
2. Build Docker image
3. Push to Docker Hub
4. Push to AWS ECR
5. (Optional) Deploy to ECS

## Environment Configuration

### Local Development
Copy and edit `.env.example`:
```bash
cp .env.example .env
# Edit .env with your local settings
```

### Production (AWS)
Environment variables are set via:
- AWS ECS task definition
- AWS Systems Manager Parameter Store
- AWS Secrets Manager

## Troubleshooting

### Docker Build Issues
```bash
# Clean up
docker system prune -a

# Rebuild without cache
docker build --no-cache -t task-manager:latest .
```

### Port Already in Use
```bash
# Find process using port 8000
lsof -i :8000

# Kill process
kill -9 <PID>
```

### Tests Failing
```bash
# Install dev dependencies
pip install -r requirements-dev.txt

# Run with verbose output
pytest -vv --tb=long
```

## Next Steps

1. ✅ Test locally with `make docker-compose-up`
2. ✅ Verify tests pass with `make full-test`
3. ✅ Commit and push to test GitHub Actions
4. ✅ Add AWS secrets to GitHub
5. ✅ Create AWS ECR repository
6. ✅ Test AWS deployment on main branch push
