@echo off
echo Stopping any running Spring Boot application...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080') do (
    taskkill /F /PID %%a 2>nul
)

echo Cleaning and packaging application...
call mvnw clean package -DskipTests

echo Starting the application...
start /B cmd /c mvnw spring-boot:run
echo Application restart requested. Check the console for updates. 