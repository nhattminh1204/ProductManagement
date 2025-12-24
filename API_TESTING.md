# API Testing Guide

## Hướng dẫn test API với các công cụ

### 1. Sử dụng cURL

#### Test Authentication

**Đăng ký:**
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"Admin User\",\"email\":\"admin@example.com\",\"phone\":\"0123456789\",\"password\":\"admin123\"}"
```

**Đăng nhập:**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"admin@example.com\",\"password\":\"admin123\"}"
```

#### Test Categories

**Tạo danh mục:**
```bash
curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"Electronics\",\"status\":\"active\"}"
```

**Lấy tất cả danh mục:**
```bash
curl -X GET http://localhost:8080/api/categories
```

#### Test Products

**Tạo sản phẩm:**
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"iPhone 15 Pro\",\"image\":\"https://example.com/iphone.jpg\",\"price\":999.99,\"quantity\":50,\"status\":\"active\",\"categoryId\":1}"
```

**Lấy tất cả sản phẩm:**
```bash
curl -X GET http://localhost:8080/api/products
```

**Tìm kiếm sản phẩm:**
```bash
curl -X GET "http://localhost:8080/api/products/search?keyword=iPhone"
```

#### Test Orders

**Tạo đơn hàng:**
```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d "{\"customerName\":\"Nguyen Van A\",\"email\":\"customer@example.com\",\"phone\":\"0987654321\",\"address\":\"123 Main St, Hanoi\",\"paymentMethod\":\"credit_card\",\"items\":[{\"productId\":1,\"quantity\":2}]}"
```

**Lấy đơn hàng theo email:**
```bash
curl -X GET http://localhost:8080/api/orders/customer/customer@example.com
```

### 2. Sử dụng Postman

Import collection sau vào Postman:

#### Postman Collection (JSON)

Tạo file `ProductManagement.postman_collection.json`:

```json
{
  "info": {
    "name": "Product Management API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Auth",
      "item": [
        {
          "name": "Register",
          "request": {
            "method": "POST",
            "header": [{"key": "Content-Type", "value": "application/json"}],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"name\": \"Test User\",\n  \"email\": \"test@example.com\",\n  \"phone\": \"0123456789\",\n  \"password\": \"password123\"\n}"
            },
            "url": "{{baseUrl}}/auth/register"
          }
        },
        {
          "name": "Login",
          "request": {
            "method": "POST",
            "header": [{"key": "Content-Type", "value": "application/json"}],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"email\": \"test@example.com\",\n  \"password\": \"password123\"\n}"
            },
            "url": "{{baseUrl}}/auth/login"
          }
        }
      ]
    },
    {
      "name": "Categories",
      "item": [
        {
          "name": "Get All Categories",
          "request": {
            "method": "GET",
            "url": "{{baseUrl}}/categories"
          }
        },
        {
          "name": "Create Category",
          "request": {
            "method": "POST",
            "header": [{"key": "Content-Type", "value": "application/json"}],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"name\": \"Electronics\",\n  \"status\": \"active\"\n}"
            },
            "url": "{{baseUrl}}/categories"
          }
        }
      ]
    },
    {
      "name": "Products",
      "item": [
        {
          "name": "Get All Products",
          "request": {
            "method": "GET",
            "url": "{{baseUrl}}/products"
          }
        },
        {
          "name": "Create Product",
          "request": {
            "method": "POST",
            "header": [{"key": "Content-Type", "value": "application/json"}],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"name\": \"iPhone 15 Pro\",\n  \"image\": \"https://example.com/iphone.jpg\",\n  \"price\": 999.99,\n  \"quantity\": 50,\n  \"status\": \"active\",\n  \"categoryId\": 1\n}"
            },
            "url": "{{baseUrl}}/products"
          }
        },
        {
          "name": "Search Products",
          "request": {
            "method": "GET",
            "url": "{{baseUrl}}/products/search?keyword=iPhone"
          }
        }
      ]
    },
    {
      "name": "Orders",
      "item": [
        {
          "name": "Create Order",
          "request": {
            "method": "POST",
            "header": [{"key": "Content-Type", "value": "application/json"}],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"customerName\": \"Nguyen Van A\",\n  \"email\": \"customer@example.com\",\n  \"phone\": \"0987654321\",\n  \"address\": \"123 Main St, Hanoi\",\n  \"paymentMethod\": \"credit_card\",\n  \"items\": [\n    {\n      \"productId\": 1,\n      \"quantity\": 2\n    }\n  ]\n}"
            },
            "url": "{{baseUrl}}/orders"
          }
        },
        {
          "name": "Get Orders by Email",
          "request": {
            "method": "GET",
            "url": "{{baseUrl}}/orders/customer/customer@example.com"
          }
        }
      ]
    }
  ],
  "variable": [
    {
      "key": "baseUrl",
      "value": "http://localhost:8080/api"
    }
  ]
}
```

### 3. Test Flow Hoàn Chỉnh

#### Bước 1: Tạo danh mục
```bash
curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d '{"name":"Electronics","status":"active"}'
```

#### Bước 2: Tạo sản phẩm
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Laptop Dell XPS 15","image":"https://example.com/laptop.jpg","price":1500.00,"quantity":20,"status":"active","categoryId":1}'
```

#### Bước 3: Đăng ký tài khoản
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com","phone":"0123456789","password":"password123"}'
```

#### Bước 4: Tạo đơn hàng
```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{"customerName":"John Doe","email":"john@example.com","phone":"0123456789","address":"456 Elm St, HCMC","paymentMethod":"cash","items":[{"productId":1,"quantity":1}]}'
```

#### Bước 5: Kiểm tra đơn hàng
```bash
curl -X GET http://localhost:8080/api/orders/customer/john@example.com
```

#### Bước 6: Đánh giá sản phẩm
```bash
curl -X POST http://localhost:8080/api/ratings \
  -H "Content-Type: application/json" \
  -d '{"productId":1,"userId":1,"rating":5,"comment":"Excellent product!"}'
```

### 4. Kiểm tra Database

Sau khi test API, bạn có thể kiểm tra database:

```sql
-- Kiểm tra categories
SELECT * FROM categories;

-- Kiểm tra products
SELECT * FROM products;

-- Kiểm tra users
SELECT * FROM users;

-- Kiểm tra orders
SELECT * FROM orders;

-- Kiểm tra order details
SELECT * FROM order_details;

-- Kiểm tra ratings
SELECT * FROM product_ratings;
```

### 5. Expected Responses

**Success Response:**
```json
{
  "success": true,
  "message": "Success message",
  "data": { ... }
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Error message",
  "data": null
}
```

**Validation Error:**
```json
{
  "success": false,
  "message": "Validation failed",
  "data": {
    "fieldName": "error message"
  }
}
```
