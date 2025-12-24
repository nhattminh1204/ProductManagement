# Tích hợp API với Flutter

## 📱 Hướng dẫn gọi API từ Flutter App

### 1. Cài đặt dependencies

Thêm vào `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.2
  provider: ^6.1.1
```

### 2. Tạo API Service

Tạo file `lib/services/api_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  
  // Lấy token từ SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  
  // Lưu token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  
  // Headers mặc định
  Map<String, String> _getHeaders({bool includeToken = false}) {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    return headers;
  }
  
  // Xử lý response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed: ${response.body}');
    }
  }
  
  // ==================== AUTH ====================
  
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _getHeaders(),
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      }),
    );
    return _handleResponse(response);
  }
  
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _getHeaders(),
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
    
    final result = _handleResponse(response);
    
    // Lưu token
    if (result['success'] && result['data']['token'] != null) {
      await _saveToken(result['data']['token']);
    }
    
    return result;
  }
  
  // ==================== CATEGORIES ====================
  
  Future<Map<String, dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: _getHeaders(),
    );
    return _handleResponse(response);
  }
  
  Future<Map<String, dynamic>> getActiveCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories/active'),
      headers: _getHeaders(),
    );
    return _handleResponse(response);
  }
  
  Future<Map<String, dynamic>> createCategory({
    required String name,
    String status = 'active',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: _getHeaders(),
      body: json.encode({
        'name': name,
        'status': status,
      }),
    );
    return _handleResponse(response);
  }
  
  // ==================== PRODUCTS ====================
  
  Future<Map<String, dynamic>> getProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: _getHeaders(),
    );
    return _handleResponse(response);
  }
  
  Future<Map<String, dynamic>> getActiveProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/active'),
      headers: _getHeaders(),
    );
    return _handleResponse(response);
  }
  
  Future<Map<String, dynamic>> getProductById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id'),
      headers: _getHeaders(),
    );
    return _handleResponse(response);
  }
  
  Future<Map<String, dynamic>> searchProducts(String keyword) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/search?keyword=$keyword'),
      headers: _getHeaders(),
    );
    return _handleResponse(response);
  }
  
  Future<Map<String, dynamic>> createProduct({
    required String name,
    required double price,
    required int quantity,
    required int categoryId,
    String? image,
    String status = 'active',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: _getHeaders(),
      body: json.encode({
        'name': name,
        'price': price,
        'quantity': quantity,
        'categoryId': categoryId,
        'image': image,
        'status': status,
      }),
    );
    return _handleResponse(response);
  }
  
  // ==================== ORDERS ====================
  
  Future<Map<String, dynamic>> createOrder({
    required String customerName,
    required String email,
    required String phone,
    required String address,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: _getHeaders(),
      body: json.encode({
        'customerName': customerName,
        'email': email,
        'phone': phone,
        'address': address,
        'paymentMethod': paymentMethod,
        'items': items,
      }),
    );
    return _handleResponse(response);
  }
  
  Future<Map<String, dynamic>> getOrdersByEmail(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/customer/$email'),
      headers: _getHeaders(),
    );
    return _handleResponse(response);
  }
  
  Future<Map<String, dynamic>> getOrderByCode(String orderCode) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/code/$orderCode'),
      headers: _getHeaders(),
    );
    return _handleResponse(response);
  }
  
  // ==================== RATINGS ====================
  
  Future<Map<String, dynamic>> createRating({
    required int productId,
    required int userId,
    required int rating,
    String? comment,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ratings'),
      headers: _getHeaders(),
      body: json.encode({
        'productId': productId,
        'userId': userId,
        'rating': rating,
        'comment': comment,
      }),
    );
    return _handleResponse(response);
  }
  
  Future<Map<String, dynamic>> getRatingsByProduct(int productId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/ratings/product/$productId'),
      headers: _getHeaders(),
    );
    return _handleResponse(response);
  }
}
```

### 3. Tạo Models

Tạo file `lib/models/product.dart`:

```dart
class Product {
  final int id;
  final String name;
  final String? image;
  final double price;
  final int quantity;
  final String status;
  final int categoryId;
  final String categoryName;
  final double? averageRating;
  final int? totalRatings;

  Product({
    required this.id,
    required this.name,
    this.image,
    required this.price,
    required this.quantity,
    required this.status,
    required this.categoryId,
    required this.categoryName,
    this.averageRating,
    this.totalRatings,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      status: json['status'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      averageRating: json['averageRating']?.toDouble(),
      totalRatings: json['totalRatings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'status': status,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
    };
  }
}
```

### 4. Sử dụng trong Widget

Tạo file `lib/screens/products_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await _apiService.getActiveProducts();
      
      if (response['success']) {
        final List<dynamic> data = response['data'];
        setState(() {
          _products = data.map((json) => Product.fromJson(json)).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  leading: product.image != null
                      ? Image.network(product.image!, width: 50, height: 50)
                      : Icon(Icons.image),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price}'),
                  trailing: Text('Stock: ${product.quantity}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadProducts,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
```

### 5. Ví dụ Login Screen

```dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _apiService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (response['success']) {
        // Navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter email' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter password' : null,
              ),
              SizedBox(height: 24),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 6. Ví dụ tạo đơn hàng

```dart
Future<void> createOrder() async {
  final apiService = ApiService();
  
  try {
    final response = await apiService.createOrder(
      customerName: 'Nguyen Van A',
      email: 'customer@example.com',
      phone: '0123456789',
      address: '123 Main St, Hanoi',
      paymentMethod: 'cash',
      items: [
        {'productId': 1, 'quantity': 2},
        {'productId': 2, 'quantity': 1},
      ],
    );
    
    if (response['success']) {
      print('Order created: ${response['data']['orderCode']}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
```

## 🔧 Cấu hình cho Android

Thêm vào `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>

<application
    android:usesCleartextTraffic="true"
    ...>
```

## 🔧 Cấu hình cho iOS

Thêm vào `ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## 📝 Lưu ý

1. **Localhost trên Android Emulator**: Sử dụng `10.0.2.2` thay vì `localhost`
2. **Localhost trên iOS Simulator**: Sử dụng `localhost` hoặc IP máy
3. **Production**: Thay đổi `baseUrl` thành URL server thực

```dart
// Development
static const String baseUrl = 'http://10.0.2.2:8080/api'; // Android
static const String baseUrl = 'http://localhost:8080/api'; // iOS

// Production
static const String baseUrl = 'https://your-domain.com/api';
```

## 🎯 Best Practices

1. **Error Handling**: Luôn wrap API calls trong try-catch
2. **Loading States**: Hiển thị loading indicator
3. **Token Management**: Lưu và gửi JWT token
4. **Offline Support**: Cache dữ liệu với SharedPreferences
5. **State Management**: Sử dụng Provider, Bloc, hoặc Riverpod

Chúc bạn thành công! 🚀
