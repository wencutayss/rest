@echo off
REM eCommerce Microservices - Quick Start Script
REM Usage: run-service.bat user (runs user service)
REM Usage: run-service.bat product (runs product service)
REM etc...

setlocal enabledelayedexpansion

REM Map service names to ports
set "user-service_port=8001"
set "product-service_port=8002"
set "cart-service_port=8003"
set "inventory-service_port=8004"
set "order-service_port=8005"
set "payment-service_port=8006"
set "notification-service_port=8007"
set "review-service_port=8008"
set "shipping-service_port=8009"
set "saga-orchestrator_port=8010"
set "admin-service_port=8011"

REM Get service name from argument
if [%1]==[] (
    echo.
    echo ========================================
    echo eCommerce Microservices - Quick Runner
    echo ========================================
    echo.
    echo Usage: run-service.bat [SERVICE_NAME] [DEV_MODE]
    echo.
    echo Available Services:
    echo   - user
    echo   - product
    echo   - cart
    echo   - inventory
    echo   - order
    echo   - payment
    echo   - notification
    echo   - review
    echo   - shipping
    echo   - saga-orchestrator
    echo   - admin
    echo.
    echo Examples:
    echo   run-service.bat user
    echo   run-service.bat product dev
    echo.
    exit /b 1
)

set "SERVICE=%1"
set "MODE=%2"

REM Validate service
if not exist "%~dp0%SERVICE%-service\target\%SERVICE%-service-1.0.0-SNAPSHOT.jar" (
    if not exist "%~dp0saga-orchestrator\target\saga-orchestrator-1.0.0-SNAPSHOT.jar" if "%SERVICE%"=="saga-orchestrator" goto run_saga
    echo Error: Service not found - %SERVICE%-service
    echo Please run: mvn clean package -DskipTests
    exit /b 1
)

REM Get port
for /f "tokens=1,2 delims==" %%A in ('set %SERVICE%-service_port') do (
    set "PORT=%%B"
)

if "%MODE%"=="dev" (
    echo.
    echo ========================================
    echo Running %SERVICE%-service in DEV MODE
    echo Port: %PORT%
    echo ========================================
    echo.
    echo Configuration:
    echo - Spring Cloud Config: DISABLED
    echo - Eureka Service Discovery: DISABLED
    echo - Database: H2 In-Memory
    echo.

    java -jar "%~dp0%SERVICE%-service\target\%SERVICE%-service-1.0.0-SNAPSHOT.jar" ^
        --spring.cloud.config.enabled=false ^
        --spring.cloud.config.import-check.enabled=false ^
        --eureka.client.enabled=false ^
        --eureka.client.registerWithEureka=false ^
        --eureka.client.fetchRegistry=false ^
        --spring.datasource.url=jdbc:h2:mem:testdb ^
        --spring.datasource.driverClassName=org.h2.Driver ^
        --spring.jpa.database-platform=org.hibernate.dialect.H2Dialect ^
        --spring.jpa.hibernate.ddl-auto=create-drop ^
        --spring.h2.console.enabled=true ^
        --server.port=%PORT%
) else (
    echo.
    echo ========================================
    echo Running %SERVICE%-service
    echo Port: %PORT%
    echo ========================================
    echo.
    echo Configuration:
    echo - Spring Cloud Config: ENABLED
    echo - Eureka Service Discovery: ENABLED
    echo - Requires: Eureka Server, Config Server
    echo.

    java -jar "%~dp0%SERVICE%-service\target\%SERVICE%-service-1.0.0-SNAPSHOT.jar" ^
        --server.port=%PORT%
)

exit /b 0

:run_saga
set "PORT=8010"
echo.
echo ========================================
echo Running saga-orchestrator
echo Port: %PORT%
echo ========================================
echo.

if "%MODE%"=="dev" (
    echo Configuration: DEV MODE
    java -jar "%~dp0saga-orchestrator\target\saga-orchestrator-1.0.0-SNAPSHOT.jar" ^
        --spring.cloud.config.enabled=false ^
        --eureka.client.enabled=false ^
        --server.port=%PORT%
) else (
    java -jar "%~dp0saga-orchestrator\target\saga-orchestrator-1.0.0-SNAPSHOT.jar" ^
        --server.port=%PORT%
)

exit /b 0

