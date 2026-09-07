from fastapi.testclient import TestClient
from app import app

client = TestClient(app)


def test_health():
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_tasks():
    response = client.get("/tasks")

    assert response.status_code == 200
    assert "tasks" in response.json()
    assert response.json()["tasks"][0]["title"] == "Learn Docker & CI/CD"
