import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; 
import 'package:rentverse_mobile/features/tenant/state/property_list_notifier.dart';
import 'package:rentverse_mobile/features/tenant/state/wishlist_notifier.dart';
import 'package:rentverse_mobile/data/models/property.dart'; // Ensure Property model is imported

class PropertyDetailScreen extends ConsumerWidget {
  final String propertyId;

  const PropertyDetailScreen({required this.propertyId, super.key});

  // Helper function to create the detail chips (Defined here to be reusable and outside build)
  Widget _buildDetailChip(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }

  // Helper method to look up an appropriate icon for an amenity
  IconData _getAmenityIcon(String amenity) {
    final lowerAmenity = amenity.toLowerCase();
    if (lowerAmenity.contains('pool')) return Icons.pool;
    if (lowerAmenity.contains('gym') || lowerAmenity.contains('fitness')) return Icons.fitness_center;
    if (lowerAmenity.contains('parking')) return Icons.local_parking;
    if (lowerAmenity.contains('laundry')) return Icons.local_laundry_service;
    if (lowerAmenity.contains('wifi') || lowerAmenity.contains('internet')) return Icons.wifi;
    if (lowerAmenity.contains('pets')) return Icons.pets;
    if (lowerAmenity.contains('balcony') || lowerAmenity.contains('deck')) return Icons.balcony;
    if (lowerAmenity.contains('air conditioning') || lowerAmenity.contains('ac')) return Icons.ac_unit;
    if (lowerAmenity.contains('security')) return Icons.security;
    return Icons.check_circle_outline; // Default icon
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyListAsyncValue = ref.watch(propertyListNotifierProvider);
    
    // Watch the wishlist state to get the current status and rebuild the icon
    final isFavorite = ref.watch(wishlistNotifierProvider.select((state) => state.contains(propertyId)));
    final wishlistNotifier = ref.read(wishlistNotifierProvider.notifier);

    // Attempt to find the specific property from the loaded list
    final Property? property = propertyListAsyncValue.value?.firstWhereOrNull(
      (p) => p.id == propertyId,
    );

    // --- Loading, Error, Not Found Handling ---
    if (propertyListAsyncValue.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (propertyListAsyncValue.hasError || property == null) {
        return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(propertyListAsyncValue.hasError 
            ? 'Error: ${propertyListAsyncValue.error}' 
            : 'Property ID $propertyId not found.')),
      );
    }
    // --- End Handling ---
    
    // Now that the property is non-null, we can build the UI
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                context.pop(); // Go back to the previous screen
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                property.title,
                style: const TextStyle(shadows: [Shadow(blurRadius: 5.0)]),
              ),
              background: Image.network(
                property.imageUrls.isNotEmpty 
                  ? property.imageUrls.first 
                  : 'https://via.placeholder.com/600x250?text=No+Image',
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  wishlistNotifier.toggleFavorite(property.id);
                },
              ),
            ],
          ),
          
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price & Address
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${property.monthlyRent.toStringAsFixed(0)} / mo',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(property.address, style: const TextStyle(color: Colors.grey)),

                      const Divider(height: 32),

                      // Bed/Bath Icons
                      Row(
                        children: [
                          // Using the private helper method
                          _buildDetailChip(Icons.bed, '${property.bedrooms} Bed'), 
                          _buildDetailChip(
                                Icons.bathtub, 
                                // FIX 1: Format bathrooms to show 2 or 2.5 correctly
                                '${property.bathrooms.toStringAsFixed(property.bathrooms.truncateToDouble() == property.bathrooms ? 0 : 1)} Bath',
                          ),
                        ],
                      ),

                      const Divider(height: 32),
                      
                      // Description Title
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      // 🚨 FINAL FIX: Use null-coalescing operator (??) for null safety
                      Text(property.description ?? 'No description provided by the owner.'), 
                      
                      const Divider(height: 32),

                      // Amenities Display
                      Text(
                        'Amenities',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: property.amenities.map((amenity) => Chip(
                          avatar: Icon(_getAmenityIcon(amenity), size: 18, color: Theme.of(context).primaryColor),
                          label: Text(amenity, style: const TextStyle(fontSize: 14)),
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          padding: const EdgeInsets.all(8.0),
                        )).toList(),
                      ),

                      const SizedBox(height: 100), // Filler space
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            context.go('/apply/$propertyId');
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Apply Now', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}

// Extension to allow firstWhereOrNull pattern on iterables
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
