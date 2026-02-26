# Simple Web App

A minimal FastAPI-based web application, with a fully featured CI/CD pipeline using GitHub Actions, including linting, unit testing, coverage, Docker builds, and container vulnerability scanning.

---

## Table of Contents

- [Features](#features)
- [Application Endpoints](#application-endpoints)
- [Project Structure](#project-structure)
- [Development Environment](#development-environment)
- [Running the App Locally](#running-the-app-locally)
- [Testing](#testing)
- [CI/CD Workflow](#cicd-workflow)
- [Docker Setup](#docker-setup)
- [Trivy Vulnerability Scanning](#trivy-vulnerability-scanning)
- [Configuration Files](#configuration-files)

---

## 📐 Features

- FastAPI-based web application
- `/add?left=<int>&right=<int>` endpoint: returns the sum of two integers
- `/health` endpoint: simple health check
- Unit tests with **pytest** and **pytest-cov**
- Linting with **Ruff**
- Dockerized application with a slim image
- Optional Trivy vulnerability scanning
- GitHub Actions workflow with manual trigger and user inputs
- Workflow summary outputs for lint, test, and scan stages

---

## 🔱 Application Endpoints

| Endpoint | Method | Description | Example |
|----------|--------|------------|---------|
| `/add`   | GET    | Returns sum of two integers | `/add?left=5&right=2` → `{"sum":7}` |
| `/health`| GET    | Returns service status | `/health` → `{"status":"OK"}` |

---

## 📁 Project Structure

```text
.
├── app/                     # Application package
│   ├── __init__.py
│   └── main.py              # FastAPI entrypoint
├── tests/                   # Unit tests
│   └── test_add.py
├── requirements.txt         # Runtime dependencies
├── requirements-dev.txt     # Dev dependencies
├── Dockerfile               # Container build definition
├── pyproject.toml           # Project configuration
├── .github/
│   └── workflows/
│       └── ci.yml           # GitHub Actions pipeline
└── README.md
```

## 🚧 Development Environment

**Python version:** 3.13  

Create virtual environment:

```bash
python3.13 -m venv .venv
source .venv/bin/activate
pip install -r requirements-test.txt
pip install -r requirements-lint.txt
```

## ⚡ Running the App Locally

### Install runtime dependencies

```bash
pip install -r requirements.txt
```
Start the server
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000
```
Test endpoints
```bash
curl "http://127.0.0.1:8000/add?left=5&right=2"
curl "http://127.0.0.1:8000/health"
```
---

## ✅ Testing
### Run linting
```bash
ruff check .
````
### Run tests with coverage

```bash
pytest --cov=app --cov-report=term
```
What is tested:

* Positive values

* Negative values

* Health endpoint

Coverage results are displayed in the terminal and in the CI summary.

---

## 📜 CI/CD Workflow

The GitHub Actions workflow includes:

### Manual Trigger (`workflow_dispatch`)

User inputs:

- `left` (integer)
- `right` (integer)
- `run_lint` (boolean)
- `run_test` (boolean)
- `run_trivy` (boolean)

### Jobs

#### Lint (Ruff) - optional

- Static code analysis
- Results shown in workflow summary

#### Test (Pytest + Coverage) - optional

- Runs unit tests
- Coverage report displayed in summary

#### Docker Build

- Builds container image
- Creates container
- Runs `/health` check 
- Calls `/add` using workflow inputs

#### Trivy Scan - optional

- Scans built container image
- Adds vulnerability report to workflow summary
- Does not fail the build
---
## 🧰 Docker Setup

### Build Image

```bash
docker build -t simple-web-app:latest .
```
### Run Container
```bash
docker run -d -p 8000:8000 --name simple-web-app simple-web-app:latest
```
### Stop Container
```bash
docker stop simple-web-app
docker rm simple-web-app
```
---

## 🔎 Trivy Vulnerability Scanning

### Scan image locally

```bash
trivy image simple-web-app:latest
```
In CI, only HIGH and CRITICAL vulnerabilities are shown

Scan does not fail the build

Results appear in workflow summary


---

## 📋 Configuration Files


### `pyproject.toml`

- Ruff configuration (line length, Python version)
- Pytest configuration
- Project metadata
- setuptools build system

### `requirements.txt`

Runtime dependencies:

- fastapi
- uvicorn

### `requirements-test.txt`

Development dependencies:

- pytest
- pytest-cov
- ruff
- httpx

### `requirements-lint.txt`

Development dependencies:

- ruff

### `Dockerfile`

- Multi-stage build
- Slim Python base image
- Virtual environment
- Non root user
