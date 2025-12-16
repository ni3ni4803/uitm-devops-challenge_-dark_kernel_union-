import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; 
import 'package:rentverse_mobile/features/tenant/state/property_list_notifier.dart';
import 'package:rentverse_mobile/features/tenant/state/wishlist_notifier.dart';

class PropertyDetailScreen extends ConsumerWidget {
  final String propertyId;

  const PropertyDetailScreen({required this.propertyId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyListAsyncValue = ref.watch(propertyListNotifierProvider);
    final wishlistNotifier = ref.read(wishlistNotifierProvider.notifier);
    
    // Attempt to find the specific property from the loaded list
    final property = propertyListAsyncValue.value?.firstWhere(
      (p) => p.id == propertyId,
      orElse: () => throw Exception('Property not found'),
    );

    if (property == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: const Center(child: Text('Property Data Loading...')),
      );
    }
    
    // Get favorite status for the button
    final isFavorite = wishlistNotifier.isFavorite(propertyId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // Try the reliable pop() first, as it's cleaner for details
                context.go('/'); 
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                property.title,
                style: const TextStyle(shadows: [Shadow(blurRadius: 5.0)]),
              ),
              background: Image.network(
                // Ensure imageUrls is not empty before accessing first
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
                          _buildDetailChip(Icons.bed, '${property.bedrooms} Bed'),
                          _buildDetailChip(Icons.bathtub, '${property.bathrooms} Bath'),
                        ],
                      ),

                      const Divider(height: 32),
                      
                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      // FIX APPLIED HERE: Use null-coalescing (??)
                      Text(property.description ?? 'No description provided by the owner.'), 
                      
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
          // FIX APPLIED HERE: Implement navigation to the rental application form
          onPressed: () {
            // Use GoRouter to navigate to the new application route, passing the property ID
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
}