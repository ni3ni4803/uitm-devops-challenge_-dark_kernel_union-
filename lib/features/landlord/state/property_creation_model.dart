import 'package:freezed_annotation/freezed_annotation.dart';

part 'property_creation_model.freezed.dart';
// Note: We won't use .g.dart as this model isn't typically serialized for network transport.

@freezed
class PropertyCreationModel with _$PropertyCreationModel {
  const factory PropertyCreationModel({
    // Step 1: Basic Info
    @Default('') String title,
    @Default('') String address,
    @Default(0) double monthlyRent,
    @Default(null) String? id,
    
    // Step 2: Details & Location
    @Default(1) int bedrooms,
    @Default(1) int bathrooms,
    @Default([]) List<String> amenities,
    @Default(34.0) double latitude, // Defaulting to a central coordinate for mock purposes
    @Default(-118.0) double longitude,
    
    // Step 3: Description & Media
    @Default('') String description,
    @Default([]) List<String> imageUrls, // Mocking URL list for now
  }) = _PropertyCreationModel;
}