import 'package:freezed_annotation/freezed_annotation.dart';

part 'rental_application.freezed.dart';
part 'rental_application.g.dart';

@freezed
class RentalApplication with _$RentalApplication {
  const RentalApplication._();

  const factory RentalApplication({
    // 🚨 ADDED: Unique identifier for the application itself
    required String id, 
    required String propertyId, 

    // === Step 1: Personal Info ===
    @Default('') String fullName,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String driverLicenseNumber,
    @Default('') String dateOfBirth, 

    // === Step 2: Financial Info ===
    @Default(0.0) double currentMonthlyIncome, 
    @Default('') String employerName,
    @Default('') String employerPhone, 
    @Default('') String employmentDuration,
    @Default(1) int occupancyCount,

    // === Step 3: Residence History ===
    @Default('') String currentAddress,
    @Default('') String currentLandlordName, 
    @Default('') String currentLandlordPhone,
    @Default('') String reasonForMoving, 

    // Submission Status
    @Default(false) bool isSubmitted,
    @Default('Pending') String status, 
  }) = _RentalApplication;

  factory RentalApplication.fromJson(Map<String, dynamic> json) => _$RentalApplicationFromJson(json);

  // --- Step Validation Getters ---
  bool get isStepOneValid => 
      fullName.trim().isNotEmpty && 
      email.contains('@') && 
      phone.trim().length >= 8;

  bool get isStepTwoValid => 
      currentMonthlyIncome > 0 && 
      employerName.trim().isNotEmpty && 
      occupancyCount > 0;

  bool get isStepThreeValid => 
      currentAddress.trim().isNotEmpty && 
      reasonForMoving.trim().isNotEmpty;

  double get totalProgress {
    if (isSubmitted) return 1.0;
    double progress = 0.0;
    if (isStepOneValid) progress += 0.33;
    if (isStepTwoValid) progress += 0.33;
    if (isStepThreeValid) progress += 0.34;
    return progress;
  }
}