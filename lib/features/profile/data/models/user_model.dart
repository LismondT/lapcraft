import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
sealed class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    required List<String> addresses,
    String? phone,
    @JsonKey(name: 'refresh_token') String? refreshToken,
    @JsonKey(name: 'access_token') String? accessToken,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserMapper on UserModel {
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      addresses: addresses,
      phone: phone,
    );
  }

  UserModel toModel() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      addresses: addresses,
      phone: phone,
    );
  }
}
