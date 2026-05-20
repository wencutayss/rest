# Quick Build & Run Guide

## Building the Project

### Clean Build All Modules
```bash
cd rest
mvn clean compile
```

### Build and Package (Create Executable JARs)
```bash
mvn clean package -DskipTests
```

### Build Specific Service
```bash
mvn clean package -pl user-service -DskipTests
```

## Running Services

### Run Individual Service JAR
```bash
java -jar user-service/target/user-service-1.0.0-SNAPSHOT.jar
```

### Run with Maven
```bash
mvn spring-boot:run -pl user-service
```

### Debug Mode
```bash
java -jar user-service/target/user-service-1.0.0-SNAPSHOT.jar --debug
```

## Common Maven Commands

### Install Common Library to Local Repository
```bash
mvn clean install -pl common-lib
```

### Build and Skip Tests
```bash
mvn clean package -DskipTests
```

### Run Tests Only
```bash
mvn test
```

### View Dependency Tree
```bash
mvn dependency:tree -pl user-service
```

### Check for Dependency Updates
```bash
mvn versions:display-dependency-updates
```

## Troubleshooting

### Clear Maven Cache
```bash
rm -rf ~/.m2/repository/com/ecommerce
```

### Fix Compilation Errors
```bash
mvn clean compile -X
```

### Check Plugin Versions
```bash
mvn help:describe -Dplugin=org.springframework.boot:spring-boot-maven-plugin
```

## Service Ports

| Service | Port | Health Check |
|---------|------|--------------|
| User Service | 8001 | http://localhost:8001/actuator/health |
| Product Service | 8002 | http://localhost:8002/actuator/health |
| Inventory Service | 8004 | http://localhost:8004/actuator/health |
| Order Service | 8005 | http://localhost:8005/actuator/health |
| Payment Service | 8006 | http://localhost:8006/actuator/health |
| Notification Service | 8007 | http://localhost:8007/actuator/health |
| Review Service | 8008 | http://localhost:8008/actuator/health |
| Shipping Service | 8009 | http://localhost:8009/actuator/health |
| Saga Orchestrator | 8010 | http://localhost:8010/actuator/health |
| Admin Service | 8011 | http://localhost:8011/actuator/health |

## Monitoring & Metrics

### Prometheus Metrics Endpoint
```
http://localhost:<port>/actuator/prometheus
```

### Service Health Check
```
http://localhost:<port>/actuator/health
```

### Available Endpoints
```
http://localhost:<port>/actuator
```

## IDE Setup (IntelliJ IDEA / Eclipse)

### IntelliJ IDEA
1. Open project root directory
2. Let IDE detect as Maven project
3. Run `mvn clean install` from terminal
4. IDE should auto-configure all modules

### Eclipse
1. Import as Maven project
2. Right-click project → Maven → Update Project
3. Configure Run Configurations per service

## Maven Enforcer Rules

The project enforces:
- **Java 21 or higher** required
- **Maven 3.9.0 or higher** required  
- **Dependency convergence** - prevents version conflicts
- **No duplicate POM dependencies** - prevents mistakes

If you get conflicting Java/Maven version errors, please update your environment.

---

**For full documentation, see SETUP_COMPLETE.md**

