import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/data/models/property.dart';

// 1. Riverpod Provider for the Dio Client (Easily swappable and configurable)
final dioProvider = Provider<Dio>((ref) {
  // Define your backend base URL here.
  const baseUrl = 'http://localhost:3000/api'; // replace with your actual API base URL
  return Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
});

// 2. Riverpod Provider for the PropertyApiService (Injects the Dio client)
final propertyApiServiceProvider = Provider<PropertyApiService>((ref) {
  // We use the 'ref.watch' mechanism to inject the Dio instance.
  final dio = ref.watch(dioProvider);
  return PropertyApiService(dio);
});


// 3. The Actual Service Class
class PropertyApiService {
  final Dio _dio;

  PropertyApiService(this._dio);

  // Method to fetch all properties for the Tenant Feed/Search screen
  Future<List<Property>> fetchAllProperties() async {
    try {
      // Assuming your API endpoint for all listings is /properties/
      final response = await _dio.get('/properties/');

      // The API is expected to return a List<Map<String, dynamic>>
      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> data = response.data;
        
        // Map the JSON list to a list of Property objects using the generated fromJson method
        return data.map((json) => Property.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        // Handle unexpected status code or response type
        throw Exception('Failed to load properties: Server responded with status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors (network, timeout, etc.)
      throw Exception('Network Error: Failed to fetch properties. Details: ${e.message}');
    } catch (e) {
      // Handle any other errors
      throw Exception('An unknown error occurred while fetching properties: $e');
    }
  }

  // You will add more methods here later (e.g., fetchPropertyDetails(id), searchProperties(filters), etc.)
}