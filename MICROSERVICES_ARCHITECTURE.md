# Kiến trúc Microservices - Product Management System

## Tổng quan

Hệ thống được chia thành các microservices độc lập, mỗi service có database riêng và giao tiếp qua REST API.

## Kiến trúc

```
┌─────────────────────────────────────────────────────────────┐
│                        API Gateway                           │
│                     (Port: 8080)                             │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
┌───────▼────────┐  ┌──────▼──────┐  ┌────────▼────────┐
│ Service        │  │   Config    │  │    Eureka       │
│ Discovery      │  │   Server    │  │   (Backup)      │
│ (Eureka)       │  │ (Port: 8888)│  │                 │
│ (Port: 8761)   │  │             │  │                 │
└────────────────┘  └─────────────┘  └─────────────────┘
        │
        │ (Service Registration & Discovery)
        │
┌───────┴──────────────────────────────────────────────┐
│                                                       │
│  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐│
│  │ Auth Service │  │ User Service │  │   Product   ││
│  │ (Port: 8081) │  │ (Port: 8082) │  │   Service   ││
│  │              │  │              │  │ (Port: 8083)││
│  │  auth_db     │  │   user_db    │  │  product_db ││
│  └──────────────┘  └──────────────┘  └─────────────┘│
│                                                       │
│  ┌──────────────┐  ┌──────────────┐                  │
│  │Order Service │  │Rating Service│                  │
│  │ (Port: 8084) │  │ (Port: 8085) │                  │
│  │              │  │              │                  │
│  │  order_db    │  │  rating_db   │                  │
│  └──────────────┘  └──────────────┘                  │
└───────────────────────────────────────────────────────┘
```

## Các Services

### 1. Service Discovery (Eureka Server)
- **Port**: 8761
- **Chức năng**: Đăng ký và tìm kiếm các microservices
- **Database**: Không cần

### 2. Config Server
- **Port**: 8888
- **Chức năng**: Quản lý cấu hình tập trung cho tất cả services
- **Database**: Không cần (sử dụng Git hoặc file system)

### 3. API Gateway
- **Port**: 8080
- **Chức năng**: 
  - Routing requests đến các services
  - Load balancing
  - Authentication & Authorization
  - Rate limiting
- **Database**: Không cần

### 4. Auth Service
- **Port**: 8081
- **Database**: `auth_db`
- **Chức năng**:
  - Đăng ký, đăng nhập
  - Tạo và validate JWT tokens
  - Quản lý refresh tokens
- **Tables**:
  - `users` (id, email, password, role, status)
  - `refresh_tokens`

### 5. User Service
- **Port**: 8082
- **Database**: `user_db`
- **Chức năng**:
  - Quản lý thông tin người dùng
  - Cập nhật profile
  - Quản lý địa chỉ
- **Tables**:
  - `users` (id, name, email, phone, role, status)
  - `user_addresses`

### 6. Product Service
- **Port**: 8083
- **Database**: `product_db`
- **Chức năng**:
  - Quản lý sản phẩm
  - Quản lý danh mục
  - Tìm kiếm sản phẩm
  - Quản lý tồn kho
- **Tables**:
  - `products`
  - `categories`
  - `product_inventory`

### 7. Order Service
- **Port**: 8084
- **Database**: `order_db`
- **Chức năng**:
  - Tạo đơn hàng
  - Quản lý đơn hàng
  - Cập nhật trạng thái
  - Quản lý thanh toán
- **Tables**:
  - `orders`
  - `order_details`
  - `payments`

### 8. Rating Service
- **Port**: 8085
- **Database**: `rating_db`
- **Chức năng**:
  - Đánh giá sản phẩm
  - Quản lý comments
  - Tính toán rating trung bình
- **Tables**:
  - `product_ratings`

## Database Schema

Mỗi service có database riêng trên cùng MySQL server:

```sql
-- Auth Service
CREATE DATABASE auth_db;

-- User Service
CREATE DATABASE user_db;

-- Product Service
CREATE DATABASE product_db;

-- Order Service
CREATE DATABASE order_db;

-- Rating Service
CREATE DATABASE rating_db;
```

## Communication Patterns

### 1. Synchronous (REST API)
- API Gateway → Services
- Service → Service (khi cần dữ liệu ngay lập tức)

### 2. Asynchronous (Event-Driven) - Future Enhancement
- Kafka/RabbitMQ cho event messaging
- Ví dụ: Order created → Update inventory

## API Routing

### API Gateway Routes

```
/api/auth/**        → Auth Service (8081)
/api/users/**       → User Service (8082)
/api/products/**    → Product Service (8083)
/api/categories/**  → Product Service (8083)
/api/orders/**      → Order Service (8084)
/api/ratings/**     → Rating Service (8085)
```

## Security

1. **JWT Authentication**: 
   - Auth Service tạo JWT token
   - API Gateway validate token
   - Services nhận user info từ header

2. **Service-to-Service Authentication**:
   - Internal API keys
   - Mutual TLS (future)

## Deployment

### Development
```bash
# Chạy từng service
cd service-discovery && mvn spring-boot:run
cd config-server && mvn spring-boot:run
cd api-gateway && mvn spring-boot:run
cd auth-service && mvn spring-boot:run
# ... các service khác
```

### Production (Docker)
```bash
docker-compose up -d
```

## Monitoring & Logging

- **Spring Boot Actuator**: Health checks, metrics
- **Sleuth + Zipkin**: Distributed tracing
- **ELK Stack**: Centralized logging (future)

## Scalability

Mỗi service có thể scale độc lập:
```bash
docker-compose up -d --scale product-service=3
docker-compose up -d --scale order-service=2
```

## Data Consistency

### Eventual Consistency
- Sử dụng Saga pattern cho distributed transactions
- Event sourcing cho audit trail

### Example: Create Order Flow
1. Order Service tạo order (PENDING)
2. Gọi Product Service kiểm tra tồn kho
3. Nếu OK: Update order status (CONFIRMED)
4. Nếu FAIL: Rollback order (CANCELLED)

## Configuration

Tất cả cấu hình được quản lý tập trung tại Config Server:
- Database connections
- Service URLs
- JWT secrets
- Feature flags

## Technology Stack

- **Java**: 17
- **Spring Boot**: 3.2.0
- **Spring Cloud**: 2023.0.0
- **Database**: MySQL 8.0
- **Container**: Docker & Docker Compose
- **Service Discovery**: Netflix Eureka
- **API Gateway**: Spring Cloud Gateway
- **Config**: Spring Cloud Config

## Migration từ Monolith

1. ✅ Phân tích và thiết kế kiến trúc
2. ✅ Tạo infrastructure services (Eureka, Config, Gateway)
3. ✅ Tách database schemas
4. ✅ Tạo các business services
5. ✅ Migrate code từ monolith
6. ✅ Testing
7. ✅ Deployment

## Next Steps

1. Implement API Gateway với authentication
2. Add distributed tracing (Sleuth + Zipkin)
3. Add message queue (Kafka/RabbitMQ)
4. Implement Circuit Breaker (Resilience4j)
5. Add caching (Redis)
6. Implement CQRS pattern
