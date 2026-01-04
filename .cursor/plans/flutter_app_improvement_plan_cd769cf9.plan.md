---
name: Flutter App Improvement Plan
overview: "Kế hoạch cải thiện toàn diện ứng dụng Flutter Product Management, bao gồm: hoàn thiện chức năng thiếu, cải thiện UI/UX đạt chuẩn doanh nghiệp, tối ưu code và performance, và bổ sung các tính năng cần thiết."
todos: []
---

# Kế hoạch

cải thiện ứng dụng Flutter Product Management

## Tổng quan

Ứng dụng hiện tại có kiến trúc Clean Architecture tốt nhưng còn nhiều điểm cần cải thiện về chức năng, UI/UX, và chất lượng code.

## Phân tích hiện trạng

### Điểm mạnh

- Clean Architecture (domain/data/presentation)
- Provider state management
- Cấu trúc code rõ ràng
- Material Design 3

### Vấn đề cần cải thiện

#### 1. Authentication & Security

- ❌ Không lưu token (mất khi đóng app)
- ❌ Xác định role dựa trên email string thay vì JWT
- ❌ Không có auto-login
- ❌ Không có token refresh
- ❌ Hardcoded API URL

#### 2. Chức năng thiếu/chưa hoàn thiện

- ❌ Cart Screen: chỉ placeholder
- ❌ Checkout Screen: chỉ placeholder
- ❌ Product Detail Screen: chưa có
- ❌ User Order History: chưa có
- ❌ Category CRUD: chỉ xem, không có thêm/sửa/xóa
- ❌ Dashboard: chỉ text placeholder
- ❌ User Profile: chỉ logout button
- ❌ Image upload/picker: chưa có
- ❌ Search filters: chưa có
- ❌ Product sorting: chưa có

#### 3. UI/UX

- ⚠️ Giao diện cơ bản, chưa đạt chuẩn doanh nghiệp
- ⚠️ Thiếu loading states cho images
- ⚠️ Thiếu error handling UI
- ⚠️ Thiếu empty states
- ⚠️ Không có pull-to-refresh
- ⚠️ Không có pagination
- ⚠️ Product cards đơn giản
- ⚠️ Thiếu animations/transitions

#### 4. Code Quality

- ⚠️ Error handling chưa đồng nhất
- ⚠️ Không có offline support
- ⚠️ Không có logging
- ⚠️ Không có environment config
- ⚠️ Re-fetch toàn bộ data mỗi lần

#### 5. Performance

- ⚠️ Không có image caching
- ⚠️ Không có data caching
- ⚠️ Search không có debouncing

## Kế hoạch cải thiện chi tiết

### Phase 1: Authentication & Security (Ưu tiên cao)

#### 1.1 Token Persistence

- **File**: `lib/core/storage/local_storage.dart` (mới)
- **File**: `lib/product_management/presentation/providers/auth_provider.dart`
- **Thực hiện**:
- Thêm `flutter_secure_storage` vào pubspec.yaml
- Tạo LocalStorage service để lưu token, user info
- Load token khi app khởi động
- Auto-login nếu token hợp lệ

#### 1.2 JWT Token Parsing

- **File**: `lib/core/utils/jwt_parser.dart` (mới)
- **File**: `lib/product_management/presentation/providers/auth_provider.dart`
- **Thực hiện**:
- Parse role từ JWT token thay vì email string
- Parse user ID, email từ token
- Validate token expiration

#### 1.3 Environment Configuration

- **File**: `lib/core/config/app_config.dart` (mới)
- **File**: `lib/api/api_service.dart`
- **Thực hiện**:
- Tạo config cho dev/staging/prod
- Di chuyển API URL vào config
- Thêm `flutter_dotenv` package

### Phase 2: Hoàn thiện chức năng cốt lõi (Ưu tiên cao)

#### 2.1 Cart Screen Implementation

- **File**: `lib/product_management/presentation/screens/cart_screen.dart`
- **Thực hiện**:
- Hiển thị danh sách items trong cart
- Cho phép update quantity
- Cho phép remove items
- Hiển thị total amount
- Button "Checkout" navigate đến checkout screen
- Empty state khi cart trống
- Cart persistence (lưu vào local storage)

#### 2.2 Checkout Screen Implementation

- **File**: `lib/product_management/presentation/screens/checkout_screen.dart`
- **File**: `lib/product_management/presentation/providers/order_provider.dart`
- **File**: `lib/api/api_service.dart`
- **Thực hiện**:
- Form nhập thông tin khách hàng (name, phone, address)
- Hiển thị order summary
- Tạo order API call
- Success/error handling
- Navigate về order history sau khi thành công

#### 2.3 Product Detail Screen

- **File**: `lib/product_management/presentation/screens/product_detail_screen.dart` (mới)
- **Thực hiện**:
- Hiển thị full product info
- Image gallery với zoom
- Quantity selector
- Add to cart button
- Related products (optional)

#### 2.4 User Order History

- **File**: `lib/product_management/presentation/screens/user_order_history_screen.dart` (mới)
- **File**: `lib/api/api_service.dart`
- **Thực hiện**:
- API endpoint để lấy orders của user hiện tại
- List view với order status
- Order detail view
- Filter by status

#### 2.5 Dashboard Implementation

- **File**: `lib/product_management/presentation/screens/admin_dashboard_screen.dart`
- **Thực hiện**:
- Statistics cards (total products, orders, revenue)
- Charts (recent orders, sales trend)
- Quick actions
- Recent activities

### Phase 3: Category Management (Ưu tiên trung bình)

#### 3.1 Category CRUD

- **File**: `lib/product_management/presentation/screens/category_list_screen.dart`
- **File**: `lib/product_management/presentation/screens/category_form_screen.dart` (mới)
- **File**: `lib/api/api_service.dart`
- **File**: `lib/product_management/presentation/providers/category_provider.dart`
- **Thực hiện**:
- Create category
- Update category
- Delete category (với validation)
- Toggle active/inactive status

### Phase 4: UI/UX Enterprise Level (Ưu tiên cao)

#### 4.1 Design System Enhancement

- **File**: `lib/product_management/presentation/design_system.dart`
- **Thực hiện**:
- Mở rộng color palette
- Typography system (text styles)
- Spacing system
- Component library (buttons, cards, inputs)
- Dark mode support

#### 4.2 Product Cards Redesign

- **File**: `lib/product_management/presentation/widgets/product_card_admin.dart`
- **File**: `lib/product_management/presentation/widgets/product_card_user.dart`
- **Thực hiện**:
- Modern card design với shadows, rounded corners
- Image placeholder với shimmer loading
- Badge cho status/discount
- Better typography
- Hover/press animations

#### 4.3 Loading States

- **File**: `lib/product_management/presentation/widgets/shimmer_loading.dart` (mới)
- **Thực hiện**:
- Shimmer effect cho product cards
- Skeleton screens
- Progress indicators

#### 4.4 Error Handling UI

- **File**: `lib/product_management/presentation/widgets/error_widget.dart` (mới)
- **Thực hiện**:
- Error state với retry button
- Empty state illustrations
- Network error handling
- User-friendly error messages

#### 4.5 Animations & Transitions

- **Thực hiện**:
- Page transitions
- List animations
- Button press feedback
- Loading animations

#### 4.6 Pull to Refresh

- **File**: Các list screens
- **Thực hiện**:
- Thêm RefreshIndicator vào ListView/GridView

### Phase 5: Search & Filters (Ưu tiên trung bình)

#### 5.1 Advanced Search

- **File**: `lib/product_management/presentation/screens/user_product_list_screen.dart`
- **File**: `lib/product_management/presentation/screens/admin_product_list_screen.dart`
- **Thực hiện**:
- Search với debouncing
- Filter by category
- Filter by price range
- Sort options (price, name, date)

### Phase 6: Image Management (Ưu tiên trung bình)

#### 6.1 Image Picker & Upload

- **File**: `lib/core/services/image_service.dart` (mới)
- **File**: `lib/product_management/presentation/screens/product_form_screen.dart`
- **Thực hiện**:
- Image picker từ gallery/camera
- Image upload API
- Image preview
- Image compression

#### 6.2 Image Caching

- **Thực hiện**:
- Thêm `cached_network_image` package
- Replace Image.network với CachedNetworkImage

### Phase 7: Performance Optimization (Ưu tiên trung bình)

#### 7.1 Data Caching

- **File**: `lib/core/cache/cache_manager.dart` (mới)
- **Thực hiện**:
- Cache products, categories
- Cache invalidation strategy
- Offline data support

#### 7.2 Search Debouncing

- **File**: `lib/core/utils/debouncer.dart` (mới)
- **File**: Các search screens
- **Thực hiện**:
- Debounce search input (300ms)

#### 7.3 Pagination

- **File**: `lib/api/api_service.dart`
- **File**: Các list providers
- **Thực hiện**:
- Infinite scroll pagination
- Load more functionality

### Phase 8: User Profile & Settings (Ưu tiên thấp)

#### 8.1 User Profile

- **File**: `lib/product_management/presentation/screens/user_profile_screen.dart` (mới)
- **Thực hiện**:
- Hiển thị user info
- Edit profile
- Change password
- Logout

#### 8.2 Settings

- **File**: `lib/product_management/presentation/screens/settings_screen.dart` (mới)
- **Thực hiện**:
- Theme toggle (light/dark)
- Language selection
- Notifications settings

### Phase 9: Code Quality & Best Practices (Ưu tiên cao)

#### 9.1 Error Handling Strategy

- **File**: `lib/core/error/failures.dart` (mới)
- **File**: `lib/core/error/error_handler.dart` (mới)
- **Thực hiện**:
- Centralized error handling
- Custom exceptions
- Error mapping

#### 9.2 Logging

- **File**: `lib/core/utils/logger.dart` (mới)
- **Thực hiện**:
- Thêm `logger` package
- Logging cho debug/production

#### 9.3 Constants & Strings

- **File**: `lib/core/constants/app_strings.dart` (mới)
- **File**: `lib/core/constants/app_constants.dart` (mới)
- **Thực hiện**:
- Extract hardcoded strings
- App constants

#### 9.4 Validation

- **File**: `lib/core/utils/validators.dart` (mới)
- **Thực hiện**:
- Email validation
- Password validation
- Form validators

### Phase 10: Testing (Ưu tiên trung bình)

#### 10.1 Unit Tests

- **File**: Test files cho providers, use cases
- **Thực hiện**:
- Provider tests
- Use case tests
- Utility function tests

#### 10.2 Widget Tests

- **File**: Test files cho widgets
- **Thực hiện**:
- Widget tests cho key components

## Dependencies cần thêm

```yaml
dependencies:
  # Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.2
  
  # Environment
  flutter_dotenv: ^5.1.0
  
  # Image
  image_picker: ^1.0.7
  cached_network_image: ^3.3.1
  
  # JWT
  jwt_decoder: ^2.0.1
  
  # Utils
  intl: ^0.20.2 (đã có)
  
  # Logging
  logger: ^2.0.2+1
  
  # State management (đã có provider)
  
dev_dependencies:
  # Testing
  mockito: ^5.4.4
  build_runner: ^2.4.7
```



## Thứ tự ưu tiên thực hiện

1. **Phase 1**: Authentication & Security (Critical)
2. **Phase 2**: Hoàn thiện chức năng cốt lõi (Critical)
3. **Phase 4**: UI/UX Enterprise Level (High priority)
4. **Phase 9**: Code Quality (High priority)
5. **Phase 3, 5, 6, 7**: Features & Optimization (Medium priority)
6. **Phase 8, 10**: Nice to have (Low priority)

## Metrics để đánh giá

- Code coverage > 60%
- App startup time < 2s