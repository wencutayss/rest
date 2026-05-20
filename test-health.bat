@echo off
REM Test if the service is running by checking its health endpoint

REM Give service time to fully start (wait 10-15 seconds after starting)
REM Then run one of these commands:

REM For User Service (Port 8001):
curl http://localhost:8001/actuator/health

REM For other services, replace 8001 with the appropriate port:
REM Port 8002 - Product Service
REM Port 8003 - Cart Service
REM Port 8004 - Inventory Service
REM Port 8005 - Order Service
REM Port 8006 - Payment Service
REM Port 8007 - Notification Service
REM Port 8008 - Review Service
REM Port 8009 - Shipping Service
REM Port 8010 - Saga Orchestrator
REM Port 8011 - Admin Service

