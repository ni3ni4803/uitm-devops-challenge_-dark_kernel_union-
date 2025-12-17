// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rental_application.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RentalApplication _$RentalApplicationFromJson(Map<String, dynamic> json) {
  return _RentalApplication.fromJson(json);
}

/// @nodoc
mixin _$RentalApplication {
// Application Metadata
  String get propertyId =>
      throw _privateConstructorUsedError; // === Step 1: Personal Info (Synchronized) ===
  String get fullName => throw _privateConstructorUsedError;
  String get email =>
      throw _privateConstructorUsedError; // ADDED: Email is required by Step 1 form
  String get phone => throw _privateConstructorUsedError;
  String get driverLicenseNumber =>
      throw _privateConstructorUsedError; // ADDED: License is required by Step 1 form
  String get dateOfBirth =>
      throw _privateConstructorUsedError; // === Step 2: Financial Info (Synchronized) ===
// Renamed to match Notifier's expected parameter
  double get currentMonthlyIncome => throw _privateConstructorUsedError;
  String get employerName =>
      throw _privateConstructorUsedError; // Added field that Notifier/Form sends
  String get employerPhone => throw _privateConstructorUsedError;
  String get employmentDuration =>
      throw _privateConstructorUsedError; // === Step 3: Residence History (Synchronized) ===
  String get currentAddress =>
      throw _privateConstructorUsedError; // Renamed field that Notifier/Form sends
  String get currentLandlordName =>
      throw _privateConstructorUsedError; // Added field that Notifier/Form sends
  String get currentLandlordPhone =>
      throw _privateConstructorUsedError; // Submission Status
  bool get isSubmitted => throw _privateConstructorUsedError;

  /// Serializes this RentalApplication to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RentalApplication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RentalApplicationCopyWith<RentalApplication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RentalApplicationCopyWith<$Res> {
  factory $RentalApplicationCopyWith(
          RentalApplication value, $Res Function(RentalApplication) then) =
      _$RentalApplicationCopyWithImpl<$Res, RentalApplication>;
  @useResult
  $Res call(
      {String propertyId,
      String fullName,
      String email,
      String phone,
      String driverLicenseNumber,
      String dateOfBirth,
      double currentMonthlyIncome,
      String employerName,
      String employerPhone,
      String employmentDuration,
      String currentAddress,
      String currentLandlordName,
      String currentLandlordPhone,
      bool isSubmitted});
}

/// @nodoc
class _$RentalApplicationCopyWithImpl<$Res, $Val extends RentalApplication>
    implements $RentalApplicationCopyWith<$Res> {
  _$RentalApplicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RentalApplication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? propertyId = null,
    Object? fullName = null,
    Object? email = null,
    Object? phone = null,
    Object? driverLicenseNumber = null,
    Object? dateOfBirth = null,
    Object? currentMonthlyIncome = null,
    Object? employerName = null,
    Object? employerPhone = null,
    Object? employmentDuration = null,
    Object? currentAddress = null,
    Object? currentLandlordName = null,
    Object? currentLandlordPhone = null,
    Object? isSubmitted = null,
  }) {
    return _then(_value.copyWith(
      propertyId: null == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      driverLicenseNumber: null == driverLicenseNumber
          ? _value.driverLicenseNumber
          : driverLicenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as String,
      currentMonthlyIncome: null == currentMonthlyIncome
          ? _value.currentMonthlyIncome
          : currentMonthlyIncome // ignore: cast_nullable_to_non_nullable
              as double,
      employerName: null == employerName
          ? _value.employerName
          : employerName // ignore: cast_nullable_to_non_nullable
              as String,
      employerPhone: null == employerPhone
          ? _value.employerPhone
          : employerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      employmentDuration: null == employmentDuration
          ? _value.employmentDuration
          : employmentDuration // ignore: cast_nullable_to_non_nullable
              as String,
      currentAddress: null == currentAddress
          ? _value.currentAddress
          : currentAddress // ignore: cast_nullable_to_non_nullable
              as String,
      currentLandlordName: null == currentLandlordName
          ? _value.currentLandlordName
          : currentLandlordName // ignore: cast_nullable_to_non_nullable
              as String,
      currentLandlordPhone: null == currentLandlordPhone
          ? _value.currentLandlordPhone
          : currentLandlordPhone // ignore: cast_nullable_to_non_nullable
              as String,
      isSubmitted: null == isSubmitted
          ? _value.isSubmitted
          : isSubmitted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RentalApplicationImplCopyWith<$Res>
    implements $RentalApplicationCopyWith<$Res> {
  factory _$$RentalApplicationImplCopyWith(_$RentalApplicationImpl value,
          $Res Function(_$RentalApplicationImpl) then) =
      __$$RentalApplicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String propertyId,
      String fullName,
      String email,
      String phone,
      String driverLicenseNumber,
      String dateOfBirth,
      double currentMonthlyIncome,
      String employerName,
      String employerPhone,
      String employmentDuration,
      String currentAddress,
      String currentLandlordName,
      String currentLandlordPhone,
      bool isSubmitted});
}

/// @nodoc
class __$$RentalApplicationImplCopyWithImpl<$Res>
    extends _$RentalApplicationCopyWithImpl<$Res, _$RentalApplicationImpl>
    implements _$$RentalApplicationImplCopyWith<$Res> {
  __$$RentalApplicationImplCopyWithImpl(_$RentalApplicationImpl _value,
      $Res Function(_$RentalApplicationImpl) _then)
      : super(_value, _then);

  /// Create a copy of RentalApplication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? propertyId = null,
    Object? fullName = null,
    Object? email = null,
    Object? phone = null,
    Object? driverLicenseNumber = null,
    Object? dateOfBirth = null,
    Object? currentMonthlyIncome = null,
    Object? employerName = null,
    Object? employerPhone = null,
    Object? employmentDuration = null,
    Object? currentAddress = null,
    Object? currentLandlordName = null,
    Object? currentLandlordPhone = null,
    Object? isSubmitted = null,
  }) {
    return _then(_$RentalApplicationImpl(
      propertyId: null == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      driverLicenseNumber: null == driverLicenseNumber
          ? _value.driverLicenseNumber
          : driverLicenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as String,
      currentMonthlyIncome: null == currentMonthlyIncome
          ? _value.currentMonthlyIncome
          : currentMonthlyIncome // ignore: cast_nullable_to_non_nullable
              as double,
      employerName: null == employerName
          ? _value.employerName
          : employerName // ignore: cast_nullable_to_non_nullable
              as String,
      employerPhone: null == employerPhone
          ? _value.employerPhone
          : employerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      employmentDuration: null == employmentDuration
          ? _value.employmentDuration
          : employmentDuration // ignore: cast_nullable_to_non_nullable
              as String,
      currentAddress: null == currentAddress
          ? _value.currentAddress
          : currentAddress // ignore: cast_nullable_to_non_nullable
              as String,
      currentLandlordName: null == currentLandlordName
          ? _value.currentLandlordName
          : currentLandlordName // ignore: cast_nullable_to_non_nullable
              as String,
      currentLandlordPhone: null == currentLandlordPhone
          ? _value.currentLandlordPhone
          : currentLandlordPhone // ignore: cast_nullable_to_non_nullable
              as String,
      isSubmitted: null == isSubmitted
          ? _value.isSubmitted
          : isSubmitted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RentalApplicationImpl implements _RentalApplication {
  const _$RentalApplicationImpl(
      {required this.propertyId,
      this.fullName = '',
      this.email = '',
      this.phone = '',
      this.driverLicenseNumber = '',
      this.dateOfBirth = '',
      this.currentMonthlyIncome = 0,
      this.employerName = '',
      this.employerPhone = '',
      this.employmentDuration = '',
      this.currentAddress = '',
      this.currentLandlordName = '',
      this.currentLandlordPhone = '',
      this.isSubmitted = false});

  factory _$RentalApplicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$RentalApplicationImplFromJson(json);

// Application Metadata
  @override
  final String propertyId;
// === Step 1: Personal Info (Synchronized) ===
  @override
  @JsonKey()
  final String fullName;
  @override
  @JsonKey()
  final String email;
// ADDED: Email is required by Step 1 form
  @override
  @JsonKey()
  final String phone;
  @override
  @JsonKey()
  final String driverLicenseNumber;
// ADDED: License is required by Step 1 form
  @override
  @JsonKey()
  final String dateOfBirth;
// === Step 2: Financial Info (Synchronized) ===
// Renamed to match Notifier's expected parameter
  @override
  @JsonKey()
  final double currentMonthlyIncome;
  @override
  @JsonKey()
  final String employerName;
// Added field that Notifier/Form sends
  @override
  @JsonKey()
  final String employerPhone;
  @override
  @JsonKey()
  final String employmentDuration;
// === Step 3: Residence History (Synchronized) ===
  @override
  @JsonKey()
  final String currentAddress;
// Renamed field that Notifier/Form sends
  @override
  @JsonKey()
  final String currentLandlordName;
// Added field that Notifier/Form sends
  @override
  @JsonKey()
  final String currentLandlordPhone;
// Submission Status
  @override
  @JsonKey()
  final bool isSubmitted;

  @override
  String toString() {
    return 'RentalApplication(propertyId: $propertyId, fullName: $fullName, email: $email, phone: $phone, driverLicenseNumber: $driverLicenseNumber, dateOfBirth: $dateOfBirth, currentMonthlyIncome: $currentMonthlyIncome, employerName: $employerName, employerPhone: $employerPhone, employmentDuration: $employmentDuration, currentAddress: $currentAddress, currentLandlordName: $currentLandlordName, currentLandlordPhone: $currentLandlordPhone, isSubmitted: $isSubmitted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RentalApplicationImpl &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.driverLicenseNumber, driverLicenseNumber) ||
                other.driverLicenseNumber == driverLicenseNumber) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.currentMonthlyIncome, currentMonthlyIncome) ||
                other.currentMonthlyIncome == currentMonthlyIncome) &&
            (identical(other.employerName, employerName) ||
                other.employerName == employerName) &&
            (identical(other.employerPhone, employerPhone) ||
                other.employerPhone == employerPhone) &&
            (identical(other.employmentDuration, employmentDuration) ||
                other.employmentDuration == employmentDuration) &&
            (identical(other.currentAddress, currentAddress) ||
                other.currentAddress == currentAddress) &&
            (identical(other.currentLandlordName, currentLandlordName) ||
                other.currentLandlordName == currentLandlordName) &&
            (identical(other.currentLandlordPhone, currentLandlordPhone) ||
                other.currentLandlordPhone == currentLandlordPhone) &&
            (identical(other.isSubmitted, isSubmitted) ||
                other.isSubmitted == isSubmitted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      propertyId,
      fullName,
      email,
      phone,
      driverLicenseNumber,
      dateOfBirth,
      currentMonthlyIncome,
      employerName,
      employerPhone,
      employmentDuration,
      currentAddress,
      currentLandlordName,
      currentLandlordPhone,
      isSubmitted);

  /// Create a copy of RentalApplication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RentalApplicationImplCopyWith<_$RentalApplicationImpl> get copyWith =>
      __$$RentalApplicationImplCopyWithImpl<_$RentalApplicationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RentalApplicationImplToJson(
      this,
    );
  }
}

abstract class _RentalApplication implements RentalApplication {
  const factory _RentalApplication(
      {required final String propertyId,
      final String fullName,
      final String email,
      final String phone,
      final String driverLicenseNumber,
      final String dateOfBirth,
      final double currentMonthlyIncome,
      final String employerName,
      final String employerPhone,
      final String employmentDuration,
      final String currentAddress,
      final String currentLandlordName,
      final String currentLandlordPhone,
      final bool isSubmitted}) = _$RentalApplicationImpl;

  factory _RentalApplication.fromJson(Map<String, dynamic> json) =
      _$RentalApplicationImpl.fromJson;

// Application Metadata
  @override
  String get propertyId; // === Step 1: Personal Info (Synchronized) ===
  @override
  String get fullName;
  @override
  String get email; // ADDED: Email is required by Step 1 form
  @override
  String get phone;
  @override
  String get driverLicenseNumber; // ADDED: License is required by Step 1 form
  @override
  String get dateOfBirth; // === Step 2: Financial Info (Synchronized) ===
// Renamed to match Notifier's expected parameter
  @override
  double get currentMonthlyIncome;
  @override
  String get employerName; // Added field that Notifier/Form sends
  @override
  String get employerPhone;
  @override
  String
      get employmentDuration; // === Step 3: Residence History (Synchronized) ===
  @override
  String get currentAddress; // Renamed field that Notifier/Form sends
  @override
  String get currentLandlordName; // Added field that Notifier/Form sends
  @override
  String get currentLandlordPhone; // Submission Status
  @override
  bool get isSubmitted;

  /// Create a copy of RentalApplication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RentalApplicationImplCopyWith<_$RentalApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
