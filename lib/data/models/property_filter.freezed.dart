// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PropertyFilter {
// Initial state: no minimum or maximum set
  double get minRent => throw _privateConstructorUsedError;
  double get maxRent => throw _privateConstructorUsedError;
  int get minBedrooms => throw _privateConstructorUsedError;

  /// Create a copy of PropertyFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyFilterCopyWith<PropertyFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyFilterCopyWith<$Res> {
  factory $PropertyFilterCopyWith(
          PropertyFilter value, $Res Function(PropertyFilter) then) =
      _$PropertyFilterCopyWithImpl<$Res, PropertyFilter>;
  @useResult
  $Res call({double minRent, double maxRent, int minBedrooms});
}

/// @nodoc
class _$PropertyFilterCopyWithImpl<$Res, $Val extends PropertyFilter>
    implements $PropertyFilterCopyWith<$Res> {
  _$PropertyFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minRent = null,
    Object? maxRent = null,
    Object? minBedrooms = null,
  }) {
    return _then(_value.copyWith(
      minRent: null == minRent
          ? _value.minRent
          : minRent // ignore: cast_nullable_to_non_nullable
              as double,
      maxRent: null == maxRent
          ? _value.maxRent
          : maxRent // ignore: cast_nullable_to_non_nullable
              as double,
      minBedrooms: null == minBedrooms
          ? _value.minBedrooms
          : minBedrooms // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PropertyFilterImplCopyWith<$Res>
    implements $PropertyFilterCopyWith<$Res> {
  factory _$$PropertyFilterImplCopyWith(_$PropertyFilterImpl value,
          $Res Function(_$PropertyFilterImpl) then) =
      __$$PropertyFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double minRent, double maxRent, int minBedrooms});
}

/// @nodoc
class __$$PropertyFilterImplCopyWithImpl<$Res>
    extends _$PropertyFilterCopyWithImpl<$Res, _$PropertyFilterImpl>
    implements _$$PropertyFilterImplCopyWith<$Res> {
  __$$PropertyFilterImplCopyWithImpl(
      _$PropertyFilterImpl _value, $Res Function(_$PropertyFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of PropertyFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minRent = null,
    Object? maxRent = null,
    Object? minBedrooms = null,
  }) {
    return _then(_$PropertyFilterImpl(
      minRent: null == minRent
          ? _value.minRent
          : minRent // ignore: cast_nullable_to_non_nullable
              as double,
      maxRent: null == maxRent
          ? _value.maxRent
          : maxRent // ignore: cast_nullable_to_non_nullable
              as double,
      minBedrooms: null == minBedrooms
          ? _value.minBedrooms
          : minBedrooms // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PropertyFilterImpl extends _PropertyFilter {
  const _$PropertyFilterImpl(
      {this.minRent = 0.0, this.maxRent = 10000.0, this.minBedrooms = 0})
      : super._();

// Initial state: no minimum or maximum set
  @override
  @JsonKey()
  final double minRent;
  @override
  @JsonKey()
  final double maxRent;
  @override
  @JsonKey()
  final int minBedrooms;

  @override
  String toString() {
    return 'PropertyFilter(minRent: $minRent, maxRent: $maxRent, minBedrooms: $minBedrooms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyFilterImpl &&
            (identical(other.minRent, minRent) || other.minRent == minRent) &&
            (identical(other.maxRent, maxRent) || other.maxRent == maxRent) &&
            (identical(other.minBedrooms, minBedrooms) ||
                other.minBedrooms == minBedrooms));
  }

  @override
  int get hashCode => Object.hash(runtimeType, minRent, maxRent, minBedrooms);

  /// Create a copy of PropertyFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyFilterImplCopyWith<_$PropertyFilterImpl> get copyWith =>
      __$$PropertyFilterImplCopyWithImpl<_$PropertyFilterImpl>(
          this, _$identity);
}

abstract class _PropertyFilter extends PropertyFilter {
  const factory _PropertyFilter(
      {final double minRent,
      final double maxRent,
      final int minBedrooms}) = _$PropertyFilterImpl;
  const _PropertyFilter._() : super._();

// Initial state: no minimum or maximum set
  @override
  double get minRent;
  @override
  double get maxRent;
  @override
  int get minBedrooms;

  /// Create a copy of PropertyFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyFilterImplCopyWith<_$PropertyFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
