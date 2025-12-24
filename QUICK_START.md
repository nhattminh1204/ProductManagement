# Quick Start Guide - Product Management API

## 📋 Yêu cầu

- ✅ Java 17+
- ✅ Maven 3.6+
- ✅ MySQL 8.0+
- ✅ IDE (IntelliJ IDEA, Eclipse, hoặc VS Code)

## 🚀 Bắt đầu nhanh (5 phút)

### Bước 1: Clone/Download dự án
```bash
cd d:\HUSC\Fluter\ProductManagement
```

### Bước 2: Cấu hình Database
File `src/main/resources/application.properties` đã được cấu hình sẵn:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/product_management?createDatabaseIfNotExist=true
spring.datasource.username=root
spring.datasource.password=123456
```

**Lưu ý:** Database sẽ tự động được tạo khi chạy ứng dụng lần đầu!

### Bước 3: Chạy ứng dụng

**Cách 1: Sử dụng Maven**
```bash
mvn spring-boot:run
```

**Cách 2: Sử dụng IDE**
- Mở dự án trong IDE
- Chạy file `ProductManagementApplication.java`

### Bước 4: Kiểm tra
Mở browser và truy cập: `http://localhost:8080/api/categories`

Nếu thấy response:
```json
{
  "success": true,
  "message": "Success",
  "data": []
}
```
✅ **Thành công!** API đã sẵn sàng.

## 🧪 Test API ngay lập tức

### 1. Tạo danh mục đầu tiên
```bash
curl -X POST http://localhost:8080/api/categories -H "Content-Type: application/json" -d "{\"name\":\"Electronics\",\"status\":\"active\"}"
```

### 2. Tạo sản phẩm đầu tiên
```bash
curl -X POST http://localhost:8080/api/products -H "Content-Type: application/json" -d "{\"name\":\"iPhone 15\",\"price\":999.99,\"quantity\":10,\"categoryId\":1}"
```

### 3. Đăng ký tài khoản
```bash
curl -X POST http://localhost:8080/api/auth/register -H "Content-Type: application/json" -d "{\"name\":\"Test User\",\"email\":\"test@test.com\",\"password\":\"123456\"}"
```

### 4. Tạo đơn hàng
```bash
curl -X POST http://localhost:8080/api/orders -H "Content-Type: application/json" -d "{\"customerName\":\"Test User\",\"email\":\"test@test.com\",\"phone\":\"0123456789\",\"address\":\"123 Test St\",\"paymentMethod\":\"cash\",\"items\":[{\"productId\":1,\"quantity\":1}]}"
```

## 📱 Sử dụng với Postman

1. Mở Postman
2. Import collection từ file `API_TESTING.md`
3. Set biến `baseUrl` = `http://localhost:8080/api`
4. Bắt đầu test!

## 🗂️ Cấu trúc API

### Base URL
```
http://localhost:8080/api
```

### Endpoints chính

| Module | Endpoint | Mô tả |
|--------|----------|-------|
| Auth | `/auth/register` | Đăng ký |
| Auth | `/auth/login` | Đăng nhập |
| Categories | `/categories` | Quản lý danh mục |
| Products | `/products` | Quản lý sản phẩm |
| Orders | `/orders` | Quản lý đơn hàng |
| Users | `/users` | Quản lý người dùng |
| Ratings | `/ratings` | Đánh giá sản phẩm |

## 💡 Các tính năng chính

### 1. Quản lý sản phẩm
- ✅ CRUD sản phẩm
- ✅ Tìm kiếm sản phẩm
- ✅ Lọc theo danh mục
- ✅ Quản lý tồn kho

### 2. Quản lý đơn hàng
- ✅ Tạo đơn hàng
- ✅ Tự động tính tổng tiền
- ✅ Tự động trừ tồn kho
- ✅ Quản lý trạng thái đơn hàng
- ✅ Hủy đơn hàng (hoàn tồn kho)

### 3. Xác thực
- ✅ Đăng ký/Đăng nhập
- ✅ JWT Token
- ✅ Mã hóa mật khẩu (BCrypt)
- ✅ Phân quyền (Admin/User)

### 4. Đánh giá sản phẩm
- ✅ Đánh giá 1-5 sao
- ✅ Bình luận
- ✅ Tính điểm trung bình

## 🔧 Troubleshooting

### Lỗi kết nối MySQL
```
Error: Communications link failure
```
**Giải pháp:**
- Kiểm tra MySQL đang chạy
- Kiểm tra username/password trong `application.properties`
- Kiểm tra port MySQL (mặc định: 3306)

### Lỗi port 8080 đã được sử dụng
```
Error: Port 8080 is already in use
```
**Giải pháp:**
Thay đổi port trong `application.properties`:
```properties
server.port=8081
```

### Database không tự động tạo
**Giải pháp:**
Chạy file SQL thủ công:
```bash
mysql -u root -p < database/product_management.sql
```

## 📊 Kiểm tra Database

Sau khi chạy ứng dụng, kiểm tra database:

```sql
-- Kết nối MySQL
mysql -u root -p

-- Chọn database
USE product_management;

-- Xem các bảng
SHOW TABLES;

-- Kiểm tra dữ liệu
SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM users;
SELECT * FROM orders;
```

## 📚 Tài liệu chi tiết

- `README.md` - Tổng quan dự án
- `PROJECT_STRUCTURE.md` - Cấu trúc chi tiết
- `API_TESTING.md` - Hướng dẫn test API
- `database/product_management.sql` - Database schema

## 🎯 Workflow mẫu

### Workflow 1: Tạo sản phẩm và bán hàng
```
1. Tạo danh mục (POST /categories)
2. Tạo sản phẩm (POST /products)
3. Khách hàng đăng ký (POST /auth/register)
4. Tạo đơn hàng (POST /orders)
5. Kiểm tra tồn kho đã giảm (GET /products/{id})
```

### Workflow 2: Quản lý đơn hàng
```
1. Xem tất cả đơn hàng (GET /orders)
2. Cập nhật trạng thái (PATCH /orders/{id}/status?status=paid)
3. Cập nhật trạng thái (PATCH /orders/{id}/status?status=shipped)
4. Hoặc hủy đơn (DELETE /orders/{id}/cancel)
```

### Workflow 3: Đánh giá sản phẩm
```
1. Khách mua hàng (POST /orders)
2. Đánh giá sản phẩm (POST /ratings)
3. Xem đánh giá (GET /ratings/product/{productId})
4. Sản phẩm hiển thị điểm TB (GET /products/{id})
```

## 🔐 Security Notes

- Mật khẩu được mã hóa bằng BCrypt
- JWT token có thời hạn 24 giờ
- CORS được enable cho tất cả origins (development)
- Trong production, nên giới hạn CORS origins

## 📞 Hỗ trợ

Nếu gặp vấn đề:
1. Kiểm tra logs trong console
2. Kiểm tra MySQL logs
3. Xem file `README.md` và `API_TESTING.md`
4. Kiểm tra cấu hình trong `application.properties`

## 🎉 Chúc mừng!

Bạn đã sẵn sàng sử dụng Product Management API! 🚀

**Next Steps:**
- Tích hợp với Flutter app
- Thêm file upload cho product images
- Deploy lên server
- Thêm unit tests
