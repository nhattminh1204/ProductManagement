# Product Management API

API quản lý sản phẩm được xây dựng bằng Spring Boot 3.2.0 và MySQL.

## Yêu cầu hệ thống

- Java 17 hoặc cao hơn
- Maven 3.6+
- MySQL 8.0+

## Cấu trúc dự án

```
ProductManagement/
├── src/
│   └── main/
│       ├── java/com/husc/productmanagement/
│       │   ├── config/          # Cấu hình (Security, CORS)
│       │   ├── controller/      # REST Controllers
│       │   ├── dto/             # Data Transfer Objects
│       │   ├── entity/          # JPA Entities
│       │   ├── exception/       # Exception Handlers
│       │   ├── repository/      # JPA Repositories
│       │   ├── service/         # Business Logic
│       │   ├── util/            # Utilities (JWT)
│       │   └── ProductManagementApplication.java
│       └── resources/
│           └── application.properties
├── database/
│   └── product_management.sql
└── pom.xml
```

## Cài đặt và chạy

### 1. Cấu hình Database

Đảm bảo MySQL đang chạy và cập nhật thông tin kết nối trong `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/product_management?createDatabaseIfNotExist=true
spring.datasource.username=root
spring.datasource.password=123456
```

### 2. Tạo database (tùy chọn)

Nếu muốn tạo database thủ công, chạy file SQL:

```bash
mysql -u root -p < database/product_management.sql
```

### 3. Build và chạy ứng dụng

```bash
# Build project
mvn clean install

# Chạy ứng dụng
mvn spring-boot:run
```

Hoặc chạy trực tiếp từ IDE (IntelliJ IDEA, Eclipse, VS Code).

### 4. Truy cập API

API sẽ chạy tại: `http://localhost:8080/api`

## API Endpoints

### Authentication

- **POST** `/api/auth/register` - Đăng ký tài khoản mới
- **POST** `/api/auth/login` - Đăng nhập

### Categories (Danh mục)

- **GET** `/api/categories` - Lấy tất cả danh mục
- **GET** `/api/categories/active` - Lấy danh mục đang hoạt động
- **GET** `/api/categories/{id}` - Lấy danh mục theo ID
- **POST** `/api/categories` - Tạo danh mục mới
- **PUT** `/api/categories/{id}` - Cập nhật danh mục
- **DELETE** `/api/categories/{id}` - Xóa danh mục

### Products (Sản phẩm)

- **GET** `/api/products` - Lấy tất cả sản phẩm
- **GET** `/api/products/active` - Lấy sản phẩm đang hoạt động
- **GET** `/api/products/{id}` - Lấy sản phẩm theo ID
- **GET** `/api/products/category/{categoryId}` - Lấy sản phẩm theo danh mục
- **GET** `/api/products/search?keyword={keyword}` - Tìm kiếm sản phẩm
- **POST** `/api/products` - Tạo sản phẩm mới
- **PUT** `/api/products/{id}` - Cập nhật sản phẩm
- **DELETE** `/api/products/{id}` - Xóa sản phẩm

### Orders (Đơn hàng)

- **GET** `/api/orders` - Lấy tất cả đơn hàng
- **GET** `/api/orders/{id}` - Lấy đơn hàng theo ID
- **GET** `/api/orders/code/{orderCode}` - Lấy đơn hàng theo mã
- **GET** `/api/orders/customer/{email}` - Lấy đơn hàng theo email khách hàng
- **POST** `/api/orders` - Tạo đơn hàng mới
- **PATCH** `/api/orders/{id}/status?status={status}` - Cập nhật trạng thái đơn hàng
- **DELETE** `/api/orders/{id}/cancel` - Hủy đơn hàng

### Users (Người dùng)

- **GET** `/api/users` - Lấy tất cả người dùng
- **GET** `/api/users/{id}` - Lấy người dùng theo ID
- **PUT** `/api/users/{id}` - Cập nhật người dùng
- **DELETE** `/api/users/{id}` - Xóa người dùng

### Product Ratings (Đánh giá sản phẩm)

- **GET** `/api/ratings/product/{productId}` - Lấy đánh giá theo sản phẩm
- **GET** `/api/ratings/user/{userId}` - Lấy đánh giá theo người dùng
- **POST** `/api/ratings` - Tạo đánh giá mới
- **DELETE** `/api/ratings/{id}` - Xóa đánh giá

## Ví dụ Request

### Đăng ký tài khoản

```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Nguyen Van A",
    "email": "nguyenvana@example.com",
    "phone": "0123456789",
    "password": "password123"
  }'
```

### Đăng nhập

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "nguyenvana@example.com",
    "password": "password123"
  }'
```

### Tạo danh mục

```bash
curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Electronics",
    "status": "active"
  }'
```

### Tạo sản phẩm

```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "iPhone 15 Pro",
    "image": "https://example.com/iphone15.jpg",
    "price": 999.99,
    "quantity": 50,
    "status": "active",
    "categoryId": 1
  }'
```

### Tạo đơn hàng

```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "customerName": "Nguyen Van A",
    "email": "nguyenvana@example.com",
    "phone": "0123456789",
    "address": "123 Main St, Hanoi",
    "paymentMethod": "credit_card",
    "items": [
      {
        "productId": 1,
        "quantity": 2
      }
    ]
  }'
```

## Response Format

Tất cả API đều trả về theo format:

```json
{
  "success": true,
  "message": "Success message",
  "data": { ... }
}
```

Hoặc khi có lỗi:

```json
{
  "success": false,
  "message": "Error message",
  "data": null
}
```

## Công nghệ sử dụng

- **Spring Boot 3.2.0** - Framework chính
- **Spring Data JPA** - ORM
- **Spring Security** - Bảo mật
- **MySQL** - Database
- **JWT** - Authentication
- **Lombok** - Giảm boilerplate code
- **Maven** - Build tool

## Lưu ý

- Database sẽ tự động được tạo khi chạy ứng dụng lần đầu (nếu chưa tồn tại)
- JPA sẽ tự động tạo/cập nhật các bảng dựa trên Entity classes
- Tất cả API đều hỗ trợ CORS
- JWT token có thời hạn 24 giờ (86400000ms)

## Liên hệ

Nếu có vấn đề, vui lòng tạo issue hoặc liên hệ qua email.
