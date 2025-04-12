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
