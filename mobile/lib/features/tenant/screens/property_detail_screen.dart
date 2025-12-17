import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; 
import 'package:rentverse_mobile/features/tenant/state/property_list_notifier.dart';
import 'package:rentverse_mobile/features/tenant/state/wishlist_notifier.dart';
import 'package:intl/intl.dart';

class PropertyDetailScreen extends ConsumerWidget {
  final String propertyId;

  const PropertyDetailScreen({required this.propertyId, super.key});

  // Helper function for detail chips
  Widget _buildDetailChip(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // Icon mapping for amenities
  IconData _getAmenityIcon(String amenity) {
    final lower = amenity.toLowerCase();
    if (lower.contains('pool')) return Icons.pool;
    if (lower.contains('gym') || lower.contains('fitness')) return Icons.fitness_center;
    if (lower.contains('parking')) return Icons.local_parking;
    if (lower.contains('wifi')) return Icons.wifi;
    if (lower.contains('pets')) return Icons.pets;
    if (lower.contains('ac') || lower.contains('air')) return Icons.ac_unit;
    return Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyListAsync = ref.watch(propertyListNotifierProvider);
    final isFavorite = ref.watch(wishlistNotifierProvider.select((s) => s.contains(propertyId)));
    
    // Find property safely
    final property = propertyListAsync.value?.firstWhereOrNull((p) => p.id == propertyId);

    // --- State Handling ---
    if (propertyListAsync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (property == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Property Not Found')),
        body: Center(child: Text('Property ID: $propertyId could not be located.')),
      );
    }

    final priceFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsing Header with Image
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    property.imageUrls.isNotEmpty ? property.imageUrls.first : '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                        Container(color: Colors.grey[300], child: const Icon(Icons.home, size: 100)),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black54, Colors.transparent, Colors.black54],
                        stops: [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () => ref.read(wishlistNotifierProvider.notifier).toggleFavorite(propertyId),
              ),
            ],
          ),
          
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            property.title,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          '${priceFormatter.format(property.monthlyRent)}/mo',
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold, 
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(property.address, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const Divider(height: 40),
                    Row(
                      children: [
                        _buildDetailChip(Icons.king_bed_outlined, '${property.bedrooms} Bedrooms'),
                        _buildDetailChip(
                          Icons.straighten_outlined, 
                          '${property.bathrooms.toStringAsFixed(property.bathrooms.truncateToDouble() == property.bathrooms ? 0 : 1)} Bathrooms'
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(
                      property.description ?? 'No description provided.',
                      style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                    ),
                    const SizedBox(height: 30),
                    const Text('Amenities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: property.amenities.map((amenity) => Chip(
                        avatar: Icon(_getAmenityIcon(amenity), size: 16, color: Theme.of(context).primaryColor),
                        label: Text(amenity),
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.08),
                        side: BorderSide.none,
                      )).toList(),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: ElevatedButton(
          onPressed: () {
            // --- MODIFIED CODE START ---
            // Navigate to the step-one screen and include the current propertyId
            // This matches the '/tenant/apply/step-one/:id' route in your main.dart
            context.push('/tenant/apply/step-one/$propertyId');
            // --- MODIFIED CODE END ---
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: const Text('Apply Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}