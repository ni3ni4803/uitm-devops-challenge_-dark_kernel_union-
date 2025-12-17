import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/features/admin/state/admin_dashboard_notifier.dart'; // Ensure this is imported correctly
import 'package:rentverse_mobile/features/auth/state/auth_notifier.dart';

// Helper widget to display a single statistic card
class StatCard extends StatelessWidget {
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

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  // Drawer helper method
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
            onTap: () => context.go('/admin'),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('User Management'),
            onTap: () {
              Navigator.pop(context);
              context.go('/admin/users');
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Content Moderation'),
            onTap: () {
              Navigator.pop(context);
              context.go('/admin/moderation');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Analytics'),
            onTap: () {
              Navigator.pop(context);
              context.go('/admin/analytics');
            },
          ),
          const Divider(),
          
          // --- UPDATED LOGOUT SECTION ---
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              // 1. Close the drawer
              Navigator.pop(context);

              // 2. Optional: Show confirmation dialog
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                // 3. Trigger the logout in AuthNotifier
                ref.read(authNotifierProvider.notifier).logout();
                
                // 4. Force navigation to login (Safety check)
                if (context.mounted) {
                  context.go('/login');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(AdminDashboardState state) {
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
    // Correct usage: Use ref.watch inside the build method
    final state = ref.watch(adminDashboardNotifierProvider);
    final notifier = ref.read(adminDashboardNotifierProvider.notifier);

    // Initial fetch logic
    if (state.stats == null && !state.isLoading) {
      Future.microtask(() => notifier.fetchDashboardStats());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: state.isLoading ? null : notifier.fetchDashboardStats,
          ),
        ],
      ),
      body: _buildBody(state),
      drawer: _buildAdminDrawer(context, ref),
    );
  }
}