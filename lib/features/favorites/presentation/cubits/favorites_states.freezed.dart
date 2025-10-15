// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavoritesState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FavoritesState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FavoritesState()';
  }
}

/// @nodoc
class $FavoritesStateCopyWith<$Res> {
  $FavoritesStateCopyWith(FavoritesState _, $Res Function(FavoritesState) __);
}

/// @nodoc

class FavoritesStateInitial implements FavoritesState {
  const FavoritesStateInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FavoritesStateInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FavoritesState.initial()';
  }
}

/// @nodoc

class FavoritesStateLoading implements FavoritesState {
  const FavoritesStateLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FavoritesStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FavoritesState.loading()';
  }
}

/// @nodoc

class FavoritesStateLoaded implements FavoritesState {
  const FavoritesStateLoaded(final List<Product> products)
      : _products = products;

  final List<Product> _products;
  List<Product> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  /// Create a copy of FavoritesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FavoritesStateLoadedCopyWith<FavoritesStateLoaded> get copyWith =>
      _$FavoritesStateLoadedCopyWithImpl<FavoritesStateLoaded>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FavoritesStateLoaded &&
            const DeepCollectionEquality().equals(other._products, _products));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_products));

  @override
  String toString() {
    return 'FavoritesState.loaded(products: $products)';
  }
}

/// @nodoc
abstract mixin class $FavoritesStateLoadedCopyWith<$Res>
    implements $FavoritesStateCopyWith<$Res> {
  factory $FavoritesStateLoadedCopyWith(FavoritesStateLoaded value,
          $Res Function(FavoritesStateLoaded) _then) =
      _$FavoritesStateLoadedCopyWithImpl;
  @useResult
  $Res call({List<Product> products});
}

/// @nodoc
class _$FavoritesStateLoadedCopyWithImpl<$Res>
    implements $FavoritesStateLoadedCopyWith<$Res> {
  _$FavoritesStateLoadedCopyWithImpl(this._self, this._then);

  final FavoritesStateLoaded _self;
  final $Res Function(FavoritesStateLoaded) _then;

  /// Create a copy of FavoritesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? products = null,
  }) {
    return _then(FavoritesStateLoaded(
      null == products
          ? _self._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<Product>,
    ));
  }
}

/// @nodoc

class FavoritesStateError implements FavoritesState {
  const FavoritesStateError(this.message);

  final String message;

  /// Create a copy of FavoritesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FavoritesStateErrorCopyWith<FavoritesStateError> get copyWith =>
      _$FavoritesStateErrorCopyWithImpl<FavoritesStateError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FavoritesStateError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'FavoritesState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $FavoritesStateErrorCopyWith<$Res>
    implements $FavoritesStateCopyWith<$Res> {
  factory $FavoritesStateErrorCopyWith(
          FavoritesStateError value, $Res Function(FavoritesStateError) _then) =
      _$FavoritesStateErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FavoritesStateErrorCopyWithImpl<$Res>
    implements $FavoritesStateErrorCopyWith<$Res> {
  _$FavoritesStateErrorCopyWithImpl(this._self, this._then);

  final FavoritesStateError _self;
  final $Res Function(FavoritesStateError) _then;

  /// Create a copy of FavoritesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(FavoritesStateError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class FavoritesStateEmpty implements FavoritesState {
  const FavoritesStateEmpty();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FavoritesStateEmpty);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FavoritesState.empty()';
  }
}

// dart format on
