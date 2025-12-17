import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TenantMainWrapper extends StatelessWidget {
  final Widget child;

  const TenantMainWrapper({required this.child, super.key});

  // 1. Added '/profile' to the routes list
  static const List<String> _routes = ['/', '/map', '/wishlist', '/profile']; 

  int _calculateSelectedIndex(BuildContext context) {
    final GoRouter router = GoRouter.of(context);
    final String location = router.routerDelegate.currentConfiguration.uri.toString();

    if (location == _routes[0] || location.startsWith('/tenant/property/')) {
      return 0; 
    }
    if (location == _routes[1]) {
      return 1; 
    }
    if (location == _routes[2]) {
      return 2; 
    }
    // 2. Highlight Profile tab for /profile, /change-password, etc.
    if (location.startsWith('/profile') || location.startsWith('/change-password')) {
      return 3; 
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index != _calculateSelectedIndex(context)) {
      context.go(_routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);
    // Use the primary color from your theme for the active icon
    final Color primaryBlue = Theme.of(context).primaryColor;

    return Scaffold(
      body: child, 
      bottomNavigationBar: BottomNavigationBar(
        // 3. Force 'fixed' type so labels and colors show correctly with 4+ items
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => _onItemTapped(index, context),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            activeIcon: Icon(Icons.list_alt),
            label: 'Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Wishlist', 
          ),
          // 4. ADDED: Profile Tab
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile', 
          ),
        ],
      ),
    );
  }
}