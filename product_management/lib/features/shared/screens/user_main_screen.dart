import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
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
import 'package:product_management/product_management/presentation/design_system.dart';
import '../../../api/api_service.dart';
import '../../users/data/models/user_model.dart';
import '../widgets/floating_dock.dart';
import 'package:google_fonts/google_fonts.dart';


class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _currentIndex = 0;
  final List<GlobalKey> _dockKeys = List.generate(4, (index) => GlobalKey());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      UserHomeScreen(
        cartKey: _dockKeys[1],
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
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
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      extendBody: true, // Allow body to extend behind the dock
      drawer: AppDrawer(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                return FadeThroughTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(_currentIndex),
                child: _buildScreens()[_currentIndex],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FloatingDock(
              currentIndex: _currentIndex,
              onItemSelected: (index) {
                setState(() => _currentIndex = index);
              },
              icons: const [
                Icons.home_rounded,
                Icons.shopping_cart_rounded,
                Icons.favorite_rounded,
                Icons.person_rounded,
              ],
              labels: const ['Home', 'Cart', 'Likes', 'Profile'],
              itemKeys: _dockKeys,
            ),
          ),
        ],
      ),
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
      try {
        final user = await ApiService().getUserById(authProvider.userId!);
        if (mounted) {
          setState(() => _user = user);
        }
      } catch (e) {
        debugPrint('Error fetching profile: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern App Bar with Blur Effect
          SliverAppBar(
            pinned: true,
            expandedHeight: 280, // Taller header
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, Color(0xFF6366F1)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40), // Top spacing
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: authProvider.userEmail != null
                            ? NetworkImage(
                                'https://ui-avatars.com/api/?name=${_user?.name ?? authProvider.userEmail}&background=F0768B&color=fff',
                              )
                            : null,
                        child: authProvider.userEmail == null
                            ? const Icon(Icons.person, size: 50, color: AppColors.textLight)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _user?.name ?? authProvider.userEmail ?? 'Khách hàng',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_user?.phone != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _user!.phone!,
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            actions: [
               IconButton(
                 icon: const Icon(Icons.refresh, color: Colors.white),
                 onPressed: _fetchProfile,
               ),
            ],
          ),

          // Bento Grid Menu
          SliverToBoxAdapter(
             child: Padding(
               padding: const EdgeInsets.all(20),
               child: Column(
                 children: [
                   // Row 1: Profile & Address
                   Row(
                     children: [
                       Expanded(
                         child: _buildBentoItem(
                           icon: Icons.person_outline_rounded,
                           title: 'Hồ sơ',
                           subtitle: 'Chỉnh sửa',
                           color: const Color(0xFFF59E0B),
                           onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                              );
                              _fetchProfile();
                           },
                         ),
                       ),
                       const SizedBox(width: 16),
                       Expanded(
                         child: _buildBentoItem(
                           icon: Icons.location_on_rounded,
                           title: 'Địa chỉ',
                           subtitle: 'Quản lý',
                           color: const Color(0xFF10B981),
                           onTap: () => Navigator.push(
                             context,
                             MaterialPageRoute(builder: (_) => const UserAddressListScreen()),
                           ),
                         ),
                       ),
                     ],
                   ),
                   const SizedBox(height: 16),

                   // Row 2: History & Help
                   Row(
                     children: [
                       Expanded(
                         child: _buildBentoItem(
                           icon: Icons.history_rounded,
                           title: 'Lịch sử', // Shortened title for better fit
                           subtitle: 'Đơn hàng',
                           color: const Color(0xFF3B82F6),
                           onTap: () => Navigator.push(
                             context,
                             MaterialPageRoute(builder: (_) => const UserOrderHistoryScreen()),
                           ),
                         ),
                       ),
                       const SizedBox(width: 16),
                       Expanded(
                         child: _buildBentoItem(
                           icon: Icons.help_outline_rounded,
                           title: 'Hỗ trợ',
                           subtitle: 'Trung tâm',
                           color: const Color(0xFF8B5CF6),
                           onTap: () {},
                         ),
                       ),
                     ],
                   ),
                   
                   const SizedBox(height: 32),

                   // Small Logout Button
                   Center(
                     child: TextButton.icon(
                       onPressed: () {
                         context.read<AuthProvider>().logout();
                         Navigator.of(context).pushAndRemoveUntil(
                           MaterialPageRoute(builder: (_) => const LoginScreen()),
                           (route) => false,
                         );
                       },
                       icon: const Icon(Icons.logout_rounded, size: 20),
                       label: Text(
                         'Đăng xuất',
                         style: GoogleFonts.inter(
                           fontWeight: FontWeight.w600,
                           fontSize: 14,
                         ),
                       ),
                       style: TextButton.styleFrom(
                         foregroundColor: AppColors.error,
                         backgroundColor: AppColors.error.withValues(alpha: 0.1),
                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(30),
                         ),
                       ),
                     ),
                   ),

                   const SizedBox(height: 100), // Space for FloatingDock
                 ],
               ),
             ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isLarge = false,
    bool isDark = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isLarge ? 140 : 160,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? color : Colors.white,
          borderRadius: BorderRadius.circular(24), // Squircle
          boxShadow: AppShadows.ambientShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.2) : color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDark ? Colors.white : color,
                size: 24,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: isDark ? Colors.white.withValues(alpha: 0.8) : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
