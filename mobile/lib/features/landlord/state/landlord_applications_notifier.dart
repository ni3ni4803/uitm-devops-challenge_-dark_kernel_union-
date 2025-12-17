import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/tenant/models/rental_application.dart';

class LandlordApplicationsNotifier extends StateNotifier<AsyncValue<List<RentalApplication>>> {
  LandlordApplicationsNotifier() : super(const AsyncValue.loading()) {
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    state = const AsyncValue.loading();
    try {
      // Simulate fetching applications from a database/API
      await Future.delayed(const Duration(seconds: 1));
      
      state = AsyncValue.data([
        RentalApplication(
          id: 'app_001', 
          propertyId: 'p101',
          fullName: 'John Doe',
          email: 'john.doe@example.com',
          phone: '555-0123',
          driverLicenseNumber: 'DL-98765',
          dateOfBirth: '1990-05-15',
          currentMonthlyIncome: 4500.0,
          employerName: 'Global Tech Inc.',
          employerPhone: '555-9999',
          employmentDuration: '3 years',
          currentAddress: '123 Main St, Apt 4B',
          currentLandlordName: 'Jane Smith',
          currentLandlordPhone: '555-8888',
          isSubmitted: true,
          status: 'Pending',
        ),
      ]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // --- Method to handle Approval ---
  Future<void> approveApplication(String applicationId) async {
    // We only update if we currently have data
    state.whenData((applications) async {
      // Simulate API Call to update backend
      await Future.delayed(const Duration(milliseconds: 500));

      // Update state by filtering out the approved application
      // This causes the list UI to rebuild and the item to disappear
      state = AsyncValue.data(
        applications.where((app) => app.id != applicationId).toList(),
      );
    });
  }

  // --- Method to handle Rejection ---
  Future<void> rejectApplication(String applicationId) async {
    state.whenData((applications) async {
      // Simulate API Call
      await Future.delayed(const Duration(milliseconds: 500));

      // Update state by filtering out the rejected application
      state = AsyncValue.data(
        applications.where((app) => app.id != applicationId).toList(),
      );
    });
  }
}

final landlordApplicationsProvider = StateNotifierProvider<
    LandlordApplicationsNotifier, AsyncValue<List<RentalApplication>>>((ref) {
  return LandlordApplicationsNotifier();
});