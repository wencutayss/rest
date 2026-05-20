# Configuration Guide - Application Properties

**Date**: May 20, 2026  
**Status**: Complete and Ready to Use

---

## Overview

Each microservice in the eCommerce platform has been configured with **two distinct profiles**:

1. **Default (Development)** - H2 In-Memory Database
2. **PostgreSQL (Production)** - Full PostgreSQL Database

---

## ✅ Development Mode (H2 In-Memory) - DEFAULT

**File**: `application.properties` (default)

### What It Includes
- **Database**: H2 in-memory (no setup needed)
- **Eureka**: Disabled (no service discovery needed)
- **Kafka**: Optional (auto-startup disabled)
- **Redis**: Optional (configured but not required)
- **DDL Strategy**: `create-drop` (recreates on startup)
- **Perfect For**: Local development, testing, quick iterations

### All Services Ready
```
user-service      → Port 8001 ✅
product-service   → Port 8002 ✅
cart-service      → Port 8003 ✅
inventory-service → Port 8004 ✅
order-service     → Port 8005 ✅
payment-service   → Port 8006 ✅
notification-service → Port 8007 ✅
review-service    → Port 8008 ✅
shipping-service  → Port 8009 ✅
saga-orchestrator → Port 8010 ✅
admin-service     → Port 8011 ✅
```

### Run a Service (Dev Mode)
```powershell
cd C:\Users\HP\Videos\Code\Projects\rest
.\run-service.ps1 -Service user -DevMode
```

**Expected Output**: Service starts in 10-15 seconds with no database errors ✅

### Test Service Health
```powershell
curl http://localhost:8001/actuator/health
```

**Response**:
```json
{"status":"UP"}
```

---

## 🗄️ PostgreSQL Mode (Production)

**File**: `application-postgres.properties` (optional)

### What It Includes
- **Database**: PostgreSQL on `localhost:5432`
- **Eureka**: Enabled (service discovery active)
- **Kafka**: Enabled with auto-startup
- **Redis**: Configured and active
- **DDL Strategy**: `validate` (validates existing schema)
- **Connection Pool**: 20 max, 5 minimum connections
- **Perfect For**: Production deployment, multi-service testing

### Prerequisites
Before switching to PostgreSQL mode, ensure these are running:

```
✓ PostgreSQL Server (localhost:5432)
✓ Apache Kafka (localhost:9092)
✓ Redis Server (localhost:6379)
✓ Eureka Server (localhost:8761)
```

### Database Setup
```sql
-- Create databases for each service
CREATE DATABASE userdb;
CREATE DATABASE productdb;
CREATE DATABASE cartdb;
CREATE DATABASE orderdb;
CREATE DATABASE paymentdb;
CREATE DATABASE notificationdb;
CREATE DATABASE reviewdb;
CREATE DATABASE inventorydb;
CREATE DATABASE shippingdb;
CREATE DATABASE admindb;
CREATE DATABASE sagadb;
```

### Run a Service (PostgreSQL Mode)
```powershell
java -jar user-service/target/user-service-1.0.0-SNAPSHOT.jar ^
  --spring.profiles.active=postgres ^
  --spring.datasource.password=your_postgres_password
```

Or using the run script:
```powershell
.\run-service.ps1 -Service user -Profile postgres
```

---

## 📋 Configuration Profiles Summary

| Setting | Development | PostgreSQL |
|---------|-------------|------------|
| **Database** | H2 In-Memory | PostgreSQL |
| **Database URL** | `jdbc:h2:mem:*` | `jdbc:postgresql://localhost:5432/*` |
| **Username** | `sa` | `postgres` |
| **Password** | _(empty)_ | `postgres` |
| **DDL Strategy** | `create-drop` | `validate` |
| **Eureka** | Disabled | Enabled |
| **Kafka** | Disabled | Enabled |
| **Redis** | Not needed | Optional |
| **H2 Console** | Enabled | Disabled |
| **Setup Time** | 0 seconds | 5 minutes |

---

## 🎯 Quick Start Scenarios

### Scenario 1: I Want to Run Services Immediately
✅ Use default development configuration
```powershell
.\run-service.ps1 -Service user -DevMode
```
**Result**: Service running in 15 seconds with zero setup!

---

### Scenario 2: I Want to Test with Real Database
1. Install PostgreSQL
2. Create databases (see Database Setup above)
3. Start Kafka and Redis
4. Run service with postgres profile:
```powershell
java -jar user-service/target/user-service-1.0.0-SNAPSHOT.jar ^
  --spring.profiles.active=postgres
```

---

### Scenario 3: I Want to Test Service-to-Service Communication
1. Start all services in development mode (H2):
```powershell
# Terminal 1
.\run-service.ps1 -Service user -DevMode

# Terminal 2
.\run-service.ps1 -Service product -DevMode

# Terminal 3
.\run-service.ps1 -Service order -DevMode
# ... etc
```

2. Test health endpoints:
```powershell
curl http://localhost:8001/actuator/health
curl http://localhost:8002/actuator/health
curl http://localhost:8005/actuator/health
```

---

## 🔧 Customizing Configuration

### Modify Default Configuration
Edit: `[service-name]/src/main/resources/application.properties`

Example for user-service:
```properties
# Change database name
spring.datasource.url=jdbc:h2:mem:mymemdb

# Change server port
server.port=9001

# Enable additional endpoints
management.endpoints.web.exposure.include=health,info,metrics,prometheus,env,configprops
```

### Modify PostgreSQL Configuration
Edit: `[service-name]/src/main/resources/application-postgres.properties`

Example for user-service:
```properties
# Change database URL
spring.datasource.url=jdbc:postgresql://remote-host:5432/userdb

# Change credentials
spring.datasource.username=prod_user
spring.datasource.password=prod_password

# Enable debug logging
logging.level.org.springframework.web=DEBUG
logging.level.org.hibernate.SQL=DEBUG
```

---

## 🚨 Troubleshooting

### Error: "Failed to determine a suitable driver class"
**Cause**: Database not configured or missing dependency

**Solution**:
- Make sure you're using application.properties (development mode)
- Or ensure PostgreSQL is running if using postgres profile

### Error: "dialect did not initialize"
**Cause**: H2 or PostgreSQL driver missing from classpath

**Solution**:
Run rebuild:
```powershell
mvn clean package -DskipTests
```

### Service Takes Too Long to Start
**Possible Cause**: Trying to connect to unavailable PostgreSQL

**Solution**:
- Use development mode (H2) instead
- Or start PostgreSQL service
- Check if Eureka server is running

### Port Already in Use
**Solution**:
Change port in application.properties:
```properties
server.port=9001  # Change from 8001
```

---

## 📊 Monitoring Endpoints

All services expose health and metrics endpoints:

```
Health Check:     http://localhost:800X/actuator/health
Metrics:          http://localhost:800X/actuator/metrics
Prometheus:       http://localhost:800X/actuator/prometheus
Application Info: http://localhost:800X/actuator/info
H2 Console:       http://localhost:800X/h2-console (dev mode only)
```

---

## 🔐 Security Notes

### Development Mode
- H2 console is enabled for debugging
- No authentication required
- Default credentials: `sa` / (empty password)
- **Never use in production!**

### Production Mode
- PostgreSQL requires proper credentials
- Eureka and Kafka require authentication
- Redis should be password-protected
- All passwords should be externalized (environment variables)

---

## 📝 Configuration Files Checklist

```
✅ user-service/src/main/resources/
   ├── application.properties (Dev - H2)
   └── application-postgres.properties (Prod)

✅ product-service/src/main/resources/
   ├── application.properties (Dev - H2)
   └── application-postgres.properties (Prod)

✅ order-service/src/main/resources/
   ├── application.properties (Dev - H2)
   └── application-postgres.properties (Prod)

✅ cart-service/src/main/resources/
   ├── application.properties (Dev - H2)
   └── application-postgres.properties (Prod)

✅ payment-service/src/main/resources/
   ├── application.properties (Dev - H2)
   └── application-postgres.properties (Prod)

✅ notification-service/src/main/resources/
   ├── application.properties (Dev - H2)
   └── application-postgres.properties (Prod)

✅ review-service/src/main/resources/
   ├── application.properties (Dev - H2)
   └── application-postgres.properties (Prod)

✅ inventory-service/src/main/resources/
   ├── application.properties (Dev - H2)
   └── application-postgres.properties (Prod)

✅ shipping-service/src/main/resources/
   ├── application.properties (Dev - H2)
   └── application-postgres.properties (Prod)

✅ admin-service/src/main/resources/
   ├── application.properties (Dev - H2)
   └── application-postgres.properties (Prod)

✅ saga-orchestrator/src/main/resources/
   ├── application.properties (Dev - H2)
   └── application-postgres.properties (Prod)
```

**Total**: 22 configuration files (11 services × 2 profiles)

---

## 🎉 You're Ready!

### Right Now: Start with Development Mode
```powershell
cd C:\Users\HP\Videos\Code\Projects\rest
.\run-service.ps1 -Service user -DevMode
```

### When Ready: Switch to PostgreSQL Production
```powershell
# After installing PostgreSQL, Kafka, Redis:
java -jar user-service/target/user-service-1.0.0-SNAPSHOT.jar ^
  --spring.profiles.active=postgres
```

---

## 📚 Related Documentation

- **[RUNNING_GUIDE.md](../docs/01-getting-started/RUNNING_GUIDE.md)** - How to run services
- **[BUILD_GUIDE.md](../docs/02-setup-and-build/BUILD_GUIDE.md)** - Build commands
- **[QUICK_START.md](../docs/01-getting-started/QUICK_START.md)** - 3-step quick guide

---

**Configuration Status**: ✅ COMPLETE  
**Date**: May 20, 2026  
**All Services**: Ready to Run!

Start development now! 🚀

