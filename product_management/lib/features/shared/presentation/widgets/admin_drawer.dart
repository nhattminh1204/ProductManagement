import 'package:flutter/material.dart';
import 'package:product_management/features/shared/design_system.dart';
import 'package:product_management/features/dashboard/presentation/screens/dashboard_overview_screen.dart';
import 'package:product_management/features/products/presentation/screens/admin_product_list_screen.dart';
import 'package:product_management/features/orders/presentation/screens/order_list_screen.dart';
import 'package:product_management/features/users/presentation/screens/user_management_screen.dart';
import 'package:product_management/features/categories/presentation/screens/category_management_screen.dart';
import '../../../../features/ratings/presentation/screens/admin_rating_management_screen.dart';
import '../../../../features/payments/presentation/screens/admin_payment_management_screen.dart';
import 'package:product_management/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:product_management/features/auth/presentation/screens/login_screen.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch AuthProvider to update email/avatar if it changes
    final authProvider = context.watch<AuthProvider>();

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            accountName: const Text(
              'Admin Panel',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            accountEmail: Text(
              authProvider.userEmail ?? '',
              style: const TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.admin_panel_settings,
                size: 40,
                color: AppColors.primary,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'Tổng quan',
                  onTap: () =>
                      _navigate(context, const DashboardOverviewScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.inventory_2,
                  title: 'Quản lý sản phẩm',
                  onTap: () =>
                      _navigate(context, const AdminProductListScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.category,
                  title: 'Quản lý danh mục',
                  onTap: () =>
                      _navigate(context, const CategoryManagementScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.shopping_cart,
                  title: 'Quản lý đơn hàng',
                  onTap: () => _navigate(context, const OrderListScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.people,
                  title: 'Quản lý người dùng',
                  onTap: () => _navigate(context, const UserManagementScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.star_rate,
                  title: 'Quản lý đánh giá',
                  onTap: () =>
                      _navigate(context, const AdminRatingManagementScreen()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.payment,
                  title: 'Quản lý thanh toán',
                  onTap: () =>
                      _navigate(context, const AdminPaymentManagementScreen()),
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout,
                  title: 'Đăng xuất',
                  onTap: () async {
                    await context.read<AuthProvider>().logout();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  },
                  textColor: Colors.red,
                  iconColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primary),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close drawer
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
