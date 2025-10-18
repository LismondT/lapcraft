// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      addresses:
          (json['addresses'] as List<dynamic>).map((e) => e as String).toList(),
      phone: json['phone'] as String?,
      refreshToken: json['refresh_token'] as String?,
      accessToken: json['access_token'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'addresses': instance.addresses,
      'phone': instance.phone,
      'refresh_token': instance.refreshToken,
      'access_token': instance.accessToken,
    };
