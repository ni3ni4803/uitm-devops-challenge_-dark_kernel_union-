import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/tenant/models/rental_application.dart';

class LandlordApplicationsNotifier extends StateNotifier<AsyncValue<List<RentalApplication>>> {
  LandlordApplicationsNotifier() : super(const AsyncValue.loading()) {
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    // Simulate fetching applications from a database/API
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data matching your Freezed model structure
    state = AsyncValue.data([
      RentalApplication(
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
      ),
    ]);
  }
}

final landlordApplicationsProvider = StateNotifierProvider<
    LandlordApplicationsNotifier, AsyncValue<List<RentalApplication>>>((ref) {
  return LandlordApplicationsNotifier();
});