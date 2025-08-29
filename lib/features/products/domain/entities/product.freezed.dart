// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {
  String? get id;
  int? get article;
  String? get title;
  String? get description;
  double? get price;
  int? get category;
  int? get petCategory;
  List<String>? get imageUrls;
  int? get stockQuantity;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductCopyWith<Product> get copyWith =>
      _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Product &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.article, article) || other.article == article) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.petCategory, petCategory) ||
                other.petCategory == petCategory) &&
            const DeepCollectionEquality().equals(other.imageUrls, imageUrls) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      article,
      title,
      description,
      price,
      category,
      petCategory,
      const DeepCollectionEquality().hash(imageUrls),
      stockQuantity);

  @override
  String toString() {
    return 'Product(id: $id, article: $article, title: $title, description: $description, price: $price, category: $category, petCategory: $petCategory, imageUrls: $imageUrls, stockQuantity: $stockQuantity)';
  }
}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) =
      _$ProductCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      int? article,
      String? title,
      String? description,
      double? price,
      int? category,
      int? petCategory,
      List<String>? imageUrls,
      int? stockQuantity});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res> implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? article = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? category = freezed,
    Object? petCategory = freezed,
    Object? imageUrls = freezed,
    Object? stockQuantity = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      article: freezed == article
          ? _self.article
          : article // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as int?,
      petCategory: freezed == petCategory
          ? _self.petCategory
          : petCategory // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrls: freezed == imageUrls
          ? _self.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      stockQuantity: freezed == stockQuantity
          ? _self.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _Product implements Product {
  const _Product(
      {this.id,
      this.article,
      this.title,
      this.description,
      this.price,
      this.category,
      this.petCategory,
      final List<String>? imageUrls,
      this.stockQuantity})
      : _imageUrls = imageUrls;

  @override
  final String? id;
  @override
  final int? article;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final double? price;
  @override
  final int? category;
  @override
  final int? petCategory;
  final List<String>? _imageUrls;
  @override
  List<String>? get imageUrls {
    final value = _imageUrls;
    if (value == null) return null;
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? stockQuantity;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductCopyWith<_Product> get copyWith =>
      __$ProductCopyWithImpl<_Product>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Product &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.article, article) || other.article == article) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.petCategory, petCategory) ||
                other.petCategory == petCategory) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      article,
      title,
      description,
      price,
      category,
      petCategory,
      const DeepCollectionEquality().hash(_imageUrls),
      stockQuantity);

  @override
  String toString() {
    return 'Product(id: $id, article: $article, title: $title, description: $description, price: $price, category: $category, petCategory: $petCategory, imageUrls: $imageUrls, stockQuantity: $stockQuantity)';
  }
}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) =
      __$ProductCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      int? article,
      String? title,
      String? description,
      double? price,
      int? category,
      int? petCategory,
      List<String>? imageUrls,
      int? stockQuantity});
}

/// @nodoc
class __$ProductCopyWithImpl<$Res> implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? article = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? category = freezed,
    Object? petCategory = freezed,
    Object? imageUrls = freezed,
    Object? stockQuantity = freezed,
  }) {
    return _then(_Product(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      article: freezed == article
          ? _self.article
          : article // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as int?,
      petCategory: freezed == petCategory
          ? _self.petCategory
          : petCategory // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrls: freezed == imageUrls
          ? _self._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      stockQuantity: freezed == stockQuantity
          ? _self.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
