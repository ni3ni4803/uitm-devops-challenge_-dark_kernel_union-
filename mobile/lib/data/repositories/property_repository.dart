import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/data/models/property.dart';
import 'package:rentverse_mobile/data/models/property_filter.dart';

// --- MOCK DATA SOURCE (Temporary) ---
// This enables immediate UI development for the Tenant Feed/Search.
const _mockProperties = [
  {
    'id': 'p100',
    'title': 'Sunny Apartment Downtown',
    'address': '123 Main St, City',
    'latitude': 34.0522,
    'longitude': -118.2437,
    'bedrooms': 2,
    'bathrooms': 1,
    'monthlyRent': 2400.00,
    'image_urls': ['https://via.placeholder.com/600/a1d1d1/242424?text=Apartment+1'],
    'description': 'Beautifully lit apartment close to all transit and shopping.',
    'isAvailable': true,
    'owner_id': 'o500',
  },
  {
    'id': 'p101',
    'title': 'Modern Loft in Arts District',
    'address': '456 Gallery Ave, City',
    'latitude': 34.0566,
    'longitude': -118.2514,
    'bedrooms': 1,
    'bathrooms': 1,
    'monthlyRent': 1850.50,
    'image_urls': ['https://via.placeholder.com/600/b2c2c2/242424?text=Loft+2'],
    'description': 'Industrial-style loft with high ceilings and private balcony.',
    'isAvailable': true,
    'owner_id': 'o501',
  }
];


// --- Riverpod Provider for Dependency Injection ---
// The UI will only ever interact with this provider.
final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  // In a real implementation, you would pass the PropertyApiService here:
  // final apiService = ref.watch(propertyApiServiceProvider);
  // return PropertyRepository(apiService); 
  return PropertyRepository(); 
});

// --- The Repository Class ---
class PropertyRepository {
  // Update the method signature to accept the filter
  Future<List<Property>> getProperties(PropertyFilter filter) async {
    // 1. Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500)); 

    // 2. Start with all mock properties
    final List<Map<String, dynamic>> allData = _mockProperties;
    
    // 3. Apply Filtering Logic (Price Range)
    final filteredData = allData.where((json) {
      final monthlyRent = json['monthlyRent'] as double;
      
      // Filter condition based on minRent and maxRent from the PropertyFilter
      final passesRentFilter = monthlyRent >= filter.minRent && monthlyRent <= filter.maxRent;
      
      // You would add other filters here (e.g., passesBedroomsFilter, etc.)
      return passesRentFilter;
    }).toList();

    // 4. Map the filtered JSON list to Property objects
    final properties = filteredData.map((json) => Property.fromJson(json)).toList();
    
    return properties;
  }
}