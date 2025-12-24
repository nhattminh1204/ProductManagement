-- Tạo database
CREATE DATABASE IF NOT EXISTS product_management;
USE product_management;

-- Bảng categories (danh mục sản phẩm)
CREATE TABLE categories (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    status ENUM('active','inactive') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Bảng products
CREATE TABLE products (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    image VARCHAR(500),
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    status ENUM('active','inactive') NOT NULL DEFAULT 'active',
    id_category INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (id_category) REFERENCES categories(id)
);

-- Bảng users
CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    role ENUM('admin','user') NOT NULL DEFAULT 'user',
    status ENUM('active','inactive') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Bảng orders
CREATE TABLE orders (
    id INT NOT NULL AUTO_INCREMENT,
    order_code VARCHAR(50) NOT NULL UNIQUE,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status ENUM('pending','paid','shipped','cancelled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Bảng order_details
CREATE TABLE order_details (
    id INT NOT NULL AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Bảng payments (quản lý thanh toán chi tiết)
CREATE TABLE payments (
    id INT NOT NULL AUTO_INCREMENT,
    order_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status ENUM('pending','paid','failed') NOT NULL DEFAULT 'pending',
    paid_at TIMESTAMP NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- Bảng product_ratings (đánh giá sản phẩm)
CREATE TABLE product_ratings (
    id INT NOT NULL AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
