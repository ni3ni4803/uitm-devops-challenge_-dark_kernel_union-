// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RentalApplicationImpl _$$RentalApplicationImplFromJson(
        Map<String, dynamic> json) =>
    _$RentalApplicationImpl(
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble() ?? 0,
      employerName: json['employerName'] as String? ?? '',
      employmentDuration: json['employmentDuration'] as String? ?? '',
      currentAddress: json['currentAddress'] as String? ?? '',
      currentLandlordContact: json['currentLandlordContact'] as String? ?? '',
      propertyId: json['propertyId'] as String,
    );

Map<String, dynamic> _$$RentalApplicationImplToJson(
        _$RentalApplicationImpl instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'phone': instance.phone,
      'dateOfBirth': instance.dateOfBirth,
      'monthlyIncome': instance.monthlyIncome,
      'employerName': instance.employerName,
      'employmentDuration': instance.employmentDuration,
      'currentAddress': instance.currentAddress,
      'currentLandlordContact': instance.currentLandlordContact,
      'propertyId': instance.propertyId,
    };
