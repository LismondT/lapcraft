import 'dart:convert';
import 'package:flutter/services.dart';

class Config {
  static late final String apiUrl;

  static Future<void> init() async {
    final configString = await rootBundle.loadString('assets/config.json');
    final configJson = json.decode(configString) as Map<String, dynamic>;

    apiUrl = configJson['api_url'] as String;
  }
}