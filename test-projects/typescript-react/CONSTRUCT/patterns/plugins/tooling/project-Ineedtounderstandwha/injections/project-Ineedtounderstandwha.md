# Build & Development Workflow

## Build System Configuration
- Vite for fast development builds
- GitHub Actions for CI/CD
- Docker for containerized deployments
- Environment-specific configuration files

## Testing Framework Requirements
- Jest for unit testing
- React Testing Library for component testing
- Storybook for component documentation

## Code Quality Tools
- ESLint and Prettier for code formatting
- TypeScript strict mode enforcement

## Performance Build Standards
- Implement code splitting with React.lazy()
- Optimize bundle size with tree shaking
- Implement proper caching strategies

## Development Workflow Rules
✅ ALWAYS use TypeScript strict mode
✅ ALWAYS run ESLint and Prettier before commits
✅ ALWAYS implement proper testing with Jest and React Testing Library
✅ ALWAYS use Vite for development builds

❌ NEVER bypass TypeScript strict mode checks
❌ NEVER commit code without proper formatting
❌ NEVER deploy without running the full test suite
