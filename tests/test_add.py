from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_positive():
    response = client.get("/add?left=5&right=2")
    assert response.status_code == 200
    assert response.json() == {"sum": 7}

def test_negative():
    response = client.get("/add?left=-5&right=-2")
    assert response.status_code == 200
    assert response.json() == {"sum": -7}

def test_non_integer():
    response = client.get("/add?left=abc&right=5")
    assert response.status_code == 442

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "OK"}
