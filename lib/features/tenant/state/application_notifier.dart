import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/tenant/models/rental_application.dart';
import 'package:flutter/foundation.dart';

// Notifier to manage the multi-step form state
class ApplicationNotifier extends StateNotifier<RentalApplication> {
  ApplicationNotifier(String propertyId)
      : super(RentalApplication(propertyId: propertyId));

  // === Step 1: Personal Info ===
  void updatePersonalInfo({
    required String fullName,
    required String email,
    required String phone,
    required String driverLicenseNumber,
    required String dateOfBirth, // Added to match model
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
    required String employmentDuration, // Added to match model
  }) {
    state = state.copyWith(
      currentMonthlyIncome: currentMonthlyIncome,
      employerName: employerName,
      employerPhone: employerPhone,
      employmentDuration: employmentDuration,
    );
  }

  // === Step 3: Residence History ===
  void updateResidenceHistory({
    required String currentAddress,
    required String currentLandlordName,
    required String currentLandlordPhone,
  }) {
    state = state.copyWith(
      currentAddress: currentAddress,
      currentLandlordName: currentLandlordName,
      currentLandlordPhone: currentLandlordPhone,
    );
  }

  // === Submission ===
  Future<bool> submitApplication() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1500));

      debugPrint('Finalizing application for property: ${state.propertyId}');

      // 🚨 CRITICAL: Set isSubmitted to true so UI can show success screen
      state = state.copyWith(isSubmitted: true);

      return true;
    } catch (e) {
      debugPrint('Submission Error: $e');
      return false;
    }
  }

  // === Explicit reset ===
  void resetApplication() {
    state = RentalApplication(propertyId: state.propertyId);
  }
}

// Provider utilizing .family to keep property-specific state
final applicationNotifierProvider =
    StateNotifierProvider.family<ApplicationNotifier, RentalApplication, String>(
  (ref, propertyId) => ApplicationNotifier(propertyId),
);