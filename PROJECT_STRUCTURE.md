# Cấu Trúc Dự Án Product Management API

## Tổng quan
Dự án Spring Boot REST API hoàn chỉnh cho hệ thống quản lý sản phẩm với các tính năng:
- Quản lý danh mục sản phẩm
- Quản lý sản phẩm
- Quản lý đơn hàng
- Quản lý người dùng
- Xác thực với JWT
- Đánh giá sản phẩm

## Cấu trúc thư mục chi tiết

```
ProductManagement/
│
├── database/
│   └── product_management.sql          # SQL script tạo database
│
├── src/
│   └── main/
│       ├── java/com/husc/productmanagement/
│       │   │
│       │   ├── config/
│       │   │   └── SecurityConfig.java              # Cấu hình Spring Security, CORS
│       │   │
│       │   ├── controller/
│       │   │   ├── AuthController.java              # API đăng nhập, đăng ký
│       │   │   ├── CategoryController.java          # API quản lý danh mục
│       │   │   ├── OrderController.java             # API quản lý đơn hàng
│       │   │   ├── ProductController.java           # API quản lý sản phẩm
│       │   │   ├── ProductRatingController.java     # API đánh giá sản phẩm
│       │   │   └── UserController.java              # API quản lý người dùng
│       │   │
│       │   ├── dto/
│       │   │   ├── ApiResponse.java                 # Generic response wrapper
│       │   │   ├── CategoryDTO.java                 # Category data transfer object
│       │   │   ├── LoginRequest.java                # Login request DTO
│       │   │   ├── LoginResponse.java               # Login response với JWT token
│       │   │   ├── OrderDTO.java                    # Order data transfer object
│       │   │   ├── OrderItemDTO.java                # Order item DTO
│       │   │   ├── ProductDTO.java                  # Product data transfer object
│       │   │   ├── ProductRatingDTO.java            # Rating data transfer object
│       │   │   └── UserDTO.java                     # User data transfer object
│       │   │
│       │   ├── entity/
│       │   │   ├── Category.java                    # Entity cho bảng categories
│       │   │   ├── Order.java                       # Entity cho bảng orders
│       │   │   ├── OrderDetail.java                 # Entity cho bảng order_details
│       │   │   ├── Payment.java                     # Entity cho bảng payments
│       │   │   ├── Product.java                     # Entity cho bảng products
│       │   │   ├── ProductRating.java               # Entity cho bảng product_ratings
│       │   │   └── User.java                        # Entity cho bảng users
│       │   │
│       │   ├── exception/
│       │   │   └── GlobalExceptionHandler.java      # Xử lý exception toàn cục
│       │   │
│       │   ├── repository/
│       │   │   ├── CategoryRepository.java          # JPA Repository cho Category
│       │   │   ├── OrderDetailRepository.java       # JPA Repository cho OrderDetail
│       │   │   ├── OrderRepository.java             # JPA Repository cho Order
│       │   │   ├── PaymentRepository.java           # JPA Repository cho Payment
│       │   │   ├── ProductRatingRepository.java     # JPA Repository cho ProductRating
│       │   │   ├── ProductRepository.java           # JPA Repository cho Product
│       │   │   └── UserRepository.java              # JPA Repository cho User
│       │   │
│       │   ├── service/
│       │   │   ├── AuthService.java                 # Business logic cho authentication
│       │   │   ├── CategoryService.java             # Business logic cho categories
│       │   │   ├── OrderService.java                # Business logic cho orders
│       │   │   ├── ProductRatingService.java        # Business logic cho ratings
│       │   │   ├── ProductService.java              # Business logic cho products
│       │   │   └── UserService.java                 # Business logic cho users
│       │   │
│       │   ├── util/
│       │   │   └── JwtUtil.java                     # Utility cho JWT token
│       │   │
│       │   └── ProductManagementApplication.java    # Main application class
│       │
│       └── resources/
│           └── application.properties                # Cấu hình ứng dụng
│
├── .gitignore                                        # Git ignore file
├── API_TESTING.md                                    # Hướng dẫn test API
├── pom.xml                                           # Maven configuration
└── README.md                                         # Tài liệu dự án

```

## Các thành phần chính

### 1. Entities (7 files)
Ánh xạ các bảng trong database sang Java objects:
- `Category` - Danh mục sản phẩm
- `Product` - Sản phẩm
- `User` - Người dùng
- `Order` - Đơn hàng
- `OrderDetail` - Chi tiết đơn hàng
- `Payment` - Thanh toán
- `ProductRating` - Đánh giá sản phẩm

### 2. Repositories (7 files)
Interface JPA để tương tác với database:
- Kế thừa `JpaRepository` để có sẵn CRUD operations
- Custom query methods cho các truy vấn đặc biệt
- Aggregate queries (COUNT, AVG, etc.)

### 3. DTOs (9 files)
Data Transfer Objects để truyền dữ liệu giữa layers:
- Validation annotations (@NotBlank, @Email, @Min, etc.)
- Tách biệt giữa database entities và API responses
- `ApiResponse<T>` - Generic wrapper cho tất cả responses

### 4. Services (6 files)
Business logic layer:
- `@Transactional` cho database operations
- Convert giữa Entity và DTO
- Validation và error handling
- Complex business rules (inventory management, order processing)

### 5. Controllers (6 files)
REST API endpoints:
- `@RestController` và `@RequestMapping`
- HTTP methods: GET, POST, PUT, PATCH, DELETE
- Request validation với `@Valid`
- Consistent response format với `ApiResponse`

### 6. Configuration (1 file)
- `SecurityConfig` - Spring Security configuration
- CORS configuration
- Password encoder
- Stateless session management

### 7. Utilities (1 file)
- `JwtUtil` - JWT token generation và validation

### 8. Exception Handling (1 file)
- `GlobalExceptionHandler` - Centralized exception handling
- Validation error handling
- Custom error responses

## Database Schema

### Tables:
1. **categories** - Danh mục sản phẩm
2. **products** - Sản phẩm (FK: id_category)
3. **users** - Người dùng (role: admin/user)
4. **orders** - Đơn hàng
5. **order_details** - Chi tiết đơn hàng (FK: order_id, product_id)
6. **payments** - Thanh toán (FK: order_id)
7. **product_ratings** - Đánh giá (FK: product_id, user_id)

## API Endpoints Summary

### Authentication (2 endpoints)
- POST `/api/auth/register`
- POST `/api/auth/login`

### Categories (6 endpoints)
- GET, POST, PUT, DELETE operations

### Products (8 endpoints)
- CRUD + search + filter by category

### Orders (7 endpoints)
- CRUD + status management + customer lookup

### Users (4 endpoints)
- CRUD operations

### Ratings (4 endpoints)
- Create, read, delete ratings

**Tổng cộng: 31 API endpoints**

## Công nghệ sử dụng

| Công nghệ | Version | Mục đích |
|-----------|---------|----------|
| Java | 17 | Programming language |
| Spring Boot | 3.2.0 | Framework |
| Spring Data JPA | 3.2.0 | ORM |
| Spring Security | 6.2.0 | Security |
| MySQL | 8.0+ | Database |
| JWT | 0.12.3 | Authentication |
| Lombok | Latest | Reduce boilerplate |
| Maven | 3.6+ | Build tool |

## Tính năng nổi bật

✅ RESTful API design
✅ JWT Authentication
✅ Input validation
✅ Exception handling
✅ CORS support
✅ Transaction management
✅ Inventory management
✅ Order processing
✅ Product rating system
✅ Search functionality
✅ Consistent response format

## Cách chạy

1. Đảm bảo MySQL đang chạy
2. Cập nhật `application.properties` với thông tin database
3. Chạy: `mvn spring-boot:run`
4. API sẽ chạy tại: `http://localhost:8080/api`

## Next Steps

Để mở rộng dự án, bạn có thể thêm:
- File upload cho product images
- Email notifications
- Payment gateway integration
- Admin dashboard
- Pagination và sorting
- Caching với Redis
- API documentation với Swagger/OpenAPI
- Unit tests và Integration tests
