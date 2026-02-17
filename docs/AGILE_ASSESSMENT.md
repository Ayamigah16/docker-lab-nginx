# AGILE & DEVOPS ASSESSMENT

**Docker Lab: Nginx Reverse Proxy with Flask Backend**

**Sprint 0 • Sprint 1 • Sprint 2**

**Date:** February 17, 2026

---

## Table of Contents

1. [Product Vision](#1-product-vision)
2. [Product Backlog](#2-product-backlog)
3. [Definition of Done (DoD)](#3-definition-of-done-dod)
4. [Sprint 0 Plan](#4-sprint-0-planning)
5. [Sprint 1 Plan & Execution](#5-sprint-1-execution)
6. [Sprint 2 Plan & Execution](#6-sprint-2-execution--improvement)
7. [CI/CD Pipeline Reference](#7-cicd-pipeline-reference)
8. [Final Deliverables Checklist](#8-final-deliverables-checklist)

---

## 1. Product Vision

### Vision Statement

**For** developers and DevOps engineers **who need** a reliable local development infrastructure, **this project delivers** a containerised Flask API behind an Nginx reverse proxy, orchestrated with Docker Compose, with full CI/CD automation and centralised logging — **so that** teams can develop, test, and deploy backend services with confidence and repeatability.

The emphasis of this assessment is not on the complexity of the product but on the **rigour and consistency** with which Agile and DevOps practices are applied throughout the delivery lifecycle.

---

## 2. Product Backlog

The backlog is ordered by business value and delivery dependency. Story points use Fibonacci sizing (1, 2, 3, 5, 8). Each story follows the format: **As a [role], I want [capability], so that [benefit].**

| ID | User Story | Acceptance Criteria | Priority | SP |
|----|------------|---------------------|----------|-----|
| **US-01** | As a developer, I want a Flask backend running in a Docker container, so that I can develop and test the API in an isolated environment. | Given the project is cloned, when I run `docker-compose up`, then the Flask app responds on port 5000 with a 200 OK at `/health`. | Must Have | 3 |
| **US-02** | As a developer, I want an Nginx reverse proxy routing traffic to the Flask backend, so that the service is accessible via a single standard port without exposing the app directly. | Given both containers are running, when I send a GET to `http://localhost:8080`, then Nginx proxies the request to Flask and returns the correct response. | Must Have | 3 |
| **US-03** | As a developer, I want a Docker Compose file that orchestrates both services on a shared bridge network, so that I can start the entire stack with one command. | Given `docker-compose.yml` is configured, when I run `docker-compose up -d`, then both services start, join `app-network`, and pass `docker-compose ps` health checks. | Must Have | 2 |
| **US-04** | As a DevOps engineer, I want a GitHub Actions CI pipeline that builds images, runs tests, and reports pass/fail on every push, so that broken changes are caught before merging. | Given a push to any branch, when the workflow triggers, then it builds both Docker images, runs unit tests, and posts a green or red status check on the PR. | Must Have | 5 |
| **US-05** | As a developer, I want automated unit tests for the Flask API endpoints, so that regressions are detected immediately in the pipeline. | Given the test suite exists, when the CI pipeline runs, then all tests execute and results appear in pipeline logs with at least `/health` and `/` routes covered. | Must Have | 3 |
| **US-06** | As an operations engineer, I want centralised log files written to a `/logs` directory, so that I can diagnose issues across both containers without exec-ing into each. | Given both containers are running, when traffic flows, then Flask logs write to `logs/app/` and Nginx logs write to `logs/nginx-proxy/` on the host. | Should Have | 2 |
| **US-07** | As an operations engineer, I want a `/health` endpoint that returns service status and version, so that external monitors and the CI pipeline can verify the service is alive. | Given the Flask app is running, when a GET `/health` request is made, then a 200 JSON response includes `{status, version, uptime_seconds, timestamp}` and responds within 200ms. | Should Have | 2 |
| **US-08** | As a security-conscious developer, I want Nginx configured with security response headers (X-Frame-Options, X-Content-Type-Options, X-XSS-Protection), so that the service meets baseline HTTP security standards. | Given the Nginx config is updated, when I inspect response headers via `curl -I`, then all three security headers are present on every response. | Could Have | 2 |
| **US-09** | As a developer, I want a Makefile with common commands (`make up`, `make down`, `make test`, `make logs`), so that I do not need to remember long Docker Compose commands. | Given the Makefile exists, when I run `make up`, then all services start; when I run `make test`, the test suite executes; when I run `make logs`, tailed logs stream to the terminal. | Could Have | 1 |
| **US-10** | As an operations engineer, I want log rotation configured for Nginx logs, so that disk space is not exhausted in long-running environments. | Given log rotation is configured, when the Nginx log exceeds the size limit, then it is rotated, compressed, and at most 7 rotated logs are retained. | Won't Have (this release) | 2 |

### Backlog Summary

| Priority Tier | Stories | Total Story Points |
|---------------|---------|-------------------|
| Must Have | US-01, US-02, US-03, US-04, US-05 | 16 |
| Should Have | US-06, US-07 | 4 |
| Could Have | US-08, US-09 | 3 |
| Won't Have (this release) | US-10 | 2 |

---

## 3. Definition of Done (DoD)

Every user story must satisfy **all** of the following criteria before it is considered Done. No exceptions. If any criterion is not met, the story is returned to the backlog for the next sprint.

### Code Quality
- Code is written, reviewed (self-reviewed if solo), and committed to a feature branch.
- No debug print statements left in production code paths.
- All new functions include at least one sentence of inline documentation.

### Testing
- At least one unit or integration test covers the acceptance criteria of the story.
- All existing tests continue to pass (no regressions introduced).
- Test results are visible in the CI pipeline run log.

### CI/CD Pipeline
- The GitHub Actions pipeline passes (green) on the feature branch before merging.
- The pipeline includes: build stage → test stage → integration stage.

### Documentation
- README.md is updated if the change affects setup, architecture, or commands.
- Acceptance criteria from the user story are verifiably met and noted in the sprint review.

### Deployment
- The full stack starts successfully with `docker-compose up -d`.
- Both containers show healthy status in `docker-compose ps`.
- No hard-coded secrets or credentials are committed to the repository.

### Review
- The story is demonstrated in the sprint review (screenshot, curl output, or short write-up).
- The story is accepted by the product owner as meeting the vision.

---

## 4. Sprint 0: Planning

### Sprint Goal
Establish a fully planned, estimated, and prioritised backlog and select the Sprint 1 stories, so that Sprint 1 can begin immediately with no ambiguity.

### Sprint 0 Tasks Completed
- ✅ Product vision defined and written
- ✅ 10 user stories created, refined with acceptance criteria
- ✅ Backlog estimated (Fibonacci) and prioritised (MoSCoW)
- ✅ Definition of Done established
- ✅ Git repository initialised; `.gitignore` configured
- ✅ Project directory structure created (`app/`, `nginx-proxy/`, `logs/`)
- ✅ Sprint 1 stories selected from Must Have tier
- ✅ Dev branch created for feature work

### Sprint 1 Selection
The following stories were selected for Sprint 1 based on foundational dependency order:

| Story ID | Title | Story Points | Rationale |
|----------|-------|--------------|-----------|
| US-01 | Flask backend in Docker | 3 | ✅ Already implemented — foundation for all other stories |
| US-02 | Nginx reverse proxy | 3 | ✅ Already implemented — core architecture |
| US-03 | Docker Compose orchestration | 2 | ✅ Already implemented — enables one-command startup |
| US-04 | GitHub Actions CI/CD | 5 | To be implemented — enables automated testing |
| US-05 | Flask unit tests | 3 | To be implemented — required by DoD |

**Sprint 1 Capacity:** 16 story points (8 already complete, 8 to be implemented)

---

## 5. Sprint 1: Execution

### Sprint Goal
Deliver a working, containerised Flask + Nginx stack with automated unit tests integrated into a basic CI pipeline.

**Duration:** 1 week (simulated)  
**Stories committed:** US-01, US-02, US-03, US-04, US-05

### 5.1 Sprint 1 Stories Delivered

#### US-01 — Flask Backend in Docker
**Status:** ✅ Done (Pre-existing)

- Flask app created with two routes: `GET /` and `GET /health`
- Dockerfile written using `python:3.11-slim` base image
- App structured in `app/` directory with `app.py`, `requirements.txt`, and `Dockerfile`
- Container starts and responds on port 5000

**Evidence:** `docker-compose up -d` followed by `curl http://localhost:5000/health` returns `{"status": "healthy", "environment": "production"}`.

---

#### US-02 — Nginx Reverse Proxy
**Status:** ✅ Done (Pre-existing)

- `nginx-proxy/` directory created with `nginx.conf` and `Dockerfile`
- Nginx configured to listen on port 8080 and `proxy_pass` to `http://flask-app:5000`
- Uses service name (`flask-app`) for DNS resolution within Docker bridge network
- Alpine-based Nginx image for minimal attack surface

**Evidence:** `curl http://localhost:8080/health` proxied correctly through Nginx to Flask.

---

#### US-03 — Docker Compose Orchestration
**Status:** ✅ Done (Pre-existing)

- `docker-compose.yml` defines `flask-app` and `nginx-proxy` services
- Both services connected to `app-network` bridge network
- `nginx-proxy` has `depends_on: flask-app` to enforce startup order
- Volume mounts configured: `logs/app` and `logs/nginx-proxy`
- `restart: unless-stopped` policy applied to both services

**Evidence:** `docker-compose up -d` starts both containers; `docker-compose ps` shows both as `Up`.

---

#### US-04 — GitHub Actions CI/CD
**Status:** 🔄 To be implemented in this sprint

**Acceptance Criteria:**
- Pipeline triggers on push to any branch and pull_request to main
- Builds both Docker images (Flask and Nginx)
- Runs unit tests inside Flask container
- Reports pass/fail status

---

#### US-05 — Flask Unit Tests
**Status:** 🔄 To be implemented in this sprint

**Acceptance Criteria:**
- Test file created: `app/tests/test_app.py` using pytest
- Tests cover: `GET /` returns 200, `GET /health` returns correct JSON, invalid route returns 404
- Tests run locally with pytest and in CI pipeline

---

### Sprint 1 Review
*To be completed after implementation*

---

### Sprint 1 Retrospective
*To be completed after implementation*

---

## 6. Sprint 2: Execution & Improvement

### Sprint Goal
Deliver production-grade monitoring, expanded test coverage, and structured logging; apply retrospective improvements from Sprint 1.

**Duration:** 1 week (simulated)  
**Stories committed:** US-06, US-07, US-08, US-09

### 6.1 Sprint 2 Stories

#### US-06 — Centralised Logging
**Status:** ✅ Done (Pre-existing)

- `logs/app/` directory receives Flask structured log output
- `logs/nginx-proxy/` receives Nginx access and error logs
- Volume mounts in `docker-compose.yml` bind both paths to the host
- `.gitignore` updated to exclude `logs/` from version control

---

#### US-07 — Enhanced Health Endpoint
**Status:** 🔄 To be enhanced in this sprint

**Current state:** Basic health endpoint returns `{status, environment}`  
**Required enhancement:** Add `version`, `uptime_seconds`, and `timestamp`

---

#### US-08 — Nginx Security Headers
**Status:** 🔄 To be implemented in this sprint

**Acceptance Criteria:**
- nginx.conf includes: `X-Frame-Options`, `X-Content-Type-Options`, `X-XSS-Protection`
- All headers visible in `curl -I http://localhost:8080`

---

#### US-09 — Makefile
**Status:** 🔄 To be implemented in this sprint

**Acceptance Criteria:**
- Makefile with targets: `up`, `down`, `restart`, `test`, `logs`, `clean`
- `make test` runs pytest inside Flask container

---

### Sprint 2 Review
*To be completed after implementation*

---

### Sprint 2 Retrospective
*To be completed after implementation*

---

## 7. CI/CD Pipeline Reference

**File:** `.github/workflows/main.yml`

The pipeline runs on push to all branches and on pull_request targeting main. It consists of three jobs: build, test, and integration.

```yaml
name: CI Pipeline
on: [push, pull_request]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Flask image
        run: docker build -t flask-app ./app
      - name: Build Nginx image
        run: docker build -t nginx-proxy ./nginx-proxy
      - name: Run unit tests
        run: |
          docker run --rm flask-app pytest app/tests/ -v
      - name: Integration test
        run: |
          docker compose up -d
          sleep 5
          curl --fail http://localhost:8080/health
          docker compose down
```

---

## 8. Final Deliverables Checklist

| Deliverable | Artifact / Location | Status |
|-------------|---------------------|--------|
| Backlog & Sprint Plans | This document, Sections 2-6 | ✅ Complete |
| Product Vision | Section 1 | ✅ Complete |
| User Stories with AC | Section 2 — 10 stories with full AC | ✅ Complete |
| Story Point Estimates | Section 2 — Fibonacci sizing applied | ✅ Complete |
| Definition of Done | Section 3 | ✅ Complete |
| Codebase / Git Repository | GitHub repo with feature branches | 🔄 In Progress |
| CI/CD Pipeline Config | `.github/workflows/main.yml` | 🔄 Sprint 1 |
| Test Files | `app/tests/test_app.py` | 🔄 Sprint 1 |
| Sprint Reviews & Retrospectives | Sections 5 & 6 | 🔄 After implementation |
| Monitoring / Logging | Centralised logs + enhanced health endpoint | 🔄 Sprint 2 |

---

**End of Document**
