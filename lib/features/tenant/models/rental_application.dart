import 'package:freezed_annotation/freezed_annotation.dart';

part 'rental_application.freezed.dart';
part 'rental_application.g.dart';

// Note: You must run 'flutter pub run build_runner build' after creating this.

@freezed
class RentalApplication with _$RentalApplication {
  const factory RentalApplication({
    // Basic Information
    @Default('') String fullName,
    @Default('') String phone,
    @Default('') String dateOfBirth, // Store as String/DateTime
    
    // Financial Information
    @Default(0) double monthlyIncome,
    @Default('') String employerName,
    @Default('') String employmentDuration,
    
    // Residence History
    @Default('') String currentAddress,
    @Default('') String currentLandlordContact,

    // Property ID associated with this application
    required String propertyId, 
  }) = _RentalApplication;

  factory RentalApplication.fromJson(Map<String, dynamic> json) => _$RentalApplicationFromJson(json);
}