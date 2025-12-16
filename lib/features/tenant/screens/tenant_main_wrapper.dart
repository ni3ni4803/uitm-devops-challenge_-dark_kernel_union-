import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TenantMainWrapper extends StatelessWidget {
  final Widget child; // The current screen widget (TenantHomeScreen or TenantMapScreen)

  const TenantMainWrapper({required this.child, super.key});

  // A list of the main navigation destinations for the BottomNavigationBar
  static const List<String> _routes = ['/', '/map', '/wishlist']; 

  // Determines the current index based on the URL path
  int _calculateSelectedIndex(BuildContext context) {
    final GoRouter router = GoRouter.of(context);
    
    // FIX APPLIED HERE: Use routerDelegate to get the current URI/path
    final String location = router.routerDelegate.currentConfiguration.uri.toString();

    // Check against the base routes
    if (location == _routes[0] || location.startsWith('/property/')) {
      return 0; // List View is the default home tab
    }
    if (location == _routes[1]) {
      return 1; // Map View
    }
    if (location == _routes[2]) {
      return 2; // Wishlist View
    }
    return 0;
  }

  // Handles navigation when a bottom bar item is tapped
  void _onItemTapped(int index, BuildContext context) {
    // Only navigate if the user is tapping a different tab
    if (index != _calculateSelectedIndex(context)) {
      // Use context.go to navigate to the root path of the branch
      context.go(_routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      // The child widget (TenantHomeScreen, TenantMapScreen, or WishlistScreen) is displayed here
      body: child, 
      
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist', 
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }
}