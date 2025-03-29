# Accounting Management System

A web-based accounting management system for handling school payments and transactions.

## Features

### 1. Payment Queue System
- Online KIOSK for payment selection
- Priority number generation and management
- Real-time queue status updates
- Estimated wait time display
- Payment type categorization

### 2. Search & Help System
- Advanced payment item search
- Category-based filtering
- FAQ navigation and search
- Transaction guides
- Help documentation

### 3. User Management System
- User profile management
- Admin profile management
- Role-based access control
- Account settings
- Security management

### 4. Transaction Management
- Payment processing
- Receipt validation
- Transaction history
- Point of sales management
- External payment verification

### 5. Notification System
- Real-time queue updates
- Transaction notifications
- System alerts
- Status updates
- Priority number announcements

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

### 1. Payment Queue System
- Integrated KIOSK and queue management
- Smart priority number generation
- Real-time queue status display
- Payment type selection interface
- Wait time estimation

### 2. Search & Help System
- Unified search interface for payments and FAQs
- Advanced filtering and sorting
- Category-based organization
- Interactive help guides
- Context-sensitive assistance

### 3. User Management System
- Unified user profile management
- Role-based access control
- Security settings
- Account preferences
- Activity tracking

### 4. Transaction Management
- Comprehensive payment processing
- Receipt validation system
- Transaction history tracking
- Point of sales interface
- External payment verification

### 5. Notification System
- Real-time updates
- Multi-channel notifications
- Priority announcements
- Transaction confirmations
- System status alerts

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
