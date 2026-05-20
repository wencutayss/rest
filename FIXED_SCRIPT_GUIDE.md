# How to Run Services - FIXED SCRIPT GUIDE

**Date**: May 18, 2026  
**Status**: ✅ Script Fixed - Ready to Use

---

## ✅ PROBLEM FIXED

The PowerShell script had encoding issues with special characters (emoji). All issues have been corrected.

---

## 🚀 How to Run a Service

### Method 1: PowerShell (Recommended)

**Terminal Window 1 - Start the Service**:
```powershell
cd C:\Users\HP\Videos\Code\Projects\rest
.\run-service.ps1 -Service user -DevMode
```

**Wait for this message** (takes ~10-15 seconds):
```
2026-05-18T23:XX:XX.XXX+05:30 INFO ... Started UserServiceApplication
```

**Terminal Window 2 - Test the Service**:
```powershell
# Wait about 10-15 seconds, then run:
curl http://localhost:8001/actuator/health
```

**Expected Response**:
```json
{"status":"UP"}
```

---

## 📊 All Services Available

| Service Name | Command | Port | Health URL |
|--------------|---------|------|-----------|
| **User** | `.\run-service.ps1 -Service user -DevMode` | 8001 | http://localhost:8001/actuator/health |
| **Product** | `.\run-service.ps1 -Service product -DevMode` | 8002 | http://localhost:8002/actuator/health |
| **Cart** | `.\run-service.ps1 -Service cart -DevMode` | 8003 | http://localhost:8003/actuator/health |
| **Inventory** | `.\run-service.ps1 -Service inventory -DevMode` | 8004 | http://localhost:8004/actuator/health |
| **Order** | `.\run-service.ps1 -Service order -DevMode` | 8005 | http://localhost:8005/actuator/health |
| **Payment** | `.\run-service.ps1 -Service payment -DevMode` | 8006 | http://localhost:8006/actuator/health |
| **Notification** | `.\run-service.ps1 -Service notification -DevMode` | 8007 | http://localhost:8007/actuator/health |
| **Review** | `.\run-service.ps1 -Service review -DevMode` | 8008 | http://localhost:8008/actuator/health |
| **Shipping** | `.\run-service.ps1 -Service shipping -DevMode` | 8009 | http://localhost:8009/actuator/health |
| **Saga-Orchestrator** | `.\run-service.ps1 -Service saga-orchestrator -DevMode` | 8010 | http://localhost:8010/actuator/health |
| **Admin** | `.\run-service.ps1 -Service admin -DevMode` | 8011 | http://localhost:8011/actuator/health |

---

## 🎯 Example: Run Multiple Services

**Terminal 1 - User Service**:
```powershell
.\run-service.ps1 -Service user -DevMode
```

**Terminal 2 - Product Service**:
```powershell
.\run-service.ps1 -Service product -DevMode
```

**Terminal 3 - Order Service**:
```powershell
.\run-service.ps1 -Service order -DevMode
```

All services will run simultaneously on their own ports (8001, 8002, 8005).

---

## 🔧 Batch Script Alternative

If you prefer batch/cmd scripts:

```batch
run-service.bat user
run-service.bat product
run-service.bat order
```

---

## ✅ What's Running

When you start a service, you'll see:

```
========== eCommerce Microservices - user ==========
Mode: DEV (Offline)
Port: 8001
======================================================

Configuration:
  [+] Spring Cloud Config: DISABLED
  [+] Eureka Discovery: DISABLED
  [+] Database: H2 In-Memory

Starting service...
JAR: C:\Users\HP\Videos\Code\Projects\rest\user-service\target\user-service-1.0.0-SNAPSHOT.jar

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/

 :: Spring Boot :: (v3.3.0)

[INFO] Starting UserServiceApplication...
```

This means the service is starting. **Wait 10-15 seconds** for the "Started" message.

---

## 📡 Testing Services

### Quick Test (No additional terminal needed)

In the service terminal, wait for "Started" message, then:

```powershell
# In a web browser
http://localhost:8001/actuator/health

# Or from PowerShell/CMD
curl http://localhost:8001/actuator/health
```

### Response:
```json
{"status":"UP"}
```

---

## 🛑 Stopping Services

Press **Ctrl+C** in the terminal window where the service is running.

```
2026-05-18T23:XX:XX.XXX+05:30  INFO ... Closing ApplicationContext
PS C:\Users\HP\Videos\Code\Projects\rest>
```

---

## 📋 Troubleshooting

### Issue: "JAR not found"
**Solution**: Build first
```powershell
mvn clean package -DskipTests
```

### Issue: "Port already in use"
**Solution**: Stop the service on that port:
```powershell
# Find and kill the Java process
Get-Process java | Stop-Process -Force

# Or change port in manual command:
java -jar user-service/target/user-service-1.0.0-SNAPSHOT.jar --server.port=9001
```

### Issue: Script still has errors
**Solution**: Verify script is fixed:
```powershell
# Check if script is readable
Get-Content .\run-service.ps1 | Select-Object -First 50
```

---

## ✨ Next Steps

1. ✅ **Run first service**:
   ```powershell
   .\run-service.ps1 -Service user -DevMode
   ```

2. ✅ **Wait for startup** (~10-15 seconds):
   - Look for "Started UserServiceApplication"

3. ✅ **Test health** (in another terminal):
   ```powershell
   curl http://localhost:8001/actuator/health
   ```

4. ✅ **Run more services** (in more terminals):
   ```powershell
   .\run-service.ps1 -Service product -DevMode
   .\run-service.ps1 -Service order -DevMode
   ```

---

## 📚 Documentation

For complete details, see:
- `README_START_HERE.md` - Quick overview
- `QUICK_START.md` - 3-step guide
- `RUNNING_GUIDE.md` - Detailed instructions
- `DOCUMENTATION_INDEX.md` - All documentation

---

**Status**: ✅ Script Fixed and Ready  
**Date**: May 18, 2026  
**All Systems**: GO!

Start running services now! 🚀

