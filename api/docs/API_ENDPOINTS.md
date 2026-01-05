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
  "username": "nguyenvana",
  "email": "test@example.com",
  "phone": "0123456789",
  "address": "123 Main St, Hanoi",
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
    "username": "nguyenvana",
    "email": "test@example.com",
    "phone": "0123456789",
    "address": "123 Main St, Hanoi",
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
  "usernameOrEmail": "test@example.com",
  "password": "password123"
}
```
*Note: `usernameOrEmail` can be either username or email.*

- **Response**: `200 OK`
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "userId": 1,
    "email": "test@example.com",
    "username": "nguyenvana",
    "name": "Nguyen Van A",
    "role": "user"
  }
}
```

---

## 📁 2. Categories API (`/api/categories`)

### 2.1. Lấy tất cả danh mục
- **Method**: `GET`
- **Endpoint**: `/api/categories`
- **Response**: `200 OK`

### 2.2. Lấy danh mục đang hoạt động
- **Method**: `GET`
- **Endpoint**: `/api/categories/active`
- **Response**: `200 OK`

### 2.3. Lấy danh mục theo ID
- **Method**: `GET`
- **Endpoint**: `/api/categories/{id}`
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
      "description": "The latest iPhone",
      "image": "https://example.com/iphone.jpg",
      "price": 999.99,
      "discountPrice": 899.99,
      "quantity": 50,
      "status": "active",
      "categoryId": 1,
      "categoryName": "Electronics",
      "averageRating": 4.5,
      "totalRatings": 10
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
- **Response**: `200 OK`

### 3.4. Lấy sản phẩm theo danh mục
- **Method**: `GET`
- **Endpoint**: `/api/products/category/{categoryId}`
- **Response**: `200 OK`

### 3.5. Tìm kiếm sản phẩm
- **Method**: `GET`
- **Endpoint**: `/api/products/search?keyword={keyword}`
- **Response**: `200 OK`

### 3.6. Tạo sản phẩm mới
- **Method**: `POST`
- **Endpoint**: `/api/products`
- **Body**:
```json
{
  "name": "iPhone 15 Pro",
  "description": "The latest iPhone",
  "image": "https://example.com/iphone.jpg",
  "price": 999.99,
  "discountPrice": 899.99,
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
  "description": "Updated description",
  "image": "https://example.com/iphone.jpg",
  "price": 1199.99,
  "discountPrice": 1099.99,
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

### 3.9. Lấy sản phẩm nổi bật
- **Method**: `GET`
- **Endpoint**: `/api/products/featured`
- **Response**: `200 OK`
- Returns products with rating >= 4.0

### 3.10. Lấy sản phẩm sắp hết hàng
- **Method**: `GET`
- **Endpoint**: `/api/products/low-stock`
- **Response**: `200 OK`
- Returns products with quantity <= 10

---

## 🛒 4. Orders API (`/api/orders`)

### 4.1. Lấy tất cả đơn hàng
- **Method**: `GET`
- **Endpoint**: `/api/orders`
- **Response**: `200 OK`

### 4.2. Lấy đơn hàng theo ID
- **Method**: `GET`
- **Endpoint**: `/api/orders/{id}`
- **Response**: `200 OK`

### 4.3. Lấy đơn hàng theo mã đơn
- **Method**: `GET`
- **Endpoint**: `/api/orders/code/{orderCode}`
- **Response**: `200 OK`

### 4.4. Lấy đơn hàng theo email
- **Method**: `GET`
- **Endpoint**: `/api/orders/customer/{email}`
- **Response**: `200 OK`

### 4.5. Lấy đơn hàng theo User ID
- **Method**: `GET`
- **Endpoint**: `/api/orders/user/{userId}`
- **Response**: `200 OK`

### 4.6. Lấy đơn hàng theo trạng thái
- **Method**: `GET`
- **Endpoint**: `/api/orders/status/{status}`
- **Response**: `200 OK`

### 4.7. Tạo đơn hàng mới
- **Method**: `POST`
- **Endpoint**: `/api/orders`
- **Response**: `201 Created`

### 4.8. Cập nhật trạng thái đơn hàng
- **Method**: `PATCH`
- **Endpoint**: `/api/orders/{id}/status?status={status}`
- **Response**: `200 OK`

### 4.9. Hủy đơn hàng
- **Method**: `DELETE`
- **Endpoint**: `/api/orders/{id}/cancel`
- **Response**: `200 OK`

---

## 👥 5. Users API (`/api/users`)

### 5.1. Lấy tất cả người dùng
- **Method**: `GET`
- **Endpoint**: `/api/users`
- **Response**: `200 OK`

### 5.2. Lấy người dùng theo ID
- **Method**: `GET`
- **Endpoint**: `/api/users/{id}`
- **Response**: `200 OK`

### 5.3. Cập nhật người dùng
- **Method**: `PUT`
- **Endpoint**: `/api/users/{id}`
- **Body**:
```json
{
  "name": "Nguyen Van A Updated",
  "username": "nguyenvana",
  "email": "test@example.com",
  "phone": "0987654321",
  "address": "New Address",
  "role": "user",
  "status": "active"
}
```
- **Response**: `200 OK`

---

## ❤️ 6. Wishlist API (`/api/wishlists`)

### 6.1. Get User Wishlist
- **Method**: `GET`
- **Endpoint**: `/api/wishlists/user/{userId}`
- **Response**: `200 OK`

### 6.2. Add to Wishlist
- **Method**: `POST`
- **Endpoint**: `/api/wishlists/user/{userId}/add/{productId}`
- **Response**: `200 OK`

### 6.3. Remove from Wishlist
- **Method**: `DELETE`
- **Endpoint**: `/api/wishlists/user/{userId}/remove/{productId}`
- **Response**: `200 OK`

---

## �️ 7. Cart API (`/api/cart`)

### 7.1. Get User Cart
- **Method**: `GET`
- **Endpoint**: `/api/cart/user/{userId}`
- **Response**: `200 OK`

### 7.2. Add to Cart
- **Method**: `POST`
- **Endpoint**: `/api/cart/user/{userId}/add/{productId}?quantity=1`
- **Response**: `200 OK`

### 7.3. Update Cart Item Quantity
- **Method**: `PUT`
- **Endpoint**: `/api/cart/user/{userId}/update/{productId}?quantity=2`
- **Response**: `200 OK`

### 7.4. Remove from Cart
- **Method**: `DELETE`
- **Endpoint**: `/api/cart/user/{userId}/remove/{productId}`
- **Response**: `200 OK`

### 7.5. Clear Cart
- **Method**: `DELETE`
- **Endpoint**: `/api/cart/user/{userId}/clear`
- **Response**: `200 OK`

---

## 📦 8. Inventory Logs API (`/api/inventory`)

### 8.1. Create Inventory Log (Admin)
- **Method**: `POST`
- **Endpoint**: `/api/inventory/log`
- **Body**:
```json
{
  "productId": 1,
  "changeQuantity": 10,
  "logType": "import",
  "notes": "Restocking"
}
```
*logType*: `import`, `export`, `adjustment`
- **Response**: `200 OK`

### 8.2. Get Product Logs
- **Method**: `GET`
- **Endpoint**: `/api/inventory/product/{productId}`
- **Response**: `200 OK`

### 8.3. Get All Logs
- **Method**: `GET`
- **Endpoint**: `/api/inventory/logs`
- **Response**: `200 OK`

---

---

## 💳 9. Payments API (`/api/payments`)

### 9.1. Create Payment
- **Method**: `POST`
- **Endpoint**: `/api/payments`
- **Body**:
```json
{
  "orderId": 1,
  "amount": 999.99,
  "paymentMethod": "credit_card",
  "status": "pending"
}
```
- **Response**: `201 Created`

### 9.2. Get Payment By ID
- **Method**: `GET`
- **Endpoint**: `/api/payments/{id}`
- **Response**: `200 OK`

### 9.3. Get Payments By Order
- **Method**: `GET`
- **Endpoint**: `/api/payments/order/{orderId}`
- **Response**: `200 OK`

### 9.4. Get Payments By User
- **Method**: `GET`
- **Endpoint**: `/api/payments/user/{userId}`
- **Response**: `200 OK`

### 9.5. Get All Payments
- **Method**: `GET`
- **Endpoint**: `/api/payments`
- **Response**: `200 OK`

### 9.6. Update Payment Status
- **Method**: `PATCH`
- **Endpoint**: `/api/payments/{id}/status?status=paid`
- **Response**: `200 OK`

---

## 📊 10. Dashboard API (`/api/dashboard`)

### 10.1. Get Dashboard Stats
- **Method**: `GET`
- **Endpoint**: `/api/dashboard/stats`
- **Response**: `200 OK`
- Returns: totalOrders, totalRevenue, totalProducts, totalUsers, recentOrders, topProducts, orderStatsByStatus

### 10.2. Get Revenue By Period
- **Method**: `GET`
- **Endpoint**: `/api/dashboard/revenue?period={period}`
- **Query Parameters**: period (daily, weekly, monthly, yearly)
- **Response**: `200 OK`

### 10.3. Get Top Products
- **Method**: `GET`
- **Endpoint**: `/api/dashboard/top-products?limit={limit}`
- **Response**: `200 OK`

### 10.4. Get Order Stats By Status
- **Method**: `GET`
- **Endpoint**: `/api/dashboard/order-stats`
- **Response**: `200 OK`

---

## 📊 Summary

| Module | Endpoints |
|--------|-----------|
| Authentication | 2 |
| Categories | 6 |
| Products | 10 |
| Orders | 9 |
| Users | 4 |
| Ratings | 4 |
| Wishlist | 3 |
| Cart | 5 |
| Inventory | 3 |
| **Payments** | **6** |
| **Dashboard** | **4** |
| **TOTAL** | **56 endpoints** |

