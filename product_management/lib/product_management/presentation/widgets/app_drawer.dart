import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/orders/presentation/screens/user_order_history_screen.dart';
import '../../../features/products/presentation/screens/user_product_list_screen.dart';
import '../design_system.dart';

class AppDrawer extends StatelessWidget {
  final int? currentIndex;
  final Function(int)? onItemSelected;

  const AppDrawer({
    super.key,
    this.currentIndex,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            accountName: Text(
              authProvider.isAdmin ? 'Administrator' : 'Customer',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              authProvider.userEmail ?? 'No email',
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context: context,
                  icon: Icons.home_outlined,
                  title: 'Home',
                  index: 0,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.shopping_bag_outlined,
                  title: 'Cart',
                  index: 1,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.grid_view_rounded,
                  title: 'Products',
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    // If we want to reset filters, pass no args
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserProductListScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.person_outline_rounded,
                  title: 'Profile',
                  index: 2,
                ),
                const Divider(),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.history_rounded,
                  title: 'Order History',
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserOrderHistoryScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.logout_rounded,
                  title: 'Sign Out',
                  onTap: () {
                    Navigator.pop(context); // Close drawer
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
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    int? index,
    VoidCallback? onTap,
  }) {
    final isSelected = currentIndex != null && index != null && currentIndex == index;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : Colors.black87,
        ),
      ),
      selected: isSelected,
      onTap: onTap ?? () {
        Navigator.pop(context); // Close drawer
        if (onItemSelected != null && index != null) {
          onItemSelected!(index);
        }
      },
    );
  }
}

