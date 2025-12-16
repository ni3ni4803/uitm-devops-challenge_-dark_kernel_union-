// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_creation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PropertyCreationModel {
// Step 1: Basic Info
  String get title => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double get monthlyRent => throw _privateConstructorUsedError;
  String? get id =>
      throw _privateConstructorUsedError; // Step 2: Details & Location
  int get bedrooms => throw _privateConstructorUsedError;
  int get bathrooms => throw _privateConstructorUsedError;
  List<String> get amenities => throw _privateConstructorUsedError;
  double get latitude =>
      throw _privateConstructorUsedError; // Defaulting to a central coordinate for mock purposes
  double get longitude =>
      throw _privateConstructorUsedError; // Step 3: Description & Media
  String get description => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;

  /// Create a copy of PropertyCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyCreationModelCopyWith<PropertyCreationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyCreationModelCopyWith<$Res> {
  factory $PropertyCreationModelCopyWith(PropertyCreationModel value,
          $Res Function(PropertyCreationModel) then) =
      _$PropertyCreationModelCopyWithImpl<$Res, PropertyCreationModel>;
  @useResult
  $Res call(
      {String title,
      String address,
      double monthlyRent,
      String? id,
      int bedrooms,
      int bathrooms,
      List<String> amenities,
      double latitude,
      double longitude,
      String description,
      List<String> imageUrls});
}

/// @nodoc
class _$PropertyCreationModelCopyWithImpl<$Res,
        $Val extends PropertyCreationModel>
    implements $PropertyCreationModelCopyWith<$Res> {
  _$PropertyCreationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? address = null,
    Object? monthlyRent = null,
    Object? id = freezed,
    Object? bedrooms = null,
    Object? bathrooms = null,
    Object? amenities = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? description = null,
    Object? imageUrls = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      monthlyRent: null == monthlyRent
          ? _value.monthlyRent
          : monthlyRent // ignore: cast_nullable_to_non_nullable
              as double,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      bedrooms: null == bedrooms
          ? _value.bedrooms
          : bedrooms // ignore: cast_nullable_to_non_nullable
              as int,
      bathrooms: null == bathrooms
          ? _value.bathrooms
          : bathrooms // ignore: cast_nullable_to_non_nullable
              as int,
      amenities: null == amenities
          ? _value.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PropertyCreationModelImplCopyWith<$Res>
    implements $PropertyCreationModelCopyWith<$Res> {
  factory _$$PropertyCreationModelImplCopyWith(
          _$PropertyCreationModelImpl value,
          $Res Function(_$PropertyCreationModelImpl) then) =
      __$$PropertyCreationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String address,
      double monthlyRent,
      String? id,
      int bedrooms,
      int bathrooms,
      List<String> amenities,
      double latitude,
      double longitude,
      String description,
      List<String> imageUrls});
}

/// @nodoc
class __$$PropertyCreationModelImplCopyWithImpl<$Res>
    extends _$PropertyCreationModelCopyWithImpl<$Res,
        _$PropertyCreationModelImpl>
    implements _$$PropertyCreationModelImplCopyWith<$Res> {
  __$$PropertyCreationModelImplCopyWithImpl(_$PropertyCreationModelImpl _value,
      $Res Function(_$PropertyCreationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PropertyCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? address = null,
    Object? monthlyRent = null,
    Object? id = freezed,
    Object? bedrooms = null,
    Object? bathrooms = null,
    Object? amenities = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? description = null,
    Object? imageUrls = null,
  }) {
    return _then(_$PropertyCreationModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      monthlyRent: null == monthlyRent
          ? _value.monthlyRent
          : monthlyRent // ignore: cast_nullable_to_non_nullable
              as double,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      bedrooms: null == bedrooms
          ? _value.bedrooms
          : bedrooms // ignore: cast_nullable_to_non_nullable
              as int,
      bathrooms: null == bathrooms
          ? _value.bathrooms
          : bathrooms // ignore: cast_nullable_to_non_nullable
              as int,
      amenities: null == amenities
          ? _value._amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$PropertyCreationModelImpl implements _PropertyCreationModel {
  const _$PropertyCreationModelImpl(
      {this.title = '',
      this.address = '',
      this.monthlyRent = 0,
      this.id = null,
      this.bedrooms = 1,
      this.bathrooms = 1,
      final List<String> amenities = const [],
      this.latitude = 34.0,
      this.longitude = -118.0,
      this.description = '',
      final List<String> imageUrls = const []})
      : _amenities = amenities,
        _imageUrls = imageUrls;

// Step 1: Basic Info
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final double monthlyRent;
  @override
  @JsonKey()
  final String? id;
// Step 2: Details & Location
  @override
  @JsonKey()
  final int bedrooms;
  @override
  @JsonKey()
  final int bathrooms;
  final List<String> _amenities;
  @override
  @JsonKey()
  List<String> get amenities {
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amenities);
  }

  @override
  @JsonKey()
  final double latitude;
// Defaulting to a central coordinate for mock purposes
  @override
  @JsonKey()
  final double longitude;
// Step 3: Description & Media
  @override
  @JsonKey()
  final String description;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  String toString() {
    return 'PropertyCreationModel(title: $title, address: $address, monthlyRent: $monthlyRent, id: $id, bedrooms: $bedrooms, bathrooms: $bathrooms, amenities: $amenities, latitude: $latitude, longitude: $longitude, description: $description, imageUrls: $imageUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyCreationModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.monthlyRent, monthlyRent) ||
                other.monthlyRent == monthlyRent) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bedrooms, bedrooms) ||
                other.bedrooms == bedrooms) &&
            (identical(other.bathrooms, bathrooms) ||
                other.bathrooms == bathrooms) &&
            const DeepCollectionEquality()
                .equals(other._amenities, _amenities) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      address,
      monthlyRent,
      id,
      bedrooms,
      bathrooms,
      const DeepCollectionEquality().hash(_amenities),
      latitude,
      longitude,
      description,
      const DeepCollectionEquality().hash(_imageUrls));

  /// Create a copy of PropertyCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyCreationModelImplCopyWith<_$PropertyCreationModelImpl>
      get copyWith => __$$PropertyCreationModelImplCopyWithImpl<
          _$PropertyCreationModelImpl>(this, _$identity);
}

abstract class _PropertyCreationModel implements PropertyCreationModel {
  const factory _PropertyCreationModel(
      {final String title,
      final String address,
      final double monthlyRent,
      final String? id,
      final int bedrooms,
      final int bathrooms,
      final List<String> amenities,
      final double latitude,
      final double longitude,
      final String description,
      final List<String> imageUrls}) = _$PropertyCreationModelImpl;

// Step 1: Basic Info
  @override
  String get title;
  @override
  String get address;
  @override
  double get monthlyRent;
  @override
  String? get id; // Step 2: Details & Location
  @override
  int get bedrooms;
  @override
  int get bathrooms;
  @override
  List<String> get amenities;
  @override
  double get latitude; // Defaulting to a central coordinate for mock purposes
  @override
  double get longitude; // Step 3: Description & Media
  @override
  String get description;
  @override
  List<String> get imageUrls;

  /// Create a copy of PropertyCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyCreationModelImplCopyWith<_$PropertyCreationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
