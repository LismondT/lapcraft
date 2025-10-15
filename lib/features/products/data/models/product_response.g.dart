// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductResponse _$ProductResponseFromJson(Map<String, dynamic> json) =>
    _ProductResponse(
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

Map<String, dynamic> _$ProductResponseToJson(_ProductResponse instance) =>
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
