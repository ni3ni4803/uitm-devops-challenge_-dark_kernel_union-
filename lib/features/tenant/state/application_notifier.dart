import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/tenant/models/rental_application.dart';

// 1. Notifier to manage the multi-step form state
class ApplicationNotifier extends StateNotifier<RentalApplication> {
  ApplicationNotifier(String propertyId)
      : super(RentalApplication(propertyId: propertyId));

  // Updates the application data with partial information
  void updateApplication(RentalApplication newApplicationData) {
    state = newApplicationData;
  }

  // Simulates submitting the final application
  Future<void> submitApplication() async {
    // In a real app, this would call an API with the entire 'state' object
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // For demonstration, we just log the submission
    print('Application Submitted for Property ${state.propertyId}:');
    print(state.toJson());
  }

  // Resets the state for a new application
  void reset(String newPropertyId) {
    state = RentalApplication(propertyId: newPropertyId);
  }
}

// 2. The Application Provider (needs to be instantiated with the property ID)
// This provider is designed to be overridden when entering the application flow.
final applicationNotifierProvider = StateNotifierProvider.family<ApplicationNotifier, RentalApplication, String>(
  (ref, propertyId) => ApplicationNotifier(propertyId),
);