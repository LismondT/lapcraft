// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductsResponse _$ProductsResponseFromJson(Map<String, dynamic> json) =>
    _ProductsResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ProductData.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: (json['currentPage'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductsResponseToJson(_ProductsResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
    };

_ProductData _$ProductDataFromJson(Map<String, dynamic> json) => _ProductData(
      id: json['id'] as String?,
      article: (json['article'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      category: json['category'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      stockQuantity: (json['stockQuantity'] as num?)?.toInt(),
      isFavorite: json['isFavorite'] as bool?,
    );

Map<String, dynamic> _$ProductDataToJson(_ProductData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'article': instance.article,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'category': instance.category,
      'imageUrls': instance.imageUrls,
      'stockQuantity': instance.stockQuantity,
      'isFavorite': instance.isFavorite,
    };
