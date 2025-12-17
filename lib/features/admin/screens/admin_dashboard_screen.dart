import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/features/admin/state/admin_dashboard_state.dart';
import 'package:rentverse_mobile/features/auth/state/auth_notifier.dart'; // <--- 🚨 NEW: Import AuthNotifier file!

// Helper widget to display a single statistic card (No functional change)
// ... (StatCard code is unchanged)

class StatCard extends StatelessWidget {
// ... (StatCard code is unchanged)
  final String title;
  final int value;
  final IconData icon;

  const StatCard({
    required this.title,
    required this.value,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 36, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}


// CONVERTED: From StatefulWidget to ConsumerWidget
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  // 🚨 MODIFIED: Add WidgetRef ref as a parameter to the helper method
  Widget _buildAdminDrawer(BuildContext context, WidgetRef ref) {
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
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => GoRouter.of(context).go('/admin'), // Navigate to root admin path
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('User Management'),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).go('/admin/users');
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Content Moderation'),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).go('/admin/moderation');
            },
          ),
          
          // NEW: Analytics ListTile
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Analytics'),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).go('/admin/analytics');
            },
          ),

          // Divider for separation
          const Divider(), 

          // 🚨 THE LOGOUT FIX: New Logout ListTile
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              // 1. Close the drawer
              Navigator.pop(context);
              
              // 2. Read the AuthNotifier and call logout()
              ref.read(authNotifierProvider.notifier).logout(); 
              // GoRouter's redirect logic in main.dart will automatically send the user to /login
            },
          ),
        ],
      ),
    );
  }
  
  // Helper method for the body
  Widget _buildBody(AdminDashboardState state) {
    // ... (rest of _buildBody is unchanged)
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Text(
          state.errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (state.stats == null) {
      return const Center(child: Text('No dashboard data available.'));
    }

    // Display the loaded statistics
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Platform Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // A grid of StatCards
          GridView.count(
            crossAxisCount: 2, 
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true, 
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StatCard(
                title: 'Total Properties',
                value: state.stats!.totalProperties,
                icon: Icons.business,
              ),
              StatCard(
                title: 'Pending Approvals',
                value: state.stats!.pendingApprovals,
                icon: Icons.pending_actions,
              ),
              StatCard(
                title: 'Active Tenants',
                value: state.stats!.activeTenants,
                icon: Icons.person,
              ),
              StatCard(
                title: 'Active Landlords',
                value: state.stats!.activeLandlords,
                icon: Icons.home_work,
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Placeholder for Analytics Chart or recent activities
          const Text(
            'Recent Activities & Analytics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            color: Colors.grey[200],
            alignment: Alignment.center,
            child: const Text('Analytics Chart Placeholder'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the state for UI rebuilds
    final state = ref.watch(adminDashboardNotifierProvider);
    // 2. Read the notifier for calling methods
    final notifier = ref.read(adminDashboardNotifierProvider.notifier);
    
    // Initial data fetch logic (replaces initState)
    if (state.stats == null && !state.isLoading) {
        Future.microtask(() => notifier.fetchDashboardStats());
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: state.isLoading 
                ? null 
                : notifier.fetchDashboardStats, 
          ),
        ],
      ),
        body: _buildBody(state),
        // 🚨 MODIFIED: Pass the 'ref' object to the drawer helper method
        drawer: _buildAdminDrawer(context, ref), 
      ) ; 
  } 
}
