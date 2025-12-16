import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; 
import 'package:rentverse_mobile/features/tenant/state/property_list_notifier.dart';
import 'package:rentverse_mobile/features/tenant/widgets/property_card.dart';
import 'package:rentverse_mobile/features/tenant/state/filter_notifier.dart';
import 'package:rentverse_mobile/features/tenant/widgets/filter_modal.dart';
import 'package:rentverse_mobile/features/auth/state/auth_notifier.dart';


// Use ConsumerWidget to watch Riverpod providers
class TenantHomeScreen extends ConsumerWidget {
  const TenantHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the AsyncNotifierProvider for the LIST DATA
    final propertyListAsyncValue = ref.watch(propertyListNotifierProvider);
    
    // Watch the synchronous NotifierProvider for the FILTER STATE
    final currentFilter = ref.watch(filterNotifierProvider); 
    
    // Helper to determine if the filter button should be highlighted
    final isFiltered = !currentFilter.isDefault;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rentverse: Tenant Feed'),
        actions: [
          
          // 2. NEW: MAP VIEW BUTTON
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              // Use GoRouter to navigate to the new map screen route
              context.go('/map'); 
            },
          ),

          // 3. NEW: PROFILE BUTTON
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // Navigate to the Profile Edit Screen
              context.go('/profile'); 
            },
          ),
          
          // FILTER BUTTON (Remains the same)
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: isFiltered ? Colors.deepOrange : Colors.white, 
            ),
            onPressed: () {
              // Show the Filter Modal Bottom Sheet
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const FilterModal(),
              );
            },
          ),
          
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Call the notifier method to log the user out
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),

          // Refresh Button (Remains the same)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Call the notifier method to refresh the list
              ref.read(propertyListNotifierProvider.notifier).refreshProperties();
            },
          ),
        ],
      ),
      
      // Handle the three states of the AsyncValue
      body: propertyListAsyncValue.when(
        // LOADING STATE
        loading: () => const Center(child: CircularProgressIndicator()),
        
        // ERROR STATE (Remains the same)
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 40),
                const SizedBox(height: 10),
                Text('Error loading properties: $err', textAlign: TextAlign.center),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(propertyListNotifierProvider.notifier).refreshProperties();
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),

        // DATA STATE
        data: (properties) {
          if (properties.isEmpty) {
            // Provide contextual message if filters are active
            final text = isFiltered 
                ? 'No properties found matching your current filters.'
                : 'No properties found.';
            return Center(child: Text(text));
          }

          // Display the list of properties
          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return PropertyCard(property: property);
            },
          );
        },
      ),
    );
  }
}