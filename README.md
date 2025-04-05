# Accounting Management System

A Spring Boot application for managing accounting transactions and user roles.

## Features

- User authentication and authorization
- Role-based access control (Admin and User roles)
- Transaction management
- Notification system
- Queue management for pending transactions

## Technology Stack

- Java 17
- Spring Boot 3.2.3
- Spring Security
- Spring Data JPA
- H2 Database
- Maven
- Thymeleaf
- Lombok

## Database Schema

The application uses the following database tables:

### Users Table
- Stores user information including credentials and personal details
- Fields: id, username, password, email, first_name, last_name, enabled, created_at, updated_at

### Roles Table
- Defines available roles in the system
- Fields: id, name

### User Roles Table
- Manages many-to-many relationship between users and roles
- Fields: id, user_id, role_id

### Transaction Table
- Stores financial transactions
- Fields: id, amount, description, status, timestamp, user_id, created_at, updated_at

## Setup Instructions

1. Clone the repository
2. Ensure you have Java 17 and Maven installed
3. Build the project:
   ```bash
   mvn clean install
   ```
4. Run the application:
   ```bash
   mvn spring-boot:run
   ```

## Default Credentials

- Username: admin
- Password: password

## Configuration

The application uses an H2 in-memory database by default. Database configuration can be modified in `application.properties`.

## API Endpoints

### Authentication
- POST /api/auth/login - User login
- POST /api/auth/register - User registration

### Admin
- GET /api/admin/users - List all users
- GET /api/admin/transactions - List all transactions
- GET /api/admin/statistics - Get system statistics

### Transactions
- GET /api/transactions - List user's transactions
- POST /api/transactions - Create new transaction
- GET /api/transactions/{id} - Get transaction details
- PUT /api/transactions/{id} - Update transaction
- DELETE /api/transactions/{id} - Delete transaction

### Notifications
- GET /api/notifications - Get user notifications
- PUT /api/notifications/settings - Update notification settings

## Security

The application uses Spring Security with:
- BCrypt password encoding
- JWT-based authentication
- Role-based authorization
- CSRF protection

## Development

### Prerequisites
- Java 17
- Maven 3.8+
- IDE with Spring Boot support

### Building
```bash
mvn clean install
```

### Running Tests
```bash
mvn test
```

### Code Style
The project uses standard Java code style conventions.

## License

This project is licensed under the MIT License.
