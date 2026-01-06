import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import 'package:provider/provider.dart';
import '../../products/presentation/screens/user_product_list_screen.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../auth/presentation/screens/login_screen.dart';
import '../../orders/presentation/screens/user_order_history_screen.dart';
import '../../payments/presentation/screens/payment_history_screen.dart';

class AppDrawer extends StatelessWidget {
  final int? currentIndex;
  final Function(int)? onItemSelected;

  const AppDrawer({super.key, this.currentIndex, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Drawer(
      backgroundColor: AppColors.surface,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Custom Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF6366F1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: authProvider.userEmail != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://ui-avatars.com/api/?name=${authProvider.userEmail}&background=fff&color=4F46E5',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.person, color: AppColors.primary),
                            ),
                          )
                        : const Icon(Icons.person, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.isAdmin ? 'Quản trị viên' : 'Khách hàng',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authProvider.userEmail ?? 'Chưa đăng nhập',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                _buildSectionHeader('MENU'),
                _buildDrawerItem(
                  context,
                  icon: Icons.home_rounded,
                  title: 'Trang chủ',
                  isActive: currentIndex == 0,
                  onTap: () {
                    Navigator.pop(context);
                    if (onItemSelected != null) onItemSelected!(0);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.inventory_2_rounded,
                  title: 'Sản phẩm',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserProductListScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.shopping_cart_rounded,
                  title: 'Giỏ hàng',
                  isActive: currentIndex == 1,
                  onTap: () {
                    Navigator.pop(context);
                    if (onItemSelected != null) onItemSelected!(1);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.favorite_rounded,
                  title: 'Yêu thích',
                  isActive: currentIndex == 2,
                  onTap: () {
                    Navigator.pop(context);
                    if (onItemSelected != null) onItemSelected!(2);
                  },
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('TÀI KHOẢN'),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_rounded,
                  title: 'Hồ sơ cá nhân',
                  isActive: currentIndex == 3,
                  onTap: () {
                    Navigator.pop(context);
                    if (onItemSelected != null) onItemSelected!(3);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.history_rounded,
                  title: 'Lịch sử đơn hàng',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserOrderHistoryScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.payment_rounded,
                  title: 'Lịch sử thanh toán',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PaymentHistoryScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            ),
            child: _buildDrawerItem(
              context,
              icon: Icons.logout_rounded,
              title: 'Đăng xuất',
              onTap: () {
                Navigator.pop(context);
                context.read<AuthProvider>().logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              isDanger: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: AppColors.textLight,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isActive = false,
    bool isDanger = false,
  }) {
    final color = isDanger
        ? AppColors.error
        : (isActive ? AppColors.primary : AppColors.textMain);
    final bgColor = isActive
        ? AppColors.primary.withValues(alpha: 0.08)
        : Colors.transparent;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          color: isDanger
              ? AppColors.error
              : (isActive ? AppColors.primary : AppColors.textSecondary),
          size: 22,
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: color,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        trailing: isActive
            ? Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }
}

