// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RentalApplicationImpl _$$RentalApplicationImplFromJson(
        Map<String, dynamic> json) =>
    _$RentalApplicationImpl(
      propertyId: json['propertyId'] as String,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      driverLicenseNumber: json['driverLicenseNumber'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      currentMonthlyIncome:
          (json['currentMonthlyIncome'] as num?)?.toDouble() ?? 0,
      employerName: json['employerName'] as String? ?? '',
      employerPhone: json['employerPhone'] as String? ?? '',
      employmentDuration: json['employmentDuration'] as String? ?? '',
      currentAddress: json['currentAddress'] as String? ?? '',
      currentLandlordName: json['currentLandlordName'] as String? ?? '',
      currentLandlordPhone: json['currentLandlordPhone'] as String? ?? '',
      isSubmitted: json['isSubmitted'] as bool? ?? false,
    );

Map<String, dynamic> _$$RentalApplicationImplToJson(
        _$RentalApplicationImpl instance) =>
    <String, dynamic>{
      'propertyId': instance.propertyId,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'driverLicenseNumber': instance.driverLicenseNumber,
      'dateOfBirth': instance.dateOfBirth,
      'currentMonthlyIncome': instance.currentMonthlyIncome,
      'employerName': instance.employerName,
      'employerPhone': instance.employerPhone,
      'employmentDuration': instance.employmentDuration,
      'currentAddress': instance.currentAddress,
      'currentLandlordName': instance.currentLandlordName,
      'currentLandlordPhone': instance.currentLandlordPhone,
      'isSubmitted': instance.isSubmitted,
    };
