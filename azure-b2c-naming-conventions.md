# Azure B2c Naming Conventions

Mar 2023

> Quick azure naming conventions to keep custom policies easy to read an understandable.

## User Journey Naming Convention

Organize all journeys using a consistent naming pattern where sub-journeys include the core journey name as a prefix.

### Example Structure:
- **CoreSubJourneyName**: The main user process
- **CoreSubJourneyName-SubJourneyName**: Specific components of the main process

### Password Reset Example:
- **PasswordReset**: The primary journey
- **PasswordReset-LoadUser**: Sub-journey for loading user data
- **PasswordReset-Block**: Sub-journey for handling accounts not enabled

### Benefits of Approach

1. Creates clear hierarchical relationships
2. Makes related journeys easily identifiable in lists
3. Simplifies filtering and searching in documentation
4. Provides immediate context about a journey's purpose
5. Ensures consistent naming across teams and systems

## Technical Profile Naming Convention

Organize all technical profiles using a consistent naming pattern where profiles include the context as a suffix.

### Example Structure:
- **TechnicalProfile-Context**: Naming pattern for all technical profiles

### Azure B2C Technical Profile Examples:
- **SocialLogin-Facebook**: Technical profile for Facebook login
- **SocialLogin-Google**: Technical profile for Google login
- **ConfirmationPage-EmailUpdated**: ConfirmationPage technical profile for email update
- **ConfirmationPage-PasswordUpdated**: ConfirmationPage technical profile for password update
- **ConfirmationPage-PasswordUpdated-Merge**: Merge flow ConfirmationPage technical profile for password update

### Benefits of Approach

1. Creates clear categorization by technical profile type
2. Groups similar technical profiles together in policy files
3. Makes profiles easily identifiable by their function
4. Provides immediate context about a profile's purpose
5. Ensures consistent naming across custom policies
6. Simplifies searching and navigation in large policy files