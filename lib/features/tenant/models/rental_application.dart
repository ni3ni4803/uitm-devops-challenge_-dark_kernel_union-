import 'package:freezed_annotation/freezed_annotation.dart';

part 'rental_application.freezed.dart';
part 'rental_application.g.dart';

// Note: You must run 'flutter pub run build_runner build' after creating this.

@freezed
class RentalApplication with _$RentalApplication {
  const factory RentalApplication({
    // Application Metadata
    required String propertyId, 

    // === Step 1: Personal Info (Synchronized) ===
    @Default('') String fullName,
    @Default('') String email, // ADDED: Email is required by Step 1 form
    @Default('') String phone,
    @Default('') String driverLicenseNumber, // ADDED: License is required by Step 1 form
    @Default('') String dateOfBirth, 

    // === Step 2: Financial Info (Synchronized) ===
    // Renamed to match Notifier's expected parameter
    @Default(0) double currentMonthlyIncome, 
    @Default('') String employerName,
    // Added field that Notifier/Form sends
    @Default('') String employerPhone, 
    @Default('') String employmentDuration,

    // === Step 3: Residence History (Synchronized) ===
    @Default('') String currentAddress,
    // Renamed field that Notifier/Form sends
    @Default('') String currentLandlordName, 
    // Added field that Notifier/Form sends
    @Default('') String currentLandlordPhone,

    // Submission Status
    @Default(false) bool isSubmitted, // ADDED: For tracking state after submission
  }) = _RentalApplication;

  factory RentalApplication.fromJson(Map<String, dynamic> json) => _$RentalApplicationFromJson(json);
}