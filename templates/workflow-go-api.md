# Go API Development Workflow

## Quick Start Template

### 1. Initial Setup
```
Task: go-expert "Design REST API structure with authentication"
Task: framework-auditor "Validate project structure"
```

### 2. Implementation
```
Task: go-expert "Implement API endpoints with error handling"
Task: go-test-specialist "Create unit and integration tests"
Task: security-specialist "Review authentication and security"
```

### 3. Documentation
```
Task: documentation-maintainer "Generate API documentation"
Task: go-expert "Add OpenAPI/Swagger specs"
```

### 4. Testing & Validation
```
Bash: go test ./... -cover
Bash: go vet ./...
Bash: golangci-lint run
Task: test-automation-engineer "Create E2E test suite"
```

### 5. Performance
```
Task: performance-auditor "Analyze API performance"
Task: go-expert "Optimize critical paths"
```

### 6. Deployment Prep
```
Task: azure-deployment-specialist "Configure Docker and CI/CD"
Task: azure-cloud-architect "Design Azure deployment"
```

## Parallel Execution Example

Single message with all operations:
```
- Task: go-expert "Design API"
- Task: security-specialist "Security review"
- Task: documentation-maintainer "Update docs"
- Bash: go test ./...
- Bash: go build
- Read: README.md
- Glob: **/*.go
```

## Best Practices
- Always use go-expert for Go-specific tasks
- Run tests in parallel with implementation
- Use MultiEdit for refactoring
- Launch multiple agents concurrently