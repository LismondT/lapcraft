// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductResponse _$ProductResponseFromJson(Map<String, dynamic> json) =>
    _ProductResponse(
      id: json['id'] as String,
      article: (json['article'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
      imageUrls: (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      stockQuantity: (json['stock_quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductResponseToJson(_ProductResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'article': instance.article,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'image_urls': instance.imageUrls,
      'stock_quantity': instance.stockQuantity,
    };
