# Cucumberjs typescript readme 

Sep 2025

> AI Assisted Readme 

```
# Sample End to End Tests Readme

A comprehensive end-to-end testing suite for B2C policies using Cucumber.js, Playwright, and TypeScript. This project tests various authentication flows and user journeys.

## Features

- **Cucumber BDD Testing** - Behavior-driven development with Gherkin scenarios
- **Playwright Integration** - Modern browser automation for reliable E2E tests
- **TypeScript Support** - Type-safe test development
- **Azure Integration** - Microsoft Graph API and Azure Identity support
- **Tagged Test Execution** - Run specific test suites with Cucumber tags
- **Environment Configuration** - Flexible configuration via environment variables

## Prerequisites

- Node.js 20+ 
- npm or yarn
- Modern browsers (Chrome, Firefox, Safari, Edge)

## Project Structure

```
e2e/
├── features/              # Cucumber features
├── src/
│   ├── steps/             # Step definition files (.ts)
│   ├── support/           # Test utilities and configuration
├── package.json
├── tsconfig.json
├── .env
└── README.md
```

## Installation

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd e2e
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Install Playwright browsers:**
   ```bash
   npx playwright install
   ```

4. **Set up environment variables:**
   ```bash
   touch .env
   # Edit .env with your configuration
   ```

## Environment Configuration

Create a `.env` file in the project root:

```env
HEADLESS="false"
TIMEOUT="900000"
IGNORE_HTTPS_ERRORS=""true"
DEFAULT_TTIMEOUT="900000"
HOMEPAGE="http://localhost:5000"
UTILS_CLIENT_SETTINGS__BASE_URL="http://localhost:50001"
UTILS_CLIENT_SETTINGS__TENANT_ID=""
UTILS_CLIENT_SETTINGS__CLIENT_ID=""
UTILS_CLIENT_SETTINGS__CLIENT_SECRET=""
UTILS_CLIENT_SETTINGS__EXTENSION_PREFIX=""
UTILS_CLIENT_SETTINGS__SCOPE=""
GRAPH_CLIENT_SETTINGS__BASE_URL=""
GRAPH_CLIENT_SETTINGS__TENANT_ID=""
GRAPH_CLIENT_SETTINGS__CLIENT_ID=""
GRAPH_CLIENT_SETTINGS__CLIENT_SECRET=""
GRAPH_CLIENT_SETTINGS__SCOPE="https://graph.microsoft.com/.default"
GRAPH_CLIENT_SETTINGS__ISSUER=""
```

## Available Test Scripts

### Run All Tests
```bash
npm run tests
```
Executes the complete end-to-end test suite.

### Development Tests
```bash
npm run dev
```
Runs tests tagged with `@dev` - typically used for tests under development.

### Link Account Tests
```bash
npm run link-account
```
Executes account linking functionality tests (tagged with `@link-account`).

### Link Error Tests
```bash
npm run link-account-errors
```
Tests error scenarios in account linking flow (tagged with `@link-account-errors`).

### Unlink Account Tests
```bash
npm run unlink-account
```
Tests account unlinking functionality (tagged with `@unlink-account`).

### Unlink Error Tests
```bash
npm run unlink-account-errors
```
Tests error scenarios in account unlinking flow (tagged with `@unlink-account-errors`).

## Test Tags

Tests are organized using Cucumber tags for flexible execution:

- `@dev` - Development/work-in-progress tests
- `@link-account` - Account linking happy path scenarios
- `@link-account-errors` - Account linking error scenarios
- `@unlink-account` - Account unlinking happy path scenarios
- `@unlink-account-errors` - Account unlinking error scenarios

### Running Custom Tag Combinations

```bash
# Run multiple tags
npx cucumber-js --require-module ts-node/register --require src/**/**/*.ts --tags "@link-account or @unlink-account"

# Exclude specific tags
npx cucumber-js --require-module ts-node/register --require src/**/**/*.ts --tags "not @dev"

# Complex tag expressions
npx cucumber-js --require-module ts-node/register --require src/**/**/*.ts --tags "@link-account and not @link-account-errors"
```

## Writing Tests

### Feature Files
Create `.feature` files in the `src/features/` directory:

```gherkin
@link-account
Feature: Account Linking
  As a user
  I want to view my account
  So that I can accessmy bill

  @dev
  Scenario: Successful account view
    Given I am on the login page
    When I enter valid credentials
    Then I should see account overview
```

### Step Definitions
Implement step definitions in TypeScript:

```typescript
import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';

Given('I am on the login page', async function () {
  await this.page.goto(process.env.BASE_URL + '/login');
});

When('I enter valid credentials', async function () {
  await this.page.fill('#username', process.env.USERNAME);
  await this.page.fill('#password', process.env.PASSWORD);
});
```

## Test Reports

Test results are automatically generated after each run. Reports include:

- **Console Output** - Real-time test execution status
- **Screenshots** - Configurable using Playwright
- **HTML Reports** - To be developed detailed test execution reports

## Debugging

### Running Tests in Debug Mode
```bash
# Run with browser visible
HEADLESS=false 

npm run dev

# Run single scenario
npx cucumber-js --require-module ts-node/register --require src/**/**/*.ts --name "Successful account linking"
```

### Run sms api
``` bash
docker run -e TWILIO_ACCOUNT_SID=<> -e TWILIO_AUTH_TOKEN=<> -e TWILIO_PHONE_NUMBER=<> -e PORT=3000 -p 3001:3000 sms-client
```

Access most recent sms within last minute
```
http://localhost:3001/sms/recent
```

### Common Issues

**TypeScript compilation errors:**
- Ensure `tsconfig.json` is properly configured
- Check import paths and type definitions

**Playwright browser issues:**
- Run `npx playwright install` to install browsers
- Check browser compatibility with your OS

**Azure authentication failures:**
- Verify Azure credentials in `.env` file
- Ensure proper permissions are set in Azure portal

## CI/CD Integration

### GitHub Actions Example
```yaml
name: E2E Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npm run tests
        env:
          AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
          AZURE_CLIENT_SECRET: ${{ secrets.AZURE_CLIENT_SECRET }}
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-test`
3. Write your tests following the existing patterns
4. Add appropriate tags to your scenarios
5. Test locally: `npm run dev`
6. Submit a pull request

## Dependencies

- **@cucumber/cucumber** - BDD testing framework
- **@playwright/test** - Browser automation
- **TypeScript** - Type-safe development
- **@azure/identity** - Azure authentication
- **@microsoft/microsoft-graph-client** - Microsoft Graph API integration
- **axios** - HTTP client for API testing
- **dotenv** - Environment variable management

## Support

For questions or issues:
1. Check the troubleshooting section above
2. Review existing GitHub issues
3. Create a new issue with detailed reproduction steps

### Updating generated-client 
generated-client interacts with api to create and delete accounts

Generate http clients 

Use docker to update generated-client 

```
docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli generate -i http://localhosost:5001/swagger/v1.0/swagger.json -g typescript-node -o /local/src/generated-client
```