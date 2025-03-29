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

## Team Setup Guide

### 1. Initial Setup for New Team Members

1. Create a GitHub account if you don't have one
2. Accept the collaboration invitation sent to your email
3. Install required software:
   - Git
   - Java JDK 11+
   - Maven 3.6+
   - MySQL 8.0+
   - Apache Tomcat 9.0+

### 2. First Time Repository Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/AccountingManagementSystem.git
cd AccountingManagementSystem

# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 3. Database Setup

```bash
# Create a MySQL database named 'accounting_db'
mysql -u root -p
CREATE DATABASE accounting_db;
```

### 4. Application Configuration

1. Copy `src/main/resources/application.properties.example` to `src/main/resources/application.properties`
2. Update the database credentials in `application.properties`

### 5. Build and Deploy

```bash
# Build the project
mvn clean install

# Deploy to Tomcat
# Copy the generated WAR file from target/ to Tomcat's webapps/ directory
# Start Tomcat server
```

## Development Workflow

### Daily Workflow

```bash
# Start new work
git checkout main
git pull origin main
git checkout -b feature/your-feature-name

# Make changes and commit
git add .
git commit -m "Your changes"
git push origin feature/your-feature-name

# Get latest changes
git checkout main
git pull origin main
git checkout feature/your-feature-name
git merge main
```

### Feature Branches

Available feature branches:
- feature/online-kiosk
- feature/priority-number
- feature/search-functionality
- feature/user-profile
- feature/admin-profile
- feature/notification-system
- feature/faq-navigation
- feature/accounting-checker

### Working on Features

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

4. Create a Pull Request on GitHub:
   - Go to repository
   - Click "Pull requests" tab
   - Click "New pull request"
   - Select your feature branch
   - Add description of changes
   - Create pull request

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

## Feature Details

### 1. Online KIOSK
- Allows users to select payment types
- Handles payment processing
- Provides payment confirmation

### 2. Priority Number Generator
- Generates queue numbers
- Shows current and next numbers
- Displays estimated wait times

### 3. Search Feature
- Search payment items
- Filter by category
- Sort by various criteria

### 4. User Profile Management
- Update personal information
- View transaction history
- Manage account settings

### 5. Admin Profile Management
- Handle priority numbers
- Process payments
- Manage point of sales
- Track transactions

### 6. Notification System
- Real-time queue updates
- Transaction notifications
- System alerts

### 7. FAQs Navigation
- Browse common questions
- Search for specific topics
- View transaction guides

### 8. Accounting Checker
- Validate external receipts
- Verify payment status
- Process external payments

## Troubleshooting

### Common Issues

1. **Git Authentication Issues**
   - Ensure you've accepted the collaboration invitation
   - Check your Git credentials
   - Use personal access token if needed

2. **Database Connection**
   - Verify MySQL is running
   - Check database credentials
   - Ensure database exists

3. **Build Failures**
   - Check Java version
   - Verify Maven installation
   - Clean and rebuild project

4. **Deployment Issues**
   - Check Tomcat logs
   - Verify WAR file location
   - Ensure proper permissions

## Team Guidelines

1. **Code Standards**
   - Follow Java coding conventions
   - Write clear commit messages
   - Document new features
   - Test before committing

2. **Git Workflow**
   - Create feature branches
   - Keep commits small
   - Pull before pushing
   - Use meaningful branch names

3. **Communication**
   - Update team on major changes
   - Report issues promptly
   - Share knowledge and solutions

## Team Members

- [Your Name] - Project Lead
- [Team Member 1] - Developer
- [Team Member 2] - Developer
- [Team Member 3] - Developer
- [Team Member 4] - Developer

## License

This project is licensed under the MIT License - see the LICENSE file for details.
