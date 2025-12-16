import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/auth/state/auth_notifier.dart';
import 'package:rentverse_mobile/features/landlord/state/landlord_property_list_notifier.dart';
import 'package:go_router/go_router.dart'; // REQUIRED for context.go()

class LandlordHomeScreen extends ConsumerWidget {
  const LandlordHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final propertyListAsyncValue = ref.watch(landlordPropertyNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        actions: [
          // CORRECT: Single Button to add a new property (in AppBar)
          IconButton(
            icon: const Icon(Icons.add_home_work_outlined),
            onPressed: () {
              // Navigate to the form
              context.go('/landlord/add-property');
            },
          ),
          
          // CORRECT: Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: propertyListAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error loading properties: $error')),
        data: (properties) {
          if (properties.isEmpty) {
            return const Center(child: Text('You have no active listings.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  // FIX: Replaced Image.network with a colored placeholder container
                  leading: Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[300], // Use a light grey color
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
                      // REMOVED: Redundant Add Property Button was here
                      
                     // Edit Button
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Navigate to the edit route with the property's ID
                        context.go('/landlord/edit-property/${property.id}');
                      },
                    ),
                      // Remove Button (Mock functionality)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          ref.read(landlordPropertyNotifierProvider.notifier).removeProperty(property.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${property.title} removed (Mock)')),
                          );
                        },
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}