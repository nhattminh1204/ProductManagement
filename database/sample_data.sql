-- =====================================================
-- DỮ LIỆU MẪU - SẢN PHẨM ĐIỆN TỬ
-- Product Management System
-- =====================================================

USE product_management;

-- =====================================================
-- 1. CATEGORIES (Danh mục sản phẩm)
-- =====================================================

INSERT INTO categories (name, status) VALUES
('Điện thoại', 'active'),
('Laptop', 'active'),
('Tablet', 'active'),
('Tai nghe', 'active'),
('Đồng hồ thông minh', 'active'),
('Phụ kiện', 'active'),
('TV & Màn hình', 'active'),
('Camera', 'active');

-- =====================================================
-- 2. USERS (Người dùng)
-- =====================================================

-- Password mặc định: "password123" (đã mã hóa BCrypt)
INSERT INTO users (name, email, phone, password, role, status) VALUES
('Admin System', 'admin@husc.edu.vn', '0123456789', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'admin', 'active'),
('Nguyễn Văn An', 'nguyenvana@gmail.com', '0987654321', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'user', 'active'),
('Trần Thị Bình', 'tranthib@gmail.com', '0912345678', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'user', 'active'),
('Lê Văn Cường', 'levanc@gmail.com', '0909123456', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'user', 'active'),
('Phạm Thị Dung', 'phamthid@gmail.com', '0898765432', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'user', 'active');

-- =====================================================
-- 3. PRODUCTS (Sản phẩm điện tử)
-- =====================================================

-- ĐIỆN THOẠI (Category ID: 1)
INSERT INTO products (name, image, price, quantity, status, id_category) VALUES
('iPhone 15 Pro Max 256GB', 'https://cdn.tgdd.vn/Products/Images/42/305658/iphone-15-pro-max-blue-thumbnew-600x600.jpg', 29990000.00, 50, 'active', 1),
('iPhone 15 Pro 128GB', 'https://cdn.tgdd.vn/Products/Images/42/305658/iphone-15-pro-blue-thumbnew-600x600.jpg', 24990000.00, 45, 'active', 1),
('Samsung Galaxy S24 Ultra', 'https://cdn.tgdd.vn/Products/Images/42/307174/samsung-galaxy-s24-ultra-grey-thumbnew-600x600.jpg', 27990000.00, 40, 'active', 1),
('Samsung Galaxy S24', 'https://cdn.tgdd.vn/Products/Images/42/307174/samsung-galaxy-s24-violet-thumbnew-600x600.jpg', 19990000.00, 55, 'active', 1),
('Xiaomi 14 Ultra', 'https://cdn.tgdd.vn/Products/Images/42/320721/xiaomi-14-ultra-black-thumbnew-600x600.jpg', 24990000.00, 30, 'active', 1),
('OPPO Find N3 Flip', 'https://cdn.tgdd.vn/Products/Images/42/309816/oppo-find-n3-flip-pink-thumbnew-600x600.jpg', 22990000.00, 25, 'active', 1),
('Vivo V30 Pro', 'https://cdn.tgdd.vn/Products/Images/42/320722/vivo-v30-pro-black-thumbnew-600x600.jpg', 14990000.00, 60, 'active', 1),
('Realme 12 Pro+', 'https://cdn.tgdd.vn/Products/Images/42/320723/realme-12-pro-plus-green-thumbnew-600x600.jpg', 9990000.00, 70, 'active', 1),

-- LAPTOP (Category ID: 2)
('MacBook Pro 14" M3 Pro', 'https://cdn.tgdd.vn/Products/Images/44/309016/macbook-pro-14-m3-pro-2023-gray-thumbnew-600x600.jpg', 52990000.00, 20, 'active', 2),
('MacBook Air 15" M3', 'https://cdn.tgdd.vn/Products/Images/44/309017/macbook-air-15-m3-2024-gray-thumbnew-600x600.jpg', 34990000.00, 30, 'active', 2),
('Dell XPS 15 9530', 'https://cdn.tgdd.vn/Products/Images/44/307890/dell-xps-15-9530-i7-13700h-thumbnew-600x600.jpg', 45990000.00, 15, 'active', 2),
('ASUS ROG Strix G16', 'https://cdn.tgdd.vn/Products/Images/44/320724/asus-rog-strix-g16-i7-13650hx-thumbnew-600x600.jpg', 38990000.00, 25, 'active', 2),
('Lenovo ThinkPad X1 Carbon', 'https://cdn.tgdd.vn/Products/Images/44/307891/lenovo-thinkpad-x1-carbon-i7-1355u-thumbnew-600x600.jpg', 42990000.00, 18, 'active', 2),
('HP Pavilion 15', 'https://cdn.tgdd.vn/Products/Images/44/320725/hp-pavilion-15-i5-1335u-thumbnew-600x600.jpg', 18990000.00, 40, 'active', 2),
('Acer Aspire 5', 'https://cdn.tgdd.vn/Products/Images/44/320726/acer-aspire-5-i5-1235u-thumbnew-600x600.jpg', 14990000.00, 50, 'active', 2),

-- TABLET (Category ID: 3)
('iPad Pro 12.9" M2 256GB', 'https://cdn.tgdd.vn/Products/Images/522/289694/ipad-pro-129-m2-wifi-256gb-2022-gray-thumbnew-600x600.jpg', 28990000.00, 25, 'active', 3),
('iPad Air 5 M1 256GB', 'https://cdn.tgdd.vn/Products/Images/522/274443/ipad-air-5-m1-256gb-wifi-purple-thumbnew-600x600.jpg', 18990000.00, 35, 'active', 3),
('Samsung Galaxy Tab S9 Ultra', 'https://cdn.tgdd.vn/Products/Images/522/307175/samsung-galaxy-tab-s9-ultra-gray-thumbnew-600x600.jpg', 26990000.00, 20, 'active', 3),
('Samsung Galaxy Tab S9', 'https://cdn.tgdd.vn/Products/Images/522/307176/samsung-galaxy-tab-s9-beige-thumbnew-600x600.jpg', 19990000.00, 30, 'active', 3),
('Xiaomi Pad 6', 'https://cdn.tgdd.vn/Products/Images/522/320727/xiaomi-pad-6-gray-thumbnew-600x600.jpg', 8990000.00, 45, 'active', 3),

-- TAI NGHE (Category ID: 4)
('AirPods Pro 2 USB-C', 'https://cdn.tgdd.vn/Products/Images/54/325377/airpods-pro-2-usbc-thumbnew-600x600.jpg', 6490000.00, 100, 'active', 4),
('AirPods Max', 'https://cdn.tgdd.vn/Products/Images/54/228147/airpods-max-silver-thumbnew-600x600.jpg', 12990000.00, 40, 'active', 4),
('Sony WH-1000XM5', 'https://cdn.tgdd.vn/Products/Images/54/289781/sony-wh-1000xm5-black-thumbnew-600x600.jpg', 8990000.00, 60, 'active', 4),
('Samsung Galaxy Buds2 Pro', 'https://cdn.tgdd.vn/Products/Images/54/289782/samsung-galaxy-buds2-pro-purple-thumbnew-600x600.jpg', 4490000.00, 80, 'active', 4),
('JBL Tune 770NC', 'https://cdn.tgdd.vn/Products/Images/54/320728/jbl-tune-770nc-black-thumbnew-600x600.jpg', 2990000.00, 90, 'active', 4),

-- ĐỒNG HỒ THÔNG MINH (Category ID: 5)
('Apple Watch Series 9 GPS 45mm', 'https://cdn.tgdd.vn/Products/Images/7077/309013/apple-watch-s9-gps-45mm-pink-thumbnew-600x600.jpg', 10990000.00, 50, 'active', 5),
('Apple Watch Ultra 2', 'https://cdn.tgdd.vn/Products/Images/7077/309014/apple-watch-ultra-2-orange-thumbnew-600x600.jpg', 21990000.00, 30, 'active', 5),
('Samsung Galaxy Watch 6 Classic', 'https://cdn.tgdd.vn/Products/Images/7077/307177/samsung-galaxy-watch-6-classic-black-thumbnew-600x600.jpg', 8990000.00, 45, 'active', 5),
('Xiaomi Watch 2 Pro', 'https://cdn.tgdd.vn/Products/Images/7077/320729/xiaomi-watch-2-pro-black-thumbnew-600x600.jpg', 5990000.00, 60, 'active', 5),
('Garmin Fenix 7', 'https://cdn.tgdd.vn/Products/Images/7077/320730/garmin-fenix-7-black-thumbnew-600x600.jpg', 16990000.00, 25, 'active', 5),

-- PHỤ KIỆN (Category ID: 6)
('Sạc Apple 20W USB-C', 'https://cdn.tgdd.vn/Products/Images/58/228898/sac-20w-type-c-apple-mhje3-thumbnew-600x600.jpg', 490000.00, 200, 'active', 6),
('Cáp Lightning to USB-C 1m', 'https://cdn.tgdd.vn/Products/Images/58/228899/cap-lightning-to-usbc-1m-apple-thumbnew-600x600.jpg', 590000.00, 180, 'active', 6),
('Ốp lưng iPhone 15 Pro Max Silicone', 'https://cdn.tgdd.vn/Products/Images/60/305659/op-lung-iphone-15-pro-max-silicone-thumbnew-600x600.jpg', 990000.00, 150, 'active', 6),
('Bàn phím Magic Keyboard', 'https://cdn.tgdd.vn/Products/Images/4547/228900/magic-keyboard-apple-thumbnew-600x600.jpg', 2490000.00, 80, 'active', 6),
('Chuột Magic Mouse', 'https://cdn.tgdd.vn/Products/Images/86/228901/magic-mouse-apple-thumbnew-600x600.jpg', 1990000.00, 90, 'active', 6),
('Pin dự phòng Anker 20000mAh', 'https://cdn.tgdd.vn/Products/Images/57/320731/anker-20000mah-black-thumbnew-600x600.jpg', 1290000.00, 120, 'active', 6),

-- TV & MÀN HÌNH (Category ID: 7)
('Samsung QLED 4K 55 inch', 'https://cdn.tgdd.vn/Products/Images/1942/307178/samsung-qled-4k-55-inch-thumbnew-600x600.jpg', 18990000.00, 20, 'active', 7),
('LG OLED 4K 65 inch', 'https://cdn.tgdd.vn/Products/Images/1942/320732/lg-oled-4k-65-inch-thumbnew-600x600.jpg', 42990000.00, 10, 'active', 7),
('Dell UltraSharp 27" 4K', 'https://cdn.tgdd.vn/Products/Images/5697/320733/dell-ultrasharp-27-4k-thumbnew-600x600.jpg', 12990000.00, 30, 'active', 7),
('ASUS ProArt 32" 4K', 'https://cdn.tgdd.vn/Products/Images/5697/320734/asus-proart-32-4k-thumbnew-600x600.jpg', 24990000.00, 15, 'active', 7),

-- CAMERA (Category ID: 8)
('Canon EOS R6 Mark II', 'https://cdn.tgdd.vn/Products/Images/4565/320735/canon-eos-r6-mark-ii-thumbnew-600x600.jpg', 54990000.00, 10, 'active', 8),
('Sony Alpha A7 IV', 'https://cdn.tgdd.vn/Products/Images/4565/320736/sony-alpha-a7-iv-thumbnew-600x600.jpg', 52990000.00, 12, 'active', 8),
('GoPro Hero 12 Black', 'https://cdn.tgdd.vn/Products/Images/4565/320737/gopro-hero-12-black-thumbnew-600x600.jpg', 10990000.00, 35, 'active', 8),
('DJI Mini 4 Pro', 'https://cdn.tgdd.vn/Products/Images/4565/320738/dji-mini-4-pro-thumbnew-600x600.jpg', 21990000.00, 20, 'active', 8);

-- =====================================================
-- 4. ORDERS (Đơn hàng mẫu)
-- =====================================================

INSERT INTO orders (order_code, customer_name, email, phone, address, total_amount, payment_method, status) VALUES
('ORD-20251224-001', 'Nguyễn Văn An', 'nguyenvana@gmail.com', '0987654321', '123 Đường Lê Lợi, Quận 1, TP.HCM', 59980000.00, 'credit_card', 'paid'),
('ORD-20251224-002', 'Trần Thị Bình', 'tranthib@gmail.com', '0912345678', '456 Đường Trần Hưng Đạo, Quận 5, TP.HCM', 34990000.00, 'bank_transfer', 'shipped'),
('ORD-20251224-003', 'Lê Văn Cường', 'levanc@gmail.com', '0909123456', '789 Đường Nguyễn Huệ, Quận 1, TP.HCM', 18990000.00, 'cod', 'pending'),
('ORD-20251224-004', 'Phạm Thị Dung', 'phamthid@gmail.com', '0898765432', '321 Đường Hai Bà Trưng, Quận 3, TP.HCM', 28990000.00, 'credit_card', 'paid');

-- =====================================================
-- 5. ORDER DETAILS (Chi tiết đơn hàng)
-- =====================================================

-- Order 1: iPhone 15 Pro Max + MacBook Air
INSERT INTO order_details (order_id, product_id, quantity, price, subtotal) VALUES
(1, 1, 1, 29990000.00, 29990000.00),
(1, 10, 1, 34990000.00, 34990000.00);

-- Order 2: MacBook Air
INSERT INTO order_details (order_id, product_id, quantity, price, subtotal) VALUES
(2, 10, 1, 34990000.00, 34990000.00);

-- Order 3: iPad Air
INSERT INTO order_details (order_id, product_id, quantity, price, subtotal) VALUES
(3, 17, 1, 18990000.00, 18990000.00);

-- Order 4: iPad Pro
INSERT INTO order_details (order_id, product_id, quantity, price, subtotal) VALUES
(4, 16, 1, 28990000.00, 28990000.00);

-- =====================================================
-- 6. PAYMENTS (Thanh toán)
-- =====================================================

INSERT INTO payments (order_id, amount, payment_method, status, paid_at) VALUES
(1, 59980000.00, 'credit_card', 'paid', '2025-12-24 10:30:00'),
(2, 34990000.00, 'bank_transfer', 'paid', '2025-12-24 11:45:00'),
(3, 18990000.00, 'cod', 'pending', NULL),
(4, 28990000.00, 'credit_card', 'paid', '2025-12-24 14:20:00');

-- =====================================================
-- 7. PRODUCT RATINGS (Đánh giá sản phẩm)
-- =====================================================

INSERT INTO product_ratings (product_id, user_id, rating, comment) VALUES
-- iPhone 15 Pro Max
(1, 2, 5, 'Sản phẩm tuyệt vời! Camera cực đỉnh, pin trâu.'),
(1, 3, 5, 'Màn hình đẹp, hiệu năng mạnh mẽ. Rất hài lòng!'),
(1, 4, 4, 'Tốt nhưng hơi đắt. Chất lượng xứng đáng.'),

-- MacBook Air M3
(10, 2, 5, 'Máy nhẹ, pin khủng, làm việc cả ngày không lo.'),
(10, 5, 5, 'Thiết kế đẹp, hiệu năng ổn định. Đáng mua!'),

-- Samsung Galaxy S24 Ultra
(3, 3, 5, 'Bút S Pen rất tiện, màn hình siêu đẹp.'),
(3, 4, 4, 'Camera zoom 100x ấn tượng. Pin hơi yếu.'),

-- AirPods Pro 2
(22, 2, 5, 'Chống ồn tốt, âm thanh trong trẻo.'),
(22, 3, 5, 'Đeo rất vừa tai, pin lâu. Recommend!'),
(22, 5, 4, 'Tốt nhưng giá hơi cao so với đối thủ.'),

-- Apple Watch Series 9
(27, 4, 5, 'Theo dõi sức khỏe chính xác, giao diện đẹp.'),
(27, 5, 5, 'Pin 2 ngày, tính năng đầy đủ. Rất hài lòng!'),

-- iPad Pro
(16, 2, 5, 'Màn hình 120Hz mượt mà, chip M2 cực mạnh.'),
(16, 3, 4, 'Tuyệt vời cho công việc đồ họa. Hơi nặng.'),

-- Sony WH-1000XM5
(23, 4, 5, 'Chống ồn đỉnh cao, âm thanh chi tiết.'),
(23, 5, 4, 'Đeo lâu hơi nóng tai nhưng chất lượng tốt.');

-- =====================================================
-- HOÀN TẤT
-- =====================================================

-- Kiểm tra dữ liệu đã insert
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
