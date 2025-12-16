import 'package:freezed_annotation/freezed_annotation.dart';

part 'property_filter.freezed.dart';

@freezed
class PropertyFilter with _$PropertyFilter {
  // ----------------------------------------------------
  // FIX: Add this private constructor to allow custom getters/methods
  const PropertyFilter._(); 
  // ----------------------------------------------------

  const factory PropertyFilter({
    // Initial state: no minimum or maximum set
    @Default(0.0) double minRent,
    @Default(10000.0) double maxRent, 
    @Default(0) int minBedrooms,
    // Add other fields later: property type, location, etc.
  }) = _PropertyFilter;

  // Custom getter: check if any filter other than the default max is active
  bool get isDefault => minRent == 0.0 && maxRent == 10000.0 && minBedrooms == 0;
}