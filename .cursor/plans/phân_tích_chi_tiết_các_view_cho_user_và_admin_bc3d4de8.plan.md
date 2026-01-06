---
name: Phân tích chi tiết các View cho User và Admin
overview: Tài liệu phân tích toàn diện về tất cả các màn hình (views) trong ứng dụng Flutter Product Management, bao gồm bố cục, thành phần, vị trí, kích thước và màu sắc cho cả user và admin.
todos: []
---

#Phân tích chi tiết các View cho User và Admin

## Hệ thống màu sắc chung (Design System)

### AppColors (từ `design_system.dart`)

- **Primary**: `#F0768B` (Màu hồng - Pink)
- **Secondary**: `#10B981` (Emerald - Xanh lá)
- **Warning**: `#F59E0B` (Amber - Vàng cam)
- **Error**: `#EF4444` (Red - Đỏ)
- **Background**: `#F9FAFB` (Gray 50 - Xám nhạt)
- **Surface**: `Colors.white` (Trắng)
- **Text Main**: `#111827` (Gray 900 - Xám đậm)

---

## PHẦN 1: VIEWS CHO USER

### 1. Login Screen (`login_screen.dart`)

**Bố cục**: Scaffold với Stack layout

- **Background**: Màu trắng (`Colors.white`)
- **Kích thước màn hình**: Full screen

**Các thành phần**:

1. **Decorative Background Elements** (Positioned widgets):

- Vòng tròn trên phải: `width: 300, height: 300`, màu `AppColors.primary` với opacity 0.1, vị trí `top: -100, right: -100`
- Vòng tròn dưới trái: `width: 200, height: 200`, màu `AppColors.secondary` với opacity 0.1, vị trí `bottom: -50, left: -50`

2. **Logo Section** (Center):

- Container tròn: `120x120`, màu trắng, có shadow
- Icon: `Icons.inventory_2_rounded`, size 60, màu `AppColors.primary`
- Khoảng cách dưới: `32px`

3. **Welcome Text**:

- Tiêu đề: "Chào mừng trở lại", `headlineMedium`, bold, màu `AppColors.textMain`
- Phụ đề: "Đăng nhập để tiếp tục", `bodyLarge`, màu `Colors.grey[600]`
- Khoảng cách dưới: `48px`

4. **Login Form Container**:

- Padding: `24px` tất cả các phía
- Background: Trắng
- Border radius: `24px`
- Shadow: `blurRadius: 30, offset: (0, 10)`, màu đen opacity 0.05
- Border: `Colors.grey.shade100`

5. **Text Fields**:

- Background: `Colors.grey[50]` (xám rất nhạt)
- Border radius: `16px`
- Padding: `horizontal: 24, vertical: 16`
- Prefix icon: Màu `AppColors.primary` với opacity 0.7, size 22
- Focused border: `AppColors.primary`, width 2
- Error border: `AppColors.error` với opacity 0.5

6. **Login Button**:

- Height: `56px`
- Background: `AppColors.primary`
- Text color: Trắng
- Border radius: `16px`
- Elevation: 2
- Shadow color: `AppColors.primary` với opacity 0.4

7. **Footer** (Register link):

- Text: "Chưa có tài khoản? Đăng ký"
- Link color: `AppColors.primary`, bold

---

### 2. User Main Screen (`user_main_screen.dart`)

**Bố cục**: Scaffold với IndexedStack

- **Background**: `AppColors.background`
- **Drawer**: `AppDrawer` (bên trái)
- **Body**: IndexedStack chứa 4 tab:

1. UserHomeScreen (index 0)
2. CartScreen (index 1)
3. WishlistScreen (index 2)
4. UserProfileTab (index 3)

**AppDrawer**:

- Header: `UserAccountsDrawerHeader`
- Background: `AppColors.primary`
- Account name: "Customer" hoặc "Administrator"
- Account email: Email của user
- Avatar: CircleAvatar trắng, icon `Icons.person`, màu `AppColors.primary`, size 40
- Menu items: ListTile với icon và title
- Home (index 0)
- Cart (index 1)
- Products (navigate)
- Profile (index 2)
- Order History (navigate)
- Sign Out (màu đỏ)

---

### 3. User Home Screen (`user_home_screen.dart`)

**Bố cục**: Scaffold với CustomScrollView (SliverAppBar + SliverList)

- **Background**: `AppColors.background`

**Các thành phần**:

1. **SliverAppBar** (Pinned):

- Background: `AppColors.primary`
- Title: "Khám phá", màu trắng, bold, `titleLarge`
- Leading: Icon menu (mở drawer), màu trắng
- Actions: Icon search, màu trắng
- Elevation: 0

2. **Featured Products Section** (nếu có):

- Header: Row với icon star (màu amber, size 24), text "Sản phẩm nổi bật" (font size 20, bold), button "Xem tất cả"
- Padding: `horizontal: 20, vertical: 16`
- Product list: Horizontal ListView
    - Height: `280px`
    - Padding: `horizontal: 16`
    - Item width: `170px`
    - Spacing: `12px` giữa các items

3. **Category Sections**:

- Mỗi category có header tương tự Featured
- Product cards: `ProductCardUser`, width 170px, height 280px

4. **FloatingActionButton** (Cart):

- Background: `AppColors.primary`
- Icon: `Icons.shopping_cart_rounded`, màu trắng
- Badge: Vòng tròn đỏ, min size 20x20, hiển thị số lượng items
- Position: `endFloat`

---

### 4. User Product List Screen (`user_product_list_screen.dart`)

**Bố cục**: Scaffold với CustomScrollView

- **Background**: `AppColors.background`

**Các thành phần**:

1. **SliverAppBar**:

- Background: `AppColors.primary`
- Title: "Sản phẩm", màu trắng, bold
- Actions: Icon notification, màu trắng

2. **Search Bar** (SliverToBoxAdapter):

- Container trắng, border radius `16px`, shadow
- TextField: Hint "Tìm kiếm sản phẩm...", prefix icon search (màu primary)
- Filter button: Icon `Icons.tune_rounded`, màu primary
- Padding: `horizontal: 20, vertical: 10`

3. **Category Filter Chips** (Horizontal ListView):

- Height: `50px`
- Padding: `horizontal: 20`
- Chip: 
    - Selected: Background `AppColors.primary`, text trắng, shadow
    - Unselected: Background trắng, text `Colors.grey[700]`, border xám
    - Border radius: `30px`
    - Padding: `horizontal: 20, vertical: 10`

4. **Product Grid** (SliverGrid):

- Cross axis count: 3
- Child aspect ratio: 0.65
- Spacing: `8px` (cross và main)
- Padding: `horizontal: 20, vertical: 10`

5. **FloatingActionButton**: Tương tự User Home Screen

---

### 5. Product Detail Screen (`product_detail_screen.dart`)

**Bố cục**: Scaffold với CustomScrollView + TabBar + BottomSheet

- **Background**: Trắng

**Các thành phần**:

1. **AppBar**:

- Background: `AppColors.primary`
- Title: "Chi tiết sản phẩm", màu trắng
- Elevation: 0

2. **Product Image** (SliverToBoxAdapter):

- Height: `400px`
- Stack layout:
    - Image: Full width/height, `BoxFit.cover`
    - Wishlist button: Positioned top-right (16, 16)
    - Container tròn: `48x48`, trắng, shadow
    - LoveButton: Size 28

3. **TabBar** (SliverPersistentHeader):

- Pinned: true
- Tabs: "Thông tin", "Đánh giá", "Lịch sử" (nếu admin)
- Label color: `AppColors.primary`
- Indicator: `AppColors.primary`, weight 3

4. **Tab Content**:

- **Thông tin tab**:
    - Category badge: Background primary với opacity 0.1, border radius 20
    - Product name: Font size 28, bold, màu `AppColors.textMain`
    - Price: Font size 26, weight 800, màu `AppColors.primary`
    - Stock status: Container với màu xanh/đỏ tùy trạng thái
    - Description: Font size 15, màu `Colors.grey[700]`
- **Đánh giá tab**:
    - Rating cards: Mỗi card có avatar, tên, stars, comment, date
- **Lịch sử tab** (admin):
    - Inventory logs với icon và màu theo loại (import: xanh, export: đỏ, adjustment: cam)

5. **Bottom Sheet**:

- Padding: `24px`
- Background: Trắng
- Shadow: `blurRadius: 20, offset: (0, -5)`
- Row:
    - Button "Thêm vào giỏ": Expanded, height 56, background primary
    - Icon button cart: Background primary với opacity 0.1

---

### 6. Cart Screen (`cart_screen.dart`)

**Bố cục**: Scaffold với Column (ListView + Bottom Container)

- **Background**: `AppColors.background`

**Các thành phần**:

1. **AppBar**:

- Background: `AppColors.primary`
- Title: "Giỏ hàng", màu trắng
- Actions: Icon delete (xóa tất cả) nếu có items

2. **Empty State** (nếu giỏ trống):

- Icon: `Icons.shopping_cart_outlined`, size 80, màu `Colors.grey[300]`
- Text: "Giỏ hàng trống", font size 18, màu `Colors.grey[600]`
- Button: "Mua sắm ngay"

3. **Cart Items List**:

- Padding: `16px`
- Separator: `16px` height
- Item container:
    - Background: Trắng
    - Border radius: `16px`
    - Shadow: `blurRadius: 10, offset: (0, 4)`
    - Padding: `12px`
    - Row:
    - Image: `80x80`, border radius 12
    - Details: Expanded column
    - Quantity controls: Row với buttons +/-
    - Remove button: Icon delete, màu đỏ

4. **Bottom Container**:

- Background: Trắng
- Border radius: Top 24px
- Shadow: `blurRadius: 20, offset: (0, -5)`
- Padding: `20px`
- Total row: "Tổng tiền" + giá (font size 24, bold)
- Checkout button: Full width, height 56, background primary

---

### 7. Checkout Screen (`checkout_screen.dart`)

**Bố cục**: Scaffold với SingleChildScrollView

- **Background**: `AppColors.background`

**Các thành phần**:

1. **AppBar**:

- Background: `AppColors.primary`
- Title: "Thanh toán", màu trắng

2. **Form Sections**:

- **Thông tin liên hệ**:
    - TextFields: Border radius 12, prefix icons
    - Validation: Tên (min 2 ký tự), Email (phải có @), Phone (regex 0xxxxxxxxx)
- **Địa chỉ giao hàng**:
    - TextField: Max lines 3, border radius 12
    - Validation: Min 10 ký tự
- **Phương thức thanh toán**:
    - Dropdown: Border radius 12, options với icons
    - Options: COD (xanh), Bank transfer (xanh dương), E-wallet (tím), Credit card (cam)
- **Thông tin đơn hàng**:
    - Container trắng, border radius 12
    - List items: Image 50x50, tên, số lượng x giá, tổng
    - Summary: Tạm tính, Phí vận chuyển, Tổng cộng (font size 18, bold, màu primary)

3. **Submit Button**:

- Height: `56px`
- Background: `AppColors.primary`
- Text: "Đặt hàng", font size 18, bold

---

### 8. User Order History Screen (`user_order_history_screen.dart`)

**Bố cục**: Scaffold với ListView

- **Background**: `AppColors.background`

**Các thành phần**:

1. **AppBar**:

- Background: `AppColors.primary`
- Title: "Đơn hàng của tôi", màu trắng

2. **Order Cards**:

- Background: Trắng
- Border radius: `16px`
- Shadow: `blurRadius: 10, offset: (0, 4)`
- Padding: `16px`
- ExpansionTile:
    - Title: Order code + Status badge
    - Status badge: Màu theo trạng thái (pending: cam, confirmed: xanh dương, shipped: tím, delivered: xanh lá, cancelled: đỏ)
    - Subtitle: Ngày đặt + Tổng tiền (màu primary, bold)
    - Children: Danh sách sản phẩm, địa chỉ giao hàng
    - Button "Xác nhận đã nhận hàng" nếu status = shipped

---

### 9. Wishlist Screen (`wishlist_screen.dart`)

**Bố cục**: Scaffold với ListView

- **Background**: `AppColors.background`

**Các thành phần**:

1. **AppBar**:

- Background: `AppColors.primary`
- Title: "Danh sách yêu thích", màu trắng

2. **Wishlist Items**:

- Card: Border radius 16, margin bottom 16
- Row:
    - Image: `80x80`, border radius 12
    - Info: Expanded column (tên, giá)
    - Actions: Icon favorite (đỏ), Icon cart (primary)

3. **FloatingActionButton**: Tương tự các màn hình khác

---

### 10. User Profile Tab (`user_main_screen.dart` - UserProfileTab)

**Bố cục**: Scaffold với SingleChildScrollView

- **Background**: `AppColors.background`

**Các thành phần**:

1. **AppBar**:

- Background: `AppColors.primary`
- Title: "Hồ sơ", màu trắng
- Actions: Icon refresh

2. **Header Section** (Container trắng):

- Border radius: Bottom 30px
- Shadow: `blurRadius: 10, offset: (0, 5)`
- Padding: `bottom: 32, top: 16`
- Avatar: CircleAvatar radius 50, border 3px primary với opacity 0.2
- Name: Font size 24, bold
- Phone/Email/Address: Màu xám, font size 16/14

3. **Menu Items**:

- Container trắng, border radius 16, shadow
- ListTile:
    - Leading: Icon trong circle, màu theo loại
    - Title: Font size 16, weight 600
    - Trailing: Icon arrow forward, size 18, màu xám
- Items:
    - Lịch sử đơn hàng (xanh dương)
    - Sổ địa chỉ (teal)
    - Chỉnh sửa hồ sơ (cam)
    - Trợ giúp (tím)
    - Đăng xuất (đỏ, destructive)

---

### 11. Edit Profile Screen (`edit_profile_screen.dart`)

**Bố cục**: Scaffold với SingleChildScrollView

- **Background**: Trắng

**Các thành phần**:

1. **AppBar**:

- Background: `AppColors.primary`
- Title: "Chỉnh sửa hồ sơ", màu trắng

2. **Avatar Section**:

- Container tròn: `100x100`
- Border: 2px primary
- Background: Primary với opacity 0.1
- Text: Chữ cái đầu, font size 40, bold, màu primary

3. **Form Fields**:

- Section header: "Personal Information", font size 14, bold
- TextFields: Border radius 12, prefix icons
- Email: Read-only, background xám nhạt
- Validation: Username và Name bắt buộc

4. **Change Password Button**:

- OutlinedButton, border primary, height 50

5. **Save Button**:

- Full width, height 54
- Background: `AppColors.primary`
- Text: "Lưu thay đổi", font size 16, bold

---

### 12. User Address List Screen (`user_address_list_screen.dart`)

**Bố cục**: Scaffold với ListView

- **Background**: Mặc định

**Các thành phần**:

1. **AppBar**: Standard AppBar
2. **Address Cards**:

- Card: Elevation 2, border radius 12
- Padding: `16px`
- Content:
    - Row: Tên người nhận + Số điện thoại + Badge "Mặc định" (nếu có)
    - Badge: Background primary với opacity 0.1, border primary, text primary, font size 12, bold
    - Địa chỉ: Text địa chỉ
    - Actions: Button Sửa (icon edit), Button Xóa (icon delete, màu error)

3. **FloatingActionButton**:

- Background: `AppColors.primary`
- Icon: Add, màu trắng

---

### 13. Checkout Success Screen (`checkout_success_screen.dart`)

**Bố cục**: Scaffold với Column centered

- **Background**: Trắng

**Các thành phần**:

1. **Success Icon**:

- Container tròn: `120x120`
- Background: `Colors.green.shade50`
- Icon: `Icons.check_rounded`, size 80, màu `Colors.green.shade400`

2. **Text**:

- Title: "Đặt hàng thành công!", font size 24, bold
- Description: Font size 16, màu xám, height 1.5

3. **Buttons**:

- Primary: "Xem đơn hàng của tôi", background primary, height 56
- Secondary: "Tiếp tục mua sắm", text button, màu xám

---

## PHẦN 2: VIEWS CHO ADMIN

### 1. Admin Dashboard Screen (`admin_dashboard_screen.dart`)

**Bố cục**: Scaffold với IndexedStack + BottomNavigationBar

- **Background**: Mặc định

**Các thành phần**:

1. **Body**: IndexedStack với 5 screens:

- DashboardOverviewScreen (index 0)
- AdminProductListScreen (index 1)
- OrderListScreen (index 2)
- InventoryLogsScreen (index 3)
- AdminProfileTab (index 4)

2. **BottomNavigationBar**:

- Destinations:
    - Dashboard (icon: `Icons.dashboard`)
    - Products (icon: `Icons.inventory_2`)
    - Orders (icon: `Icons.receipt_long`)
    - Inventory (icon: `Icons.warehouse`)
    - Profile (icon: `Icons.person`)

---

### 2. Dashboard Overview Screen (`dashboard_overview_screen.dart`)

**Bố cục**: Scaffold với SingleChildScrollView

- **Background**: `AppColors.background`
- **Drawer**: `AdminDrawer`

**Các thành phần**:

1. **AppBar**:

- Background: `AppColors.primary`
- Title: "Tổng quan", màu trắng

2. **Summary Cards** (Row, 2x2):

- Card: Standard Material Card
- Padding: `16px`
- Icon: Size 32, màu theo loại
- Title: Font size 14, màu `Colors.grey[600]`
- Value: Font size 20, bold, màu theo icon
- Cards:
    - Tổng đơn hàng (xanh dương)
    - Tổng doanh thu (xanh lá)
    - Tổng sản phẩm (cam)
    - Tổng người dùng (tím)

3. **Revenue Chart Section**:

- Header: "Doanh thu (Tháng này)" + Button "Phân tích"
- Card: InkWell (clickable)
- Chart: Height 200, LineChart với màu primary

4. **Order Stats Chart Section**:

- Header: "Thống kê đơn hàng" + Button "Chi tiết"
- Card: InkWell
- Chart: Height 200, PieChart với màu theo status

5. **Top Products Section**:

- Title: "Sản phẩm bán chạy", font size 20, bold
- Card: ListView
- Items: CircleAvatar với số thứ tự, tên sản phẩm, số lượng đã bán, doanh thu

---

### 3. Admin Product List Screen (`admin_product_list_screen.dart`)

**Bố cục**: Scaffold với ListView

- **Drawer**: `AdminDrawer`

**Các thành phần**:

1. **AppBar**:

- Background: `AppColors.primary`
- Title: "Quản lý sản phẩm", màu trắng
- Actions:
    - Icon warning (sản phẩm sắp hết hàng)
    - Icon refresh
- Bottom: PreferredSize với TextField search
    - Height: 60
    - TextField: Border radius 10, background trắng

2. **Product List**:

- Padding: `8px`
- Separator: Divider
- Items: InkWell (clickable)
    - Row:
    - Image: `60x60`, border radius 8
    - Info: Expanded column (tên, số lượng kho)
    - Price: Màu primary, bold
    - Actions: Icon edit (xanh dương), Icon delete (đỏ)

3. **FloatingActionButton**:

- Icon: Add
- Background: Primary (mặc định)

---

### 4. Order List Screen (`order_list_screen.dart`)

**Bố cục**: Scaffold với ListView

- **Drawer**: `AdminDrawer`

**Các thành phần**:

1. **AppBar**:

- Background: `AppColors.primary`
- Title: "Quản lý đơn hàng", màu trắng
- Bottom: PreferredSize với search + filter
    - Height: 60
    - TextField: Border radius 30, background trắng
    - Filter button: Icon `Icons.filter_list`, background trắng

2. **Order Cards**:

- Card: Margin vertical 4, horizontal 8
- Padding: `12px`
- Content:
    - Row: Order code + Status badge
    - Text: Khách hàng, Ngày đặt
    - Text: Tổng tiền (màu primary, bold)
    - Actions: Button "Chi tiết", "Hủy" (nếu pending), "Duyệt" (nếu pending), "Giao hàng" (nếu confirmed/paid)

---

### 5. Inventory Logs Screen (`inventory_logs_screen.dart`)

**Bố cục**: Scaffold với ListView

- **Background**: `AppColors.background`

**Các thành phần**:

1. **AppBar**:

- Background: `AppColors.primary`
- Title: "Inventory Logs", màu trắng

2. **Log Items**:

- Container: Background trắng, border radius 12, shadow
- ListTile:
    - Leading: CircleAvatar với icon (màu theo loại)
    - Title: Product ID, bold
    - Subtitle: Loại log, số lượng thay đổi, ghi chú, ngày giờ
- Màu:
    - Import: Xanh lá (`Colors.green`)
    - Export: Đỏ (`Colors.red`)
    - Adjustment: Cam (`Colors.orange`)

---

### 6. Admin Profile Tab (`admin_dashboard_screen.dart` - AdminProfileTab)

**Bố cục**: Scaffold với Column centered

- **Background**: Mặc định

**Các thành phần**:

1. **Avatar**:

- CircleAvatar: Radius 50
- Icon: `Icons.admin_panel_settings`, size 50

2. **Text**:

- "System Administrator", font size 20, bold

3. **Logout Button**:

- ElevatedButton.icon
- Background: Đỏ
- Text: "Logout", màu trắng

---

### 7. Admin Drawer (`admin_drawer.dart`)

**Bố cục**: Drawer với Column**Các thành phần**:

1. **Header**:

- `UserAccountsDrawerHeader`
- Background: `AppColors.primary`
- Account name: "Admin Panel", font size 20, bold
- Account email: Email của admin
- Avatar: CircleAvatar trắng, icon `Icons.admin_panel_settings`, màu primary, size 40

2. **Menu Items**:

- ListTile với icon và title
- Icon color: `AppColors.primary`
- Items:
    - Tổng quan
    - Quản lý sản phẩm
    - Quản lý danh mục
    - Quản lý đơn hàng
    - Quản lý người dùng
    - Quản lý đánh giá
    - Quản lý thanh toán
    - Divider
    - Đăng xuất (màu đỏ)

---

## Tổng kết về Design Patterns

### Layout Patterns:

1. **User screens**: Chủ yếu dùng CustomScrollView với SliverAppBar cho hiệu ứng scroll
2. **Admin screens**: Dùng ListView/GridView đơn giản hơn
3. **Forms**: SingleChildScrollView với Form widget
4. **Navigation**: BottomNavigationBar cho admin, IndexedStack cho user main screen

### Color Usage:

- **Primary actions**: `AppColors.primary` (#F0768B - Hồng)
- **Success**: Xanh lá
- **Error/Destructive**: Đỏ
- **Warning**: Cam
- **Info**: Xanh dương
- **Neutral**: Xám các cấp độ

### Spacing:

- Padding phổ biến: 16px, 20px, 24px
- Border radius: 12px, 16px, 24px, 30px
- Icon sizes: 16px, 20px, 24px, 32px, 40px, 48px, 60px

### Typography:

- Headers: 18px-28px, bold
- Body: 14px-16px
- Small text: 12px-13px
- Large numbers: 20px-26px, bold/800

### Shadows:

- Light: `blurRadius: 5-10, offset: (0, 2-4)`