import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/admin/models/app_user.dart';
import 'package:rentverse_mobile/features/admin/state/user_management_notifier.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  // Helper method to trigger the initial data fetch (equivalent to initState)
  void _initializeData(WidgetRef ref, UserManagementState state, UserManagementNotifier notifier) {
    if (state.users.isEmpty && !state.isLoading) {
      // Use Future.microtask to call the async method after the build phase completes
      Future.microtask(() => notifier.fetchUsers());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the state and get the notifier
    final state = ref.watch(userManagementNotifierProvider);
    final notifier = ref.read(userManagementNotifierProvider.notifier);
    
    // 🚨 NEW: Watch the computed provider for the list to display
    final filteredUsers = ref.watch(filteredUsersProvider); // <--- Use the filtered list

    // Trigger initial fetch
    _initializeData(ref, state, notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: state.isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.refresh),
            onPressed: state.isLoading ? null : notifier.fetchUsers,
            tooltip: 'Refresh Users',
          ),
        ],
      ),
      // 🚨 MODIFIED: Pass the filtered list to the body builder
      body: _buildBody(context, state, notifier, filteredUsers), 
    );
  }

  // 🚨 MODIFIED: Accept the filteredUsers list
  Widget _buildBody(
    BuildContext context, 
    UserManagementState state, 
    UserManagementNotifier notifier,
    List<AppUser> filteredUsers,
  ) {
    // 1. Loading and Error Checks (use state.users.isEmpty for first load)
    if (state.isLoading && state.users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Error: ${state.errorMessage}. Tap refresh to try again.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    
    // 2. Main Layout with Search Bar and List
    return Column(
      children: [
        // 🚨 NEW: Search Input Field
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Search Users',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            // Call the notifier method to update the search query state
            onChanged: notifier.setSearchQuery, 
          ),
        ),
        
        // 3. User Count / No Users Found
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: filteredUsers.isEmpty && state.users.isNotEmpty
            ? const Text('No results match your search query.', style: TextStyle(color: Colors.grey))
            : filteredUsers.isEmpty && state.users.isEmpty
              ? const Text('No users found on the platform.', style: TextStyle(color: Colors.grey))
              : Text('Showing ${filteredUsers.length} of ${state.users.length} total users.'),
        ),
        
        // 4. Display the Filtered List
        Expanded(
          child: ListView.builder(
            // 🚨 MODIFIED: Use the filtered list count
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return UserListTile(user: user, notifier: notifier);
            },
          ),
        ),
      ],
    );
  }
}

// UserListTile remains unchanged, as it correctly uses the passed notifier
class UserListTile extends StatelessWidget {
  final AppUser user;
  final UserManagementNotifier notifier;

  const UserListTile({
    required this.user,
    required this.notifier,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // ... (rest of ListTile remains unchanged)
      leading: CircleAvatar(
        backgroundColor: user.isActive ? Colors.green : Colors.red,
        child: Text(user.role[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
      ),
      title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user.email),
          Text(
            'Role: ${user.role.toUpperCase()} | Status: ${user.isActive ? 'Active' : 'Banned'}',
            style: TextStyle(
              color: user.isActive ? Colors.green.shade700 : Colors.red.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (action) {
          if (action == 'toggle_status') {
            _confirmToggleStatus(context, user);
          }
          // Add other actions like 'change_role' here
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'toggle_status',
            child: Text(user.isActive ? 'Ban User' : 'Unban User'),
          ),
          const PopupMenuItem(
            value: 'change_role',
            child: Text('Change Role'),
          ),
        ],
      ),
    );
  }

  void _confirmToggleStatus(BuildContext context, AppUser user) {
    final actionText = user.isActive ? 'Ban' : 'Unban';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$actionText Confirmation'),
        content: Text('Are you sure you want to $actionText ${user.name}? This will affect their ability to use the Rentverse platform.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              notifier.toggleUserActiveStatus(user.id);
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(backgroundColor: user.isActive ? Colors.red : Colors.green),
            child: Text(actionText),
          ),
        ],
      ),
    );
  }
}

