# Project-Specific Claude Configuration

## Project Overview
<!-- Provide a brief description of your project -->
**Project Name:** [Your Project Name]
**Type:** [Web App / API / CLI Tool / Library / etc.]
**Primary Language:** [Language]
**Framework:** [Framework if applicable]

## Project Structure
<!-- Describe the key directories and their purposes -->
```
project-root/
├── src/          # Source code
├── tests/        # Test files
├── docs/         # Documentation
└── scripts/      # Build and utility scripts
```

## Development Guidelines

### Code Style
<!-- Define project-specific code style preferences -->
- **Formatting:** [prettier/black/gofmt/etc.]
- **Linting:** [eslint/pylint/golangci-lint/etc.]
- **Naming Conventions:** 
  - Functions: [camelCase/snake_case/etc.]
  - Variables: [camelCase/snake_case/etc.]
  - Constants: [UPPER_SNAKE_CASE/etc.]

### Testing Requirements
<!-- Specify testing approach and requirements -->
- **Test Framework:** [jest/pytest/go test/etc.]
- **Coverage Target:** [80%/90%/etc.]
- **Test Commands:**
  - Unit tests: `npm test`
  - Integration tests: `npm run test:integration`
  - Coverage: `npm run test:coverage`

### Build and Deployment
<!-- Define build and deployment processes -->
- **Build Command:** `npm run build`
- **Lint Command:** `npm run lint`
- **Type Check:** `npm run typecheck`
- **Deploy Command:** `npm run deploy`

## Project-Specific Rules

### Do's
<!-- List what Claude should always do -->
- ✅ Run tests before marking tasks complete
- ✅ Follow existing code patterns
- ✅ Update documentation when changing APIs
- ✅ Use dependency injection for testability
- ✅ Add appropriate error handling

### Don'ts
<!-- List what Claude should never do -->
- ❌ Modify database schemas without explicit approval
- ❌ Commit directly to main branch
- ❌ Add new dependencies without justification
- ❌ Remove existing tests
- ❌ Expose sensitive configuration

## Dependencies and Libraries
<!-- List key dependencies and their purposes -->
- **Core Dependencies:**
  - [library]: [purpose]
  - [library]: [purpose]

## Environment Variables
<!-- Document required environment variables -->
- `DATABASE_URL`: PostgreSQL connection string
- `API_KEY`: External service API key
- `NODE_ENV`: Environment (development/production)

## Common Tasks

### Adding a New Feature
1. Create feature branch
2. Implement with tests
3. Update documentation
4. Run full test suite
5. Create pull request

### Debugging Issues
1. Check error logs in `logs/`
2. Run with debug flag: `DEBUG=* npm start`
3. Use debugger: `npm run debug`

### Database Operations
- Migration: `npm run db:migrate`
- Seed: `npm run db:seed`
- Reset: `npm run db:reset`

## External Services
<!-- List integrated external services -->
- **API:** [Service Name] - [Purpose]
- **Database:** [Type] - [Connection details]
- **Cache:** [Redis/Memcached] - [Configuration]

## Security Considerations
<!-- Project-specific security requirements -->
- Never log sensitive data
- Sanitize all user inputs
- Use parameterized queries
- Implement rate limiting
- Follow OWASP guidelines

## Performance Guidelines
<!-- Performance requirements and optimization strategies -->
- Target response time: < 200ms
- Database query optimization required
- Implement caching where appropriate
- Use pagination for large datasets

## Team Conventions
<!-- Team-specific agreements and conventions -->
- PR reviews required before merge
- Squash commits on merge
- Update CHANGELOG.md for releases
- Follow semantic versioning

## Known Issues and Workarounds
<!-- Document any known issues and their workarounds -->
- Issue: [Description]
  - Workaround: [Solution]

## Contact and Resources
<!-- Team contacts and helpful resources -->
- **Team Lead:** [Name/Email]
- **Documentation:** [URL]
- **CI/CD:** [URL]
- **Monitoring:** [URL]

---
*Last Updated: [Date]*
*Version: 1.0.0*