-- mod-version:3
local ptm = require 'plugins.ptm'

local content = [[
# Software Project Plan Template

_Short description_

---

## 1. Requirements Analysis

### 1.1 Functional Requirements

- [ ] Feature 1: _Short description_
- [ ] Feature 2: _Short description_
- [ ] Feature 3: _Short description_

### 1.2 Non-Functional Requirements

- [ ] Performance: _e.g., response time < 200ms_
- [ ] Scalability: _e.g., horizontal scaling support_
- [ ] Security: _e.g., OAuth2, data encryption_
- [ ] Compliance: _e.g., GDPR, SOC2_

### 1.3 Tools & Technologies

| Category        | Tool/Tech                  | Rationale                          |
|-----------------|----------------------------|------------------------------------|
| Frontend        | React / Vue / Svelte       | Fast dev cycle, community support  |
| Backend         | Node.js / Go / .NET        | Performance, ecosystem             |
| Database        | PostgreSQL / MongoDB       | ACID compliance / flexibility      |
| DevOps          | Docker / Kubernetes        | Containerization, orchestration    |
| CI/CD           | GitHub Actions / GitLab CI | Automation, integration            |

### 1.4 Workflow Enhancements

- [ ] Git branching strategy: `main`, `develop`, `feature/*`
- [ ] Code reviews via pull requests
- [ ] Automated testing pipeline
- [ ] Linting & formatting enforcement (e.g., Prettier, ESLint)

---

## 2. Dependencies

| Framework/Library | Purpose     | Version | License | External  |
|-------------------|-------------|---------|---------|-----------|
| Library A         | HTTP client | v1.5.0  | MIT     | yes       |
| Library B         | ?           | v1.5.0  | MIT     | no        |
| Framework C       | ?           | v1.5.0  | MIT     | yes       |
| Framework D       | ?           | v1.5.0  | MIT     | yes       |

---

## 3. Engineering Practices

- [ ] Test-Driven Development (TDD)
- [ ] Continuous Integration / Continuous Deployment (CI/CD)
- [ ] Infrastructure as Code (IaC)
- [ ] Monitoring & Observability (e.g., Prometheus, Grafana)
- [ ] Documentation-first approach (e.g., OpenAPI, README-driven dev)

---

## 4. Cost Estimation

### 4.1 Human Resources

| Role              | Estimated Hours | Hourly Rate | Total Cost |
|-------------------|-----------------|-------------|------------|
| Senior Developer  | 120             | €80         | €9,600     |
| DevOps Engineer   | 40              | €75         | €3,000     |
| QA Specialist     | 30              | €60         | €1,800     |

### 4.2 Infrastructure & Services

| Service           | Monthly Cost | Notes                        |
|-------------------|--------------|------------------------------|
| Cloud Hosting     | €150         | AWS/GCP/Azure                |
| CI/CD Pipeline    | €50          | GitHub Actions / GitLab CI   |
| Monitoring Tools  | €30          | Grafana Cloud / Datadog      |

---

## 5. Infrastructure Components

### 5.1 Environments

- [ ] Development
- [ ] Staging
- [ ] Production

### 5.2 Core Infrastructure

| Component         | Description                     |
|-------------------|---------------------------------|
| Load Balancer     | Distributes traffic             |
| API Gateway       | Centralized routing & auth      |
| Database Cluster  | High availability & backups     |
| Object Storage    | For media, logs, backups        |

### 5.3 Deployment Strategy

- [ ] Blue/Green Deployment
- [ ] Canary Releases
- [ ] Rollback Mechanism

---

## 6. Milestones & Timeline

| Milestone              | Target Date   | Status       | Owner    |
|------------------------|---------------|--------------|--------- |
| Requirements Finalized | YYYY-MM-DD    | Not Started  | Dev Team |
| MVP Delivery           | YYYY-MM-DD    | Not Started  | Dev Team |
| Production Launch      | YYYY-MM-DD    | Not Started  | Bus Team |

---

## 7. Documentation Checklist

- [ ] Architecture Overview
- [ ] API Reference
- [ ] Setup Instructions
- [ ] Troubleshooting Guide
- [ ] Onboarding Manual

---

## 8. Quality Gates

- [ ] 90%+ Unit/Integration Test Coverage (via JUnit + Mockito)
- [ ] Zero Critical Bugs in QA
- [ ] Performance Benchmarks Met (Lighthouse score > 90)
- [ ] Security Audit Passed

---

## 9. Risk Assessment

| Risk                | Likelihood | Impact | Mitigation Strategy         | Status |
|---------------------|------------|--------|-----------------------------|--------|
| Tech Debt           | Medium     | High   | Regular refactoring sprints | ?      |
| Vendor Lock-in      | Low        | Medium | Use open standards          | ?      |
| Scaling Bottlenecks | High       | High   | Load testing, autoscaling   | ?      |

---

## 10. Project Roles

| Name              | Role               | Responsibilities               |
|-------------------|--------------------|--------------------------------|
| Jane Doe          | Tech Lead          | Architecture, code quality     |
| John Smith        | Product Owner      | Requirements, stakeholder comm |
| Alice Johnson     | DevOps Engineer    | CI/CD, infrastructure          |

---

?
]]

ptm.add_template() {
  name = "(single)project-plan",
  desc = "A professional, minimal project plan.",
  files = {
    ["PLAN.md"] = {
      content = content,
      path = ""
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {}
}
