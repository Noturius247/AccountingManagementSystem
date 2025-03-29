# Accounting Management System

## Project Overview
A comprehensive accounting management system designed to streamline financial operations and improve efficiency in business processes.

## Technology Stack
- **Java**: 17
- **Spring Framework**: 6.1.3
- **Spring Boot**: 3.2.3
- **Jakarta EE**: 10
- **Tomcat**: 10.1
- **Hibernate**: 6.4.4.Final
- **Maven**: 3.9.9
- **Lombok**: 1.18.30
- **Jackson**: 2.16.1
- **JUnit**: 5.10.1

## Key Features
1. **Payment Queue System**
   - Priority-based queue management
   - Real-time queue status updates
   - Digital queue display
   - Queue analytics and reporting

2. **Search & Help System**
   - Advanced search functionality
   - FAQ management
   - Help topic categorization
   - User guidance system

3. **User Management System**
   - Role-based access control
   - User authentication and authorization
   - Profile management
   - Activity logging

4. **Transaction Management**
   - Payment processing
   - Transaction history
   - Receipt generation
   - Financial reporting

5. **Notification System**
   - Real-time alerts
   - Email notifications
   - SMS integration
   - Custom notification preferences

## Project Setup

### Prerequisites
- JDK 17 or higher
- Maven 3.9.9
- Tomcat 10.1
- Spring Tool Suite (STS) 4.27.0

### Installation Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/L64Y14W36/AccountingManagementSystem.git
   ```

2. Import the project in STS:
   - File → Import → Git → Projects from Git
   - Choose URI: `https://github.com/L64Y14W36/AccountingManagementSystem.git`
   - Select the main branch
   - Choose "Import as general project"

3. Convert to Maven project:
   - Right-click on the project
   - Configure → Convert to Maven Project
   - Update Maven project (Force Update)

4. Configure Tomcat:
   - Window → Show View → Servers
   - Add new Tomcat 10.1 server
   - Configure project facets (Dynamic Web Module, Java)

5. Build the project:
   ```bash
   mvn clean install
   ```

6. Deploy to Tomcat:
   - Right-click on the project
   - Run As → Run on Server
   - Select Tomcat server
   - Click Finish

### Project Structure
```
src/
├── main/
│   ├── java/
│   │   └── com/
│   │       └── accounting/
│   │           ├── controller/
│   │           ├── service/
│   │           ├── model/
│   │           └── util/
│   └── resources/
│       ├── css/
│       ├── js/
│       └── images/
└── test/
    └── java/
        └── com/
            └── accounting/
                └── test/
```

## Configuration Files
- `pom.xml`: Maven dependencies and build configuration
- `web.xml`: Web application deployment descriptor
- `spring-mvc-servlet.xml`: Spring MVC configuration

## Contributing
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Support
For support, please contact the development team or create an issue in the repository.
