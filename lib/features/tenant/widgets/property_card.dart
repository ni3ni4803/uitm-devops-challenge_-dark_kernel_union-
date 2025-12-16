import 'package:flutter/material.dart';
import 'package:rentverse_mobile/data/models/property.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/tenant/state/wishlist_notifier.dart';
import 'package:go_router/go_router.dart';

// Change from StatelessWidget to ConsumerWidget
class PropertyCard extends ConsumerWidget { 
  final Property property;

  const PropertyCard({required this.property, super.key});

  @override
  // Add WidgetRef ref to the build method signature
  Widget build(BuildContext context, WidgetRef ref) { 
    
    // WATCH the wishlist state (a Set<String> of favorited IDs)
    final wishlist = ref.watch(wishlistNotifierProvider);
    // Check if the current property's ID is in the wishlist set
    final isFavorite = wishlist.contains(property.id);

    // 1. WRAP THE CARD IN A GESTURE DETECTOR
    return GestureDetector(
      onTap: () {
        // Navigate to the detail screen, passing the property ID in the path
        // The GoRouter path is '/property/:id'
        context.go('/property/${property.id}');
      },
      child: Card( // <-- Card is now the child
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Property Image (remains the same)
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                image: DecorationImage(
                  image: NetworkImage(property.imageUrls.isNotEmpty 
                      ? property.imageUrls.first 
                      : 'https://via.placeholder.com/600x200?text=No+Image'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 3. Rent and Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${property.monthlyRent.toStringAsFixed(0)} / mo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      
                      // 4. INTERACTIVE FAVORITE BUTTON
                      IconButton(
                        // Dynamically change icon based on isFavorite state
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          // Change color based on isFavorite state
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          // Use ref.read to get the notifier and call the toggle method
                          ref.read(wishlistNotifierProvider.notifier)
                             .toggleFavorite(property.id);
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8.0),
                  Text(
                    property.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4.0),

                  // 5. Details (Address, Beds, Baths) (remains the same)
                  Text(
                    property.address,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      const Icon(Icons.bed, size: 18, color: Colors.grey),
                      const SizedBox(width: 4.0),
                      Text('${property.bedrooms} Bed', style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 16.0),
                      const Icon(Icons.bathtub, size: 18, color: Colors.grey),
                      const SizedBox(width: 4.0),
                      Text('${property.bathrooms} Bath', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}