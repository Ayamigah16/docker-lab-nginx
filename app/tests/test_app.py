"""
Unit tests for Flask application

Tests cover:
- Home endpoint (/)
- Health endpoint (/health)
- Invalid routes (404 handling)
- Response status codes and content types
"""

import pytest
from app import app


@pytest.fixture
def client():
    """Create a test client for the Flask application"""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client


def test_home_endpoint_returns_200(client):
    """Test that the home endpoint returns HTTP 200"""
    response = client.get('/')
    assert response.status_code == 200


def test_home_endpoint_contains_expected_text(client):
    """Test that the home endpoint returns expected message"""
    response = client.get('/')
    assert b'Hello from Docker!' in response.data
    assert b'production' in response.data or b'development' in response.data


def test_health_endpoint_returns_200(client):
    """Test that the health endpoint returns HTTP 200"""
    response = client.get('/health')
    assert response.status_code == 200


def test_health_endpoint_returns_json(client):
    """Test that the health endpoint returns valid JSON"""
    response = client.get('/health')
    assert response.content_type == 'application/json'


def test_health_endpoint_has_required_fields(client):
    """Test that the health endpoint returns required fields"""
    response = client.get('/health')
    json_data = response.get_json()
    
    assert 'status' in json_data
    assert 'environment' in json_data
    assert json_data['status'] == 'healthy'


def test_invalid_route_returns_404(client):
    """Test that an invalid route returns HTTP 404"""
    response = client.get('/nonexistent')
    assert response.status_code == 404


def test_health_endpoint_response_time(client):
    """Test that health endpoint responds quickly"""
    import time
    start_time = time.time()
    response = client.get('/health')
    end_time = time.time()
    
    response_time_ms = (end_time - start_time) * 1000
    assert response.status_code == 200
    assert response_time_ms < 200  # Should respond in less than 200ms


def test_multiple_requests_to_home(client):
    """Test that multiple requests to home endpoint work correctly"""
    for _ in range(5):
        response = client.get('/')
        assert response.status_code == 200
