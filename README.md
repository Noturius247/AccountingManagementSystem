# Accounting Management System

A comprehensive school accounting system with role-based access control, transaction management, and kiosk integration.

## System Requirements

- Java 17 or higher
- Maven
- MySQL 8.0 or higher
- Spring Boot 3.x

## Installation

1. Clone the repository:
```bash
git clone [repository-url]
```

2. Configure the database:
- Create a MySQL database named `accounting_system`
- Update `application.properties` with your database credentials:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/accounting_system
spring.datasource.username=your_username
spring.datasource.password=your_password
```

3. Build the project:
```bash
mvn clean install
```

4. Run the application:
```bash
mvn spring-boot:run
```

## Login Information

The system comes with pre-configured users for testing:

### Admin Access
- **Username**: admin
- **Password**: password
- **Email**: admin@school.edu
- **Features**: Full system access, user management, transaction oversight

### Manager Access
- **Username**: manager1
- **Password**: password
- **Email**: manager1@school.edu
- **Features**: Kiosk management, transaction processing, queue monitoring

### Student Access
- **Username**: student1
- **Password**: password
- **Email**: student1@school.edu
- **Features**: View transactions, make payments, check queue status

## Features

### Admin Dashboard
- User management
- Transaction oversight
- System reports
- Settings configuration

### Manager Dashboard
- Kiosk management
- Queue monitoring
- Transaction processing
- User assistance

### Student Dashboard
- View transactions
- Make payments
- Check queue status
- Download receipts

## Security Features

- Role-based access control
- Password encryption
- Session management
- CSRF protection

## Mock Data

The system includes sample data for testing:
- 6 users (1 admin, 2 managers, 3 students)
- 10 transactions across different types
- 3 kiosks in different locations
- Queue entries for various services

## Troubleshooting

If you encounter login issues:
1. Ensure the database is properly configured
2. Check if the application is running
3. Verify your credentials
4. Clear browser cache and cookies
5. Check application logs for errors

## Support

For technical support or issues:
- Email: support@school.edu
- Phone: (123) 456-7890

## License

This project is licensed under the MIT License - see the LICENSE file for details.
