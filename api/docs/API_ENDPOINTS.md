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

---

## 🛒 4. Orders API (`/api/orders`)

*(No changes to existing Order endpoints)*

### 4.1. Lấy tất cả đơn hàng
- **Method**: `GET`
- **Endpoint**: `/api/orders`
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

## 📊 Summary

| Module | Endpoints |
|--------|-----------|
| Authentication | 2 |
| Categories | 6 |
| Products | 8 |
| Orders | 7 |
| Users | 4 |
| Ratings | 4 |
| **Wishlist** | **3** |
| **Cart** | **5** |
| **Inventory** | **3** |
| **TOTAL** | **42 endpoints** |

