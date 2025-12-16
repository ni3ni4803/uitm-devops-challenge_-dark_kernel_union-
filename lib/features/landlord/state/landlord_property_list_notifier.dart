import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/data/models/property.dart';
import 'package:rentverse_mobile/features/auth/state/auth_notifier.dart';

// Mock Data: Only Landlord Properties
final List<Property> _mockLandlordProperties = [
  const Property(
    id: 'lp-701',
    title: 'Luxury Downtown Loft',
    address: '101 Main St, Unit 701, City',
    monthlyRent: 2500,
    bedrooms: 2,
    bathrooms: 2,
    description: 'A spacious loft with floor-to-ceiling windows and premium finishes. Perfect for the urban professional.',
    imageUrls: ['https://via.placeholder.com/600x400?text=Loft+701'],
    // REQUIRED FIXES ADDED/VERIFIED HERE
    amenities: ['Gym', 'Pool', 'In-Unit Laundry'], // <<< FIX: Added amenities parameter
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
    // REQUIRED FIXES ADDED/VERIFIED HERE
    amenities: ['Garage', 'Patio', 'Fenced Yard'], // <<< FIX: Added amenities parameter
    latitude: 34.0123, 
    longitude: -118.1000, 
    isAvailable: true, 
    ownerId: 'landlord-456', 
  ),
];

// Notifier for Landlord-specific property list
class LandlordPropertyNotifier extends StateNotifier<AsyncValue<List<Property>>> {
// ... (rest of the code remains the same)

  final String? landlordId;

  LandlordPropertyNotifier(this.landlordId) : super(const AsyncValue.loading()) {
    if (landlordId != null) {
      _fetchProperties();
    } else {
      state = const AsyncValue.error('Landlord ID missing, cannot fetch properties.', StackTrace.empty);
    }
  }

  // Simulate fetching properties owned by the current landlord
  Future<void> _fetchProperties() async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(seconds: 1)); 
      // In a real app, this would filter properties by landlordId
      state = AsyncValue.data(_mockLandlordProperties);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Method to remove a property (for demonstration)
  void removeProperty(String propertyId) {
    if (state is AsyncData) {
      final updatedList = state.value!.where((p) => p.id != propertyId).toList();
      state = AsyncValue.data(updatedList);
    }
  }

  // Method to add a property (for demonstration)
  void addProperty(Property newProperty) {
    if (state is AsyncData) {
      final updatedList = [...state.value!, newProperty];
      state = AsyncValue.data(updatedList);
    }
  }

  // Method to update an existing property
void updateProperty(Property updatedProperty) {
  state = state.whenData((properties) {
    final index = properties.indexWhere((p) => p.id == updatedProperty.id);
    if (index != -1) {
      // If found, replace the old property with the updated one
      final newList = List<Property>.from(properties);
      newList[index] = updatedProperty;
      return newList;
    }
    // If not found, return the original list
    return properties; 
  });
}
}

// Provider: Uses Family to identify properties by the logged-in Landlord ID
final landlordPropertyNotifierProvider = StateNotifierProvider<
    LandlordPropertyNotifier, AsyncValue<List<Property>>>((ref) {
  // Get the current user's ID
  final landlordId = ref.watch(authNotifierProvider)?.id;
  
  // We use the ID to initialize the notifier, ensuring the data is scope-aware.
  return LandlordPropertyNotifier(landlordId);
});