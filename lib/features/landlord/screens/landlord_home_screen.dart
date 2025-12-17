import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/auth/state/auth_notifier.dart';
import 'package:rentverse_mobile/features/landlord/state/landlord_property_list_notifier.dart';
import 'package:go_router/go_router.dart';

class LandlordHomeScreen extends ConsumerWidget {
  const LandlordHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyListAsyncValue = ref.watch(landlordPropertyNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        actions: [
          // 🔔 NEW: Applications Notification Button
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/landlord/applications'),
            tooltip: 'View Applications',
          ),
          // Add Property Button
          IconButton(
            icon: const Icon(Icons.add_home_work_outlined),
            onPressed: () => context.go('/landlord/add-property'),
          ),
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
          ),
        ],
      ),
      body: propertyListAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (properties) {
          return Column(
            children: [
              // 🚀 NEW: Quick Access Card for Applications
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  color: Colors.blue.shade50,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.blue.shade100),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.assignment_ind, color: Colors.white),
                    ),
                    title: const Text(
                      'Rental Applications',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Review tenant submissions here'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.push('/landlord/applications'),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'My Listings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Existing Property List
              Expanded(
                child: properties.isEmpty
                    ? const Center(child: Text('You have no active listings.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          final property = properties[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.apartment, color: Colors.grey),
                                ),
                              ),
                              title: Text(property.title),
                              subtitle: Text(
                                '${property.address}\n\$${property.monthlyRent.toStringAsFixed(0)}/mo',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => context.go('/landlord/edit-property/${property.id}'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      ref.read(landlordPropertyNotifierProvider.notifier).removeProperty(property.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${property.title} removed')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}