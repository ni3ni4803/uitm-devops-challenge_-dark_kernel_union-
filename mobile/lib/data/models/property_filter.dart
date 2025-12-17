import 'package:freezed_annotation/freezed_annotation.dart';

part 'property_filter.freezed.dart';

@freezed
class PropertyFilter with _$PropertyFilter {
  const PropertyFilter._(); 

  const factory PropertyFilter({
    @Default(0.0) double minRent,
    @Default(10000.0) double maxRent, 
    @Default(0) int minBedrooms,
    // Added propertyType field
    @Default('All') String propertyType, 
  }) = _PropertyFilter;

  // Updated getter to include propertyType check
  bool get isDefault => 
      minRent == 0.0 && 
      maxRent == 10000.0 && 
      minBedrooms == 0 && 
      propertyType == 'All';
}