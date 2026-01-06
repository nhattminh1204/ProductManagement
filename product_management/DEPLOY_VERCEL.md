# Hướng dẫn Deploy ứng dụng Flutter lên Vercel

Tài liệu này hướng dẫn cách đưa ứng dụng Flutter Web lên Vercel để chạy online (hỗ trợ truy cập từ điện thoại iPhone/Android qua mạng internet).

## 1. Chuẩn bị công cụ
Trước khi bắt đầu, hãy đảm bảo bạn đã cài các công cụ sau:
1.  **Node.js**: [Tải tại đây](https://nodejs.org/).
2.  **Vercel CLI**: Mở Terminal và chạy lệnh:
    ```powershell
    npm install -g vercel
    ```
3.  **Đăng nhập Vercel**:
    ```powershell
    vercel login
    ```
    (Làm theo hướng dẫn để đăng nhập bằng Email hoặc GitHub/Google).

---

## 2. Các bước Deploy (Thực hiện mỗi khi cập nhật code)

### Bước 1: Build ứng dụng Flutter
Chạy lệnh sau ở thư mục gốc dự án để tạo bản web:
```powershell
flutter build web --release
```

### Bước 2: Copy cấu hình Routing
Để tránh lỗi 404 khi load lại trang (F5), cần có file `vercel.json`.
Chạy lệnh copy file này vào thư mục build:
```powershell
copy vercel.json build\web\
```

### Bước 3: Đẩy lên Vercel
Di chuyển vào thư mục vừa build và chạy lệnh deploy:

1.  Vào thư mục web:
    ```powershell
    cd build\web
    ```

2.  Đẩy code lên:
    ```powershell
    vercel --prod
    ```

### Bước 4: Trả lời các câu hỏi của Vercel (chỉ hỏi lần đầu)
Khi chạy lệnh `vercel --prod`, bạn sẽ cần chọn như sau:

*   `Set up and deploy?`: **Y** (Yes)
*   `Which scope?`: **[Chọn tài khoản của bạn]** (Enter)
*   `Link to existing project?`: **N** (No - nếu tạo mới)
*   `What’s your project’s name?`: **Nhập tên viết thường** (quan trọng!)
    *   ✅ Đúng: `sunnyestore`, `quan-ly-ban-hang`
    *   ❌ Sai: `SunnyeStore` (không được viết hoa)
*   `In which directory is your code located?`: **./** (Giữ nguyên, nhấn Enter)
*   `Want to modify these settings?`: **N** (No - nhấn Enter)

---

## 3. Kết quả
Sau khi chạy xong, Terminal sẽ hiện ra đường link **Production**, ví dụ:
`https://sunnyestore.vercel.app`

Bạn có thể gửi link này qua Zalo/Messenger để mở trên điện thoại iPhone.

### Mẹo: Cài đặt như App trên iPhone
1. Mở link trên Safari.
2. Bấm nút **Chia sẻ** (biểu tượng mũi tên đi lên).
3. Chọn **Thêm vào Màn hình chính** (Add to Home Screen).
