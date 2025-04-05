# Accounting Management System

A Spring Boot application for managing accounting operations.

## Prerequisites

- Java 17 or higher
- Maven 3.6 or higher
- Your favorite IDE (Spring Tool Suite, IntelliJ IDEA, or Eclipse)
- Git

## Setup Instructions

1. Clone the repository:
```bash
git clone [your-repository-url]
cd AccountingManagementSystem
```

2. Configure application properties:
   - Copy `src/main/resources/application.properties` to `src/main/resources/application-local.properties`
   - Modify the database settings in your local properties file if needed

3. Build the project:
```bash
mvn clean install
```

4. Run the application:
```bash
mvn spring-boot:run
```

Or run it from your IDE by running the `AccountingApplication` class.

5. Access the application:
   - Open a web browser
   - Go to `http://localhost:8081/accounting/login`
   - Default credentials:
     - Username: admin
     - Password: password

## Project Structure

```
src/
├── main/
│   ├── java/
│   │   └── com/
│   │       └── accounting/
│   │           ├── config/      # Configuration classes
│   │           ├── controller/  # MVC Controllers
│   │           ├── model/       # Entity classes
│   │           ├── repository/  # Data repositories
│   │           └── service/     # Business logic
│   └── resources/
│       ├── static/             # Static resources
│       ├── templates/          # Thymeleaf templates
│       └── application.properties
```

## Development Guidelines

1. Always create a new branch for features/fixes:
```bash
git checkout -b feature/your-feature-name
```

2. Follow the existing code style and naming conventions

3. Write unit tests for new features

4. Update documentation when necessary

## Common Issues

1. Port 8081 already in use:
   - Change the port in `application.properties`
   - Or stop the process using the port

2. Database connection issues:
   - Verify database settings in application.properties
   - Ensure H2 console is accessible at `/h2-console`

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Contact

[Your Name/Team Contact Information]
