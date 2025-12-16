import 'package:freezed_annotation/freezed_annotation.dart';

part 'property.freezed.dart';
part 'property.g.dart'; 

@freezed
class Property with _$Property {
  const factory Property({
    required String id,
    required String title,
    required String address,
    required double latitude,
    required double longitude,
    required int bedrooms,
    required int bathrooms,
    required double monthlyRent,
    @JsonKey(name: 'image_urls') @Default([]) List<String> imageUrls, 
    String? description, 
    required bool isAvailable,
    @JsonKey(name: 'owner_id') required String ownerId,
    
    // 🌟 THE CRITICAL FIX IS HERE
    @Default([]) List<String> amenities, 
    // You could also make it required if every property must have amenities:
    // required List<String> amenities, 

  })=_Property;

  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);
}