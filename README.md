# Accounting Management System

A comprehensive school accounting system with role-based access control, transaction management, and kiosk integration.

## System Requirements

- Java 17 or higher
- Maven 3.8.6 or higher
- Tomcat 10.1.x
- MySQL 8.0 or higher
- Spring Boot 3.x

## Installation

### 1. Install Java
1. Download and install Java 17 JDK from [Oracle's website](https://www.oracle.com/java/technologies/downloads/#java17)
2. Set JAVA_HOME environment variable:
   - Open System Properties > Advanced > Environment Variables
   - Under System Variables, click New
   - Variable name: `JAVA_HOME`
   - Variable value: `C:\Program Files\Java\jdk-17` (adjust path as needed)
   - Click OK to save

### 2. Install Maven
1. Download Maven 3.8.6 or higher from [Maven's website](https://maven.apache.org/download.cgi)
2. Extract the downloaded file to a directory (e.g., `C:\Program Files\Apache\maven`)
3. Set Maven environment variables:
   - Open System Properties > Advanced > Environment Variables
   - Under System Variables, click New
   - Variable name: `MAVEN_HOME`
   - Variable value: `C:\Program Files\Apache\maven` (adjust path as needed)
   - Edit the `Path` variable and add `%MAVEN_HOME%\bin`
   - Click OK to save

### 3. Install Tomcat
1. Download Tomcat 10.1.x from [Apache's website](https://tomcat.apache.org/download-10.cgi)
2. Extract the downloaded file to a directory (e.g., `C:\Program Files\Apache\tomcat`)
3. Set Tomcat environment variables:
   - Open System Properties > Advanced > Environment Variables
   - Under System Variables, click New
   - Variable name: `CATALINA_HOME`
   - Variable value: `C:\Program Files\Apache\tomcat` (adjust path as needed)
   - Edit the `Path` variable and add `%CATALINA_HOME%\bin`
   - Click OK to save

### 4. Verify Installations
Open a new command prompt and run:
```bash
java -version
mvn -version
```

### 5. Project Setup
1. Clone the repository:
```bash
git clone [repository-url]
```

2. Configure the database:
- Install SQLyog from [SQLyog website](https://www.webyog.com/product/sqlyog) or use direct download link: [SQLyog Community Edition](https://www.webyog.com/product/sqlyog/download)
- Launch SQLyog and connect to your MySQL server with these default credentials:
  - Host: localhost
  - Port: 3306
  - Username: root
  - Password: (leave empty if no password is set)
- Create a new database named `accounting_system`:
  - Right-click in the Schema Browser
  - Select Create Database
  - Enter name: `accounting_system`
  - Click Create
- Import the database schema:
  - File > Execute SQL Script
  - Select the `accounting_db.sql` file from Teams
  - Click Execute
  - Verify the tables are created in the Schema Browser

3. Update database configuration:
- Open `src/main/resources/application.properties`
- Update the database credentials with your MySQL credentials:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/accounting_system
spring.datasource.username=root
spring.datasource.password=admin
```

4. Build the project:
```bash
mvn clean install
```

5. Deploy to Tomcat:
- Copy the generated WAR file from `target/` to `%CATALINA_HOME%\webapps\`
- Start Tomcat by running `%CATALINA_HOME%\bin\startup.bat`

### 6. Using Spring Tools IDE (STS)
1. Install Spring Tools IDE:
   - Download from [Spring Tools website](https://spring.io/tools)
   - Install and launch STS

2. Import the project:
   - File > Import > Maven > Existing Maven Projects
   - Select the project root directory
   - Click Finish

3. Maven Commands in STS:
   - Right-click on the project in Project Explorer
   - Select Run As > Maven clean (to clean the project)
   - Select Run As > Maven install (to build the project)
   - Select Run As > Spring Boot App (to run the application)

4. View Console Output:
   - Window > Show View > Console
   - Monitor the application logs and startup process

5. Access the Application:
   - Once started, open a web browser
   - Navigate to `http://localhost:8080`

## Login Information

The system comes with pre-configured users for testing:

### Admin Access
- **Username**: admin
- **Password**: @The10112002
- **Email**: admin@school.edu
- **Features**: Full system access, user management, transaction oversight

### Manager Access
- **Username**: manager
- **Password**: @The10112002
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

## Running the Application

### Method 1: Using Spring Tools IDE (STS)
1. Open the project in STS:
   - File > Import > Maven > Existing Maven Projects
   - Browse to the project directory
   - Click Finish

2. Run the application:
   - Find `src/main/java/com/accounting/AccountingApplication.java` in Project Explorer
   - Right-click > Run As > Spring Boot App

### Method 2: Using Command Line
1. Open terminal in project directory
2. Build the project:
   ```bash
   mvn clean install
   ```
3. Run the application:
   ```bash
   mvn spring-boot:run
   ```

### Method 3: Using JAR file
1. Build the JAR:
   ```bash
   mvn clean package
   ```
2. Run the JAR:
   ```bash
   java -jar target/accounting-management-system.jar
   ```

### Accessing the Application
Once started:
1. Open your web browser
2. Navigate to `http://localhost:8080`
3. Login with the credentials provided in the Login Information section

### Troubleshooting
If you encounter any issues:
1. Ensure MySQL is running and the database is created
2. Check application.properties has correct database credentials
3. Make sure all required dependencies are downloaded (check Maven status)
4. Look for errors in the console output

## User Dashboard Implementation Details

### Currently Implemented Features

#### Financial Overview
- View current balance
- Track pending payments
- Monitor total documents
- Check notifications

#### Transaction Management
- View recent transactions with details
- Export transaction records
- Print transaction history
- Filter transactions by date and status

#### Document Management
- Upload and manage documents
- View document status
- Download documents
- Filter documents by type and status
- Bulk delete functionality

#### Profile Management
- View and update personal information
- Check account status
- View student information (if registered)
- Access settings

#### Payment Management
- View payment statistics
- Track payment history
- Filter payments by date and status
- Make new payments

#### Student Registration
- Complete student registration process
- View registration status
- Update student information

#### Notifications
- View system alerts
- Track document status changes
- Monitor payment updates
- Manage notification preferences

### Implementation Status
- All features listed above are fully implemented in the codebase
- UI components are complete with proper styling and responsiveness
- Backend integration is functional for all listed features
- Security measures are in place for all user actions

## Admin Dashboard Implementation Details

### Currently Implemented Features

#### User Management
- View user list with pagination
- Search users by name, email, or role
- Filter users by role and status
- View user details including:
  - Basic information (name, email, role)
  - Account status
  - Last activity timestamp
  - Account creation date
- Bulk actions:
  - Delete multiple users
  - Export user data
- View user history and activity logs

#### Financial Analytics
- View total balance
- Track pending payments
- Monitor total documents
- Check notifications

### Implementation Status

#### User Management
- ✅ User listing and pagination
- ✅ Search functionality
- ✅ Role and status filtering
- ✅ User details display
- ✅ Bulk delete functionality
- ✅ Export functionality
- ✅ User history tracking

#### Financial Analytics
- ✅ Balance display
- ✅ Pending payments tracking
- ✅ Document count monitoring
- ✅ Notification system

### Technical Details

#### User Management Implementation
- Uses Spring Data JPA for database operations
- Implements custom repository methods for search and filtering
- Utilizes Spring Security for role-based access control
- Implements pagination using Spring Data's Pageable interface
- Uses JSP for view rendering with Bootstrap for styling
- Implements client-side filtering and sorting using JavaScript
- Exports data in CSV format using Apache Commons CSV

#### Financial Analytics Implementation
- Real-time balance calculation using Spring Data JPA
- Asynchronous notification system using Spring's @Async
- Document tracking using Spring Data JPA repositories
- Transaction monitoring with Spring AOP for logging

### Security Features
- Role-based access control (RBAC)
- CSRF protection
- Input validation
- Secure password handling
- Session management
- Audit logging

### Performance Optimizations
- Pagination for large datasets
- Caching of frequently accessed data
- Lazy loading of user details
- Optimized database queries
- Client-side filtering for better responsiveness

### Future Enhancements
- Advanced user analytics
- Custom report generation
- Enhanced export options
- Real-time notifications
- Audit trail improvements
- Performance monitoring dashboard

## Manager Dashboard Implementation Details

### Currently Implemented Features

#### Financial Overview
- View total revenue with trend analysis
- Monitor pending approvals
- Track active users
- System health monitoring
- Revenue trend visualization
- User activity tracking

#### Transaction Management
- View recent transactions
- Approve/reject transactions
- Export transaction reports
- Filter transactions by status
- View transaction details

#### Task Management
- View and manage tasks
- Set task priorities (High/Medium/Low)
- Mark tasks as completed
- Track task due dates
- Add new tasks

#### Team Management
- View team member status
- Monitor team member roles
- Track member availability
- View member details

#### Document Management
- View document statistics
- Track pending reviews
- Monitor approved/rejected documents
- Document filtering and search
- Bulk document operations

#### Queue Management
- Monitor service queues
- Advance queue positions
- Reset queues
- View queue statistics
- Track waiting users

#### Reporting
- Generate financial reports
- Export data in various formats
- View report statistics
- Track report generation time
- Monitor popular reports

#### Notifications
- View system alerts
- Mark notifications as read
- Track important updates
- Manage notification preferences

### Implementation Status

#### Financial Overview
- ✅ Revenue tracking and analysis
- ✅ Pending approvals monitoring
- ✅ Active user tracking
- ✅ System health monitoring
- ✅ Revenue trend visualization
- ✅ User activity tracking

#### Transaction Management
- ✅ Transaction viewing and filtering
- ✅ Transaction approval system
- ✅ Report export functionality
- ✅ Status-based filtering
- ✅ Detailed transaction view

#### Task Management
- ✅ Task creation and management
- ✅ Priority setting
- ✅ Task completion tracking
- ✅ Due date management
- ✅ Task filtering

#### Team Management
- ✅ Team member status display
- ✅ Role monitoring
- ✅ Availability tracking
- ✅ Member details view

#### Document Management
- ✅ Document statistics
- ✅ Review tracking
- ✅ Status monitoring
- ✅ Search and filter
- ✅ Bulk operations

#### Queue Management
- ✅ Queue monitoring
- ✅ Position advancement
- ✅ Queue reset functionality
- ✅ Statistics display
- ✅ User tracking

#### Reporting
- ✅ Report generation
- ✅ Data export
- ✅ Statistics display
- ✅ Generation tracking
- ✅ Popular report monitoring

#### Notifications
- ✅ Alert system
- ✅ Read status tracking
- ✅ Update monitoring
- ✅ Preference management

### Technical Details

#### Financial Overview Implementation
- Real-time revenue calculation using Spring Data JPA
- Trend analysis using statistical methods
- System health monitoring with Spring Actuator
- Activity tracking with Spring AOP

#### Transaction Management Implementation
- Transaction processing with Spring Transaction Management
- Approval workflow using Spring State Machine
- Report generation with Apache POI
- Filtering using Spring Data JPA Specifications

#### Task Management Implementation
- Task scheduling with Spring Task
- Priority management using custom enums
- Due date tracking with Java Time API
- Task filtering using Spring Data JPA

#### Team Management Implementation
- Team member tracking with Spring Data JPA
- Role management using Spring Security
- Availability monitoring with WebSocket
- Member details using Spring Data REST

#### Document Management Implementation
- Document storage using Spring Content
- Review workflow with Spring State Machine
- Status tracking using Spring Data JPA
- Search functionality with Spring Data Elasticsearch

#### Queue Management Implementation
- Queue monitoring with Spring Integration
- Position management using Redis
- Statistics calculation with Spring Data JPA
- User tracking using Spring Security

#### Reporting Implementation
- Report generation with JasperReports
- Data export using Apache POI
- Statistics calculation with Spring Data JPA
- Generation tracking using Spring Task

#### Notifications Implementation
- Alert system using Spring WebSocket
- Read status tracking with Spring Data JPA
- Update monitoring using Spring Events
- Preference management with Spring Security

### Security Features
- Role-based access control (RBAC)
- Transaction security
- Document access control
- Queue access management
- Report access restrictions

### Performance Optimizations
- Caching with Spring Cache
- Asynchronous processing
- Batch operations
- Lazy loading
- Query optimization

### Future Enhancements
- Advanced analytics
- Machine learning integration
- Real-time monitoring
- Mobile app integration
- API enhancements

## Testing Responsibilities

### Joshua: User Dashboard Testing
#### Functional Testing
- Test user login and authentication
- Verify financial overview features:
  - Balance display
  - Pending payments tracking
  - Document count monitoring
- Test transaction management:
  - View recent transactions
  - Export functionality
  - Filtering capabilities
- Validate document management:
  - Upload/download documents
  - Document status updates
  - Bulk operations

#### Security Testing
- Test password policies
- Verify session management
- Check access control for user-specific features
- Test data privacy measures

### Steben: Admin Dashboard Testing
#### Functional Testing
- Test admin login and authentication
- Verify user management features:
  - User listing and pagination
  - Search and filter functionality
  - User details display
  - Bulk operations
- Test financial analytics:
  - Balance calculations
  - Payment tracking
  - Document monitoring

#### Security Testing
- Test admin-specific access controls
- Verify role-based permissions
- Test audit logging
- Validate security configurations

### Felix: admin Dashboard Testing (Part 1)
#### Functional Testing
- Test manager login and authentication
- Verify financial overview:
  - Revenue tracking
  - Trend analysis
  - System health monitoring
- Test transaction management:
  - Transaction approval workflow
  - Report generation
  - Status filtering

#### Performance Testing
- Test system response times
- Verify concurrent user handling
- Test data loading performance
- Validate caching mechanisms

### Frank: Manager Dashboard Testing (Part 2)
#### Functional Testing
- Test task management:
  - Task creation and updates
  - Priority setting
  - Due date tracking
- Verify team management:
  - Member status display
  - Role monitoring
  - Availability tracking
- Test document management:
  - Document statistics
  - Review tracking
  - Search functionality

#### Integration Testing
- Test integration with user dashboard
- Verify integration with admin dashboard
- Test external system integrations
- Validate data flow between components

### Benz: System-wide Testing
#### System Testing
- Test cross-role interactions
- Verify system-wide features:
  - Notifications
  - Reporting
  - Queue management
- Test backup and recovery procedures
- Validate system configuration

#### Quality Assurance
- Test UI/UX consistency
- Verify error handling
- Test data validation
- Validate system documentation
- Test system scalability

### Testing Schedule
1. Week 1-2: Individual component testing
2. Week 3: Integration testing
3. Week 4: System testing and bug fixes
4. Week 5: Final testing and documentation

### Testing Tools
- JUnit for unit testing
- Selenium for UI testing
- JMeter for performance testing
- Postman for API testing
- SonarQube for code quality

### Testing Deliverables
1. Test plans for each component
2. Test cases and results
3. Bug reports and fixes
4. Performance metrics
5. Final testing report

### Reporting Requirements
- Daily progress updates
- Weekly test summaries
- Bug tracking reports
- Performance test results
- Final testing documentation
