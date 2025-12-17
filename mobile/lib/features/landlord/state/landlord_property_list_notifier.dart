import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/data/models/property.dart';
import 'package:rentverse_mobile/features/auth/state/auth_notifier.dart';

// 🚨 MODIFIED: Move mock data inside the class to allow mutation for simulation purposes.

// Notifier for Landlord-specific property list
class LandlordPropertyNotifier extends StateNotifier<AsyncValue<List<Property>>> {
  final String? landlordId;
  
  // Mock data source (Properties are only for Landlord ID 'landlord-456')
  final List<Property> _mockPropertiesDb = [
    const Property(
      id: 'lp-701',
      title: 'Luxury Downtown Loft',
      address: '101 Main St, Unit 701, City',
      monthlyRent: 2500,
      bedrooms: 2,
      bathrooms: 2,
      description: 'A spacious loft with floor-to-ceiling windows and premium finishes. Perfect for the urban professional.',
      imageUrls: ['https://via.placeholder.com/600x400?text=Loft+701'],
      amenities: ['Gym', 'Pool', 'In-Unit Laundry'], 
      latitude: 34.0522, 
      longitude: -118.2437, 
      isAvailable: true, 
      ownerId: 'landlord-456', 
    ),
    const Property(
      id: 'lp-802',
      title: 'Cozy Family Home',
      address: '456 Oak Lane, Suburbia',
      monthlyRent: 1800,
      bedrooms: 3,
      bathrooms: 2,
      description: 'Quiet neighborhood, large backyard, and excellent school district.',
      imageUrls: ['https://via.placeholder.com/600x400?text=Home+802'],
      amenities: ['Garage', 'Patio', 'Fenced Yard'], 
      latitude: 34.0123, 
      longitude: -118.1000, 
      isAvailable: true, 
      ownerId: 'landlord-456', 
    ),
  ];

  // 🚨 MODIFIED: Constructor simplified, fetching logic moved to its own method
  LandlordPropertyNotifier(this.landlordId) : super(const AsyncValue.loading()) {
    _fetchProperties();
  }

  // Helper to filter mock properties by current Landlord's ID
  List<Property> _getPropertiesForCurrentUser() {
    if (landlordId == null) return const [];
    // Filter the internal DB copy to simulate API result for the current user
    return _mockPropertiesDb.where((p) => p.ownerId == landlordId).toList();
  }


  // Simulate fetching properties owned by the current landlord
  Future<void> _fetchProperties() async {
    if (landlordId == null) {
      state = const AsyncValue.error('Landlord ID missing, cannot fetch properties.', StackTrace.empty);
      return;
    }
    
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(seconds: 1)); 
      
      final filteredList = _getPropertiesForCurrentUser();
      state = AsyncValue.data(filteredList);
      
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  // Method to remove a property (for demonstration)
  void removeProperty(String propertyId) {
    // 🚨 MODIFIED: Use state.whenData to safely mutate and update
    state = state.whenData((properties) {
      // Update mock DB source
      _mockPropertiesDb.removeWhere((p) => p.id == propertyId);
      // Update local state copy
      return properties.where((p) => p.id != propertyId).toList();
    });
  }

  // Method to add a property (called by PropertyCreationNotifier)
  void addProperty(Property newProperty) {
    // 🚨 MODIFIED: Use state.whenData
    state = state.whenData((properties) {
      // Update mock DB source
      _mockPropertiesDb.add(newProperty);
      // Update local state copy
      return [...properties, newProperty];
    });
  }

  // Method to update an existing property (called by PropertyCreationNotifier)
  void updateProperty(Property updatedProperty) {
    // 🚨 MODIFIED: Use state.whenData
    state = state.whenData((properties) {
      // Update mock DB source
      final dbIndex = _mockPropertiesDb.indexWhere((p) => p.id == updatedProperty.id);
      if (dbIndex != -1) {
          _mockPropertiesDb[dbIndex] = updatedProperty;
      }
      
      // Update local state copy
      final index = properties.indexWhere((p) => p.id == updatedProperty.id);
      if (index != -1) {
        final newList = List<Property>.from(properties);
        newList[index] = updatedProperty;
        return newList;
      }
      return properties; 
    });
  }
  
  // Method to toggle availability (needed for LandlordHomeScreen)
  Future<void> togglePropertyAvailability(String propertyId) async {
    // Perform optimistic update first
    state = state.whenData((properties) {
        final propertyIndex = properties.indexWhere((p) => p.id == propertyId);
        if (propertyIndex == -1) return properties;

        final oldProperty = properties[propertyIndex];
        final newStatus = !oldProperty.isAvailable;
        
        // Create updated property model
        final updatedProperty = oldProperty.copyWith(isAvailable: newStatus);

        // Update local state list
        final updatedList = properties.map((p) {
            return p.id == propertyId ? updatedProperty : p;
        }).toList();
        
        return updatedList;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
      
      // On success, update the mock DB
      final dbIndex = _mockPropertiesDb.indexWhere((p) => p.id == propertyId);
      if (dbIndex != -1) {
          // Find the optimistically updated version from the current state
          final successProperty = state.value!.firstWhere((p) => p.id == propertyId);
          _mockPropertiesDb[dbIndex] = successProperty;
      }
      
    } catch (e, st) {
      // Revert if API fails
      state = AsyncValue.error(e, st);
      // A more robust revert would find the old property and explicitly revert the list
      _fetchProperties(); // Re-fetch from the (unchanged) mock DB to revert
    }
  }
}

// Provider: Uses select on authNotifierProvider to get the ID
final landlordPropertyNotifierProvider = StateNotifierProvider.autoDispose<
    LandlordPropertyNotifier, AsyncValue<List<Property>>>((ref) {
  // Watch the auth state to get the current user's ID
  final landlordId = ref.watch(authNotifierProvider.select((user) => user?.id));
  
  // Pass the ID to the notifier
  return LandlordPropertyNotifier(landlordId);
});