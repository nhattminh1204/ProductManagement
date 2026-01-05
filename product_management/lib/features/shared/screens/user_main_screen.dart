import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../products/presentation/providers/product_provider.dart';
import '../../orders/presentation/providers/cart_provider.dart';
import '../../products/presentation/screens/user_home_screen.dart';
import '../../orders/presentation/screens/cart_screen.dart';
import '../../orders/presentation/screens/user_order_history_screen.dart';
import '../../auth/presentation/screens/login_screen.dart';
import '../../users/presentation/screens/edit_profile_screen.dart';
import '../../wishlist/presentation/screens/wishlist_screen.dart';
import '../../addresses/presentation/screens/user_address_list_screen.dart';
import '../widgets/app_drawer.dart';
import '../design_system.dart';
import '../../../api/api_service.dart';
import '../../users/data/models/user_model.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load cart from storage after products are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cartProvider = context.read<CartProvider>();
      final productProvider = context.read<ProductProvider>();

      // Ensure products are loaded first
      if (productProvider.products.isEmpty) {
        await productProvider.fetchActiveProducts();
      }

      // Load cart from storage
      if (productProvider.products.isNotEmpty) {
        await cartProvider.loadCart(productProvider.products);
      }
    });
  }

  List<Widget> _buildScreens() {
    return [
      const UserHomeScreen(),
      CartScreen(
        onGoShopping: () {
          setState(() {
            _currentIndex = 0; // Go to Home tab
          });
        },
      ),
      WishlistScreen(
        onGoHome: () {
          setState(() {
            _currentIndex = 0; // Go to Home tab
          });
        },
      ),
      const UserProfileTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: AppDrawer(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: IndexedStack(index: _currentIndex, children: _buildScreens()),
    );
  }
}

class UserProfileTab extends StatefulWidget {
  const UserProfileTab({super.key});

  @override
  State<UserProfileTab> createState() => _UserProfileTabState();
}

class _UserProfileTabState extends State<UserProfileTab> {
  UserModel? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProfile();
    });
  }

  Future<void> _fetchProfile() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.userId != null) {
      setState(() => _isLoading = true);
      try {
        final user = await ApiService().getUserById(authProvider.userId!);
        if (mounted) {
          setState(() => _user = user);
        }
      } catch (e) {
        debugPrint('Error fetching profile: $e');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchProfile,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header Section containing Profile Info as requested
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 32, top: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[100],
                        backgroundImage: authProvider.userEmail != null
                            ? NetworkImage(
                                'https://ui-avatars.com/api/?name=${_user?.name ?? authProvider.userEmail}&background=F0768B&color=fff',
                              )
                            : null,
                        child: authProvider.userEmail == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoading && _user == null)
                      const CircularProgressIndicator()
                    else ...[
                      Text(
                        _user?.name ?? authProvider.userEmail ?? 'Khách hàng',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Display extra info here as requested
                      if (_user?.phone != null && _user!.phone!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.phone, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                _user!.phone!,
                                style: TextStyle(color: Colors.grey[600], fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      if (_user?.email != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            _user!.email,
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ),
                      if (_user?.address != null && _user!.address!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            _user!.address!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[500], fontSize: 14),
                          ),
                        ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Menu Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                      _buildProfileItem(
                        icon: Icons.history_rounded,
                        color: Colors.blue,
                        title: 'Lịch sử đơn hàng',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UserOrderHistoryScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildProfileItem(
                        icon: Icons.location_on_rounded,
                        color: Colors.teal,
                        title: 'Sổ địa chỉ',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UserAddressListScreen(),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 16),
                    _buildProfileItem(
                      icon: Icons.edit_rounded,
                      color: Colors.orange,
                      title: 'Chỉnh sửa hồ sơ',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                        _fetchProfile(); // Refresh after edit
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildProfileItem(
                      icon: Icons.help_outline_rounded,
                      color: Colors.purple,
                      title: 'Trợ giúp & Hỗ trợ',
                      onTap: () {},
                    ),
                    const SizedBox(height: 32),
                    _buildProfileItem(
                      icon: Icons.logout_rounded,
                      color: AppColors.error,
                      title: 'Đăng xuất',
                      isDestructive: true,
                      onTap: () {
                        context.read<AuthProvider>().logout();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDestructive ? AppColors.error : AppColors.textMain,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
