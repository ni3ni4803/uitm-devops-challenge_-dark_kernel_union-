import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:rentverse_mobile/data/models/property.dart';
import 'package:rentverse_mobile/features/auth/state/auth_notifier.dart';
import 'package:rentverse_mobile/features/landlord/state/landlord_property_list_notifier.dart';
import 'package:rentverse_mobile/features/landlord/state/property_creation_model.dart';


// Notifier for the multi-step Property Creation Form
class PropertyCreationNotifier extends StateNotifier<PropertyCreationModel> {
  final Ref ref;

  PropertyCreationNotifier(this.ref) : super(const PropertyCreationModel());

  // === NEW: ID Setter for Edit Flow ===
  void setPropertyId(String id) {
    state = state.copyWith(id: id);
  }

  // === Step 1: Basic Info ===
  void updateBasicInfo({String? title, String? address, double? monthlyRent}) {
    state = state.copyWith(
      title: title ?? state.title,
      address: address ?? state.address,
      monthlyRent: monthlyRent ?? state.monthlyRent,
    );
  }

  // === Step 2: Details & Location ===
  void updateDetailsAndLocation({
    int? bedrooms,
    int? bathrooms,
    List<String>? amenities,
    double? latitude,
    double? longitude,
  }) {
    state = state.copyWith(
      bedrooms: bedrooms ?? state.bedrooms,
      bathrooms: bathrooms ?? state.bathrooms,
      amenities: amenities ?? state.amenities,
      latitude: latitude ?? state.latitude,
      longitude: longitude ?? state.longitude,
    );
  }

  // === Step 3: Description & Media ===
  void updateDescriptionAndMedia({String? description, List<String>? imageUrls}) {
    state = state.copyWith(
      description: description ?? state.description,
      imageUrls: imageUrls ?? state.imageUrls,
    );
  }

  // === Final Submission for ADDING ===
  Future<bool> submitProperty() async {
    final landlordId = ref.read(authNotifierProvider)?.id ?? 'landlord-456'; 

    try {
      final newProperty = Property(
        id: 'lp-${DateTime.now().millisecondsSinceEpoch}',
        title: state.title.isEmpty ? 'Untitled Listing' : state.title, 
        address: state.address.isEmpty ? 'No Address' : state.address,   
        monthlyRent: state.monthlyRent > 0 ? state.monthlyRent : 1000.00, 
        bedrooms: state.bedrooms,
        bathrooms: state.bathrooms,
        description: state.description,
        imageUrls: state.imageUrls.isNotEmpty 
            ? state.imageUrls 
            : ['https://via.placeholder.com/600x400?text=Listing+Cover'], 
        amenities: state.amenities,
        latitude: state.latitude,
        longitude: state.longitude,
        isAvailable: true, 
        ownerId: landlordId,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      ref.read(landlordPropertyNotifierProvider.notifier).addProperty(newProperty);

      resetForm();
      return true;
    } catch (e, st) {
      debugPrint('CRITICAL PROPERTY SUBMISSION ERROR: $e');
      debugPrint('Stack trace: $st');
      return false; 
    }
  }

  // === NEW: Final Submission for EDITING ===
  Future<bool> updateProperty() async {
    final landlordId = ref.read(authNotifierProvider)?.id ?? 'landlord-456';

    if (state.id == null) {
      debugPrint('Update failed: Missing property ID.');
      return false;
    }

    try {
      final updatedProperty = Property(
        id: state.id!, // Use the existing ID
        title: state.title.isEmpty ? 'Untitled Listing' : state.title,
        address: state.address.isEmpty ? 'No Address' : state.address,
        monthlyRent: state.monthlyRent > 0 ? state.monthlyRent : 1000.00,
        bedrooms: state.bedrooms,
        bathrooms: state.bathrooms,
        description: state.description,
        imageUrls: state.imageUrls.isNotEmpty 
            ? state.imageUrls 
            : ['https://via.placeholder.com/600x400?text=Listing+Cover'],
        amenities: state.amenities,
        latitude: state.latitude,
        longitude: state.longitude,
        isAvailable: true, 
        ownerId: landlordId,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      // CRITICAL DIFFERENCE: Call updateProperty on the list notifier
      ref.read(landlordPropertyNotifierProvider.notifier).updateProperty(updatedProperty);

      resetForm();
      return true;
    } catch (e, st) {
      debugPrint('CRITICAL PROPERTY UPDATE ERROR: $e');
      debugPrint('Stack trace: $st');
      return false;
    }
  }

  void resetForm() {
    state = const PropertyCreationModel();
  }
}

final propertyCreationNotifierProvider =
    StateNotifierProvider.autoDispose<PropertyCreationNotifier, PropertyCreationModel>(
  (ref) => PropertyCreationNotifier(ref),
);