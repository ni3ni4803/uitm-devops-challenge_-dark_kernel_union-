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

  // === ID Setter for Edit Flow ===
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

  // === Step 2: Details & Location (Used by AddPropertyStepTwoScreen) ===
    // Parameter 'bathrooms' is double to allow half-bath counts.
  void updateDetailsAndLocation({
    int? bedrooms,
    double? bathrooms, 
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


  // === Step 3: Description & Media (Used by AddPropertyStepThreeScreen) ===
  void updateDescriptionAndMedia({String? description, List<String>? imageUrls}) {
    state = state.copyWith(
      description: description ?? state.description,
      imageUrls: imageUrls ?? state.imageUrls,
    );
  }

  // === Final Submission for ADDING ===
  Future<bool> submitProperty() async {
    final landlordId = ref.read(authNotifierProvider.select((user) => user?.id)) ?? 'landlord-456'; 

    // Basic validation to prevent submitting empty core data
    if (state.title.isEmpty || state.address.isEmpty || state.monthlyRent <= 0) {
        debugPrint('Submission failed: Missing core data.');
        return false;
    }

    try {
      final newProperty = Property(
        id: 'lp-${DateTime.now().millisecondsSinceEpoch}',
        title: state.title, 
        address: state.address,   
        monthlyRent: state.monthlyRent, 
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

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500)); 

      // Update the Landlord's list of properties
      ref.read(landlordPropertyNotifierProvider.notifier).addProperty(newProperty);

      resetDraft();
      return true;
    } catch (e, st) {
      debugPrint('CRITICAL PROPERTY SUBMISSION ERROR: $e');
      debugPrint('Stack trace: $st');
      return false; 
    }
  }

  // === Final Submission for EDITING ===
  Future<bool> updateProperty() async {
    final landlordId = ref.read(authNotifierProvider.select((user) => user?.id)) ?? 'landlord-456';

    if (state.id == null) {
      debugPrint('Update failed: Missing property ID.');
      return false;
    }
    
    // Basic validation
    if (state.title.isEmpty || state.address.isEmpty || state.monthlyRent <= 0) {
        debugPrint('Update failed: Missing core data.');
        return false;
    }

    try {
      final updatedProperty = Property(
        id: state.id!, // Use the existing ID
        title: state.title,
        address: state.address,
        monthlyRent: state.monthlyRent,
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
        // NOTE: In a real app, copy over fields like creationDate, isAvailable, etc.
      );

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      // CRITICAL DIFFERENCE: Call updateProperty on the list notifier
      ref.read(landlordPropertyNotifierProvider.notifier).updateProperty(updatedProperty);

      resetDraft();
      return true;
    } catch (e, st) {
      debugPrint('CRITICAL PROPERTY UPDATE ERROR: $e');
      debugPrint('Stack trace: $st');
      return false;
    }
  }

  // === Form Reset ===
  void resetDraft() { 
    state = const PropertyCreationModel();
  }
}

final propertyCreationNotifierProvider =
    StateNotifierProvider.autoDispose<PropertyCreationNotifier, PropertyCreationModel>(
  (ref) => PropertyCreationNotifier(ref),
);
