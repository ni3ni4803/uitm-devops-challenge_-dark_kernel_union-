import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/tenant/state/property_list_notifier.dart';
import 'package:rentverse_mobile/features/tenant/state/wishlist_notifier.dart';
import 'package:rentverse_mobile/features/tenant/widgets/property_card.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get the list of ALL properties (to find matches)
    final allPropertiesAsync = ref.watch(propertyListNotifierProvider);
    // 2. Get the SET of saved property IDs
    final favoriteIds = ref.watch(wishlistNotifierProvider); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Saved Properties'),
      ),
      body: allPropertiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (allProperties) {
          // Filter the full list down to only the properties whose IDs are in the favorites set
          final favoriteProperties = allProperties
              .where((property) => favoriteIds.contains(property.id))
              .toList();

          if (favoriteProperties.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No favorites yet!', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on any listing to save it here.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          // Display the list of favorited properties
          return ListView.builder(
            itemCount: favoriteProperties.length,
            itemBuilder: (context, index) {
              final property = favoriteProperties[index];
              return PropertyCard(property: property);
            },
          );
        },
      ),
    );
  }
}