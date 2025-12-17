import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/features/auth/state/auth_notifier.dart';
import 'package:rentverse_mobile/features/tenant/state/property_list_notifier.dart'; 
import 'package:rentverse_mobile/features/tenant/state/filter_notifier.dart'; 
import 'package:rentverse_mobile/features/tenant/widgets/filter_modal.dart'; 
import 'package:rentverse_mobile/data/models/property.dart';
import 'package:intl/intl.dart';

class TenantHomeScreen extends ConsumerWidget {
  const TenantHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the property list (triggers rebuild when filters change)
    final propertyListAsync = ref.watch(propertyListNotifierProvider);
    
    // Watch the filter state for visual indicators
    final currentFilter = ref.watch(filterNotifierProvider);
    
    final tenantName = ref.watch(authNotifierProvider.select((user) => user?.fullName ?? 'Tenant'));

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, $tenantName!'),
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
          // Search & Filter Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by Title or Location',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: !currentFilter.isDefault ? Theme.of(context).primaryColor : null,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true, 
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => const FilterModal(),
                        );
                      },
                    ),
                    if (!currentFilter.isDefault)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                        ),
                      ),
                  ],
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ),

          // Active Filter Chips
          if (!currentFilter.isDefault)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (currentFilter.propertyType != 'All')
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Chip(
                          label: Text(currentFilter.propertyType),
                          onDeleted: () => ref.read(filterNotifierProvider.notifier).updatePropertyType('All'),
                        ),
                      ),
                    ActionChip(
                      label: const Text('Clear All'),
                      onPressed: () => ref.read(filterNotifierProvider.notifier).resetFilters(),
                    ),
                  ],
                ),
              ),
            ),
          
          // Property List Display
          Expanded(
            child: propertyListAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(child: Text('Error: $err')),
              data: (properties) {
                if (properties.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('No properties match your filters.', style: TextStyle(color: Colors.grey)),
                        TextButton(
                          onPressed: () => ref.read(filterNotifierProvider.notifier).resetFilters(),
                          child: const Text('Reset Filters'),
                        ),
                      ],
                    ),
                  );
                }
                
                return RefreshIndicator(
                  // FIX: Changed 'onPressed' to 'onRefresh'
                  onRefresh: () => ref.read(propertyListNotifierProvider.notifier).refreshProperties(),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      return PropertyTile(property: properties[index]);
                    },
                  ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Image.network(
              property.imageUrls.isNotEmpty ? property.imageUrls.first : '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.home_work, size: 40, color: Colors.grey),
            ),
          ),
        ),
        title: Text(
          property.title, 
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(property.address, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.king_bed_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${property.bedrooms} Bed'),
                const SizedBox(width: 12),
                const Icon(Icons.bathtub_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${property.bathrooms.toInt()} Bath'),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              priceFormatter.format(property.monthlyRent), 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
                color: Theme.of(context).primaryColor,
              ),
            ),
            const Text('per month', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        onTap: () => context.push('/tenant/property/${property.id}'),
      ),
    );
  }
}