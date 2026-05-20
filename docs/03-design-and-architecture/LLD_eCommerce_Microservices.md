# eCommerce Microservices Platform - Low-Level Design (LLD)

**Document Version**: 1.0  
**Date**: May 13, 2026  
**Status**: Design Phase

---

## Table of Contents
1. [Database Schema Design](#database-schema-design)
2. [API Specifications](#api-specifications)
3. [Service Implementation Details](#service-implementation-details)
4. [Event & Message Structure](#event--message-structure)
5. [CQRS Read Models](#cqrs-read-models)
6. [Saga Workflow Details](#saga-workflow-details)
7. [Security Implementation](#security-implementation)
8. [Error Handling & Exception Strategy](#error-handling--exception-strategy)
9. [Caching Strategy](#caching-strategy)
10. [Deployment Configuration](#deployment-configuration)

---

## Database Schema Design

### 1.1 User Service Database

```sql
-- user_db

-- Users table
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone_number VARCHAR(15),
    profile_picture_url VARCHAR(500),
    user_type ENUM ('BUYER', 'SELLER', 'VENDOR') NOT NULL DEFAULT 'BUYER',
    status ENUM ('ACTIVE', 'INACTIVE', 'SUSPENDED', 'DELETED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    CONSTRAINT user_type_check CHECK (user_type IN ('BUYER', 'SELLER', 'VENDOR'))
);

-- User Roles (many-to-many relationship)
CREATE TABLE user_roles (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(user_id, role_id)
);

-- Roles
CREATE TABLE roles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT role_name_check CHECK (name IN ('ADMIN', 'USER', 'VENDOR', 'DEVELOPER'))
);

-- Role Permissions (many-to-many)
CREATE TABLE role_permissions (
    id BIGSERIAL PRIMARY KEY,
    role_id BIGINT NOT NULL,
    permission_id BIGINT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    UNIQUE(role_id, permission_id)
);

-- Permissions
CREATE TABLE permissions (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    resource VARCHAR(50) NOT NULL,
    action VARCHAR(50) NOT NULL
);

-- User Addresses
CREATE TABLE user_addresses (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    address_type ENUM ('SHIPPING', 'BILLING') NOT NULL,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state_province VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(50) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- User Sessions (for tracking active sessions)
CREATE TABLE user_sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    refresh_token_id VARCHAR(255) UNIQUE NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at)
);

-- Audit Log
CREATE TABLE user_audit_log (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    action VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id BIGINT,
    old_values JSONB,
    new_values JSONB,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX idx_user_addresses_user_id ON user_addresses(user_id);
```

### 1.2 Product Service Database

```sql
-- product_db

-- Categories
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    parent_category_id BIGINT,
    slug VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_slug (slug)
);

-- Products
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category_id BIGINT NOT NULL,
    seller_id BIGINT NOT NULL,
    base_price DECIMAL(12, 2) NOT NULL,
    discount_percentage DECIMAL(5, 2) DEFAULT 0,
    final_price DECIMAL(12, 2) GENERATED ALWAYS AS (base_price * (100 - discount_percentage) / 100) STORED,
    weight DECIMAL(8, 2),
    dimensions_length DECIMAL(8, 2),
    dimensions_width DECIMAL(8, 2),
    dimensions_height DECIMAL(8, 2),
    status ENUM ('ACTIVE', 'INACTIVE', 'DISCONTINUED', 'ARCHIVED') NOT NULL DEFAULT 'ACTIVE',
    ratings_count INT DEFAULT 0,
    ratings_average DECIMAL(3, 1) DEFAULT 0,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (seller_id) REFERENCES users(id),
    INDEX idx_category_id (category_id),
    INDEX idx_seller_id (seller_id),
    INDEX idx_status (status),
    INDEX idx_sku (sku),
    FULLTEXT INDEX ft_search (name, description)
);

-- Product Images
CREATE TABLE product_images (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    alt_text VARCHAR(255),
    display_order INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id)
);

-- Product Tags
CREATE TABLE product_tags (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL,
    tag_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id),
    INDEX idx_tag_name (tag_name)
);

-- Product Variants (e.g., different sizes, colors)
CREATE TABLE product_variants (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL,
    variant_name VARCHAR(100) NOT NULL,
    variant_value VARCHAR(100) NOT NULL,
    additional_price DECIMAL(12, 2) DEFAULT 0,
    sku_variant VARCHAR(50) UNIQUE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id)
);

-- Indexes for performance
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_products_created_at ON products(created_at);
CREATE INDEX idx_products_ratings ON products(ratings_average DESC);
```

### 1.3 Order Service Database

```sql
-- order_db

-- Orders
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    buyer_id BIGINT NOT NULL,
    order_status ENUM ('PENDING', 'CONFIRMED', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    payment_status ENUM ('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    shipping_status ENUM ('PENDING', 'IN_TRANSIT', 'DELIVERED', 'FAILED') NOT NULL DEFAULT 'PENDING',
    total_amount DECIMAL(12, 2) NOT NULL,
    tax_amount DECIMAL(12, 2) DEFAULT 0,
    shipping_cost DECIMAL(12, 2) DEFAULT 0,
    discount_amount DECIMAL(12, 2) DEFAULT 0,
    final_amount DECIMAL(12, 2) GENERATED ALWAYS AS (total_amount + tax_amount + shipping_cost - discount_amount) STORED,
    billing_address JSONB NOT NULL,
    shipping_address JSONB NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_buyer_id (buyer_id),
    INDEX idx_order_status (order_status),
    INDEX idx_order_number (order_number),
    INDEX idx_created_at (created_at)
);

-- Order Items
CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    seller_id BIGINT NOT NULL,
    product_name VARCHAR(255),
    product_sku VARCHAR(50),
    quantity INT NOT NULL,
    unit_price DECIMAL(12, 2) NOT NULL,
    line_total DECIMAL(12, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    variant_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id),
    INDEX idx_product_id (product_id),
    INDEX idx_seller_id (seller_id)
);

-- Order Events (for audit trail)
CREATE TABLE order_events (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    event_description TEXT,
    created_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id),
    INDEX idx_event_type (event_type)
);

-- Invoices
CREATE TABLE invoices (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL UNIQUE,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    invoice_date TIMESTAMP,
    due_date TIMESTAMP,
    subtotal DECIMAL(12, 2) NOT NULL,
    tax DECIMAL(12, 2),
    shipping DECIMAL(12, 2),
    total DECIMAL(12, 2) NOT NULL,
    pdf_url VARCHAR(500),
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_invoice_number (invoice_number)
);

-- Returns (for order returns/RMA)
CREATE TABLE order_returns (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    return_number VARCHAR(50) UNIQUE NOT NULL,
    return_status ENUM ('REQUESTED', 'APPROVED', 'REJECTED', 'COMPLETED', 'CANCELLED') NOT NULL,
    reason TEXT NOT NULL,
    items JSONB NOT NULL,
    refund_amount DECIMAL(12, 2),
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id),
    INDEX idx_return_status (return_status)
);

CREATE INDEX idx_orders_buyer_created ON orders(buyer_id, created_at DESC);
```

### 1.4 Cart Service Database

```sql
-- cart_db

-- Shopping Carts
CREATE TABLE shopping_carts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    cart_status ENUM ('ACTIVE', 'ABANDONED', 'CONVERTED_TO_ORDER', 'EXPIRED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    UNIQUE(user_id),
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at)
);

-- Cart Items
CREATE TABLE cart_items (
    id BIGSERIAL PRIMARY KEY,
    cart_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    variant_id BIGINT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(12, 2) NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cart_id) REFERENCES shopping_carts(id) ON DELETE CASCADE,
    INDEX idx_cart_id (cart_id),
    UNIQUE(cart_id, product_id, variant_id)
);

-- Abandoned Carts (for analytics)
CREATE TABLE abandoned_carts_analytics (
    id BIGSERIAL PRIMARY KEY,
    cart_id BIGINT NOT NULL,
    user_id BIGINT,
    item_count INT,
    total_value DECIMAL(12, 2),
    last_activity_at TIMESTAMP,
    abandoned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    recovered BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (cart_id) REFERENCES shopping_carts(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);
```

### 1.5 Payment Service Database

```sql
-- payment_db

-- Payments
CREATE TABLE payments (
    id BIGSERIAL PRIMARY KEY,
    payment_id VARCHAR(100) UNIQUE NOT NULL,
    order_id BIGINT NOT NULL,
    buyer_id BIGINT NOT NULL,
    payment_method ENUM ('CREDIT_CARD', 'DEBIT_CARD', 'NET_BANKING', 'WALLET', 'UPI') NOT NULL,
    payment_status ENUM ('PENDING', 'INITIATED', 'PROCESSING', 'COMPLETED', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    transaction_id VARCHAR(100),
    gateway_response JSONB,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_order_id (order_id),
    INDEX idx_payment_id (payment_id),
    INDEX idx_payment_status (payment_status)
);

-- Refunds
CREATE TABLE refunds (
    id BIGSERIAL PRIMARY KEY,
    refund_id VARCHAR(100) UNIQUE NOT NULL,
    payment_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    refund_status ENUM ('PENDING', 'INITIATED', 'PROCESSING', 'COMPLETED', 'FAILED') NOT NULL DEFAULT 'PENDING',
    amount DECIMAL(12, 2) NOT NULL,
    reason TEXT NOT NULL,
    gateway_response JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    FOREIGN KEY (payment_id) REFERENCES payments(id),
    INDEX idx_refund_id (refund_id),
    INDEX idx_refund_status (refund_status)
);

-- Payment Methods (for storing masked card details, etc.)
CREATE TABLE user_payment_methods (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    method_type ENUM ('CREDIT_CARD', 'DEBIT_CARD', 'NET_BANKING') NOT NULL,
    masked_details VARCHAR(255) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);
```

### 1.6 Notification Service Database

```sql
-- notification_db

-- Notifications
CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    notification_id VARCHAR(100) UNIQUE NOT NULL,
    recipient_id BIGINT,
    recipient_email VARCHAR(100),
    recipient_phone VARCHAR(15),
    notification_type ENUM ('ORDER_CONFIRMATION', 'PAYMENT_SUCCESS', 'PAYMENT_FAILED', 'SHIPMENT_ALERT', 'DELIVERY_ALERT', 'REVIEW_REQUEST', 'PROMOTIONAL', 'ACCOUNT_UPDATE') NOT NULL,
    channel ENUM ('EMAIL', 'SMS', 'PUSH', 'IN_APP') NOT NULL,
    subject VARCHAR(255),
    message_body TEXT NOT NULL,
    template_name VARCHAR(100),
    template_variables JSONB,
    status ENUM ('PENDING', 'SENT', 'DELIVERED', 'FAILED', 'BOUNCED') NOT NULL DEFAULT 'PENDING',
    retry_count INT DEFAULT 0,
    max_retries INT DEFAULT 3,
    sent_at TIMESTAMP,
    error_message TEXT,
    related_order_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_recipient_id (recipient_id),
    INDEX idx_status (status),
    INDEX idx_notification_type (notification_type)
);

-- Notification Templates
CREATE TABLE notification_templates (
    id BIGSERIAL PRIMARY KEY,
    template_name VARCHAR(100) UNIQUE NOT NULL,
    channel ENUM ('EMAIL', 'SMS') NOT NULL,
    subject_template VARCHAR(255),
    body_template TEXT NOT NULL,
    variables JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Notification Preferences
CREATE TABLE user_notification_preferences (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    email_notifications BOOLEAN DEFAULT TRUE,
    sms_notifications BOOLEAN DEFAULT TRUE,
    push_notifications BOOLEAN DEFAULT TRUE,
    promotional_emails BOOLEAN DEFAULT FALSE,
    order_updates BOOLEAN DEFAULT TRUE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### 1.7 Review & Rating Service Database

```sql
-- review_db

-- Reviews
CREATE TABLE reviews (
    id BIGSERIAL PRIMARY KEY,
    review_id VARCHAR(100) UNIQUE NOT NULL,
    product_id BIGINT NOT NULL,
    reviewer_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    helpful_count INT DEFAULT 0,
    unhelpful_count INT DEFAULT 0,
    review_status ENUM ('APPROVED', 'PENDING', 'REJECTED', 'WITHDRAWN') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_product_id (product_id),
    INDEX idx_reviewer_id (reviewer_id),
    INDEX idx_rating (rating),
    INDEX idx_created_at (created_at DESC)
);

-- Review Images
CREATE TABLE review_images (
    id BIGSERIAL PRIMARY KEY,
    review_id BIGINT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
    INDEX idx_review_id (review_id)
);

-- Review Responses (seller/admin responses to reviews)
CREATE TABLE review_responses (
    id BIGSERIAL PRIMARY KEY,
    review_id BIGINT NOT NULL UNIQUE,
    respondent_id BIGINT NOT NULL,
    response_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE
);

-- Helpful Reviews (user marking reviews as helpful)
CREATE TABLE review_helpfulness (
    id BIGSERIAL PRIMARY KEY,
    review_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    is_helpful BOOLEAN NOT NULL,
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
    UNIQUE(review_id, user_id)
);
```

### 1.8 Inventory/Warehouse Service Database

```sql
-- inventory_db

-- Warehouses
CREATE TABLE warehouses (
    id BIGSERIAL PRIMARY KEY,
    warehouse_code VARCHAR(50) UNIQUE NOT NULL,
    warehouse_name VARCHAR(100) NOT NULL,
    location_city VARCHAR(50),
    location_state VARCHAR(50),
    location_country VARCHAR(50),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    capacity INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_warehouse_code (warehouse_code)
);

-- Inventory
CREATE TABLE inventory (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL,
    warehouse_id BIGINT NOT NULL,
    available_quantity INT NOT NULL DEFAULT 0,
    reserved_quantity INT NOT NULL DEFAULT 0,
    damaged_quantity INT NOT NULL DEFAULT 0,
    total_quantity INT GENERATED ALWAYS AS (available_quantity + reserved_quantity + damaged_quantity) STORED,
    reorder_level INT,
    reorder_quantity INT,
    last_restock_at TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(id),
    UNIQUE(product_id, warehouse_id),
    INDEX idx_product_id (product_id),
    INDEX idx_warehouse_id (warehouse_id)
);

-- Stock Movements (audit trail)
CREATE TABLE stock_movements (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL,
    warehouse_id BIGINT NOT NULL,
    movement_type ENUM ('IN', 'OUT', 'ADJUSTMENT', 'DAMAGE', 'RETURN') NOT NULL,
    quantity INT NOT NULL,
    reference_id VARCHAR(100),
    reference_type VARCHAR(50),
    notes TEXT,
    created_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(id),
    INDEX idx_product_id (product_id),
    INDEX idx_movement_type (movement_type),
    INDEX idx_created_at (created_at)
);

-- Reserved Inventory (for orders in progress)
CREATE TABLE reserved_inventory (
    id BIGSERIAL PRIMARY KEY,
    reservation_id VARCHAR(100) UNIQUE NOT NULL,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    warehouse_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    reservation_status ENUM ('RESERVED', 'RELEASED', 'CONSUMED') NOT NULL DEFAULT 'RESERVED',
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    released_at TIMESTAMP,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(id),
    INDEX idx_order_id (order_id),
    INDEX idx_reservation_status (reservation_status)
);
```

### 1.9 Shipping Service Database

```sql
-- shipping_db

-- Shipments
CREATE TABLE shipments (
    id BIGSERIAL PRIMARY KEY,
    shipment_number VARCHAR(50) UNIQUE NOT NULL,
    order_id BIGINT NOT NULL,
    shipment_status ENUM ('PENDING', 'PICKED', 'PACKED', 'SHIPPED', 'IN_TRANSIT', 'OUT_FOR_DELIVERY', 'DELIVERED', 'FAILED', 'RETURNED') NOT NULL DEFAULT 'PENDING',
    tracking_number VARCHAR(100) UNIQUE,
    carrier_name VARCHAR(100),
    carrier_service VARCHAR(100),
    pickup_warehouse_id BIGINT,
    delivery_address JSONB NOT NULL,
    estimated_delivery_date DATE,
    actual_delivery_date DATE,
    shipped_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_order_id (order_id),
    INDEX idx_tracking_number (tracking_number),
    INDEX idx_shipment_status (shipment_status)
);

-- Shipment Items
CREATE TABLE shipment_items (
    id BIGSERIAL PRIMARY KEY,
    shipment_id BIGINT NOT NULL,
    order_item_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE
);

-- Shipment Events (tracking updates)
CREATE TABLE shipment_events (
    id BIGSERIAL PRIMARY KEY,
    shipment_id BIGINT NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    event_description TEXT,
    location_city VARCHAR(50),
    location_state VARCHAR(50),
    timestamp TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE,
    INDEX idx_shipment_id (shipment_id),
    INDEX idx_event_type (event_type)
);
```

---

## API Specifications

### 2.1 User Service APIs

```yaml
# Authentication & Authorization APIs

POST /v1/auth/register
  Description: Register a new user
  Request:
    - username: string (required, 3-50 chars)
    - email: string (required, valid email)
    - password: string (required, min 8 chars, complex password)
    - first_name: string (required)
    - last_name: string (required)
    - user_type: enum (BUYER|SELLER|VENDOR) (required)
  Response:
    - user_id: string
    - username: string
    - email: string
    - status: string
    - created_at: timestamp
  Status: 201 Created | 400 Bad Request | 409 Conflict
  Rate Limit: 5 requests per minute per IP

POST /v1/auth/login
  Description: Authenticate user and get tokens
  Request:
    - email: string (required)
    - password: string (required)
  Response:
    - access_token: string (JWT, 15-30 min expiry)
    - refresh_token: string (long-lived, stored in Redis)
    - token_type: string ("Bearer")
    - expires_in: number (seconds)
    - user: { id, email, username, roles }
  Status: 200 OK | 401 Unauthorized | 404 Not Found
  Rate Limit: 10 requests per minute per IP

POST /v1/auth/refresh-token
  Description: Refresh expired access token
  Request:
    - refresh_token: string (required)
  Response:
    - access_token: string (new JWT)
    - refresh_token: string (new or same)
    - expires_in: number
  Status: 200 OK | 400 Bad Request | 401 Unauthorized
  Rate Limit: 20 requests per minute per user

POST /v1/auth/logout
  Description: Logout user (invalidate tokens)
  Headers:
    - Authorization: Bearer {access_token}
  Request: {}
  Response:
    - message: string
  Status: 200 OK | 401 Unauthorized

GET /v1/users/{userId}
  Description: Get user profile
  Headers:
    - Authorization: Bearer {access_token}
  Response:
    - id: string
    - username: string
    - email: string
    - first_name: string
    - last_name: string
    - phone_number: string
    - user_type: enum
    - roles: array
    - profile_picture_url: string
    - created_at: timestamp
  Status: 200 OK | 401 Unauthorized | 404 Not Found
  Authorization: Self or Admin

PUT /v1/users/{userId}
  Description: Update user profile
  Headers:
    - Authorization: Bearer {access_token}
  Request:
    - first_name: string (optional)
    - last_name: string (optional)
    - phone_number: string (optional)
    - profile_picture_url: string (optional)
  Response: Updated user object
  Status: 200 OK | 400 Bad Request | 401 Unauthorized | 404 Not Found

POST /v1/users/{userId}/addresses
  Description: Add user address
  Headers:
    - Authorization: Bearer {access_token}
  Request:
    - address_type: enum (SHIPPING|BILLING) (required)
    - street_address: string (required)
    - city: string (required)
    - state_province: string (required)
    - postal_code: string (required)
    - country: string (required)
    - is_default: boolean (optional)
  Response:
    - address_id: string
    - user_id: string
    - address details...
  Status: 201 Created | 400 Bad Request | 401 Unauthorized

GET /v1/users/{userId}/addresses
  Description: Get user addresses
  Response: array of addresses

PUT /v1/users/{userId}/roles
  Description: Assign roles to user (Admin only)
  Headers:
    - Authorization: Bearer {admin_token}
  Request:
    - role_ids: array (required)
  Status: 200 OK | 401 Unauthorized | 403 Forbidden | 404 Not Found
```

### 2.2 Product Service APIs

```yaml
GET /v1/products
  Description: List products with filters & pagination
  Query Parameters:
    - category_id: number (optional)
    - search: string (optional, full-text search)
    - sort_by: enum (name|price|rating|created_at) (optional)
    - sort_order: enum (asc|desc) (optional)
    - page: number (required, min 1)
    - limit: number (required, min 1, max 100)
    - price_min: number (optional)
    - price_max: number (optional)
    - rating_min: number (optional)
  Response:
    - data: array of products
    - total_count: number
    - page: number
    - limit: number
    - has_more: boolean
  Status: 200 OK
  Cache: 5 minutes
  Rate Limit: 30 requests per minute

GET /v1/products/{productId}
  Description: Get product details
  Response:
    - id: string
    - sku: string
    - name: string
    - description: string
    - category_id: string
    - prices: { base_price, discount_percentage, final_price }
    - images: array
    - variants: array
    - ratings: { average, count }
    - seller: { id, name }
  Status: 200 OK | 404 Not Found
  Cache: 10 minutes

POST /v1/products
  Description: Create product (Seller/Vendor/Admin)
  Headers:
    - Authorization: Bearer {seller_token}
  Request:
    - sku: string (required, unique)
    - name: string (required)
    - description: string (required)
    - category_id: number (required)
    - base_price: decimal (required)
    - discount_percentage: decimal (optional, 0-100)
    - weight: decimal (optional)
    - dimensions: object (optional)
    - images: array (optional, URLs)
    - variants: array (optional)
  Response: Created product object with id
  Status: 201 Created | 400 Bad Request | 401 Unauthorized | 403 Forbidden
  Rate Limit: 10 requests per minute per user

PUT /v1/products/{productId}
  Description: Update product
  Restrictions: Only seller/admin who created product
  Request: Product fields (subset of POST)
  Status: 200 OK | 400 Bad Request | 401 Unauthorized | 403 Forbidden | 404 Not Found

DELETE /v1/products/{productId}
  Description: Delete/archive product
  Status: 204 No Content | 401 Unauthorized | 403 Forbidden | 404 Not Found

GET /v1/categories
  Description: Get product categories
  Response:
    - id: string
    - name: string
    - parent_category_id: string (nullable)
    - subcategories: array
  Cache: 1 hour
  Status: 200 OK
```

### 2.3 Order Service APIs

```yaml
POST /v1/orders
  Description: Create new order
  Headers:
    - Authorization: Bearer {buyer_token}
  Request:
    - cart_id: string (required)
    - billing_address_id: string (required)
    - shipping_address_id: string (required)
    - notes: string (optional)
    - coupon_code: string (optional)
  Response:
    - order_id: string
    - order_number: string
    - order_status: string (PENDING)
    - payment_status: string (PENDING)
    - total_amount: decimal
    - created_at: timestamp
  Status: 201 Created | 400 Bad Request | 401 Unauthorized
  Rate Limit: 5 requests per minute
  Workflow: Triggers Order Processing Saga

GET /v1/orders/{orderId}
  Description: Get order details
  Headers:
    - Authorization: Bearer {token}
  Response:
    - id: string
    - order_number: string
    - buyer_id: string
    - items: array (with product details)
    - statuses: { order, payment, shipping }
    - amounts: { subtotal, tax, shipping, discount, total }
    - addresses: { billing, shipping }
    - shipments: array (if available)
  Status: 200 OK | 401 Unauthorized | 404 Not Found
  Authorization: Buyer, Seller (for items), or Admin

GET /v1/orders
  Description: List user's orders
  Query Parameters:
    - page: number (required)
    - limit: number (required)
    - status: string (optional, filter by order status)
  Response:
    - data: array
    - pagination: { page, limit, total_count, has_more }
  Status: 200 OK | 401 Unauthorized

PUT /v1/orders/{orderId}/status
  Description: Update order status (Admin/System)
  Headers:
    - Authorization: Bearer {admin_token}
  Request:
    - status: enum (CONFIRMED|PROCESSING|SHIPPED|DELIVERED|CANCELLED|REFUNDED)
  Response: Updated order object
  Status: 200 OK | 400 Bad Request | 401 Unauthorized | 404 Not Found

POST /v1/orders/{orderId}/cancel
  Description: Cancel order
  Restrictions: Only if order is in PENDING/CONFIRMED status
  Request: { reason: string (optional) }
  Response: Cancelled order
  Status: 200 OK | 400 Bad Request | 401 Unauthorized | 404 Not Found
  Workflow: Triggers compensating saga transaction

POST /v1/orders/{orderId}/return
  Description: Request order return
  Request:
    - items: array (required, item_id list)
    - reason: string (required)
  Response: Return request object
  Status: 201 Created | 400 Bad Request | 401 Unauthorized
```

### 2.4 Cart Service APIs

```yaml
GET /v1/carts/{cartId}
  Description: Get shopping cart
  Headers:
    - Authorization: Bearer {token}
  Response:
    - cart_id: string
    - user_id: string
    - items: array (with product details, pricing)
    - item_count: number
    - subtotal: decimal
    - estimated_tax: decimal
    - estimated_shipping: decimal
    - total: decimal
    - created_at: timestamp
    - updated_at: timestamp
  Status: 200 OK | 401 Unauthorized | 404 Not Found
  Cache: Session duration (via Redis)

POST /v1/carts/{cartId}/items
  Description: Add item to cart
  Request:
    - product_id: string (required)
    - quantity: number (required, min 1)
    - variant_id: string (optional)
  Response: Updated cart
  Status: 201 Created | 400 Bad Request | 401 Unauthorized
  Rate Limit: 20 requests per minute

DELETE /v1/carts/{cartId}/items/{itemId}
  Description: Remove item from cart
  Status: 204 No Content | 401 Unauthorized | 404 Not Found

PUT /v1/carts/{cartId}/items/{itemId}
  Description: Update item quantity
  Request:
    - quantity: number (required, min 1)
  Response: Updated cart
  Status: 200 OK | 400 Bad Request | 401 Unauthorized

POST /v1/carts/{cartId}/checkout
  Description: Initiate checkout
  Request:
    - billing_address_id: string (required)
    - shipping_address_id: string (required)
  Response:
    - checkout_session_id: string
    - redirect_url: string
  Status: 200 OK | 400 Bad Request | 401 Unauthorized

DELETE /v1/carts/{cartId}
  Description: Clear cart
  Status: 204 No Content | 401 Unauthorized
```

### 2.5 Payment Service APIs

```yaml
POST /v1/payments
  Description: Process payment for order
  Headers:
    - Authorization: Bearer {system_token}
  Request:
    - order_id: string (required)
    - buyer_id: string (required)
    - payment_method: enum (CREDIT_CARD|DEBIT_CARD|NET_BANKING|WALLET) (required)
    - amount: decimal (required)
  Response:
    - payment_id: string
    - payment_status: string (INITIATED|PROCESSING)
    - transaction_id: string (if available)
  Status: 200 OK | 400 Bad Request | 401 Unauthorized
  Async: Completes asynchronously, updates via Kafka event

GET /v1/payments/{paymentId}
  Description: Get payment status
  Response:
    - id: string
    - order_id: string
    - amount: decimal
    - payment_status: string
    - payment_method: string
    - created_at: timestamp
  Status: 200 OK | 404 Not Found

POST /v1/payments/{paymentId}/refund
  Description: Refund payment
  Headers:
    - Authorization: Bearer {admin_token}
  Request:
    - reason: string (required)
    - amount: decimal (optional, for partial refund)
  Response: Refund object
  Status: 201 Created | 400 Bad Request | 401 Unauthorized
```

### 2.6 Notification Service APIs

```yaml
POST /v1/notifications/email/send
  Description: Send email notification
  Headers:
    - Authorization: Bearer {system_token}
  Request:
    - recipient_email: string (required)
    - template_name: string (required)
    - variables: object (optional)
    - subject: string (optional, overrides template)
  Response:
    - notification_id: string
    - status: string (PENDING|SENT)
  Status: 202 Accepted | 400 Bad Request | 401 Unauthorized

POST /v1/notifications/sms/send
  Description: Send SMS notification
  Request:
    - recipient_phone: string (required)
    - message: string (required)
  Response:
    - notification_id: string
    - status: string
  Status: 202 Accepted | 400 Bad Request

GET /v1/notifications/{notificationId}
  Description: Get notification status
  Response:
    - id: string
    - status: string (PENDING|SENT|DELIVERED|FAILED)
    - sent_at: timestamp
    - error_message: string (if failed)
  Status: 200 OK | 404 Not Found
```

### 2.7 Review Service APIs

```yaml
POST /v1/reviews
  Description: Create product review
  Headers:
    - Authorization: Bearer {buyer_token}
  Request:
    - product_id: string (required)
    - order_id: string (required, buyer must have purchased)
    - rating: number (required, 1-5)
    - title: string (required)
    - content: string (required, min 10 chars)
    - images: array (optional, URLs)
  Response:
    - review_id: string
    - status: string (PENDING|APPROVED)
    - created_at: timestamp
  Status: 201 Created | 400 Bad Request | 401 Unauthorized

GET /v1/reviews
  Description: Get reviews for product
  Query Parameters:
    - product_id: string (required)
    - page: number (optional)
    - limit: number (optional)
    - sort_by: enum (helpful|recent|rating) (optional)
  Response:
    - reviews: array
    - pagination: object
  Status: 200 OK
  Cache: 5 minutes

PUT /v1/reviews/{reviewId}
  Description: Update review (reviewer only, before approval)
  Request:
    - rating: number (optional)
    - content: string (optional)
  Status: 200 OK | 401 Unauthorized | 403 Forbidden | 404 Not Found

DELETE /v1/reviews/{reviewId}
  Description: Delete review
  Status: 204 No Content | 401 Unauthorized | 403 Forbidden

POST /v1/reviews/{reviewId}/responses
  Description: Add response to review (seller/admin)
  Request:
    - response_text: string (required)
  Status: 201 Created | 401 Unauthorized | 403 Forbidden
```

### 2.8 Inventory Service APIs

```yaml
GET /v1/inventory/{productId}
  Description: Get inventory/stock levels
  Query Parameters:
    - warehouse_id: string (optional, specific warehouse)
  Response:
    - product_id: string
    - total_available: number (aggregate or by warehouse)
    - reserved: number
    - warehouses: array (if no specific warehouse)
  Status: 200 OK
  Cache: 30 seconds (expires frequently)

POST /v1/inventory/reserve
  Description: Reserve inventory for order (internal, called by Saga)
  Headers:
    - Authorization: Bearer {service_token}
  Request:
    - order_id: string (required)
    - items: array
      - product_id: string
      - quantity: number
  Response:
    - reservation_id: string
    - order_id: string
    - status: string (RESERVED)
  Status: 200 OK | 400 Bad Request (insufficient stock) | 401 Unauthorized

POST /v1/inventory/release
  Description: Release reserved inventory (on order cancel/return)
  Request:
    - reservation_id: string (required)
  Status: 200 OK | 404 Not Found

PUT /v1/inventory/{productId}
  Description: Update inventory (add/reduce stock)
  Headers:
    - Authorization: Bearer {vendor_token}
  Request:
    - warehouse_id: string (required)
    - quantity_change: number (required, positive or negative)
    - reason: string (required, RESTOCK|DAMAGE|ADJUSTMENT)
  Status: 200 OK | 400 Bad Request

GET /v1/warehouses
  Description: List warehouses
  Response:
    - warehouses: array
  Status: 200 OK
  Cache: 1 hour
```

### 2.9 Shipping Service APIs

```yaml
POST /v1/shipments
  Description: Create shipment (triggered by Saga)
  Headers:
    - Authorization: Bearer {system_token}
  Request:
    - order_id: string (required)
    - warehouse_id: string (required)
    - delivery_address: object (required)
    - items: array (required)
  Response:
    - shipment_id: string
    - shipment_number: string
    - tracking_number: string (if assigned)
  Status: 201 Created | 400 Bad Request | 401 Unauthorized

GET /v1/shipments/{shipmentId}
  Description: Get shipment details
  Response:
    - id: string
    - shipment_number: string
    - order_id: string
    - status: string
    - tracking_number: string
    - carrier: string
    - estimated_delivery: date
    - events: array (tracking updates)
  Status: 200 OK | 404 Not Found

GET /v1/tracking/{trackingNumber}
  Description: Track shipment by tracking number
  Response: Shipment details with event history
  Status: 200 OK | 404 Not Found
  Cache: 1 minute (updates frequently)

PUT /v1/shipments/{shipmentId}/status
  Description: Update shipment status (system/carrier integration)
  Request:
    - status: enum (SHIPPED|IN_TRANSIT|OUT_FOR_DELIVERY|DELIVERED|FAILED)
    - event_description: string (optional)
  Status: 200 OK | 400 Bad Request
```

---

## Service Implementation Details

### 3.1 Technology Stack per Service

**All Services Common:**
- Framework: Spring Boot 3.x
- Build Tool: Maven / Gradle
- Language: Java 21
- Container: Docker
- Configuration: Spring Cloud Config
- Service Discovery: Spring Cloud Netflix Eureka
- API Gateway: Spring Cloud Gateway (before routing to services)
- Resilience: Resilience4j (circuit breaker, retry, rate limiter)
- REST Client: OpenFeign (with Resilience4j)
- Caching: Spring Cache + Redis (Lettuce client)
- Message Broker: Apache Kafka (Spring Kafka)
- Authentication: Spring Security + JWT (jjwt library)
- Database: PostgreSQL with Spring Data JPA
- ORM: Hibernate
- API Documentation: Springdoc OpenAPI (Swagger)
- Testing: JUnit 5, Mockito, TestContainers
- Logging: SLF4J + Logback (with Splunk appender)
- Monitoring: Micrometer + Prometheus
- Tracing: Spring Cloud Sleuth + Zipkin
- Encryption: Spring Security Crypto

### 3.2 Service Structure (Maven Module Layout)

```
ecommerce-platform/
├── parent-pom.xml
├── common-lib/
│   ├── pom.xml
│   ├── src/
│   │   ├── main/java/com/ecommerce/common/
│   │   │   ├── dto/
│   │   │   │   ├── ApiResponse.java
│   │   │   │   ├── ErrorResponse.java
│   │   │   │   ├── PaginatedResponse.java
│   │   │   │   └── ...
│   │   │   ├── exception/
│   │   │   │   ├── ServiceException.java
│   │   │   │   ├── BusinessException.java
│   │   │   │   ├── ResourceNotFoundException.java
│   │   │   │   └── ...
│   │   │   ├── config/
│   │   │   │   ├── JwtConfig.java
│   │   │   │   ├── CacheConfig.java
│   │   │   │   ├── FeignClientConfig.java
│   │   │   │   └── ...
│   │   │   ├── security/
│   │   │   │   ├── JwtTokenProvider.java
│   │   │   │   ├── UserContext.java
│   │   │   │   └── ...
│   │   │   ├── constants/
│   │   │   │   ├── ApiConstants.java
│   │   │   │   ├── CacheKeyConstants.java
│   │   │   │   └── ...
│   │   │   └── util/
│   │   │       ├── DateUtil.java
│   │   │       ├── ValidationUtil.java
│   │   │       └── ...
│   │   └── test/java/ (unit tests)
│
├── user-service/
│   ├── pom.xml
│   ├── src/main/java/com/ecommerce/user/
│   │   ├── UserServiceApplication.java
│   │   ├── controller/
│   │   │   ├── AuthController.java
│   │   │   ├── UserController.java
│   │   │   └── RoleController.java
│   │   ├── service/
│   │   │   ├── AuthService.java
│   │   │   ├── UserService.java
│   │   │   ├── RoleService.java
│   │   │   └── impl/
│   │   │       ├── AuthServiceImpl.java
│   │   │       ├── UserServiceImpl.java
│   │   │       └── RoleServiceImpl.java
│   │   ├── repository/
│   │   │   ├── UserRepository.java
│   │   │   ├── RoleRepository.java
│   │   │   ├── UserRoleRepository.java
│   │   │   └── UserAddressRepository.java
│   │   ├── entity/
│   │   │   ├── User.java
│   │   │   ├── Role.java
│   │   │   ├── Permission.java
│   │   │   ├── UserAddress.java
│   │   │   └── ...
│   │   ├── dto/
│   │   │   ├── request/
│   │   │   │   ├── RegisterRequest.java
│   │   │   │   ├── LoginRequest.java
│   │   │   │   ├── UpdateUserRequest.java
│   │   │   │   └── ...
│   │   │   └── response/
│   │   │       ├── UserDTO.java
│   │   │       ├── AuthResponse.java
│   │   │       └── ...
│   │   ├── mapper/
│   │   │   ├── UserMapper.java
│   │   │   └── RoleMapper.java
│   │   ├── config/
│   │   │   ├── UserServiceConfig.java
│   │   │   └── SecurityConfig.java
│   │   └── event/
│   │       ├── UserCreatedEvent.java
│   │       └── UserEventPublisher.java
│   ├── src/main/resources/
│   │   ├── application.yml
│   │   ├── application-dev.yml
│   │   └── db/migration/ (Flyway migrations)
│   └── pom.xml
│
├── product-service/
│   ├── pom.xml
│   ├── src/main/java/com/ecommerce/product/
│   │   ├── ProductServiceApplication.java
│   │   ├── controller/
│   │   ├── service/
│   │   ├── repository/
│   │   ├── entity/
│   │   ├── dto/
│   │   ├── mapper/
│   │   ├── cqrs/
│   │   │   ├── command/
│   │   │   ├── query/
│   │   │   ├── event/
│   │   │   └── handler/
│   │   └── config/
│   └── pom.xml
│
├── order-service/
│   ├── pom.xml
│   ├── src/main/java/com/ecommerce/order/
│   │   ├── OrderServiceApplication.java
│   │   ├── controller/
│   │   ├── service/
│   │   ├── repository/
│   │   ├── entity/
│   │   ├── dto/
│   │   ├── mapper/
│   │   ├── client/
│   │   │   ├── CartServiceClient.java (Feign)
│   │   │   ├── InventoryServiceClient.java (Feign)
│   │   │   └── PaymentServiceClient.java (Feign)
│   │   ├── cqrs/
│   │   ├── event/
│   │   └── config/
│   └── pom.xml
│
├── saga-orchestrator/
│   ├── pom.xml
│   ├── src/main/java/com/ecommerce/saga/
│   │   ├── SagaOrchestratorApplication.java
│   │   ├── orchestrator/
│   │   │   ├── OrderProcessingSaga.java
│   │   │   ├── OrderFulfillmentSaga.java
│   │   │   └── CompensationHandler.java
│   │   ├── state/
│   │   ├── event/
│   │   ├── repository/
│   │   └── config/
│   └── pom.xml
│
├── api-gateway/
│   ├── pom.xml
│   ├── src/main/java/com/ecommerce/gateway/
│   │   ├── ApiGatewayApplication.java
│   │   ├── config/
│   │   │   ├── GatewayConfig.java
│   │   │   ├── SecurityConfig.java
│   │   │   └── RateLimitingConfig.java
│   │   ├── filter/
│   │   │   ├── JwtAuthenticationFilter.java
│   │   │   ├── LoggingFilter.java
│   │   │   └── RateLimitingFilter.java
│   │   ├── exception/
│   │   │   └── GlobalExceptionHandler.java
│   │   └── util/
│   └── pom.xml
│
├── eureka-server/
│   └── pom.xml
│
├── config-server/
│   └── pom.xml
│
├── docker-compose.yml
├── kubernetes/
│   ├── namespace.yml
│   ├── configmap/
│   ├── secrets/
│   ├── deployments/
│   │   ├── user-service-deployment.yml
│   │   ├── product-service-deployment.yml
│   │   └── ...
│   ├── services/
│   ├── ingress/
│   └── helm/
│       └── ecommerce-chart/
│
└── README.md
```

---

## Event & Message Structure

### 4.1 Kafka Topics & Message Format

**Topic: order.created**
```json
{
  "event_id": "evt-123456",
  "event_type": "ORDER_CREATED",
  "timestamp": "2026-05-13T10:30:45Z",
  "order_id": "order-123",
  "buyer_id": "user-456",
  "items": [
    {
      "product_id": "prod-789",
      "quantity": 2,
      "unit_price": 29.99
    }
  ],
  "total_amount": 59.98,
  "shipping_address": { ... },
  "source": "order-service",
  "version": "1.0"
}
```

**Topic: order.payment-processed**
```json
{
  "event_id": "evt-789012",
  "event_type": "ORDER_PAYMENT_PROCESSED",
  "timestamp": "2026-05-13T10:31:00Z",
  "order_id": "order-123",
  "payment_id": "pay-345",
  "payment_status": "COMPLETED",
  "amount": 59.98,
  "transaction_id": "txn-xyz123",
  "source": "payment-service"
}
```

**Topic: inventory.reserved**
```json
{
  "event_id": "evt-345678",
  "event_type": "INVENTORY_RESERVED",
  "timestamp": "2026-05-13T10:31:05Z",
  "order_id": "order-123",
  "reservation_id": "resv-111",
  "items": [
    {
      "product_id": "prod-789",
      "quantity": 2,
      "warehouse_id": "wh-001"
    }
  ],
  "source": "inventory-service"
}
```

### 4.2 Kafka Consumer Groups

```
Service                  Consumer Group              Subscribed Topics
------------------------------------------------------------------------------------
Notification Service     notification-group         order.*, payment.*, inventory.*
Analytics Service        analytics-group            all topics (event streaming)
Saga Orchestrator        saga-orchestrator-group    payment.*, inventory.*, shipment.*
Order Service            order-consumer-group       payment.*, shipment.*
Admin Service            admin-analytics-group      all topics
```

---

## CQRS Read Models

### 5.1 Read Model Database Schema (Elasticsearch-backed)

```
Index: product-catalog-view
{
  "mappings": {
    "properties": {
      "product_id": { "type": "keyword" },
      "sku": { "type": "keyword" },
      "name": { "type": "text" },
      "description": { "type": "text" },
      "category": { "type": "keyword" },
      "price": { "type": "scaled_float", "scaling_factor": 100 },
      "rating": { "type": "float" },
      "review_count": { "type": "integer" },
      "images": { "type": "nested" },
      "availability": { "type": "keyword" },
      "created_at": { "type": "date" },
      "updated_at": { "type": "date" }
    }
  }
}
```

### 5.2 Read Model Update Pattern

```
Write Model (Order Service)
       ↓
Event Published to Kafka (order.created)
       ↓
Analytics/CQRS Consumer (Order Read Model Service)
       ↓
Denormalized Data Written to Read Store (PostgreSQL or Elasticsearch)
       ↓
Subsequent Queries Read from Read Store (optimized queries, no joins required)
```

---

## Saga Workflow Details

### 6.1 Order Processing Saga (Orchestration Pattern)

```
Start: Order Created (from Order Service)
  ↓
Step 1: Validate Order & Items
  Service: Order Service
  Action: Check order validity, user, items availability
  Success → Step 2
  Failure → Compensate (notify user, rollback cart)
  ↓
Step 2: Reserve Inventory
  Service: Inventory Service (via Saga Orchestrator)
  Action: Reserve stock for each item
  Success → Step 3
  Failure → Compensate (release reservations, notify user)
  Timeout: 30 seconds, else auto-rollback
  ↓
Step 3: Process Payment
  Service: Payment Service (via Saga Orchestrator)
  Action: Process payment (simulated)
  Success → Step 4
  Failure → Compensate (release inventory, refund, notify user)
  Timeout: 60 seconds, else manual intervention
  ↓
Step 4: Create Shipment
  Service: Shipping Service (via Saga Orchestrator)
  Action: Create shipment, assign tracking number
  Success → Step 5
  Failure → Compensate (release inventory, refund payment, notify user)
  ↓
Step 5: Update Order Status
  Service: Order Service
  Action: Update order to CONFIRMED/PROCESSING
  ↓
Step 6: Send Notifications
  Service: Notification Service
  Action: Send order confirmation email, SMS
  Async (Kafka), non-blocking
  ↓
End: Order Processing Complete
    Order Status: CONFIRMED
    Payment Status: COMPLETED
    Shipment: CREATED
```

**Compensation/Rollback Chain (if any step fails):**
```
Payment Failed
  ↓ Release Inventory
  ↓ Notify inventory service
  ↓ Update order status to PAYMENT_FAILED
  ↓ Send failure notification to user
  ↓ Log saga failure in audit
```

### 6.2 Saga Orchestrator Implementation

```java
@Service
public class OrderProcessingSaga {

    @Autowired
    private InventoryServiceClient inventoryClient;
    
    @Autowired
    private PaymentServiceClient paymentClient;
    
    @Autowired
    private ShippingServiceClient shippingClient;
    
    @Autowired
    private SagaStateRepository stateRepo;
    
    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;

    @Transactional
    public void executeOrderSaga(Order order) {
        SagaState sagaState = new SagaState(order.getId(), SagaStatus.STARTED);
        stateRepo.save(sagaState);

        try {
            // Step 1: Reserve Inventory
            InventoryReservation reservation = 
                inventoryClient.reserveInventory(order.getItems());
            sagaState.setInventoryReservationId(reservation.getId());
            
            // Step 2: Process Payment
            Payment payment = paymentClient.processPayment(order);
            sagaState.setPaymentId(payment.getId());
            
            // Step 3: Create Shipment
            Shipment shipment = shippingClient.createShipment(order);
            sagaState.setShipmentId(shipment.getId());
            
            // Step 4: Mark as Complete
            sagaState.setStatus(SagaStatus.COMPLETED);
            stateRepo.save(sagaState);
            
            // Publish completion event
            publishOrderConfirmed(order);
            
        } catch (Exception e) {
            // Compensation steps
            compensate(sagaState, e);
        }
    }

    private void compensate(SagaState state, Exception error) {
        if (state.getPaymentId() != null) {
            paymentClient.refundPayment(state.getPaymentId());
        }
        if (state.getInventoryReservationId() != null) {
            inventoryClient.releaseReservation(state.getInventoryReservationId());
        }
        state.setStatus(SagaStatus.COMPENSATED);
        state.setErrorMessage(error.getMessage());
        stateRepo.save(state);
    }
}
```

---

## Security Implementation

### 7.1 JWT Token Structure

```json
{
  "alg": "RS256",
  "typ": "JWT"
}
.
{
  "sub": "user-123",
  "email": "buyer@example.com",
  "username": "john_doe",
  "roles": ["USER", "BUYER"],
  "permissions": ["read:products", "create:orders", "read:reviews"],
  "iat": 1715589045,
  "exp": 1715590845,
  "iss": "ecommerce-platform",
  "aud": "ecommerce-api"
}
.
[signature]
```

### 7.2 API Gateway JWT Validation Filter

```java
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Override
    protected void doFilterInternal(HttpServletRequest request, 
                                   HttpServletResponse response, 
                                   FilterChain filterChain)
            throws ServletException, IOException {
        
        String token = extractToken(request);
        
        if (token != null && tokenProvider.validateToken(token)) {
            UserContext userContext = tokenProvider.getUserContext(token);
            // Store in SecurityContext or ThreadLocal
            UserContextHolder.set(userContext);
            filterChain.doFilter(request, response);
        } else if (shouldRefreshToken(request)) {
            String newToken = tokenProvider.refreshToken(token);
            response.setHeader("Authorization", "Bearer " + newToken);
            filterChain.doFilter(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Unauthorized");
        }
    }

    private String extractToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}
```

### 7.3 Role-Based Authorization

```java
@RestController
@RequestMapping("/v1/products")
public class ProductController {

    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('VENDOR')")
    public ResponseEntity<?> createProduct(@RequestBody ProductRequest req) {
        // Only Admin and Vendor can create products
        return ResponseEntity.ok(...);
    }

    @GetMapping
    @PreAuthorize("permitAll()")
    public ResponseEntity<?> listProducts(...) {
        // Anyone can list products
        return ResponseEntity.ok(...);
    }

    @DeleteMapping("/{productId}")
    @PreAuthorize("hasRole('ADMIN') or @productService.isProductOwner(#productId)")
    public ResponseEntity<?> deleteProduct(@PathVariable String productId) {
        // Only Admin or product owner (vendor) can delete
        return ResponseEntity.ok(...);
    }
}
```

---

## Error Handling & Exception Strategy

### 8.1 Global Exception Handler (API Gateway)

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationException(
            MethodArgumentNotValidException ex) {
        ErrorResponse error = new ErrorResponse(
            "VALIDATION_ERROR",
            "Request validation failed",
            ex.getBindingResult().getFieldErrors()
                .stream()
                .map(e -> e.getField() + ": " + e.getDefaultMessage())
                .collect(Collectors.toList())
        );
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<ErrorResponse> handleAuthException(
            AuthenticationException ex) {
        ErrorResponse error = new ErrorResponse(
            "AUTHENTICATION_ERROR",
            "Authentication failed",
            Collections.singletonList(ex.getMessage())
        );
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ErrorResponse> handleAccessDenied(
            AccessDeniedException ex) {
        ErrorResponse error = new ErrorResponse(
            "AUTHORIZATION_ERROR",
            "Access denied",
            Collections.singletonList(ex.getMessage())
        );
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error);
    }

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(
            ResourceNotFoundException ex) {
        ErrorResponse error = new ErrorResponse(
            "NOT_FOUND",
            ex.getMessage(),
            null
        );
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGenericException(
            Exception ex) {
        ErrorResponse error = new ErrorResponse(
            "INTERNAL_SERVER_ERROR",
            "An unexpected error occurred",
            Collections.singletonList(ex.getMessage())
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(error);
    }
}
```

### 8.2 Error Response Structure

```json
{
  "timestamp": "2026-05-13T10:30:45Z",
  "error_code": "VALIDATION_ERROR",
  "message": "Request validation failed",
  "details": [
    "email: Invalid email format",
    "password: Must contain at least 8 characters"
  ],
  "trace_id": "550e8400-e29b-41d4-a716-446655440000",
  "path": "/v1/auth/register"
}
```

---

## Caching Strategy

### 9.1 Cache Configuration (Redis)

```java
@Configuration
@EnableCaching
public class CacheConfig {

    @Bean
    public CacheManager cacheManager(LettuceConnectionFactory factory) {
        return RedisCacheManager.create(factory);
    }

    @Bean
    public LettuceConnectionFactory redisConnectionFactory() {
        return new LettuceConnectionFactory();
    }
}
```

### 9.2 Caching Annotations

```java
@Service
public class ProductService {

    @Cacheable(value = "products", key = "#productId", 
               unless = "#result == null")
    public ProductDTO getProduct(String productId) {
        // Fetch from database
        return productRepository.findById(productId)
            .map(this::mapToDTO)
            .orElse(null);
    }

    @CachePut(value = "products", key = "#productId")
    public ProductDTO updateProduct(String productId, ProductDTO dto) {
        // Update database and cache
        Product product = mapToEntity(dto);
        return mapToDTO(productRepository.save(product));
    }

    @CacheEvict(value = "products", key = "#productId")
    public void deleteProduct(String productId) {
        productRepository.deleteById(productId);
    }
}
```

### 9.3 Cache Invalidation Strategy

```
Cache TTL by Entity:
- Products: 10 minutes (CRUD operations trigger invalidation)
- User Profiles: 5 minutes
- Shopping Carts: Session duration (30 min)
- Rate Limiting Counters: 1 minute
- Category List: 1 hour
- Reviews: 5 minutes
```

---

## Deployment Configuration

### 10.1 Docker Configuration

**Dockerfile Template (for all services):**
```dockerfile
FROM eclipse-temurin:21-jre-alpine

ARG JAR_FILE=target/*.jar

COPY ${JAR_FILE} app.jar

ENTRYPOINT ["java", "-XX:+UseG1GC", "-XX:MaxRAMPercentage=75", "-jar", "/app.jar"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/v1/health || exit 1
```

### 10.2 Kubernetes Deployment Manifest

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: order-service
  namespace: ecommerce
  labels:
    app: order-service
    version: v1
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: order-service
  template:
    metadata:
      labels:
        app: order-service
        version: v1
    spec:
      containers:
      - name: order-service
        image: docker.io/ecommerce/order-service:1.0.0
        imagePullPolicy: IfNotPresent
        ports:
        - name: http
          containerPort: 8080
          protocol: TCP
        - name: metrics
          containerPort: 9090
          protocol: TCP
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "kubernetes"
        - name: SPRING_DATASOURCE_URL
          valueFrom:
            secretKeyRef:
              name: order-db-secret
              key: url
        - name: SPRING_DATASOURCE_USERNAME
          valueFrom:
            secretKeyRef:
              name: order-db-secret
              key: username
        - name: SPRING_DATASOURCE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: order-db-secret
              key: password
        - name: KAFKA_BOOTSTRAP_SERVERS
          valueFrom:
            configMapKeyRef:
              name: kafka-config
              key: bootstrap-servers
        - name: EUREKA_CLIENT_SERVICEURL_DEFAULTZONE
          valueFrom:
            configMapKeyRef:
              name: eureka-config
              key: serviceurl
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /v1/health/liveness
            port: http
          initialDelaySeconds: 40
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /v1/health/readiness
            port: http
          initialDelaySeconds: 30
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 3
        volumeMounts:
        - name: config
          mountPath: /etc/config
      volumes:
      - name: config
        configMap:
          name: order-service-config
  
---
apiVersion: v1
kind: Service
metadata:
  name: order-service
  namespace: ecommerce
  labels:
    app: order-service
spec:
  type: ClusterIP
  ports:
  - name: http
    port: 8080
    targetPort: 8080
    protocol: TCP
  - name: metrics
    port: 9090
    targetPort: 9090
    protocol: TCP
  selector:
    app: order-service
```

### 10.3 Development Environment Setup

**docker-compose.yml:**
```yaml
version: '3.8'

services:
  # PostgreSQL Databases
  user-db:
    image: postgres:16-alpine
    container_name: user-db
    environment:
      POSTGRES_DB: user_db
      POSTGRES_USER: user_user
      POSTGRES_PASSWORD: user_password
    ports:
      - "5432:5432"
    volumes:
      - user_db_data:/var/lib/postgresql/data

  product-db:
    image: postgres:16-alpine
    container_name: product-db
    environment:
      POSTGRES_DB: product_db
      POSTGRES_USER: product_user
      POSTGRES_PASSWORD: product_password
    ports:
      - "5433:5432"
    volumes:
      - product_db_data:/var/lib/postgresql/data

  # Similar for other databases...

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  # Kafka
  kafka:
    image: confluentinc/cp-kafka:7.5.0
    container_name: kafka
    depends_on:
      - zookeeper
    ports:
      - "9092:9092"
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:29092,PLAINTEXT_HOST://localhost:9092
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1

  zookeeper:
    image: confluentinc/cp-zookeeper:7.5.0
    container_name: zookeeper
    ports:
      - "2181:2181"
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181

  # Service Discovery (Eureka)
  eureka-server:
    image: ecommerce/eureka-server:1.0.0
    container_name: eureka-server
    ports:
      - "8761:8761"
    environment:
      SPRING_PROFILES_ACTIVE: dev

  # Config Server
  config-server:
    image: ecommerce/config-server:1.0.0
    container_name: config-server
    ports:
      - "8888:8888"
    environment:
      SPRING_PROFILES_ACTIVE: dev

  # API Gateway
  api-gateway:
    image: ecommerce/api-gateway:1.0.0
    container_name: api-gateway
    depends_on:
      - eureka-server
      - config-server
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: dev

  # Microservices
  user-service:
    image: ecommerce/user-service:1.0.0
    container_name: user-service
    depends_on:
      - user-db
      - eureka-server
      - kafka
    ports:
      - "8001:8080"
    environment:
      SPRING_PROFILES_ACTIVE: dev

  product-service:
    image: ecommerce/product-service:1.0.0
    container_name: product-service
    depends_on:
      - product-db
      - eureka-server
      - kafka
    ports:
      - "8002:8080"
    environment:
      SPRING_PROFILES_ACTIVE: dev

  # Similar for other services...

  # Monitoring Stack
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      GF_SECURITY_ADMIN_PASSWORD: admin

  zipkin:
    image: ghcr.io/openzipkin/zipkin:latest
    container_name: zipkin
    ports:
      - "9411:9411"

volumes:
  user_db_data:
  product_db_data:
  redis_data:
```

---

## Summary

This LLD document provides:

1. **Complete Database Schema** for all 10 services with proper indexing
2. **RESTful API Specifications** with examples, status codes, and rate limits
3. **Service Implementation Details** with architecture patterns
4. **Event-Driven Architecture** with Kafka topics and message formats
5. **CQRS Implementation** for read/write separation
6. **Saga Orchestration Workflow** for distributed transactions
7. **Security Implementation** with JWT and RBAC
8. **Error Handling** with structured error responses
9. **Caching Strategy** with TTL configurations
10. **Deployment Configuration** for Docker and Kubernetes

---

**Next Steps:**
1. Review the database schema with DBA
2. Generate database migration scripts (Flyway/Liquibase)
3. Start implementing individual microservices
4. Setup CI/CD pipeline for automated builds and deployments
5. Setup observability stack (Splunk, Prometheus, Grafana, Zipkin)


