# MCP Server Configuration Requirements

## Azure MCP Server

To enable Azure MCP server, set these environment variables in your shell profile:

```bash
export AZURE_SUBSCRIPTION_ID="your-subscription-id"
export AZURE_TENANT_ID="your-tenant-id"
export AZURE_CLIENT_ID="your-client-id"
export AZURE_CLIENT_SECRET="your-client-secret"
```

Get these values from:
1. Azure Portal > Azure Active Directory > App registrations
2. Create new registration if needed
3. Add API permissions for Azure Management API
4. Create client secret under Certificates & secrets

## GitHub MCP Server

To enable GitHub MCP server, set:

```bash
export GITHUB_TOKEN="your-github-personal-access-token"
```

Create token at: https://github.com/settings/tokens
Required scopes: repo, workflow, read:org

## Verify Configuration

After setting environment variables, restart your shell and run:
```bash
env | grep -E "AZURE_|GITHUB_TOKEN"
```

