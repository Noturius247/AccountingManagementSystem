# Accounting Management System - User Guide

## Table of Contents
1. [Introduction](#introduction)
2. [System Requirements](#system-requirements)
3. [Getting Started](#getting-started)
4. [User Roles and Permissions](#user-roles-and-permissions)
5. [Features](#features)
6. [Troubleshooting](#troubleshooting)
7. [FAQs](#faqs)

## Introduction
The Accounting Management System is a comprehensive solution for managing financial transactions, queues, and user accounts. This guide will help you understand and use the system effectively.

## System Requirements
- Java 17 or higher
- MySQL 8.0 or higher
- Modern web browser (Chrome, Firefox, Edge)
- Minimum 4GB RAM
- 2GB free disk space

## Getting Started

### Installation
1. Clone the repository
2. Configure the database in `application.properties`
3. Run the application using Maven:
   ```bash
   mvn spring-boot:run
   ```

### First-Time Setup
1. Access the system at `http://localhost:8080`
2. Log in with default admin credentials:
   - Username: admin
   - Password: admin123
3. Change the default password immediately

## User Roles and Permissions

### Administrator
- Full system access
- User management
- System settings
- Reports generation

### Manager
- Queue management
- Transaction approval
- Basic reports
- User supervision

### User
- Basic transactions
- Queue operations
- Personal dashboard
- Document upload

## Features

### Dashboard
- Real-time statistics
- Recent transactions
- Queue status
- Notifications

### Transaction Management
1. Creating Transactions
   - Select transaction type
   - Enter amount
   - Add description
   - Attach documents

2. Viewing Transactions
   - Filter by date
   - Search by ID
   - Export to PDF

### Queue Management
1. Queue Operations
   - Generate queue number
   - Check position
   - Estimated wait time
   - Priority handling

2. Queue Status
   - Current position
   - Active counters
   - Processing time

### Document Management
1. Uploading Documents
   - Supported formats
   - Size limits
   - Naming conventions

2. Document Organization
   - Categories
   - Tags
   - Search functionality

## Troubleshooting

### Common Issues
1. Login Problems
   - Reset password
   - Check credentials
   - Clear browser cache

2. Transaction Errors
   - Check internet connection
   - Verify input data
   - Contact support

3. Queue Issues
   - Refresh page
   - Check system status
   - Contact manager

### Error Messages
- List of common error messages
- Solutions and workarounds
- Support contact information

## FAQs

### General Questions
Q: How do I reset my password?
A: Click "Forgot Password" on the login page and follow the instructions.

Q: Can I access the system from multiple devices?
A: Yes, but only one active session is allowed per user.

### Technical Questions
Q: What browsers are supported?
A: Chrome, Firefox, Edge (latest versions)

Q: Is there a mobile app?
A: Currently, the system is web-based only.

### Security Questions
Q: How is my data protected?
A: All data is encrypted and stored securely in the database.

Q: Can I export my data?
A: Yes, administrators can export data in various formats.

## Support
For additional support:
- Email: support@accounting-system.com
- Phone: +1 (555) 123-4567
- Hours: Monday-Friday, 9:00 AM - 5:00 PM EST 