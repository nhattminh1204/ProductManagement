# 📋 Danh sách API - Product Management System

**Base URL**: `http://localhost:8080/api`

**Response Format**: Tất cả API đều trả về format:
```json
{
  "success": true,
  "message": "Success message",
  "data": { ... }
}
```

---

## 🔐 1. Authentication API (`/api/auth`)

### 1.1. Đăng ký tài khoản
- **Method**: `POST`
- **Endpoint**: `/api/auth/register`
- **Body**:
```json
{
  "name": "Nguyen Van A",
  "email": "test@example.com",
  "phone": "0123456789",
  "password": "password123"
}
```
- **Response**: `201 Created`
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "id": 1,
    "name": "Nguyen Van A",
    "email": "test@example.com",
    "phone": "0123456789",
    "role": "user",
    "status": "active"
  }
}
```

### 1.2. Đăng nhập
- **Method**: `POST`
- **Endpoint**: `/api/auth/login`
- **Body**:
```json
{
  "email": "test@example.com",
  "password": "password123"
}
```
- **Response**: `200 OK`
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "name": "Nguyen Van A",
      "email": "test@example.com",
      "role": "user"
    }
  }
}
```

---

## 📁 2. Categories API (`/api/categories`)

### 2.1. Lấy tất cả danh mục
- **Method**: `GET`
- **Endpoint**: `/api/categories`
- **Response**: `200 OK`
```json
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "id": 1,
      "name": "Electronics",
      "status": "active",
      "createdAt": "2025-12-24T14:00:00",
      "updatedAt": "2025-12-24T14:00:00"
    }
  ]
}
```

### 2.2. Lấy danh mục đang hoạt động
- **Method**: `GET`
- **Endpoint**: `/api/categories/active`
- **Response**: `200 OK`

### 2.3. Lấy danh mục theo ID
- **Method**: `GET`
- **Endpoint**: `/api/categories/{id}`
- **Example**: `/api/categories/1`
- **Response**: `200 OK`

### 2.4. Tạo danh mục mới
- **Method**: `POST`
- **Endpoint**: `/api/categories`
- **Body**:
```json
{
  "name": "Electronics",
  "status": "active"
}
```
- **Response**: `201 Created`

### 2.5. Cập nhật danh mục
- **Method**: `PUT`
- **Endpoint**: `/api/categories/{id}`
- **Body**:
```json
{
  "name": "Electronics Updated",
  "status": "active"
}
```
- **Response**: `200 OK`

### 2.6. Xóa danh mục
- **Method**: `DELETE`
- **Endpoint**: `/api/categories/{id}`
- **Response**: `200 OK`

---

## 📦 3. Products API (`/api/products`)

### 3.1. Lấy tất cả sản phẩm
- **Method**: `GET`
- **Endpoint**: `/api/products`
- **Response**: `200 OK`
```json
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "id": 1,
      "name": "iPhone 15 Pro",
      "image": "https://example.com/iphone.jpg",
      "price": 999.99,
      "quantity": 50,
      "status": "active",
      "categoryId": 1,
      "categoryName": "Electronics",
      "createdAt": "2025-12-24T14:00:00",
      "updatedAt": "2025-12-24T14:00:00"
    }
  ]
}
```

### 3.2. Lấy sản phẩm đang hoạt động
- **Method**: `GET`
- **Endpoint**: `/api/products/active`
- **Response**: `200 OK`

### 3.3. Lấy sản phẩm theo ID
- **Method**: `GET`
- **Endpoint**: `/api/products/{id}`
- **Example**: `/api/products/1`
- **Response**: `200 OK`

### 3.4. Lấy sản phẩm theo danh mục
- **Method**: `GET`
- **Endpoint**: `/api/products/category/{categoryId}`
- **Example**: `/api/products/category/1`
- **Response**: `200 OK`

### 3.5. Tìm kiếm sản phẩm
- **Method**: `GET`
- **Endpoint**: `/api/products/search?keyword={keyword}`
- **Example**: `/api/products/search?keyword=iPhone`
- **Response**: `200 OK`

### 3.6. Tạo sản phẩm mới
- **Method**: `POST`
- **Endpoint**: `/api/products`
- **Body**:
```json
{
  "name": "iPhone 15 Pro",
  "image": "https://example.com/iphone.jpg",
  "price": 999.99,
  "quantity": 50,
  "status": "active",
  "categoryId": 1
}
```
- **Response**: `201 Created`

### 3.7. Cập nhật sản phẩm
- **Method**: `PUT`
- **Endpoint**: `/api/products/{id}`
- **Body**:
```json
{
  "name": "iPhone 15 Pro Max",
  "image": "https://example.com/iphone.jpg",
  "price": 1199.99,
  "quantity": 30,
  "status": "active",
  "categoryId": 1
}
```
- **Response**: `200 OK`

### 3.8. Xóa sản phẩm
- **Method**: `DELETE`
- **Endpoint**: `/api/products/{id}`
- **Response**: `200 OK`

---

## 🛒 4. Orders API (`/api/orders`)

### 4.1. Lấy tất cả đơn hàng
- **Method**: `GET`
- **Endpoint**: `/api/orders`
- **Response**: `200 OK`
```json
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "id": 1,
      "orderCode": "ORD-20251224-001",
      "customerName": "Nguyen Van A",
      "email": "test@example.com",
      "phone": "0123456789",
      "address": "123 Main St, Hanoi",
      "totalAmount": 1999.98,
      "paymentMethod": "credit_card",
      "status": "pending",
      "items": [
        {
          "id": 1,
          "productId": 1,
          "productName": "iPhone 15 Pro",
          "quantity": 2,
          "price": 999.99,
          "subtotal": 1999.98
        }
      ],
      "createdAt": "2025-12-24T14:00:00",
      "updatedAt": "2025-12-24T14:00:00"
    }
  ]
}
```

### 4.2. Lấy đơn hàng theo ID
- **Method**: `GET`
- **Endpoint**: `/api/orders/{id}`
- **Example**: `/api/orders/1`
- **Response**: `200 OK`

### 4.3. Lấy đơn hàng theo mã
- **Method**: `GET`
- **Endpoint**: `/api/orders/code/{orderCode}`
- **Example**: `/api/orders/code/ORD-20251224-001`
- **Response**: `200 OK`

### 4.4. Lấy đơn hàng theo email khách hàng
- **Method**: `GET`
- **Endpoint**: `/api/orders/customer/{email}`
- **Example**: `/api/orders/customer/test@example.com`
- **Response**: `200 OK`

### 4.5. Tạo đơn hàng mới
- **Method**: `POST`
- **Endpoint**: `/api/orders`
- **Body**:
```json
{
  "customerName": "Nguyen Van A",
  "email": "test@example.com",
  "phone": "0123456789",
  "address": "123 Main St, Hanoi",
  "paymentMethod": "credit_card",
  "items": [
    {
      "productId": 1,
      "quantity": 2
    }
  ]
}
```
- **Response**: `201 Created`

### 4.6. Cập nhật trạng thái đơn hàng
- **Method**: `PATCH`
- **Endpoint**: `/api/orders/{id}/status?status={status}`
- **Example**: `/api/orders/1/status?status=paid`
- **Status values**: `pending`, `paid`, `shipped`, `cancelled`
- **Response**: `200 OK`

### 4.7. Hủy đơn hàng
- **Method**: `DELETE`
- **Endpoint**: `/api/orders/{id}/cancel`
- **Response**: `200 OK`

---

## 👥 5. Users API (`/api/users`)

### 5.1. Lấy tất cả người dùng
- **Method**: `GET`
- **Endpoint**: `/api/users`
- **Response**: `200 OK`
```json
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "id": 1,
      "name": "Nguyen Van A",
      "email": "test@example.com",
      "phone": "0123456789",
      "role": "user",
      "status": "active",
      "createdAt": "2025-12-24T14:00:00",
      "updatedAt": "2025-12-24T14:00:00"
    }
  ]
}
```

### 5.2. Lấy người dùng theo ID
- **Method**: `GET`
- **Endpoint**: `/api/users/{id}`
- **Example**: `/api/users/1`
- **Response**: `200 OK`

### 5.3. Cập nhật người dùng
- **Method**: `PUT`
- **Endpoint**: `/api/users/{id}`
- **Body**:
```json
{
  "name": "Nguyen Van A Updated",
  "email": "test@example.com",
  "phone": "0987654321",
  "role": "user",
  "status": "active"
}
```
- **Response**: `200 OK`

### 5.4. Xóa người dùng
- **Method**: `DELETE`
- **Endpoint**: `/api/users/{id}`
- **Response**: `200 OK`

---

## ⭐ 6. Product Ratings API (`/api/ratings`)

### 6.1. Lấy đánh giá theo sản phẩm
- **Method**: `GET`
- **Endpoint**: `/api/ratings/product/{productId}`
- **Example**: `/api/ratings/product/1`
- **Response**: `200 OK`
```json
{
  "success": true,
  "message": "Success",
  "data": [
    {
      "id": 1,
      "productId": 1,
      "userId": 1,
      "userName": "Nguyen Van A",
      "rating": 5,
      "comment": "Great product!",
      "createdAt": "2025-12-24T14:00:00"
    }
  ]
}
```

### 6.2. Lấy đánh giá theo người dùng
- **Method**: `GET`
- **Endpoint**: `/api/ratings/user/{userId}`
- **Example**: `/api/ratings/user/1`
- **Response**: `200 OK`

### 6.3. Tạo đánh giá mới
- **Method**: `POST`
- **Endpoint**: `/api/ratings`
- **Body**:
```json
{
  "productId": 1,
  "userId": 1,
  "rating": 5,
  "comment": "Great product!"
}
```
- **Note**: Rating phải từ 1-5
- **Response**: `201 Created`

### 6.4. Xóa đánh giá
- **Method**: `DELETE`
- **Endpoint**: `/api/ratings/{id}`
- **Response**: `200 OK`

---

## 📊 Tổng kết API

| Module | Số lượng Endpoints |
|--------|-------------------|
| Authentication | 2 |
| Categories | 6 |
| Products | 8 |
| Orders | 7 |
| Users | 4 |
| Ratings | 4 |
| **TỔNG** | **31 endpoints** |

---

## 🔒 Security

**Hiện tại**: Tất cả endpoints đều public (để test)

**Production**: Cần cấu hình lại SecurityConfig:
```java
.authorizeHttpRequests(auth -> auth
    .requestMatchers("/api/auth/**").permitAll()
    .requestMatchers(HttpMethod.GET, "/api/products/**").permitAll()
    .requestMatchers(HttpMethod.GET, "/api/categories/**").permitAll()
    .anyRequest().authenticated()
)
```

---

## 🧪 Testing Tools

### 1. cURL (Command Line)
```bash
curl http://localhost:8080/api/categories
```

### 2. PowerShell
```powershell
Invoke-WebRequest -Uri http://localhost:8080/api/categories -UseBasicParsing
```

### 3. Postman
Import collection từ file `API_TESTING.md`

### 4. Thunder Client (VS Code)
Extension ID: `rangav.vscode-thunder-client`

### 5. Browser
Truy cập trực tiếp: http://localhost:8080/api/categories

---

## 📝 Error Responses

### 400 Bad Request
```json
{
  "success": false,
  "message": "Validation error: name is required",
  "data": null
}
```

### 404 Not Found
```json
{
  "success": false,
  "message": "Category not found with id: 999",
  "data": null
}
```

### 500 Internal Server Error
```json
{
  "success": false,
  "message": "Internal server error",
  "data": null
}
```

---

## 🚀 Quick Start

1. **Start server**:
```bash
mvn spring-boot:run
```

2. **Test API**:
```bash
curl http://localhost:8080/api/categories
```

3. **Create test data**:
```bash
# Create category
curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d '{"name":"Electronics","status":"active"}'

# Create product
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"iPhone 15","price":999.99,"quantity":50,"status":"active","categoryId":1}'
```

---

**Last Updated**: 2025-12-24  
**Version**: 1.0.0  
**Author**: Product Management Team
