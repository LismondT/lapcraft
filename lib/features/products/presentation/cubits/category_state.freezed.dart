// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CategoryState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CategoryState()';
  }
}

/// @nodoc
class $CategoryStateCopyWith<$Res> {
  $CategoryStateCopyWith(CategoryState _, $Res Function(CategoryState) __);
}

/// @nodoc

class Initial implements CategoryState {
  const Initial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CategoryState.initial()';
  }
}

/// @nodoc

class Loading implements CategoryState {
  const Loading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CategoryState.loading()';
  }
}

/// @nodoc

class CategoriesLoaded implements CategoryState {
  const CategoriesLoaded(final List<Category> categories)
      : _categories = categories;

  final List<Category> _categories;
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoriesLoadedCopyWith<CategoriesLoaded> get copyWith =>
      _$CategoriesLoadedCopyWithImpl<CategoriesLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CategoriesLoaded &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_categories));

  @override
  String toString() {
    return 'CategoryState.categoriesLoaded(categories: $categories)';
  }
}

/// @nodoc
abstract mixin class $CategoriesLoadedCopyWith<$Res>
    implements $CategoryStateCopyWith<$Res> {
  factory $CategoriesLoadedCopyWith(
          CategoriesLoaded value, $Res Function(CategoriesLoaded) _then) =
      _$CategoriesLoadedCopyWithImpl;
  @useResult
  $Res call({List<Category> categories});
}

/// @nodoc
class _$CategoriesLoadedCopyWithImpl<$Res>
    implements $CategoriesLoadedCopyWith<$Res> {
  _$CategoriesLoadedCopyWithImpl(this._self, this._then);

  final CategoriesLoaded _self;
  final $Res Function(CategoriesLoaded) _then;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? categories = null,
  }) {
    return _then(CategoriesLoaded(
      null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ));
  }
}

/// @nodoc

class CategoryTreeLoaded implements CategoryState {
  const CategoryTreeLoaded(final List<Category> categories)
      : _categories = categories;

  final List<Category> _categories;
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoryTreeLoadedCopyWith<CategoryTreeLoaded> get copyWith =>
      _$CategoryTreeLoadedCopyWithImpl<CategoryTreeLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CategoryTreeLoaded &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_categories));

  @override
  String toString() {
    return 'CategoryState.categoryTreeLoaded(categories: $categories)';
  }
}

/// @nodoc
abstract mixin class $CategoryTreeLoadedCopyWith<$Res>
    implements $CategoryStateCopyWith<$Res> {
  factory $CategoryTreeLoadedCopyWith(
          CategoryTreeLoaded value, $Res Function(CategoryTreeLoaded) _then) =
      _$CategoryTreeLoadedCopyWithImpl;
  @useResult
  $Res call({List<Category> categories});
}

/// @nodoc
class _$CategoryTreeLoadedCopyWithImpl<$Res>
    implements $CategoryTreeLoadedCopyWith<$Res> {
  _$CategoryTreeLoadedCopyWithImpl(this._self, this._then);

  final CategoryTreeLoaded _self;
  final $Res Function(CategoryTreeLoaded) _then;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? categories = null,
  }) {
    return _then(CategoryTreeLoaded(
      null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ));
  }
}

/// @nodoc

class SubcategoriesLoaded implements CategoryState {
  const SubcategoriesLoaded(final List<Category> categories, this.parentId)
      : _categories = categories;

  final List<Category> _categories;
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final String parentId;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubcategoriesLoadedCopyWith<SubcategoriesLoaded> get copyWith =>
      _$SubcategoriesLoadedCopyWithImpl<SubcategoriesLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SubcategoriesLoaded &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_categories), parentId);

  @override
  String toString() {
    return 'CategoryState.subcategoriesLoaded(categories: $categories, parentId: $parentId)';
  }
}

/// @nodoc
abstract mixin class $SubcategoriesLoadedCopyWith<$Res>
    implements $CategoryStateCopyWith<$Res> {
  factory $SubcategoriesLoadedCopyWith(
          SubcategoriesLoaded value, $Res Function(SubcategoriesLoaded) _then) =
      _$SubcategoriesLoadedCopyWithImpl;
  @useResult
  $Res call({List<Category> categories, String parentId});
}

/// @nodoc
class _$SubcategoriesLoadedCopyWithImpl<$Res>
    implements $SubcategoriesLoadedCopyWith<$Res> {
  _$SubcategoriesLoadedCopyWithImpl(this._self, this._then);

  final SubcategoriesLoaded _self;
  final $Res Function(SubcategoriesLoaded) _then;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? categories = null,
    Object? parentId = null,
  }) {
    return _then(SubcategoriesLoaded(
      null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      null == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class Error implements CategoryState {
  const Error(this.message);

  final String message;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ErrorCopyWith<Error> get copyWith =>
      _$ErrorCopyWithImpl<Error>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Error &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'CategoryState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $ErrorCopyWith<$Res>
    implements $CategoryStateCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) _then) =
      _$ErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$ErrorCopyWithImpl<$Res> implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(this._self, this._then);

  final Error _self;
  final $Res Function(Error) _then;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(Error(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
