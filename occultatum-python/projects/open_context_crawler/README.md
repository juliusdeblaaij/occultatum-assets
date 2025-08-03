# Open Context Crawler - Security Setup

## Environment Configuration

This project requires several environment variables to be set for secure operation.

### Setup Instructions

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and replace the placeholder values with your actual passwords:
   ```bash
   # Database Configuration
   POSTGRES_PASSWORD=your_secure_postgres_password
   OC_CRAWLER_PASSWORD=your_secure_oc_crawler_password
   AUTHENTICATOR_PASSWORD=your_secure_authenticator_password
   ```

3. Make sure to use strong, unique passwords for each service.

### Database Setup

The database initialization scripts now use environment variables instead of hardcoded passwords. Before running:

1. Ensure your `.env` file is properly configured
2. Source the environment variables or ensure they're available to your deployment system
3. Replace `${VARIABLE_NAME}` placeholders in SQL files with actual values during deployment

### Security Notes

- Never commit the `.env` file to version control
- Use different passwords for each environment (development, staging, production)
- Regularly rotate passwords
- Ensure database access is restricted to necessary hosts only
