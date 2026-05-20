# 🚀 Quick Start Guide - Running Services

**Last Updated**: May 20, 2026

---

## ⚡ TL;DR - Get Started in 30 Seconds

```powershell
cd C:\Users\HP\Videos\Code\Projects\rest

# Start User Service
java -jar user-service/target/user-service-1.0.0-SNAPSHOT.jar --server.port=8001

# Test if it's running
curl http://localhost:8001/actuator/health
```

**Expected Output**:
```json
{"status":"UP"}
```

---

## 📦 Prerequisites

✅ **Already Provided**:
- H2 Database (in memory, no setup needed)
- Spring Boot 3.3.0
- Java 21

❌ **NOT Needed** for development mode:
- PostgreSQL
- Kafka
- Redis
- Eureka Server

---

## 🎯 Run Any Service

All 11 services follow the same command pattern:

```powershell
java -jar [SERVICE_NAME]/target/[SERVICE_NAME]-1.0.0-SNAPSHOT.jar --server.port=[PORT]
```

### All Services & Ports

```powershell
# User Service
java -jar user-service/target/user-service-1.0.0-SNAPSHOT.jar --server.port=8001

# Product Service
java -jar product-service/target/product-service-1.0.0-SNAPSHOT.jar --server.port=8002

# Cart Service
java -jar cart-service/target/cart-service-1.0.0-SNAPSHOT.jar --server.port=8003

# Inventory Service
java -jar inventory-service/target/inventory-service-1.0.0-SNAPSHOT.jar --server.port=8004

# Order Service
java -jar order-service/target/order-service-1.0.0-SNAPSHOT.jar --server.port=8005

# Payment Service
java -jar payment-service/target/payment-service-1.0.0-SNAPSHOT.jar --server.port=8006

# Notification Service
java -jar notification-service/target/notification-service-1.0.0-SNAPSHOT.jar --server.port=8007

# Review Service
java -jar review-service/target/review-service-1.0.0-SNAPSHOT.jar --server.port=8008

# Shipping Service
java -jar shipping-service/target/shipping-service-1.0.0-SNAPSHOT.jar --server.port=8009

# Saga Orchestrator
java -jar saga-orchestrator/target/saga-orchestrator-1.0.0-SNAPSHOT.jar --server.port=8010

# Admin Service
java -jar admin-service/target/admin-service-1.0.0-SNAPSHOT.jar --server.port=8011
```

---

## 🧪 Test Service Health

For any running service:

```powershell
# Health Check (all services)
curl http://localhost:[PORT]/actuator/health

# Specific Examples
curl http://localhost:8001/actuator/health    # User Service
curl http://localhost:8002/actuator/health    # Product Service
curl http://localhost:8005/actuator/health    # Order Service
```

---

## 💾 H2 Database Console (Dev Mode Only)

Access the H2 web console:

```
URL: http://localhost:[PORT]/h2-console

Login Details:
  Driver Class: org.h2.Driver
  JDBC URL: jdbc:h2:mem:[servicename]db
  User Name: sa
  Password: (leave empty)
```

**Example** for user-service:
```
JDBC URL: jdbc:h2:mem:userdb
```

---

## 🔧 Build Project Before Running

If you haven't built yet:

```powershell
cd C:\Users\HP\Videos\Code\Projects\rest
mvn clean package -DskipTests
```

This creates JAR files in each service's `target/` directory.

---

## 📊 Service Response Example

**Request**:
```powershell
curl http://localhost:8001/actuator/health
```

**Response**:
```json
{
  "status": "UP",
  "components": {
    "db": {
      "status": "UP",
      "details": {
        "database": "H2",
        ...
      }
    },
    "diskSpace": {
      "status": "UP"
    },
    "livenessState": {
      "status": "UP"
    },
    "readinessState": {
      "status": "UP"
    }
  }
}
```

---

## ⚠️ Troubleshooting

### **Service won't start - Port already in use**
```powershell
# Change the port
java -jar user-service/target/user-service-1.0.0-SNAPSHOT.jar --server.port=9001
```

### **Service won't start - JAR not found**
```powershell
# Build the project first
mvn clean package -DskipTests
```

### **Slow startup time**
- First startup is slow (15-20 seconds) - normal!
- Subsequent starts will be faster
- H2 initializes with `create-drop` mode (recreates schema on startup)

### **Can't connect to service**
```powershell
# Check if port is accessible
Test-NetConnection -ComputerName localhost -Port 8001

# Check if Java process is running
Get-Process java
```

---

## 🚀 Run Multiple Services

Open multiple PowerShell terminals:

```powershell
# Terminal 1 - User Service
cd C:\Users\HP\Videos\Code\Projects\rest
java -jar user-service/target/user-service-1.0.0-SNAPSHOT.jar --server.port=8001

# Terminal 2 - Product Service
cd C:\Users\HP\Videos\Code\Projects\rest
java -jar product-service/target/product-service-1.0.0-SNAPSHOT.jar --server.port=8002

# Terminal 3 - Order Service
cd C:\Users\HP\Videos\Code\Projects\rest
java -jar order-service/target/order-service-1.0.0-SNAPSHOT.jar --server.port=8005
```

Test all services:
```powershell
# PowerShell - Test all services
8001,8002,8003,8004,8005,8006,8007,8008,8009,8010,8011 | ForEach-Object {
  $response = curl -s http://localhost:$_/actuator/health
  Write-Host "Port $_: $response"
}
```

---

## 📝 Service Configuration

Each service's configuration is in:
```
[service-name]/src/main/resources/application.properties
```

### Default Configuration (H2 In-Memory)
- Database: H2 (no setup needed)
- Port: Specified with `--server.port`
- Eureka: Disabled
- Kafka: Optional (disabled by default)

### Override Configuration
```powershell
# Override port via command line
java -jar user-service/target/user-service-1.0.0-SNAPSHOT.jar --server.port=9001

# Override database (PostgreSQL mode)
java -jar user-service/target/user-service-1.0.0-SNAPSHOT.jar \
  --spring.profiles.active=postgres \
  --spring.datasource.url=jdbc:postgresql://localhost:5432/userdb \
  --spring.datasource.password=your_password
```

---

## ✅ Startup Checklist

- [ ] Java 21 installed: `java -version`
- [ ] Maven installed: `mvn -version`
- [ ] Project built: `mvn clean package -DskipTests`
- [ ] No Java processes running: `Get-Process java` (should be empty)
- [ ] Target directory has JARs: Check `user-service/target/*.jar` exists
- [ ] Start service: `java -jar...`
- [ ] Test health: `curl http://localhost:8001/actuator/health`
- [ ] See `"status": "UP"` in response ✅

---

## 📚 More Information

- **[CONFIGURATION_GUIDE.md](./CONFIGURATION_GUIDE.md)** - Detailed configuration options
- **[DATASOURCE_FIX_SUMMARY.md](./DATASOURCE_FIX_SUMMARY.md)** - What was fixed
- **[RUNNING_GUIDE.md](./docs/01-getting-started/RUNNING_GUIDE.md)** - Additional running options
- **[BUILD_GUIDE.md](./docs/02-setup-and-build/BUILD_GUIDE.md)** - Build and deployment

---

## 🆘 Still Having Issues?

1. Check logs for error messages
2. Ensure ports are free
3. Build with fresh dependencies: `mvn clean package -DskipTests`
4. Check configuration in `application.properties`
5. Verify Java 21: `java -version` → should be 21.x.x

---

**Status**: ✅ Ready to run!  
**Date**: May 20, 2026

Start your first service now:
```powershell
java -jar user-service/target/user-service-1.0.0-SNAPSHOT.jar --server.port=8001
```

🎉

