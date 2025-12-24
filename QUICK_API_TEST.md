# Quick API Testing Guide

## 🚀 API đã sẵn sàng!

Server đang chạy tại: `http://localhost:8080`

## ✅ Test nhanh các endpoint

### 1. Lấy danh sách categories
```bash
curl http://localhost:8080/api/categories
```

**PowerShell:**
```powershell
Invoke-WebRequest -Uri http://localhost:8080/api/categories -UseBasicParsing
```

### 2. Tạo category mới
```bash
curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"Electronics\",\"status\":\"active\"}"
```

**PowerShell:**
```powershell
$body = @{
    name = "Electronics"
    status = "active"
} | ConvertTo-Json

Invoke-WebRequest -Uri http://localhost:8080/api/categories `
  -Method POST `
  -ContentType "application/json" `
  -Body $body `
  -UseBasicParsing
```

### 3. Đăng ký tài khoản
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"Nguyen Van A\",\"email\":\"test@example.com\",\"phone\":\"0123456789\",\"password\":\"password123\"}"
```

**PowerShell:**
```powershell
$body = @{
    name = "Nguyen Van A"
    email = "test@example.com"
    phone = "0123456789"
    password = "password123"
} | ConvertTo-Json

Invoke-WebRequest -Uri http://localhost:8080/api/auth/register `
  -Method POST `
  -ContentType "application/json" `
  -Body $body `
  -UseBasicParsing
```

### 4. Đăng nhập
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"test@example.com\",\"password\":\"password123\"}"
```

**PowerShell:**
```powershell
$body = @{
    email = "test@example.com"
    password = "password123"
} | ConvertTo-Json

Invoke-WebRequest -Uri http://localhost:8080/api/auth/login `
  -Method POST `
  -ContentType "application/json" `
  -Body $body `
  -UseBasicParsing
```

### 5. Tạo sản phẩm
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"iPhone 15 Pro\",\"image\":\"https://example.com/iphone.jpg\",\"price\":999.99,\"quantity\":50,\"status\":\"active\",\"categoryId\":1}"
```

**PowerShell:**
```powershell
$body = @{
    name = "iPhone 15 Pro"
    image = "https://example.com/iphone.jpg"
    price = 999.99
    quantity = 50
    status = "active"
    categoryId = 1
} | ConvertTo-Json

Invoke-WebRequest -Uri http://localhost:8080/api/products `
  -Method POST `
  -ContentType "application/json" `
  -Body $body `
  -UseBasicParsing
```

### 6. Lấy danh sách sản phẩm
```bash
curl http://localhost:8080/api/products
```

**PowerShell:**
```powershell
Invoke-WebRequest -Uri http://localhost:8080/api/products -UseBasicParsing
```

### 7. Tìm kiếm sản phẩm
```bash
curl "http://localhost:8080/api/products/search?keyword=iPhone"
```

**PowerShell:**
```powershell
Invoke-WebRequest -Uri "http://localhost:8080/api/products/search?keyword=iPhone" -UseBasicParsing
```

## 📝 Response Format

Tất cả API trả về format:

```json
{
  "success": true,
  "message": "Success message",
  "data": { ... }
}
```

## 🔧 Lưu ý

- **Security hiện tại**: Tất cả endpoints đều public (để test)
- **Production**: Cần bật lại authentication cho các endpoint quan trọng
- **Database**: Đảm bảo MySQL đang chạy và đã tạo database `product_management`

## 🌐 Test bằng Browser

Mở browser và truy cập:
- http://localhost:8080/api/categories
- http://localhost:8080/api/products
- http://localhost:8080/api/orders

## 🛠️ Tools khác

### Postman
Import các endpoint từ file `API_TESTING.md`

### Thunder Client (VS Code Extension)
Tạo request mới với URL: `http://localhost:8080/api/categories`

### Browser DevTools
```javascript
fetch('http://localhost:8080/api/categories')
  .then(res => res.json())
  .then(data => console.log(data));
```
