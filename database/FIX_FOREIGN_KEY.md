# 🔧 Fix Lỗi Foreign Key - Sample Data

## ❌ Lỗi gặp phải

```
Error Code: 1452. Cannot add or update a child row: 
a foreign key constraint fails (`product_management`.`product_ratings`, 
CONSTRAINT `product_ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`))
```

## 🔍 Nguyên nhân

Khi insert `product_ratings` với `user_id = 2, 3, 4, 5`, nhưng trong bảng `users` chỉ có ID từ 1-5 (do AUTO_INCREMENT không được reset sau khi xóa dữ liệu cũ).

**Vấn đề**:
- Bạn đã delete user với ID=3 trước đó
- Khi insert users mới, MySQL tạo ID tiếp theo (không phải từ 1)
- Ratings tham chiếu đến user_id không tồn tại → Lỗi!

## ✅ Giải pháp

Đã thêm vào đầu file `sample_data.sql`:

```sql
-- Xóa dữ liệu cũ
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE product_ratings;
TRUNCATE TABLE payments;
TRUNCATE TABLE order_details;
TRUNCATE TABLE orders;
TRUNCATE TABLE products;
TRUNCATE TABLE categories;
TRUNCATE TABLE users;

SET FOREIGN_KEY_CHECKS = 1;

-- Reset AUTO_INCREMENT về 1
ALTER TABLE categories AUTO_INCREMENT = 1;
ALTER TABLE products AUTO_INCREMENT = 1;
ALTER TABLE users AUTO_INCREMENT = 1;
ALTER TABLE orders AUTO_INCREMENT = 1;
ALTER TABLE order_details AUTO_INCREMENT = 1;
ALTER TABLE payments AUTO_INCREMENT = 1;
ALTER TABLE product_ratings AUTO_INCREMENT = 1;
```

## 🚀 Chạy lại

### Cách 1: MySQL Workbench
1. Mở file `sample_data.sql`
2. Click **Execute** (⚡)
3. ✅ Thành công!

### Cách 2: Command Line
```bash
cd d:\HUSC\Fluter\ProductManagement\database
mysql -u root -p product_management < sample_data.sql
```

### Cách 3: Copy-Paste
1. Mở file `sample_data.sql`
2. **Select All** (Ctrl+A)
3. **Copy** (Ctrl+C)
4. Paste vào MySQL Workbench
5. **Execute**

## ✅ Kết quả mong đợi

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

## 🎯 Kiểm tra

```sql
-- Xem users
SELECT id, name, email FROM users;

-- Kết quả:
-- ID: 1, 2, 3, 4, 5 (liên tục, không có gap)

-- Xem ratings
SELECT pr.id, pr.user_id, u.name, pr.rating, pr.comment 
FROM product_ratings pr
JOIN users u ON pr.user_id = u.id
LIMIT 5;
```

## 💡 Giải thích

### TRUNCATE vs DELETE

**DELETE**:
```sql
DELETE FROM users;
-- Xóa dữ liệu nhưng GIỮ AUTO_INCREMENT
-- Nếu ID cuối là 3, ID mới sẽ là 4
```

**TRUNCATE**:
```sql
TRUNCATE TABLE users;
-- Xóa dữ liệu VÀ reset AUTO_INCREMENT về 1
-- ID mới sẽ bắt đầu từ 1
```

### SET FOREIGN_KEY_CHECKS

```sql
SET FOREIGN_KEY_CHECKS = 0;
-- Tắm kiểm tra foreign key tạm thời
-- Cho phép TRUNCATE bảng có foreign key

TRUNCATE TABLE users;

SET FOREIGN_KEY_CHECKS = 1;
-- Bật lại kiểm tra foreign key
```

### ALTER TABLE AUTO_INCREMENT

```sql
ALTER TABLE users AUTO_INCREMENT = 1;
-- Đặt lại AUTO_INCREMENT về 1
-- ID tiếp theo sẽ là 1
```

## 🎉 Hoàn tất

File `sample_data.sql` đã được fix và sẵn sàng import!

---

**Updated**: 2025-12-24 15:21  
**Status**: READY
