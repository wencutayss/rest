# eCommerce Microservices - Quick Start PowerShell Script
# Usage: .\run-service.ps1 -Service user
# Usage: .\run-service.ps1 -Service product -DevMode

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("user", "product", "cart", "inventory", "order", "payment", "notification", "review", "shipping", "saga-orchestrator", "admin")]
    [string]$Service,

    [Parameter(Mandatory=$false)]
    [switch]$DevMode
)

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

# Port mapping
$Ports = @{
    "user" = 8001
    "product" = 8002
    "cart" = 8003
    "inventory" = 8004
    "order" = 8005
    "payment" = 8006
    "notification" = 8007
    "review" = 8008
    "shipping" = 8009
    "saga-orchestrator" = 8010
    "admin" = 8011
}

$Port = $Ports[$Service]

if ($Service -eq "saga-orchestrator") {
    $JarPath = Join-Path $ProjectRoot "saga-orchestrator\target\saga-orchestrator-1.0.0-SNAPSHOT.jar"
} else {
    $JarPath = Join-Path $ProjectRoot "$Service-service\target\$Service-service-1.0.0-SNAPSHOT.jar"
}

# Verify JAR exists
if (-not (Test-Path $JarPath)) {
    Write-Host "[ERROR] JAR not found at $JarPath" -ForegroundColor Red
    Write-Host "Please run: mvn clean package -DskipTests" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "========== eCommerce Microservices - $Service ==========" -ForegroundColor Cyan
if ($DevMode) {
    Write-Host "Mode: DEV (Offline)" -ForegroundColor Yellow
} else {
    Write-Host "Mode: Standard" -ForegroundColor Green
}
Write-Host "Port: $Port" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# Build Java command
$JavaArgs = @(
    "-jar",
    $JarPath
)

if ($DevMode) {
    Write-Host "Configuration:" -ForegroundColor Yellow
    Write-Host "  [+] Spring Cloud Config: DISABLED"
    Write-Host "  [+] Eureka Discovery: DISABLED"
    Write-Host "  [+] Database: H2 In-Memory"
    Write-Host ""

    $JavaArgs += @(
        "--spring.cloud.config.enabled=false",
        "--spring.cloud.config.import-check.enabled=false",
        "--eureka.client.enabled=false",
        "--eureka.client.registerWithEureka=false",
        "--eureka.client.fetchRegistry=false",
        "--spring.datasource.url=jdbc:h2:mem:testdb",
        "--spring.datasource.driverClassName=org.h2.Driver",
        "--spring.jpa.database-platform=org.hibernate.dialect.H2Dialect",
        "--spring.jpa.hibernate.ddl-auto=create-drop",
        "--spring.h2.console.enabled=true"
    )
} else {
    Write-Host "Configuration:" -ForegroundColor Green
    Write-Host "  [+] Spring Cloud Config: ENABLED (requires Config Server)"
    Write-Host "  [+] Eureka Discovery: ENABLED (requires Eureka Server)"
    Write-Host "  [+] Database: PostgreSQL (requires database setup)"
    Write-Host ""
}

# Add port argument
$JavaArgs += "--server.port=$Port"

Write-Host "Starting service..." -ForegroundColor Green
Write-Host "JAR: $JarPath" -ForegroundColor Gray
Write-Host ""

# Run Java
try {
    & java $JavaArgs
} catch {
    Write-Host "Error running service:" $_ -ForegroundColor Red
    exit 1
}

