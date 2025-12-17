import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/tenant/models/rental_application.dart';
import 'package:flutter/foundation.dart';

// Use the modern NotifierProvider with .family
final applicationNotifierProvider =
    NotifierProvider.family<ApplicationNotifier, RentalApplication, String>(
  () => ApplicationNotifier(),
);

class ApplicationNotifier extends FamilyNotifier<RentalApplication, String> {
  
  @override
  RentalApplication build(String arg) {
    // 'arg' is the propertyId passed from the UI
    // FIX: Generate a unique ID for this specific application attempt
    return RentalApplication(
      id: 'app_${DateTime.now().millisecondsSinceEpoch}', 
      propertyId: arg,
    );
  }

  // === Step 1: Personal Info ===
  void updatePersonalInfo({
    required String fullName,
    required String email,
    required String phone,
    required String driverLicenseNumber,
    required String dateOfBirth,
  }) {
    state = state.copyWith(
      fullName: fullName,
      email: email,
      phone: phone,
      driverLicenseNumber: driverLicenseNumber,
      dateOfBirth: dateOfBirth,
    );
  }

  // === Step 2: Financial Info ===
  void updateFinancialInfo({
    required double currentMonthlyIncome,
    required String employerName,
    required String employerPhone,
    required String employmentDuration,
    required int occupancyCount, 
  }) {
    state = state.copyWith(
      currentMonthlyIncome: currentMonthlyIncome,
      employerName: employerName,
      employerPhone: employerPhone,
      employmentDuration: employmentDuration,
      occupancyCount: occupancyCount,
    );
  }

  // === Step 3: Residence History ===
  void updateResidenceHistory({
    required String currentAddress,
    required String currentLandlordName,
    required String currentLandlordPhone,
    required String reasonForMoving, 
  }) {
    state = state.copyWith(
      currentAddress: currentAddress,
      currentLandlordName: currentLandlordName,
      currentLandlordPhone: currentLandlordPhone,
      reasonForMoving: reasonForMoving,
    );
  }

  // === Submission ===
  Future<bool> submitApplication() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1500));

      debugPrint('Submitting application for property: ${state.propertyId}');

      // Set state to submitted and update status
      state = state.copyWith(
        isSubmitted: true,
        status: 'Pending',
      );

      return true;
    } catch (e) {
      debugPrint('Submission Error: $e');
      return false;
    }
  }

  // === Reset ===
  void resetApplication() {
    // FIX: Use the same initialization logic as the build method
    state = RentalApplication(
      id: 'app_${DateTime.now().millisecondsSinceEpoch}',
      propertyId: arg,
    );
  }
}