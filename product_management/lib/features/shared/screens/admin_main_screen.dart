import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:product_management/features/dashboard/presentation/screens/dashboard_overview_screen.dart';
import 'package:product_management/features/products/presentation/screens/admin_product_list_screen.dart';
import 'package:product_management/features/orders/presentation/screens/order_list_screen.dart';
import 'package:product_management/features/users/presentation/screens/user_management_screen.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import '../widgets/floating_dock.dart';
import '../presentation/widgets/admin_drawer.dart';


class AdminMainScreen extends StatefulWidget {
  final int initialIndex;
  const AdminMainScreen({super.key, this.initialIndex = 0});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  late int _currentIndex;
  int _previousIndex = 0;
  final List<GlobalKey> _dockKeys = List.generate(4, (index) => GlobalKey());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _previousIndex = widget.initialIndex;
  }

  List<Widget> _buildScreens() {
    return [
      DashboardOverviewScreen(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      AdminProductListScreen(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      OrderListScreen(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      UserManagementScreen(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      extendBody: true,
      drawer: AdminDrawer(
        currentScreen: _getCurrentScreenName(),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 300),
              reverse: _currentIndex < _previousIndex,
              transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                return SharedAxisTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
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
                setState(() {
                  _previousIndex = _currentIndex;
                  _currentIndex = index;
                });
              },
              icons: const [
                Icons.dashboard_rounded,
                Icons.inventory_2_rounded,
                Icons.shopping_bag_rounded,
                Icons.group_rounded,
              ],
              labels: const ['Overview', 'Products', 'Orders', 'Users'],
              itemKeys: _dockKeys,
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentScreenName() {
    switch (_currentIndex) {
      case 0:
        return 'dashboard';
      case 1:
        return 'products';
      case 2:
        return 'orders';
      case 3:
        return 'users';
      default:
        return 'dashboard';
    }
  }
}
