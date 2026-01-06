import 'package:flutter/material.dart';
import 'package:product_management/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import 'package:product_management/features/categories/presentation/screens/category_management_screen.dart';
import '../../../../features/ratings/presentation/screens/admin_rating_management_screen.dart';
import '../../../../features/payments/presentation/screens/admin_payment_management_screen.dart';
import 'package:product_management/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:product_management/features/auth/presentation/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../screens/admin_main_screen.dart';

class AdminDrawer extends StatelessWidget {
  final String currentScreen;
  const AdminDrawer({super.key, this.currentScreen = 'dashboard'});

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
          // Header Section
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
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primary,
                        Color(0xFF6366F1),
                      ], // Indigo Gradient
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
                  child: const Center(
                    child: Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin Panel',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authProvider.userEmail ?? 'admin@example.com',
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
                _buildSectionHeader('DASHBOARD'),
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard_rounded,
                  title: 'Overview',
                  onTap: () =>
                      _navigate(context, const AdminMainScreen(initialIndex: 0)),
                  isActive: currentScreen == 'dashboard',
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('MANAGEMENT'),
                _buildDrawerItem(
                  context,
                  icon: Icons.inventory_2_rounded,
                  title: 'Products',
                  onTap: () =>
                      _navigate(context, const AdminMainScreen(initialIndex: 1)),
                  isActive: currentScreen == 'products',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.category_rounded,
                  title: 'Categories',
                  onTap: () =>
                      _navigate(context, const CategoryManagementScreen()),
                  isActive: currentScreen == 'categories',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.shopping_bag_rounded,
                  title: 'Orders',
                  onTap: () => _navigate(context, const AdminMainScreen(initialIndex: 2)),
                  isActive: currentScreen == 'orders',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.people_rounded,
                  title: 'Users',
                  onTap: () => _navigate(context, const AdminMainScreen(initialIndex: 3)),
                  isActive: currentScreen == 'users',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.star_rounded,
                  title: 'Ratings',
                  onTap: () =>
                      _navigate(context, const AdminRatingManagementScreen()),
                  isActive: currentScreen == 'ratings',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.payments_rounded,
                  title: 'Payments',
                  onTap: () =>
                      _navigate(context, const AdminPaymentManagementScreen()),
                  isActive: currentScreen == 'payments',
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
              title: 'Log Out',
              onTap: () async {
                await context.read<AuthProvider>().logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              textColor: AppColors.error,
              iconColor: AppColors.error,
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
    Color? textColor,
    Color? iconColor,
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

  void _navigate(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close drawer
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
