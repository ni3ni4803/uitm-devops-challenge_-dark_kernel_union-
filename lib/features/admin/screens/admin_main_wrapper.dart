import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminMainWrapper extends StatelessWidget {
  // 'child' is the current screen being displayed by the nested router (GoRouter)
  final Widget child;
  const AdminMainWrapper({required this.child, super.key});

  // Helper function to build the common navigation drawer
  Widget _buildAdminDrawer(BuildContext context) {
    // Determine the current path to highlight the active menu item
    final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;

    
    // Helper to build a ListTile and check if it's the active route
    Widget buildMenuItem(IconData icon, String title, String path) {
      return ListTile(
        leading: Icon(icon),
        title: Text(title),
        selected: currentPath == path,
        onTap: () {
          // Close the drawer first
          Navigator.pop(context);
          // Navigate to the new path
          if (currentPath != path) {
            GoRouter.of(context).go(path);
          }
        },
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Text(
              'Admin Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          buildMenuItem(Icons.dashboard, 'Dashboard', '/admin'),
          buildMenuItem(Icons.people, 'User Management', '/admin/users'),
          buildMenuItem(Icons.gavel, 'Content Moderation', '/admin/moderation'),
          buildMenuItem(Icons.bar_chart, 'Analytics', '/admin/analytics'),
          
          const Divider(),

          // Logout/Profile
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {
              // In a real app, you would dispatch a Riverpod action here to log out.
              // For now, we'll navigate back to the login screen.
              GoRouter.of(context).go('/login');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The wrapper provides the consistent layout (AppBar, Drawer, and Body)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rentverse Admin Portal'),
      ),
      drawer: _buildAdminDrawer(context),
      body: child, // The body is the child screen (Dashboard, Users, etc.)
    );
  }
}