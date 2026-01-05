---
name: Kế hoạch Cải thiện Toàn diện Ứng dụng Quản lý Sản phẩm
overview: Kế hoạch tập trung vào phát triển chức năng và giao diện người dùng (UI/UX) cho cả User và Admin, bỏ qua các yếu tố bảo mật phức tạp, nhằm nhanh chóng hoàn thiện sản phẩm.
todos:
  - id: phase1-ratings
    content: Xây dựng hệ thống Đánh giá & Bình luận sản phẩm (Ratings & Reviews)
    status: pending
  - id: phase1-search-filter
    content: Triển khai Tìm kiếm & Bộ lọc nâng cao (Theo giá, danh mục, đánh giá)
    status: completed
  - id: phase1-address
    content: Hệ thống Quản lý địa chỉ giao hàng (Thêm, sửa, xóa, chọn mặc định)
    status: completed
  - id: phase1-order-tracking
    content: Theo dõi trạng thái đơn hàng (Timeline trực quan)
    status: pending
  - id: phase1-cart-enhance
    content: Cải tiến Giỏ hàng (Kiểm tra tồn kho, cảnh báo hết hàng)
    status: pending
  - id: phase2-user-management
    content: Quản lý Người dùng cho Admin (Danh sách, chi tiết, khóa tài khoản)
    status: pending
  - id: phase2-order-management
    content: Quản lý Đơn hàng nâng cao cho Admin (Lọc, in hóa đơn, cập nhật hàng loạt)
    status: pending
  - id: phase2-product-management
    content: Quản lý Sản phẩm nâng cao (Nhiều ảnh, biến thể, xóa hàng loạt)
    status: pending
  - id: phase2-dashboard-analytics
    content: Dashboard & Thống kê doanh thu, khách hàng
    status: pending
  - id: phase2-inventory
    content: Quản lý Kho hàng (Cảnh báo sắp hết hàng, lịch sử nhập xuất)
    status: pending
  - id: phase3-payment
    content: Tích hợp Thanh toán (Mô phỏng cổng thanh toán, lịch sử giao dịch)
    status: pending
    dependencies:
      - phase1-address
  - id: phase3-coupon
    content: Hệ thống Mã giảm giá (Coupon) cho người dùng
    status: pending
  - id: phase3-comparison
    content: Tính năng So sánh sản phẩm
    status: pending
  - id: phase3-view-history
    content: Lịch sử xem hàng & Sản phẩm đã xem gần đây
    status: pending
  - id: phase3-sharing
    content: Chia sẻ sản phẩm qua Mạng xã hội
    status: pending
  - id: phase3-support
    content: Trung tâm Hỗ trợ & FAQ
    status: pending
  - id: phase4-promotion-admin
    content: Quản lý Khuyến mãi & Coupon cho Admin
    status: pending
    dependencies:
      - phase3-coupon
  - id: phase4-rating-admin
    content: Quản lý Đánh giá & Bình luận cho Admin
    status: pending
    dependencies:
      - phase1-ratings
  - id: phase4-payment-admin
    content: Quản lý Giao dịch & Thanh toán cho Admin
    status: pending
    dependencies:
      - phase3-payment
  - id: phase4-category-enhance
    content: Quản lý Danh mục nâng cao (Danh mục con - Subcategories)
    status: pending
  - id: phase4-settings
    content: Cài đặt hệ thống
    status: pending
  - id: phase4-reporting
    content: Báo cáo & Phân tích chuyên sâu
    status: pending
    dependencies:
      - phase2-dashboard-analytics
  - id: phase5-dark-mode
    content: Giao diện Tối (Dark Mode)
    status: pending
  - id: phase5-localization
    content: Đa ngôn ngữ (Tiếng Việt / Tiếng Anh)
    status: pending
  - id: phase5-performance
    content: Tối ưu hiệu năng (Lazy loading, caching)
    status: pending
  - id: phase5-offline
    content: Hỗ trợ Offline (Xem sản phẩm đã cache)
    status: pending
  - id: phase5-push-notifications
    content: Thông báo đẩy (Push Notifications) cho trạng thái đơn hàng
    status: pending
  - id: phase5-image-upload
    content: Quản lý & Upload hình ảnh chuyên nghiệp
    status: pending
  - id: phase5-profile-enhance
    content: Hoàn thiện Hồ sơ người dùng (Avatar, thông tin chi tiết)
    status: pending
---

# Kế hoạch Cải thiện Toàn diện Ứng dụng Quản lý Sản phẩm

## Tổng quan

Kế hoạch này được điều chỉnh để tập trung tối đa vào **Tính năng (Functionality)** và **Giao diện (UI/UX)**, loại bỏ các rào cản về bảo mật phức tạp ở giai đoạn này. Mục tiêu là tạo ra một ứng dụng hoàn chỉnh, đẹp mắt và giàu tính năng.

---

## Phase 1: Tính năng User Cốt lõi (Trải nghiệm Mua sắm)

**Mục tiêu:** Người dùng có thể tìm kiếm, xem, đánh giá và mua hàng một cách mượt mà nhất.

### Tasks

#### Task 1.1: Đánh giá & Bình luận (Ratings & Reviews)

- **UI:** Thêm sao đánh giá (1-5) và form bình luận trong chi tiết sản phẩm.
- **Feature:** Hiển thị trung bình sao, tổng số đánh giá. User có thể viết review (có thể kèm ảnh).

#### Task 1.2: Tìm kiếm & Lọc nâng cao (Advanced Search & Filter)

- **UI:** Màn hình lọc riêng hoặc BottomSheet.
- **Feature:** Lọc theo: Khoảng giá, Danh mục, Đánh giá (4 sao+), Sắp xếp (Giá tăng/giảm, Mới nhất).

#### Task 1.3: Quản lý Địa chỉ Giao hàng

- **UI:** Màn hình danh sách địa chỉ đẹp mắt.
- **Feature:** Thêm mới, Sửa, Xóa địa chỉ. Chọn địa chỉ mặc định để tự động điền khi Checkout.

#### Task 1.4: Theo dõi Đơn hàng (Order Tracking Timeline)

- **UI:** Timeline dọc hoặc ngang thể hiện trạng thái: Chờ duyệt -> Đã duyệt -> Đang giao -> Đã giao.
- **Feature:** Cập nhật trạng thái realtime (khi Admin đổi trạng thái). Nút "Đã nhận hàng" cho User.

#### Task 1.5: Cải tiến Giỏ hàng (Smart Cart)

- **Feature:** Tự động kiểm tra tồn kho khi thêm vào giỏ. Hiển thị cảnh báo nếu số lượng mua > tồn kho. Tính tổng tiền real-time.

---

## Phase 2: Tính năng Admin Cốt lõi (Quản trị Hệ thống)

**Mục tiêu:** Cung cấp công cụ mạnh mẽ để Admin quản lý vận hành.

### Tasks

#### Task 2.1: Quản lý Người dùng

- **UI:** Danh sách User dạng bảng hoặc list card.
- **Feature:** Xem chi tiết lịch sử mua hàng của user. Khóa/Mở khóa tài khoản.

#### Task 2.2: Quản lý Đơn hàng Nâng cao

- **Feature:** 
- Bộ lọc đơn hàng (Theo trạng thái, ngày tháng).
- Thao tác nhanh: Duyệt nhanh, Hủy nhanh.
- In hóa đơn (xuất PDF đơn giản).
- Ghi chú nội bộ cho đơn hàng.

#### Task 2.3: Quản lý Sản phẩm Nâng cao

- **UI:** Form nhập liệu chuyên nghiệp hơn.
- **Feature:**
- Upload nhiều ảnh cho 1 sản phẩm (Slider ảnh).
- Xóa/Ẩn sản phẩm nhanh.
- Quản lý biến thể (Màu sắc, Size) nếu cần thiết.

#### Task 2.4: Dashboard & Thống kê (Analytics)

- **UI:** Biểu đồ đường (doanh thu), biểu đồ tròn (tỷ lệ đơn hàng).
- **Feature:**
- Thống kê doanh thu theo ngày/tuần/tháng.
- Top sản phẩm bán chạy.
- Số lượng khách hàng mới.

#### Task 2.5: Quản lý Kho hàng (Inventory)

- **Feature:**
- Cảnh báo các sản phẩm sắp hết hàng (Low stock alert).
- Lịch sử nhập/xuất kho (đơn giản).

---

## Phase 3: Tính năng User Nâng cao (Tăng tương tác)

**Mục tiêu:** Giữ chân người dùng và khuyến khích mua hàng nhiều hơn.

### Tasks

#### Task 3.1: Tích hợp Thanh toán (Payment)

- **Feature:** 
- Giao diện chọn phương thức thanh toán (Visa, Momo, COD).
- Mô phỏng quá trình thanh toán thành công/thất bại.
- Lưu lịch sử giao dịch.

#### Task 3.2: Hệ thống Coupon (Mã giảm giá)

- **UI:** Trang "Kho Voucher" của tôi.
- **Feature:** Nhập mã giảm giá khi Checkout. Trừ tiền trực tiếp hoặc theo %.

#### Task 3.3: So sánh Sản phẩm

- **UI:** Bảng so sánh 2-3 sản phẩm cạnh nhau.
- **Feature:** So sánh giá, thông số kỹ thuật.

#### Task 3.4: Lịch sử & Yêu thích

- **Feature:**
- "Sản phẩm đã xem": Lưu lại 10-20 sản phẩm gần nhất.
- "Sản phẩm yêu thích" (Wishlist): Đã có, cần hoàn thiện UI.

#### Task 3.5: Chia sẻ & Hỗ trợ

- **Feature:** Nút Share (Facebook, Zalo, Copy Link). Trang FAQ và Liên hệ hỗ trợ.

---

## Phase 4: Tính năng Admin Nâng cao (Mở rộng)

### Tasks

#### Task 4.1: Quản lý Khuyến mãi

- **Feature:** Tạo mã Coupon (Số lượng, hạn dùng, mức giảm).

#### Task 4.2: Quản lý Đánh giá

- **Feature:** Admin xem và duyệt các bình luận. Xóa bình luận spam/xúc phạm.

#### Task 4.3: Quản lý Danh mục Đa cấp

- **Feature:** Hỗ trợ danh mục cha - con (Ví dụ: Thời trang -> Nam -> Áo thun).

#### Task 4.4: Báo cáo Chuyên sâu

- **Feature:** Xuất báo cáo doanh thu ra Excel. Phân tích xu hướng mua hàng.

---

## Phase 5: Tối ưu & Hoàn thiện (Polish UI/UX)

### Tasks

#### Task 5.1: Dark Mode

- **Feature:** Chế độ giao diện tối cho toàn bộ ứng dụng.

#### Task 5.2: Đa ngôn ngữ

- **Feature:** Chuyển đổi Tiếng Việt / Tiếng Anh.

#### Task 5.3: Tối ưu Hiệu năng

- **Tech:** Lazy loading hình ảnh, Caching dữ liệu API để app mượt hơn. Skeleton loading khi chờ dữ liệu.

#### Task 5.4: Hỗ trợ Offline

- **Feature:** User vẫn xem được sản phẩm đã load khi mất mạng.

#### Task 5.5: Push Notifications

- **Feature:** Bắn thông báo khi đơn hàng thay đổi trạng thái.

#### Task 5.6: Hoàn thiện Profile

- **Feature:** Cho phép user upload Avatar, đổi mật khẩu, cập nhật thông tin cá nhân đầy đủ.