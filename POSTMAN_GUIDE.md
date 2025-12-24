# 📮 Hướng dẫn Import Postman Collection

## 🎯 File đã tạo

- **`postman_collection.json`** - Postman Collection chứa tất cả 31 API endpoints

## 📥 Cách Import vào Postman

### Phương pháp 1: Import File (Khuyến nghị)

1. **Mở Postman**
2. Click **Import** ở góc trên bên trái
3. Chọn tab **File**
4. Click **Upload Files**
5. Chọn file `postman_collection.json`
6. Click **Import**

### Phương pháp 2: Drag & Drop

1. **Mở Postman**
2. **Kéo thả** file `postman_collection.json` vào cửa sổ Postman
3. Click **Import**

### Phương pháp 3: Copy-Paste

1. **Mở Postman**
2. Click **Import**
3. Chọn tab **Raw text**
4. **Copy toàn bộ nội dung** file `postman_collection.json`
5. **Paste** vào ô text
6. Click **Continue** → **Import**

---

## ✅ Sau khi Import

Bạn sẽ thấy collection **"Product Management API"** với cấu trúc:

```
📁 Product Management API
├── 📂 1. Authentication (2 requests)
│   ├── Register
│   └── Login
├── 📂 2. Categories (6 requests)
│   ├── Get All Categories
│   ├── Get Active Categories
│   ├── Get Category By ID
│   ├── Create Category
│   ├── Update Category
│   └── Delete Category
├── 📂 3. Products (8 requests)
│   ├── Get All Products
│   ├── Get Active Products
│   ├── Get Product By ID
│   ├── Get Products By Category
│   ├── Search Products
│   ├── Create Product
│   ├── Update Product
│   └── Delete Product
├── 📂 4. Orders (7 requests)
│   ├── Get All Orders
│   ├── Get Order By ID
│   ├── Get Order By Code
│   ├── Get Orders By Customer Email
│   ├── Create Order
│   ├── Update Order Status
│   └── Cancel Order
├── 📂 5. Users (4 requests)
│   ├── Get All Users
│   ├── Get User By ID
│   ├── Update User
│   └── Delete User
└── 📂 6. Product Ratings (4 requests)
    ├── Get Ratings By Product
    ├── Get Ratings By User
    ├── Create Rating
    └── Delete Rating
```

---

## 🔧 Cấu hình Environment Variable

Collection đã có biến `{{base_url}}` được set sẵn:

```
base_url = http://localhost:8080/api
```

### Thay đổi Base URL (nếu cần)

**Cách 1: Trong Collection**
1. Click vào collection **"Product Management API"**
2. Chọn tab **Variables**
3. Sửa giá trị `base_url` (ví dụ: `http://192.168.1.100:8080/api`)
4. Click **Save**

**Cách 2: Tạo Environment mới**
1. Click icon ⚙️ (Settings) ở góc phải
2. Click **Add** để tạo environment mới
3. Đặt tên: `Production` hoặc `Development`
4. Thêm variable:
   - **Variable**: `base_url`
   - **Initial Value**: `http://localhost:8080/api`
   - **Current Value**: `http://localhost:8080/api`
5. Click **Save**
6. Chọn environment vừa tạo từ dropdown

---

## 🧪 Test API

### 1. Khởi động Server
```bash
cd d:\HUSC\Fluter\ProductManagement
mvn spring-boot:run
```

### 2. Test từng bước

#### Bước 1: Test Categories
1. Mở folder **"2. Categories"**
2. Click **"Get All Categories"**
3. Click **Send**
4. Kết quả mong đợi:
```json
{
  "success": true,
  "message": "Success",
  "data": []
}
```

#### Bước 2: Tạo Category
1. Click **"Create Category"**
2. Kiểm tra Body:
```json
{
  "name": "Electronics",
  "status": "active"
}
```
3. Click **Send**
4. Kết quả: Category mới được tạo với ID

#### Bước 3: Tạo Product
1. Mở folder **"3. Products"**
2. Click **"Create Product"**
3. **Sửa categoryId** trong Body thành ID vừa tạo
4. Click **Send**

#### Bước 4: Đăng ký User
1. Mở folder **"1. Authentication"**
2. Click **"Register"**
3. Click **Send**

#### Bước 5: Đăng nhập
1. Click **"Login"**
2. Click **Send**
3. Copy **token** từ response

#### Bước 6: Tạo Order
1. Mở folder **"4. Orders"**
2. Click **"Create Order"**
3. **Sửa productId** trong items thành ID product đã tạo
4. Click **Send**

---

## 🎨 Tùy chỉnh Requests

### Thay đổi ID trong URL
Các request có `{id}` trong URL (ví dụ: `/categories/1`):
1. Click vào request
2. Sửa số `1` thành ID bạn muốn
3. Click **Send**

### Thay đổi Body
Các request POST/PUT có Body:
1. Click vào tab **Body**
2. Sửa JSON theo nhu cầu
3. Click **Send**

### Thay đổi Query Parameters
Các request có query params (ví dụ: `?keyword=iPhone`):
1. Click vào tab **Params**
2. Sửa giá trị
3. Click **Send**

---

## 💾 Lưu Response Examples

Để lưu response làm example:

1. Send request thành công
2. Click **Save Response**
3. Đặt tên: "Success Example"
4. Click **Save**

Lần sau mở request sẽ thấy example đã lưu.

---

## 🔄 Chạy toàn bộ Collection

### Collection Runner

1. Click vào collection **"Product Management API"**
2. Click **Run** (hoặc ⏵)
3. Chọn folder muốn chạy (hoặc chọn tất cả)
4. Click **Run Product Management API**
5. Xem kết quả từng request

### Thứ tự chạy đề xuất:
1. ✅ Categories → Create Category
2. ✅ Products → Create Product
3. ✅ Authentication → Register
4. ✅ Authentication → Login
5. ✅ Orders → Create Order
6. ✅ Ratings → Create Rating

---

## 📊 Export Collection

Để chia sẻ collection:

1. Click vào collection **"Product Management API"**
2. Click **⋯** (3 dots)
3. Click **Export**
4. Chọn **Collection v2.1 (recommended)**
5. Click **Export**
6. Lưu file

---

## 🐛 Troubleshooting

### Lỗi: "Could not get any response"
- ✅ Kiểm tra server đang chạy: `http://localhost:8080`
- ✅ Kiểm tra firewall
- ✅ Thử ping: `curl http://localhost:8080/api/categories`

### Lỗi: 404 Not Found
- ✅ Kiểm tra URL đúng chưa
- ✅ Kiểm tra base_url variable
- ✅ Xem logs server

### Lỗi: 400 Bad Request
- ✅ Kiểm tra Body JSON đúng format
- ✅ Kiểm tra required fields
- ✅ Xem response message

### Lỗi: 500 Internal Server Error
- ✅ Xem logs server
- ✅ Kiểm tra database connection
- ✅ Kiểm tra foreign key constraints

---

## 📱 Postman Mobile

Collection cũng hoạt động trên Postman Mobile:
1. Đăng nhập cùng tài khoản
2. Collection tự động sync
3. Test API trên điện thoại

---

## 🔗 Liên kết hữu ích

- [Postman Learning Center](https://learning.postman.com/)
- [API Documentation](./API_ENDPOINTS.md)
- [Quick Start Guide](./QUICK_START.md)

---

**Tạo bởi**: Product Management Team  
**Ngày**: 2025-12-24  
**Version**: 1.0.0
