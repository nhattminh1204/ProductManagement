import 'package:flutter/material.dart';
import 'package:product_management/product_management/presentation/design_system.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Manage notification preferences'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement notifications settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('Change app language'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement language settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Theme'),
            subtitle: const Text('Light / Dark mode'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement theme settings
            },
          ),
        ],
      ),
    );
  }
}
