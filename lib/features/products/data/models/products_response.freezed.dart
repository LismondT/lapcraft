// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'products_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductsResponse {
  List<ProductData>? get data;
  int? get currentPage;
  int? get totalPages;

  /// Create a copy of ProductsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductsResponseCopyWith<ProductsResponse> get copyWith =>
      _$ProductsResponseCopyWithImpl<ProductsResponse>(
          this as ProductsResponse, _$identity);

  /// Serializes this ProductsResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductsResponse &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(data), currentPage, totalPages);

  @override
  String toString() {
    return 'ProductsResponse(data: $data, currentPage: $currentPage, totalPages: $totalPages)';
  }
}

/// @nodoc
abstract mixin class $ProductsResponseCopyWith<$Res> {
  factory $ProductsResponseCopyWith(
          ProductsResponse value, $Res Function(ProductsResponse) _then) =
      _$ProductsResponseCopyWithImpl;
  @useResult
  $Res call({List<ProductData>? data, int? currentPage, int? totalPages});
}

/// @nodoc
class _$ProductsResponseCopyWithImpl<$Res>
    implements $ProductsResponseCopyWith<$Res> {
  _$ProductsResponseCopyWithImpl(this._self, this._then);

  final ProductsResponse _self;
  final $Res Function(ProductsResponse) _then;

  /// Create a copy of ProductsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? currentPage = freezed,
    Object? totalPages = freezed,
  }) {
    return _then(_self.copyWith(
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ProductData>?,
      currentPage: freezed == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPages: freezed == totalPages
          ? _self.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ProductsResponse implements ProductsResponse {
  const _ProductsResponse(
      {final List<ProductData>? data, this.currentPage, this.totalPages})
      : _data = data;
  factory _ProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseFromJson(json);

  final List<ProductData>? _data;
  @override
  List<ProductData>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? currentPage;
  @override
  final int? totalPages;

  /// Create a copy of ProductsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductsResponseCopyWith<_ProductsResponse> get copyWith =>
      __$ProductsResponseCopyWithImpl<_ProductsResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductsResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductsResponse &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_data), currentPage, totalPages);

  @override
  String toString() {
    return 'ProductsResponse(data: $data, currentPage: $currentPage, totalPages: $totalPages)';
  }
}

/// @nodoc
abstract mixin class _$ProductsResponseCopyWith<$Res>
    implements $ProductsResponseCopyWith<$Res> {
  factory _$ProductsResponseCopyWith(
          _ProductsResponse value, $Res Function(_ProductsResponse) _then) =
      __$ProductsResponseCopyWithImpl;
  @override
  @useResult
  $Res call({List<ProductData>? data, int? currentPage, int? totalPages});
}

/// @nodoc
class __$ProductsResponseCopyWithImpl<$Res>
    implements _$ProductsResponseCopyWith<$Res> {
  __$ProductsResponseCopyWithImpl(this._self, this._then);

  final _ProductsResponse _self;
  final $Res Function(_ProductsResponse) _then;

  /// Create a copy of ProductsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? data = freezed,
    Object? currentPage = freezed,
    Object? totalPages = freezed,
  }) {
    return _then(_ProductsResponse(
      data: freezed == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ProductData>?,
      currentPage: freezed == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPages: freezed == totalPages
          ? _self.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$ProductData {
  String? get id;
  int? get article;
  String? get title;
  String? get description;
  double? get price;
  int? get category;
  int? get petCategory;
  List<String>? get imageUrls;
  int? get stockQuantity;

  /// Create a copy of ProductData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductDataCopyWith<ProductData> get copyWith =>
      _$ProductDataCopyWithImpl<ProductData>(this as ProductData, _$identity);

  /// Serializes this ProductData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductData &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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
    return 'ProductData(id: $id, article: $article, title: $title, description: $description, price: $price, category: $category, petCategory: $petCategory, imageUrls: $imageUrls, stockQuantity: $stockQuantity)';
  }
}

/// @nodoc
abstract mixin class $ProductDataCopyWith<$Res> {
  factory $ProductDataCopyWith(
          ProductData value, $Res Function(ProductData) _then) =
      _$ProductDataCopyWithImpl;
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
class _$ProductDataCopyWithImpl<$Res> implements $ProductDataCopyWith<$Res> {
  _$ProductDataCopyWithImpl(this._self, this._then);

  final ProductData _self;
  final $Res Function(ProductData) _then;

  /// Create a copy of ProductData
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
@JsonSerializable()
class _ProductData implements ProductData {
  const _ProductData(
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
  factory _ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);

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

  /// Create a copy of ProductData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductDataCopyWith<_ProductData> get copyWith =>
      __$ProductDataCopyWithImpl<_ProductData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductData &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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
    return 'ProductData(id: $id, article: $article, title: $title, description: $description, price: $price, category: $category, petCategory: $petCategory, imageUrls: $imageUrls, stockQuantity: $stockQuantity)';
  }
}

/// @nodoc
abstract mixin class _$ProductDataCopyWith<$Res>
    implements $ProductDataCopyWith<$Res> {
  factory _$ProductDataCopyWith(
          _ProductData value, $Res Function(_ProductData) _then) =
      __$ProductDataCopyWithImpl;
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
class __$ProductDataCopyWithImpl<$Res> implements _$ProductDataCopyWith<$Res> {
  __$ProductDataCopyWithImpl(this._self, this._then);

  final _ProductData _self;
  final $Res Function(_ProductData) _then;

  /// Create a copy of ProductData
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
    return _then(_ProductData(
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
