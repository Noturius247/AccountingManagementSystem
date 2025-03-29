# Accounting Management System

A web-based accounting management system for handling school payments and transactions.

## Features

- Online KIOSK for payment selection
- Priority Number Generator for queue management
- Search functionality for payment items
- User Profile Management
- Accounting Admin Profile Management
- Notification System
- FAQs Navigation
- Accounting Checker for receipt validation

## Prerequisites

- Java JDK 11 or higher
- Maven 3.6 or higher
- Git
- MySQL 8.0 or higher
- Apache Tomcat 9.0 or higher

## Setup Instructions

1. Clone the repository:
```bash
git clone https://github.com/yourusername/AccountingManagementSystem.git
cd AccountingManagementSystem
```

2. Set up the database:
```bash
# Create a MySQL database named 'accounting_db'
mysql -u root -p
CREATE DATABASE accounting_db;
```

3. Configure the application:
   - Copy `src/main/resources/application.properties.example` to `src/main/resources/application.properties`
   - Update the database credentials in `application.properties`

4. Build the project:
```bash
mvn clean install
```

5. Deploy to Tomcat:
   - Copy the generated WAR file from `target/` to Tomcat's `webapps/` directory
   - Start Tomcat server

## Project Structure

```
AccountingManagementSystem/
├── src/
│   ├── main/
│   │   ├── java/
│   │   ├── resources/
│   │   └── webapp/
│   └── test/
├── WebContent/
│   ├── css/
│   ├── js/
│   └── jsp/
└── pom.xml
```

## Development Workflow

1. Create a new branch for your feature:
```bash
git checkout -b feature/your-feature-name
```

2. Make your changes and commit them:
```bash
git add .
git commit -m "Description of your changes"
```

3. Push your changes:
```bash
git push origin feature/your-feature-name
```

4. Create a Pull Request on GitHub

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Team Members

- [Your Name] - Project Lead
- [Team Member 1] - Developer
- [Team Member 2] - Developer
- [Team Member 3] - Developer
- [Team Member 4] - Developer

## License

This project is licensed under the MIT License - see the LICENSE file for details.
