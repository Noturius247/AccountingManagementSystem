# Accounting Management System - Deployment Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Database Configuration](#database-configuration)
4. [Application Deployment](#application-deployment)
5. [Security Configuration](#security-configuration)
6. [Monitoring and Maintenance](#monitoring-and-maintenance)
7. [Backup and Recovery](#backup-and-recovery)

## Prerequisites

### Hardware Requirements
- CPU: 4 cores or more
- RAM: 8GB minimum
- Storage: 50GB minimum
- Network: 100Mbps minimum

### Software Requirements
- Java 17 or higher
- MySQL 8.0 or higher
- Apache Tomcat 9.0 or higher
- Maven 3.6 or higher
- Git

## Environment Setup

### 1. Java Installation
```bash
# Install Java 17
sudo apt update
sudo apt install openjdk-17-jdk

# Verify installation
java -version
```

### 2. MySQL Installation
```bash
# Install MySQL
sudo apt install mysql-server

# Start MySQL service
sudo systemctl start mysql

# Secure installation
sudo mysql_secure_installation
```

### 3. Apache Tomcat Installation
```bash
# Download Tomcat
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.68/bin/apache-tomcat-9.0.68.tar.gz

# Extract
tar -xzf apache-tomcat-9.0.68.tar.gz

# Move to /opt
sudo mv apache-tomcat-9.0.68 /opt/tomcat
```

## Database Configuration

### 1. Create Database
```sql
CREATE DATABASE accounting_db;
CREATE USER 'accounting_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON accounting_db.* TO 'accounting_user'@'localhost';
FLUSH PRIVILEGES;
```

### 2. Configure application.properties
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/accounting_db
spring.datasource.username=accounting_user
spring.datasource.password=your_password
spring.jpa.hibernate.ddl-auto=none
```

## Application Deployment

### 1. Build the Application
```bash
# Clone repository
git clone https://github.com/your-org/accounting-system.git

# Build with Maven
cd accounting-system
mvn clean package
```

### 2. Deploy to Tomcat
```bash
# Copy WAR file to Tomcat
cp target/accounting-system.war /opt/tomcat/webapps/

# Start Tomcat
/opt/tomcat/bin/startup.sh
```

### 3. Verify Deployment
- Access the application at `http://your-server:8080/accounting-system`
- Check Tomcat logs at `/opt/tomcat/logs/catalina.out`

## Security Configuration

### 1. SSL Configuration
```bash
# Generate SSL certificate
openssl req -newkey rsa:2048 -nodes -keyout accounting.key -x509 -days 365 -out accounting.crt

# Configure Tomcat for SSL
# Edit /opt/tomcat/conf/server.xml
```

### 2. Firewall Configuration
```bash
# Allow necessary ports
sudo ufw allow 8080/tcp
sudo ufw allow 8443/tcp
sudo ufw enable
```

### 3. Security Headers
Configure in `application.properties`:
```properties
server.servlet.session.cookie.http-only=true
server.servlet.session.cookie.secure=true
server.servlet.session.cookie.same-site=strict
```

## Monitoring and Maintenance

### 1. Logging Configuration
```properties
logging.level.root=INFO
logging.level.com.accounting=DEBUG
logging.file.name=/var/log/accounting/application.log
```

### 2. Health Checks
- Access `/actuator/health` for system health
- Monitor `/actuator/metrics` for performance metrics

### 3. Regular Maintenance
```bash
# Database backup
mysqldump -u accounting_user -p accounting_db > backup.sql

# Log rotation
logrotate /etc/logrotate.d/accounting
```

## Backup and Recovery

### 1. Database Backup
```bash
# Daily backup script
#!/bin/bash
BACKUP_DIR="/backup/accounting"
DATE=$(date +%Y%m%d)
mysqldump -u accounting_user -p accounting_db > $BACKUP_DIR/backup_$DATE.sql
```

### 2. Application Backup
```bash
# Backup application files
tar -czf /backup/accounting/app_$DATE.tar.gz /opt/tomcat/webapps/accounting-system
```

### 3. Recovery Procedures
1. Database Recovery:
```sql
mysql -u accounting_user -p accounting_db < backup.sql
```

2. Application Recovery:
```bash
# Stop Tomcat
/opt/tomcat/bin/shutdown.sh

# Restore from backup
tar -xzf app_backup.tar.gz -C /opt/tomcat/webapps/

# Start Tomcat
/opt/tomcat/bin/startup.sh
```

## Troubleshooting

### Common Issues
1. Application Not Starting
   - Check Tomcat logs
   - Verify database connection
   - Check memory usage

2. Database Connection Issues
   - Verify credentials
   - Check network connectivity
   - Ensure MySQL is running

3. Performance Issues
   - Monitor system resources
   - Check database indexes
   - Review application logs

### Support
For deployment support:
- Email: devops@accounting-system.com
- Phone: +1 (555) 123-4567
- Hours: 24/7 