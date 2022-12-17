// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of coffee_models;

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CoffeeResponse _$CoffeeResponseFromJson(Map<String, dynamic> json) {
  return _CoffeeResponse.fromJson(json);
}

/// @nodoc
mixin _$CoffeeResponse {
  String? get file => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CoffeeResponseCopyWith<CoffeeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoffeeResponseCopyWith<$Res> {
  factory $CoffeeResponseCopyWith(
          CoffeeResponse value, $Res Function(CoffeeResponse) then) =
      _$CoffeeResponseCopyWithImpl<$Res, CoffeeResponse>;
  @useResult
  $Res call({String? file});
}

/// @nodoc
class _$CoffeeResponseCopyWithImpl<$Res, $Val extends CoffeeResponse>
    implements $CoffeeResponseCopyWith<$Res> {
  _$CoffeeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? file = freezed,
  }) {
    return _then(_value.copyWith(
      file: freezed == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CoffeeResponseCopyWith<$Res>
    implements $CoffeeResponseCopyWith<$Res> {
  factory _$$_CoffeeResponseCopyWith(
          _$_CoffeeResponse value, $Res Function(_$_CoffeeResponse) then) =
      __$$_CoffeeResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? file});
}

/// @nodoc
class __$$_CoffeeResponseCopyWithImpl<$Res>
    extends _$CoffeeResponseCopyWithImpl<$Res, _$_CoffeeResponse>
    implements _$$_CoffeeResponseCopyWith<$Res> {
  __$$_CoffeeResponseCopyWithImpl(
      _$_CoffeeResponse _value, $Res Function(_$_CoffeeResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? file = freezed,
  }) {
    return _then(_$_CoffeeResponse(
      file: freezed == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CoffeeResponse implements _CoffeeResponse {
  const _$_CoffeeResponse({this.file});

  factory _$_CoffeeResponse.fromJson(Map<String, dynamic> json) =>
      _$$_CoffeeResponseFromJson(json);

  @override
  final String? file;

  @override
  String toString() {
    return 'CoffeeResponse(file: $file)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CoffeeResponse &&
            (identical(other.file, file) || other.file == file));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, file);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CoffeeResponseCopyWith<_$_CoffeeResponse> get copyWith =>
      __$$_CoffeeResponseCopyWithImpl<_$_CoffeeResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CoffeeResponseToJson(
      this,
    );
  }
}

abstract class _CoffeeResponse implements CoffeeResponse {
  const factory _CoffeeResponse({final String? file}) = _$_CoffeeResponse;

  factory _CoffeeResponse.fromJson(Map<String, dynamic> json) =
      _$_CoffeeResponse.fromJson;

  @override
  String? get file;
  @override
  @JsonKey(ignore: true)
  _$$_CoffeeResponseCopyWith<_$_CoffeeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}
