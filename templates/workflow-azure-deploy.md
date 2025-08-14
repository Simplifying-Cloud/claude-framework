# Azure Deployment Workflow

## Quick Start Template

### 1. Architecture Design
```
Task: azure-cloud-architect "Design scalable Azure architecture with CAF compliance"
Task: security-specialist "Review security architecture"
```

### 2. Infrastructure as Code
```
Task: azure-cloud-architect "Generate Terraform/Bicep templates"
mcp__azure__bicepschema: Get resource schemas
mcp__azure__bestpractices: Get Azure best practices
```

### 3. Resource Deployment
```
mcp__azure__group: List resource groups
mcp__azure__subscription: Check subscription
Task: azure-deployment-specialist "Configure and deploy resources"
```

### 4. Monitoring Setup
```
mcp__azure__monitor: Configure monitoring
mcp__azure__workbooks: Create dashboards
Task: performance-auditor "Set up performance monitoring"
```

### 5. Security Configuration
```
mcp__azure__keyvault: Configure secrets
mcp__azure__role: Set up RBAC
Task: security-specialist "Audit security configuration"
```

## Parallel MCP Operations

Execute all Azure queries simultaneously:
```
- mcp__azure__subscription: list
- mcp__azure__group: list all
- mcp__azure__storage: list accounts
- mcp__azure__aks: list clusters
- mcp__azure__sql: list databases
- mcp__azure__keyvault: list vaults
```

## Best Practices
- Use azure-cloud-architect for design decisions
- Query all resources in parallel
- Follow CAF (Cloud Adoption Framework)
- Enable monitoring from the start
- Use Key Vault for all secrets