import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/features/auth/state/auth_notifier.dart';
import 'package:rentverse_mobile/features/tenant/state/property_list_notifier.dart'; 
import 'package:rentverse_mobile/data/models/property.dart';
import 'package:intl/intl.dart';

class TenantHomeScreen extends ConsumerWidget {
  // 🚨 FIX: Removed the non-const field _searchQueryController 
  const TenantHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the property list
    final propertyListAsync = ref.watch(propertyListNotifierProvider);
    final propertyListNotifier = ref.read(propertyListNotifierProvider.notifier);
    
    final tenantName = ref.watch(authNotifierProvider.select((user) => user?.fullName ?? 'Tenant'));

    // NOTE: If you later need to display the current search query, you must track it 
    // within the PropertyListNotifier state model and use a separate ref.watch for it.

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, $tenantName! Find your new home.'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar (Now fully stateless)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              // 🚨 FIX: Removed controller and now rely purely on onChanged
              decoration: InputDecoration(
                labelText: 'Search by Title or Location',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Filter functionality pending implementation in PropertyListNotifier.')),
                      );
                    },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (query) {
                // In a complete app, this should call a method on the notifier:
                // propertyListNotifier.updateSearchQuery(query);
                
                // For now, it's a mock hook:
                print('Search Query: $query'); 
              },
            ),
          ),
          
          // Property List Display
          Expanded(
            child: propertyListAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(child: Text('Error: $err')),
              data: (properties) {
                if (properties.isEmpty) {
                  return const Center(
                    child: Text('No available properties right now.'),
                  );
                }
                
                return ListView.builder(
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    return PropertyTile(property: property);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyTile extends StatelessWidget {
  final Property property;
  const PropertyTile({required this.property, super.key});

  @override
  Widget build(BuildContext context) {
    final priceFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: SizedBox(
          width: 80,
          height: 80,
          child: Image.network(
            property.imageUrls.first,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
          ),
        ),
        title: Text(property.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            '${property.address}\n${property.bedrooms} Bed, ${property.bathrooms.toStringAsFixed(property.bathrooms.truncateToDouble() == property.bathrooms ? 0 : 1)} Bath'
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(priceFormatter.format(property.monthlyRent), 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
            const Text('per month', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        onTap: () {
          // Navigation to Property Detail Screen
          context.push('/tenant/property/${property.id}'); 
        },
      ),
    );
  }
}
