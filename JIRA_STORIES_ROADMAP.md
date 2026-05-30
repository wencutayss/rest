# eCommerce Microservices - JIRA Stories & Roadmap
## Story Points-Based Development Plan

**Document Version**: 2.0  
**Date**: May 21, 2026  
**Total Project Story Points**: ~1,145 SP  
**Estimated Duration**: 29 Weeks (40 points/week average with buffers)  
**Sprint Duration**: 2 weeks (average 65 points/sprint)
**AWS Account**: Free tier with 6 months free resources

---

## Table of Contents
1. [Story Point Estimation Guide](#story-point-estimation-guide)
2. [Phase 1: Foundation (Weeks 1-4)](#phase-1-foundation-weeks-1-4)
3. [Phase 2: Core Services (Weeks 5-8)](#phase-2-core-services-weeks-5-8)
4. [Phase 3: Business Logic Services (Weeks 9-12)](#phase-3-business-logic-services-weeks-9-12)
5. [Phase 4: Resilience & Advanced Features (Weeks 13-14)](#phase-4-resilience--advanced-features-weeks-13-14)
6. [Phase 5: Security & Authentication (Week 15)](#phase-5-security--authentication-week-15)
7. [Phase 6: Observability & Monitoring (Week 16)](#phase-6-observability--monitoring-week-16)
8. [Phase 7: Containerization & Orchestration (Week 17)](#phase-7-containerization--orchestration-week-17)
9. [Phase 8: Testing & Quality Assurance (Week 18)](#phase-8-testing--quality-assurance-week-18)
10. [Phase 9: CI/CD Pipeline (Week 19)](#phase-9-cicd-pipeline-week-19)
11. [Phase 10: Production Deployment (Week 20)](#phase-10-production-deployment-week-20)
12. [Phase 11: AWS Infrastructure & Cloud Migration (Weeks 21-26)](#phase-11-aws-infrastructure--cloud-migration-weeks-21-26)
13. [Phase 12: React UI Development with TypeScript (Weeks 27-33)](#phase-12-react-ui-development-with-typescript-weeks-27-33)

---

## Story Point Estimation Guide

**Story Point Scale:**
- **1 SP**: Trivial (< 1 hour)
- **2 SP**: Very Easy (1-2 hours)
- **3 SP**: Easy (2-4 hours)
- **5 SP**: Medium (4-8 hours)
- **8 SP**: Hard (8-16 hours, 2-3 days)
- **13 SP**: Very Hard (16-32 hours, 4-5 days)
- **21 SP**: Epic/Breaking Down (Needs to be split)

**Assumptions:**
- Development team velocity: ~50 SP per 2-week sprint
- 1 Sprint = 2 weeks = 10 SP average/week
- Team size: 5-7 developers + DevOps + QA

---

# PHASE 1: FOUNDATION (Weeks 1-4)
**Total Story Points: 89 SP**
**Priority: CRITICAL**

---

## EPIC-1.1: Project Setup & Infrastructure
**Epic Story Points: 34 SP**

### STORY-1.1.1: Setup Maven Multi-Module Project Structure
**Story Points**: 8  
**Priority**: CRITICAL  
**Assignee Type**: Lead Developer / Architect  
**Sprint**: Sprint 1  

**Description**:
Create the Maven parent-child module structure for the microservices platform with dependency management.

**Acceptance Criteria**:
- [ ] Parent POM created with Spring Boot BOM, Cloud dependencies
- [ ] Common-lib module created with shared utilities, DTOs, exceptions
- [ ] Individual service modules created (user, product, order, cart, payment, notification, review, inventory, shipping, admin, saga-orchestrator)
- [ ] Dependency versions managed in parent POM
- [ ] All modules successfully build and compile
- [ ] Maven enforcer plugin configured to prevent dependency conflicts
- [ ] Common library JAR published to local repository

**Technical Details**:
```
- Parent POM: Spring Boot 3.x, Spring Cloud 2023.x
- Common-lib dependencies: Lombok, Validation API, JSON utilities
- Plugin management: Spring Boot Maven Plugin, Docker Maven Plugin
- Properties: Java 21, Maven 3.9+
```

**Subtasks**:
1. Create parent POM with BOM imports
2. Create common-lib module structure
3. Add shared exception classes
4. Add shared DTOs (ApiResponse, ErrorResponse, PaginatedResponse)
5. Configure dependency management
6. Create service module stubs

**Dependencies**: None

---

### STORY-1.1.2: Create Common Library Module
**Story Points**: 5  
**Priority**: CRITICAL  
**Assignee Type**: Backend Developer  
**Sprint**: Sprint 1  

**Description**:
Develop the common-lib containing shared utilities, exceptions, DTOs, and constants used across all services.

**Acceptance Criteria**:
- [ ] Exception hierarchy implemented (ServiceException, BusinessException, ResourceNotFound, ValidationException)
- [ ] Standard DTOs created (ApiResponse, ErrorResponse, PaginatedResponse, PageRequest)
- [ ] Constants classes created (ApiConstants, CacheKeyConstants, ErrorCodeConstants)
- [ ] Utility classes created (DateUtil, ValidationUtil, EntityDtoMapper)
- [ ] Common configurations created (JwtConfig, CacheConfig, FeignClientConfig)
- [ ] Unit tests for all utilities (>80% coverage)
- [ ] JAR builds successfully and is reusable

**Technical Details**:
```java
- Dependencies: Lombok, Jakarta Validation, Jackson, Spring Core
- Key classes:
  - com.ecommerce.common.exception.*
  - com.ecommerce.common.dto.*
  - com.ecommerce.common.config.*
  - com.ecommerce.common.util.*
```

**Subtasks**:
1. Create exception hierarchy
2. Design and implement DTOs
3. Create utility classes
4. Add validation annotations
5. Create common configurations
6. Write unit tests for utilities
7. Document common module usage

**Dependencies**: STORY-1.1.1

---

### STORY-1.1.3: Setup Eureka Service Discovery Server
**Story Points**: 8  
**Priority**: CRITICAL  
**Assignee Type**: DevOps / Backend Developer  
**Sprint**: Sprint 1  

**Description**:
Setup Spring Cloud Netflix Eureka server for service discovery and registration.

**Acceptance Criteria**:
- [ ] Eureka server instance runs on port 8761
- [ ] High availability configuration (peer-to-peer replication)
- [ ] Eureka dashboard accessible at http://localhost:8761
- [ ] Service registration timeout configured (default 30 seconds)
- [ ] Health check interval set (15 seconds)
- [ ] Lease renewal interval configured (30 seconds)
- [ ] Development environment configuration created
- [ ] Docker image builds successfully
- [ ] Kubernetes manifest created for deployment

**Technical Details**:
```
- Port: 8761
- Configuration: Enable/disable self-registration
- Registry fetch interval: 5 seconds
- Lease expiration: 90 seconds
- Self-preservation: Enabled by default
```

**Subtasks**:
1. Create eureka-server module
2. Add Eureka server dependency
3. Configure application.yml
4. Add @EnableEurekaServer annotation
5. Configure peer-to-peer replication (optional)
6. Create Dockerfile for Eureka
7. Create Kubernetes deployment manifest
8. Test service registration/deregistration

**Dependencies**: STORY-1.1.1

---

### STORY-1.1.4: Setup Spring Cloud Config Server
**Story Points**: 8  
**Priority**: CRITICAL  
**Assignee Type**: DevOps / Backend Developer  
**Sprint**: Sprint 1  

**Description**:
Setup Spring Cloud Config Server for centralized configuration management without restart.

**Acceptance Criteria**:
- [ ] Config server runs on port 8888
- [ ] Git repository configured as backend
- [ ] Configuration files for each environment created (dev, staging, prod)
- [ ] Clients can fetch and refresh configuration
- [ ] Configuration encryption support enabled
- [ ] Actuator refresh endpoint functional
- [ ] Docker image builds successfully
- [ ] Kubernetes manifest created

**Technical Details**:
```
- Port: 8888
- Backend: Git repository or file-based
- Encryption key configured
- Actuator endpoints exposed: /actuator/refresh
- Search paths: classpath:/config/{application}-{profile}.yml
```

**Subtasks**:
1. Create config-server module
2. Configure Git/file backend
3. Create application-dev.yml, application-staging.yml
4. Add encryption support
5. Configure actuator endpoints
6. Test @RefreshScope functionality
7. Create Dockerfile
8. Create Kubernetes deployment manifest

**Dependencies**: STORY-1.1.1

---

### STORY-1.1.5: Create API Gateway with Spring Cloud Gateway
**Story Points**: 13  
**Priority**: CRITICAL  
**Assignee Type**: Backend Developer (Senior)  
**Sprint**: Sprint 1-2  

**Description**:
Implement API Gateway as single entry point with routing, JWT validation, rate limiting, and CORS support.

**Acceptance Criteria**:
- [ ] Gateway runs on port 8080
- [ ] Route configuration created for all services
- [ ] JWT validation filter implemented
- [ ] Rate limiting per service configured (30-50 req/min)
- [ ] CORS policy configured
- [ ] Request/response logging implemented
- [ ] Health check endpoints available
- [ ] Circuit breaker pattern integrated
- [ ] Load balancing across service instances
- [ ] Error handling with proper HTTP status codes
- [ ] Docker image builds successfully
- [ ] Kubernetes manifest created

**Technical Details**:
```
- Framework: Spring Cloud Gateway
- Port: 8080
- Routes: Dynamic discovery via Eureka
- Filters: JWT, RateLimiter, Logging
- Rate Limiter: Redis backend for distributed counting
- CORS: Allow specified origins, methods, headers
```

**Subtasks**:
1. Create api-gateway module
2. Configure route definitions
3. Implement JWT validation filter
4. Add rate limiting filter
5. Configure CORS
6. Implement logging filter
7. Add request/response transformation
8. Configure error handling
9. Test all routes
10. Create Dockerfile
11. Create Kubernetes manifest
12. Add monitoring annotations

**Dependencies**: STORY-1.1.1, STORY-1.1.3, STORY-1.1.4

---

## EPIC-1.2: Data Infrastructure Setup
**Epic Story Points: 21 SP**

---

### STORY-1.2.1: Setup PostgreSQL Databases for Each Service
**Story Points**: 8  
**Priority**: CRITICAL  
**Assignee Type**: Database Administrator / DevOps  
**Sprint**: Sprint 2  

**Description**:
Create PostgreSQL instances for each microservice, ensuring database isolation per service pattern.

**Acceptance Criteria**:
- [ ] 9 PostgreSQL databases created (user_db, product_db, order_db, cart_db, payment_db, notification_db, review_db, inventory_db, shipping_db)
- [ ] Connection strings configured for development environment
- [ ] Multi-AZ setup for production (future)
- [ ] Backup strategy documented
- [ ] Connection pooling configured (25-50 connections per service)
- [ ] Query timeout set (30 seconds)
- [ ] Logging/slow query logging enabled
- [ ] Docker Compose file includes all PostgreSQL instances
- [ ] Database health check scripts created

**Technical Details**:
```
- Version: PostgreSQL 16
- Encoding: UTF-8
- Timezone: UTC
- Connection pool: HikariCP, 25-50 connections
- Query timeout: 30 seconds
- Slow query log: > 1000ms
```

**Subtasks**:
1. Create Docker Compose PostgreSQL services
2. Create database initialization scripts
3. Configure connection pooling
4. Setup backup procedures
5. Create health check scripts
6. Document database connection details
7. Test failover procedures (optional)
8. Configure replication for prod

**Dependencies**: None

---

### STORY-1.2.2: Setup Redis Cache Layer
**Story Points**: 5  
**Priority**: HIGH  
**Assignee Type**: Backend Developer / DevOps  
**Sprint**: Sprint 2  

**Description**:
Setup Redis cluster for caching, session management, and rate limiting across services.

**Acceptance Criteria**:
- [ ] Redis instance runs on port 6379
- [ ] Persistence enabled (RDB snapshots)
- [ ] MaxMemory policy configured (evict-lru)
- [ ] Connection pooling configured (connection pool size 20-30)
- [ ] Cluster mode disabled for dev (single instance)
- [ ] Docker image configured
- [ ] Spring Cache integration tested
- [ ] TTL configuration for different data types
- [ ] Sentinel setup for HA (production)

**Technical Details**:
```
- Port: 6379
- Persistence: RDB (Snapshots every hour)
- MaxMemory: 512MB (dev), 4GB+ (prod)
- TTL: Products (10 min), Sessions (30 min), Rate limits (1 min)
- Client: Lettuce with Spring Data Redis
```

**Subtasks**:
1. Create Docker Compose Redis service
2. Configure persistence (RDB)
3. Setup maxMemory and eviction policy
4. Configure Spring Cache manager
5. Create cache configuration class
6. Test cache operations
7. Setup monitoring alerts
8. Document cache key naming conventions

**Dependencies**: STORY-1.1.1

---

### STORY-1.2.3: Configure Kafka Message Broker
**Story Points**: 8  
**Priority**: HIGH  
**Assignee Type**: Backend Developer / DevOps  
**Sprint**: Sprint 2  

**Description**:
Setup Apache Kafka for asynchronous event-driven communication between services.

**Acceptance Criteria**:
- [ ] Kafka broker runs on port 9092
- [ ] Zookeeper configured (port 2181)
- [ ] 9 Kafka topics created (order.*, inventory.*, notification.*, etc.)
- [ ] Replication factor set to 1 (dev), 3 (prod)
- [ ] Topic retention policy configured (7 days)
- [ ] Consumer group configurations created
- [ ] Spring Kafka integration configured
- [ ] Producer/Consumer templates created
- [ ] Docker Compose includes Kafka setup
- [ ] Topic initialization script created

**Technical Details**:
```
- Broker Port: 9092
- Zookeeper Port: 2181
- Topics: 9 topics as per LLD
- Partitions: 3 per topic (parallelism)
- Replication Factor: 1 (dev), 3 (prod)
- Retention: 7 days
- Spring Kafka: version 3.x
```

**Subtasks**:
1. Create Docker Compose Kafka/Zookeeper services
2. Create topic initialization script
3. Configure Spring Kafka producer
4. Configure Spring Kafka consumer
5. Create message serialization/deserialization
6. Implement error handling for Kafka
7. Setup monitoring for lag
8. Document consumer group strategy

**Dependencies**: STORY-1.1.1

---

## EPIC-1.3: Docker & Local Development Environment
**Epic Story Points: 34 SP**

---

### STORY-1.3.1: Create Docker Compose for Local Development
**Story Points**: 13  
**Priority**: CRITICAL  
**Assignee Type**: DevOps  
**Sprint**: Sprint 2-3  

**Description**:
Create comprehensive Docker Compose file for local development with all infrastructure services.

**Acceptance Criteria**:
- [ ] Docker Compose file includes: PostgreSQL (9 instances), Redis, Kafka, Zookeeper, Eureka, Config Server
- [ ] All services are networked properly
- [ ] Volume mounts for data persistence
- [ ] Health checks for all services
- [ ] Environment files for service configuration
- [ ] Services start in dependency order
- [ ] All services accessible on configured ports
- [ ] Commands documented (docker-compose up, down, logs)
- [ ] Resource limits configured (CPU, memory)
- [ ] README updated with setup instructions

**Technical Details**:
```yaml
Services:
- 9 PostgreSQL instances (5432 each)
- Redis (6379)
- Kafka (9092) + Zookeeper (2181)
- Eureka Server (8761)
- Config Server (8888)
- API Gateway (8080) [if running]
- Volumes: named volumes for persistence
- Networks: shared bridge network
```

**Subtasks**:
1. Create docker-compose.yml with all services
2. Create .env file for environment variables
3. Create health check scripts for each service
4. Configure volume mounts
5. Test complete stack startup
6. Optimize resource usage
7. Create backup scripts
8. Document troubleshooting steps
9. Create wipe/reset scripts
10. Test on multiple OS (Windows, Mac, Linux)

**Dependencies**: STORY-1.2.1, STORY-1.2.2, STORY-1.2.3

---

### STORY-1.3.2: Create Dockerfile for Microservices
**Story Points**: 8  
**Priority**: CRITICAL  
**Assignee Type**: DevOps / Backend Developer  
**Sprint**: Sprint 2-3  

**Description**:
Create optimized Dockerfile template for all microservices with multi-stage builds and minimal image size.

**Acceptance Criteria**:
- [ ] Dockerfile template created (multi-stage build)
- [ ] Base image: eclipse-temurin:21-jre-alpine
- [ ] Image size < 300MB
- [ ] JVM parameters optimized (G1GC, heap size)
- [ ] HEALTHCHECK configured
- [ ] Log output to stdout
- [ ] Non-root user configured
- [ ] Proper signal handling (SIGTERM)
- [ ] Spring Boot jar layer caching optimized
- [ ] Tested with all services
- [ ] Build command documented

**Technical Details**:
```dockerfile
- Multi-stage build: builder stage + runtime stage
- Base: eclipse-temurin:21-jre-alpine
- JVM arguments: -XX:+UseG1GC -XX:MaxRAMPercentage=75
- Healthcheck: http://localhost:{port}/actuator/health
- User: app (non-root)
- Entrypoint: exec java ...
```

**Subtasks**:
1. Create Dockerfile template
2. Optimize layer caching
3. Configure healthcheck
4. Setup non-root user
5. Test image for all services
6. Verify image size
7. Test container startup
8. Create image build script
9. Document image tagging strategy

**Dependencies**: STORY-1.1.1

---

### STORY-1.3.3: Setup Development Environment Documentation
**Story Points**: 5  
**Priority**: HIGH  
**Assignee Type**: Lead Developer / Technical Writer  
**Sprint**: Sprint 3  

**Description**:
Create comprehensive documentation for developer setup, including prerequisites, setup steps, and troubleshooting.

**Acceptance Criteria**:
- [ ] Prerequisites documented (JDK 21, Maven 3.9, Docker, Docker Compose)
- [ ] Step-by-step setup guide created
- [ ] Docker Compose startup instructions
- [ ] IDE setup instructions (IntelliJ, VS Code)
- [ ] How to run individual services locally
- [ ] Common issues and solutions documented
- [ ] How to access services (URLs, credentials)
- [ ] Debugging instructions
- [ ] Contribution guidelines
- [ ] Code style guide
- [ ] Git workflow explained

**Technical Details**:
```
- Documentation format: Markdown
- Location: README.md + DEVELOPMENT.md
- Include: Architecture diagram, service URLs, credentials
- Commands: All setup/teardown commands provided
```

**Subtasks**:
1. Create DEVELOPMENT.md
2. Write prerequisites section
3. Write setup step-by-step guide
4. Add Docker Compose instructions
5. Add IDE setup instructions
6. Create common issues section
7. Add debugging tips
8. Create code style guide
9. Document git workflow
10. Review and validate instructions

**Dependencies**: STORY-1.3.1, STORY-1.3.2

---

### STORY-1.3.4: Create Kubernetes Namespace & ConfigMaps
**Story Points**: 8  
**Priority**: HIGH  
**Assignee Type**: DevOps / Kubernetes Admin  
**Sprint**: Sprint 3  

**Description**:
Create Kubernetes namespace for eCommerce application and ConfigMaps for environment-specific configurations.

**Acceptance Criteria**:
- [ ] Kubernetes namespace 'ecommerce' created
- [ ] ConfigMaps created for each service (configuration)
- [ ] Environment-specific ConfigMaps (dev, staging, prod)
- [ ] Database connection strings configured in ConfigMaps
- [ ] Kafka broker endpoints configured
- [ ] Redis connection details configured
- [ ] Log level configurations
- [ ] Service discovery URLs
- [ ] All ConfigMaps labeled appropriately
- [ ] Namespace quotas configured (resource limits)
- [ ] YAML manifests validated

**Technical Details**:
```yaml
Namespace: ecommerce
ConfigMaps:
- user-service-config
- product-service-config
- order-service-config
- ... (one per service)
- shared-config (common settings)
```

**Subtasks**:
1. Create namespace.yml
2. Create ConfigMap templates
3. Create ConfigMaps for each service
4. Create ConfigMaps for shared config
5. Add environment-specific variants
6. Configure resource quotas
7. Configure network policies (basic)
8. Validate all YAML manifests
9. Test ConfigMap mounting
10. Document ConfigMap update procedures

**Dependencies**: STORY-1.3.2

---

# PHASE 2: CORE SERVICES (Weeks 5-8)
**Total Story Points: 120 SP**
**Services to Build**: User, Product, Cart, Inventory Services

---

## EPIC-2.1: User Service Implementation
**Epic Story Points: 34 SP**

---

### STORY-2.1.1: Implement User Service - Database Schema
**Story Points**: 5  
**Priority**: CRITICAL  
**Assignee Type**: Database Administrator / Backend Developer  
**Sprint**: Sprint 3  

**Description**:
Create database schema for User Service including users, roles, permissions, addresses tables.

**Acceptance Criteria**:
- [ ] All tables created: users, roles, permissions, user_roles, role_permissions, user_addresses, user_sessions, user_audit_log
- [ ] Foreign key constraints defined
- [ ] Indexes created for frequently queried columns
- [ ] Enum types defined (BUYER, SELLER, VENDOR, etc.)
- [ ] Audit timestamp columns added
- [ ] Soft delete columns added (deleted_at)
- [ ] Migration script created (Flyway)
- [ ] Schema validated for integrity
- [ ] Data types optimized
- [ ] Documentation updated

**Technical Details**:
```sql
Tables: users, roles, permissions, user_roles, role_permissions, 
        user_addresses, user_sessions, user_audit_log
Migration Tool: Flyway (V1__create_user_schema.sql)
Indexes: username, email, status
Enums: USER_TYPE, USER_STATUS
```

**Subtasks**:
1. Design schema based on LLD
2. Create Flyway migration file
3. Define all tables
4. Add constraints and indexes
5. Create enum types
6. Add audit columns
7. Validate schema relationships
8. Create rollback migration
9. Test migration execution
10. Document schema

**Dependencies**: STORY-1.2.1

---

### STORY-2.1.2: Implement User Service - Authentication Endpoints
**Story Points**: 13  
**Priority**: CRITICAL  
**Assignee Type**: Backend Developer (Senior)  
**Sprint**: Sprint 3-4  

**Description**:
Implement authentication endpoints: register, login, logout, refresh token with JWT support.

**Acceptance Criteria**:
- [ ] POST /v1/auth/register endpoint implemented
- [ ] POST /v1/auth/login endpoint implemented
- [ ] POST /v1/auth/logout endpoint implemented
- [ ] POST /v1/auth/refresh-token endpoint implemented
- [ ] JWT token generated with correct claims
- [ ] Access token (15-30 min expiry) and refresh token (7-30 days)
- [ ] Password hashing with BCrypt
- [ ] Input validation on all endpoints
- [ ] Error handling (duplicate email, invalid credentials)
- [ ] Rate limiting (5-10 req/min)
- [ ] Unit tests (>80% coverage)
- [ ] Integration tests
- [ ] Swagger documentation generated
- [ ] Docker image builds

**Technical Details**:
```java
- JWT Library: jjwt 0.12.x
- Signing Algorithm: RS256 (RSA)
- Password Encoding: BCrypt (strength 12)
- Token Claims: sub, email, roles, permissions, iat, exp
- Refresh mechanism: Redis-stored refresh tokens
```

**Subtasks**:
1. Create User entity and repository
2. Implement AuthService with login/register logic
3. Create JWT token provider
4. Implement password hashing
5. Create user validation logic
6. Implement logout (token invalidation)
7. Implement refresh token mechanism
8. Create error handling
9. Add rate limiting decorator
10. Write unit tests
11. Write integration tests
12. Create Swagger documentation
13. Test endpoints manually

**Dependencies**: STORY-2.1.1, STORY-1.1.4, STORY-1.1.3

---

### STORY-2.1.3: Implement User Service - Profile Management APIs
**Story Points**: 8  
**Priority**: HIGH  
**Assignee Type**: Backend Developer  
**Sprint**: Sprint 4  

**Description**:
Implement user profile management endpoints: get profile, update profile, manage addresses, role assignment.

**Acceptance Criteria**:
- [ ] GET /v1/users/{userId} endpoint
- [ ] PUT /v1/users/{userId} endpoint
- [ ] POST /v1/users/{userId}/addresses endpoint
- [ ] GET /v1/users/{userId}/addresses endpoint
- [ ] PUT /v1/users/{userId}/roles endpoint (Admin only)
- [ ] Authorization checked (self or admin)
- [ ] Input validation
- [ ] CQRS read model updated via Kafka
- [ ] Cache invalidation on update
- [ ] Audit logging enabled
- [ ] Unit tests
- [ ] Integration tests
- [ ] Swagger documentation

**Technical Details**:
```java
- Authorization: Spring @PreAuthorize
- Caching: @Cacheable with 5 min TTL
- Validation: Jakarta Validation annotations
- CQRS: Event published to Kafka on user updates
- Audit: Spring Data Envers or custom audit log
```

**Subtasks**:
1. Create UserController
2. Implement get profile logic
3. Implement update profile logic
4. Implement address management
5. Implement role assignment (admin)
6. Add authorization checks
7. Add caching
8. Add audit logging
9. Publish Kafka events
10. Write unit tests
11. Write integration tests

**Dependencies**: STORY-2.1.2

---

### STORY-2.1.4: Implement User Service - RBAC & Permissions
**Story Points**: 8  
**Priority**: HIGH  
**Assignee Type**: Backend Developer (Senior)  
**Sprint**: Sprint 4  

**Description**:
Implement role-based access control with 4 roles (Admin, User, Vendor, Developer) and permissions matrix.

**Acceptance Criteria**:
- [ ] 4 roles created: ADMIN, USER, VENDOR, DEVELOPER
- [ ] Permissions table populated with resource-action pairs
- [ ] Role-permission mapping implemented
- [ ] Spring Security integration with custom UserDetailsService
- [ ] @PreAuthorize annotations on protected endpoints
- [ ] Permission evaluation logic implemented
- [ ] Role hierarchy defined
- [ ] Custom permission evaluator created
- [ ] Authorization tests
- [ ] Swagger documentation with required roles

**Technical Details**:
```
Roles:
- ADMIN: Full access
- USER: Browse, order, manage profile
- VENDOR: Manage products, view sales
- DEVELOPER: API access, webhooks

Permissions: CHECK format (resource:action)
- products:read, products:create, orders:read, etc.
```

**Subtasks**:
1. Create Role entity
2. Create Permission entity
3. Create RolePermission mapping
4. Implement UserDetailsService
5. Create GrantedAuthority mapper
6. Create permission evaluator
7. Add @PreAuthorize annotations
8. Create permission validation tests
9. Document permission matrix
10. Test RBAC enforcement

**Dependencies**: STORY-2.1.1, STORY-2.1.2

---

## EPIC-2.2: Product Service Implementation
**Epic Story Points: 30 SP**

---

### STORY-2.2.1: Implement Product Service - Database Schema
**Story Points**: 5  
**Priority**: CRITICAL  
**Assignee Type**: Database Administrator / Backend Developer  
**Sprint**: Sprint 4  

**Description**:
Create database schema for Product Service with categories, products, images, variants.

**Acceptance Criteria**:
- [ ] All tables created: categories, products, product_images, product_tags, product_variants
- [ ] Full-text search index on products
- [ ] Generated columns for calculated fields (final_price)
- [ ] Indexes on frequently queried columns
- [ ] Foreign key constraints
- [ ] Enum types (status: ACTIVE, INACTIVE, DISCONTINUED)
- [ ] Migration script created
- [ ] Schema validated
- [ ] Parent-child relationships for categories
- [ ] Documentation updated

**Technical Details**:
```sql
Tables: categories, products, product_images, product_tags, 
        product_variants
Indexes: category_id, seller_id, status, full-text search
Generated Columns: final_price = base_price * (100-discount)/100
```

**Subtasks**:
1. Design product schema
2. Create Flyway migration
3. Define all tables
4. Add constraints and indexes
5. Create full-text search indexes
6. Add category hierarchy
7. Validate relationships
8. Create rollback migration
9. Test migration

**Dependencies**: STORY-1.2.1

---

### STORY-2.2.2: Implement Product Service - Catalog APIs
**Story Points**: 13  
**Priority**: CRITICAL  
**Assignee Type**: Backend Developer (Senior)  
**Sprint**: Sprint 4-5  

**Description**:
Implement product catalog APIs: list products with filtering, get product details, create/update/delete products.

**Acceptance Criteria**:
- [ ] GET /v1/products with filters (category, search, price, rating)
- [ ] GET /v1/products with pagination
- [ ] GET /v1/products with sorting
- [ ] GET /v1/products/{productId}
- [ ] POST /v1/products (Seller/Vendor/Admin)
- [ ] PUT /v1/products/{productId} (owner)
- [ ] DELETE /v1/products/{productId} (owner/admin)
- [ ] GET /v1/categories
- [ ] Full-text search implemented
- [ ] Caching optimized (5-10 min TTL)
- [ ] CQRS read model triggered
- [ ] Rate limiting enforced
- [ ] Authorization enforced
- [ ] Unit tests (>80%)
- [ ] Swagger documentation

**Technical Details**:
```java
- Database: Full-text search on product name/description
- Framework: Spring Data JPA with custom queries
- Caching: Redis with smart invalidation
- CQRS: Event published on product CRUD
- Pagination: Offset + Limit (max 100)
- Sorting: name, price, rating, created_at
```

**Subtasks**:
1. Create Product entity and repository
2. Implement ProductService
3. Create ProductController
4. Implement list with pagination
5. Implement filters (category, search, price)
6. Implement sorting
7. Implement create product
8. Implement update product
9. Implement delete product (soft delete)
10. Add authorization checks
11. Add caching
12. Publish Kafka events
13. Write unit tests
14. Write integration tests
15. Create Swagger docs

**Dependencies**: STORY-2.2.1, STORY-1.1.4

---

### STORY-2.2.3: Implement Product Service - Category & Variant Management
**Story Points**: 12  
**Priority**: HIGH  
**Assignee Type**: Backend Developer  
**Sprint**: Sprint 5  

**Description**:
Implement category hierarchy and product variant management (sizes, colors, etc.).

**Acceptance Criteria**:
- [ ] Category hierarchy (parent-child) implemented
- [ ] GET categories endpoint with nested structure
- [ ] POST category endpoint (admin)
- [ ] PUT category endpoint
- [ ] DELETE category endpoint
- [ ] Product variants management implemented
- [ ] Variant pricing support (additional_price)
- [ ] Variant SKU management
- [ ] GET product with variants
- [ ] CQRS updates on category/variant changes
- [ ] Caching optimized
- [ ] Unit tests
- [ ] Integration tests

**Technical Details**:
```java
- Category Hierarchy: Self-referencing through parent_category_id
- Variants: Generate unique SKU combinations
- Pricing: Base price + variant surcharge
- Caching: Category hierarchy cached for 1 hour
```

**Subtasks**:
1. Create Category entity
2. Implement category hierarchy logic
3. Create ProductVariant entity
4. Implement variant management
5. Handle variant pricing
6. Generate variant SKUs
7. Create endpoints for category CRUD
8. Create endpoints for variant CRUD
9. Add authorization checks
10. Add caching
11. Publish Kafka events
12. Write tests

**Dependencies**: STORY-2.2.1, STORY-2.2.2

---

## EPIC-2.3: Cart Service Implementation
**Epic Story Points: 28 SP**

---

### STORY-2.3.1: Implement Cart Service - Database Schema & Redis Caching
**Story Points**: 8  
**Priority**: CRITICAL  
**Assignee Type**: Backend Developer  
**Sprint**: Sprint 5  

**Description**:
Create cart schema and Redis-backed session storage for active shopping carts.

**Acceptance Criteria**:
- [ ] Cart tables created: shopping_carts, cart_items, abandoned_carts_analytics
- [ ] Unique constraint on user_id (one active cart per user)
- [ ] Cart expiration logic (30 days)
- [ ] Indexes on user_id, expires_at
- [ ] Redis integration for active carts (session cache)
- [ ] Cart TTL in Redis (30 minutes)
- [ ] Fallback to database if Redis unavailable
- [ ] Migration script created
- [ ] Cache warming strategy defined
- [ ] Unit tests

**Technical Details**:
```
Database: PostgreSQL cart schema
Cache: Redis with session duration TTL (30 min)
Key Format: cart:{userId}
Fallback: Read from DB if cache miss
```

**Subtasks**:
1. Create cart schema
2. Create Flyway migration
3. Implement Redis cache integration
4. Create cart cache wrapper
5. Implement fallback logic
6. Add expiration logic
7. Create abandoned cart tracking
8. Write integration tests

**Dependencies**: STORY-1.2.1, STORY-1.2.2

---

### STORY-2.3.2: Implement Cart Service - Shopping Cart APIs
**Story Points**: 20  
**Priority**: CRITICAL  
**Assignee Type**: Backend Developer (Senior)  
**Sprint**: Sprint 5-6  

**Description**:
Implement shopping cart APIs: get cart, add/remove items, update quantities, checkout.

**Acceptance Criteria**:
- [ ] GET /v1/carts/{cartId} endpoint
- [ ] POST /v1/carts/{cartId}/items endpoint
- [ ] DELETE /v1/carts/{cartId}/items/{itemId} endpoint
- [ ] PUT /v1/carts/{cartId}/items/{itemId} endpoint (update qty)
- [ ] POST /v1/carts/{cartId}/checkout endpoint
- [ ] DELETE /v1/carts/{cartId} endpoint (clear cart)
- [ ] Cart totals calculation (subtotal, tax, shipping estimate)
- [ ] Stock availability check (call Inventory Service)
- [ ] Authorization (user can only access own cart)
- [ ] Rate limiting (20 req/min)
- [ ] Validation on quantity, product availability
- [ ] Abandoned cart detection
- [ ] CQRS read model updates
- [ ] Redis caching
- [ ] Unit tests (>80%)
- [ ] Integration tests
- [ ] Swagger documentation

**Technical Details**:
```java
- API Gateway routing: /v1/carts -> cart-service
- Data Access: Redis (primary) + PostgreSQL (backup)
- Validation: Stock check via Inventory Service (Feign)
- Calculations: Subtotal, tax estimate, shipping estimate
- Session: User context from JWT in API Gateway
- Error handling: OutOfStockException, CartNotFound
```

**Subtasks**:
1. Create Cart entity
2. Create CartItem entity
3. Create CartService
4. Create CartController
5. Implement get cart
6. Implement add to cart
7. Implement remove from cart
8. Implement update quantity
9. Implement checkout initiation
10. Implement cart totals calculation
11. Add stock availability check
12. Add authorization
13. Add rate limiting
14. Add caching
15. Publish Kafka events
16. Write unit tests
17. Write integration tests
18. Create Swagger docs

**Dependencies**: STORY-2.3.1, STORY-2.2.2, STORY-1.1.5

---

## EPIC-2.4: Inventory Service Implementation
**Epic Story Points: 28 SP**

---

### STORY-2.4.1: Implement Inventory Service - Database Schema
**Story Points**: 5  
**Priority**: CRITICAL  
**Assignee Type**: Database Administrator / Backend Developer  
**Sprint**: Sprint 6  

**Description**:
Create inventory schema with warehouses, stock levels, reservations, and movement tracking.

**Acceptance Criteria**:
- [ ] Tables created: warehouses, inventory, stock_movements, reserved_inventory
- [ ] Warehouse table with location and capacity info
- [ ] Inventory table with available/reserved/damaged quantities
- [ ] Stock movement audit trail
- [ ] Reservation table for order-related holds
- [ ] Indexes on product_id, warehouse_id, status
- [ ] Constraints for quantity validation (>= 0)
- [ ] Generated column for total_quantity
- [ ] Migration script created
- [ ] Schema validated

**Technical Details**:
```sql
Tables: warehouses, inventory, stock_movements, reserved_inventory
Quantities: available, reserved, damaged, total (generated)
Indexes: product_id, warehouse_id, status
```

**Subtasks**:
1. Design inventory schema
2. Create Flyway migration
3. Define all tables
4. Add constraints
5. Create indexes
6. Add generated columns
7. Validate schema

**Dependencies**: STORY-1.2.1

---

### STORY-2.4.2: Implement Inventory Service - Stock Management APIs
**Story Points**: 23  
**Priority**: CRITICAL  
**Assignee Type**: Backend Developer (Senior)  
**Sprint**: Sprint 6-7  

**Description**:
Implement inventory APIs: get stock, reserve inventory, release inventory, update stock, warehouse management.

**Acceptance Criteria**:
- [ ] GET /v1/inventory/{productId} endpoint
- [ ] GET /v1/inventory/{productId}?warehouse_id=x endpoint
- [ ] POST /v1/inventory/reserve endpoint (internal)
- [ ] POST /v1/inventory/release endpoint (internal)
- [ ] PUT /v1/inventory/{productId} endpoint (vendor)
- [ ] GET /v1/warehouses endpoint
- [ ] Reservation expiry logic (30 seconds)
- [ ] Stock availability check
- [ ] Reservation ID generation
- [ ] Inventory movement audit trail
- [ ] Redis cache for real-time stock (short TTL: 30s)
- [ ] Fallback to database
- [ ] Concurrent access handling (pessimistic locking)
- [ ] Underselling prevention
- [ ] Authorization enforced
- [ ] Error handling (OutOfStock, ReservationFailed)
- [ ] Unit tests (>80%)
- [ ] Integration tests
- [ ] Swagger docs

**Technical Details**:
```java
- Concurrency: Pessimistic locking with @Lock(LockModeType.PESSIMISTIC_WRITE)
- Cache: Redis key = inventory:{productId}:{warehouseId}, TTL 30s
- Reservation: Auto-expiry after 30 seconds if not consumed
- Events: Published to Kafka on reserve/release
- Feign: Called from Cart/Order services
```

**Subtasks**:
1. Create Warehouse entity
2. Create Inventory entity
3. Create StockMovement entity
4. Create ReservedInventory entity
5. Create InventoryService
6. Implement stock level queries
7. Implement reservation logic
8. Implement release logic
9. Implement stock update
10. Add reservation expiry logic
11. Add concurrent access handling
12. Create InventoryController
13. Add rate limiting
14. Add authorization
15. Add caching
16. Publish Kafka events
17. Write unit tests
18. Write integration tests
19. Create endpoints for warehouses
20. Test concurrent operations

**Dependencies**: STORY-2.4.1, STORY-1.2.2, STORY-1.1.5

---

# PHASE 3: BUSINESS LOGIC SERVICES (Weeks 9-12)
**Total Story Points: 140 SP**
**Services to Build**: Order, Payment, Notification, Review, Shipping, Saga Orchestrator

---

## EPIC-3.1: Order Service Implementation with CQRS
**Epic Story Points: 40 SP**

---

### STORY-3.1.1: Implement Order Service - Database Schema with CQRS
**Story Points**: 8  
**Priority**: CRITICAL**
**Assignee Type**: Database Administrator / Backend Developer  
**Sprint**: Sprint 7  

**Description**:
Create order service schema including orders, order items, invoices, returns, and CQRS read models.

**Acceptance Criteria**:
- [ ] Tables created: orders, order_items, order_events, invoices, order_returns
- [ ] Order status enum (PENDING, CONFIRMED, PROCESSING, SHIPPED, DELIVERED, CANCELLED, REFUNDED)
- [ ] Payment/Shipping status enums
- [ ] Generated columns for final_amount calculation
- [ ] JSONB columns for addresses
- [ ] Indexes on buyer_id, order_status, created_at
- [ ] Foreign key constraints
- [ ] Audit logging table
- [ ] CQRS read model table structure (denormalized order view)
- [ ] Migration script created
- [ ] Schema validated

**Technical Details**:
```sql
Write Model: orders, order_items, order_events
Read Model: order_summary_view (denormalized for reporting)
Addresses: JSONB format (billing, shipping)
Indexes: buyer_id, order_status, created_at DESC
```

**Subtasks**:
1. Design order schema
2. Create Flyway migration
3. Define order-related tables
4. Define CQRS read model table
5. Add constraints and indexes
6. Add audit columns
7. Validate schema

**Dependencies**: STORY-1.2.1

---

### STORY-3.1.2: Implement Order Service - Order Creation & Management APIs
**Story Points**: 32  
**Priority**: CRITICAL  
**Assignee Type**: Backend Developer (Senior)  
**Sprint**: Sprint 7-8  

**Description**:
Implement order creation, retrieval, and management APIs with CQRS and Saga orchestration.

**Acceptance Criteria**:
- [ ] POST /v1/orders endpoint (create order from cart)
- [ ] GET /v1/orders/{orderId} endpoint
- [ ] GET /v1/orders endpoint (list user orders with pagination)
- [ ] PUT /v1/orders/{orderId}/status endpoint (admin)
- [ ] POST /v1/orders/{orderId}/cancel endpoint
- [ ] POST /v1/orders/{orderId}/return endpoint
- [ ] Order number generation (unique, formatted)
- [ ] Saga orchestration initiated on order creation
- [ ] CQRS read model updated via Kafka events
- [ ] Cart cleared after order creation
- [ ] Order totals calculated correctly
- [ ] Authorization enforced
- [ ] Rate limiting (5 req/min)
- [ ] Input validation
- [ ] Error handling (cart not found, insufficient stock)
- [ ] Async payment initiation
- [ ] Kafka events published (order.created, order.updated)
- [ ] Unit tests (>80%)
- [ ] Integration tests
- [ ] Swagger documentation

**Technical Details**:
```java
- Saga Orchestrator Integration: RestTemplate or Feign to trigger saga
- CQRS: Event published to Kafka on order state change
- Payment: Async via Saga, updates via Kafka events
- Inventory: Reserve via Saga  
- Notifications: Async via Kafka
- Read Model: Updated by dedicated consumer
```

**Subtasks**:
1. Create Order entity
2. Create OrderItem entity
3. Create OrderService
4. Create OrderController
5. Implement order creation logic
6. Generate order numbers
7. Calculate totals
8. Implement get order
9. Implement list orders with pagination
10. Implement update order status
11. Implement order cancellation
12. Implement return request
13. Initiate Saga on creation
14. Publish Kafka events
15. Update CQRS read model
16. Add authorization
17. Add rate limiting
18. Add validation and error handling
19. Write unit tests
20. Write integration tests
21. Create Swagger docs
22. Test Saga integration

**Dependencies**: STORY-3.1.1, STORY-2.3.2, STORY-2.4.2, STORY-1.1.5

---

## EPIC-3.2: Payment Service Implementation
**Epic Story Points: 28 SP**

---

### STORY-3.2.1: Implement Payment Service - Database Schema
**Story Points**: 5  
**Priority**: CRITICAL  
**Assignee Type**: Database Administrator  
**Sprint**: Sprint 8  

**Description**:
Create payment service schema with payment records, refunds, and payment methods.

**Acceptance Criteria**:
- [ ] Tables created: payments, refunds, user_payment_methods
- [ ] Payment status enum (PENDING, INITIATED, PROCESSING, COMPLETED, FAILED, REFUNDED)
- [ ] Refund status enum
- [ ] JSONB for gateway_response
- [ ] Indexes on order_id, payment_id, status
- [ ] Foreign key constraints
- [ ] Unique constraint on payment_id
- [ ] Migration script created
- [ ] Schema for storing masked card details

**Technical Details**:
```sql
Tables: payments, refunds, user_payment_methods
Status Enums: For payment and refund tracking
JSONB: Gateway responses and metadata
```

**Subtasks**:
1. Design payment schema
2. Create Flyway migration
3. Define tables
4. Add constraints and indexes
5. Validate schema

**Dependencies**: STORY-1.2.1

---

### STORY-3.2.2: Implement Payment Service - Payment Processing APIs
**Story Points**: 23  
**Priority**: CRITICAL  
**Assignee Type**: Backend Developer (Senior)  
**Sprint**: Sprint 8-9  

**Description**:
Implement payment processing APIs: process payment, get payment status, refund payment (simulated with logic).

**Acceptance Criteria**:
- [ ] POST /v1/payments endpoint (process payment)
- [ ] GET /v1/payments/{paymentId} endpoint
- [ ] POST /v1/payments/{paymentId}/refund endpoint (admin)
- [ ] Payment simulation logic (random success/failure based on amount)
- [ ] Async processing with Kafka events
- [ ] Payment status updates in database
- [ ] Refund processing and updates
- [ ] Gateway response storage (JSONB)
- [ ] Error messages logged
- [ ] Idempotency key support
- [ ] Amount validation
- [ ] Authorization enforced
- [ ] Rate limiting
- [ ] Kafka events published (payment-processed, payment-failed)
- [ ] Unit tests
- [ ] Integration tests (mock payment gateway)
- [ ] Swagger documentation

**Technical Details**:
```java
- Service Token: Only callable from Saga Orchestrator
- Simulation: Random failure rate based on business logic
- Idempotency: Prevent duplicate payments for same order
- Async: Payment completes asynchronously, status polled via events
- Events: payment.success, payment.failed published to Kafka
```

**Subtasks**:
1. Create Payment entity
2. Create Refund entity
3. Create PaymentService
4. Create PaymentController
5. Implement payment processing (simulated)
6. Implement payment status check
7. Implement refund logic
8. Add idempotency support
9. Add amount validation
10. Store gateway responses
11. Publish Kafka events
12. Add error handling
13. Add authorization (service token)
14. Add rate limiting
15. Write unit tests
16. Write integration tests
17. Create Swagger docs

**Dependencies**: STORY-3.2.1, STORY-1.1.3, STORY-1.1.4

---

## EPIC-3.3: Notification Service Implementation
**Epic Story Points: 24 SP**

---

### STORY-3.3.1: Implement Notification Service - Database Schema
**Story Points**: 3  
**Priority**: HIGH  
**Assignee Type**: Database Administrator  
**Sprint**: Sprint 9  

**Description**:
Create notification service schema for storing notification records and templates.

**Acceptance Criteria**:
- [ ] Tables created: notifications, notification_templates, user_notification_preferences
- [ ] Notification status enum (PENDING, SENT, DELIVERED, FAILED, BOUNCED)
- [ ] Channel enum (EMAIL, SMS, PUSH, IN_APP)
- [ ] Notification type enum
- [ ] JSONB for template variables
- [ ] Indexes on recipient_id, status, notification_type
- [ ] Retry count tracking
- [ ] Migration script

**Technical Details**:
```sql
Tables: notifications, notification_templates, user_notification_preferences
Channels: EMAIL, SMS, PUSH, IN_APP
```

**Subtasks**:
1. Design notification schema
2. Create Flyway migration
3. Define tables
4. Add constraints and indexes
5. Validate schema

**Dependencies**: STORY-1.2.1

---

### STORY-3.3.2: Implement Notification Service - Email & SMS APIs
**Story Points**: 21  
**Priority**: HIGH  
**Assignee Type**: Backend Developer  
**Sprint**: Sprint 9-10  

**Description**:
Implement notification service with email and SMS sending capabilities via Kafka consumers.

**Acceptance Criteria**:
- [ ] POST /v1/notifications/email/send endpoint
- [ ] POST /v1/notifications/sms/send endpoint
- [ ] GET /v1/notifications/{notificationId} endpoint
- [ ] Kafka consumer for order.* events (auto-send notifications)
- [ ] Kafka consumer for payment.* events
- [ ] Kafka consumer for shipment.* events
- [ ] Notification templates supported
- [ ] Template variable substitution
- [ ] Retry mechanism (3 retries with exponential backoff)
- [ ] Mock email provider (in-memory or console logging)
- [ ] Mock SMS provider
- [ ] User notification preferences respected
- [ ] Status tracking (PENDING -> SENT/FAILED)
- [ ] Error handling and cleanup
- [ ] Async processing
- [ ] Unit tests
- [ ] Integration tests (with embedded Kafka)
- [ ] Swagger docs

**Technical Details**:
```java
- Kafka Consumers: notification-group, subscribed to order/payment/shipment topics
- Providers: AWS SES mock + SMS mock (can swap with real later)
- Templates: Database-driven templates with variable substitution
- Retry: Spring Retry with exponential backoff
- Status: Tracked in database, updated after send attempts
```

**Subtasks**:
1. Create Notification entity
2. Create NotificationTemplate entity
3. Create NotificationService
4. Create NotificationController
5. Implement email sending endpoint
6. Implement SMS sending endpoint
7. Implement Kafka consumer for order events
8. Implement Kafka consumer for payment events
9. Implement Kafka consumer for shipment events
10. Create email/SMS providers (mock)
11. Implement template substitution
12. Add retry logic
13. Respect user preferences
14. Track notification status
15. Add error handling
16. Write unit tests
17. Write integration tests
18. Create Swagger docs

**Dependencies**: STORY-3.3.1, STORY-1.2.3

---

## EPIC-3.4: Review & Rating Service
**Epic Story Points: 24 SP**

---

### STORY-3.4.1: Implement Review Service - Database Schema
**Story Points**: 5  
**Priority**: HIGH  
**Assignee Type**: Database Administrator  
**Sprint**: Sprint 10  

**Description**:
Create review service schema with reviews, ratings, and responses.

**Acceptance Criteria**:
- [ ] Tables created: reviews, review_images, review_responses, review_helpfulness
- [ ] Rating validation (1-5)
- [ ] Review status enum (APPROVED, PENDING, REJECTED, WITHDRAWN)
- [ ] Indexes on product_id, reviewer_id, rating, created_at
- [ ] Foreign key constraints
- [ ] Unique constraints on review_id, user can only review once per product per purchase
- [ ] Helpful/unhelpful count tracking
- [ ] Migration script

**Technical Details**:
```sql
Tables: reviews, review_images, review_responses, review_helpfulness
Rating: 1-5 constraint Check
```

**Subtasks**:
1. Design review schema
2. Create Flyway migration
3. Define tables
4. Add constraints
5. Add indexes

**Dependencies**: STORY-1.2.1

---

### STORY-3.4.2: Implement Review Service - Review Management APIs
**Story Points**: 19  
**Priority**: HIGH  
**Assignee Type**: Backend Developer  
**Sprint**: Sprint 10-11  

**Description**:
Implement review APIs: create review, get reviews, update/delete, seller responses, helpful voting.

**Acceptance Criteria**:
- [ ] POST /v1/reviews endpoint (create)
- [ ] GET /v1/reviews endpoint (list with filters)
- [ ] PUT /v1/reviews/{reviewId} endpoint (update by reviewer)
- [ ] DELETE /v1/reviews/{reviewId} endpoint (delete by reviewer/admin)
- [ ] POST /v1/reviews/{reviewId}/responses endpoint (seller/admin response)
- [ ] PUT /v1/reviews/{reviewId}/helpful endpoint (mark helpful)
- [ ] Review approval workflow (PENDING -> APPROVED)
- [ ] Only verified buyers can review
- [ ] Prevent duplicate reviews
- [ ] CQRS read model for rating aggregation
- [ ] Caching (5 min TTL)
- [ ] Authorization enforced
- [ ] Input validation
- [ ] Unit tests
- [ ] Integration tests
- [ ] Swagger docs

**Technical Details**:
```java
- Verified Buyer Check: Validate order_id from Order Service
- CQRS: Aggregate rating updated on review approval/rejection
- Cache: Review list cached per product (5 min, evicted on new review)
- Moderation: New reviews PENDING, require approval
```

**Subtasks**:
1. Create Review entity
2. Create ReviewService
3. Create ReviewController
4. Implement create review
5. Implement list reviews with pagination
6. Implement review approval workflow
7. Implement seller responses
8. Implement helpful voting
9. Add verified buyer check
10. Prevent duplicate reviews
11. Add authorization
12. Add caching
13. Aggregate ratings via CQRS
14. Update product rating
15. Write unit tests
16. Write integration tests
17. Create Swagger docs

**Dependencies**: STORY-3.4.1, STORY-3.1.2

---

## EPIC-3.5: Shipping Service Implementation
**Epic Story Points: 24 SP**

---

### STORY-3.5.1: Implement Shipping Service - Database Schema
**Story Points**: 5  
**Priority**: HIGH  
**Assignee Type**: Database Administrator  
**Sprint**: Sprint 11  

**Description**:
Create shipping service schema with shipments, tracking, and events.

**Acceptance Criteria**:
- [ ] Tables created: shipments, shipment_items, shipment_events
- [ ] Shipment status enum
- [ ] Tracking number generation
- [ ] Indexes on order_id, tracking_number, shipment_status
- [ ] JSONB for delivery address
- [ ] Estimated/actual delivery date fields
- [ ] Migration script

**Technical Details**:
```sql
Tables: shipments, shipment_items, shipment_events
Status: PENDING, PICKED, PACKED, SHIPPED, IN_TRANSIT, DELIVERED, etc.
```

**Subtasks**:
1. Design shipping schema
2. Create Flyway migration
3. Define tables
4. Add constraints and indexes
5. Validate schema

**Dependencies**: STORY-1.2.1

---

### STORY-3.5.2: Implement Shipping Service - Shipment Management APIs
**Story Points**: 19  
**Priority**: HIGH  
**Assignee Type**: Backend Developer  
**Sprint**: Sprint 11-12  

**Description**:
Implement shipment APIs: create shipment, get shipment details, track shipment, update status.

**Acceptance Criteria**:
- [ ] POST /v1/shipments endpoint (internal, called by Saga)
- [ ] GET /v1/shipments/{shipmentId} endpoint
- [ ] GET /v1/tracking/{trackingNumber} endpoint (public)
- [ ] PUT /v1/shipments/{shipmentId}/status endpoint (internal)
- [ ] Tracking number generation
- [ ] Shipment event tracking
- [ ] Estimated delivery calculation
- [ ] Carrier integration mock (can upgrade later)
- [ ] Status updates via events
- [ ] Shipment history
- [ ] CQRS read model updated
- [ ] Caching (1 min, updates frequently)
- [ ] Authorization enforced
- [ ] Rate limiting
- [ ] Unit tests
- [ ] Integration tests
- [ ] Swagger docs

**Technical Details**:
```java
- Service Token: Only Saga Orchestrator can create
- Tracking: Public endpoint, no auth required
- Carrier: Mock carrier (random tracking updates)
- Events: Shipment events tracked for audit trail
- Cache: Short TTL (1 min) as tracking updates frequently
```

**Subtasks**:
1. Create Shipment entity
2. Create ShipmentService
3. Create ShipmentController
4. Implement shipment creation
5. Implement tracking number generation
6. Implement get shipment details
7. Implement get shipment by tracking
8. Implement status update
9. Implement event tracking
10. Calculate estimated delivery
11. Mock carrier integration
12. Add CQRS updates
13. Add caching (short TTL)
14. Write unit tests
15. Write integration tests
16. Create Swagger docs

**Dependencies**: STORY-3.5.1, STORY-1.1.3

---

## EPIC-3.6: Saga Orchestrator Implementation
**Epic Story Points: 40 SP**

---

### STORY-3.6.1: Implement Saga Orchestrator - State Management & Database
**Story Points**: 8  
**Priority**: CRITICAL  
**Assignee Type**: Backend Developer (Senior)  
**Sprint**: Sprint 11  

**Description**:
Create Saga state machine and database for tracking distributed transaction state.

**Acceptance Criteria**:
- [ ] SagaState entity created with state tracking
- [ ] SagaState table with saga_id, status, retry_count, fail_reason
- [ ] Status enum (RUNNING, COMPENSATING, COMPLETED, FAILED)
- [ ] Timestamps for audit trail
- [ ] Indexed by saga_id
- [ ] Idempotency support
- [ ] Saga state repository implemented
- [ ] Migration script
- [ ] State serialization/deserialization

**Technical Details**:
```sql
- SagaState: saga_id (unique), status, step_state, retry_count
- Step tracking: Current step executed, results
- Timeline: created_at, updated_at for audit
```

**Subtasks**:
1. Design SagaState schema
2. Create Flyway migration
3. Create SagaState entity
4. Create SagaStateRepository
5. Add state management logic
6. Add audit fields
7. Implement idempotency checks

**Dependencies**: STORY-1.2.1

---

### STORY-3.6.2: Implement Order Processing Saga Orchestration
**Story Points**: 32  
**Priority**: CRITICAL  
**Assignee Type**: Backend Developer (Senior)  
**Sprint**: Sprint 11-12  

**Description**:
Implement Order Processing Saga orchestrator with step orchestration, compensation, and Kafka integration.

**Acceptance Criteria**:
- [ ] OrderProcessingSaga service created
- [ ] Saga triggered on order creation
- [ ] Step 1: Inventory reservation (with timeout)
- [ ] Step 2: Payment processing (with timeout)
- [ ] Step 3: Shipment creation (with timeout)
- [ ] Compensation chain implemented (rollback on any failure)
- [ ] Timeout handlers for each step
- [ ] Retry logic with exponential backoff
- [ ] Saga state persisted
- [ ] Idempotence ensured
- [ ] Kafka events listened for step completion
- [ ] Order status updated based on saga progress
- [ ] Error handling and notifications
- [ ] Logging of saga execution
- [ ] Unit tests
- [ ] Integration tests (with embedded Kafka)
- [ ] Swagger docs

**Technical Details**:
```java
- Pattern: Orchestration (centralized orchestrator)
- State Machine: STARTED -> INVENTORY_RESERVED -> PAYMENT_COMPLETED -> 
                 SHIPMENT_CREATED -> COMPLETED
- Compensation: Reverse order if any step fails
- Timeouts: Inventory 30s, Payment 60s, Shipment 30s
- Idempotency: Check saga state before executing step
- Kafka: Listen for service completion events
```

**Subtasks**:
1. Create OrderProcessingSaga service
2. Implement saga workflow orchestration
3. Implement inventory reservation step
4. Implement payment processing step
5. Implement shipment creation step
6. Implement compensation logic
7. Add timeout handlers
8. Add retry logic
9. Add state persistence
10. Add idempotency checks
11. Add Kafka event listeners
12. Add error handling
13. Add logging and monitoring hooks
14. Write unit tests
15. Write integration tests (with embedded Kafka)
16. Create Swagger docs/documentation

**Dependencies**: STORY-3.6.1, STORY-3.1.2, STORY-3.2.2, STORY-3.5.2

---

# PHASE 4: RESILIENCE & ADVANCED FEATURES (Weeks 13-14)
**Total Story Points: 68 SP**

---

## EPIC-4.1: Resilience4j Implementation
**Epic Story Points: 26 SP**

---

### STORY-4.1.1: Implement Resilience4j - Circuit Breaker Pattern
**Story Points**: 13  
**Priority**: HIGH  
**Assignee Type**: Backend Developer (Senior)  
**Sprint**: Sprint 13  

**Description**:
Implement circuit breaker pattern for all inter-service communication using Resilience4j.

**Acceptance Criteria**:
- [ ] Circuit breaker configured on all Feign clients
- [ ] Failure threshold set (5 failures)
- [ ] Slow call threshold configured (>2 seconds)
- [ ] States implemented (CLOSED, OPEN, HALF_OPEN)
- [ ] Fallback methods defined
- [ ] Metrics exposed to Prometheus
- [ ] Custom event listeners for state changes
- [ ] Configuration via application.yml
- [ ] Different settings per service dependency
- [ ] Manual circuit breaker reset capability
- [ ] Actuator endpoints for monitoring
- [ ] Unit tests
- [ ] Integration tests

**Technical Details**:
```yaml
Resilience4j:
- Failure Threshold: 5 failures
- Slow Call Threshold: 2 seconds
- State Transitions: CLOSED -> OPEN (on failure) -> HALF_OPEN (after wait time)
- Wait Duration in Open State: 60 seconds
- Max Attempts in Half-Open: 3
```

**Subtasks**:
1. Add Resilience4j dependency
2. Configure circuit breaker for each Feign client
3. Implement fallback methods
4. Add event listeners
5. Configure metrics export
6. Add actuator endpoints
7. Test state transitions
8. Write unit tests
9. Write integration tests
10. Document configuration

**Dependencies**: STORY-1.1.5, STORY-3.1.2

---

### STORY-4.1.2: Implement Resilience4j - Retry & Rate Limiter
**Story Points**: 13  
**Priority**: HIGH  
**Assignee Type**: Backend Developer  
**Sprint**: Sprint 13  

**Description**:
Implement retry mechanism and rate limiting using Resilience4j.

**Acceptance Criteria**:
- [ ] Retry policy configured with exponential backoff
- [ ] Max retry attempts: 3
- [ ] Initial wait time: 100ms
- [ ] Exponential backoff multiplier: 1.5
- [ ] Rate limiter configured for each service
- [ ] Limit: 100 requests per service
- [ ] Time window: 1 minute
- [ ] Queue capacity: 10
- [ ] Custom rejection handler
- [ ] Metrics exposed
- [ ] Configuration per endpoint
- [ ] Unit tests
- [ ] Integration tests

**Technical Details**:
```yaml
Retry:
- Max Attempts: 3
- Initial Wait: 100ms
- Multiplier: 1.5x

Rate Limiter:
- Limit Per Interval: 100 reqs
- Time Interval: 1 minute
- Timeout Duration: 5 seconds
```

**Subtasks**:
1. Add retry configuration
2. Add rate limiter configuration
3. Apply to Feign clients
4. Implement rejection handlers
5. Configure metrics
6. Test retry behavior
7. Test rate limiting
8. Write unit tests
9. Write integration tests

**Dependencies**: STORY-4.1.1

---

## EPIC-4.2: Feign Client Implementation
**Epic Story Points: 25 SP**

---

### STORY-4.2.1: Implement Feign Clients for Service-to-Service Communication
**Story Points**: 25  
**Priority**: HIGH  
**Assignee Type**: Backend Developer (Senior)  
**Sprint**: Sprint 13-14  

**Description**:
Implement OpenFeign clients for synchronous inter-service communication with resilience patterns.

**Acceptance Criteria**:
- [ ] Feign clients created for all service dependencies
- [ ] User Service client (from Cart, Order)
- [ ] Product Service client (from Cart, Inventory, Order)
- [ ] Inventory Service client (from Order, Cart)
- [ ] Payment Service client (from Saga Orchestrator)
- [ ] Shipping Service client (from Saga Orchestrator)
- [ ] Circuit breaker integrated with each client
- [ ] Fallback implementations provided
- [ ] Request/response interceptors added
- [ ] Error decoding custom
- [ ] Request logging
- [ ] Timeout configured (2-5 seconds)
- [ ] Retry logic from Resilience4j
- [ ] Unit tests (mock clients)
- [ ] Integration tests (with @FeignClient mocking)

**Technical Details**:
```java
- Framework: OpenFeign with Spring Cloud integration
- Load Balancing: Ribbon/Eureka
- Resilience: Resilience4j circuit breaker + retry
- Timeout: 2-5 seconds per client
- Fallback: Graceful degradation where possible
- Logging: DEBUG level for request/response
```

**Subtasks**:
1. Create UserServiceClient (Feign interface)
2. Create ProductServiceClient
3. Create InventoryServiceClient
4. Create PaymentServiceClient
5. Create ShippingServiceClient
6. Add circuit breaker to each
7. Implement fallback methods
8. Add request interceptors
9. Add error decoders
10. Configure timeouts
11. Add logging
12. Write unit tests (mock)
13. Write integration tests
14. Document client usage patterns

**Dependencies**: STORY-4.1.1, STORY-3.1.2

---

## EPIC-4.3: Caching & Performance
**Epic Story Points: 17 SP**

---

### STORY-4.3.1: Implement Redis Caching Layer with Cache-Aside Pattern
**Story Points**: 17  
**Priority**: HIGH  
**Assignee Type**: Backend Developer  
**Sprint**: Sprint 14  

**Description**:
Implement comprehensive caching strategy with Redis using cache-aside pattern for frequently accessed data.

**Acceptance Criteria**:
- [ ] Cache configuration created (Spring Cache with Redis)
- [ ] @Cacheable annotations on read methods
- [ ] @CacheEvict annotations on write/delete methods
- [ ] @CachePut annotations where needed
- [ ] Cache key naming strategy implemented
- [ ] Different TTLs for different data types
- [ ] Cache statistics tracked
- [ ] Cache warming for critical data
- [ ] Manual cache invalidation capability
- [ ] Fallback if Redis unavailable
- [ ] Cache metrics exposed to Prometheus
- [ ] Spring Cloud Cache abstraction
- [ ] Unit tests for cache behavior
- [ ] Integration tests with Redis

**Technical Details**:
```
Cache TTLs:
- Products: 10 minutes
- User Profiles: 5 minutes
- Cart: 30 minutes (session)
- Rate Limiter Counters: 1 minute
- Categories: 60 minutes
- Reviews: 5 minutes

Cache Key Format: {serviceName}:{entityType}:{id}
Example: product-service:product:1001
```

**Subtasks**:
1. Create CacheConfig with Redis manager
2. Add @Cacheable to read methods
3. Add @CacheEvict to write methods
4. Implement cache key naming
5. Configure different TTLs
6. Implement cache warming
7. Add manual invalidation endpoints
8. Configure fall back logic
9. Export cache metrics
10. Write cache behavior tests
11. Write Redis integration tests
12. Monitor cache hit/miss ratio

**Dependencies**: STORY-1.2.2

---

# PHASE 5: SECURITY & AUTHENTICATION (Week 15)
**Total Story Points: 40 SP**

---

## EPIC-5.1: JWT Security Implementation
**Epic Story Points: 25 SP**

---

### STORY-5.1.1: Implement JWT Token Generation & Validation
**Story Points**: 13  
**Priority**: CRITICAL  
**Assignee Type**: Backend Developer (Senior)  
**Sprint**: Sprint 15  

**Description**:
Implement JWT token generation with RS256 signing and validation across all services.

**Acceptance Criteria**:
- [ ] JWT provider service created
- [ ] RS256 signing algorithm implemented (RSA key pair generated)
- [ ] Access token generation (15-30 min expiry)
- [ ] Refresh token generation (7-30 days expiry)
- [ ] Token claims: sub, email, roles, permissions, itat, exp
- [ ] Token validation logic
- [ ] Token expiration checking
- [ ] Token revocation support (blacklist in Redis)
- [ ] JWT secret management (AWS Secrets Manager)
- [ ] Key rotation capability
- [ ] Error handling (invalid token, expired token)
- [ ] Unit tests
- [ ] Integration tests

**Technical Details**:
```
Algorithm: RS256 (RSA with SHA-256)
Access Token: 15-30 minutes
Refresh Token: 7-30 days
Claims: sub, email, username, roles, permissions, iat, exp, iss, aud
Blacklist: Redis key = "token-blacklist:{token-hash}"
```

**Subtasks**:
1. Generate RSA key pair
2. Create JwtTokenProvider class
3. Implement token generation
4. Implement token validation
5. Add claims mapping
6. Add expiration checking
7. Add token revocation (blacklist)
8. Add secret management integration
9. Add error handling
10. Create bearer token extraction
11. Write unit tests
12. Write integration tests

**Dependencies**: STORY-1.2.2

---

### STORY-5.1.2: Implement JWT Authentication Filter in API Gateway
**Story Points**: 12  
**Priority**: CRITICAL  
**Assignee Type**: Backend Developer  
**Sprint**: Sprint 15  

**Description**:
Implement authentication filter in API Gateway for JWT validation and token refresh.

**Acceptance Criteria**:
- [ ] JwtAuthenticationFilter created
- [ ] Token extraction from Authorization header
- [ ] Token validation before routing
- [ ] Automatic token refresh if expiring
- [ ] User context extracted and stored
- [ ] Request enrichment with user info
- [ ] Statistics: Valid tokens, invalid tokens, refreshed tokens
- [ ] Exclusion list for public endpoints
- [ ] Error responses (401 Unauthorized)
- [ ] CORS headers configured
- [ ] Unit tests
- [ ] Integration tests

**Technical Details**:
```java
- Annotations: @Component, extends OncePerRequestFilter
- Token Extraction: Authorization header, format "Bearer {token}"
- Refresh Logic: If token expires in next 5 min, refresh automatically
- User Context: Store in SecurityContext or ThreadLocal
- Public Endpoints: /auth/register, /auth/login, /products, /reviews, etc.
```

**Subtasks**:
1. Create JwtAuthenticationFilter
2. Implement token extraction
3. Implement token validation
4. Implement auto-refresh logic
5. Extract user context
6. Store in SecurityContext
7. Handle exceptions
8. Configure public endpoint exclusions
9. Add CORS support
10. Write unit tests
11. Write integration tests

**Dependencies**: STORY-5.1.1, STORY-1.1.5

---

## EPIC-5.2: Authorization & Permissions
**Epic Story Points: 15 SP**

---

### STORY-5.2.1: Implement RBAC with @PreAuthorize Annotations
**Story Points**: 15  
**Priority**: CRITICAL  
**Assignee Type**: Backend Developer  
**Sprint**: Sprint 15  

**Description**:
Implement role-based and permission-based authorization across all service endpoints.

**Acceptance Criteria**:
- [ ] @PreAuthorize annotations on all protected endpoints
- [ ] Role checks: ADMIN, USER, VENDOR, DEVELOPER
- [ ] Permission checks: resource:action format
- [ ] Custom authorization expressions
- [ ] AdminOnly methods protected
- [ ] OwnershipCheck for user-specific resources
- [ ] Access denied responses (403 Forbidden)
- [ ] Audit logging of authorization failures
- [ ] Method-level security configured
- [ ] Unit tests for authorization
- [ ] Integration tests

**Technical Details**:
```java
Annotations:
- @PreAuthorize("hasRole('ADMIN')")
- @PreAuthorize("hasAuthority('products:create')")
- @PreAuthorize("hasRole('ADMIN') or @userService.isOwner(#userId)")

Endpoints Protected:
- Admin endpoints: POST/PUT/DELETE
- User-specific: Get own profile, orders, addresses
- Public: GET products, GET reviews, GET categories
```

**Subtasks**:
1. Create custom authorization expressions
2. Create method-level security
3. Apply @PreAuthorize to endpoints
4. Create ownership validators
5. Create admin check utilities
6. Add authorization failure logging
7. Test authorization on all endpoints
8. Write authorization tests
9. Write integration tests
10. Document authorization rules

**Dependencies**: STORY-5.1.2, STORY-2.1.4

---

# PHASE 6: OBSERVABILITY & MONITORING (Week 16)
**Total Story Points: 50 SP**

---

## EPIC-6.1: Prometheus Metrics & Grafana Dashboards
**Epic Story Points: 25 SP**

---

### STORY-6.1.1: Setup Prometheus Metrics & Micrometer Integration
**Story Points**: 13  
**Priority**: HIGH  
**Assignee Type**: DevOps / Backend Developer  
**Sprint**: Sprint 16  

**Description**:
Configure Micrometer for metrics collection and Prometheus for time-series data storage.

**Acceptance Criteria**:
- [ ] Micrometer dependency added to all services
- [ ] Prometheus endpoint enabled (/actuator/prometheus)
- [ ] Custom metrics defined (business metrics)
- [ ] HTTP request metrics (latency, status codes)
- [ ] Database query metrics
- [ ] Kafka producer/consumer metrics
- [ ] Cache hit/miss ratio metrics
- [ ] JVM metrics (memory, GC, threads)
- [ ] Circuit breaker metrics
- [ ] Metrics with labels (service, endpoint, status)
- [ ] Unit tests for custom metrics
- [ ] Prometheus scraping configured
- [ ] Docker image for Prometheus created

**Technical Details**:
```java
Metrics Collected:
- HTTP requests: duration, count, status
- Database: query time, connection pool
- Kafka: lag, throughput, partitions
- Cache: hits, misses, evictions
- JVM: memory, GC, threads
- Business: orders/min, conversion rate

Prometheus Scrape:
- Interval: 15 seconds
- Timeout: 10 seconds
- Targets: All services on port 8080/actuator/prometheus
```

**Subtasks**:
1. Add Micrometer dependency
2. Configure Prometheus endpoint
3. Define custom business metrics
4. Configure HTTP metrics
5. Configure database metrics
6. Configure cache metrics
7. Configure Kafka metrics
8. Add service labels
9. Create Prometheus Docker image
10. Configure Prometheus scrape targets
11. Write metric tests
12. Test metrics collection

**Dependencies**: STORY-1.1.3

---

### STORY-6.1.2: Create Grafana Dashboards for Monitoring
**Story Points**: 12  
**Priority**: HIGH  
**Assignee Type**: DevOps  
**Sprint**: Sprint 16  

**Description**:
Create Grafana dashboards for visualizing system metrics and performance.

**Acceptance Criteria**:
- [ ] Grafana instance deployed
- [ ] Prometheus data source configured
- [ ] Dashboard: Service Health Overview
- [ ] Dashboard: Request Latency (p95, p99)
- [ ] Dashboard: Error Rates by Service
- [ ] Dashboard: Database Performance
- [ ] Dashboard: Cache Hit Ratio
- [ ] Dashboard: Kafka Consumer Lag
- [ ] Dashboard: JVM Memory & GC
- [ ] Dashboard: Business KPIs (orders/min, conversion)
- [ ] Alerts configured for critical thresholds
- [ ] Grafana provisioning automated
- [ ] Dashboard templates created

**Technical Details**:
```
Dashboards:
1. System Overview: Uptime, requests/sec, error rate
2. Service Performance: Latency, status codes, throughput
3. Resource Usage: CPU, memory, disk
4. Database: Query time, connections, locks
5. Business Metrics: Orders, revenue, conversion rate
```

**Subtasks**:
1. Deploy Grafana
2. Configure Prometheus datasource
3. Create service health dashboard
4. Create latency dashboard
5. Create error rate dashboard
6. Create resource usage dashboard
7. Create database dashboard
8. Create business KPI dashboard
9. Configure alerts
10. Setup alert notifications
11. Test dashboard functionality
12. Document dashboard interpretation

**Dependencies**: STORY-6.1.1

---

## EPIC-6.2: Distributed Tracing
**Epic Story Points: 12 SP**

---

### STORY-6.2.1: Implement Zipkin Distributed Tracing for Critical Paths
**Story Points**: 12  
**Priority**: HIGH  
**Assignee Type**: Backend Developer / DevOps  
**Sprint**: Sprint 16  

**Description**:
Implement distributed tracing with Spring Cloud Sleuth and Zipkin for critical transaction flows.

**Acceptance Criteria**:
- [ ] Spring Cloud Sleuth added to all services
- [ ] Zipkin server deployed
- [ ] Trace ID propagation across services
- [ ] Span ID tracking
- [ ] Baggage context propagation
- [ ] Sampling configured (10% for dev, 1% for prod)
- [ ] HTTP client tracing (Feign)
- [ ] Database query tracing
- [ ] Kafka producer/consumer tracing
- [ ] Custom span annotations
- [ ] Trace export to Zipkin
- [ ] Docker image for Zipkin
- [ ] Unit tests for tracing
- [ ] Critical path traces visible in UI

**Technical Details**:
```java
Critical Paths Traced:
1. Order Creation: API Gateway -> Order Service -> Inventory -> Payment -> Shipping
2. Authentication: API Gateway -> User Service -> JWT validation
3. Product Search: API Gateway -> Product Service -> Cache/DB

Sampling: 10% (dev), 1% (prod)
Trace Retention: 7 days
```

**Subtasks**:
1. Add Spring Cloud Sleuth dependency
2. Configure trace ID propagation
3. Configure sampling
4. Deploy Zipkin server
5. Configure Zipkin exporter
6. Add customer span tracing
7. Trace HTTP calls (Feign)
8. Trace database calls
9. Trace Kafka calls
10. Test trace propagation
11. View traces in Zipkin UI
12. Document critical paths

**Dependencies**: STORY-6.1.1

---

## EPIC-6.3: Centralized Logging with Splunk
**Epic Story Points: 13 SP**

---

### STORY-6.3.1: Configure Splunk Logging & Log Aggregation
**Story Points**: 13  
**Priority**: HIGH  
**Assignee Type**: DevOps / Backend Developer  
**Sprint**: Sprint 16  

**Description**:
Setup centralized logging with Splunk for log aggregation and analysis.

**Acceptance Criteria**:
- [ ] Logback configuration with Splunk appender
- [ ] JSON-formatted logs for structured logging
- [ ] Log levels: ERROR, WARN, INFO, DEBUG
- [ ] Splunk HEC (HTTP Event Collector) configured
- [ ] Log enrichment: trace ID, span ID, user ID, service name
- [ ] Index configuration: separate indices per environment
- [ ] Log retention: 30 days
- [ ] Search patterns for common queries
- [ ] Alerts for error patterns
- [ ] Dashboard for log analysis
- [ ] Unit tests for logging
- [ ] ELK stack (Elasticsearch, Logstash, Kibana) as alternative

**Technical Details**:
```json
Log Format (JSON):
{
  "timestamp": "2026-05-13T10:30:45Z",
  "level": "INFO",
  "service": "order-service",
  "traceId": "abc123",
  "userId": "user-456",
  "message": "Order created",
  "orderId": "order-789"
}

Splunk HEC:
- Token: Configured in application.yml
- Endpoint: https://splunk-server:8088
- Index: ecommerce-dev, ecommerce-staging, ecommerce-prod
```

**Subtasks**:
1. Add Logback Splunk appender
2. Configure JSON formatting
3. Configure Splunk HEC endpoint
4. Add log enrichment (trace ID, etc.)
5. Configure per-environment indices
6. Create Splunk searches
7. Setup alerts
8. Create Splunk dashboard
9. Configure ELK stack as alternative
10. Test log delivery
11. Verify Splunk indexing
12. Document log queries

**Dependencies**: STORY-1.1.3

---

# PHASE 7: CONTAINERIZATION & ORCHESTRATION (Week 17)
**Total Story Points: 65 SP**

---

## EPIC-7.1: Docker & Container Registry
**Epic Story Points: 26 SP**

---

### STORY-7.1.1: Build Docker Images for All Services
**Story Points**: 13  
**Priority**: CRITICAL  
**Assignee Type**: DevOps / Backend Developer  
**Sprint**: Sprint 17  

**Description**:
Build optimized Docker images for all microservices and push to Docker Hub.

**Acceptance Criteria**:
- [ ] Docker images built for all 11 services + supporting services
- [ ] Image size < 300MB each
- [ ] Multi-stage builds implemented
- [ ] JVM options optimized (-XX:+UseG1GC, MaxRAMPercentage=75)
- [ ] Health checks configured
- [ ] Non-root user configured
- [ ] Proper signal handling
- [ ] Startup time < 30 seconds
- [ ] Images pushed to Docker Hub with version tags
- [ ] Semantic versioning: v1.0.0, v1.0.1, etc.
- [ ] README.md per service image
- [ ] Build automation script created

**Technical Details**:
```
Images:
- user-service:1.0.0
- product-service:1.0.0
- order-service:1.0.0
- ... (11 services total)
- api-gateway:1.0.0
- eureka-server:1.0.0
- config-server:1.0.0

Registry: docker.io/{organization}/{service}:{version}
```

**Subtasks**:
1. Create optimized Dockerfile per service
2. Test multi-stage builds
3. Optimize layer caching
4. Configure healthChecks
5. Setup non-root user
6. Optimize JVM parameters
7. Build all images
8. Test image startup
9. Verify image sizes
10. Create build script
11. Push to Docker Hub
12. Tag with versions
13. Create image documentation

**Dependencies**: STORY-1.3.2

---

### STORY-7.1.2: Setup Kubernetes Manifests for All Services
**Story Points**: 13  
**Priority**: CRITICAL  
**Assignee Type**: DevOps / Kubernetes Admin  
**Sprint**: Sprint 17  

**Description**:
Create Kubernetes deployment manifests for all services with proper resource limits and health checks.

**Acceptance Criteria**:
- [ ] Deployment manifests created for 11 services
- [ ] Service manifests for networking
- [ ] ConfigMap manifests for configuration
- [ ] Secret manifests placeholders
- [ ] Resource requests/limits defined (CPU, memory)
- [ ] Health checks configured (liveness, readiness)
- [ ] Rolling update strategy defined
- [ ] Environment variables from ConfigMaps
- [ ] Service discovery via DNS
- [ ] Init containers for migrations (if needed)
- [ ] Node affinity/pod affinity rules
- [ ] Namespace isolation
- [ ] Labels and selectors properly configured
- [ ] YAML validation

**Technical Details**:
```yaml
Deployment:
- Replicas: 2-3 (min), 10 (max) with HPA
- Resource Limits: CPU 500m, Memory 512Mi
- Health Checks: liveness (30s), readiness (10s)
- Strategy: RollingUpdate (maxSurge: 1, maxUnavailable: 0)

Services:
- Type: ClusterIP
- Ports: Service port, target port
- Backend: Pods via label selector
```

**Subtasks**:
1. Create Deployment template
2. Create Service template
3. Configure resource limits
4. Configure health checks
5. Setup rolling updates
6. Configure environment variables
7. Create manifests for each service
8. Configure database init container
9. Setup ConfigMap references
10. Setup Secret references
11. Define labels and selectors
12. Validate all YAML
13. Test manifest deployment

**Dependencies**: STORY-1.3.4, STORY-7.1.1

---

## EPIC-7.2: Helm Charts
**Epic Story Points: 15 SP**

---

### STORY-7.2.1: Create Helm Charts for Service Deployment
**Story Points**: 15  
**Priority**: HIGH  
**Assignee Type**: DevOps / K8s Admin  
**Sprint**: Sprint 17  

**Description**:
Create Helm charts for templating and parameterizing Kubernetes deployments.

**Acceptance Criteria**:
- [ ] Helm chart structure created
- [ ] Service templates parameterized
- [ ] Values.yaml with customizable parameters
- [ ] Environment overrides (dev, staging, prod)
- [ ] Dependency management (if applicable)
- [ ] Secrets management integration
- [ ] ConfigMap handling
- [ ] Image tag versioning
- [ ] Replica scaling parameters
- [ ] Resource limits customizable
- [ ] Service type configurable
- [ ] Ingress configuration optional
- [ ] Chart validation
- [ ] Installation tested

**Technical Details**:
```yaml
Helm Chart Structure:
- ecommerce-platform/
  - Chart.yaml
  - values.yaml
  - templates/
    - deployment.yaml
    - service.yaml
    - ingress.yaml
    - configmap.yaml
    - secret.yaml

Values:
- environment: dev/staging/prod
- imageTag: v1.0.0
- replicas: 3
- resources: CPU, memory
```

**Subtasks**:
1. Create Helm chart structure
2. Create Chart.yaml
3. Create values.yaml
4. Create service templates
5. Create deployment templates
6. Create ConfigMap templates
7. Create Secret templates
8. Create Ingress template (optional)
9. Setup environment overrides
10. Add helper templates
11. Validate Helm chart
12. Test installation
13. Create Helm installation guide

**Dependencies**: STORY-7.1.2

---

## EPIC-7.3: Kubernetes Deployment & Setup
**Epic Story Points: 24 SP**

---

### STORY-7.3.1: Deploy to Development Kubernetes Cluster
**Story Points**: 24  
**Priority**: HIGH  
**Assignee Type**: DevOps / K8s Admin  
**Sprint**: Sprint 17  

**Description**:
Deploy all services to development Kubernetes cluster and verify functionality.

**Acceptance Criteria**:
- [ ] Kubernetes cluster created (EKS / minikube for dev)
- [ ] Namespace created (ecommerce)
- [ ] ConfigMaps deployed
- [ ] Secrets deployed
- [ ] All services deployed successfully
- [ ] Pods running and healthy
- [ ] Services accessible via DNS
- [ ] API Gateway accessible from outside cluster
- [ ] Databases accessible
- [ ] Kafka accessible
- [ ] Redis accessible
- [ ] Smoke tests passing
- [ ] End-to-end test flow passing
- [ ] Logs accessible via Splunk/logs command
- [ ] Metrics visible in Prometheus
- [ ] Traces visible in Zipkin

**Technical Details**:
```
Cluster: Single dev cluster with reduced resources
Deployment Order: 
1. Supporting infrastructure (Eureka, Config)
2. Data services (PostgreSQL, Redis, Kafka)
3. Core services (in dependency order)
4. API Gateway

Verification:
- kubectl get pods -n ecommerce (all running)
- kubectl logs deployment/order-service -n ecommerce
- curl http://api-gateway.ecommerce.svc.cluster.local:8080/v1/health
```

**Subtasks**:
1. Setup EKS cluster
2. Create namespace
3. Deploy ConfigMaps
4. Deploy Secrets
5. Deploy supporting services
6. Deploy data layer
7. Deploy microservices
8. Deploy API Gateway
9. Verify all pods healthy
10. Test service-to-service communication
11. Run smoke tests
12. Run end-to-end tests
13. Verify monitoring (metrics, logs, traces)
14. Create deployment checklist
15. Document access procedures

**Dependencies**: STORY-7.1.2, STORY-7.2.1

---

# PHASE 8: TESTING & QUALITY ASSURANCE (Week 18)
**Total Story Points: 75 SP**

---

## EPIC-8.1: Unit & Integration Testing
**Epic Story Points: 35 SP**

---

### STORY-8.1.1: Comprehensive Unit Testing (>80% Coverage)
**Story Points**: 20  
**Priority**: HIGH  
**Assignee Type**: QA / Backend Developer  
**Sprint**: Sprint 18  

**Description**:
Write unit tests for all services achieving >80% code coverage.

**Acceptance Criteria**:
- [ ] Unit tests written for all services
- [ ] Code coverage > 80% per service
- [ ] All business logic covered
- [ ] Edge cases tested
- [ ] Error scenarios tested
- [ ] JUnit 5 framework used
- [ ] Mockito for mocking
- [ ] Assertions and matchers used
- [ ] Tests run in CI pipeline
- [ ] Coverage reports generated

**Technical Details**:
```
Framework: JUnit 5, Mockito, Hamcrest matchers
Coverage Target: >80% per service
Running: mvn clean test, test reports in target/site/jacoco/
```

**Subtasks**:
1. Write tests for User Service
2. Write tests for Product Service
3. Write tests for Order Service
4. Write tests for Cart Service
5. Write tests for Inventory Service
6. Write tests for Payment Service
7. Write tests for Notification Service
8. Write tests for Review Service
9. Write tests for Shipping Service
10. Generate coverage reports
11. Identify untested code
12. Add tests for gaps
13. Verify >80% coverage

**Dependencies**: All service implementation stories

---

### STORY-8.1.2: Integration Testing with TestContainers
**Story Points**: 15  
**Priority**: HIGH  
**Assignee Type**: QA  
**Sprint**: Sprint 18  

**Description**:
Write integration tests using TestContainers for database and Kafka interactions.

**Acceptance Criteria**:
- [ ] TestContainers dependency added
- [ ] PostgreSQL container used for tests
- [ ] Redis container for cache tests
- [ ] Embedded Kafka for message tests
- [ ] Service integration tests
- [ ] Database transaction tests
- [ ] Kafka producer/consumer tests
- [ ] Feign client tests (with mockServer)
- [ ] Error scenarios tested
- [ ] Tests isolated and repeatable
- [ ] Tests run in CI pipeline (~10 min)

**Technical Details**:
```java
TestContainers:
- @Container PostgreSQL
- @Container Redis (optional)
- @Container Kafka
- Tests: e.g., OrderServiceIntegrationTest
```

**Subtasks**:
1. Add TestContainers dependency
2. Create Base integration test class
3. Write PostgreSQL container tests
4. Write Kafka container tests
5. Write Redis container tests (optional)
6. Write service integration tests
7. Test Feign clients (with MockServer)
8. Test database transactions
9. Test messaging flow
10. Test error scenarios
11. Run tests locally
12. Setup CI integration

**Dependencies**: All service implementation stories

---

## EPIC-8.2: End-to-End & Performance Testing
**Epic Story Points: 25 SP**

---

### STORY-8.2.1: End-to-End Testing of Critical Workflows
**Story Points**: 15  
**Priority**: HIGH  
**Assignee Type**: QA  
**Sprint**: Sprint 18  

**Description**:
Create end-to-end tests for critical business workflows (order creation, payment, notification).

**Acceptance Criteria**:
- [ ] E2E test for user registration and login
- [ ] E2E test for product search and browsing
- [ ] E2E test for add to cart
- [ ] E2E test for order creation flow
- [ ] E2E test for payment processing
- [ ] E2E test for order tracking
- [ ] E2E test for review submission
- [ ] Tests run against dev cluster
- [ ] Tests validate complete flow
- [ ] Error scenarios included
- [ ] Tests take ~30 seconds each
- [ ] Automated execution

**Technical Details**:
```
Tools: RestAssured, Cucumber (optional), or simple HTTP client
Tests: Against deployed services
Flow: API Gateway -> Services -> Database
```

**Subtasks**:
1. Create E2E test base class
2. Write registration E2E test
3. Write login E2E test
4. Write product search E2E test
5. Write add to cart E2E test
6. Write order creation E2E test
7. Write payment E2E test
8. Write tracking E2E test
9. Write review E2E test
10. Test error scenarios
11. Measure test execution time
12. Automate test execution

**Dependencies**: All services deployed to dev cluster

---

### STORY-8.2.2: Load & Performance Testing
**Story Points**: 10  
**Priority**: HIGH  
**Assignee Type**: QA / DevOps  
**Sprint**: Sprint 18  

**Description**:
Perform load testing to validate system handles expected peak load (100-1000 TPS).

**Acceptance Criteria**:
- [ ] Load testing tool configured (JMeter / Gatling)
- [ ] Test scenarios created (login, search, order)
- [ ] Ramp-up period: 5 minutes
- [ ] Peak load: 100 TPS (dev), scale to 1000 TPS target
- [ ] Duration: 30 minutes at peak
- [ ] Success rate > 99%
- [ ] Response time p95 < 500ms
- [ ] Response time p99 < 2 seconds
- [ ] Error rate < 0.5%
- [ ] System recovery after spike
- [ ] Resource utilization tracked (CPU, memory)
- [ ] No database connections leaked
- [ ] Bottlenecks identified

**Technical Details**:
```
Tool: Apache JMeter or Gatling
Load Pattern: Ramp-up 5 min, Peak 30 min, Ramp-down 5 min
Scenarios: Login, Product Search, Add to Cart, Order Creation
Success Criteria: p95 < 500ms, Error < 0.5%
```

**Subtasks**:
1. Setup JMeter/Gatling
2. Create test scenarios
3. Configure ramp-up/ramp-down
4. Run test against dev cluster
5. Collect metrics (latency, throughput, errors)
6. Analyze bottlenecks
7. Identify slow services
8. Tune configurations
9. Rerun tests
10. Document results

**Dependencies**: All services deployed to dev cluster

---

## EPIC-8.3: Security & Compliance Testing
**Epic Story Points: 15 SP**

---

### STORY-8.3.1: Security Testing (OWASP Top 10)
**Story Points**: 15  
**Priority**: HIGH  
**Assignee Type**: Security Tester / QA  
**Sprint**: Sprint 18  

**Description**:
Perform security testing covering OWASP Top 10 vulnerabilities.

**Acceptance Criteria**:
- [ ] SQL Injection testing
- [ ] XSS (Cross-Site Scripting) prevention verified
- [ ] CSRF (Cross-Site Request Forgery) protection verified
- [ ] Authentication bypass attempts
- [ ] Authorization boundary testing
- [ ] Rate limiting validation
- [ ] Input validation testing
- [ ] Password strength requirements
- [ ] Sensitive data exposure check (no PII in logs)
- [ ] Security headers verified
- [ ] HTTPS/TLS enforcement
- [ ] API key/token security
- [ ] No hardcoded secrets
- [ ] OWASP ZAP scan run
- [ ] Vulnerabilities documented
- [ ] Remediation plan created

**Technical Details**:
```
Tools: OWASP ZAP, Burp Suite (community), manual testing
Areas: APIs, Authentication, Authorization, Data Protection
```

**Subtasks**:
1. Setup OWASP ZAP
2. Scan APIs for vulnerabilities
3. Test SQL injection protection
4. Test XSS protection
5. Test CSRF protection
6. Test authentication
7. Test authorization boundaries
8. Verify rate limiting
9. Check input validation
10. Verify password policies
11. Check for hardcoded secrets
12. Verify security headers
13. Document findings
14. Create remediation plan

**Dependencies**: All services and security implementation

---

# PHASE 9: CI/CD PIPELINE (Week 19)
**Total Story Points: 55 SP**

---

## EPIC-9.1: GitHub Actions CI/CD Pipeline
**Epic Story Points: 55 SP**

---

### STORY-9.1.1: Setup GitHub Actions with Code Quality & Security Scanning
**Story Points**: 26  
**Priority**: CRITICAL  
**Assignee Type**: DevOps / Backend Developer  
**Sprint**: Sprint 19  

**Description**:
Create GitHub Actions pipeline with automated testing, code quality, and security scanning.

**Acceptance Criteria**:
- [ ] GitHub repository created
- [ ] GitHub Actions workflow file created
- [ ] Build stage: Maven compile
- [ ] Unit test stage: mvn test
- [ ] Code coverage check: >80%
- [ ] SonarQube code quality analysis
- [ ] Dependency security check (OWASP Dependency-Check)
- [ ] Docker image build stage
- [ ] Image push to Docker Hub (on tag)
- [ ] Tests run in parallel where possible
- [ ] Failure notifications
- [ ] Pipeline duration < 30 minutes
- [ ] Secrets management for credentials
- [ ] Branch protection rules

**Technical Details**:
```yaml
Pipeline Stages:
1. Checkout
2. Setup JDK 21
3. Build (mvn clean compile)
4. Unit Tests (mvn test)
5. Code Coverage Check
6. SonarQube Analysis
7. Security Scan (Dependency-Check)
8. Build Docker Images
9. Push to Registry (on version tag)

Tools:
- Build: Maven
- Quality: SonarQube
- Security: OWASP Dependency-Check
- Container: Docker
- Registry: Docker Hub
```

**Subtasks**:
1. Create GitHub repository
2. Create GitHub Actions workflow YAML
3. Configure Maven build stage
4. Configure unit test stage
5. Add code coverage reporting
6. Integrate SonarQube
7. Integrate OWASP Dependency-Check
8. Configure Docker image build
9. Configure Docker Hub credentials
10. Setup branch protection rules
11. Configure notifications
12. Test pipeline execution
13. Optimize pipeline performance

**Dependencies**: All services with tests

---

### STORY-9.1.2: Automate Kubernetes Deployment via Pipeline
**Story Points**: 29  
**Priority**: CRITICAL  
**Assignee Type**: DevOps  
**Sprint**: Sprint 19  

**Description**:
Automate deployment to Kubernetes clusters using GitOps and pipeline-triggered deployments.

**Acceptance Criteria**:
- [ ] Deployment stage in pipeline
- [ ] Automatic deployment to Dev on main branch merge
- [ ] Manual approval required for Staging
- [ ] Manual approval required for Production
- [ ] Helm deployment used
- [ ] Rollback capability defined
- [ ] Pre-deployment health checks
- [ ] Post-deployment smoke tests
- [ ] Deployment notifications
- [ ] Deployment status tracking
- [ ] GitOps repository (ArgoCD) optional
- [ ] Deployment logs captured
- [ ] Failure rollback automatic

**Technical Details**:
```yaml
Pipeline Stages:
1. Build & Test (previous stage)
2. Build Docker Images
3. Deploy to Dev (automatic)
4. Smoke Tests (Dev)
5. Deploy to Staging (manual approval)
6. Smoke Tests (Staging)
7. Deploy to Prod (manual approval)
8. Smoke Tests (Prod)

Deployment:
- Tool: Helm
- Strategy: Rolling update (0 downtime)
- Rollback: Automatic if health check fails
```

**Subtasks**:
1. Create deployment stage in pipeline
2. Configure kubectl access (kubeconfig)
3. Create deployment script
4. Configure Helm deployment
5. Setup pre-deployment validation
6. Setup post-deployment health checks
7. Create smoke test suite
8. Enable manual approvals (Staging, Prod)
9. Configure failure notifications
10. Setup automatic rollback
11. Configure deployment notifications
12. Create deployment documentation
13. Test full deployment flow
14. Test rollback procedure

**Dependencies**: STORY-9.1.1, STORY-7.2.1, STORY-7.3.1

---

# PHASE 10: PRODUCTION DEPLOYMENT (Week 20)
**Total Story Points: 85 SP**

---

## EPIC-10.1: Multi-Cluster Production Setup
**Epic Story Points: 50 SP**

---

### STORY-10.1.1: Setup AWS EKS Multi-Cluster Infrastructure
**Story Points**: 30  
**Priority**: CRITICAL  
**Assignee Type**: DevOps / AWS Architect  
**Sprint**: Sprint 20  

**Description**:
Setup production-grade Kubernetes clusters on AWS EKS with multi-AZ, auto-scaling, and disaster recovery.

**Acceptance Criteria**:
- [ ] Production EKS cluster created (3+ nodes)
- [ ] Staging EKS cluster created (identical configuration)
- [ ] Multi-AZ deployment (3 availability zones)
- [ ] Auto-scaling configured (min 3, max 10 nodes)
- [ ] Node security groups configured
- [ ] VPC and subnets configured
- [ ] ALB (Application Load Balancer) created
- [ ] Route53 DNS configured
- [ ] RDS PostgreSQL multi-AZ with failover
- [ ] MSK Kafka with replication factor 3
- [ ] ElastiCache Redis with multi-AZ
- [ ] VPC endpoints for private AWS services (optional)
- [ ] IAM roles and policies configured
- [ ] Monitoring and autoscaling metrics
- [ ] Backup strategies configured
- [ ] Disaster recovery plan documented

**Technical Details**:
```
AWS Services:
- EKS: Version 1.28+, 3 clusters (Prod, Staging, Dev)
- EC2: On-demand instances, auto-scaling groups
- RDS: Multi-AZ PostgreSQL 16, backup retention 14 days
- MSK: 3 brokers, replication factor 3
- ElastiCache: Redis, Multi-AZ, automatic failover
- ALB: Layer 7 load balancing
- Route53: DNS with failover policies
```

**Subtasks**:
1. Setup VPC and subnets (3 AZs)
2. Create EKS cluster (Prod)
3. Create EKS cluster (Staging)
4. Create EC2 node groups
5. Configure auto-scaling
6. Setup RDS PostgreSQL multi-AZ
7. Setup MSK Kafka
8. Setup ElastiCache Redis
9. Create ALB
10. Configure Route53
11. Setup security groups
12. Configure IAM roles/policies
13. Enable monitoring
14. Configure backups
15. Test failover procedures
16. Document infrastructure
17. Create runbooks

**Dependencies**: STORY-7.2.1

---

### STORY-10.1.2: Setup Monitoring, Alerting & High Availability
**Story Points**: 20  
**Priority**: CRITICAL  
**Assignee Type**: DevOps / SRE  
**Sprint**: Sprint 20  

**Description**:
Setup comprehensive monitoring, alerting, and high availability for production environment.

**Acceptance Criteria**:
- [ ] Prometheus scraping all services
- [ ] Grafana dashboards for Production
- [ ] CloudWatch monitoring enabled
- [ ] Alerts configured for critical metrics
- [ ] Alert notifications via SNS/Email
- [ ] Incident response procedures documented
- [ ] On-call rotation setup
- [ ] Log aggregation (Splunk) in Production
- [ ] Distributed tracing (Zipkin) in Production
- [ ] Performance baselines established
- [ ] Capacity planning metrics
- [ ] Health checks configured (liveness, readiness)
- [ ] Pod disruption budgets defined
- [ ] Network policies configured
- [ ] Resource quotas enforced
- [ ] Error budget defined (SLO, SLI)

**Technical Details**:
```
SLO (Service Level Objectives):
- Availability: 99.9% uptime
- Latency p95: < 500ms
- Error Rate: < 0.1%

Alerts:
- Service down: Immediate
- Error > 1%: 5 min
- Latency p95 > 2s: 10 min
- Disk usage > 80%: 24 hours
```

**Subtasks**:
1. Configure CloudWatch monitoring
2. Setup CloudWatch alarms
3. Configure SNS notifications
4. Create on-call rotation
5. Create incident response runbook
6. Configure log retention
7. Setup dashboard for Prod
8. Define SLOs and SLIs
9. Establish performance baselines
10. Test alerting mechanisms
11. Document alert thresholds
12. Create capacity planning process
13. Test incident response procedure

**Dependencies**: STORY-10.1.1

---

## EPIC-10.2: Deployment & Cutover to Production
**Epic Story Points: 35 SP**

---

### STORY-10.2.1: Production Cutover & Data Migration
**Story Points**: 25  
**Priority**: CRITICAL  
**Assignee Type**: DevOps / DBA  
**Sprint**: Sprint 20  

**Description**:
Execute production cutover with zero-downtime blue-green deployment and data migration.

**Acceptance Criteria**:
- [ ] Production data loaded into RDS
- [ ] Blue-green deployment ready
- [ ] Database migration tested on staging
- [ ] Rollback procedure documented
- [ ] Smoke tests created and passing
- [ ] Load balancer configured for canary deployment
- [ ] Health checks passing
- [ ] DNS cutover planned
- [ ] Communication plan for cutover window
- [ ] Cutover executed with zero downtime
- [ ] Production validation successful
- [ ] All services healthy post-deployment
- [ ] Metrics and logs flowing correctly

**Technical Details**:
```
Deployment Strategy: Blue-Green
1. Deploy new version (Green) alongside current (Blue)
2. Route 10% traffic to Green, monitor
3. Gradually increase to 50%, 90%, 100%
4. Keep Blue ready for rollback

Data Migration:
1. Replicate data from staging DB
2. Validate data integrity
3. Run migration scripts
4. Verify constraints
```

**Subtasks**:
1. Prepare production database
2. Load initial data
3. Test data migration
4. Create blue-green deployment
5. Configure load balancer routing
6. Create smoke tests for Prod
7. Plan cutover window
8. Execute cutover
9. Monitor metrics during cutover
10. Validate health checks
11. Run smoke tests
12. Verify logs and traces
13. Confirm all systems healthy
14. Communicate to stakeholders
15. Update runbooks

**Dependencies**: STORY-10.1.1, STORY-10.1.2

---

### STORY-10.2.2: Production Support & Runbook Documentation
**Story Points**: 10  
**Priority**: HIGH  
**Assignee Type**: DevOps / SRE  
**Sprint**: Sprint 20  

**Description**:
Create comprehensive operational runbooks and support procedures for production systems.

**Acceptance Criteria**:
- [ ] Deployment runbook created
- [ ] Rollback runbook created
- [ ] Scaling runbook created
- [ ] Incident response procedures
- [ ] Database recovery procedures
- [ ] Backup and restore procedures
- [ ] On-call escalation path
- [ ] Common issues and solutions
- [ ] Troubleshooting guide
- [ ] Performance tuning guide
- [ ] Secrets rotation procedures
- [ ] Certificate rotation procedures
- [ ] All runbooks tested

**Technical Details**:
```
Runbooks Cover:
1. Deployment procedures
2. Rollback procedures
3. Health check verification
4. Performance troubleshooting
5. Database administration
6. Security incident response
7. Communication procedures
```

**Subtasks**:
1. Create deployment runbook
2. Create rollback runbook
3. Create troubleshooting guide
4. Create incident response guide
5. Create database admin guide
6. Create scaling procedure
7. Create backup/restore guide
8. Create on-call guide
9. Test all procedures
10. Get team sign-off

**Dependencies**: STORY-10.2.1

---

## Summary Table: All Stories by Phase

| Phase | Total SP | Key Deliverables |
|-------|----------|------------------|
| Phase 1: Foundation | 89 | Maven setup, Eureka, Config, Gateway, Databases, Docker, K8s setup |
| Phase 2: Core Services | 120 | User, Product, Cart, Inventory services with APIs |
| Phase 3: Business Logic | 140 | Order, Payment, Notification, Review, Shipping, Saga Orchestrator |
| Phase 4: Resilience | 68 | Circuit breaker, Retry, Rate limit, Feign, Caching |
| Phase 5: Security | 40 | JWT, RBAC, Authorization |
| Phase 6: Observability | 50 | Prometheus, Grafana, Zipkin, Splunk |
| Phase 7: Containerization | 65 | Docker images, K8s manifests, Helm charts, Dev deployment |
| Phase 8: Testing | 75 | Unit tests, Integration tests, E2E tests, Load testing |
| Phase 9: CI/CD | 55 | GitHub Actions, Code quality, Security scanning, Auto-deployment |
| Phase 10: Production | 85 | Multi-cluster EKS, Monitoring, Cutover, Runbooks |
| **PHASE 11: AWS Infrastructure** | **120** | **IAM, VPC, EC2, RDS, S3, ECR, ECS, ALB, Auto Scaling, CloudFront, Route 53, HTTPS** |
| **PHASE 12: React UI** | **155** | **Frontend app, Components, Pages, State Management, API Integration, Testing, Deployment** |
| **TOTAL** | **~1320 SP** | **Complete microservices platform with AWS cloud and modern UI** |

---

# PHASE 11: AWS INFRASTRUCTURE & CLOUD MIGRATION (Weeks 21-26)
**Total Story Points: 140 SP**
**Priority: CRITICAL**
**AWS Services: Free Tier Available for 6 Months**

---

## EPIC-11.1: AWS Foundation & Network Setup
**Epic Story Points: 40 SP**

---

### STORY-11.1.1: Setup AWS Account with IAM Roles & Policies
**Story Points**: 8  
**Priority**: CRITICAL  
**Assignee Type**: DevOps / Cloud Architect  
**Sprint**: Sprint 21  

**Description**:
Configure AWS free tier account with proper IAM roles, policies, and MFA for security best practices.

**Acceptance Criteria**:
- [ ] AWS account configured with MFA enabled on root account
- [ ] IAM users created for development team members
- [ ] Service roles created for EC2, ECS, RDS, Lambda
- [ ] Least-privilege IAM policies defined
- [ ] Cross-service permissions configured
- [ ] Resource tagging strategy defined
- [ ] CloudTrail enabled for audit logging
- [ ] Cost monitoring alerts configured
- [ ] Free tier resources tracked
- [ ] AWS CLI configured locally
- [ ] Terraform/CloudFormation IAM roles ready
- [ ] Documentation updated

**Technical Details**:
```
IAM Structure:
- Root Account: MFA only, no keys
- Admin User: Limited permissions for team lead
- Developer Users: Service-specific access
- Service Roles: EC2, ECS, Lambda, RDS
- Policy-based access control (least privilege)
```

**Subtasks**:
1. Create AWS account (free tier)
2. Enable MFA on root account
3. Create IAM users for developers
4. Create service roles (EC2, ECS, RDS, Lambda)
5. Define IAM policies
6. Configure AWS CLI access
7. Setup cost monitoring
8. Enable CloudTrail
9. Document access procedures

**Dependencies**: None

---

### STORY-11.1.2: Design & Setup VPC with Subnets, Security Groups, NACLs
**Story Points**: 12  
**Priority**: CRITICAL  
**Assignee Type**: DevOps / Network Engineer  
**Sprint**: Sprint 21  

**Description**:
Create VPC architecture with public/private subnets, internet gateway, NAT gateway, and security controls.

**Acceptance Criteria**:
- [ ] VPC created (CIDR: 10.0.0.0/16)
- [ ] 2 Public subnets (Web tier, 10.0.1.0/24, 10.0.2.0/24)
- [ ] 2 Private subnets (App tier, 10.0.10.0/24, 10.0.11.0/24)
- [ ] 2 Private subnets (DB tier, 10.0.20.0/24, 10.0.21.0/24)
- [ ] Internet Gateway attached and configured
- [ ] NAT Gateway in public subnet for private subnet egress
- [ ] Route tables configured (public and private)
- [ ] Security groups created: ALB-SG, App-SG, DB-SG
- [ ] NACLs configured for inbound/outbound rules
- [ ] VPC Flow Logs enabled
- [ ] VPC Endpoints configured (for AWS services)
- [ ] Multi-AZ setup for high availability
- [ ] Terraform/CloudFormation code created
- [ ] Tested and documented

**Technical Details**:
```
VPC Architecture:
- CIDR Block: 10.0.0.0/16
- Public Subnets: 10.0.1.0/24, 10.0.2.0/24 (Multi-AZ)
- App Subnets: 10.0.10.0/24, 10.0.11.0/24 (Multi-AZ)
- DB Subnets: 10.0.20.0/24, 10.0.21.0/24 (Multi-AZ)
- NAT Gateway: In public subnet for private egress
- Security Groups: Separate for each tier
```

**Subtasks**:
1. Create VPC with CIDR 10.0.0.0/16
2. Create public subnets (2 AZs)
3. Create private subnets for app tier (2 AZs)
4. Create private subnets for database tier (2 AZs)
5. Create Internet Gateway
6. Create NAT Gateway
7. Create and configure route tables
8. Create security groups for each tier
9. Configure NACLs
10. Enable VPC Flow Logs
11. Create Terraform/CloudFormation templates
12. Document network architecture

**Dependencies**: STORY-11.1.1

---

### STORY-11.1.3: Setup RDS Multi-AZ PostgreSQL Database
**Story Points**: 10  
**Priority**: CRITICAL  
**Assignee Type**: Database Administrator / DevOps  
**Sprint**: Sprint 21  

**Description**:
Create managed RDS PostgreSQL instance with Multi-AZ for high availability and automated backups.

**Acceptance Criteria**:
- [ ] RDS PostgreSQL 16 instance created (Multi-AZ)
- [ ] Database endpoint configured
- [ ] Enhanced monitoring enabled
- [ ] Automated backups configured (7-day retention)
- [ ] Manual snapshot capability
- [ ] Parameter groups configured (max_connections, shared_buffers)
- [ ] Subnet group created in private subnets
- [ ] DB security group configured
- [ ] Encryption at rest enabled
- [ ] Encryption in transit (SSL) enabled
- [ ] CloudWatch monitoring and alarms
- [ ] Read replicas configured (optional for scaling)
- [ ] Performance Insights enabled
- [ ] Failover behavior tested
- [ ] Connection pooling setup (via microservices)
- [ ] Free tier instance type (db.t3.micro or db.t4g.micro)

**Technical Details**:
```
RDS Configuration:
- Engine: PostgreSQL 16
- Instance Class: db.t4g.micro (free tier eligible)
- Multi-AZ: Enabled
- Storage: 20 GB (free tier limit)
- Backup Retention: 7 days
- Encryption: AES-256 at rest, SSL in transit
- Monitoring: Enhanced monitoring every 60 seconds
- Parameter Groups: Optimized for microservices
```

**Subtasks**:
1. Create RDS subnet group (private subnets)
2. Create DB security group
3. Create RDS PostgreSQL instance
4. Enable Multi-AZ
5. Configure automated backups
6. Enable encryption at rest and in transit
7. Setup CloudWatch alarms
8. Enable Performance Insights
9. Create read replica (optional)
10. Test failover
11. Document connection procedures
12. Create parameter backup/restore procedures

**Dependencies**: STORY-11.1.2

---

### STORY-11.1.4: Setup S3 Buckets for Media & Backups
**Story Points**: 10  
**Priority**: HIGH  
**Assignee Type**: DevOps  
**Sprint**: Sprint 21  

**Description**:
Create S3 buckets for product images, user uploads, and database backups with lifecycle policies.

**Acceptance Criteria**:
- [ ] S3 bucket for product images created
- [ ] S3 bucket for user uploads created
- [ ] S3 bucket for database backups created
- [ ] Bucket versioning enabled
- [ ] Server-side encryption (SSE-S3) configured
- [ ] Public access blocked (except images via CloudFront)
- [ ] Lifecycle policies for old versions (delete after 30 days)
- [ ] Cross-region replication (optional for critical backups)
- [ ] IAM policies for service access
- [ ] CloudFront OAI configured for image delivery
- [ ] Bucket logging enabled
- [ ] Access logs stored in separate bucket
- [ ] Intelligent-Tiering enabled for cost optimization
- [ ] Free tier limits monitored

**Technical Details**:
```
S3 Buckets:
1. ecommerce-images (product images)
   - Public access via CloudFront OAI only
   - Object lock for audit compliance
   
2. ecommerce-uploads (user uploads)
   - Private access via signed URLs
   - Virus scanning via Lambda (optional)
   
3. ecommerce-backups (database/logs)
   - Private, versioned
   - Lifecycle: Move to Glacier after 30 days
```

**Subtasks**:
1. Create S3 bucket for images
2. Create S3 bucket for uploads
3. Create S3 bucket for backups
4. Enable versioning
5. Configure encryption
6. Setup lifecycle policies
7. Configure access control and IAM
8. Setup CloudFront OAI for images
9. Enable bucket logging
10. Configure backup lifecycle
11. Test access patterns
12. Document bucket policies

**Dependencies**: STORY-11.1.1

---

## EPIC-11.2: Container Registry & Container Orchestration
**Epic Story Points: 35 SP**

---

### STORY-11.2.1: Setup Amazon ECR (Elastic Container Registry)
**Story Points**: 8  
**Priority**: CRITICAL  
**Assignee Type**: DevOps  
**Sprint**: Sprint 22  

**Description**:
Create private ECR repositories for each microservice Docker image.

**Acceptance Criteria**:
- [ ] ECR repositories created for all 11 services
- [ ] Image scanning on push enabled
- [ ] Lifecycle policies configured (keep last 10 images)
- [ ] IAM policies for ECS/Lambda access
- [ ] Image tag format defined (latest, version, git-sha)
- [ ] Access logging enabled
- [ ] Encryption configured
- [ ] Registry cleanup automation via Lambda
- [ ] Docker authentication configured locally
- [ ] CI/CD pipeline configured for image push
- [ ] Image pull secrets created for ECS

**Technical Details**:
```
ECR Repositories:
- user-service
- product-service
- cart-service
- order-service
- payment-service
- inventory-service
- notification-service
- review-service
- shipping-service
- saga-orchestrator
- api-gateway

Image Tagging: {service}:{version}-{gitsha}
Retention: Keep 10 latest images
Scanning: AWS native scanning enabled
```

**Subtasks**:
1. Create ECR repositories for each service
2. Configure image scanning
3. Setup lifecycle policies
4. Configure IAM roles for ECS/Lambda
5. Configure image push via CI/CD
6. Setup Docker authentication
7. Configure image pull secrets
8. Test image push and pull
9. Document ECR access procedures
10. Setup image scanning notifications

**Dependencies**: STORY-11.1.1, Phase 7 Docker images

---

### STORY-11.2.2: Setup ECS Cluster with EC2 Launch Type
**Story Points**: 15  
**Priority**: CRITICAL  
**Assignee Type**: DevOps  
**Sprint**: Sprint 22  

**Description**:
Create ECS cluster with EC2 launch type and Auto Scaling groups for microservices deployment.

**Acceptance Criteria**:
- [ ] ECS cluster created (ecommerce-cluster)
- [ ] EC2 Auto Scaling group configured (t3.micro instances, free tier)
- [ ] Minimum 2 instances (for HA), maximum 5
- [ ] Target tracking scaling policy (CPU 70%)
- [ ] Memory-based scaling (70% threshold)
- [ ] CloudWatch monitoring enabled
- [ ] Container insights enabled
- [ ] Capacity providers configured
- [ ] Task placement strategies defined
- [ ] ECS optimized AMI used
- [ ] SSH access configured (bastion host)
- [ ] Security groups configured
- [ ] IAM roles for ECS tasks
- [ ] Log routing to CloudWatch
- [ ] Service auto-recovery enabled

**Technical Details**:
```
ECS Cluster:
- Name: ecommerce-cluster
- Launch Type: EC2
- Container Insights: Enabled
- Instances: t3.micro (free tier eligible, burstable)
- ASG: Min 2, Max 5 instances
- Scaling Policy: CPU target 70%
- Log Driver: awslogs to CloudWatch
```

**Subtasks**:
1. Create ECS cluster
2. Create Auto Scaling group with t3.micro instances
3. Configure launch templates
4. Setup capacity providers
5. Configure scaling policies (CPU, memory)
6. Setup CloudWatch monitoring
7. Enable Container Insights
8. Configure log routing
9. Create IAM task roles
10. Setup service auto-recovery
11. Test scaling policies
12. Document ECS architecture

**Dependencies**: STORY-11.1.1, STORY-11.1.2, STORY-11.2.1

---

### STORY-11.2.3: Deploy Microservices to ECS with Service Discovery
**Story Points**: 12  
**Priority**: CRITICAL  
**Assignee Type**: DevOps / Backend  
**Sprint**: Sprint 22-23  

**Description**:
Create ECS task definitions and services for all microservices with service discovery via ECS Service Discovery.

**Acceptance Criteria**:
- [ ] Task definitions created for all 11 services
- [ ] Environment variables configured via task definition
- [ ] Secrets managed via AWS Secrets Manager
- [ ] CPU/Memory reservations configured (optimized for t3.micro)
- [ ] ECS services created with desired count 2 (HA)
- [ ] Service discovery namespaces configured
- [ ] Load balancing configured (ALB target groups)
- [ ] Auto-restart on failure enabled
- [ ] Deployment strategy: Rolling updates
- [ ] Health checks configured
- [ ] Log routing to CloudWatch
- [ ] Container-to-host port mapping
- [ ] Secrets injection from AWS Secrets Manager
- [ ] Database connection pooling optimized
- [ ] All services deployed and healthy

**Technical Details**:
```
Task Definition:
- Family: {service-name}
- Container Port: Service-specific (8081-8091)
- Host Port: Same (dynamic port mapping optional)
- CPU: 256 (burstable)
- Memory: 512 MB (adjust per service)
- Log Driver: awslogs
- Environment: Via task definition
- Secrets: Via Secrets Manager
- Health Check: HTTP endpoint every 30 seconds
```

**Subtasks**:
1. Create task definition templates
2. Configure environment variables
3. Setup Secrets Manager for sensitive data
4. Create task definitions for all 11 services
5. Create ECS services
6. Configure service discovery
7. Setup load balancer target groups
8. Configure health checks
9. Setup log routing
10. Deploy all services to ECS
11. Verify service health and connectivity
12. Test inter-service communication
13. Document service deployment procedures

**Dependencies**: STORY-11.2.1, STORY-11.2.2

---

## EPIC-11.3: Load Balancing, Auto Scaling & CDN
**Epic Story Points: 25 SP**

---

### STORY-11.3.1: Setup Application Load Balancer (ALB) with Target Groups
**Story Points**: 10  
**Priority**: CRITICAL  
**Assignee Type**: DevOps  
**Sprint**: Sprint 23  

**Description**:
Create ALB for routing traffic to microservices with path-based and hostname-based routing.

**Acceptance Criteria**:
- [ ] ALB created in public subnets (Multi-AZ)
- [ ] Listener on port 80 (HTTP)
- [ ] Listener on port 443 (HTTPS - configured in next story)
- [ ] Target groups created for each service
- [ ] Path-based routing rules configured
  - /v1/users/* -> user-service
  - /v1/products/* -> product-service
  - /v1/orders/* -> order-service
  - etc.
- [ ] Host-based routing for subdomains (optional)
- [ ] Health checks configured (30 sec, healthy threshold 2)
- [ ] Stickiness disabled (stateless services)
- [ ] Cross-zone load balancing enabled
- [ ] CloudWatch monitoring enabled
- [ ] Access logs enabled
- [ ] HTTP to HTTPS redirect (after HTTPS setup)
- [ ] WAF rules attached (optional, future phase)

**Technical Details**:
```
ALB Configuration:
- Subnets: Public subnets (Multi-AZ)
- Security Group: Allow 80, 443
- Listeners: 80, 443
- Target Type: IP (for ECS tasks)
- Health Check: /actuator/health
- Protocol: HTTP internally, HTTPS externally
- Path Rules: Based on API Gateway routing
```

**Subtasks**:
1. Create ALB in public subnets
2. Configure security groups for ALB
3. Create target groups for each service
4. Configure path-based routing rules
5. Setup health checks
6. Configure sticky sessions (if needed)
7. Enable cross-zone load balancing
8. Setup access logging
9. Create CloudWatch alarms
10. Test routing rules
11. Test failover behavior
12. Document ALB configuration

**Dependencies**: STORY-11.1.2, STORY-11.2.3

---

### STORY-11.3.2: Setup HTTPS/TLS with AWS Certificate Manager (ACM)
**Story Points**: 8  
**Priority**: CRITICAL  
**Assignee Type**: DevOps  
**Sprint**: Sprint 23  

**Description**:
Configure HTTPS/TLS certificates via AWS Certificate Manager and setup secure communication.

**Acceptance Criteria**:
- [ ] Domain name registered (or existing domain)
- [ ] ACM certificate requested for domain
- [ ] DNS validation completed
- [ ] Certificate attached to ALB listener (port 443)
- [ ] HTTPS listener created with SSL policy
- [ ] HTTP to HTTPS redirect configured
- [ ] Security headers configured (HSTS, X-Frame-Options, etc.)
- [ ] TLS 1.2+ enforced
- [ ] Certificate auto-renewal enabled
- [ ] Cipher suites optimized
- [ ] CloudWatch alarms for certificate expiration
- [ ] All services behind HTTPS
- [ ] SSL/TLS testing passed (A+ rating on SSL Labs)

**Technical Details**:
```
ACM Configuration:
- Domain: yourdomain.com
- Validation: DNS (CNAME)
- Auto-renewal: Enabled
- TLS Version: 1.2 and 1.3
- ALB Listener: 443
- Redirect: HTTP (80) -> HTTPS (443)
- Security Headers: HSTS, X-Frame-Options, X-Content-Type-Options
```

**Subtasks**:
1. Register domain (Route 53 or external)
2. Request ACM certificate
3. Complete DNS validation
4. Create ALB HTTPS listener
5. Attach ACM certificate
6. Configure HTTP to HTTPS redirect
7. Configure security headers in ALB
8. Enable TLS 1.2+ only
9. Configure cipher suites
10. Setup certificate expiration alarms
11. Test HTTPS access
12. Verify SSL/TLS configuration

**Dependencies**: STORY-11.3.1

---

### STORY-11.3.3: Setup CloudFront CDN for Static Content & Images
**Story Points**: 7  
**Priority**: HIGH  
**Assignee Type**: DevOps  
**Sprint**: Sprint 23  

**Description**:
Create CloudFront distribution for caching product images and static assets globally.

**Acceptance Criteria**:
- [ ] CloudFront distribution created
- [ ] Origin: S3 bucket for images (origin access identity)
- [ ] Origin: ALB for dynamic content (separate behavior)
- [ ] Cache behaviors configured
  - /images/* -> S3 origin, 1 year TTL
  - /static/* -> S3 origin, 1 year TTL
  - /v1/* -> ALB origin, 0 TTL (no cache)
- [ ] Compression enabled (gzip, brotli)
- [ ] Custom headers added (cache control, security)
- [ ] Geo-blocking configured (optional)
- [ ] SSL/TLS certificate attached
- [ ] HTTP/2 enabled
- [ ] IPv6 support enabled
- [ ] Query strings handled correctly
- [ ] Cache invalidation strategy defined
- [ ] CloudWatch monitoring
- [ ] Access logs enabled
- [ ] Origin Shield enabled (optional for extra caching layer)

**Technical Details**:
```
CloudFront Configuration:
- Primary Origin: ALB (dynamic APIs)
- Secondary Origin: S3 (images, static)
- Cache Behaviors:
  - /images/* -> S3, 31536000s (1 year)
  - /static/* -> S3, 31536000s (1 year)
  - /v1/* -> ALB, 0s (no cache)
- Compression: Enabled
- Protocol: HTTPS only
- HTTP Version: HTTP/2 and HTTP/3
- Origin Shield: Optional for better caching
```

**Subtasks**:
1. Create CloudFront distribution
2. Configure S3 origin with OAI
3. Configure ALB origin
4. Setup cache behaviors
5. Enable compression
6. Configure custom headers
7. Setup SSL/TLS
8. Enable HTTP/2 and HTTP/3
9. Configure cache invalidation
10. Setup CloudWatch monitoring
11. Enable access logs
12. Test CDN caching
13. Test geo-distribution (optional)

**Dependencies**: STORY-11.1.4, STORY-11.3.1, STORY-11.3.2

---

## EPIC-11.4: Auto Scaling, Monitoring & DNS
**Epic Story Points: 20 SP**

---

### STORY-11.4.1: Setup Auto Scaling Policies & CloudWatch Alarms
**Story Points**: 10  
**Priority**: HIGH  
**Assignee Type**: DevOps  
**Sprint**: Sprint 24  

**Description**:
Configure auto-scaling based on CPU/memory metrics and setup comprehensive CloudWatch alarms.

**Acceptance Criteria**:
- [ ] Target tracking scaling policy for CPU (70% target)
- [ ] Target tracking scaling policy for memory (80% target)
- [ ] Step scaling policy for rapid load increases
- [ ] Cooldown periods configured (300 seconds)
- [ ] Scale-out happens within 2 minutes
- [ ] Scale-in happens after 10 minutes (to prevent flapping)
- [ ] CloudWatch alarms for high CPU
- [ ] CloudWatch alarms for high memory
- [ ] CloudWatch alarms for service failures
- [ ] CloudWatch alarms for ALB target health
- [ ] CloudWatch alarms for database connections
- [ ] SNS notifications for scaling events
- [ ] Metrics dashboard created
- [ ] Custom metrics from applications
- [ ] Scaling tested with load test

**Technical Details**:
```
Scaling Configuration:
- Target CPU: 70%
- Target Memory: 80%
- Min Instances: 2
- Max Instances: 5
- Scale-out Threshold: 70% for 1 minute
- Scale-in Threshold: 30% for 5 minutes
- Cool-down: 300 seconds
- Metrics: Per-service CPU, memory, request count
```

**Subtasks**:
1. Create target tracking scaling policies
2. Create step scaling policies for rapid load
3. Configure cooldown periods
4. Create CloudWatch alarms for metrics
5. Configure SNS notifications
6. Create custom metrics from applications
7. Setup metrics dashboard
8. Configure log group retention
9. Test scaling behavior
10. Load test and observe scaling
11. Tune scaling thresholds
12. Document scaling configuration

**Dependencies**: STORY-11.2.2, STORY-11.2.3

---

### STORY-11.4.2: Setup Route 53 DNS, Health Checks & Failover
**Story Points**: 10  
**Priority**: HIGH  
**Assignee Type**: DevOps  
**Sprint**: Sprint 24  

**Description**:
Configure Route 53 for domain management, health checks, and failover routing.

**Acceptance Criteria**:
- [ ] Hosted zone created in Route 53 for domain
- [ ] A record created for main domain (points to CloudFront or ALB)
- [ ] CNAME records for subdomains (api.domain.com, etc.)
- [ ] Health checks configured for endpoints
- [ ] Failover routing (primary/secondary ALBs - optional for multi-region)
- [ ] Weighted routing policy (optional, for canary deployments)
- [ ] Geolocation routing (optional, route by country)
- [ ] Latency-based routing (optional, multi-region)
- [ ] Health check alarms in CloudWatch
- [ ] TTL configured (300 seconds for faster failover)
- [ ] DNSSEC enabled (optional)
- [ ] CloudTrail logging for DNS changes
- [ ] DNS query logging enabled
- [ ] DNS failover tested

**Technical Details**:
```
Route 53 Configuration:
- Hosted Zone: yourdomain.com
- A Record: domain.com -> CloudFront distribution
- Health Check: HTTP GET /actuator/health on ALB
- Health Check Interval: 30 seconds
- Failure Threshold: 3 consecutive failures
- TTL: 300 seconds
- Routing Policy: Simple (or Failover for HA)
```

**Subtasks**:
1. Create/migrate hosted zone to Route 53
2. Create A record for main domain
3. Create CNAME records for subdomains
4. Configure health checks
5. Setup CloudWatch alarms for health checks
6. Configure DNS failover (if needed)
7. Test DNS resolution
8. Test health check failover
9. Configure DNS logging
10. Enable DNSSEC (optional)
11. Test DNS recovery
12. Document DNS configuration

**Dependencies**: STORY-11.3.2

---

## EPIC-11.5: Secrets, Monitoring & Logging
**Epic Story Points: 20 SP**

---

### STORY-11.5.1: Setup AWS Secrets Manager for Configuration & Credentials
**Story Points**: 8  
**Priority**: HIGH  
**Assignee Type**: DevOps  
**Sprint**: Sprint 24  

**Description**:
Centralize secrets management using AWS Secrets Manager for database credentials, API keys, and sensitive configuration.

**Acceptance Criteria**:
- [ ] RDS master password stored in Secrets Manager
- [ ] API keys and tokens stored securely
- [ ] Database connection strings stored
- [ ] JWT secrets stored
- [ ] Third-party service credentials stored
- [ ] Secret rotation policies configured
- [ ] IAM policies for secret access
- [ ] Encryption with KMS (customer-managed key)
- [ ] Audit logging via CloudTrail
- [ ] Secrets Manager API integrated in application
- [ ] Spring Cloud integration (optional)
- [ ] Automated secret rotation for RDS (optional)
- [ ] Secrets tagged for organization
- [ ] Backup and recovery procedures documented

**Technical Details**:
```
Secrets Manager:
- Database Credentials: Auto-rotate every 30 days
- API Keys: Rotate manually or via webhook
- JWT Secrets: Store as SecretString
- KMS Key: Customer-managed key for encryption
- IAM Policy: Allow ECS task role to read secrets
```

**Subtasks**:
1. Create customer-managed KMS key
2. Store RDS credentials in Secrets Manager
3. Store API keys and tokens
4. Store database connection strings
5. Create IAM policies for access
6. Configure automatic rotation (RDS)
7. Setup CloudTrail logging
8. Integrate with ECS task definitions
9. Create rotation Lambda functions (if custom)
10. Test secret access from applications
11. Test rotation process
12. Document secrets management procedures

**Dependencies**: STORY-11.1.1, STORY-11.1.3

---

### STORY-11.5.2: Setup CloudWatch Logs, Monitoring & Alarms
**Story Points**: 12  
**Priority**: HIGH  
**Assignee Type**: DevOps  
**Sprint**: Sprint 24-25  

**Description**:
Configure comprehensive CloudWatch logging, metrics, and alarms for all AWS resources.

**Acceptance Criteria**:
- [ ] CloudWatch log groups created for each service
- [ ] Log retention configured (30 days for debug, 7 days for verbose)
- [ ] RDS logs enabled and streamed to CloudWatch
- [ ] ALB access logs sent to S3
- [ ] VPC Flow Logs enabled
- [ ] Application logs streamed via ECS
- [ ] Custom metrics published from applications
- [ ] CloudWatch dashboards created
- [ ] Alarms for critical metrics
  - High CPU (>80%)
  - High memory (>85%)
  - RDS CPU (>70%)
  - RDS connections (>80% of max)
  - ALB target health (unhealthy targets)
  - Error rates in logs (>1% of requests)
  - Application exception logs
- [ ] SNS topics for alarm notifications
- [ ] Email alerts configured
- [ ] Slack integration (optional)
- [ ] Log insights queries created
- [ ] Cost monitoring alarms

**Technical Details**:
```
CloudWatch Configuration:
- Log Groups: /ecs/{service-name}, /rds/{db-instance}
- Log Retention: 30 days (apps), 7 days (verbose)
- Metrics: CPU, Memory, NetworkIn/Out, DiskReadOps
- Custom Metrics: Request count, error count, latency
- Dashboards: Per-service, per-tier, overall system
- Alarms: SNS topics for notifications
- Log Insights: Query language for analysis
```

**Subtasks**:
1. Create CloudWatch log groups
2. Configure log retention policies
3. Enable RDS logging
4. Enable VPC Flow Logs
5. Configure ALB access logs to S3
6. Stream ECS logs to CloudWatch
7. Create CloudWatch dashboards
8. Create metric alarms
9. Configure SNS topics
10. Setup email notifications
11. Create Log Insights queries
12. Setup cost monitoring
13. Test alarms and notifications
14. Document monitoring procedures

**Dependencies**: STORY-11.2.2, STORY-11.2.3, STORY-11.3.1

---

# PHASE 12: REACT UI DEVELOPMENT WITH TYPESCRIPT (Weeks 27-33)
**Total Story Points: 155 SP**
**Priority: HIGH**
**Tech Stack: React 18, TypeScript, Vite, Redux Toolkit, React Query, Tailwind CSS**

---

## EPIC-12.1: Project Setup & Foundation
**Epic Story Points: 25 SP**

---

### STORY-12.1.1: Setup React + TypeScript Project with Vite
**Story Points**: 8  
**Priority**: CRITICAL  
**Assignee Type**: Frontend Lead / Senior Developer  
**Sprint**: Sprint 27  

**Description**:
Create React 18 project with TypeScript, Vite, and essential development tools.

**Acceptance Criteria**:
- [ ] Vite project created with React 18 template
- [ ] TypeScript configured with strict mode
- [ ] ESLint configured for TypeScript
- [ ] Prettier configured for code formatting
- [ ] Husky and lint-staged for pre-commit hooks
- [ ] .gitignore configured
- [ ] Environment variables setup (.env files)
- [ ] Development and production builds working
- [ ] Hot module replacement (HMR) functional
- [ ] Build optimization configured
- [ ] Source maps configured for debugging
- [ ] Project structure organized (src/components, src/pages, src/hooks, etc.)
- [ ] README with setup instructions

**Technical Details**:
```
Project Structure:
src/
  components/     # Reusable components
  pages/          # Page components
  hooks/          # Custom hooks
  services/       # API services
  store/          # Redux state management
  types/          # TypeScript types
  utils/          # Utility functions
  styles/         # Tailwind CSS config
  App.tsx
  main.tsx
```

**Subtasks**:
1. Initialize Vite React project
2. Install and configure TypeScript
3. Setup ESLint
4. Setup Prettier
5. Configure Husky pre-commit hooks
6. Setup project structure
7. Configure environment variables
8. Test build process
9. Configure source maps
10. Setup development workflow documentation
11. Create .env.example file
12. Test HMR functionality

**Dependencies**: None

---

### STORY-12.1.2: Setup Tailwind CSS for Styling
**Story Points**: 5  
**Priority**: HIGH  
**Assignee Type**: Frontend Developer  
**Sprint**: Sprint 27  

**Description**:
Configure Tailwind CSS for utility-first styling and responsive design.

**Acceptance Criteria**:
- [ ] Tailwind CSS installed and configured
- [ ] PostCSS configured
- [ ] Tailwind config file customized (colors, fonts, breakpoints)
- [ ] Custom utility classes defined
- [ ] CSS reset applied
- [ ] Dark mode support configured (optional)
- [ ] Responsive breakpoints defined (mobile-first)
- [ ] Component-scoped styles using @apply (if needed)
- [ ] PurgeCSS/content path configured for production
- [ ] Build file size optimized

**Technical Details**:
```
Tailwind Configuration:
- Theme customization: colors, fonts, spacing
- Breakpoints: sm, md, lg, xl, 2xl
- Dark Mode: Class or media query strategy
- Plugins: Forms, typography (optional)
- Content: src/**/*.{js,jsx,ts,tsx}
```

**Subtasks**:
1. Install Tailwind CSS
2. Configure PostCSS
3. Create tailwind.config.ts
4. Customize theme
5. Setup responsive breakpoints
6. Configure dark mode (optional)
7. Create global styles
8. Test utility classes
9. Verify PurgeCSS working
10. Optimize build size

**Dependencies**: STORY-12.1.1

---

### STORY-12.1.3: Setup Redux Toolkit for State Management
**Story Points**: 8  
**Priority**: HIGH  
**Assignee Type**: Frontend Senior Developer  
**Sprint**: Sprint 27  

**Description**:
Configure Redux Toolkit with Thunk middleware for efficient state management.

**Acceptance Criteria**:
- [ ] Redux Toolkit installed
- [ ] Redux DevTools configured
- [ ] Store setup with slices pattern
- [ ] Authentication slice created
- [ ] User profile slice created
- [ ] Async thunks configured
- [ ] Middleware configured (Thunk pre-installed)
- [ ] Type-safe selectors created
- [ ] Redux persist configured (optional)
- [ ] Redux RTK Query configured (optional, for API caching)
- [ ] Slice tests created
- [ ] Store structure documented

**Technical Details**:
```
Redux Structure:
- authSlice: login, logout, register, auth state
- userSlice: user profile, preferences
- cartSlice: shopping cart items, totals
- orderSlice: orders list, current order
- notificationSlice: UI notifications
- configSlice: app configuration
Middleware: Thunk, Logger (dev only)
DevTools: Browser extension for debugging
```

**Subtasks**:
1. Install Redux Toolkit and React-Redux
2. Setup Redux store
3. Configure Redux DevTools
4. Create authentication slice
5. Create user profile slice
6. Create async thunks for API calls
7. Create selectors
8. Setup middleware
9. Configure Redux persist (optional)
10. Create slice reducer tests
11. Test store functionality
12. Document store structure

**Dependencies**: STORY-12.1.1

---

### STORY-12.1.4: Setup React Router with Type-Safe Routes
**Story Points**: 4  
**Priority**: HIGH  
**Assignee Type**: Frontend Developer  
**Sprint**: Sprint 27  

**Description**:
Configure React Router v6 with TypeScript for type-safe navigation and routing.

**Acceptance Criteria**:
- [ ] React Router v6 installed
- [ ] Route structure defined
- [ ] Protected routes implemented
- [ ] Lazy loading of page components
- [ ] Type-safe route parameters
- [ ] Navigation guards configured
- [ ] 404 error page
- [ ] Breadcrumb navigation (optional)
- [ ] Route metadata (titles, descriptions)
- [ ] Query parameters handled

**Technical Details**:
```
Route Structure:
- / (Home)
- /login
- /register
- /products
- /products/:productId
- /cart
- /checkout
- /orders
- /orders/:orderId
- /account/profile
- /admin/* (protected)
```

**Subtasks**:
1. Install React Router v6
2. Define route configuration
3. Create route types
4. Setup lazy loading
5. Create protected route component
6. Implement route guards
7. Create error boundary pages
8. Configure query parameters
9. Test routing functionality
10. Create navigation utilities

**Dependencies**: STORY-12.1.1

---

## EPIC-12.2: Core Components & Pages
**Epic Story Points: 40 SP**

---

### STORY-12.2.1: Create Reusable UI Components Library
**Story Points**: 15  
**Priority**: HIGH  
**Assignee Type**: Frontend Developer  
**Sprint**: Sprint 28  

**Description**:
Build foundational reusable components (Button, Input, Card, Modal, etc.) with TypeScript.

**Acceptance Criteria**:
- [ ] Button component (variants: primary, secondary, danger)
- [ ] Input component (text, email, password)
- [ ] TextArea component
- [ ] Select/Dropdown component
- [ ] Card component
- [ ] Modal/Dialog component
- [ ] Toast/Alert notifications component
- [ ] Loading spinner component
- [ ] Pagination component
- [ ] Table component with sorting
- [ ] Link component (routing-aware)
- [ ] Image component with lazy loading
- [ ] Badge component
- [ ] Tooltip component
- [ ] Components documented with Storybook (optional)
- [ ] 100% TypeScript with strict types
- [ ] Accessibility (a11y) compliant
- [ ] Unit tests for each component (>80% coverage)
- [ ] Props documentation

**Technical Details**:
```
Components Library:
- Form Components: Input, TextArea, Select, Checkbox, Radio
- Feedback: Toast, Alert, Loading, Skeleton
- Navigation: Link, Breadcrumb, Pagination
- Layout: Card, Container, Stack, Grid
- Display: Badge, Avatar, Image, Icon
- Overlay: Modal, Dropdown, Tooltip, Popover
Props: Fully typed with TypeScript interfaces
Accessibility: ARIA labels, keyboard navigation
```

**Subtasks**:
1. Create components directory structure
2. Create Button component with variants
3. Create form input components
4. Create card and layout components
5. Create modal component
6. Create notification/toast component
7. Create table component
8. Create pagination component
9. Create image component with lazy loading
10. Create badge and avatar components
11. Add TypeScript types for all components
12. Add accessibility attributes
13. Create component tests (Jest + React Testing Library)
14. Document components
15. Setup Storybook (optional)

**Dependencies**: STORY-12.1.1, STORY-12.1.2

---

### STORY-12.2.2: Create Authentication Pages (Login, Register, Forgot Password)
**Story Points**: 12  
**Priority**: CRITICAL  
**Assignee Type**: Frontend Developer  
**Sprint**: Sprint 28  

**Description**:
Implement authentication UI pages with form validation and error handling.

**Acceptance Criteria**:
- [ ] Login page created with email and password fields
- [ ] Register page created with email, password, confirm password
- [ ] Forgot password page with email recovery
- [ ] Password reset page with new password entry
- [ ] Form validation (client-side) with error messages
- [ ] Loading states during submission
- [ ] Error message display (from API)
- [ ] Success notifications
- [ ] Remember me option (optional)
- [ ] OAuth integration UI (Google, GitHub - optional)
- [ ] Link to registration from login
- [ ] Link to forgot password from login
- [ ] Responsive design (mobile, tablet, desktop)
- [ ] Accessibility compliant
- [ ] Integration with Redux auth slice
- [ ] Unit and integration tests
- [ ] Storybook stories (optional)

**Technical Details**:
```
Pages:
- /login - LoginPage component
- /register - RegisterPage component
- /forgot-password - ForgotPasswordPage
- /reset-password/:token - ResetPasswordPage

Forms:
- Client-side validation (Zod or Yup)
- API error handling
- Loading states
- Success messages
- TypeScript form types
```

**Subtasks**:
1. Create LoginPage component
2. Create login form with validation
3. Create RegisterPage component
4. Create register form
5. Create ForgotPasswordPage
6. Create ResetPasswordPage
7. Add form validation library (Zod/Yup)
8. Implement error handling
9. Implement loading states
10. Add success notifications
11. Integrate with Redux auth
12. Create tests for pages
13. Responsive styling
14. Accessibility review
15. Add error logging

**Dependencies**: STORY-12.1.1, STORY-12.1.2, STORY-12.1.3, STORY-12.2.1

---

### STORY-12.2.3: Create Product Listing & Details Pages
**Story Points**: 13  
**Priority**: HIGH  
**Assignee Type**: Frontend Developer  
**Sprint**: Sprint 28-29  

**Description**:
Build product catalog pages with search, filtering, and detailed product view.

**Acceptance Criteria**:
- [ ] Products listing page created
- [ ] Product cards displaying image, name, price, rating
- [ ] Search functionality
- [ ] Filtering by category
- [ ] Filtering by price range
- [ ] Sorting (by price, rating, newest)
- [ ] Pagination implemented
- [ ] Responsive grid layout (1-4 columns)
- [ ] Product detail page
- [ ] Product images gallery
- [ ] Product description, specifications
- [ ] Price and availability display
- [ ] Quantity selector
- [ ] Add to cart button
- [ ] Related products suggestion
- [ ] Product reviews section
- [ ] Loading skeletons
- [ ] Error handling
- [ ] SEO metadata
- [ ] Integration with Redux and API calls
- [ ] Tests for components

**Technical Details**:
```
Pages:
- /products - ProductListPage
- /products/:productId - ProductDetailPage

Features:
- Search: API call with debounce
- Filters: Category, price, rating
- Sorting: Multiple sort options
- Pagination: Page size 12-24 items
- Images: Lazy loading with CloudFront CDN
- Reviews: Inline rendering of reviews
```

**Subtasks**:
1. Create ProductListPage component
2. Create ProductCard component
3. Implement search with debounce
4. Implement filter sidebar
5. Implement sort dropdown
6. Implement pagination
7. Create ProductDetailPage component
8. Create product images gallery
9. Create product specifications section
10. Create reviews section
11. Add to cart button integration
12. Related products recommendation
13. Loading and error states
14. Responsive layout
15. Integration with API services
16. Create tests

**Dependencies**: STORY-12.1.1, STORY-12.1.2, STORY-12.2.1

---

## EPIC-12.3: Shopping & Order Pages
**Epic Story Points: 35 SP**

---

### STORY-12.3.1: Create Shopping Cart Page
**Story Points**: 10  
**Priority**: CRITICAL  
**Assignee Type**: Frontend Developer  
**Sprint**: Sprint 29  

**Description**:
Build shopping cart page with add/remove items, quantity update, and checkout flow.

**Acceptance Criteria**:
- [ ] Cart page displays all items
- [ ] Item card shows product image, name, price, quantity
- [ ] Quantity update buttons (+ and -)
- [ ] Remove item button
- [ ] Cart totals calculation (subtotal, tax, shipping estimate)
- [ ] Empty cart message with shop link
- [ ] Continue shopping link
- [ ] Proceed to checkout button
- [ ] Apply coupon code (optional)
- [ ] Save for later (optional)
- [ ] Responsive design
- [ ] Integration with Redux cart slice
- [ ] Integration with API (cart operations)
- [ ] Loading states
- [ ] Error handling
- [ ] Unit and integration tests
- [ ] Accessibility compliant

**Technical Details**:
```
Cart Page:
- Display items from Redux store
- Update quantity via API + Redux
- Remove item via API + Redux
- Calculate totals: subtotal, tax (10%), shipping
- Session persistence (localStorage or server)
- Update on every item change
```

**Subtasks**:
1. Create ShoppingCartPage component
2. Create CartItem component
3. Implement quantity update
4. Implement item removal
5. Create cart totals section
6. Implement totals calculation
7. Create empty cart view
8. Add continue shopping link
9. Add proceed to checkout button
10. Integrate with Redux
11. Integrate with cart API
12. Add loading states
13. Responsive layout
14. Tests
15. Accessibility review

**Dependencies**: STORY-12.1.1, STORY-12.1.2, STORY-12.2.1, STORY-12.1.3

---

### STORY-12.3.2: Create Checkout & Order Confirmation Pages
**Story Points**: 15  
**Priority**: CRITICAL  
**Assignee Type**: Frontend Senior Developer  
**Sprint**: Sprint 29-30  

**Description**:
Build multi-step checkout flow with shipping, billing, and payment pages.

**Acceptance Criteria**:
- [ ] Checkout flow (4 steps): Cart Review, Shipping, Payment, Confirmation
- [ ] Step indicator showing current step
- [ ] Cart review step displays items and totals
- [ ] Shipping address form (address, city, postal code, country)
- [ ] Shipping method selection with cost
- [ ] Billing address option (same as shipping or different)
- [ ] Payment method form (card details)
- [ ] Order review before final submission
- [ ] Form validation on each step
- [ ] Error handling and display
- [ ] Loading states during submission
- [ ] Order confirmation page
- [ ] Order number and details displayed
- [ ] Download invoice (optional)
- [ ] Track order button
- [ ] Email receipt sent (simulated)
- [ ] Responsive design (mobile optimized)
- [ ] Accessibility compliant
- [ ] Integration with Redux
- [ ] Integration with Order API
- [ ] Tests for pages

**Technical Details**:
```
Checkout Flow:
1. Review: Display cart items
2. Shipping: Address form + method selection
3. Payment: Card form (no PCI - backend handles)
4. Confirmation: Order summary

State Management:
- Redux: Checkout step, form data, order details
- Form Validation: Zod/Yup schemas
- Error Handling: API error messages displayed
```

**Subtasks**:
1. Create CheckoutPage wrapper
2. Create cart review step
3. Create shipping address form
4. Create shipping method selection
5. Create payment form component
6. Create order review step
7. Implement step navigation (next/previous)
8. Add form validation
9. Implement error handling
10. Create OrderConfirmationPage
11. Implement order details display
12. Add invoice download (optional)
13. Integrate with API
14. Add loading states
15. Responsive layout
16. Create tests
17. Accessibility review
18. Add email receipt (simulated)

**Dependencies**: STORY-12.1.1, STORY-12.1.2, STORY-12.3.1, STORY-12.2.1

---

### STORY-12.3.3: Create Order History & Tracking Pages
**Story Points**: 10  
**Priority**: HIGH  
**Assignee Type**: Frontend Developer  
**Sprint**: Sprint 30  

**Description**:
Build order history page and order tracking/details page.

**Acceptance Criteria**:
- [ ] Order history page displays all user orders
- [ ] Order list shows: Order #, Date, Status, Total, Action
- [ ] Filtering by status (all, completed, processing, cancelled)
- [ ] Sorting by date
- [ ] Pagination
- [ ] Click to view order details
- [ ] Order details page shows items, totals, shipping info
- [ ] Order status timeline with current status
- [ ] Tracking information (tracking number, carrier, estimated delivery)
- [ ] Download invoice
- [ ] Return/exchange option
- [ ] Contact seller option
- [ ] Responsive design
- [ ] Loading states
- [ ] Error handling
- [ ] Integration with API
- [ ] Tests

**Technical Details**:
```
Pages:
- /orders - OrderHistoryPage
- /orders/:orderId - OrderDetailsPage

Features:
- Display orders from API
- Status timeline visualization
- Tracking info integration
- Invoice generation (PDF)
- Status-based actions (cancel, return)
```

**Subtasks**:
1. Create OrderHistoryPage component
2. Create OrderCard component
3. Implement filter by status
4. Implement sorting
5. Implement pagination
6. Create OrderDetailsPage component
7. Create status timeline component
8. Display tracking information
9. Add invoice download
10. Add return/exchange form
11. Add contact seller button
12. Integrate with API
13. Add loading states
14. Responsive layout
15. Tests
16. Accessibility review

**Dependencies**: STORY-12.1.1, STORY-12.1.2, STORY-12.2.1

---

## EPIC-12.4: User Account & Services Integration
**Epic Story Points: 30 SP**

---

### STORY-12.4.1: Create User Profile & Account Pages
**Story Points**: 10  
**Priority**: HIGH  
**Assignee Type**: Frontend Developer  
**Sprint**: Sprint 30  

**Description**:
Build user profile, account settings, and address management pages.

**Acceptance Criteria**:
- [ ] User profile page displays personal info
- [ ] Edit profile form (name, email, phone)
- [ ] Change password form
- [ ] Profile picture upload (to S3)
- [ ] Address management page
- [ ] Add new address form
- [ ] Edit address form
- [ ] Delete address option
- [ ] Set default address
- [ ] Notification preferences (email, SMS, push)
- [ ] Account security settings (2FA optional)
- [ ] Account activity/login history (optional)
- [ ] Delete account option (optional)
- [ ] Form validation
- [ ] Success messages
- [ ] Error handling
- [ ] Loading states
- [ ] Responsive design
- [ ] Integration with API
- [ ] Tests

**Technical Details**:
```
Pages:
- /account/profile - ProfilePage
- /account/addresses - AddressManagementPage
- /account/settings - AccountSettingsPage

Features:
- Edit profile with validation
- Change password form
- Profile picture upload to S3
- Address CRUD operations
- Notification preferences
- Security settings
```

**Subtasks**:
1. Create ProfilePage component
2. Create profile edit form
3. Create change password form
4. Implement profile picture upload
5. Create AddressManagementPage
6. Create address list with edit/delete
7. Create add address form
8. Create account settings page
9. Create notification preferences form
10. Add API integration
11. Add form validation
12. Add success/error messages
13. Add loading states
14. Responsive layout
15. Tests
16. Accessibility review

**Dependencies**: STORY-12.1.1, STORY-12.1.2, STORY-12.2.1

---

### STORY-12.4.2: Create API Service Layer & React Query Integration
**Story Points**: 10  
**Priority**: HIGH  
**Assignee Type**: Frontend Senior Developer  
**Sprint**: Sprint 30-31  

**Description**:
Build API service layer with error handling and React Query for data fetching and caching.

**Acceptance Criteria**:
- [ ] API client setup with Axios
- [ ] React Query (TanStack Query) configured
- [ ] Typed API request/response interfaces
- [ ] Error handling middleware
- [ ] Request interceptors (JWT token injection)
- [ ] Response interceptors (error handling, token refresh)
- [ ] Query hooks for GET requests
- [ ] Mutation hooks for POST/PUT/DELETE
- [ ] Automatic retry on failure
- [ ] Request debouncing for search
- [ ] Pagination support
- [ ] Optimistic updates for mutations
- [ ] Cache invalidation strategies
- [ ] Loading and error states
- [ ] TypeScript types for all API endpoints
- [ ] Tests for API service

**Technical Details**:
```
API Service Structure:
services/
  api/
    client.ts - Axios client with interceptors
    auth.ts - Authentication API calls
    products.ts - Product API calls
    orders.ts - Order API calls
    user.ts - User API calls
    cart.ts - Cart API calls

React Query:
- useQuery for GET requests
- useMutation for POST/PUT/DELETE
- useInfiniteQuery for pagination
- Custom hooks: useAuth, useUser, useProducts, etc.
```

**Subtasks**:
1. Setup Axios client
2. Configure React Query
3. Create error handling middleware
4. Create request/response interceptors
5. Create typed API interfaces
6. Create authentication service
7. Create product service
8. Create order service
9. Create user service
10. Create cart service
11. Create custom React Query hooks
12. Implement automatic retry
13. Implement pagination support
14. Implement cache invalidation
15. Create tests for API service

**Dependencies**: STORY-12.1.1, STORY-12.1.3

---

### STORY-12.4.3: Create Reviews & Ratings Components
**Story Points**: 10  
**Priority**: HIGH  
**Assignee Type**: Frontend Developer  
**Sprint**: Sprint 31  

**Description**:
Build review submission and display components for product reviews and ratings.

**Acceptance Criteria**:
- [ ] Review list component showing all reviews
- [ ] Rating stars display
- [ ] Review text with formatting
- [ ] Reviewer name and date
- [ ] Helpful/unhelpful voting
- [ ] Image gallery in reviews
- [ ] Filter reviews by rating (1-5 stars)
- [ ] Sort reviews (newest, helpful, rating)
- [ ] Pagination for reviews
- [ ] Review submission form
- [ ] Star rating input (1-5)
- [ ] Review text area with character limit
- [ ] Image upload for reviews (optional)
- [ ] Form validation
- [ ] Success/error messages
- [ ] Responsive design
- [ ] Accessibility compliant
- [ ] Integration with API
- [ ] Tests

**Technical Details**:
```
Components:
- ReviewList - Display all reviews with filtering
- ReviewCard - Individual review display
- RatingStars - Star rating display
- ReviewForm - Submit new review
- RatingDistribution - Show rating breakdown

Features:
- Filter by rating
- Sort options
- Pagination
- Helpful voting
- Image display
```

**Subtasks**:
1. Create ReviewList component
2. Create ReviewCard component
3. Create RatingStars component
4. Implement filtering by rating
5. Implement sorting
6. Implement pagination
7. Create ReviewForm component
8. Implement star rating input
9. Add image upload (optional)
10. Add helpful voting
11. Form validation
12. API integration
13. Success/error handling
14. Loading states
15. Tests
16. Accessibility review

**Dependencies**: STORY-12.1.1, STORY-12.1.2, STORY-12.2.1

---

## EPIC-12.5: Admin Features & Testing
**Epic Story Points: 25 SP**

---

### STORY-12.5.1: Create Admin Dashboard & Product Management
**Story Points**: 12  
**Priority**: HIGH  
**Assignee Type**: Frontend Developer  
**Sprint**: Sprint 31-32  

**Description**:
Build admin dashboard with product management, orders, and user management interfaces.

**Acceptance Criteria**:
- [ ] Admin dashboard with key metrics (total sales, orders, users)
- [ ] Product management page
- [ ] Add new product form
- [ ] Edit product form
- [ ] Delete product confirmation
- [ ] Product images upload
- [ ] Inventory management
- [ ] Orders management page
- [ ] Order status update
- [ ] User management page
- [ ] User list with filters
- [ ] Role assignment
- [ ] Revenue reports/charts (optional)
- [ ] Sales analytics (optional)
- [ ] Access control (admin only)
- [ ] Responsive design
- [ ] Integration with API
- [ ] Tests

**Technical Details**:
```
Admin Pages:
- /admin - DashboardPage with metrics
- /admin/products - ProductManagementPage
- /admin/orders - OrderManagementPage
- /admin/users - UserManagementPage
- /admin/reports - ReportsPage (optional)

Features:
- CRUD for products
- Order status updates
- User role assignment
- Dashboard analytics
- Export reports
```

**Subtasks**:
1. Create admin dashboard page
2. Create dashboard metrics/widgets
3. Create product management page
4. Create product add/edit forms
5. Create image upload component
6. Create order management page
7. Create status update dropdown
8. Create user management page
9. Create user list with filters
10. Create role assignment form
11. Add access control/auth checks
12. API integration
13. Loading states
14. Error handling
15. Responsive layout
16. Tests
17. Accessibility review

**Dependencies**: STORY-12.1.1, STORY-12.1.2, STORY-12.2.1, STORY-12.4.2

---

### STORY-12.5.2: Testing, Optimization & Production Build
**Story Points**: 13  
**Priority**: HIGH  
**Assignee Type**: Frontend Developer / QA  
**Sprint**: Sprint 32-33  

**Description**:
Comprehensive testing, performance optimization, and production build configuration.

**Acceptance Criteria**:
- [ ] Unit tests for all components (>80% coverage)
- [ ] Integration tests for key workflows (login, checkout)
- [ ] E2E tests with Cypress or Playwright
- [ ] Performance optimization (code splitting, lazy loading)
- [ ] Bundle size analysis and optimization
- [ ] Image optimization (WebP, responsive images)
- [ ] Build size < 500KB (gzipped)
- [ ] Lighthouse score > 90 (Performance, Accessibility, Best Practices, SEO)
- [ ] PWA features (service workers, offline support - optional)
- [ ] Security headers configured
- [ ] Environment variables configured for production
- [ ] Error logging configured
- [ ] Analytics integration (optional)
- [ ] Production build tested
- [ ] Deployment to CloudFront configured
- [ ] Cache busting configured

**Technical Details**:
```
Testing:
- Unit: Jest + React Testing Library
- Integration: React Testing Library with API mocking
- E2E: Cypress or Playwright against dev backend
- Coverage: >80% overall

Performance:
- Code splitting by route
- Lazy loading images
- Tree shaking enabled
- Minification and compression
- CSS purging
- Bundle analysis with source-map-explorer
```

**Subtasks**:
1. Write unit tests for components
2. Write integration tests for workflows
3. Configure E2E tests (Cypress)
4. Setup code coverage reporting
5. Implement code splitting by route
6. Implement lazy loading for images
7. Optimize bundle size
8. Configure image optimization
9. Setup environment variables
10. Configure error logging (Sentry)
11. Setup analytics (optional)
12. Configure security headers
13. Setup PWA (optional)
14. Run Lighthouse audit
15. Optimize based on Lighthouse scores
16. Configure production build
17. Test production build locally
18. Setup S3/CloudFront deployment
19. Document deployment procedure

**Dependencies**: All Phase 12 stories

---

## Summary

## Updated Project Totals

| Component | Story Points | Duration |
|-----------|----------|----------|
| **Backend Microservices** (Phases 1-10) | 850 SP | 20 weeks |
| **AWS Cloud Infrastructure** (Phase 11) | 140 SP | 6 weeks |
| **React UI with TypeScript** (Phase 12) | 155 SP | 7 weeks |
| **TOTAL PROJECT** | **1,145 SP** | **29 weeks** |

**New Sprint Structure**: 18 sprints of 2 weeks each (36 weeks calendar time with buffers)

---

## AWS Free Tier Resources Timeline

### Year 1 (Free Tier - 12 Months):
- **EC2**: 750 hours/month of t2.micro (or t3.micro/t4g.micro)
- **RDS**: 750 hours/month of db.t3.micro Single-AZ
- **S3**: 5 GB of storage (across all buckets)
- **CloudFront**: 50 GB/month data transfer out
- **ECS**: Container orchestration (compute resources still count)
- **Lambda**: 1,000,000 requests/month (covered separately)
- **CloudWatch**: Logs, Metrics, Alarms
- **Route 53**: First hosted zone free, $0.50/month per additional zone
- **ECR**: 500 MB/month of storage

### Considerations:
- Focus on single-AZ RDS initially (Multi-AZ in production)
- Use t4g Graviton instances (better price/performance)
- Monitor costs via CloudWatch alarms
- Set budget alerts in AWS Cost Explorer
- Clean up unused resources monthly

---

## Critical Success Factors

### Development Team:
- **Backend Team**: 5-6 developers
- **Frontend Team**: 2-3 developers
- **DevOps**: 1-2 engineers
- **QA**: 1-2 testers
- **Total**: 9-13 people

### Dependencies & Risks:
1. **AWS Learning Curve**: Team needs AWS certification training (optional)
2. **Free Tier Limits**: Plan for paid resources after 12 months
3. **API Integration**: Frontend must wait for backend API stability
4. **Security**: AWS IAM and secrets management critical from day 1
5. **Performance**: Continuous monitoring required from Phase 11 onward

---

## Document History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-05-13 | Initial document with 10 phases, 850 SP |
| 2.0 | 2026-05-21 | Added Phase 11 (AWS Infrastructure, 120 SP) + Phase 12 (React UI, 155 SP). Total updated to 1,325 SP, 33 weeks |

---

**End of Updated Document**

