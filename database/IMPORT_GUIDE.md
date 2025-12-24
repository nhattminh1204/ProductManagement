# 📊 Hướng dẫn Import Dữ liệu Mẫu

## 📁 File dữ liệu

- **`sample_data.sql`** - Dữ liệu mẫu về sản phẩm điện tử

## 📋 Tổng quan dữ liệu

### 🏷️ Categories (8 danh mục)
1. Điện thoại
2. Laptop
3. Tablet
4. Tai nghe
5. Đồng hồ thông minh
6. Phụ kiện
7. TV & Màn hình
8. Camera

### 📦 Products (45 sản phẩm)
- **Điện thoại**: 8 sản phẩm (iPhone, Samsung, Xiaomi, OPPO, Vivo, Realme)
- **Laptop**: 7 sản phẩm (MacBook, Dell, ASUS, Lenovo, HP, Acer)
- **Tablet**: 5 sản phẩm (iPad, Samsung Galaxy Tab, Xiaomi Pad)
- **Tai nghe**: 5 sản phẩm (AirPods, Sony, Samsung, JBL)
- **Đồng hồ thông minh**: 5 sản phẩm (Apple Watch, Samsung, Xiaomi, Garmin)
- **Phụ kiện**: 6 sản phẩm (Sạc, cáp, ốp lưng, bàn phím, chuột, pin dự phòng)
- **TV & Màn hình**: 4 sản phẩm (Samsung, LG, Dell, ASUS)
- **Camera**: 4 sản phẩm (Canon, Sony, GoPro, DJI)

### 👥 Users (5 người dùng)
- 1 Admin
- 4 Users thường

**Password mặc định**: `password123` (cho tất cả users)

### 🛒 Orders (4 đơn hàng)
- 2 đơn đã thanh toán (paid)
- 1 đơn đã giao (shipped)
- 1 đơn chờ xử lý (pending)

### ⭐ Ratings (15 đánh giá)
- Đánh giá cho các sản phẩm phổ biến
- Rating từ 4-5 sao
- Có comment chi tiết

---

## 🚀 Cách Import

### Phương pháp 1: MySQL Command Line (Khuyến nghị)

```bash
# Mở terminal/cmd tại thư mục database
cd d:\HUSC\Fluter\ProductManagement\database

# Import dữ liệu
mysql -u root -p product_management < sample_data.sql
```

### Phương pháp 2: MySQL Workbench

1. Mở **MySQL Workbench**
2. Kết nối đến database server
3. Chọn database `product_management`
4. Click **File** → **Open SQL Script**
5. Chọn file `sample_data.sql`
6. Click **Execute** (⚡ icon)

### Phương pháp 3: phpMyAdmin

1. Mở **phpMyAdmin**
2. Chọn database `product_management`
3. Click tab **Import**
4. Click **Choose File** → chọn `sample_data.sql`
5. Click **Go**

### Phương pháp 4: Copy-Paste

1. Mở file `sample_data.sql`
2. **Copy toàn bộ nội dung**
3. Mở MySQL client
4. **Paste** và **Execute**

---

## ✅ Kiểm tra sau khi Import

### 1. Kiểm tra số lượng records

```sql
USE product_management;

SELECT 'Categories' as 'Table', COUNT(*) as 'Records' FROM categories
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Users', COUNT(*) FROM users
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Details', COUNT(*) FROM order_details
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments
UNION ALL
SELECT 'Product Ratings', COUNT(*) FROM product_ratings;
```

**Kết quả mong đợi**:
```
+------------------+---------+
| Table            | Records |
+------------------+---------+
| Categories       |       8 |
| Products         |      45 |
| Users            |       5 |
| Orders           |       4 |
| Order Details    |       5 |
| Payments         |       4 |
| Product Ratings  |      15 |
+------------------+---------+
```

### 2. Kiểm tra một vài sản phẩm

```sql
-- Xem 5 sản phẩm đầu tiên
SELECT id, name, price, quantity, status 
FROM products 
LIMIT 5;
```

### 3. Kiểm tra users

```sql
-- Xem danh sách users
SELECT id, name, email, role, status 
FROM users;
```

**Lưu ý**: Password mặc định cho tất cả users là `password123`

### 4. Kiểm tra đơn hàng

```sql
-- Xem đơn hàng và tổng tiền
SELECT order_code, customer_name, total_amount, status 
FROM orders;
```

---

## 🧪 Test API với dữ liệu mẫu

### 1. Đăng nhập với Admin

```bash
POST /api/auth/login
{
  "email": "admin@husc.edu.vn",
  "password": "password123"
}
```

### 2. Lấy danh sách sản phẩm

```bash
GET /api/products
```

Sẽ trả về 45 sản phẩm điện tử.

### 3. Lấy sản phẩm theo danh mục

```bash
# Điện thoại
GET /api/products/category/1

# Laptop
GET /api/products/category/2
```

### 4. Tìm kiếm sản phẩm

```bash
GET /api/products/search?keyword=iPhone
GET /api/products/search?keyword=MacBook
GET /api/products/search?keyword=Samsung
```

### 5. Xem đánh giá sản phẩm

```bash
# Đánh giá iPhone 15 Pro Max (product_id = 1)
GET /api/ratings/product/1

# Đánh giá MacBook Air (product_id = 10)
GET /api/ratings/product/10
```

### 6. Xem đơn hàng

```bash
GET /api/orders
GET /api/orders/code/ORD-20251224-001
```

---

## 🔄 Reset dữ liệu (nếu cần)

Nếu muốn xóa toàn bộ dữ liệu và import lại:

```sql
-- Xóa dữ liệu (giữ cấu trúc bảng)
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE product_ratings;
TRUNCATE TABLE payments;
TRUNCATE TABLE order_details;
TRUNCATE TABLE orders;
TRUNCATE TABLE products;
TRUNCATE TABLE categories;
TRUNCATE TABLE users;

SET FOREIGN_KEY_CHECKS = 1;

-- Sau đó import lại
SOURCE sample_data.sql;
```

---

## 📊 Thống kê dữ liệu

### Sản phẩm theo danh mục

```sql
SELECT c.name as category, COUNT(p.id) as total_products
FROM categories c
LEFT JOIN products p ON c.id = p.id_category
GROUP BY c.id, c.name
ORDER BY total_products DESC;
```

### Giá trị đơn hàng

```sql
SELECT 
    COUNT(*) as total_orders,
    SUM(total_amount) as total_revenue,
    AVG(total_amount) as avg_order_value
FROM orders;
```

### Rating trung bình

```sql
SELECT 
    p.name,
    AVG(pr.rating) as avg_rating,
    COUNT(pr.id) as total_ratings
FROM products p
LEFT JOIN product_ratings pr ON p.id = pr.product_id
GROUP BY p.id, p.name
HAVING total_ratings > 0
ORDER BY avg_rating DESC, total_ratings DESC;
```

---

## 💡 Tips

1. **Backup trước khi import**: 
   ```bash
   mysqldump -u root -p product_management > backup.sql
   ```

2. **Import từng phần** nếu gặp lỗi:
   - Import categories trước
   - Sau đó products
   - Cuối cùng orders và ratings

3. **Kiểm tra encoding**: Đảm bảo file SQL là UTF-8 để hiển thị tiếng Việt đúng

4. **Adjust giá cả**: Có thể sửa giá trong file SQL trước khi import

---

## 🎯 Danh sách Users để test

| Email | Password | Role |
|-------|----------|------|
| admin@husc.edu.vn | password123 | admin |
| nguyenvana@gmail.com | password123 | user |
| tranthib@gmail.com | password123 | user |
| levanc@gmail.com | password123 | user |
| phamthid@gmail.com | password123 | user |

---

**Tạo bởi**: Product Management Team  
**Ngày**: 2025-12-24  
**Version**: 1.0.0
